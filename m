Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C97258B41
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 11:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIAJRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 05:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgIAJRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 05:17:45 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75AAC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 02:17:44 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id f7so682360wrw.1
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 02:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iMSkBGE9G/pTTicvpZ8nTpn23bc0BGZR4QLWC9TzbvQ=;
        b=fUuo6k2MqOj4ZVQtnMVWz7dY3QYoXEcUw9DdFLsErAvQL0wHUiLvsP8uCTZMPCkNG9
         UnaLRrgxmDrwkdRbdstoCwKYXGe6siPiKKN+cF3v8l6wj8AN5Q0mn/sT534P7V5aNR5z
         40HBXeeVWOLPwNSMCz0ctHV/KLMAR8ZJ+J0o9HagpQi9gkvFTA9GE+6ICD4aG/KZKSRM
         Gnxr6tnOO/1Ai5a/U9MuDSSOLOYtPNbhTj8Oyw7y5pTb//oVjC4LSn8TTY5koHcgfeU9
         La0ysIqRU2Tywhy94JZF2DBTMaliIirzSfqlMf/1HMOgwNkouLzpB3UW83v1lav87q+k
         xPEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iMSkBGE9G/pTTicvpZ8nTpn23bc0BGZR4QLWC9TzbvQ=;
        b=KsSXXN+fNA+kxfETViW/jc5TrYJ6otWSWzjngcALi4F6pHhWN2w+aLwR6r5oV7ONrz
         qQECBl1oMAVVBgkHDNFAoS3BBFuTcwZdvZO6giv8fwpT0a5emgglSUdk7ivrWKqY4GDv
         +ZQuROowE2vEE5VsoWSiQaOHJAa4NsfYwEBdIn8QzOB4IMoRbuZw+Ycrh+UncHx1nqkr
         Wk/R3B3j3lbY+VVMj74iCcksb+0eeu2WifJfsORtg1BFVg7OJGQo4EzkVq8Ygf/6AOKU
         kv3ECInC6SbxWuhtm38c1sUOzVm97ZmKnP7g7NUnOcjWn6d9BRBoOyKx54caaEenWZLb
         rH6Q==
X-Gm-Message-State: AOAM532HoZW5vTxr+uJHmGBG5QrfvuwdJOQlhu86T2GkrqxUfJgJiuHj
        hXb8Ob4aq/dWrwfowrRiWGBt1tLY0PPw0xXb
X-Google-Smtp-Source: ABdhPJyK9HkfpDHPCYGE9vYpFZ5LGS3iBs01NjUJtgLB1U9Ghm/CZ6DG5MjxlLaUi+LxBVlcgttRJA==
X-Received: by 2002:a5d:554c:: with SMTP id g12mr835549wrw.294.1598951863563;
        Tue, 01 Sep 2020 02:17:43 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id q12sm1165793wrs.48.2020.09.01.02.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 02:17:43 -0700 (PDT)
Date:   Tue, 1 Sep 2020 11:17:42 +0200
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
Message-ID: <20200901091742.GF3794@nanopsycho.orion>
References: <20200826130747.4d886a09@kicinski-fedora-PC1C0HJN>
 <BY5PR12MB432276DBB3345AD328D787E4DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200827113216.7b9a3a25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43221CAA3D77DB7DB490B012DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200827144206.3c2cad03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB432271E4F9028831FA75B7E0DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200828094343.6c4ff16a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43220099C235E238D6AF89EADC530@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200901081906.GE3794@nanopsycho.orion>
 <BY5PR12MB43229CA19D3D8215BC9BEFECDC2E0@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB43229CA19D3D8215BC9BEFECDC2E0@BY5PR12MB4322.namprd12.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Sep 01, 2020 at 10:53:23AM CEST, parav@nvidia.com wrote:
>
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Tuesday, September 1, 2020 1:49 PM
>> 
>> >> > How? How do we tell that pfnum A means external system.
>> >> > Want to avoid such 'implicit' notion.
>> >>
>> >> How do you tell that controller A means external system?
>> 
>> Perhaps the attr name could be explicitly containing "external" word?
>> Like:
>> "ext_controller" or "extnum" (similar to "pfnum" and "vfnum") something
>> like that.
>
>How about ecnum "external controller number"?
>Tiny change in the phys_port_name below example.
>
>> 
>> 
>> >Which is why I started with annotating only external controllers, mainly to
>> avoid renaming and breaking current scheme for non_smartnic cases which
>> possibly is the most user base.
>> >
>> >But probably external pcipf/vf/sf port flavours are more intuitive combined
>> with controller number.
>> >More below.
>> >
>> >>
>> >> > > > > I can see how having multiple controllers may make things
>> >> > > > > clearer, but adding another layer of IDs while the one under
>> >> > > > > it is unused
>> >> > > > > (pfnum=0) feels very unnecessary.
>> >> > > > pfnum=0 is used today. not sure I understand your comment about
>> >> > > > being unused. Can you please explain?
>> >> > >
>> >> > > You examples only ever have pfnum 0:
>> >> > >
>> >> > Because both controllers have pfnum 0.
>> >> >
>> >> > > From patch 2:
>> >> > >
>> >> > > $ devlink port show pci/0000:00:08.0/2
>> >> > > pci/0000:00:08.0/2: type eth netdev eth7 controller 0 flavour
>> >> > > pcivf pfnum 0 vfnum 1 splittable false
>> >> > >   function:
>> >> > >     hw_addr 00:00:00:00:00:00
>> >> > >
>> >> > > $ devlink port show -jp pci/0000:00:08.0/2 {
>> >> > >     "port": {
>> >> > >         "pci/0000:00:08.0/1": {
>> >> > >             "type": "eth",
>> >> > >             "netdev": "eth7",
>> >> > >             "controller": 0,
>> >> > >             "flavour": "pcivf",
>> >> > >             "pfnum": 0,
>> >> > >             "vfnum": 1,
>> >> > >             "splittable": false,
>> >> > >             "function": {
>> >> > >                 "hw_addr": "00:00:00:00:00:00"
>> >> > >             }
>> >> > >         }
>> >> > >     }
>> >> > > }
>> >> > >
>> >> > > From earlier email:
>> >> > >
>> >> > > pci/0000:00:08.0/1: type eth netdev eth6 flavour pcipf pfnum 0
>> >> > > pci/0000:00:08.0/2: type eth netdev eth7 flavour pcipf pfnum 0
>> >> > >
>> >> > > If you never use pfnum, you can just put the controller ID there,
>> >> > > like
>> >> Netronome.
>> >> > >
>> >> > It likely not going to work for us. Because pfnum is not some
>> >> > randomly
>> >> generated number.
>> >> > It is linked to the underlying PCI pf number. {pf0, pf1...}
>> >> > Orchestration sw uses this to identify representor of a PF-VF pair.
>> >>
>> >> For orchestration software which is unaware of controllers ports will
>> >> still alias on pf/vf nums.
>> >>
>> >Yes.
>> >Orchestration which will be aware of controller, will use it.
>> >
>> >> Besides you have one devlink instance per port currently so I'm
>> >> guessing there is no pf1 ever, in your case...
>> >>
>> >Currently there are multiple devlink instance. One for pf0, other for pf1.
>> >Ports of both instances have the same switch id.
>> >
>> >> > Replacing pfnum with controller number breaks this; and it still
>> >> > doesn't tell user
>> >> that it's the pf on other_host.
>> >>
>> >> Neither does the opaque controller id.
>> >Which is why I tossed the epcipf (external pci pf) port flavour that fits in
>> current model.
>> >But doesn't allow multiple external hosts under same eswitch for those
>> devices which has same pci pf, vf numbers among those hosts. (and it is the
>> case for mlnx).
>> >
>> >> Maybe now you understand better why I wanted peer objects :/
>> >>
>> >I wasn't against peer object. But showing netdev of peer object assumed
>> no_smartnic, it also assume other_side is also similar Linux kernel.
>> >Anyways, I make humble request get over the past to move forward. :-)
>> >
>> >> > So it is used, and would like to continue to use even if there are
>> >> > multiple PFs
>> >> port (that has same pfnum) under the same eswitch.
>> >> >
>> >> > In an alternative,
>> >> > Currently we have pcipf, pcivf (and pcisf) flavours. May be if we
>> >> > introduce new
>> >> flavour say 'epcipf' to indicate external pci PF/VF/SF ports?
>> >> > There can be better name than epcipf. I just put epcipf to differentiate
>> it.
>> >> > However these ports have same attributes as pcipf, pcivf, pcisf flavours.
>> >>
>> >> I don't think the controllers are a terrible idea. Seems like a
>> >> fairly reasonable extension.
>> >Ok.
>> >> But MLX don't seem to need them. And you have a history of trying to
>> >> make the Linux APIs look like your FW API.
>> >>
>> >Because there are two devlink instances for each PF?
>> >I think for now an epcipf, epcivf flavour would just suffice due to lack of
>> multiple devlink instances.
>> >But in long run it is better to have the controller covering few topologies.
>> >Otherwise we will break the rep naming later when multiple controllers are
>> managed by single eswitch (without notion of controller).
>> >
>> >Sometime my text is confusing. :-) so adding example of the thoughts
>> below.
>> >Example: Eswitch side devlink port show for multi-host setup considering
>> the smartnic.
>> >
>> >$ devlink port show
>> >pci/0000:00:08.0/0: type eth netdev enp0s8f0 flavour physical
>> >pci/0000:00:08.0/1: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0
>> >pci/0000:00:08.0/2: type eth netdev enp0s8f0_c0pf0 flavour epcipf pfnum 0
>> >                                                                                                             ^^^^^ new port
>> flavour.
>> >pci/0000:00:08.1/0: type eth netdev enp0s8f1 flavour physical
>> >pci/0000:00:08.1/1: type eth netdev enp0s8f1_pf1 flavour pcipf pfnum 1
>> >pci/0000:00:08.1/2: type eth netdev enp0s8f1_c0pf1 flavour epcipf pfnum
>> >1
>> >
>> >Here one controller has two pci pfs (0,1}. Eswitch shows that they are
>> external pci ports.
>> >Whenever (not sure when), mlnx converts to single devlink instance, this
>> will continue to work.
>> >It will also work when multiple controller(s) (of external host) ports have
>> same switch_id (for orchestration).
>> >And this doesn't break any backward compatibility for non multihost, non
>> smatnic users.
>> >
>> >> Jiri, would you mind chiming in? What's your take?
>> >
>> >Will wait for his inputs..
>> 
>> I don't see the need for new flavour. The port is still pf same as the local pf, it
>> only resides on a different host. We just need to make sure to resolve the
>> conflict between PFX and PFX on 2 different hosts (local/ext or ext/ext)
>> 
>Yes. I agree. I do not have strong opinion on new flavour as long as we make clear that this is for the external controller.
>
>> So I think that for local PFs, no change is needed.
>Yep.
>
>> The external PFs need to have an extra attribute with "external
>> enumeration" what would be used for the representor netdev name as well.
>> 
>> pci/0000:00:08.0/0: type eth netdev enp0s8f0 flavour physical
>> pci/0000:00:08.0/1: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0
>> pci/0000:00:08.0/2: type eth netdev enp0s8f0_e0pf0 flavour pcipf extnum 0
>> pfnum 0
>
>How about a prefix of "ec" instead of "e", like?
>pci/0000:00:08.0/2: type eth netdev enp0s8f0_ec0pf0 flavour pcipf ecnum 0 pfnum 0

Yeah, looks fine to me. Jakub?


>                                                                                     ^^^^
>> pci/0000:00:08.0/3: type eth netdev enp0s8f0_e1pf0 flavour pcipf extnum 1
>> pfnum 0
>
