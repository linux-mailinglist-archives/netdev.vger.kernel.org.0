Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3004F4262
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387202AbiDEOaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344234AbiDEOX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:23:28 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0796D391;
        Tue,  5 Apr 2022 06:09:49 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id ku13-20020a17090b218d00b001ca8fcd3adeso2477529pjb.2;
        Tue, 05 Apr 2022 06:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4cKz3KRjDOO2S0baJ4Rm0rVmX1qZ76ju8M71vBlKzDo=;
        b=SZ9r8aGPwF54xnRjnJKpPEDi+2MQiSd2Ui8dzkZ8chfm8UiXsQpSkE1toj36LqSuD3
         6J9abQ5RciNLzBg317AUb7Tp/RCt1tVkrEXoeV29QvwNgaIC0j4RyhSuSV0slaZnM3Rq
         +NIcLNM89n5idM0BsiBjogwIfNse3QgduYrjKD0kSDxuE4Q4zIcqam84KGYAAzyPQFwL
         Vs/RYF3GYGfeoxIOkz14uobI/fExQ0dAGbAyihqq1835MxYPR3RZwP5CKfUD4+NAQRn1
         B/r5QjJgX0TG87ouNCRvcDS+4jfdU1oFgqmfV7vZ/LV7MYfhSxVq0JJ2tsFJA3gdB3JU
         JK5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4cKz3KRjDOO2S0baJ4Rm0rVmX1qZ76ju8M71vBlKzDo=;
        b=ao5o/oxMIR1KK7BEzNZ7F31ymM04Yh+pK1dKUDIeSixltw6b7JY0yPWELCiPOkcibg
         vdBm5EtXzacL/m7rIM0+w+jaAqqKDYMrgdrX+rTzeFX0eI4EaOHT/+qlWOwQVgsuCzxx
         QHCz0HVnKh4AzRxdTJ6aAzTSVhhF36MR6Vwnhntp0HQzHfYu4g7mK3SVZj70jVaLBdtV
         KwpobgK7FmjIyG/EcZ1ZsRjWGSBT+Xx/pdAUwcEH9XJn+k5WrZ/3cKPO853Zjzwt2bgK
         TbLuDOK6PaJC0S40koZn32FMLnppmf2X0XeeET8qdngmnuxcE3QTcTyDMRGmyGAPvQpe
         iSeQ==
X-Gm-Message-State: AOAM53148Cva/mgM6uvQKkUPGQGjiMb0z6Xkj7HzTqKaUFTZA8S1BiDc
        rglXwP9uxfOLnei3Cap4rc8=
X-Google-Smtp-Source: ABdhPJysjLwmtyZKeGiRxf/NT/W7hkXMGA+xvAPPrn4tKOug5mZGyzbjlCUdDz+ouiLnbIeUL6rftA==
X-Received: by 2002:a17:90b:1d82:b0:1c7:1d3:f4 with SMTP id pf2-20020a17090b1d8200b001c701d300f4mr4048551pjb.223.1649164189427;
        Tue, 05 Apr 2022 06:09:49 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:49 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 25/27] bpf: bpftool: Set LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK for legacy libbpf
Date:   Tue,  5 Apr 2022 13:08:56 +0000
Message-Id: <20220405130858.12165-26-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220405130858.12165-1-laoar.shao@gmail.com>
References: <20220405130858.12165-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK has already been set for non legacy
libbpf, let's also set it for legacy libbpf then we can avoid using the
deprecatred RLIMIT_MEMLOCK.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/bpf/bpftool/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 451cefc2d0da..9062ef2b8767 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -508,6 +508,8 @@ int main(int argc, char **argv)
 		 * mode for loading generated skeleton.
 		 */
 		libbpf_set_strict_mode(LIBBPF_STRICT_ALL & ~LIBBPF_STRICT_MAP_DEFINITIONS);
+	} else {
+		libbpf_set_strict_mode(LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK);
 	}
 
 	argc -= optind;
-- 
2.17.1

