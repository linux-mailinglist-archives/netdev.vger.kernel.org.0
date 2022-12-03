Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F54964150E
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 09:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiLCIrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 03:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbiLCIrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 03:47:24 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5EE7DA73;
        Sat,  3 Dec 2022 00:47:23 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id v8so9342815edi.3;
        Sat, 03 Dec 2022 00:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0A0l8Aq8F2C+mYk2zfzbUY+wD5in9yH+VedMvZeY0AI=;
        b=Jt+lja152ZCYCikhJLgbHCZMFMkmPfuHTmf3JV84Tqm90sF7gdmgYG//y0M1qfKEwe
         W/UncV18TOlsufdT4kl0OYeqykMMH8RJl3fI33Nj1nSH0mbyXqESOlfs6hC23JM/JWkp
         b5irnwn0DkEuaU4X9S0FPElFQc0ZYYANDk0FFggA6gzHpbvuGHG/U3rzBMhkuD8hKqGJ
         yfmCACqMSOVKADUbDR3SC+1AMqpIwlG+boXogyS3jVW3KUel+0cAUp3qXXPbk+uDdtnJ
         KqiSs72adycDPvgMMpYPxwYJ5cI44jNisW9tf3I4t4I6ramRRzNpdnhau8pRVrD1TVYW
         ZROg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0A0l8Aq8F2C+mYk2zfzbUY+wD5in9yH+VedMvZeY0AI=;
        b=X9Dhb0vj6pFMJk1pThmvxrGkEkzu6oanAxj0C4qyzFMBeclbIWcRhG5+CamnngD9zH
         lOGaQaxbECfi0wG74S9yLCGUYJmKF/yNVNwjPhHm7RQQmLk+zjtQ6foOjth35Va1StYH
         cn0ccKXMXHqYjUQB4cwYzXMkiCpPSbROTZhiV8oIa249zZeE1UYhbVmQ3Li6EKaJ57W6
         Tfco01pZKKevNaprD1QQZcvyQP2JeUQh2KcHxCkucgYSbTn/aV9Mw2a1EPLBkRtnGhLZ
         OXR8sSeENNOjoOsS8iuDI8J/uef0V+sjYC0See79z+eictoRviKnYWF1z8QqCWyk0tPm
         3TiA==
X-Gm-Message-State: ANoB5pko5He7zpmGIlKW8yA9/D5OqzeFqzbSiiowBtassI8Ra9c3ksGs
        FCsjGbTB2F7a7V+S8mu9MwQ=
X-Google-Smtp-Source: AA0mqf4tVriSypImtNHZqJag1GEVm0xB+wvjZnmKCMbWMtMjAMyTu0ITFwzmRV1wMTEZMui/zLo2Dg==
X-Received: by 2002:aa7:cf01:0:b0:46b:d6d1:faaa with SMTP id a1-20020aa7cf01000000b0046bd6d1faaamr11016239edy.326.1670057241515;
        Sat, 03 Dec 2022 00:47:21 -0800 (PST)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id q26-20020a170906389a00b007bdc2de90e6sm3964200ejd.42.2022.12.03.00.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 00:47:21 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org,
        liuhangbin@gmail.com, lixiaoyan@google.com, jtoppins@redhat.com,
        kuniyu@amazon.co.jp
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH bpf-next,v6 3/4] tools: add IFLA_XFRM_COLLECT_METADATA to uapi/linux/if_link.h
Date:   Sat,  3 Dec 2022 10:46:58 +0200
Message-Id: <20221203084659.1837829-4-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221203084659.1837829-1-eyal.birger@gmail.com>
References: <20221203084659.1837829-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Needed for XFRM metadata tests.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 tools/include/uapi/linux/if_link.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 0242f31e339c..901d98b865a1 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -673,6 +673,7 @@ enum {
 	IFLA_XFRM_UNSPEC,
 	IFLA_XFRM_LINK,
 	IFLA_XFRM_IF_ID,
+	IFLA_XFRM_COLLECT_METADATA,
 	__IFLA_XFRM_MAX
 };
 
-- 
2.34.1

