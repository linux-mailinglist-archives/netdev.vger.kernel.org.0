Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3C659A6D3
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 22:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351556AbiHSUC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 16:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351558AbiHSUCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 16:02:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ECFE42F7
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 13:02:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA5C86162D
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 20:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2687FC433D7;
        Fri, 19 Aug 2022 20:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660939344;
        bh=pF2fCZvdjORPHZyyTeF0268/iTNYNV7ft+X54kgOEkQ=;
        h=From:To:Cc:Subject:Date:From;
        b=oW2imW2WHgxKyZ/G0nrzoBrf+xpFSLRXDSEbbGO2kOO5BxZa03GFXDGzt2Q2MZoJ4
         8KPnBRyxMgsWOhBnpgMkDUjAIdsIDj7gTsoY7/5DYvziEIqmqglE5kF8EP3GpD59qs
         mWI95tnG3RgWuPlZ4hgIrPTJzWUafRBnkhsjjVmOA+Sok9bHFwGWs4wP9ExL9LwYl0
         EPMog+KFkjW+4GsLeRLmb09XaXkaXSmArjmUHsHF59wPypfsy0+W3XjWN1IYFaKSCL
         3fOOECBheKSsQRbHkG/fiNU3Ol+Vvhmbuk21FNKs6y0yBcBHWIIlZpwTtIKYdx8ggK
         Q8Br6ropph1kg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 1/2] net: improve and fix netlink kdoc
Date:   Fri, 19 Aug 2022 13:02:20 -0700
Message-Id: <20220819200221.422801-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subsequent patch will render the kdoc from
include/uapi/linux/netlink.h into Documentation.
We need to fix the warnings. While at it move
the comments on struct nlmsghdr to a proper
kdoc comment.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/netlink.h | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index 855dffb4c1c3..9b5bd4ba6ed4 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -41,12 +41,20 @@ struct sockaddr_nl {
        	__u32		nl_groups;	/* multicast groups mask */
 };
 
+/**
+ * struct nlmsghdr - fixed format metadata header of Netlink messages
+ * @nlmsg_len:   Length of message including header
+ * @nlmsg_type:  Message content type
+ * @nlmsg_flags: Additional flags
+ * @nlmsg_seq:   Sequence number
+ * @nlmsg_pid:   Sending process port ID
+ */
 struct nlmsghdr {
-	__u32		nlmsg_len;	/* Length of message including header */
-	__u16		nlmsg_type;	/* Message content */
-	__u16		nlmsg_flags;	/* Additional flags */
-	__u32		nlmsg_seq;	/* Sequence number */
-	__u32		nlmsg_pid;	/* Sending process port ID */
+	__u32		nlmsg_len;
+	__u16		nlmsg_type;
+	__u16		nlmsg_flags;
+	__u32		nlmsg_seq;
+	__u32		nlmsg_pid;
 };
 
 /* Flags values */
@@ -337,6 +345,9 @@ enum netlink_attribute_type {
  *	bitfield32 type (U32)
  * @NL_POLICY_TYPE_ATTR_MASK: mask of valid bits for unsigned integers (U64)
  * @NL_POLICY_TYPE_ATTR_PAD: pad attribute for 64-bit alignment
+ *
+ * @__NL_POLICY_TYPE_ATTR_MAX: number of attributes
+ * @NL_POLICY_TYPE_ATTR_MAX: highest attribute number
  */
 enum netlink_policy_type_attr {
 	NL_POLICY_TYPE_ATTR_UNSPEC,
-- 
2.37.2

