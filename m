Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DE543F17D
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 23:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhJ1VVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 17:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231151AbhJ1VVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 17:21:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 338136023E;
        Thu, 28 Oct 2021 21:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635455955;
        bh=l/7ChPkJuupHkc80swZhn7yP2P5oM3wxJ8vtzg3ljJI=;
        h=From:To:Cc:Subject:Date:From;
        b=RLwOfARmA771ngCq1FOakcaLfquhw/s6VuWyQRk+UTrU+jT6CtNeJjRFOqVazX4Fr
         NIWIswVevChX0pnq8ZzKcyfF856/f51TIKeHqVrLmNRk3AaLVBiT72ZW94BEiKMSCN
         YQBrYgi12xnfYt3eGy9rmVnYZN38ydi0Ec7/NV6aM9dWfOflBnXF2chSmIEP4QuaiL
         Sx1LTjPtQTADwHFQDzf7J5EPfrxvyTeZFNsh+wHvC/8PPa2B7Hv9lDBuP4MKc/XalI
         y04099CSb2Gf1peDYbVO+Y5HJr9MrHGgLEuqFD8GjjKAQ+ucLIfXiS1OsREP5wUCs3
         8Nn0CUz5i/Vwg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, idosch@idosch.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] devlink: make all symbols GPL-only
Date:   Thu, 28 Oct 2021 14:19:13 -0700
Message-Id: <20211028211913.22862-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink_alloc() and devlink_register() are both GPL.
A non-GPL module won't get far, so for consistency
we can make all symbols GPL without risking any real
life breakage.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/devlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0de679c4313c..94783eb81c99 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -102,7 +102,7 @@ struct devlink_dpipe_header devlink_dpipe_header_ethernet = {
 	.fields_count = ARRAY_SIZE(devlink_dpipe_fields_ethernet),
 	.global = true,
 };
-EXPORT_SYMBOL(devlink_dpipe_header_ethernet);
+EXPORT_SYMBOL_GPL(devlink_dpipe_header_ethernet);
 
 static struct devlink_dpipe_field devlink_dpipe_fields_ipv4[] = {
 	{
@@ -119,7 +119,7 @@ struct devlink_dpipe_header devlink_dpipe_header_ipv4 = {
 	.fields_count = ARRAY_SIZE(devlink_dpipe_fields_ipv4),
 	.global = true,
 };
-EXPORT_SYMBOL(devlink_dpipe_header_ipv4);
+EXPORT_SYMBOL_GPL(devlink_dpipe_header_ipv4);
 
 static struct devlink_dpipe_field devlink_dpipe_fields_ipv6[] = {
 	{
@@ -136,7 +136,7 @@ struct devlink_dpipe_header devlink_dpipe_header_ipv6 = {
 	.fields_count = ARRAY_SIZE(devlink_dpipe_fields_ipv6),
 	.global = true,
 };
-EXPORT_SYMBOL(devlink_dpipe_header_ipv6);
+EXPORT_SYMBOL_GPL(devlink_dpipe_header_ipv6);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(devlink_hwmsg);
 EXPORT_TRACEPOINT_SYMBOL_GPL(devlink_hwerr);
@@ -3365,7 +3365,7 @@ void devlink_dpipe_entry_clear(struct devlink_dpipe_entry *entry)
 		kfree(value[value_index].mask);
 	}
 }
-EXPORT_SYMBOL(devlink_dpipe_entry_clear);
+EXPORT_SYMBOL_GPL(devlink_dpipe_entry_clear);
 
 static int devlink_dpipe_entries_fill(struct genl_info *info,
 				      enum devlink_command cmd, int flags,
-- 
2.31.1

