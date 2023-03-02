Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4326A83BF
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 14:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjCBNq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 08:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjCBNq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 08:46:27 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B6330B24;
        Thu,  2 Mar 2023 05:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677764787; x=1709300787;
  h=references:from:to:cc:date:in-reply-to:message-id:
   mime-version:subject;
  bh=Gc7jiqMATF/WgV3NyGXXqkcSKEdhQ2vY+HxNsRmp5Uc=;
  b=T5RBNOtQIeHccGPbig/vu+s1bAzT2+TgJxZ17sD5boscSE9tLd9Z49tO
   xI3+G814/h/oxOfB7rwQ3qHLqHg+I/iDIwNR50kcQkwkcCdhaVDbSSboT
   dIgHQUDTJHw/9tQX4OC5Yp7eHIIBsCrxSqiiFT3xfEb+LkKRI6rSIe1vR
   4=;
X-IronPort-AV: E=Sophos;i="5.98,227,1673913600"; 
   d="scan'208";a="298774921"
Subject: Re: [PATCH v4 bpf-next 2/8] drivers: net: turn on XDP features
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-617e30c2.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 13:46:22 +0000
Received: from EX19D009EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-617e30c2.us-east-1.amazon.com (Postfix) with ESMTPS id BAD75647B0;
        Thu,  2 Mar 2023 13:46:13 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D009EUA001.ant.amazon.com (10.252.50.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 2 Mar 2023 13:46:11 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.85.143.175) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 2 Mar 2023 13:45:59 +0000
References: <cover.1674913191.git.lorenzo@kernel.org>
 <948292cc7d72f2bc04b5973008ecf384f9296677.1674913191.git.lorenzo@kernel.org>
 <pj41zlcz5v1kkg.fsf@u570694869fb251.ant.amazon.com>
 <Y/58Kzah/ERCYMGD@lore-desk>
User-agent: mu4e 1.6.10; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <hawk@kernel.org>, <toke@redhat.com>, <memxor@gmail.com>,
        <alardam@gmail.com>, <saeedm@nvidia.com>,
        <anthony.l.nguyen@intel.com>, <gospo@broadcom.com>,
        <vladimir.oltean@nxp.com>, <nbd@nbd.name>, <john@phrozen.org>,
        <leon@kernel.org>, <simon.horman@corigine.com>,
        <aelior@marvell.com>, <christophe.jaillet@wanadoo.fr>,
        <ecree.xilinx@gmail.com>, <mst@redhat.com>, <bjorn@kernel.org>,
        <magnus.karlsson@intel.com>, <maciej.fijalkowski@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <lorenzo.bianconi@redhat.com>,
        <martin.lau@linux.dev>, <sdf@google.com>
Date:   Thu, 2 Mar 2023 15:44:18 +0200
In-Reply-To: <Y/58Kzah/ERCYMGD@lore-desk>
Message-ID: <pj41zllekf467h.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.85.143.175]
X-ClientProxiedBy: EX19D032UWB001.ant.amazon.com (10.13.139.152) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Lorenzo Bianconi <lorenzo@kernel.org> writes:

> [[PGP Signed Part:Undecided]]
>> 
>> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>> 
>> > From: Marek Majtyka <alardam@gmail.com>
>> > 
>> > ...
>> > 
>> > diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c
>> > b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>> > index e8ad5ea31aff..d3999db7c6a2 100644
>> > --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
>> > +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>> > @@ -597,7 +597,9 @@ static int ena_xdp_set(struct net_device 
>> > *netdev,
>> > struct netdev_bpf *bpf)
>> >  				if (rc)
>> >  					return rc;
>> >  			}
>> > +			xdp_features_set_redirect_target(netdev, 
>> > false);
>> >  		} else if (old_bpf_prog) {
>> > + xdp_features_clear_redirect_target(netdev);
>> >  			rc = 
>> >  ena_destroy_and_free_all_xdp_queues(adapter);
>> >  			if (rc)
>> >  				return rc;
>> > @@ -4103,6 +4105,8 @@ static void 
>> > ena_set_conf_feat_params(struct
>> > ena_adapter *adapter,
>> >  	/* Set offload features */
>> >  	ena_set_dev_offloads(feat, netdev);
>> >   +	netdev->xdp_features = NETDEV_XDP_ACT_BASIC |
>> > NETDEV_XDP_ACT_REDIRECT;
>> > +
>> >  	adapter->max_mtu = feat->dev_attr.max_mtu;
>> >  	netdev->max_mtu = adapter->max_mtu;
>> >  	netdev->min_mtu = ENA_MIN_MTU;
>> > 
>> 
>> Hi, thanks for the time you put in adjusting the ENA driver as 
>> well.
>
> Hi Shay,
>
>> 
>> Why did you set NETDEV_XDP_ACT_NDO_XMIT dynamically for some 
>> drivers (like
>> ENA and mlx5) and statically for others (like atlantic driver 
>> which also
>> redirects packets only when XDP program is loaded) ?
>> Is it only for the sake of notifying the user that an XDP 
>> program has been
>> loaded ?
>
> there are some drivers (e.g. mvneta) where 
> NETDEV_XDP_ACT_NDO_XMIT is always
> supported while there are other drivers (e.g. intel drivers) 
> where it
> depends on other configurations (e.g. if the driver needs to 
> reserve
> some queues for xdp).
>
> Regards,
> Lorenzo
>

Well given that ENA's ability to redirect packets goes hand in 
hand with its ability to process any XDP traffic I'd say it always 
supports ndo_xmit.
Doesn't seem like a big issue though.

Thanks for the explanation,
Shay

>
> [[End of PGP Signed Part]]

