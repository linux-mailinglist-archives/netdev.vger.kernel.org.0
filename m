Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38FD6B879B
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 02:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjCNBeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 21:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjCNBen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 21:34:43 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29D08C5AF
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 18:34:41 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7A9F55C019F;
        Mon, 13 Mar 2023 21:34:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 13 Mar 2023 21:34:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1678757679; x=1678844079; bh=NPfi6uwB5w
        UG2/qiQ5Qyoc3/VWKB/2bkjfOwPQZzKlE=; b=cGWRh/tInEJRwwUTNBjZd2vBgA
        54bUgqk/VmCbwG7QR3+ACXLGCDtvVa7A6dqKjV2olx4vP8EAnEP5h2ubyzvvkzAx
        KM9RPru/Mqyxk2OKo7iM2TH9tRElR4RY6PLFNr2oZAoQupBdFiJiHU1aLmIrDMcn
        T0er18Q/tvp7l2MPsWfWb1THUWwddZRh6AEO0RlcYKykMx6W2tfZr/u7pkab6AqP
        UkigPcs+cNmkePTxVaqiySmlM8iqGu6amVgfjxBCUEcbjx5QB90BiZKZIc/JtgNO
        osra/gsrGHtmPJ1nelZIWTmTXyh5vNfNzq0DmoSNxkuz74VuRKM8hUuodGDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1678757679; x=1678844079; bh=NPfi6uwB5wUG2
        /qiQ5Qyoc3/VWKB/2bkjfOwPQZzKlE=; b=lRl88iFO6DpbAL73tYojowi/M780N
        tIIHE2R54YQg1sSN2T3a1INocSHaFrC1rce9Nal7plGV5vVy8slhZlKrvo/f8ZEG
        JvbEBnwW1Rs/eIOS2FphswEZUu6mJkxkduPlM0ajUlKPuFXadk3xf3ZbTwfOKnQt
        9z7L0TmL9I16y9giNVuYN2p0on0SVufFjZ1ba0syRwIyeZ1Z+ht1slb61buATNYW
        OHiSToN5UsFAaJbMRB6lxcvOACXAbUPwNbTx5pHB/uQibGnn4SDMuN6YvQ3suFBP
        4H4R9vHJ3yJVj4IpqCRlUBMieJ0A4A5qXMcIB4kismIkaDeur6AJ+ZxCA==
X-ME-Sender: <xms:L88PZIZsqM1WQr-fI-pVgA9yasrYjRB1-rC-cIlNTj-b686QhkPSwg>
    <xme:L88PZDa1tGnVb2dmWN5FTwGct3IIzu83np-vqVrO4AUKKKMiEdrU6-eB_xOzApMPZ
    z10tqQfsJcKF4LYYsw>
X-ME-Received: <xmr:L88PZC8E6DXH0yj3diETozFuD6TRO2KDQ4gs3-GnNoW-WUiuIpgmNXTWIoTswfJMyrk0IeU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvhedgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    evufffkffoggfgsedtkeertdertddtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhi
    shhhkhhinhcuoehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrg
    htthgvrhhnpeevjeetfeeftefhffelvefgteelieehveehgeeltdettedvtdekffelgeeg
    iedtveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hvlhgrughimhhirhesnhhikhhishhhkhhinhdrphif
X-ME-Proxy: <xmx:L88PZCpuw0mvAbBemVZg80e-c4MC_AMBnoWDtaBeOxXup6CMSSJ7RQ>
    <xmx:L88PZDpoKzQA-p-5lK4xunaFwoz4MCKndagJMzFNjeX4kSLnc7Ur8g>
    <xmx:L88PZAQZfhiQFPiW37nHvoXB72ik3aXXVhFHtc3yRjVKtqzyI6z3TQ>
    <xmx:L88PZPL4LY-ET5rUBY6zBYd0eA1eVY8J2-QagOIk05kCs614NJC2eQ>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Mar 2023 21:34:35 -0400 (EDT)
From:   Vladimir Nikishkin <vladimir@nikishkin.pw>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
        gnault@redhat.com, razor@blackwall.org,
        Vladimir Nikishkin <vladimir@nikishkin.pw>
Subject: [PATCH net-next v3] Make vxlan try to send a packet normally if local bypass fails.
Date:   Tue, 14 Mar 2023 09:34:23 +0800
Message-Id: <20230314013423.12029-1-vladimir@nikishkin.pw>
X-Mailer: git-send-email 2.35.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vxlan_core, if an fdb entry is pointing to a local
address with some port, the system tries to get the packet to
deliver the packet to the vxlan directly, bypassing the network
stack.

This patch makes it still try canonical delivery, if there is no
linux kernel vxlan listening on this port. This will be useful
for the cases when there is some userspace daemon expecting
vxlan packets for post-processing, or some other implementation
of vxlan.

Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
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
Fastmail.

