Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47DDF13E493
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389647AbgAPRJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:09:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389638AbgAPRJQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE4732081E;
        Thu, 16 Jan 2020 17:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194555;
        bh=Ku1iZk0I5wbaIZOihCA+JS9rrQZhPd9PqqMuIKY749I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TmZmZbCs+CIPiLnZxbuJaOjcOR0C0bpbrryTg9FP0hzinmeLwFCmbhOBKZdgxrBOa
         HyyWmIom7C9ePtZOasnlS31mX0MMnGIZnsNmFOEK1Pic+gO/TOhh5EZ4SuhKLiG6Bg
         FKGwCQ2Q3LZprKJz90fX4ww667fgxuHnSuW2OUOo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Roman Gushchin <guro@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 437/671] tools: bpftool: use correct argument in cgroup errors
Date:   Thu, 16 Jan 2020 12:01:15 -0500
Message-Id: <20200116170509.12787-174-sashal@kernel.org>
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

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 6c6874f401e5a0caab3b6a0663169e1fb5e930bb ]

cgroup code tries to use argv[0] as the cgroup path,
but if it fails uses argv[1] to report errors.

Fixes: 5ccda64d38cc ("bpftool: implement cgroup bpf operations")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
Acked-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/cgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index ee7a9765c6b3..adbcd84818f7 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -164,7 +164,7 @@ static int do_show(int argc, char **argv)
 
 	cgroup_fd = open(argv[0], O_RDONLY);
 	if (cgroup_fd < 0) {
-		p_err("can't open cgroup %s", argv[1]);
+		p_err("can't open cgroup %s", argv[0]);
 		goto exit;
 	}
 
@@ -345,7 +345,7 @@ static int do_attach(int argc, char **argv)
 
 	cgroup_fd = open(argv[0], O_RDONLY);
 	if (cgroup_fd < 0) {
-		p_err("can't open cgroup %s", argv[1]);
+		p_err("can't open cgroup %s", argv[0]);
 		goto exit;
 	}
 
@@ -403,7 +403,7 @@ static int do_detach(int argc, char **argv)
 
 	cgroup_fd = open(argv[0], O_RDONLY);
 	if (cgroup_fd < 0) {
-		p_err("can't open cgroup %s", argv[1]);
+		p_err("can't open cgroup %s", argv[0]);
 		goto exit;
 	}
 
-- 
2.20.1

