Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A606126F3FB
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbgIRDKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbgIRCCu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D86F23770;
        Fri, 18 Sep 2020 02:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394567;
        bh=/ScECHuMMx+Z6V1XFj2xOe3d/sxOd6b+cZM2xBTfqao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qoBk/1lef7KeHqb8pxz+BLrgkt3GR+OSzNkgDlgn+2mNfi79gwZq4viyK3VfVMNLr
         3fLf/0pAA6mWZTycCGjNPPYEGe0G3VulTcwmFn7UVQ1Z0Tp+rfDyW3jns0Ulv5n/7k
         le29IUCxS9R7n38ITCXlw3TYtZHnuH9cABrWghKs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 079/330] vcc_seq_next should increase position index
Date:   Thu, 17 Sep 2020 21:56:59 -0400
Message-Id: <20200918020110.2063155-79-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 8bf7092021f283944f0c5f4c364853201c45c611 ]

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/proc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/atm/proc.c b/net/atm/proc.c
index d79221fd4dae2..c318967073139 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -134,8 +134,7 @@ static void vcc_seq_stop(struct seq_file *seq, void *v)
 static void *vcc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	v = vcc_walk(seq, 1);
-	if (v)
-		(*pos)++;
+	(*pos)++;
 	return v;
 }
 
-- 
2.25.1

