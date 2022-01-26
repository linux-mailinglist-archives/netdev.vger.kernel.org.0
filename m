Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F61349D21A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 19:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbiAZS4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 13:56:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48422 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiAZS4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 13:56:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18792B81FBD
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 18:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCA0C340E3;
        Wed, 26 Jan 2022 18:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643223360;
        bh=12UJsUxEatuCtPNILbLe8+CTil6V/2ysSk38ET3sfz8=;
        h=From:To:Cc:Subject:Date:From;
        b=uDeLxEbNxYCvj5Ua3yGO57NH0pNuKvf8j0cWmjAl601+s7ywlvk5j+ilFe/Ol04ul
         BuDjE2Bw2olMk+l2Z5nghQ7XoImDTNFi1ppN4MOcuhJsSGVAYdc9vDdH6SAae3/pdl
         eNDjxWX64M8dlRD2Ib0a7DvvwWEsGnd+w0xb5dfIy9wyx5xujdgcIpMPOEAVtTlYTG
         8YKaqsozzr6ezZ8UL7o/MQlt/9mpBB85tudSDqoSmQLoO6MirXTaP4XKJpd0LVZJBK
         k0u2fCze8v8SNlmNDbKR7OZmHEQfRbDx9R9/tj5OZHKYtJ5m6u1iwKfK4wMZwB2HqI
         5E1H8jbhiijyw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     anthony.l.nguyen@intel.com
Cc:     shiraz.saleem@intel.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] i40e: remove enum i40e_client_state
Date:   Wed, 26 Jan 2022 10:55:44 -0800
Message-Id: <20220126185544.2787111-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not used.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/net/intel/i40e_client.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/linux/net/intel/i40e_client.h b/include/linux/net/intel/i40e_client.h
index 6b3267b49755..ed42bd5f639f 100644
--- a/include/linux/net/intel/i40e_client.h
+++ b/include/linux/net/intel/i40e_client.h
@@ -26,11 +26,6 @@ struct i40e_client_version {
 	u8 rsvd;
 };
 
-enum i40e_client_state {
-	__I40E_CLIENT_NULL,
-	__I40E_CLIENT_REGISTERED
-};
-
 enum i40e_client_instance_state {
 	__I40E_CLIENT_INSTANCE_NONE,
 	__I40E_CLIENT_INSTANCE_OPENED,
@@ -190,11 +185,6 @@ struct i40e_client {
 	const struct i40e_client_ops *ops; /* client ops provided by the client */
 };
 
-static inline bool i40e_client_is_registered(struct i40e_client *client)
-{
-	return test_bit(__I40E_CLIENT_REGISTERED, &client->state);
-}
-
 void i40e_client_device_register(struct i40e_info *ldev, struct i40e_client *client);
 void i40e_client_device_unregister(struct i40e_info *ldev);
 
-- 
2.34.1

