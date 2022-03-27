Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296624E8A4F
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 23:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236823AbiC0VwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 17:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiC0VwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 17:52:16 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A3C3FDB9;
        Sun, 27 Mar 2022 14:50:37 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w25so14904252edi.11;
        Sun, 27 Mar 2022 14:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TTcZIvDgvkwENo79A4lHb3jXHV4Zy2dwVb7gB1jhZgM=;
        b=PwZ04pOlLIm1Unxlgvy6MVL9adW1Z7zyxbaLYtEAkn/rACy38Q/F3IGEVHeHxbv11I
         bSAXt8swt1eGdn7pOX/LyuFX0YjjfJQKWw7e61wrmvrSlNepKB97f3y2UxmX9LoOoH6R
         sjXn+MASRXsUpp4XSOgZbak+Zy2hTLyAJNs44Ps7qlDHpb2xik9Nl4M3xtU/HvDcpzOJ
         eXWOdFGBQPPdN2UZg0eKPOsICXXxZqxToUAbYODdWpRUcuRmSiKQ159hvfsKDjiLGiJ3
         76b3k1t2igKPztUXP+6K3mldLcomSpuZ4nWIS8Kqp4Wlwxn6NnHmHGnzbq0QkNtNamvJ
         Y+GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TTcZIvDgvkwENo79A4lHb3jXHV4Zy2dwVb7gB1jhZgM=;
        b=bVO/DErpgKnn/VfEXdv12iD5NhF7wyT52Nlpd5i9dHP94GQ2xPtFv++UxL8CG7567U
         46EV7E88YK4fNhK7QVjI/E2lQLqxC1bujolHr+RZlR7UXrJ1avRkaMRFv/H9MfFl2hh1
         u98fJkzP5QAesXv9MaFCNKojKgvb4dNtO04+xZDINxqSF7ctNO4K3WLG1UJqHUDky9GB
         6Ug/cLBBLu5mvI0XL8xKd+k4cvbw8VVCnQ6Fqv45brHq1Kdss1375UxEnkWQoDIX6IJb
         E4qpBmLqVNsbhtm/SoSeUTsVnh612tu3NYOQP0tO/WE0TZqG3BqV3CtboKKQ5l3WngrC
         v++w==
X-Gm-Message-State: AOAM533dfrFvu7aPxohbS7qWlZVzOidp90FFgv/nU14XtZyS+4ncfZe1
        cafBW/ea4klL5ab4on7pjEs=
X-Google-Smtp-Source: ABdhPJzzbzALNEpY7ocNy8qACRP+3a93A8WMHmF6JkOH3WG/eLxTIPaHlI1M2v1LBjxLWK4uHktwRQ==
X-Received: by 2002:a05:6402:d7:b0:413:673:ba2f with SMTP id i23-20020a05640200d700b004130673ba2fmr12609981edu.29.1648417835982;
        Sun, 27 Mar 2022 14:50:35 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id ge13-20020a170907908d00b006e09a005d73sm3530726ejb.31.2022.03.27.14.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 14:50:35 -0700 (PDT)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jakobkoschel@gmail.com>
Subject: [PATCH] bpf: replace usage of found with dedicated list iterator variable
Date:   Sun, 27 Mar 2022 23:50:10 +0200
Message-Id: <20220327215010.2193515-1-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
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

To move the list iterator variable into the list_for_each_entry_*()
macro in the future it should be avoided to use the list iterator
variable after the loop body.

To *never* use the list iterator variable after the loop it was
concluded to use a separate iterator variable instead of a
found boolean [1].

This removes the need to use a found variable (supported & existed)
and simply checking if the variable was set, can determine if the
break/goto was hit.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 kernel/bpf/bpf_iter.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index b7aef5b3416d..0b6d5e726ba3 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -329,35 +329,34 @@ static void cache_btf_id(struct bpf_iter_target_info *tinfo,
 bool bpf_iter_prog_supported(struct bpf_prog *prog)
 {
 	const char *attach_fname = prog->aux->attach_func_name;
+	struct bpf_iter_target_info *tinfo = NULL, *iter;
 	u32 prog_btf_id = prog->aux->attach_btf_id;
 	const char *prefix = BPF_ITER_FUNC_PREFIX;
-	struct bpf_iter_target_info *tinfo;
 	int prefix_len = strlen(prefix);
-	bool supported = false;

 	if (strncmp(attach_fname, prefix, prefix_len))
 		return false;

 	mutex_lock(&targets_mutex);
-	list_for_each_entry(tinfo, &targets, list) {
-		if (tinfo->btf_id && tinfo->btf_id == prog_btf_id) {
-			supported = true;
+	list_for_each_entry(iter, &targets, list) {
+		if (iter->btf_id && iter->btf_id == prog_btf_id) {
+			tinfo = iter;
 			break;
 		}
-		if (!strcmp(attach_fname + prefix_len, tinfo->reg_info->target)) {
-			cache_btf_id(tinfo, prog);
-			supported = true;
+		if (!strcmp(attach_fname + prefix_len, iter->reg_info->target)) {
+			cache_btf_id(iter, prog);
+			tinfo = iter;
 			break;
 		}
 	}
 	mutex_unlock(&targets_mutex);

-	if (supported) {
+	if (tinfo) {
 		prog->aux->ctx_arg_info_size = tinfo->reg_info->ctx_arg_info_size;
 		prog->aux->ctx_arg_info = tinfo->reg_info->ctx_arg_info;
 	}

-	return supported;
+	return tinfo != NULL;
 }

 const struct bpf_func_proto *
@@ -498,12 +497,11 @@ bool bpf_link_is_iter(struct bpf_link *link)
 int bpf_iter_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
 			 struct bpf_prog *prog)
 {
+	struct bpf_iter_target_info *tinfo = NULL, *iter;
 	struct bpf_link_primer link_primer;
-	struct bpf_iter_target_info *tinfo;
 	union bpf_iter_link_info linfo;
 	struct bpf_iter_link *link;
 	u32 prog_btf_id, linfo_len;
-	bool existed = false;
 	bpfptr_t ulinfo;
 	int err;

@@ -529,14 +527,14 @@ int bpf_iter_link_attach(const union bpf_attr *attr, bpfptr_t uattr,

 	prog_btf_id = prog->aux->attach_btf_id;
 	mutex_lock(&targets_mutex);
-	list_for_each_entry(tinfo, &targets, list) {
-		if (tinfo->btf_id == prog_btf_id) {
-			existed = true;
+	list_for_each_entry(iter, &targets, list) {
+		if (iter->btf_id == prog_btf_id) {
+			tinfo = iter;
 			break;
 		}
 	}
 	mutex_unlock(&targets_mutex);
-	if (!existed)
+	if (!tinfo)
 		return -ENOENT;

 	link = kzalloc(sizeof(*link), GFP_USER | __GFP_NOWARN);

base-commit: b47d5a4f6b8d42f8a8fbe891b36215e4fddc53be
--
2.25.1

