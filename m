Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7DF4D18CC
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241614AbiCHNMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346781AbiCHNMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:12:17 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3017F48884;
        Tue,  8 Mar 2022 05:11:15 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id mv5-20020a17090b198500b001bf2a039831so2148694pjb.5;
        Tue, 08 Mar 2022 05:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XZ5/JOgeRQIev0F6iGnllvaw2Xpd0Vkw5vT4hctm9LE=;
        b=MTzlU8i+d5WWYrMR/nWgGDPhI0Em4aOWdkZfDtdNOw00rdj00RUcnaXU6V2LyUUEZs
         uytZymJYyJKFq5tGJQgjprgAXFsu5QRkBF6OWo/euJ16VdTVnjZkGDnyqLTR0lyrZSBw
         h5Arb4qABcrL/BaNajXPaUMfzI0qkN+KfnpEmZf2rvVifTSkWAL04xDLWGsrz8lc8yW8
         ObYqT2lgYVecoJi2s3+Ein2cLceICEFBpFBM5B0xC/pXtTx84q823bHG2PZMUn7MZC5s
         pETcwE5r9uCYDYvA6rwRvvrqxfKH9ePkVqlQ/SyzRW5YaU2C80F/hj29fFRayl00Txkb
         H72Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XZ5/JOgeRQIev0F6iGnllvaw2Xpd0Vkw5vT4hctm9LE=;
        b=fu1jrF2LbS1rJY0sQim6E9nf/b8B+aLoxDwlQsLRoCiFVriZVwNMOYH8QtgiJ0yQ+j
         Yie3ONS9wQ9NWbwa83ykaikOdoNmi/P1CKvyGroVgtWgOkcyJ1CmVxiASb/Nc6XZi4At
         +Yjg1aQkDj9Nso4V7QQmB9uee5VXR2wXvgLk6haOFAvAaB6RiHtBHVRj8Nc5JmeOiApw
         RjxqMkr+rV0dewUAu4Ckw2I4frjiiUQkyrUj413+zq4U2YnKXzzHzOme0LmL3NLanVdL
         vYa8vDijvr/HEeVDhVHe0wRVvRIITc+INAcP2UePnKmka+xYdsVoZPgrDmQNpbIiwf2e
         dbfQ==
X-Gm-Message-State: AOAM5304b2nGV872V3hPdfGcvmtZSyGks0U2eUQdRAQXBlZ9LJxUvtiY
        LmziJNShjJicQMybGlBcwqc=
X-Google-Smtp-Source: ABdhPJzP43L1ogB3N4skFJGzR1Jg8A1fcMH9gZ1HrLSlGaD86J9Ijh+wfhfk/iUZ4nBV95hjZmnXAA==
X-Received: by 2002:a17:90a:6508:b0:1be:d59c:1f10 with SMTP id i8-20020a17090a650800b001bed59c1f10mr4518554pjj.229.1646745074658;
        Tue, 08 Mar 2022 05:11:14 -0800 (PST)
Received: from vultr.guest ([149.248.19.67])
        by smtp.gmail.com with ESMTPSA id s20-20020a056a00179400b004f709998d13sm7378598pfg.10.2022.03.08.05.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:11:14 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        akpm@linux-foundation.org, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com,
        guro@fb.com
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>,
        Joanne Koong <joannekoong@fb.com>
Subject: [PATCH RFC 1/9] bpftool: fix print error when show bpf man
Date:   Tue,  8 Mar 2022 13:10:48 +0000
Message-Id: <20220308131056.6732-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220308131056.6732-1-laoar.shao@gmail.com>
References: <20220308131056.6732-1-laoar.shao@gmail.com>
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

If there is no btf_id or frozen, it will not show the pids,
but the pids doesn't depends on any one of them.

Fixes: 9330986c0300 ("bpf: Add bloom filter map implementation")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Joanne Koong <joannekoong@fb.com>
---
 tools/bpf/bpftool/map.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index e746642..0bba337 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -620,17 +620,14 @@ static int show_map_close_plain(int fd, struct bpf_map_info *info)
 					    u32_as_hash_field(info->id))
 			printf("\n\tpinned %s", (char *)entry->value);
 	}
-	printf("\n");
 
 	if (frozen_str) {
 		frozen = atoi(frozen_str);
 		free(frozen_str);
 	}
 
-	if (!info->btf_id && !frozen)
-		return 0;
-
-	printf("\t");
+	if (info->btf_id || frozen)
+		printf("\n\t");
 
 	if (info->btf_id)
 		printf("btf_id %d", info->btf_id);
-- 
1.8.3.1

