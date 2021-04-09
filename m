Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2336359FED
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 15:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbhDINgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 09:36:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42640 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231127AbhDINgB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 09:36:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lUrIO-00FmRk-5c; Fri, 09 Apr 2021 15:35:36 +0200
Date:   Fri, 9 Apr 2021 15:35:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     David Miller <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH v3 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <YHBYKGwJsX/wuYqn@lunn.ch>
References: <20210408225840.26304-1-decui@microsoft.com>
 <20210408.164618.597563844564989065.davem@davemloft.net>
 <MW2PR2101MB0892B82CBCF2450D4A82DD50BF739@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <20210408.174122.1793350393067698495.davem@davemloft.net>
 <BL0PR2101MB0930523DB18C6F1C1CA00A89CA739@BL0PR2101MB0930.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL0PR2101MB0930523DB18C6F1C1CA00A89CA739@BL0PR2101MB0930.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 For the structs containing variables with the same sizes, or already size aligned 
> variables, we knew the __packed has no effect. And for these structs, it doesn't 
> cause performance impact either, correct? 
> 
> But in the future, if different sized variables are added, the __packed may 
> become necessary again. To prevent anyone accidently forget to add __packed 
> when adding new variables to these structs, can we keep the __packed for all 
> messages going through the "wire"?

It should not be a problem because anybody adding new variables should
know packed is not liked in the kernel and will take care.

If you want to be paranoid add a BUILD_BUG_ON(size(struct foo) != 42);

   Andrew
