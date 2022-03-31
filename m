Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375274ED6AE
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbiCaJVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233737AbiCaJVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:21:41 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E3C56403;
        Thu, 31 Mar 2022 02:19:53 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id lr4so38323370ejb.11;
        Thu, 31 Mar 2022 02:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iQOjmSQ0eSV4gchEgt9UF9f4o2nvBpEPhFZj2fYWH0A=;
        b=IeDtWHb984QHc6qRLsggB/1agGXhyC1vdu3aavQJ3fFsSV38P/k6WYRaq6D53BcHxc
         T8jDAKCJWLGHqFBMFWQBPh5Zvi4ILYj+mFeFeVkTF2R4KCCyu36oCEnFvPJhZuQtJL+N
         bIvCIOiHCotd/JCLcaL2CU7goAnRHRQU/fLgrFw9k/Oh/sHpbzF6R3muRlDwigqB7Qgt
         MTuV1Zg1p19bRd1CM+iKEzuwC7RBlJ0DYR6TdT2FuPtjR1oF+k4AopDAI7+cYxq+yl7b
         bQNMifXhXAIyXnhcbMqK34xuShvRS+1lEzw2dUDE16R4pLaksYiuUrWjtj0WTsdT4KYE
         SbJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iQOjmSQ0eSV4gchEgt9UF9f4o2nvBpEPhFZj2fYWH0A=;
        b=fCFFNl9x60/jLjJUKy2TX3ZHDyOYJ+mWWFkT7xMgQmf6RKWT140ODuAZbp5c9JeWXf
         k5JIwZP3yFynu3+8p6msAnfbGuecgFgZku+GOR0uCgpfRxdh8QSz4W7r3db8tAPxJeJy
         wFi8NnLOM8NIL46kVJNLnt9BPUskWVxaP4TrAjkdHXEy6whPcn3/NEO9sAnZN2gC0Wjq
         pUT15S74p2NoPZW0WNsKOcfOc1on6sLlwQyjTxzxvPiorkgyqBCir8wRKlBmwLId+T95
         r/UMdundZp2Z7E+lBfv4/jlKBo2vccVPJKd2SZC0uhfyEOofp8TYdHPLT4N1fbTz3rEo
         U4/g==
X-Gm-Message-State: AOAM530msE2VVKWspc9weoI9NsdnTDt+clx5Gh66rUqmIqtyRJX5mEox
        ZUL4vx7u9N6Lrswm53aycKs=
X-Google-Smtp-Source: ABdhPJwM/fAUCcxTW3KrXej5NfDPi+P05fTYZhWtVcR/WjHJngYjvLAho28Vse3uRfBVAkDcQwhPCw==
X-Received: by 2002:a17:907:168a:b0:6da:9177:9fdd with SMTP id hc10-20020a170907168a00b006da91779fddmr4077383ejc.757.1648718392451;
        Thu, 31 Mar 2022 02:19:52 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id v26-20020a50955a000000b00418ebdb07ddsm11159642eda.56.2022.03.31.02.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 02:19:52 -0700 (PDT)
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
Subject: [PATCH v2] bpf: replace usage of supported with dedicated list iterator variable
Date:   Thu, 31 Mar 2022 11:19:29 +0200
Message-Id: <20220331091929.647057-1-jakobkoschel@gmail.com>
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

This removes the need to use the found variable (existed & supported)
and simply checking if the variable was set, can determine if the
break/goto was hit.

[1] https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---

v1->v2:
- add correct [1] reference (Yonghong Song)

 kernel/bpf/bpf_iter.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 110029ede71e..dea920b3b840 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -330,35 +330,34 @@ static void cache_btf_id(struct bpf_iter_target_info *tinfo,
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
@@ -499,12 +498,11 @@ bool bpf_link_is_iter(struct bpf_link *link)
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

@@ -530,14 +528,14 @@ int bpf_iter_link_attach(const union bpf_attr *attr, bpfptr_t uattr,

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

base-commit: d888c83fcec75194a8a48ccd283953bdba7b2550
--
2.25.1

