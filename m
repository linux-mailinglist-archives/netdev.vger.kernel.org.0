Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49ADA58FB21
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 13:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbiHKLOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 07:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiHKLOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 07:14:10 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFE490836
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 04:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660216449; x=1691752449;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J3uo98LuVmNAbYvSuYkYeoTiZdtXt4exTEFu7JgkHCE=;
  b=ICuUMcRIT1GxwPhEikWmt+XcUcrMR12Jc88BBwZ2VCEgBBopq1UyhkUN
   TUUWByh0okLeVhryDkeeQwPmU/vem+8m40NYQWRSWD66BtGWBJRg885jz
   2pzVhBpzviVf0jvu2IptTqU/sgnLk4GMSqssQ7CCaIccPtoOBPlFvApNO
   vHz9uKg8LiPoSsIsODmSYAatNkGXpk0i6z58BeeoEH8bYO1v6WvPjfQz+
   wVuP8ywdsnpBpnOJx3gMnzgWCyhSVNfXPoe74cDtfBV4ytohgQoH2SqOV
   7EamKTT4K/J/9n38TU/clh0hz5wJbcF/RgQifnYSsJt5KgO2fAlZ4DhnY
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="355323483"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="355323483"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 04:14:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="556092260"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 11 Aug 2022 04:14:06 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27BBE53w006200;
        Thu, 11 Aug 2022 12:14:05 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "shenjian (K)" <shenjian15@huawei.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        ecree.xilinx@gmail.com, hkallweit1@gmail.com, saeed@kernel.org,
        leon@kernel.org, netdev@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [RFCv7 PATCH net-next 02/36] net: replace general features macroes with global netdev_features variables
Date:   Thu, 11 Aug 2022 13:05:29 +0200
Message-Id: <20220811110529.4866-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <7eb9ad01-cf1f-afea-0c16-4b269462236f@huawei.com>
References: <20220810030624.34711-1-shenjian15@huawei.com> <20220810030624.34711-3-shenjian15@huawei.com> <20220810095800.1304489-1-alexandr.lobakin@intel.com> <7eb9ad01-cf1f-afea-0c16-4b269462236f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "shenjian (K)" <shenjian15@huawei.com>
Date: Wed, 10 Aug 2022 20:01:15 +0800

> 在 2022/8/10 17:58, Alexander Lobakin 写道:
> > From: Jian Shen <shenjian15@huawei.com>
> > Date: Wed, 10 Aug 2022 11:05:50 +0800
> >
> >> There are many netdev_features bits group used in kernel. The definition
> >> will be illegal when using feature bit more than 64. Replace these macroes
> >> with global netdev_features variables, initialize them when netdev module
> >> init.
> >>
> >> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> >> ---

[...]

> >> @@ -11362,6 +11363,86 @@ static struct pernet_operations __net_initdata default_device_ops = {
> >>   	.exit_batch = default_device_exit_batch,
> >>   };
> >>   
> >> +static void __init netdev_features_init(void)
> > Given that you're creating a new file dedicated to netdev features,
> > I'd place that initializer there. You can then declare its proto in
> > net/core/dev.h.
> I want to make sure it cann't be called outside net/core/dev.c, for some
> drivers include net/core/dev.h, then they can see it.

net/core/dev.h is internal, nobody outside net/core/ uses it and
this was its purpose.

> 
> >> +{
> >> +	netdev_features_t features;
> >> +
> >> +	netdev_features_set_array(&netif_f_ip_csum_feature_set,
> >> +				  &netdev_ip_csum_features);
> >> +	netdev_features_set_array(&netif_f_csum_feature_set_mask,
> >> +				  &netdev_csum_features_mask);
> >> +
> >> +	netdev_features_set_array(&netif_f_gso_feature_set_mask,
> >> +				  &netdev_gso_features_mask);
> >> +	netdev_features_set_array(&netif_f_general_tso_feature_set,
> >> +				  &netdev_general_tso_features);
> >> +	netdev_features_set_array(&netif_f_all_tso_feature_set,
> >> +				  &netdev_all_tso_features);
> >> +	netdev_features_set_array(&netif_f_tso_ecn_feature_set,
> >> +				  &netdev_tso_ecn_features);
> >> +	netdev_features_set_array(&netif_f_all_fcoe_feature_set,
> >> +				  &netdev_all_fcoe_features);
> >> +	netdev_features_set_array(&netif_f_gso_soft_feature_set,
> >> +				  &netdev_gso_software_features);
> >> +	netdev_features_set_array(&netif_f_gso_encap_feature_set,
> >> +				  &netdev_gso_encap_all_features);
> >> +
> >> +	netdev_csum_gso_features_mask =
> >> +		netdev_features_or(netdev_gso_features_mask,
> >> +				   netdev_csum_features_mask);
> > (I forgot to mention this in 01/36 ._.)
> >
> > As you're converting to bitmaps, you should probably avoid direct
> > assignments. All the bitmap_*() modification functions take a pointer
> > to the destination as a first argument. So it should be
> >
> > netdev_features_or(netdev_features_t *dst, const netdev_features_t *src1,
> > 		   const netdev_features_t *src1);
> The netdev_features_t will be convert to a structure which only contained
> a feature bitmap. So assginement is ok.

Yeah I realized it later, probably a good idea.

> 
> 
> >> +
> >> +	netdev_features_set_array(&netif_f_one_for_all_feature_set,
> >> +				  &netdev_one_for_all_features);
> > Does it make sense to prefix features and the corresponding sets
> > differently? Why not just 'netdev_' for both of them?
> For all the feature bits are named "NETFI_F_XXX_BIT",

Right, but then why are netdev_*_features prefixed with 'netdev',
not 'netif_f'? :D Those sets are tied tightly with the feature
structures, so I think they should have the same prefix. I'd go
with 'netdev' for both.

> 
> 
> >> +	netdev_features_set_array(&netif_f_all_for_all_feature_set,
> >> +				  &netdev_all_for_all_features);

[...]

> >> -- 
> >> 2.33.0
> > Thanks,
> > Olek
> >
> > .
> 
> Thank,
> Jian

Thanks,
Olek
