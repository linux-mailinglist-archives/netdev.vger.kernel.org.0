Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D19313F335
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390388AbgAPRMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:12:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:54110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729464AbgAPRME (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:12:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 765CB24697;
        Thu, 16 Jan 2020 17:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194723;
        bh=sfpKkZFrh5g6jwVycqE/JJD+LVoEXASUDwo3JwoTaeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F4eAo4DEa6gUIpzoWju3qxy3c2sInn8N+ichoQ6Oln9SN1EpJ5citd/k9orGnrsy0
         EfC+M0V9Ef1DEpWtUF41jFG5lD7FipyGSUWnx5scMohyYsGhpPVHXu5fkKjhwUEu4I
         oceOu1E0DP6foJi+XTNVI4ilLxvZyltegHwVPEfY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 558/671] bpf: fix BTF limits
Date:   Thu, 16 Jan 2020 12:03:16 -0500
Message-Id: <20200116170509.12787-295-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit a0791f0df7d212c245761538b17a9ea93607b667 ]

vmlinux BTF has more than 64k types.
Its string section is also at the offset larger than 64k.
Adjust both limits to make in-kernel BTF verifier successfully parse in-kernel BTF.

Fixes: 69b693f0aefa ("bpf: btf: Introduce BPF Type Format (BTF)")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/btf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/btf.h b/include/uapi/linux/btf.h
index 972265f32871..1e2662ff0529 100644
--- a/include/uapi/linux/btf.h
+++ b/include/uapi/linux/btf.h
@@ -22,9 +22,9 @@ struct btf_header {
 };
 
 /* Max # of type identifier */
-#define BTF_MAX_TYPE	0x0000ffff
+#define BTF_MAX_TYPE	0x000fffff
 /* Max offset into the string section */
-#define BTF_MAX_NAME_OFFSET	0x0000ffff
+#define BTF_MAX_NAME_OFFSET	0x00ffffff
 /* Max # of struct/union/enum members or func args */
 #define BTF_MAX_VLEN	0xffff
 
-- 
2.20.1

