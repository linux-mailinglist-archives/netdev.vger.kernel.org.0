Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0B628B581
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 15:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388609AbgJLNHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 09:07:35 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:57474 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729521AbgJLNHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 09:07:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602508053; x=1634044053;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TKhEx3NIOhBw3NXbPso9bAlFvFT04OKekx/d4GF2W9A=;
  b=1UZSbtULcp7L+rh9GeME4m8qPLoHZ8MSEbH4uHNEro0LNR3SYDQHleU8
   kYGZAMBDVNlBq3nbblNc98vfBRSARmU5BOE9vAf2aTEvl14wcTRpyAlfK
   RZSFORNk40/e+vFRusYW5fhVbmo09qMqj70LJ6rgto4ONF8hWl+Eyb/91
   WKZMKTZo8atnogv7Lr0MlpLaMMMq8xxXsna3aZ75O1mFIUHnIxY1Ggm09
   j8+/VAhTNdrnlo41SZns84cxpA6tNplbq+MO2AOyj5vQSxQmZ20MDGnm/
   gWDq+7MLAvwrpnomqtPwxMCsXVMceJZnuazNb1k8icRqiijEx/FgZxkgv
   A==;
IronPort-SDR: AZFthPCBxXnlpxQOnTsJoxSlTXbDS96gW5LJq91+TnExtPDcKaV7WVqfZpF7FIpMYGvfKFNAyB
 uAmjsF/YU///mZSq0gOqaehV6h1ZuT+LUMC1aFgJMHOCFh48vwb+I786qUo1vZHbo8AlYHgw+P
 jZMLy974lL1nVspQEXsmZU1txTJ/WgIqbgzjxHheTOXzLdY1HBctR/wl3wSOCz0EEYCSXRsC7t
 PUe0wR75ncsy7M5DHvmgpg6EIRY5w3gfCJHY/bfnkxuIThWuPH6hCUbpvOLnKWdm4DZtk4DopH
 K2s=
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="scan'208";a="95010773"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Oct 2020 06:07:33 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 12 Oct 2020 06:07:33 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 12 Oct 2020 06:07:33 -0700
Date:   Mon, 12 Oct 2020 13:05:47 +0000
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v4 07/10] bridge: cfm: Netlink SET configuration
 Interface.
Message-ID: <20201012130547.7tj3sdkmzcqjcssf@soft-test08>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
 <20201009143530.2438738-8-henrik.bjoernlund@microchip.com>
 <20201009184556.6cfe6fbc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20201009184556.6cfe6fbc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review. Comments below.

The 10/09/2020 18:45, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Fri, 9 Oct 2020 14:35:27 +0000 Henrik Bjoernlund wrote:
> > +static inline struct mac_addr nla_get_mac(const struct nlattr *nla)
> 
> static inlines are generally not needed in C sources and just hide
> unused code. Please drop the inline annotation.
> 
I removed this function
> > +{
> > +     struct mac_addr mac;
> > +
> > +     nla_memcpy(&mac.addr, nla, sizeof(mac.addr));
> > +
> > +     return mac;
> > +}
> > +
> > +static inline struct br_cfm_maid nla_get_maid(const struct nlattr *nla)
> 
> ditto

I removed this function.

> 
> > +{
> > +     struct br_cfm_maid maid;
> > +
> > +     nla_memcpy(&maid.data, nla, sizeof(maid.data));
> 
> returning a 48B struct from a helper is a little strange, but I guess
> it's not too bad when compiler inlines the thing?
> 
I removed this function. 

> > +     return maid;
> > +}
> > +
> > +static const struct nla_policy
> > +br_cfm_policy[IFLA_BRIDGE_CFM_MAX + 1] = {
> > +     [IFLA_BRIDGE_CFM_UNSPEC]                = { .type = NLA_REJECT },
> 
> Not needed, REJECT is treated the same as 0 / uninit, right?
> 
Did not change anything here. I would like to keep this if it does no harm.

> > +     [IFLA_BRIDGE_CFM_MEP_CREATE]            = { .type = NLA_NESTED },
> 
> Consider using NLA_POLICY_NESTED() to link up the next layers.
> 
I change to use the NLA_POLICY_NESTED macro.

> > +     [IFLA_BRIDGE_CFM_MEP_DELETE]            = { .type = NLA_NESTED },
> > +     [IFLA_BRIDGE_CFM_MEP_CONFIG]            = { .type = NLA_NESTED },
> > +     [IFLA_BRIDGE_CFM_CC_CONFIG]             = { .type = NLA_NESTED },
> > +     [IFLA_BRIDGE_CFM_CC_PEER_MEP_ADD]       = { .type = NLA_NESTED },
> > +     [IFLA_BRIDGE_CFM_CC_PEER_MEP_REMOVE]    = { .type = NLA_NESTED },
> > +     [IFLA_BRIDGE_CFM_CC_RDI]                = { .type = NLA_NESTED },
> > +     [IFLA_BRIDGE_CFM_CC_CCM_TX]             = { .type = NLA_NESTED },
> > +};

-- 
/Henrik
