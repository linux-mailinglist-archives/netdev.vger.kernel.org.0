Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995F76A3F54
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 11:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjB0KRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 05:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjB0KRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 05:17:52 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89658C9;
        Mon, 27 Feb 2023 02:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677493070; x=1709029070;
  h=references:from:to:cc:subject:date:in-reply-to:
   message-id:mime-version;
  bh=WDKEfsQ09EQinniY8kNYa4ZtvRstDHSkkWFa8N7k+sY=;
  b=dp4KEMxZLIiQmbVDheN3e0D9fl6RtkNHgPb/gka9aft48rkbMvQgmLlr
   PLcMtVBG+b1Q6Tzxf17bRkv9caguPzFR7QoxStkqAXzYbT9Fsosc5ncPv
   nB7Yq9f+HMf/o+svJbjykTIVXZ9w1Ji2OJovHDBZJUKXnS9zMmpQQmqcC
   o=;
X-IronPort-AV: E=Sophos;i="5.97,331,1669075200"; 
   d="scan'208";a="1106934594"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-25ac6bd5.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 10:15:16 +0000
Received: from EX19D006EUA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-m6i4x-25ac6bd5.us-east-1.amazon.com (Postfix) with ESMTPS id 2A6774499A;
        Mon, 27 Feb 2023 10:15:14 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D006EUA002.ant.amazon.com (10.252.50.65) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Mon, 27 Feb 2023 10:15:13 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.85.143.178) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Mon, 27 Feb 2023 10:15:00 +0000
References: <cover.1674913191.git.lorenzo@kernel.org>
 <948292cc7d72f2bc04b5973008ecf384f9296677.1674913191.git.lorenzo@kernel.org>
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
Subject: Re: [PATCH v4 bpf-next 2/8] drivers: net: turn on XDP features
Date:   Mon, 27 Feb 2023 11:50:38 +0200
In-Reply-To: <948292cc7d72f2bc04b5973008ecf384f9296677.1674913191.git.lorenzo@kernel.org>
Message-ID: <pj41zlcz5v1kkg.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.85.143.178]
X-ClientProxiedBy: EX19D032UWB004.ant.amazon.com (10.13.139.136) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-10.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Lorenzo Bianconi <lorenzo@kernel.org> writes:

> From: Marek Majtyka <alardam@gmail.com>
>
> ...
>
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c 
> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index e8ad5ea31aff..d3999db7c6a2 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -597,7 +597,9 @@ static int ena_xdp_set(struct net_device 
> *netdev, struct netdev_bpf *bpf)
>  				if (rc)
>  					return rc;
>  			}
> +			xdp_features_set_redirect_target(netdev, 
> false);
>  		} else if (old_bpf_prog) {
> + 
> xdp_features_clear_redirect_target(netdev);
>  			rc = 
>  ena_destroy_and_free_all_xdp_queues(adapter);
>  			if (rc)
>  				return rc;
> @@ -4103,6 +4105,8 @@ static void 
> ena_set_conf_feat_params(struct ena_adapter *adapter,
>  	/* Set offload features */
>  	ena_set_dev_offloads(feat, netdev);
>  
> +	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | 
> NETDEV_XDP_ACT_REDIRECT;
> +
>  	adapter->max_mtu = feat->dev_attr.max_mtu;
>  	netdev->max_mtu = adapter->max_mtu;
>  	netdev->min_mtu = ENA_MIN_MTU;
>

Hi, thanks for the time you put in adjusting the ENA driver as 
well.

Why did you set NETDEV_XDP_ACT_NDO_XMIT dynamically for some 
drivers (like ENA and mlx5) and statically for others (like 
atlantic driver which also redirects packets only when XDP program 
is loaded) ?
Is it only for the sake of notifying the user that an XDP program 
has been loaded ?

Thanks,
Shay

> ...
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index a5a7ecf6391c..82727b47259d 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -773,3 +773,21 @@ static int __init xdp_metadata_init(void)
>  	return register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, 
>  &xdp_metadata_kfunc_set);
>  }
>  late_initcall(xdp_metadata_init);
> +
> +void xdp_features_set_redirect_target(struct net_device *dev, 
> bool support_sg)
> +{
> +	dev->xdp_features |= NETDEV_XDP_ACT_NDO_XMIT;
> +	if (support_sg)
> +		dev->xdp_features |= NETDEV_XDP_ACT_NDO_XMIT_SG;
> +
> +	call_netdevice_notifiers(NETDEV_XDP_FEAT_CHANGE, dev);
> +}
> +EXPORT_SYMBOL_GPL(xdp_features_set_redirect_target);
> +
> +void xdp_features_clear_redirect_target(struct net_device *dev)
> +{
> +	dev->xdp_features &= ~(NETDEV_XDP_ACT_NDO_XMIT |
> +			       NETDEV_XDP_ACT_NDO_XMIT_SG);
> +	call_netdevice_notifiers(NETDEV_XDP_FEAT_CHANGE, dev);
> +}
> +EXPORT_SYMBOL_GPL(xdp_features_clear_redirect_target);

