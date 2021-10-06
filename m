Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E3F4234F4
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 02:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbhJFAbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 20:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237007AbhJFAa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 20:30:57 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166C3C061749;
        Tue,  5 Oct 2021 17:29:06 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q7-20020a17090a2e0700b001a01027dd88so1377348pjd.1;
        Tue, 05 Oct 2021 17:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4UqEpcscfQ03cFhb1sYSCPHOjFjHmnSxOjNPBp/HO14=;
        b=nLGNBEpbdEPYvDdjcEUMHc4XF6NO+jjUxmm9/UNVX8BNZHTKe2+RZLJq6o0fhJJZG8
         Qy7JpEkP8W9jC9QgQIYhwOvTWH1dbfrym9IqCJi8lg6hseN8h5prHp1R6nuqqGkSOPyX
         oMtN+wa5qQnNu3Q1DfWSNG6ojeahI8AIqyDaRMmHMbkeiBLisf3GO6oifyRBj/b8hLXe
         gIhyrIJzIxfQ0D0uVkTk1tafmZWEFzc5vCy77mK2dFoYlQTV+8Nf1Th8rSPa44JZ2egF
         koX7M9dOkWlU50HiBoZDzVw9LYQdMwJiDdx5qBqHpy3dw/ztRfqhqAtF42uFQSxcoj4Q
         JWyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4UqEpcscfQ03cFhb1sYSCPHOjFjHmnSxOjNPBp/HO14=;
        b=vQ0+zxEO/begRlVsNrQF8UKECToHOHvcdsdlem1lnWuDIcEbkYokF5CCRGOJqMzrcG
         1L44NPDK+7x/1kq8GIZN7UZCBOOTLu4beEKQbacXmiNh0jkM08YVM6bypUyXD8ES/EUM
         eq7m1rCZd+E6lamfq5vSXC/EiSG2z7bZ1tsDsLpHAUPm3MM1blU1zRoJohHKebwb9ST6
         yyr9nz2XE8K1Sbfque2D3N8QEJSLZ14QMxAF5aHR4GfjGathv+68BUw4Dyzl3tqBjd7K
         YhaTgYQA8llImjEOSHXjqus0dV9+CWYFAtSf+/xY1YadAc2XokXIfbI83OQlcnkSuuuL
         25iQ==
X-Gm-Message-State: AOAM531B+hv8P76AmRCO+LnD0E5emd2MsKZbdMKeoLkrdCJTp8eShryY
        gqhbQotMpeOXMk4DAnKoUn3bqW62WIg=
X-Google-Smtp-Source: ABdhPJyFBuvexMWs9holY9ZycW2fFqRSZNvZw9SwY190utqvjgFW4qT5Jy8bhxXNy4AHCEOjT3qWLg==
X-Received: by 2002:a17:902:7b85:b0:13d:cdc4:9531 with SMTP id w5-20020a1709027b8500b0013dcdc49531mr8092338pll.27.1633480145484;
        Tue, 05 Oct 2021 17:29:05 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id l24sm19042418pgt.77.2021.10.05.17.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 17:29:05 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 3/6] libbpf: Ensure that module BTF fd is never 0
Date:   Wed,  6 Oct 2021 05:58:50 +0530
Message-Id: <20211006002853.308945-4-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006002853.308945-1-memxor@gmail.com>
References: <20211006002853.308945-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1329; h=from:subject; bh=6vaY63fTOrdOcgwuh5tqf+Er7r1dLYsnaLf5oJmNO6I=; b=owEBbAKT/ZANAwAIAUzgyIZIvxHKAcsmYgBhXOxQAOiKhIBZO783+I7/of0v1cYzKQbbUT3GlwHG HZyFuA+JAjIEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVzsUAAKCRBM4MiGSL8RysHND/ i245URMaBhGwGSRuGz6YvkUsZAhmmyiJTBQuEpcXHpdTI3KN0AgUEYXQLEVJIEjQAVd4+2VGa4Q7i9 jJUoY1i2EydpYhBrKq1gz8xjg1BfdwJq6BEDAUkfSlIocmTMjfwOqJ1giL969Qo3XLQhQ0/tQFi2s5 X1uBQVO2TP6S/vXJCa/v2OKX/aIehNqr8I0yDDpYfWNu6D5zO9FGghpYIaCk0qt+iVtbCsKvJd7c+I bIWHXR1dtUpE+NiBCu83TQC4PL9LGEvaXwKVwIu1rXFXhQ1ZZomp9rjzWOHh4VLBemOWi06cUKI52v rq/D0WgyKVd8uiA9OQw83bJgu5BzUoGQMpPubRRtEdtDo9vKD+EwlbJTS4ErrHfxS1x0It7qqUiQHv CAmWcPVD0XC9tA/zOQ7kAfLZhUaSYpoOa46UG55IZHmlxJej6kh7G0MLRrBrhFQMWHZ+fwLQ7s5kjs G7b94QOWU5ecfIihmxu5UjXUvAseBO7ah/1kO7X2lAVNW7frm+exmAsNbWon//CAwoPv1TmZRrarH1 rhT2pMt/tsDUYN7zNtU7/otcr+rPG+tVfK7o2iQ/zB9GZ0ND7yLOER7r2hJu781CAvwoFZLJSnRpgr eZvo6WbjtThNCxkds1ES39j3WMqXUamoMbAsQqE9OU0L2QGP/YpDwM8klQ
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the code assumes in various places that BTF fd for modules is
never 0, if we end up getting fd as 0, obtain a new fd > 0. Even though
fd 0 being free for allocation is usually an application error, it is
still possible that we end up getting fd 0 if the application explicitly
closes its stdin. Deal with this by getting a new fd using dup and
closing fd 0.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/libbpf.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index d286dec73b5f..3e5e460fe63e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4975,6 +4975,20 @@ static int load_module_btfs(struct bpf_object *obj)
 			pr_warn("failed to get BTF object #%d FD: %d\n", id, err);
 			return err;
 		}
+		/* Make sure module BTF fd is never 0, as kernel depends on it
+		 * being > 0 to distinguish between vmlinux and module BTFs,
+		 * e.g. for BPF_PSEUDO_BTF_ID ld_imm64 insns (ksyms).
+		 */
+		if (!fd) {
+			fd = dup(0);
+			if (fd < 0) {
+				err = -errno;
+				pr_warn("failed to dup BTF object #%d FD 0 to FD > 0: %d\n", id, err);
+				close(0);
+				return err;
+			}
+			close(0);
+		}
 
 		len = sizeof(info);
 		memset(&info, 0, sizeof(info));
-- 
2.33.0

