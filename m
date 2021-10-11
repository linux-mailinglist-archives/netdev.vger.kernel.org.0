Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE894293E9
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 17:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbhJKP6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 11:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236025AbhJKP6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 11:58:43 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C39C061570
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:56:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s66-20020a252c45000000b005ba35261459so23199024ybs.7
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jlfiTEUka2/blqQcciOdP3p7gXV+iiMGA7a+lcQ/zbM=;
        b=cGMeVNAzLFMNSTs8MUxjyGbu+EFvpVJhQVCM3uLH809vai3ficSFhG5lvu1Fe+KZug
         c1MopTN2Oioi+NEdbb4brDkl3iPWrWNQcCJtIUG2MPCQkN2K1XaNyttm/oHyCi1ZD/XQ
         8Dy6Zt6/qRYqUGo3Xx0JwHYD305Ne4C5yjkY36nCX5FZOAzQibCdybP++bNQYEDENdUB
         C9lImtUQmE5rb0sNxtjJxzErQ6GybMO5l2EN8edrtdMF6BcE03NGMupjGsDw5Rkog5fr
         50kiWKGAKmZvpJJomegAskbv8K20DdOyxDnrnHTCJDnA67pmAKArOwgr1JFHGnTBAqM1
         e5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jlfiTEUka2/blqQcciOdP3p7gXV+iiMGA7a+lcQ/zbM=;
        b=Y4jaHBreSEbEWisjfnZoh/ONvXEKLFm29IIpNAlP+0hHdxswNS5zb0i6zE0nQbPfYE
         Ly2IXZDgaABVsfMHsjh7AOrjr7lW+9M23Xv5kG0uMAz+CLSpCNQ1VpoKfk51JhSeaQvv
         qaKwxqVE/TTefdLLmTInoHOH60ofV87WpNh9kpcbXCZvyjBfRxOh6sjS5owvf1OFb0wJ
         mPEs0fomGCaWXR16JfPnDc1Y2dpZ85m31ywMczrwYRrXps5cObCvG8KL9uGvQcrZ7QPx
         iP9u+NhB9tBHxRVGmW5QoY/AOVIyEv1vOMnju7C3ZRICC2Tpez6LZcphls5yJLLP412P
         ps+w==
X-Gm-Message-State: AOAM530VR/EXf046fVwy+zEiX1WzYAtQfP+PF7tOdSvqAo5pKc8/Z3UK
        K18MHgkLURUyoI4fxhUY04ORyEk9uGDit1fzQo2+hIoXrxA+0wSk9h7JBN+E1dkzRkV6TlVlvAf
        +Xxco2aFvaO8wGGn64db4tQVd7MneJfplgau6/boaRiGFRQhfXhtmcA==
X-Google-Smtp-Source: ABdhPJxpNlx1870Q/fwmADu7wk+BQM29Pkn8qvHYznh6+NmQqPCEQjG5xiybeWETbERd6JiHcWWlNg0=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:8bf5:656e:8f83:7b2d])
 (user=sdf job=sendgmr) by 2002:a25:7309:: with SMTP id o9mr22521213ybc.42.1633967801951;
 Mon, 11 Oct 2021 08:56:41 -0700 (PDT)
Date:   Mon, 11 Oct 2021 08:56:35 -0700
In-Reply-To: <20211011155636.2666408-1-sdf@google.com>
Message-Id: <20211011155636.2666408-2-sdf@google.com>
Mime-Version: 1.0
References: <20211011155636.2666408-1-sdf@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH bpf-next 2/3] bpftool: don't append / to the progtype
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

