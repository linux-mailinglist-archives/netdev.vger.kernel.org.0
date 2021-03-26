Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4A134AF76
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 20:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhCZToF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 15:44:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48786 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhCZTnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 15:43:55 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lPsN2-0007Gl-AF; Fri, 26 Mar 2021 19:43:48 +0000
From:   Colin King <colin.king@canonical.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: remove redundant assignment of variable id
Date:   Fri, 26 Mar 2021 19:43:48 +0000
Message-Id: <20210326194348.623782-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable id is being assigned a value that is never
read, the assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 kernel/bpf/btf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 369faeddf1df..b22fb29347c0 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -789,7 +789,6 @@ static const struct btf_type *btf_type_skip_qualifiers(const struct btf *btf,
 
 	while (btf_type_is_modifier(t) &&
 	       BTF_INFO_KIND(t->info) != BTF_KIND_TYPEDEF) {
-		id = t->type;
 		t = btf_type_by_id(btf, t->type);
 	}
 
-- 
2.30.2

