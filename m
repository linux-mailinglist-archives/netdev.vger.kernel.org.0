Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1547F258A37
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 10:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgIAITM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 04:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbgIAITK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 04:19:10 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BE9C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 01:19:09 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id v4so247371wmj.5
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 01:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ufq2tFzgWEYlbeMmXYOotYaxFKSnpbRXsfpWbyqOPPA=;
        b=Gfk4PjitWq9tRC2Pc5LyFgKodkMIozUDs2YE6kWYeggpmg5/o8Z1O1Mn1wjQ0xuvhP
         9DU/SidE4sbh2q7UQOgvfddcU53nB7oOQoBZjk5tl+EA3acFOCW9mJ6wxYe5kxYZYRFK
         864OSchBx2tXYwpAPVaMoTn+KtUGCSgXv5j3F9sZTyvuvHpmBi/gSl74X5ldMIfeUEZ7
         h7JH1zSw5q2H5myYVJjZp8gXlLWJqR/3fJw4uFxyjyWOIs/GgK56q1QNhwz0Nt+JS/dw
         Fc/SX350M8PjveqCNSM1+lvFL/xxeYm03aqC9I7i5vUinNgazELh++ZxrpMtCCNEJjBk
         Eo2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ufq2tFzgWEYlbeMmXYOotYaxFKSnpbRXsfpWbyqOPPA=;
        b=T8SfjBQd8/lU302TSm3fo2ZzIGvEMOYVn1n/55WbiYiLtY1aUT1pgTNCaOgmz29wmy
         x1jd8LiOd99QBTr5iJDWjHhyWgm5rirm537c/HLF0aEWDqnhRPn3v+Ckp1+vsbdzdIsh
         PCGQWPwjpI0kcSfVYmdbPMrBezFYU4T8uZdCxiclSPmY30poIKnc9+0aNtsW1KMrYGVq
         qpVhidZSiE93Tcir6DUk5ktgmVKjY4zrmf/dhXZ9HL8GrJhgV+ICRSfzdeP9FmWVa9bR
         JbRP8KK2NOgbQ6vYu9Oasw9a5fwvnHCDzwiORUS1yWAGpgIemSQGGclG1BwJqR/4jLAj
         DSBQ==
X-Gm-Message-State: AOAM5320uzRyuHxh8ROLYw2YogQrys88DCyEVmlAb/yVlU1V8Tegg2kz
        bHraigTLJ96hlogFbt8VHgGoCA==
X-Google-Smtp-Source: ABdhPJzj23v6Fp5WXA57RaMVOsn6bZmRV4Xfd8LwB8NFnXTb+fPu/pNIKzOmkzlxGVF1aWrwLYM7lg==
X-Received: by 2002:a1c:9c0b:: with SMTP id f11mr626801wme.0.1598948347767;
        Tue, 01 Sep 2020 01:19:07 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id y6sm1007508wrt.80.2020.09.01.01.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 01:19:07 -0700 (PDT)
Date:   Tue, 1 Sep 2020 10:19:06 +0200
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
Message-ID: <20200901081906.GE3794@nanopsycho.orion>
References: <20200825173203.2c80ed48@kicinski-fedora-PC1C0HJN>
 <BY5PR12MB4322E2E21395BD1553B8E375DC540@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200826130747.4d886a09@kicinski-fedora-PC1C0HJN>
 <BY5PR12MB432276DBB3345AD328D787E4DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200827113216.7b9a3a25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43221CAA3D77DB7DB490B012DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200827144206.3c2cad03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB432271E4F9028831FA75B7E0DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200828094343.6c4ff16a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43220099C235E238D6AF89EADC530@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB43220099C235E238D6AF89EADC530@BY5PR12MB4322.namprd12.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Aug 29, 2020 at 05:43:58AM CEST, parav@nvidia.com wrote:
>
>
>> From: Jakub Kicinski <kuba@kernel.org>
>> Sent: Friday, August 28, 2020 10:14 PM
>> 
>> On Fri, 28 Aug 2020 04:27:19 +0000 Parav Pandit wrote:
>> > > From: Jakub Kicinski <kuba@kernel.org>
>> > > Sent: Friday, August 28, 2020 3:12 AM
>> > >
>> > > On Thu, 27 Aug 2020 20:15:01 +0000 Parav Pandit wrote:
>> > > > > From: Jakub Kicinski <kuba@kernel.org>
>> > > > >
>> > > > > I find it strange that you have pfnum 0 everywhere but then
>> > > > > different controllers.
>> > > > There are multiple PFs, connected to different PCI RC. So device
>> > > > has same pfnum for both the PFs.
>> > > >
>> > > > > For MultiHost at Netronome we've used pfnum to distinguish
>> > > > > between the hosts. ASIC must have some unique identifiers for each PF.
>> > > > Yes. there is. It is identified by a unique controller number;
>> > > > internally it is called host_number. But internal host_number is
>> > > > misleading term as multiple cables of same physical card can be
>> > > > plugged into single host. So identifying based on a unique
>> > > > (controller) number and matching that up on external cable is desired.
>> > > >
>> > > > > I'm not aware of any practical reason for creating PFs on one RC
>> > > > > without reinitializing all the others.
>> > > > I may be misunderstanding, but how is initialization is related
>> > > > multiple PFs?
>> > >
>> > > If the number of PFs is static it should be possible to understand
>> > > which one is on which system.
>> >
>> > How? How do we tell that pfnum A means external system.
>> > Want to avoid such 'implicit' notion.
>> 
>> How do you tell that controller A means external system?

Perhaps the attr name could be explicitly containing "external" word?
Like:
"ext_controller" or "extnum" (similar to "pfnum" and "vfnum") something
like that.


>Which is why I started with annotating only external controllers, mainly to avoid renaming and breaking current scheme for non_smartnic cases which possibly is the most user base.
>
>But probably external pcipf/vf/sf port flavours are more intuitive combined with controller number.
>More below.
>
>> 
>> > > > > I can see how having multiple controllers may make things
>> > > > > clearer, but adding another layer of IDs while the one under it
>> > > > > is unused
>> > > > > (pfnum=0) feels very unnecessary.
>> > > > pfnum=0 is used today. not sure I understand your comment about
>> > > > being unused. Can you please explain?
>> > >
>> > > You examples only ever have pfnum 0:
>> > >
>> > Because both controllers have pfnum 0.
>> >
>> > > From patch 2:
>> > >
>> > > $ devlink port show pci/0000:00:08.0/2
>> > > pci/0000:00:08.0/2: type eth netdev eth7 controller 0 flavour pcivf
>> > > pfnum 0 vfnum 1 splittable false
>> > >   function:
>> > >     hw_addr 00:00:00:00:00:00
>> > >
>> > > $ devlink port show -jp pci/0000:00:08.0/2 {
>> > >     "port": {
>> > >         "pci/0000:00:08.0/1": {
>> > >             "type": "eth",
>> > >             "netdev": "eth7",
>> > >             "controller": 0,
>> > >             "flavour": "pcivf",
>> > >             "pfnum": 0,
>> > >             "vfnum": 1,
>> > >             "splittable": false,
>> > >             "function": {
>> > >                 "hw_addr": "00:00:00:00:00:00"
>> > >             }
>> > >         }
>> > >     }
>> > > }
>> > >
>> > > From earlier email:
>> > >
>> > > pci/0000:00:08.0/1: type eth netdev eth6 flavour pcipf pfnum 0
>> > > pci/0000:00:08.0/2: type eth netdev eth7 flavour pcipf pfnum 0
>> > >
>> > > If you never use pfnum, you can just put the controller ID there, like
>> Netronome.
>> > >
>> > It likely not going to work for us. Because pfnum is not some randomly
>> generated number.
>> > It is linked to the underlying PCI pf number. {pf0, pf1...}
>> > Orchestration sw uses this to identify representor of a PF-VF pair.
>> 
>> For orchestration software which is unaware of controllers ports will still alias
>> on pf/vf nums.
>>
>Yes.
>Orchestration which will be aware of controller, will use it.
> 
>> Besides you have one devlink instance per port currently so I'm guessing there is
>> no pf1 ever, in your case...
>>
>Currently there are multiple devlink instance. One for pf0, other for pf1.
>Ports of both instances have the same switch id.
> 
>> > Replacing pfnum with controller number breaks this; and it still doesn't tell user
>> that it's the pf on other_host.
>> 
>> Neither does the opaque controller id. 
>Which is why I tossed the epcipf (external pci pf) port flavour that fits in current model.
>But doesn't allow multiple external hosts under same eswitch for those devices which has same pci pf, vf numbers among those hosts. (and it is the case for mlnx).
>
>> Maybe now you understand better why I wanted peer objects :/
>>
>I wasn't against peer object. But showing netdev of peer object assumed no_smartnic, it also assume other_side is also similar Linux kernel.
>Anyways, I make humble request get over the past to move forward. :-)
>
>> > So it is used, and would like to continue to use even if there are multiple PFs
>> port (that has same pfnum) under the same eswitch.
>> >
>> > In an alternative,
>> > Currently we have pcipf, pcivf (and pcisf) flavours. May be if we introduce new
>> flavour say 'epcipf' to indicate external pci PF/VF/SF ports?
>> > There can be better name than epcipf. I just put epcipf to differentiate it.
>> > However these ports have same attributes as pcipf, pcivf, pcisf flavours.
>> 
>> I don't think the controllers are a terrible idea. Seems like a fairly reasonable
>> extension.
>Ok. 
>> But MLX don't seem to need them. And you have a history of trying to
>> make the Linux APIs look like your FW API.
>> 
>Because there are two devlink instances for each PF?
>I think for now an epcipf, epcivf flavour would just suffice due to lack of multiple devlink instances.
>But in long run it is better to have the controller covering few topologies.
>Otherwise we will break the rep naming later when multiple controllers are managed by single eswitch (without notion of controller).
>
>Sometime my text is confusing. :-) so adding example of the thoughts below.
>Example: Eswitch side devlink port show for multi-host setup considering the smartnic.
>
>$ devlink port show
>pci/0000:00:08.0/0: type eth netdev enp0s8f0 flavour physical
>pci/0000:00:08.0/1: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0
>pci/0000:00:08.0/2: type eth netdev enp0s8f0_c0pf0 flavour epcipf pfnum 0
>                                                                                                             ^^^^^ new port flavour.
>pci/0000:00:08.1/0: type eth netdev enp0s8f1 flavour physical
>pci/0000:00:08.1/1: type eth netdev enp0s8f1_pf1 flavour pcipf pfnum 1
>pci/0000:00:08.1/2: type eth netdev enp0s8f1_c0pf1 flavour epcipf pfnum 1
>
>Here one controller has two pci pfs (0,1}. Eswitch shows that they are external pci ports.
>Whenever (not sure when), mlnx converts to single devlink instance, this will continue to work.
>It will also work when multiple controller(s) (of external host) ports have same switch_id (for orchestration).
>And this doesn't break any backward compatibility for non multihost, non smatnic users.
>
>> Jiri, would you mind chiming in? What's your take?
>
>Will wait for his inputs..

I don't see the need for new flavour. The port is still pf same as the
local pf, it only resides on a different host. We just need to make sure
to resolve the conflict between PFX and PFX on 2 different hosts
(local/ext or ext/ext)

So I think that for local PFs, no change is needed.
The external PFs need to have an extra attribute with "external
enumeration" what would be used for the representor netdev name as well.

pci/0000:00:08.0/0: type eth netdev enp0s8f0 flavour physical
pci/0000:00:08.0/1: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0
pci/0000:00:08.0/2: type eth netdev enp0s8f0_e0pf0 flavour pcipf extnum 0 pfnum 0
pci/0000:00:08.0/3: type eth netdev enp0s8f0_e1pf0 flavour pcipf extnum 1 pfnum 0
