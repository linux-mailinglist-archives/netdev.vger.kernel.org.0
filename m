Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9BD60368B
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 01:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiJRXNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 19:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiJRXNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 19:13:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB22DAC40
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:13:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48189B8218A
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA512C433D7;
        Tue, 18 Oct 2022 23:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666134794;
        bh=4iDCEjVSUVFGsd3s/6D2iBqrlWwZyVR6ly+UUHFphP8=;
        h=From:To:Cc:Subject:Date:From;
        b=qjPfI63sKRMpipG7VW8YaQzmcWYzcjxWIjUNyVZGpcxQX5Lfbk40D87RYZJfjJzJe
         qrRzjL7F0Ja7NxUxSS4saBVkrrm0i019zwfh+JL6jc7A8tvC+cyluW/zV9eblhetoD
         VDyKqR1lGKzZSAyy9Bt/T+XkQ0U0//1MietKDb/yPMzxxOJ+mhS23MAlOv+hcL4KeH
         lORErgOPdYCc4X1nJqskghiGT1xQqpDef/nvCcExqnxT8r8Q09Z5rTYScEyS8TtqqF
         m4a7twn+Ou8sDwF8MpLcueIQtf0sz2VYCJ82pQ/kPuxMMoFbctajUwxdnFdh897k/O
         gDRCHP349VXcQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] genetlink: fix kdoc warnings
Date:   Tue, 18 Oct 2022 16:13:10 -0700
Message-Id: <20221018231310.1040482-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Address a bunch of kdoc warnings:

include/net/genetlink.h:81: warning: Function parameter or member 'module' not described in 'genl_family'
include/net/genetlink.h:243: warning: expecting prototype for struct genl_info. Prototype was for struct genl_dumpit_info instead
include/net/genetlink.h:419: warning: Function parameter or member 'net' not described in 'genlmsg_unicast'
include/net/genetlink.h:438: warning: expecting prototype for gennlmsg_data(). Prototype was for genlmsg_data() instead
include/net/genetlink.h:244: warning: Function parameter or member 'op' not described in 'genl_dumpit_info'

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/genetlink.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 8f780170e2f8..3d08e67b3cfc 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -37,6 +37,7 @@ struct genl_info;
  *	do additional, common, filtering and return an error
  * @post_doit: called after an operation's doit callback, it may
  *	undo operations done by pre_doit, for example release locks
+ * @module: pointer to the owning module (set to THIS_MODULE)
  * @mcgrps: multicast groups used by this family
  * @n_mcgrps: number of multicast groups
  * @resv_start_op: first operation for which reserved fields of the header
@@ -173,9 +174,9 @@ struct genl_ops {
 };
 
 /**
- * struct genl_info - info that is available during dumpit op call
+ * struct genl_dumpit_info - info that is available during dumpit op call
  * @family: generic netlink family - for internal genl code usage
- * @ops: generic netlink ops - for internal genl code usage
+ * @op: generic netlink ops - for internal genl code usage
  * @attrs: netlink attributes
  */
 struct genl_dumpit_info {
@@ -354,6 +355,7 @@ int genlmsg_multicast_allns(const struct genl_family *family,
 
 /**
  * genlmsg_unicast - unicast a netlink message
+ * @net: network namespace to look up @portid in
  * @skb: netlink message as socket buffer
  * @portid: netlink portid of the destination socket
  */
@@ -373,7 +375,7 @@ static inline int genlmsg_reply(struct sk_buff *skb, struct genl_info *info)
 }
 
 /**
- * gennlmsg_data - head of message payload
+ * genlmsg_data - head of message payload
  * @gnlh: genetlink message header
  */
 static inline void *genlmsg_data(const struct genlmsghdr *gnlh)
-- 
2.37.3

