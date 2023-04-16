Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BFA6E3B63
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 21:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjDPTEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 15:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjDPTEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 15:04:22 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EA01BD8
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 12:04:21 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id h24-20020a17090a9c1800b002404be7920aso23835273pjp.5
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 12:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google; t=1681671861; x=1684263861;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UbEZeTq9MMgr0QnP6gJ8C3OJs7xVTjb+8LXU9xueXGE=;
        b=ak6Rr71z9lauYdJHdQnq8+iLPQhOh+jtNc9SIkelzRkyoPL8itGsN9z8PFId9lDQIf
         sxi2ntE5Lyb69NMhAJ9csDgFemblvoDw/V/X8rDWrXw5J69uNM1pY077BTUTdhqfrQS8
         84qjfQdbbA5dCoHm0zbIf1Zx4XUgi71Gw7gY4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681671861; x=1684263861;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UbEZeTq9MMgr0QnP6gJ8C3OJs7xVTjb+8LXU9xueXGE=;
        b=deJjeWwB274HU/LVGvSt/3I3gRbEgiLXdQHgR2MDsgfYqD0le0SXEKobWwEVGhggp3
         PJQ+CHRC9/L4EBSdjcgOLKfQFvmbr2oaOLn87uEcHllGKKxwfzIDBDPzf0fEG3JJrMTS
         zWN49BDUjXnQjCier7KhH8Pbmrl8weOrgdMx5DSIpFI6c43XZsn6uTD5dqqy0HU1YJNp
         QOyQLSE2WBIhmLvtYXsA3JoWi9DK6VNuDTCWYItfJ9SHVS3pscVPm+E/oMFQqwRGADhm
         S8NVY2GEH74xE+u6onCTClo0JxOzCIkagcuUACo3Uur/BGauWmb6VpLr8Iw5ItQDZDWt
         MeZA==
X-Gm-Message-State: AAQBX9dR2V4znbNtj16LbbH63pOe1m0cyIO6S/l3BetGDF0wCGNoRyct
        0IzTPPmU06iOwUjJVn2RUPbeTg==
X-Google-Smtp-Source: AKy350byUxcWXqSepVMvdbXk04RRaA4WvQkqOhSUtq72YBHzMojGlHyqf8UmcA93JrNBl3IERbw5Mw==
X-Received: by 2002:a17:902:d2d0:b0:1a6:961e:fcfe with SMTP id n16-20020a170902d2d000b001a6961efcfemr11829886plc.30.1681671860810;
        Sun, 16 Apr 2023 12:04:20 -0700 (PDT)
Received: from fastly.com (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id bj3-20020a170902850300b001a67a37beeesm6171068plb.139.2023.04.16.12.04.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Apr 2023 12:04:20 -0700 (PDT)
Date:   Sun, 16 Apr 2023 12:04:18 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org
Subject: Re: [PATCH net 2/2] ixgbe: Allow ixgbe to reset default flow hash
Message-ID: <20230416190417.GA43280@fastly.com>
References: <20230415054855.9293-1-jdamato@fastly.com>
 <20230415054855.9293-3-jdamato@fastly.com>
 <6a477f53-1b63-4e85-0c81-b60aff5fab0c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a477f53-1b63-4e85-0c81-b60aff5fab0c@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 16, 2023 at 10:29:36AM -0500, Samudrala, Sridhar wrote:
> 
> 
> On 4/15/2023 12:48 AM, Joe Damato wrote:
> >ethtool uses `ETHTOOL_GRXRINGS` to compute how many queues are supported
> >by RSS. The driver should return the smaller of either:
> >   - The maximum number of RSS queues the device supports, OR
> >   - The number of RX queues configured
> >
> >Prior to this change, running `ethtool -X $iface default` fails if the
> >number of queues configured is larger than the number supported by RSS,
> >even though changing the queue count correctly resets the flowhash to
> >use all supported queues.
> >
> >Other drivers (for example, i40e) will succeed but the flow hash will
> >reset to support the maximum number of queues supported by RSS, even if
> >that amount is smaller than the configured amount.
> >
> >Prior to this change:
> >
> >$ sudo ethtool -L eth1 combined 20
> >$ sudo ethtool -x eth1
> >RX flow hash indirection table for eth1 with 20 RX ring(s):
> >     0:      0     1     2     3     4     5     6     7
> >     8:      8     9    10    11    12    13    14    15
> >    16:      0     1     2     3     4     5     6     7
> >    24:      8     9    10    11    12    13    14    15
> >    32:      0     1     2     3     4     5     6     7
> >...
> >
> >You can see that the flowhash was correctly set to use the maximum
> >number of queues supported by the driver (16).
> >
> >However, asking the NIC to reset to "default" fails:
> >
> >$ sudo ethtool -X eth1 default
> >Cannot set RX flow hash configuration: Invalid argument
> >
> >After this change, the flowhash can be reset to default which will use
> >all of the available RSS queues (16) or the configured queue count,
> >whichever is smaller.
> >
> >Starting with eth1 which has 10 queues and a flowhash distributing to
> >all 10 queues:
> >
> >$ sudo ethtool -x eth1
> >RX flow hash indirection table for eth1 with 10 RX ring(s):
> >     0:      0     1     2     3     4     5     6     7
> >     8:      8     9     0     1     2     3     4     5
> >    16:      6     7     8     9     0     1     2     3
> >...
> >
> >Increasing the queue count to 48 resets the flowhash to distribute to 16
> >queues, as it did before this patch:
> >
> >$ sudo ethtool -L eth1 combined 48
> >$ sudo ethtool -x eth1
> >RX flow hash indirection table for eth1 with 16 RX ring(s):
> >     0:      0     1     2     3     4     5     6     7
> >     8:      8     9    10    11    12    13    14    15
> >    16:      0     1     2     3     4     5     6     7
> >...
> >
> >Due to the other bugfix in this series, the flowhash can be set to use
> >queues 0-5:
> >
> >$ sudo ethtool -X eth1 equal 5
> >$ sudo ethtool -x eth1
> >RX flow hash indirection table for eth1 with 16 RX ring(s):
> >     0:      0     1     2     3     4     0     1     2
> >     8:      3     4     0     1     2     3     4     0
> >    16:      1     2     3     4     0     1     2     3
> >...
> >
> >Due to this bugfix, the flowhash can be reset to default and use 16
> >queues:
> >
> >$ sudo ethtool -X eth1 default
> >$ sudo ethtool -x eth1
> >RX flow hash indirection table for eth1 with 16 RX ring(s):
> >     0:      0     1     2     3     4     5     6     7
> >     8:      8     9    10    11    12    13    14    15
> >    16:      0     1     2     3     4     5     6     7
> >...
> >
> >Signed-off-by: Joe Damato <jdamato@fastly.com>
> 
> Thanks for the detailed commit message and steps to reproduce
> and validate the issue.

No worries. Thanks for the review.

> Would suggest changing the title to indicate that this fix is enabling
> setting the RSS indirection table to default value.

OK, sure. I can send a v2 that includes your reviewed tags and changes the
title of this commit (but makes no other changes).

I'll make the new title of this commit ixgbe: Enable setting RSS table to
default values.

Hope that's ok; will send out the v2 shortly.

> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> 
> >---
> >  .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  | 19 ++++++++++---------
> >  1 file changed, 10 insertions(+), 9 deletions(-)
> >
> >diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> >index 821dfd323fa9..0bbad4a5cc2f 100644
> >--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> >+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> >@@ -2665,6 +2665,14 @@ static int ixgbe_get_rss_hash_opts(struct ixgbe_adapter *adapter,
> >  	return 0;
> >  }
> >+static int ixgbe_rss_indir_tbl_max(struct ixgbe_adapter *adapter)
> >+{
> >+	if (adapter->hw.mac.type < ixgbe_mac_X550)
> >+		return 16;
> >+	else
> >+		return 64;
> >+}
> >+
> >  static int ixgbe_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
> >  			   u32 *rule_locs)
> >  {
> >@@ -2673,7 +2681,8 @@ static int ixgbe_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
> >  	switch (cmd->cmd) {
> >  	case ETHTOOL_GRXRINGS:
> >-		cmd->data = adapter->num_rx_queues;
> >+		cmd->data = min_t(int, adapter->num_rx_queues,
> >+				  ixgbe_rss_indir_tbl_max(adapter));
> >  		ret = 0;
> >  		break;
> >  	case ETHTOOL_GRXCLSRLCNT:
> >@@ -3075,14 +3084,6 @@ static int ixgbe_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
> >  	return ret;
> >  }
> >-static int ixgbe_rss_indir_tbl_max(struct ixgbe_adapter *adapter)
> >-{
> >-	if (adapter->hw.mac.type < ixgbe_mac_X550)
> >-		return 16;
> >-	else
> >-		return 64;
> >-}
> >-
> >  static u32 ixgbe_get_rxfh_key_size(struct net_device *netdev)
> >  {
> >  	return IXGBE_RSS_KEY_SIZE;
