Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1DB678F60
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 05:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbjAXEj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 23:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbjAXEj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 23:39:26 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADFC30B1A
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 20:39:26 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 141so10592874pgc.0
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 20:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qth+m+QqGWxa6ejWDP+asO5qvuiiNmuGk9SYTp9o8fg=;
        b=1lKKJ5GlJElAqYaZqiACcFiLIJRt3bxsMn/0bpuBHgK3rb1tWJBWisJ2KnsvAtuyES
         AomzmzTwAu+zA5xdSYgoOhrRUav+SYUQsSQcceyqahqckz6Ng0BOLN+q8T6LlcqxF7hr
         7N4/8fwvRlgQlkKux5IukXNZiowUavCAkT0pGxBnpacVWTv7g99AJ3cG377zT2HCcQCV
         yRwkB7amUr/q/HPrak6mz2eyNr29NSa+X9U8dxbauKKAqgPc/6TXXB9qAuPH7pUlKRky
         iDAMnpkgmQy9jmT5GiZlEfl5+BdxrSsbgNB19nU/n9Y8KiLJ4NozW+FgJO+UiK2C4Xrd
         L0+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qth+m+QqGWxa6ejWDP+asO5qvuiiNmuGk9SYTp9o8fg=;
        b=nAHGIjUYhUm2p6HXNC47D4e/NFKYuDXs7Q2Gr+Hf/8B2aOiwVqIP4hrP//IfB4SMMR
         39HTUjvoE9L3yhGbokKy3hZjht6t+J/vRA5QkFWdyEX8H+rlFefKEQZKS67oFr+7NKY5
         zeY9fMFuytHl5ZfDxt0JOeZda1lAJ+Rsc/8dYppiAY1PRhBGyhmoJGOb0RbBf0soVQ0u
         AYob0Mt6nN8I29Ld0g6VGcEZrpRoiWmRmuErQF3KaUMsTBNulMzKCDMPnkSpXTu8XdbW
         0e2IpkzrUPM+35SFM53wzTZntKSoSEHreKjEjkbg1+qcjH5pCvFrM4wFY40Wp97Cd6a3
         wRxQ==
X-Gm-Message-State: AFqh2kpvv1T/denZium8LAxJ0Iut5kD8TpC8qfM4TM5q+XgN8d0ipUwC
        WiW4mYYvWMkN4gpuoDbwGVi+Hw==
X-Google-Smtp-Source: AMrXdXsLLP6eHtR36AvPy1ebq6ivCLVzOgdUmrJIJhIdk0x3oZSlvx/SGzSnTLDGwmEoFZyYoWT5jQ==
X-Received: by 2002:aa7:8f09:0:b0:587:364f:17f5 with SMTP id x9-20020aa78f09000000b00587364f17f5mr47311121pfr.7.1674535165628;
        Mon, 23 Jan 2023 20:39:25 -0800 (PST)
Received: from alarm.flets-east.jp ([2400:4050:a840:1e00:4457:c267:5e09:481b])
        by smtp.gmail.com with ESMTPSA id u13-20020a62790d000000b0058bcb7b437bsm433260pfc.215.2023.01.23.20.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 20:39:25 -0800 (PST)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Yan Vugenfirer <yvugenfi@redhat.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH RESEND] igbvf: Fix rx_buffer_len
Date:   Tue, 24 Jan 2023 13:39:15 +0900
Message-Id: <20230124043915.12952-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When rx_buffer_len is not aligned by 1024, igbvf sets the aligned size
to SRRCTL while the buffer is allocated with the unaligned size. This
allows the device to write more data than rx_buffer_len, resulting in
memory corruption. Align rx_buffer_len itself so that the buffer will
be allocated with the aligned size.

The condition to split RX packet header, which uses rx_buffer_len, is
also modified so that it doesn't change the behavior for the same
actual (unaligned) packet size. Actually the new condition is not
identical with the old one as it will no longer request splitting when
the actual packet size is exactly 2048, but that should be negligible.

Fixes: d4e0fe01a38a ("igbvf: add new driver to support 82576 virtual functions")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 drivers/net/ethernet/intel/igbvf/netdev.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 3a32809510fc..b6bca78198fa 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -1341,10 +1341,9 @@ static void igbvf_setup_srrctl(struct igbvf_adapter *adapter)
 	srrctl |= E1000_SRRCTL_DROP_EN;
 
 	/* Setup buffer sizes */
-	srrctl |= ALIGN(adapter->rx_buffer_len, 1024) >>
-		  E1000_SRRCTL_BSIZEPKT_SHIFT;
+	srrctl |= adapter->rx_buffer_len >> E1000_SRRCTL_BSIZEPKT_SHIFT;
 
-	if (adapter->rx_buffer_len < 2048) {
+	if (adapter->rx_buffer_len <= 2048) {
 		adapter->rx_ps_hdr_size = 0;
 		srrctl |= E1000_SRRCTL_DESCTYPE_ADV_ONEBUF;
 	} else {
@@ -1625,7 +1624,7 @@ static int igbvf_sw_init(struct igbvf_adapter *adapter)
 	struct net_device *netdev = adapter->netdev;
 	s32 rc;
 
-	adapter->rx_buffer_len = ETH_FRAME_LEN + VLAN_HLEN + ETH_FCS_LEN;
+	adapter->rx_buffer_len = ALIGN(ETH_FRAME_LEN + VLAN_HLEN + ETH_FCS_LEN, 1024);
 	adapter->rx_ps_hdr_size = 0;
 	adapter->max_frame_size = netdev->mtu + ETH_HLEN + ETH_FCS_LEN;
 	adapter->min_frame_size = ETH_ZLEN + ETH_FCS_LEN;
@@ -2429,6 +2428,8 @@ static int igbvf_change_mtu(struct net_device *netdev, int new_mtu)
 		adapter->rx_buffer_len = ETH_FRAME_LEN + VLAN_HLEN +
 					 ETH_FCS_LEN;
 
+	adapter->rx_buffer_len = ALIGN(adapter->rx_buffer_len, 1024);
+
 	netdev_dbg(netdev, "changing MTU from %d to %d\n",
 		   netdev->mtu, new_mtu);
 	netdev->mtu = new_mtu;
-- 
2.39.0

