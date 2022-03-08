Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89284D18D0
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbiCHNMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347025AbiCHNMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:12:17 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C21548890;
        Tue,  8 Mar 2022 05:11:16 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id k92so8021295pjh.5;
        Tue, 08 Mar 2022 05:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7qC9ZJnuyUGolXYQcUY/Tf83TQ1ETOj72VlDmZ6p6Ws=;
        b=bbq65S48n9rZTrLzmf2FQhuouyrA3lYX5oOGHOk8bQ0lmGrPYhUO3lK998y9GjF9bu
         vCvJg7DISbQI18AnpD6LwKkqHVPzuAawwcKFxpQBY7Jci46AOIY27abot/Y7c0pUmleb
         sSIvOx+rD9KQ+NLDELdCNfBxcG6Qadgfg55KmuFg9UK6S/oZbf5oExnqnphyWYxQVIoS
         jR5tuUxa1B1WNKBTpwq5YAq2N3gU0+gQWQfDZEXc0n5mrrV/O6xvBRth6wLThNOjgQ1E
         /S8xUomQXGSIxjE/689sHKrC/06BzAG4JA7+MSvXUqThXLw7VNa0D6TLyxTKTWgMWzJF
         1huQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7qC9ZJnuyUGolXYQcUY/Tf83TQ1ETOj72VlDmZ6p6Ws=;
        b=Xbp6oA13NMU/HfSz0h5hdRm9X0Nq5D0W5gSPOSlTrW6Lpu6yYqNXWDpamc68NlGRoY
         glKmuxG56vyuvEpq+vuKZ5srFczcDAo2hKYJpmTsfh9ekrfiwN0QGPMbcYcnQAM7dsOr
         Rj9NYiVV9RY9Q4ET0edG2INg6WftUye8/WGgH0AWnCzNOU/5je4DwCL08+rkSJdZ+E8X
         cqvsKfD/YNXLoo9xqDas+1rDiKfCmhUefoP5kl1xxz93cggU9GHNPPRQuyjBlFvmayq6
         xX410S9TqAlpPYL8TcRTiTmL87afoSkeTw+kxvKwhnROonN/Wb7QzwkYJLYPLRY2e9Lg
         krOQ==
X-Gm-Message-State: AOAM530QQqKSEUnH03sI2gMxHPslKI5eFE1TQ736DLVqKuAOPWsQfohu
        U4gLSJdASl3Gu4VRgZC6ys8=
X-Google-Smtp-Source: ABdhPJxRT96hUCFt+OLq3AvoUmcskuUoVsObUNWdtEx8FWULrshXYxLLY3NlZtrK0hmbq5kssZXcTg==
X-Received: by 2002:a17:90b:1809:b0:1bf:7e9:bdf5 with SMTP id lw9-20020a17090b180900b001bf07e9bdf5mr4642772pjb.52.1646745076176;
        Tue, 08 Mar 2022 05:11:16 -0800 (PST)
Received: from vultr.guest ([149.248.19.67])
        by smtp.gmail.com with ESMTPSA id s20-20020a056a00179400b004f709998d13sm7378598pfg.10.2022.03.08.05.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:11:15 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        akpm@linux-foundation.org, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com,
        guro@fb.com
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH RFC 2/9] bpftool: show memcg info of bpf map
Date:   Tue,  8 Mar 2022 13:10:49 +0000
Message-Id: <20220308131056.6732-3-laoar.shao@gmail.com>
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

bpf map can be charged to a memcg, so we'd better show the memcg info to
do better bpf memory management. This patch adds a new field
"memcg_state" to show whether a bpf map is charged to a memcg and
whether the memcg is offlined. Currently it has three values,
   0 : not charged
  -1 : the charged memcg is offline
   1 : the charged memcg is online

For instance,

$ bpftool map show
2: array  name iterator.rodata  flags 0x480
        key 4B  value 98B  max_entries 1  memlock 4096B
        btf_id 240  frozen
        memcg_state 0
3: hash  name calico_failsafe  flags 0x1
        key 4B  value 1B  max_entries 65535  memlock 524288B
        memcg_state 1
6: lru_hash  name access_record  flags 0x0
        key 8B  value 24B  max_entries 102400  memlock 3276800B
        btf_id 256
        memcg_state -1

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/syscall.c           | 11 +++++++++++
 tools/bpf/bpftool/map.c        |  2 ++
 tools/include/uapi/linux/bpf.h |  1 +
 4 files changed, 15 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4eebea8..a448b06 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5864,6 +5864,7 @@ struct bpf_map_info {
 	__u32 btf_value_type_id;
 	__u32 :32;	/* alignment pad */
 	__u64 map_extra;
+	__s8  memcg_state;
 } __attribute__((aligned(8)));
 
 struct bpf_btf_info {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index db402eb..3b50fcb 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3939,6 +3939,17 @@ static int bpf_map_get_info_by_fd(struct file *file,
 	}
 	info.btf_vmlinux_value_type_id = map->btf_vmlinux_value_type_id;
 
+#ifdef CONFIG_MEMCG_KMEM
+	if (map->memcg) {
+		struct mem_cgroup *memcg = map->memcg;
+
+		if (memcg == root_mem_cgroup)
+			info.memcg_state = 0;
+		else
+			info.memcg_state = memcg->kmemcg_id < 0 ? -1 : 1;
+	}
+#endif
+
 	if (bpf_map_is_dev_bound(map)) {
 		err = bpf_map_offload_info_fill(&info, map);
 		if (err)
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 0bba337..fe8322f 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -550,6 +550,7 @@ static int show_map_close_json(int fd, struct bpf_map_info *info)
 		jsonw_end_array(json_wtr);
 	}
 
+	jsonw_int_field(json_wtr, "memcg_state", info->memcg_state);
 	emit_obj_refs_json(refs_table, info->id, json_wtr);
 
 	jsonw_end_object(json_wtr);
@@ -635,6 +636,7 @@ static int show_map_close_plain(int fd, struct bpf_map_info *info)
 	if (frozen)
 		printf("%sfrozen", info->btf_id ? "  " : "");
 
+	printf("\n\tmemcg_state %d", info->memcg_state);
 	emit_obj_refs_plain(refs_table, info->id, "\n\tpids ");
 
 	printf("\n");
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4eebea8..41e65b3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5864,6 +5864,7 @@ struct bpf_map_info {
 	__u32 btf_value_type_id;
 	__u32 :32;	/* alignment pad */
 	__u64 map_extra;
+	__s8 memcg_state;
 } __attribute__((aligned(8)));
 
 struct bpf_btf_info {
-- 
1.8.3.1

