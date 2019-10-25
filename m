Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA742E4FB3
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440559AbfJYO6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:58:20 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33363 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440556AbfJYO6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 10:58:20 -0400
Received: by mail-wr1-f68.google.com with SMTP id s1so2730302wro.0
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 07:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zWtmQgZd9qbJzOqM2DSwxug87rUgvdTiQSkRKil1cAM=;
        b=U0YuSm4Pg1mbO4rxc8yp+n9GA0EVAzVT1Ghjs8X+pc/WQBi1fp79leUbj6Ln+w5O8u
         /JuMQu+44P0qrUd3cqYVjJiofWXv79fH88GzpPr3fXkbj2VCoSHOKe10Sx4Id2oam7vJ
         p5InUFoUNKDsLUjbVvFzEaJtpihRTFgrj4mqk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zWtmQgZd9qbJzOqM2DSwxug87rUgvdTiQSkRKil1cAM=;
        b=MfG1oNR8ASEK0vsWAtpUnY1DOJrINMJDc/3qV8+zVbIq+SEjAD/LOxJ1gQDrvJmX/Q
         mrZqI7Yxztv6N9U8GjXH4YfVT8UDmYE8bgUDhqUAsi00ZsdyCx2S3hT+9nyZ/FIXwUyK
         BOR1XbokPDpotLyDzayABhr9aSmk4My9EqdibTuJIR2FG0PMx4y8XCA86EW5zcVB7b9g
         1BpA8yU6wt79kuvELcPqj5dL+8FkFADuu7w4XIM/RP43j1HXVkRS9oCRddDQuCe5al23
         ZdouSYWgdp1uYd0uB1nw4XvX9/AmJva4wlgIOJijkUsbJspUV7ujZvQ+8t7/3lKxpdCk
         wJvA==
X-Gm-Message-State: APjAAAWwXAKmDWIHIsQK2OxOfRIAg4RdPG2Vhr/o7Ao3DamIGjDyjoA3
        MEOgef9f4tPYavz5ddNRiPshxQ==
X-Google-Smtp-Source: APXvYqyl0n3QkHv3N54N7r/a7DJmOwf7FZczcIrjlSYG775k9E8BjEtFCRHVIsW09ISLObQs1/5F5w==
X-Received: by 2002:adf:ea50:: with SMTP id j16mr3348843wrn.295.1572015498451;
        Fri, 25 Oct 2019 07:58:18 -0700 (PDT)
Received: from C02YVCJELVCG.dhcp.broadcom.net ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id d8sm2146190wrr.71.2019.10.25.07.58.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 07:58:17 -0700 (PDT)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Fri, 25 Oct 2019 10:58:08 -0400
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Yuval Avnery <yuvalav@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Daniel Jurgens <danielj@mellanox.com>,
        andrew.gospodarek@broadcom.com,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 0/9] devlink vdev
Message-ID: <20191025145808.GA20298@C02YVCJELVCG.dhcp.broadcom.net>
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
 <20191023120046.0f53b744@cakuba.netronome.com>
 <20191023192512.GA2414@nanopsycho>
 <20191023151409.75676835@cakuba.hsd1.ca.comcast.net>
 <9f3974a1-95e9-a482-3dcd-0b23246d9ab7@mellanox.com>
 <20191023195141.48775df1@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023195141.48775df1@cakuba.hsd1.ca.comcast.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 07:51:41PM -0700, Jakub Kicinski wrote:
> On Thu, 24 Oct 2019 00:11:48 +0000, Yuval Avnery wrote:
> > >>> We need some proper ontology and decisions what goes where. We have
> > >>> half of port attributes duplicated here, and hw_addr which honestly
> > >>> makes more sense in a port (since port is more of a networking
> > >>> construct, why would ep storage have a hw_addr?). Then you say you're
> > >>> going to dump more PCI stuff in here :(  
> > >> Well basically what this "vdev" is is the "port peer" we discussed
> > >> couple of months ago. It provides possibility for the user on bare metal
> > >> to cofigure things for the VF - for example.
> > >>
> > >> Regarding hw_addr vs. port - it is not correct to make that a devlink
> > >> port attribute. It is not port's hw_addr, but the port's peer hw_addr.  
> > > Yeah, I remember us arguing with others that "the other side of the
> > > wire" should not be a port.
> > >  
> > >>> "vdev" sounds entirely meaningless, and has a high chance of becoming
> > >>> a dumping ground for attributes.  
> > >> Sure, it is a madeup name. If you have a better name, please share.  
> > > IDK. I think I started the "peer" stuff, so it made sense to me.
> > > Now it sounds like you'd like to kill a lot of problems with this
> > > one stone. For PCIe "vdev" is def wrong because some of the config
> > > will be for PF (which is not virtual). Also for PCIe the config has
> > > to be done with permanence in mind from day 1, PCI often requires
> > > HW reset to reconfig.
> >
> > The PF is "virtual" from the SmartNic embedded CPU point of view.
> 
> We also want to configure PCIe on local host thru this in non-SmartNIC
> case, having the virtual in the name would be confusing there.
> 
> > Maybe gdev is better? (generic)
> 
> Let's focus on the scope and semantics of the object we are modelling
> first. Can we talk goals, requirements, user scenarios etc.?
> 
> IMHO the hw_addr use case is kind of weak, clouds usually do tunnelling
> so nobody cares which MAC customer has assigned in the overlay.
> 
> CCing Andy and Michael from Broadcom for their perspective and
> requirements.

Thanks, Jakub, I'm happy to chime in based on our deployment experience.
We definitely understand the desire to be able to configure properties
of devices on the SmartNIC (the kind with general purpose cores not the
kind with only flow offload) from the server side.

In addition to addressing NVMe devices, I'd also like to be be able to
create virtual or real serial ports as well as there is an interest in
*sometimes* being able to gain direct access to the SmartNIC console not
just a shell via ssh.  So my point is that there are multiple use-cases.

Arm are also _extremely_ interested in developing a method to enable
some form of SmartNIC discovery method and while lots of ideas have been
thrown around, discovery via devlink is a reasonable option.  So while
doing all this will be much more work than simply handling this case
where we set the peer or local MAC for a vdev, I think it will be worth
it to make this more usable for all^W more types of devices.  I also
agree that not everything on the other side of the wire should be a
port. 

So if we agree that addressing this device as a PCIe device then it
feels like we would be better served to query device capabilities and
depending on what capabilities exist we would be able to configure
properties for those.  In an ideal world, I could query a device using
devlink ('devlink info'?) and it would show me different devices that
are available for configuration on the SmartNIC and would also give me a
way to address them.  So while I like the idea of being able to address
and set parameters as shown in patch 05 of this series, I would like to
see a bit more flexibility to define what type of device is available
and how it might be configured.

So if we took the devlink info command as an example (whether its the
proper place for this or not), it could look _like_ this:

$ devlink dev info pci/0000:03:00.0
pci/0000:03:00.0:
  driver foo
  serial_number 8675309
  versions:
[...]
  capabilities:
      storage 0
      console 1
      mdev 1024
      [something else] [limit]

(Additionally rather than putting this as part of 'info' the device
capabilities and limits could be part of the 'resource' section and
frankly may make more sense if this is part of that.)

and then those capabilities would be something that could be set using the
'vdev' or whatever-it-is-named interface:

# devlink vdev show pci/0000:03:00.0
pci/0000:03:00.0/console/0: speed 115200 device /dev/ttySNIC0
pci/0000:03:00.0/mdev/0: hw_addr 02:00:00:00:00:00
[...]
pci/0000:03:00.0/mdev/1023: hw_addr 02:00:00:00:03:ff

# devlink vdev set pci/0000:03:00.0/mdev/0 hw_addr 00:22:33:44:55:00

Since these Arm/RISC-V based SmartNICs are going to be used in a variety
of different ways and will have a variety of different personalities
(not just different SKUs that vendors will offer but different ways in
which these will be deployed), I think it's critical that we consider
more than just the mdev/representer case from the start.

> > >> Basically it is something that represents VF/mdev - the other side of
> > >> devlink port. But in some cases, like NVMe, there is no associated
> > >> devlink port - that is why "devlink port peer" would not work here.  
> > > What are the NVMe parameters we'd configure here? Queues etc. or some
> > > IDs? Presumably there will be a NVMe-specific way to configure things?
> > > Something has to point the NVMe VF to a backend, right?
> > >
> > > (I haven't looked much into NVMe myself in case that's not obvious ;))  
