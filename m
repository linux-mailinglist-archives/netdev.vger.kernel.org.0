Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFF242A92E
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhJLQRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhJLQRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 12:17:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3849C061745
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 09:15:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z130-20020a256588000000b005b6b4594129so27852100ybb.15
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 09:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jlfiTEUka2/blqQcciOdP3p7gXV+iiMGA7a+lcQ/zbM=;
        b=IANQUCztSu0fD1+kqjILQ95Vw6oZpZ/P1o9fs7kkGN6BJ0XfDwEDavy1ZWWvmoi693
         WmVP4/OWpChEvhl0vdDGQyrXeLSYxL8hHT+Kczo90VOpvZURzPA3nxz9uoNGOnSVxAdO
         1xDN0ziNkW/lueu6N79FvKwds3f8AVOTZdNpwRebmb3YW4Mk68UdpFRen2ym9gjwEfSt
         YP7vKordN6q3/F0Qdu9OgYja6TFfUJY0UoEb8RotlpMTNLZlVOZ/mfWmKdQET2wUc3iL
         zA4lMPI31lalrDwYNjST/XdoHpqKsPcSay9Xk6y71FCu/zrPgrh3M6vI/CDwbzv07vXq
         iDDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jlfiTEUka2/blqQcciOdP3p7gXV+iiMGA7a+lcQ/zbM=;
        b=zR2aCfxK9cuNUG2ob4oFeUvKfq48ocQnBdsNnTzOBtSceTwyoymNHFU/nNSDzgknPL
         ZEbiah70Or3a3pyWOdBQ2tQOl+gfcx9vwkF9DvbV47JdV7p/7I+eAEcpxwByZZplXWvt
         NZdFVdaugG0YPEHMgpmChcFCT41zngiUfCqNE1oyEP4eMMPVCyHtnQ36PJr+S37hwtoj
         OHn1KKz3Ir8KiBmU9rL4AtKVcRyssXnR/Y8r+WbMC5ZKv/t1QoqWI8hW4MYCqmNwqryZ
         Oh9vsCDTJ5/v1tOna5zCsGJx3HywwvdEm/2MIfrGltAXlhVJ09iY7SSQQPGwgNXHMw3y
         Eomw==
X-Gm-Message-State: AOAM532pbg+7dFw4hRqfa4rflDij+zLbdYaxJM6ZB9b9trB6YRkMmf6A
        1xuAso32Kgr5dqEQJKLPLda5pUhH67WyxjIW+6Jm3S9Q4aIfJa4EWH+DNrhBUwxxq2oxq0jzIng
        22DG4LOPFwyXkVO1wtmv1Eyh1/e7FZcNc6+OkaZ7xQW+/nBM+A3emkA==
X-Google-Smtp-Source: ABdhPJz+kjT7uSEq8SgR2Cvdpyd8woeyUs/fZknba1ewWywixRh3FyHAJ2oUsGXYuY3TlofzwSxAd0s=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:4060:335c:dc47:9fc2])
 (user=sdf job=sendgmr) by 2002:a25:b309:: with SMTP id l9mr28165653ybj.188.1634055351928;
 Tue, 12 Oct 2021 09:15:51 -0700 (PDT)
Date:   Tue, 12 Oct 2021 09:15:43 -0700
In-Reply-To: <20211012161544.660286-1-sdf@google.com>
Message-Id: <20211012161544.660286-3-sdf@google.com>
Mime-Version: 1.0
References: <20211012161544.660286-1-sdf@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH bpf-next v2 2/3] bpftool: don't append / to the progtype
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise, attaching with bpftool doesn't work with strict section names.

Also, switch to libbpf strict mode to use the latest conventions
(note, I don't think we have any cli api guarantees?).

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/bpftool/main.c |  4 ++++
 tools/bpf/bpftool/prog.c | 15 +--------------
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 02eaaf065f65..8223bac1e401 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -409,6 +409,10 @@ int main(int argc, char **argv)
 	block_mount = false;
 	bin_name = argv[0];
 
+	ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+	if (ret)
+		p_err("failed to enable libbpf strict mode: %d", ret);
+
 	hash_init(prog_table.table);
 	hash_init(map_table.table);
 	hash_init(link_table.table);
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 277d51c4c5d9..17505dc1243e 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1396,8 +1396,6 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 
 	while (argc) {
 		if (is_prefix(*argv, "type")) {
-			char *type;
-
 			NEXT_ARG();
 
 			if (common_prog_type != BPF_PROG_TYPE_UNSPEC) {
@@ -1407,19 +1405,8 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 			if (!REQ_ARGS(1))
 				goto err_free_reuse_maps;
 
-			/* Put a '/' at the end of type to appease libbpf */
-			type = malloc(strlen(*argv) + 2);
-			if (!type) {
-				p_err("mem alloc failed");
-				goto err_free_reuse_maps;
-			}
-			*type = 0;
-			strcat(type, *argv);
-			strcat(type, "/");
-
-			err = get_prog_type_by_name(type, &common_prog_type,
+			err = get_prog_type_by_name(*argv, &common_prog_type,
 						    &expected_attach_type);
-			free(type);
 			if (err < 0)
 				goto err_free_reuse_maps;
 
-- 
2.33.0.882.g93a45727a2-goog

