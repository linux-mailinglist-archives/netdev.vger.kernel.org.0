Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C11825F3CE
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 09:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgIGHWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 03:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgIGHV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 03:21:56 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64850C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 00:21:55 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id c15so14573827wrs.11
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 00:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jauK4zLGfuAWi/L+qiHe6GhHl7upaTyCpwAKtsz6c9Y=;
        b=c3PZeovtqTz1OgocS3JYVbsGYl0ZPTSsCH8XTPYDORXQjIs+oOxKRIP/OjZPv8xh6R
         WUpZWYfuSVsCKSHab3aF74I1Xzvi4rmWos0RpEGVe6G7KBHbJY+HcSeyerpM/bmZZWZy
         eH6W6+qKiV20g21yXxo/xXqMMOn/Gs2A2oygHdmy86YYmaGCw4kisZ/c2DU4ZsdaBxRk
         j9KvVAlajKbQYjotsnAWIbxwNMLyFGq+zJpJy/1hF2QDmAZI59YQMUkTev/2jrNXwiwD
         F20qyxAdNgLIrXm+XN0qmnDHKiSzSS51ReIsCxGs0mjj735n36bxH6LPUnck1hh5BZps
         TmFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jauK4zLGfuAWi/L+qiHe6GhHl7upaTyCpwAKtsz6c9Y=;
        b=Ks3/1gw2iXAOq0mT7SdsXOHlZRWXTIKcyFj/+/qlQ8oReV5QZhwzWvLYnSUQ0XabNQ
         QmizZ1/zAXexRmciZ0/UZmKAFAhIkwonLruBkVrzckUQf7djZQ6exAslE18U03JDy9/Z
         ntUhLIJirIhJzZRejNyieXnl1RAHHRx2blNGVdHTiWp4nWrwdiu+MRb1UNeV0JJBTZDS
         lL62qZhcGOvc8yfAMDqMAqBaDeE0+bdkGRT9FOr7JJCslaukNeInm4MPrsMuGAPF0EiV
         Kyl8eVUcR9fZeNkgqr3pV6VVpkbgu9G9xfb71PCx4xbYNd31YRQSm0loti17F4O+CFwp
         BeGA==
X-Gm-Message-State: AOAM533J7bU+tAMMNjzBAAfIUXJHPRBIbjZhS5LBAPaY8yjrPnoQyS/j
        bNMOww0r5s4v6q+jbpE8Cv03dQ==
X-Google-Smtp-Source: ABdhPJwmvwX9zI+PHBShS4ELM2BxmcotTdHi/RFIaeF94VIXezMK0c+dMrjRvEaWhzanRmRugc73aA==
X-Received: by 2002:a5d:66c1:: with SMTP id k1mr20257018wrw.34.1599463314658;
        Mon, 07 Sep 2020 00:21:54 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id 92sm29130294wra.19.2020.09.07.00.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 00:21:54 -0700 (PDT)
Date:   Mon, 7 Sep 2020 09:21:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@mellanox.com" <roid@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Message-ID: <20200907072153.GL2997@nanopsycho.orion>
References: <BY5PR12MB43229CA19D3D8215BC9BEFECDC2E0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200901091742.GF3794@nanopsycho.orion>
 <20200901142840.25b6b58f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43228D0A9B1EF43C061A5A3BDC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200902080011.GI3794@nanopsycho.orion>
 <20200902082358.6b0c69b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200903055439.GA2997@nanopsycho.orion>
 <20200903123123.7e6025ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200904084321.GG2997@nanopsycho.orion>
 <BY5PR12MB43229A748C15AB08C233A792DC2B0@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB43229A748C15AB08C233A792DC2B0@BY5PR12MB4322.namprd12.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Sep 06, 2020 at 05:08:45AM CEST, parav@nvidia.com wrote:
>
>
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Friday, September 4, 2020 2:13 PM
>> 
>> Thu, Sep 03, 2020 at 09:31:23PM CEST, kuba@kernel.org wrote:
>> >On Thu, 3 Sep 2020 07:54:39 +0200 Jiri Pirko wrote:
>> >> Wed, Sep 02, 2020 at 05:23:58PM CEST, kuba@kernel.org wrote:
>> >> >On Wed, 2 Sep 2020 10:00:11 +0200 Jiri Pirko wrote:
>> >> >>>> I didn't quite get the fact that you want to not show controller ID on the
>> local
>> >> >>>> port, initially.
>> >> >>> Mainly to not_break current users.
>> >> >>
>> >> >> You don't have to take it to the name, unless "external" flag is set.
>> >> >>
>> >> >> But I don't really see the point of showing !external, cause such
>> >> >> controller number would be always 0. Jakub, why do you think it is
>> >> >> needed?
>> >> >
>> >> >It may seem reasonable for a smartNIC where there are only two
>> >> >controllers, and all you really need is that external flag.
>> >> >
>> >> >In a general case when users are trying to figure out the topology
>> >> >not knowing which controller they are sitting at looks like a
>> >> >serious limitation.
>> >>
>> >> I think we misunderstood each other. I never proposed just "external"
>> >> flag.
>> >
>> >Sorry, I was just saying that assuming a single host SmartNIC the
>> >controller ID is not necessary at all. You never suggested that, I did.
>> >Looks like I just confused everyone with that comment :(
>> >
>> >Different controller ID for different PFs but the same PCIe link would
>> >be very wrong. So please clarify - if I have a 2 port smartNIC, with on
>> >PCIe link to the host, and the embedded controller - what would I see?
>> 
>> Parav?
>>
>One controller id for both such PFs.
>I liked the idea of putting controller number for all the ports but not embedded for local ports.
>
>> 
>> >
>> >> What I propose is either:
>> >> 1) ecnum attribute absent for local
>> >>    ecnum attribute absent set to 0 for external controller X
>> >>    ecnum attribute absent set to 1 for external controller Y
>> >>    ...
>> >>
>> >> or:
>> >> 2) ecnum attribute absent for local, external flag set to false
>> >>    ecnum attribute absent set to 0 for external controller X, external flag set
>> to true
>> >>    ecnum attribute absent set to 1 for external controller Y,
>> >> external flag set to true
>> >
>> >I'm saying that I do want to see the the controller ID for all ports.
>> >
>> >So:
>> >
>> >3) local:   { "controller ID": x }
>> >   remote1: { "controller ID": y, "external": true }
>> >   remote1: { "controller ID": z, "external": true }
>> >
>> >We don't have to put the controller ID in the name for local ports, but
>> >the attribute should be reported. AFAIU name was your main concern, no?
>> 
>> Okay. Sounds fine. Let's put the controller number there for all ports.
>> ctrlnum X external true
>> ctrlnum Y external false
>> 
>> if (!external)
>> 	ignore the ctrlnum when generating the name
>> 
>
>Putting little more realistic example for Jakub's and your suggestion below.
>
>Below is the output for 3 controllers. ( 2 external + 1 local )
>Each external controller consist of 2 PCI PFs for a external host via single PCIe cable.
>Each local controller consist of 1 PCI PF.
>
>$ devlink port show
>pci/0000:00:08.0/0: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0 cnum 0 external false
>pci/0000:00:08.0/1: type eth netdev enp0s8f0_c1pf0 flavour pcipf pfnum 0 cnum 1 external true
>pci/0000:00:08.1/1: type eth netdev enp0s8f1_c1pf1 flavour pcipf pfnum 1 cnum 1 external true

I see cnum 0 and cnum 1, yet you talk about 3 controllers. What did I
miss?


>
>Looks ok?
>
>> 
>> >
>> >> >Example - multi-host system and you want to know which controller
>> >> >you are to run power cycle from the BMC side.
>> >> >
>> >> >We won't be able to change that because it'd change the names for you.
