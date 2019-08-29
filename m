Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB0CA24DC
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbfH2SP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:15:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729484AbfH2SPy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:15:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B891B2189D;
        Thu, 29 Aug 2019 18:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102553;
        bh=KgDQ6Jda5LEDY8kDUn5LFXutTM2b8PlpVRDCMS0ev7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=09Hrn0I200NaAq29wcWmzAlcHzXWMll3psuRmC+teAZELS0965EFUgfcYtibw7Soz
         GBi9CSHV+eWyT9io/vNPkDoRTFT7FNjaSICp64LJIdRHt7lwvta2DFwBjM8oFGFNFu
         xhti3HaaT2cJHtrxYnWlplEJXDc5vDeUiWub28Aw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/45] tools: bpftool: fix error message (prog -> object)
Date:   Thu, 29 Aug 2019 14:15:04 -0400
Message-Id: <20190829181547.8280-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181547.8280-1-sashal@kernel.org>
References: <20190829181547.8280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit b3e78adcbf991a4e8b2ebb23c9889e968ec76c5f ]

Change an error message to work for any object being
pinned not just programs.

Fixes: 71bb428fe2c1 ("tools: bpf: add bpftool")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index fcaf00621102f..be7aebff0c1e5 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -238,7 +238,7 @@ int do_pin_any(int argc, char **argv, int (*get_fd_by_id)(__u32))
 
 	fd = get_fd_by_id(id);
 	if (fd < 0) {
-		p_err("can't get prog by id (%u): %s", id, strerror(errno));
+		p_err("can't open object by id (%u): %s", id, strerror(errno));
 		return -1;
 	}
 
-- 
2.20.1

