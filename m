Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021F26B6376
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 07:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjCLGTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 01:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCLGTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 01:19:01 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE6B2E0DD
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 22:18:59 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 4345D5C008D
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 01:18:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 12 Mar 2023 01:18:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
        cc:content-type:content-type:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm2; t=1678601939; x=1678688339; bh=FiNll7pNqCedshBGZzCnQzktK
        TmqDFHb0xrX7+bSwbo=; b=aKAQj145zWmcoVFU5Ycr4Z6kCljTWw/nRyfnE+FoI
        UD7nfJb0+jFTLf97mLc70rp26Ri5erNJrSMTMb/6QCUc1H/Ge1g+oQBeqXR+8m9k
        I2DaqoaW/VDw7icPaT0Nrqft7KI4x9NpxEwYLWhgylKy9/GHHcdsZODnNKwpkqeO
        k18m/LGDP11LOi+cszDxpj1dwXVb5plZt7FH7VIrCAssRD4fdNZzKfMvCj+8ztZ+
        1QfgnMK2+5/3e4uBXdjilBAVUviLSh0eOaIs7WUp1L8Y0rWDQt0YzJdhmYiym+4e
        dXIjCuFnpSZjOkoOAisi1xWsMbBuKe7dPCY1y5ml0Wqkw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1678601939; x=1678688339; bh=FiNll7pNqCedshBGZzCnQzktKTmqDFHb0xr
        X7+bSwbo=; b=P4OpCuREQpF1skNzF6ux5QB0bAeHfVWzPBvZ/MCwyqoPYQVnr3D
        XdUHDJULAsFhVr7uHfZLaZoLGr6+K86t66zras5gL1gaqfvphW8HB5dUVQN9rLnu
        U22Rx/kK6akR/0pWUfP0ghGXG23U+4T00VuIGEaTB0ZJ6YGW4diaS6bfWAYS3/ME
        I9MeCF4/lH0ijJ+YNtdE1JOMcTk2OcpNfbThKxo+tkaqSvnKGjJd/jYTJo5RL3Ik
        ZV1cnWerFDTSDu2Ov0xIphQ12TlBNeZRYFvxsnd2EiKQHuv1g83MSMISdgfnB2AO
        HuosT3p4k214mxL4lzRCacC6YirywSjXVwQ==
X-ME-Sender: <xms:024NZNcm1J2VFLPnU9wW5y4kyNxSkIIGmNMzu6mYrGmVPMJcyKvGww>
    <xme:024NZLPPY1Z5P3bs2hFFELBDf4yDNNjfFB80zNNAK_35anJt7DVddxH3fGAfb-7Sp
    AIm8Ds9E6VR37D6Nrg>
X-ME-Received: <xmr:024NZGiZfh-3_1p_F02eR466aOQqPusmmA0fvRKebm6VmzDooOvkU3docxA4mOeo78Hy5OVzFKE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvuddgledvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdludehmdenucfjughrpegfhf
    fvufffkfggtgesthdtredttdertdenucfhrhhomhepgghlrgguihhmihhrucfpihhkihhs
    hhhkihhnuceovhhlrgguihhmihhrsehnihhkihhshhhkihhnrdhpfieqnecuggftrfgrth
    htvghrnhepjeelveeugfffffeffffgkedthfeflefgheefieehtdekjeejhfduffeffeef
    ieefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepvh
    hlrgguihhmihhrsehnihhkihhshhhkihhnrdhpfi
X-ME-Proxy: <xmx:024NZG8tfgfFej27swQ-YjawrnqhX8uxHrnnB3BjCzjbm4c2s-azaQ>
    <xmx:024NZJvWIu4u1cXK0GJnh3OBkT8x4mcERoN42oVqTk3XqogQlfT06g>
    <xmx:024NZFE-b3NdfIXsTEYWCozBHzLLXQH3mDtm4SPBL7s680CAzBdVnw>
    <xmx:024NZO4lgcJszh75qy2BXOLnOhxyjlIj3Uy7mXPtz4quZsKUyXe1WQ>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <netdev@vger.kernel.org>; Sun, 12 Mar 2023 01:18:57 -0500 (EST)
User-agent: mu4e 1.8.6; emacs 29.0.50
From:   Vladimir Nikishkin <vladimir@nikishkin.pw>
To:     netdev@vger.kernel.org
Subject: [PATCH net-next v1 1/1] vxlan: Make vxlan try without a local
 bypass, if bypass fails.
Date:   Sun, 12 Mar 2023 14:07:05 +0800
Message-ID: <871qluxzyy.fsf@laptop.lockywolf.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Nikishkin <vladimir@nikishkin.pw>
Date: Sun, 19 Feb 2023 21:24:49 +0800
Subject: [PATCH net-next v1 1/1] vxlan: Make vxlan try without a local bypass, if bypass fails.
Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
From 8650e2e742b7a2cd6c35d1c034084b9f68e0f112 Mon Sep 17 00:00:00 2001
In vxlan_core, if an fdb entry is pointing to a local
address with some port, the system tries to get the packet to
deliver the packet to the vxlan directly, bypassing the network
stack.

This patch makes it still try canonical delivery, if there is no
linux kernel vxlan listening on this port. This will be useful
for the cases when there is some userspace daemon expecting
vxlan packets for post-processing, or some other implementation
of vxlan.

---
 drivers/net/vxlan/vxlan_core.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index b1b179effe2a..0379902da766 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2422,19 +2422,13 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 	if (rt_flags & RTCF_LOCAL &&
 	    !(rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))) {
 		struct vxlan_dev *dst_vxlan;
-
-		dst_release(dst);
 		dst_vxlan = vxlan_find_vni(vxlan->net, dst_ifindex, vni,
 					   daddr->sa.sa_family, dst_port,
 					   vxlan->cfg.flags);
 		if (!dst_vxlan) {
-			dev->stats.tx_errors++;
-			vxlan_vnifilter_count(vxlan, vni, NULL,
-					      VXLAN_VNI_STATS_TX_ERRORS, 0);
-			kfree_skb(skb);
-
-			return -ENOENT;
+			return 0;
 		}
+		dst_release(dst);
 		vxlan_encap_bypass(skb, vxlan, dst_vxlan, vni, true);
 		return 1;
 	}
-- 
2.35.7


-- 
Your sincerely,
Vladimir Nikishkin (MiEr, lockywolf)
(Laptop)
--
Fastmail.

