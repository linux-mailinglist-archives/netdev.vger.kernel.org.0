Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21DD14B0872
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237577AbiBJIdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 03:33:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237561AbiBJIdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:33:40 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE782E98;
        Thu, 10 Feb 2022 00:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644482018; x=1676018018;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LzOxzSeQrSKYMob1v9yP9wi1VnFt4rvaqvnm3nMKecY=;
  b=CVZ74q2gc2O8MoOdLW2QdbXZIeyzkgalIv1YxyT9pLXesCgTo1jYEMSa
   /hdaSWXvL1Ui0qPO3MZsd2tdvfUAqtjN29PLOk+pBXwILHzz2e8vDXOHX
   NmLy1qJl2H0rxVv4olBTLFxywXRmbSor6Y20LJad7MlnHQ3cjTYj/MCZn
   /X598aY+97xpItjEg71PkAcPkkbkc5bqrh8o3PkMItvxrIG6UHy1LujAt
   8oOYOSpuC2486kQbrGYtuJENPX4s0KJLfA2mAgNvLrYpwEoUJ6L4vhPE9
   sTz7smbxGEufVvXr5pvNxFCsCeATvliPFlcsKoeABvpTnZpYYSMp3L3Mx
   Q==;
IronPort-SDR: N93H+dZ4I9GuDMVEQt638SoceWSMWlGupYrkEB2K/o2uVwTPRZlp3lDxCofP6CQ3sgxJmASdPo
 smAxgZVtZCf8Dul7D6Gwm8su9Gzj0wJPtDC4A3FRadgIbREO8Wzphj8e66Pjhkb/RYVnAb3PeG
 DG+Y0K+9Gu49E2xmAhoMN87jztzpJzmkop+vbgBLSoBfcJSZv4qu3d3iB9UUJDk1s589yUSbhe
 KBrDvN8x/MQDRM2eh/ttLeYaqpK55ABi7Ayd6aaxaf04Hmv8l4lB+pGCIeaXSrmO3TsGTlRm2/
 7lSEA3qhmM4XkUBCSYoisobW
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="161755490"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Feb 2022 01:33:38 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 10 Feb 2022 01:33:37 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 10 Feb 2022 01:33:37 -0700
Date:   Thu, 10 Feb 2022 09:36:12 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next] net: lan966x: Fix when CONFIG_IPV6 is not set
Message-ID: <20220210083612.4mszzwgcrvmn67rn@soft-dev3-1.localhost>
References: <20220209101823.1270489-1-horatiu.vultur@microchip.com>
 <YgPHjxpo0N4ND1ch@lunn.ch>
 <20220209180620.3699bf25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220209180620.3699bf25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/09/2022 18:06, Jakub Kicinski wrote:

Hi Andrew, Jakub
> 
> On Wed, 9 Feb 2022 14:54:23 +0100 Andrew Lunn wrote:
> > On Wed, Feb 09, 2022 at 11:18:23AM +0100, Horatiu Vultur wrote:
> > > When CONFIG_IPV6 is not set, then the compilation of the lan966x driver
> 
> compilation or linking?

It is a linking error. I will fix in the next version

> 
> > > fails with the following error:
> > >
> > > drivers/net/ethernet/microchip/lan966x/lan966x_main.c:444: undefined
> > > reference to `ipv6_mc_check_mld'
> > >
> > > The fix consists in adding #ifdef around this code.
> >
> > It might be better to add a stub function for when IPv6 is
> > disabled. We try to avoid #if in C code.

What do you think if I do something like this in the lan966x_main.h

---
#if IS_ENABLED(CONFIG_IPV6)
static inline bool lan966x_hw_offload_ipv6(struct sk_buff *skb)
{
	if (skb->protocol == htons(ETH_P_IPV6) &&
	    ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr) &&
	    !ipv6_mc_check_mld(skb))
		return false;

	return true;
}
#else
static inline bool lan966x_hw_offload_ipv6(struct sk_buff *skb)
{
	return false;
}
#endif
---

And then in lan966x_main.c just call this function.

> 
> If it's linking we can do:
> 
>         if (IS_ENABLED(CONFIG_IPV6) &&
>             skb->protocol == htons(ETH_P_IPV6) &&
>             ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr) &&
>             !ipv6_mc_check_mld(skb))
>                 return false;
> 
> But beware that IPV6 can be a module, you may need a Kconfig dependency.

I was also looking at other drivers on how they use 'ipv6_mc_check_mld'.
Then I have seen that drivers/net/amt.c and net/bridge/br_multicast.c
they wrap this function with #if.
But then there is net/batman-adv/multicast.c which doesn't do that and
it can compile and link without CONFIG_IPV6 and I just don't see how
that is working.

-- 
/Horatiu
