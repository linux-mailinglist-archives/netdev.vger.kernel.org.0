Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A004BC8FE
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 15:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241935AbiBSOyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 09:54:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiBSOya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 09:54:30 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE8A6464
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 06:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1645282449; x=1676818449;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TwiTNKkVrC264XfMSorkWqDX3O8n/AaIw2EuxEvqpL8=;
  b=g151LAOH/LEANmezpkJv0YfXiR6vjk8/JYf0rthD1YUIDZpsF2FMRTbe
   Bug1fKPv5UkmKIiBT+UHDXZXfprMSktGo6szcqMFmrmudcbTNyRmqo8wO
   QeAWvF292hyvpcKcnkbkQxIkJ/4Sas2ztFilpUbmjsHl1ZW9711bZsF1v
   nJXNfNeYeWMxt/EZq2kVs+JyAelhaE9ldCjeqoey/NDzezZkDigf0+iOh
   JPbCz9z6DSY4Au1yTegBh1WtF5I0N1j1FpOVlTBl3xwKsGjUD8dqocwnw
   MF1FzrFDCNz96LOx2CjE7Hqer9AmtEVjZjyeUt5TXszH7F9q2T1Awv2Mf
   w==;
X-IronPort-AV: E=Sophos;i="5.88,381,1635231600"; 
   d="scan'208";a="153659283"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Feb 2022 07:54:09 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 19 Feb 2022 07:54:08 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Sat, 19 Feb 2022 07:54:08 -0700
Date:   Sat, 19 Feb 2022 15:56:48 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Casper Andersson <casper@casan.se>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Lars Povlsen" <lars.povlsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: sparx5: Support offloading of bridge port
 flooding flags
Message-ID: <20220219145648.mucghw6kx5tkac7d@soft-dev3-1.localhost>
References: <20220217144534.sqntzdjltzvxslqo@wse-c0155>
 <20220217201830.51419e5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220218090127.vutf5qomnobcof4z@wse-c0155>
 <20220218202636.5f944493@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220218202636.5f944493@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/18/2022 20:26, Jakub Kicinski wrote:

Hi

> 
> On Fri, 18 Feb 2022 09:01:30 +0000 Casper Andersson wrote:
> > On 22/02/17 08:18, Jakub Kicinski wrote:
> > > On Thu, 17 Feb 2022 14:45:38 +0000 Casper Andersson wrote:
> > >
> > > Can others see this patch? My email client apparently does not have
> > > enough PGP support enabled. I'm worried I'm not the only one. That said
> > > lore and patchwork seem to have gotten it just fine:
> > >
> > > https://lore.kernel.org/all/20220217144534.sqntzdjltzvxslqo@wse-c0155/
> > > https://patchwork.kernel.org/project/netdevbpf/patch/20220217144534.sqntzdjltzvxslqo@wse-c0155/
> >
> > I apologize. This seems to be Protonmail's doing. When I look at the
> > web interface for Protonmail I can see that you are the only recipient
> > it says PGP encrypted for. This is probably because Protonmail will
> > automatically encrypt when both ends use Protonmail. Though I do not see
> > this indication on your reply. I tried switching to PGP/Inline instead
> > of PGP/MIME for this message. I hope this works.  Otherwise, I can
> > resubmit this patch using another email address. I did not find a way
> > to disable the automatic encryption. Or if you have any other
> > suggestions to get around this.
> 
> If I'm the only one who didn't get the plain text version - it's not
> a big deal.

I also have problems seeing Casper's patch.

The only comment that I have to the patch, it would be nice to implement
also the SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS callback. But I presume
that can be added later on.

> 
> Steen, can we get a review?

-- 
/Horatiu
