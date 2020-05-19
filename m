Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF641D9342
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 11:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgESJXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 05:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbgESJXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 05:23:04 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D508C061A0C
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 02:23:03 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id m12so2306665wmc.0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 02:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vYxbhd/mt9+GDYYOMuiR2yir2/arqLo8Ru+Ly7IKlMo=;
        b=frmUtgucp8t+03l64Dp/y+YNiBWK6lbzBlBa9I2+QgiU5cjdjtyLqvCpeS7yY9Qhth
         +XL8I7HRrG6k3CSY0xeCJJLoo42jJdxdAkxfe2PNx+9cOa7EfyAEAo+DaAcrFVSTx2Tf
         BN8EIrzV/LEXcpm1w+d8ED/6s5HiZyQywt8NIHWrCgjKCUhB/yOtzkpaINK+qaB4etDK
         HHI6GsF/l4duck/TtUcvc1NB80zgQRiRVCWaPIcXMU40KYgl4n8h1rsZveILJg0WFnfU
         pe2Efi0FAyoqj2LFGf+ViZ5PgelLjLSBTzAu4CkGeKuJmVG9F0oYsepc/ebFS0ZuY/mz
         v/gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vYxbhd/mt9+GDYYOMuiR2yir2/arqLo8Ru+Ly7IKlMo=;
        b=qVHvKUB6nWe/Z0+CcNSEo5aaJTaRQGk/tYvGLQ9EiGnaJ2nIprp5SKdtvUNsritN8M
         39I7TBgjVDAaIHCAbcsUxfOhmtbOusPUO6Qqj1yx5Ge/XcHo+ODySHN3chklsPLqsUJE
         yA4A/buXkcTlfM4TbUzwkd38mQn/BRpXaxn+dllH5csHOVeLA3bfAB/Sn5oShN8B7O20
         1CyEaCg3/+y6i3zqg4EKAYAhE0qTLOXK6/Ssh5+3WhHz/byQjjrY4fC4qHHlBqQn1OA5
         TUj4vL0dnWO0lyCJiNnDTiSRIywOyHmJRf7eo63Ji16Xh3iZcEHx7CHg9wSRI77kBDrT
         XyWQ==
X-Gm-Message-State: AOAM533b+hUZSQGH1tB4/mFkosy/Nqh8sQgh0k8NhViw/U5e7j+bAUNo
        Lijvw+4mUb2R2tIiUhxS5eS+IyIkY0U=
X-Google-Smtp-Source: ABdhPJxyEdk6ULcblOY7i2A0V5uG0bJEDU1C3uErfk29X/CEwo5abESfWtde6Wvbrsy2ym0U2db6hQ==
X-Received: by 2002:a7b:cfc9:: with SMTP id f9mr4325550wmm.107.1589880180065;
        Tue, 19 May 2020 02:23:00 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a74sm3285031wme.23.2020.05.19.02.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 02:22:59 -0700 (PDT)
Date:   Tue, 19 May 2020 11:22:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, parav@mellanox.com,
        yuvalav@mellanox.com, jgg@ziepe.ca, saeedm@mellanox.com,
        leon@kernel.org, andrew.gospodarek@broadcom.com,
        michael.chan@broadcom.com, moshe@mellanox.com, ayal@mellanox.com,
        eranbe@mellanox.com, vladbu@mellanox.com, kliteyn@mellanox.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        tariqt@mellanox.com, oss-drivers@netronome.com,
        snelson@pensando.io, drivers@pensando.io, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, grygorii.strashko@ti.com,
        mlxsw@mellanox.com, idosch@mellanox.com, markz@mellanox.com,
        jacob.e.keller@intel.com, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, sridhar.samudrala@intel.com
Subject: [RFC v3] current devlink extension plan for NICs
Message-ID: <20200519092258.GF4655@nanopsycho>
References: <20200501091449.GA25211@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501091449.GA25211@nanopsycho.orion>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all.

First, I would like to apologize for very long email. But I think it
would be beneficial to the see the whole picture, where we are going.

Currently we are working internally on several features with
need of extension of the current devlink infrastructure. I took a stab
at putting it all together in a single txt file, inlined below.

Most of the stuff is based on a new port sub-object called "func"
(called "slice" previously" and "subdev" originally in Yuval's patchsets
sent some while ago).

The text describes how things should behave and provides a draft
of user facing console input/outputs. I think it is important to clear
that up before we go in and implement the devlink core and
driver pieces.

I would like to ask you to read this and comment. Especially, I would
like to ask vendors if what is described fits the needs of your
NIC/e-switch.

Please note that something is already implemented, but most of this
isn't (see "what needs to be implemented" section).

v2->v3:
- fixed s/SF0/SF10/ typo
- added sfnum auto alloc option
- added brief SF description
- adjusted the PF section:
   - added smartnic usecase examples of dumb/nested-switch scenarios
   - added explanation of 2 models of handling PFs (Netronome/Mellanox)

v1->v2:
- mainly move from separate slice object into port/func subobject
- couple of small fixes here and there


==================================================================
||                                                              ||
||            Overall illustration of example setup             ||
||                                                              ||
==================================================================

Note that there are 2 hosts in the picture. Host A may be the smartnic host,
Host B may be one of the hosts which gets PF. Also, you might omit
the Host B and just see Host A like an ordinary nic in a host.

Note that the PF is merged with physical port representor.
That is due to simpler and flawless transition from legacy mode and back.
The devlink_ports and netdevs for physical ports are staying during
the transition.

                        +-----------+
                        |phys port 2+-----------------------------------+
                        +-----------+                                   |
                        +-----------+                                   |
                        |phys port 1+---------------------------------+ |
                        +-----------+                                 | |
                                                                      | |
+------------------------------------------------------------------+  | |
|  devlink instance for the whole ASIC                   HOST A    |  | |
|                                                                  |  | |
|  pci/0000:06:00.0  (devlink dev)                                 |  | |
|  +->health reporters, params, info, sb, dpipe,                   |  | |
|  |  resource, traps                                              |  | |
|  |                                                               |  | |
|  +-+port_pci/0000:06:00.0/0+-------------------------------------|--+ |
|  | |  flavour physical pfnum 0  (phys port and pf)               |    |
|  | |  netdev enp6s0f0np1                                         |    |
|  | +->health reporters, params                                   |    |
|  |                                                               |    |
|  +-+port_pci/0000:06:00.0/1+-------------------------------------|----+
|  | |  flavour physical pfnum 1  (phys port and pf)               |
|  | |  netdev enp6s0f0np2                                         |
|  | +->health reporters, params                                   |
|  |                                                               |
|  +-+port_pci/0000:06:00.0/2+---------------------------------+   |
|  | |  flavour pcipf pfnum 2                                  |   |
|  | |  netdev enp6s0f0pf2                                     |   |
|  | +->params                                                 |   |
|  | +->func                                                   |   |
|  |                                                           |   |
|  +-+port_pci/0000:06:00.0/3+------------------------------+  |   |
|  | |  flavour pcivf pfnum 2 vfnum 0                       |  |   |
|  | |  netdev enp6s0pf2vf0                                 |  |   |
|  | +->params                                              |  |   |
|  | +-+func                                                |  |   |
|  |   +->state, rate (qos), mpgroup, hw_addr               |  |   |
|  |                                                        |  |   |
|  +-+port_pci/0000:06:00.0/4+---------------------------+  |  |   |
|  | |  flavour pcivf pfnum 0 vfnum 0                    |  |  |   |
|  | |  netdev enp6s0pf0vf0                              |  |  |   |
|  | +->params                                           |  |  |   |
|  | +-+func                                             |  |  |   |
|  |   +->state, rate (qos), mpgroup, hw_addr            |  |  |   |
|  |                                                     |  |  |   |
|  +-+port_pci/0000:06:00.0/5+------------------------+  |  |  |   |
|  | |  flavour pcisf pfnum 0 sfnum 1                 |  |  |  |   |
|  | |  netdev enp6s0pf0sf1                           |  |  |  |   |
|  | +->params                                        |  |  |  |   |
|  | +-+func                                          |  |  |  |   |
|  |   +->state, rate (qos), mpgroup, hw_addr         |  |  |  |   |
|  |                                                  |  |  |  |   |
|  +-+port_pci/0000:06:00.0/6+-------=-------------+  |  |  |  |   |
|    |  flavour pcivf pfnum 0 vfnum 1              |  |  |  |  |   |
|    |        (non-ethernet (IB, NVME)             |  |  |  |  |   |
|    +-+func                                       |  |  |  |  |   |
|      +->state                                    |  |  |  |  |   |
|                                                  |  |  |  |  |   |
+------------------------------------------------------------------+
                                                   |  |  |  |  |
                                                   |  |  |  |  |
                                                   |  |  |  |  |
+----------------------------------------------+   |  |  |  |  |
|  devlink instance PF (other host)    HOST B  |   |  |  |  |  |
|                                              |   |  |  |  |  |
|  pci/0000:10:00.0  (devlink dev)             |   |  |  |  |  |
|  +->health reporters, info                   |   |  |  |  |  |
|  |                                           |   |  |  |  |  |
|  +-+port_pci/0000:10:00.0/1+---------------------------------+
|    |  flavour virtual                        |   |  |  |  |
|    |  netdev enp16s0f0                       |   |  |  |  |
|    +->health reporters                       |   |  |  |  |
|                                              |   |  |  |  |
+----------------------------------------------+   |  |  |  |
                                                   |  |  |  |
+----------------------------------------------+   |  |  |  |
|  devlink instance VF (other host)    HOST B  |   |  |  |  |
|                                              |   |  |  |  |
|  pci/0000:10:00.1  (devlink dev)             |   |  |  |  |
|  +->health reporters, info                   |   |  |  |  |
|  |                                           |   |  |  |  |
|  +-+port_pci/0000:10:00.1/1+------------------------------+
|    |  flavour virtual                        |   |  |  |
|    |  netdev enp16s0f0v0                     |   |  |  |
|    +->health reporters                       |   |  |  |
|                                              |   |  |  |
+----------------------------------------------+   |  |  |
                                                   |  |  |
+----------------------------------------------+   |  |  |
|  devlink instance VF                 HOST A  |   |  |  |
|                                              |   |  |  |
|  pci/0000:06:00.1  (devlink dev)             |   |  |  |
|  +->health reporters, info                   |   |  |  |
|  |                                           |   |  |  |
|  +-+port_pci/0000:06:00.1/1+---------------------------+
|    |  flavour virtual                        |   |  |
|    |  netdev enp6s0f0v0                      |   |  |
|    +->health reporters                       |   |  |
|                                              |   |  |
+----------------------------------------------+   |  |
                                                   |  |
+----------------------------------------------+   |  |
|  devlink instance SF                 HOST A  |   |  |
|                                              |   |  |
|  pci/0000:06:00.0%sf1    (devlink dev)       |   |  |
|  +->health reporters, info                   |   |  |
|  |                                           |   |  |
|  +-+port_pci/0000:06:00.0%sf1/1+--------------------+
|    |  flavour virtual                        |   |
|    |  netdev enp6s0f0s1                      |   |
|    +->health reporters                       |   |
|                                              |   |
+----------------------------------------------+   |
                                                   |
+----------------------------------------------+   |
|  devlink instance VF                 HOST A  |   |
|                                              |   |
|  pci/0000:06:00.2  (devlink dev)+----------------+
|  +->health reporters, info                   |
|                                              |
+----------------------------------------------+




==================================================================
||                                                              ||
||                 what needs to be implemented                 ||
||                                                              ||
==================================================================

1) physical port "pfnum". When PF and physical port representor
   are merged, the instance of devlink_port representing the physical port
   and PF needs to have "pfnum" attribute to be in sync
   with other PF port representors.

2) per-port health reporters are not implemented yet.

3) devlink_port instance in PF/VF/SF flavour "virtual". In PF/VF/SF devlink
   instance (in VM for example), there would make sense to have devlink_port
   instance. At least to carry link to netdevice name (otherwise we have
   no easy way to find out devlink instance and netdevice belong to each other).
   I was thinking about flavour name, we have to distinguish from eswitch
   devlink port flavours "pcipf, pcivf, pcisf".

   This was recently implemented by Parav:
commit 0a303214f8cb8e2043a03f7b727dba620e07e68d
Merge: c04d102ba56e 162add8cbae4
Author: David S. Miller <davem@davemloft.net>
Date:   Tue Mar 3 15:40:40 2020 -0800

    Merge branch 'devlink-virtual-port'

   What is missing is the "virtual" flavour for nested PF.

4) port func is not implemented yet. This is the original "vdev/subdev" concept.
   See below section "Port func user cmdline API draft".

5) SFs are not implemented.
   See below section "SF (subfunction) user cmdline API draft".

6) rate for port func are not implemented yet.
   See below section "Port func rate user cmdline API draft".

7) mpgroup for port func is not implemented yet.
   See below section "Port func mpgroup user cmdline API draft".

8) VF manual creation using devlink is not implemented yet.
   See below section "VF manual creation and activation user cmdline API draft".
 
9) PF aliasing. One devlink instance and multiple PFs sharing it as they have one
   merged e-switch.

10) Exposing maximum number of SF ports as devlink resource.            

11) Configuring more port/func capabilities (netdevice, rdma device,
    nested eswitch) and resources (irq, queues, pages). 



==================================================================
||                                                              ||
||                  Issues/open questions                       ||
||                                                              ||
==================================================================

1) "pfnum" has to be per-asic(/devlink instance), not per-host.
   That means that in smartNIC scenario, we cannot have "pfnum 0"
   for smartNIC and "pfnum 0" for host as well.
   
2) Q: for TX, RX queues reporters, should it be bound to devlink_port?
   For which flavours this might make sense?
   Most probably for flavours "physical"/"virtual".
   How about the reporters in VF/SF?

3) How the management of nested switch is handled. The PFs created dynamically
   or the ones in hosts in smartnic scenario may themselves be each a manager
   of nested e-switch. How to toggle this capability?
   During creation by a cmdline option?
   During lifetime in case the PF does not have any childs (VFs/SFs)?

   It seems to make sense to have it configurable as a port/func attribute
   for PF port/func objects.

   It might make sense to have it configurable as a port/func attribute
   for PF port/func objects. User would set this before he activates the func.



==================================================================
||                                                              ||
||             Port func user cmdline API draft                 ||
||                                                              ||
==================================================================

Note that some of the "devlink port" attributes may be forgotten or misordered.

Funcs are created as sub-objects of ports where it makes sense to have them
The driver takes care of that. The "func" is a handle to configure "the other
side of the wire". The original port object has port leve properties,
the new "func" sub-object on the other hand has device level properties".

This is example for the HOST A from the example above:

$ devlink port show
pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
pci/0000:06:00.0/2: flavour pcipf pfnum 2 type eth netdev enp6s0pf2
                    func: hw_addr 10:22:33:44:55:66 state active
pci/0000:06:00.0/3: flavour pcivf pfnum 2 vfnum 0 type eth netdev enp6s0pf2vf0
                    func: hw_addr 10:22:33:44:55:77 state active
pci/0000:06:00.0/4: flavour pcivf pfnum 0 vfnum 0 type eth netdev enp6s0pf0vf0
                    func: hw_addr 10:22:33:44:55:88 state active
pci/0000:06:00.0/5: flavour pcisf pfnum 0 sfnum 1 type eth netdev enp6s0pf0sf1
                    func: hw_addr 10:22:33:44:55:99 state active
pci/0000:06:00.0/6: flavour pcivf pfnum 1 vfnum 2 type nvme
                    func: state active

There is a fixed "state" attribute with value "active". This is by
default as the VFs are always created active. In future, it is planned
to implement manual VF creation and activation, similar to what is below
described for SFs.

Now set a different MAC address for VF1 on PF0:

$ devlink port func set pci/0000:06:00.0/3 hw_addr aa:bb:cc:dd:ee:ff

$ devlink port show
pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
pci/0000:06:00.0/2: flavour pcipf pfnum 2 type eth netdev enp6s0pf2
                    func: hw_addr 10:22:33:44:55:66 state active
pci/0000:06:00.0/3: flavour pcivf pfnum 2 vfnum 0 type eth netdev enp6s0pf2vf0
                    func: hw_addr aa:bb:cc:dd:ee:ff state active
pci/0000:06:00.0/4: flavour pcivf pfnum 0 vfnum 0 type eth netdev enp6s0pf0vf0
                    func: hw_addr 10:22:33:44:55:88 state active
pci/0000:06:00.0/5: flavour pcisf pfnum 0 sfnum 1 type eth netdev enp6s0pf0sf1
                    func: hw_addr 10:22:33:44:55:99 state active
pci/0000:06:00.0/6: flavour pcivf pfnum 1 vfnum 2 type nvme
                    func: state active



==================================================================
||                                                              ||
||          SF (subfunction) user cmdline API draft             ||
||                                                              ||
==================================================================

Subfunctions are more light weight than VFs. They share the same PCI device
(BAR, IRQs) as that of PF/VF on which it is deployed. Unlike VFs which are
enabled/disabled in bulk, subfunctions are created, deployed in unit of 1.

Note that some of the "devlink port" attributes may be forgotten,
misordered or omitted on purpose.

$ devlink port show
pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 type eth netdev enp6s0pf0vf0
                    func: hw_addr 10:22:33:44:55:66 state active

There is one VF on the NIC.

Now create subfunction of SF10 on PF1, index of the port is going to be 100:

$ devlink port add pci/0000.06.00.0/100 flavour pcisf pfnum 1 sfnum 10

The devlink kernel code calls down to device driver (devlink op) and asks
it to create a SF port. Driver then instantiates the SF port in the same
way it is done for VF.


Note that it may be possible to avoid passing port index and let the
kernel assign index for you:
$ devlink port add pci/0000.06.00.0 flavour pcisf pfnum 1 sfnum 10

This would work in a similar way as devlink region id assignment that
is being pushed now.

Moreover, it may be possible to avoid passing sfnum as well and let
the kernel assign it for you as well:
$ devlink port add pci/0000.06.00.0 flavour pcisf pfnum 1


Set the func hw_address to aa:bb:cc:aa:bb:cc:

$ devlink port func set pci/0000.06.00.0/100 hw_addr aa:bb:cc:aa:bb:cc

$ devlink port show
pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 type eth netdev enp6s0pf0vf0
    func: hw_addr 10:22:33:44:55:66 state active
pci/0000:06:00.0/100: flavour pcisf pfnum 1 sfnum 10 type eth netdev enp6s0pf1sf10
    func: hw_addr aa:bb:cc:aa:bb:cc state inactive


Note that the SF port is created but not active. That means the
entities are created on devlink side, the e-switch port representor
is created, but the SF device itself it not yet out there (same host
or different, depends on where the parent PF is - in this case the same host).
User might use e-switch port representor enp6s0pf1sf10 to do settings,
putting it into bridge, adding TC rules, etc.
It's like the cable is unplugged on the other side.


Now we activate (deploy) the SF port/func:
$ devlink port func set pci/0000:06:00.0/100 state active

$ devlink port show
pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 type eth netdev enp6s0pf0vf0
    func: hw_addr 10:22:33:44:55:66 state active
pci/0000:06:00.0/100: flavour pcisf pfnum 1 sfnum 10 type eth netdev enp6s0pf1sf10
    func: hw_addr aa:bb:cc:aa:bb:cc state active

Upon the activation, the device driver asks the device to instantiate
the actual SF device on particular PF. Does not matter if that is
on the same host or not.

On the other side, the PF driver instance gets the event from device
that particular SF was activated. It's the cue to put the device on bus
probe it and instantiate netdev and devlink instances for it.

For every SF a device is created on virtbus with an ID assigned by the
virtbus code. For example:
/sys/bus/virtbus/devices/mlx5_sf.1

$ cat /sys/bus/virtbus/devices/mlx5_sf.1/sfnum
10

/sys/bus/virtbus/devices/mlx5_sf.1 is a symlink to:
../../../devices/pci0000:00/0000:00:03.0/0000:06:00.0/mlx5_sf.1

New devlink instance is named using alias:
$ devlink dev show
pci/0000:06:00.0%sf10

$ devlink port show
pci/0000:06:00.0%sf10/0: flavour virtual type eth netdev netdev enp6s0f0s10

You see that the udev used the sysfs files and symlink to assemble netdev name.

Note that this kind of aliasing is not implemented. Needs to be done in
devlink code in kernel. During SF devlink instance creation, there should
be passed parent PF device pointer and sfnum from which the alias dev_name
is assembled. This ensures persistent naming consistent in both smartnic
and host usecase.

If the user on smartnic or host does not want the virtbus device to get
probed automatically (for any reason), he can do it by:

$ echo "0" > /sys/bus/virtbus/drivers_autoprobe

This is enabled by default.


User can deactivate the SF port/func by:

$ devlink port func set pci/0000:06:00.0/100 state inactive

This eventually leads to event delivered to PF driver, which is a
cue to remove the SF device from virtbus and remove all related devlink
and netdev instances.

The port/func may be activated again.

Now on the teardown process, user might either remove the SF port
right away, without deactivation. However, it is possible to remove
deactivated SF too. To remove the SF, user should do:

$ devlink port del pci/0000:06:00.0/100

$ devlink port show
pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 type eth netdev enp6s0pf0vf0
    func: hw_addr 10:22:33:44:55:66 state active



==================================================================
||                                                              ||
||   VF manual creation and activation user cmdline API draft   ||
||                                                              ||
==================================================================

To enter manual mode, the user has to turn off VF dummies creation:
$ devlink dev set pci/0000:06:00.0 vf_dummies disabled
$ devlink dev show
pci/0000:06:00.0: vf_dummies disabled

It is "enabled" by default in order not to break existing users.

By setting the "vf_dummies" attribute to "disabled", the driver
removes all dummy VFs. Only physical ports are present:

$ devlink port show
pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2

Then the user is able to create them in a similar way as SFs:

$ devlink port add pci/0000:06:00.0/99 flavour pcivf pfnum 1 vfnum 8

The devlink kernel code calls down to device driver (devlink op) and asks
it to create a VF port with particular attributes. Driver then instantiates
the VF port with func.

Set the func hw_address to aa:bb:cc:aa:bb:cc:
$ devlink port func set pci/0000:06:00.0/99 hw_addr aa:bb:cc:aa:bb:cc

$ devlink port show
pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
pci/0000:06:00.0/99: flavour pcivf pfnum 1 vfnum 8 type eth netdev enp6s0pf1vf8
    func: hw_addr aa:bb:cc:aa:bb:cc state inactive

Now we activate (deploy) the VF:
$ devlink port func set pci/0000:06:00.0/99 state active

$ devlink port show
pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
pci/0000:06:00.0/99: flavour pcivf pfnum 1 vfnum 8 type eth netdev enp6s0pf1vf8
    func: hw_addr aa:bb:cc:aa:bb:cc state active



==================================================================
||                                                              ||
||                             PFs                              ||
||                                                              ||
==================================================================

There are 2 flavours of PFs:
1) "Parent" PF. That is coupled with uplink port. The flavour is:
    a) "physical" - in case the uplink port is actual port in the NIC.
    b) "virtual" - in case this "Parent" PF is actually a leg to
       upstream embedded switch.

   "Parent" PFs are the ones that may be in control of managing
   embedded switch, on any hierarchy level.

   In case of the SmartNIC scenario, this PF resides on the SmartNIC CPU.

   $ devlink port show
   pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1

   There are 2 cases possible for 2 port NIC:
   a) Same PF for both ports (Netronome model):
      one PF - 0000:06:00.0

      $ devlink port show
      pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
      pci/0000:06:00.0/1: flavour physical pfnum 0 type eth netdev enp6s0f0np2

   b) Separate per-port PF (Mellanox model):
      two PFs - 0000:06:00.0, 0000:06:00.1
      They both share the same embedded switch, the aliasing is established
      for devlink handles:
      pci/0000:06:00.0
      pci/0000:06:00.1
      are equivalents, pointing to the same devlink instance.

      $ devlink port show
      pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
      pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f1np2

2) "Child" PF. This is a leg of a PF put to the "parent" PF. It is
   represented by a port a port with a netdevice and func:

   In case of the SmartNIC scenario, this PF resides on the host.

   $ devlink port show
   pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
   pci/0000:06:00.0/1: flavour pcipf pfnum 2 type eth netdev enp6s0f0pf2
       func: hw_addr aa:bb:cc:aa:bb:87 state active

   This is a typical smartnic scenario. You would see this list on
   the smartnic CPU. The port pci/0000:06:00.0/1 is a leg to
   one of the hosts. If you send packets to enp6s0f0pf2, they will
   go to the "child" PF.

   Note that inside the host, the PF is represented again as "Parent PF"
   and may be used to configure nested embedded switch.


Parent PF on a host in SmartNIC usecase:

There are 2 possible scenarios in this case:
1) Have the "simple dumb" PF, which just exposes 1 netdev for host to
   run traffic over. SmartNIC CPU manages the VFs/SFs and sees the
   devlink ports for them. This is 1 level switch - merged switch.

2) PF manages a sub-switch/nested-switch. The devlink/devlink ports are
   created on the host and the devlink ports for SFs/VFs are created
   there. This is multi-level eswitch. Each "child" PF on a parent
   manages a nested switch. And could in theory have other PF "child" with
   another nested switch.

   The PF parent sets this "nested-switch management" configuration
   on the "child PF" devlink port on SmartNIC CPU side.


==================================================================
||                                                              ||
||           Port func operational state extension              ||
||                                                              ||
==================================================================

In addition to the "state" attribute that serves for the purpose
of setting the "admin state", there is "opstate" attribute added to
reflect the operational state of the port/func:


    opstate                description
    -----------            ------------
    1. attached    State when port/func devince is bound to the host
                   driver. When the func device is unbound from the
                   host driver, func device exits this state and
                   enters detaching state.

    2. detaching   State when host is notified to deactivate the
                   func device and func device may be undergoing
                   detachment from host driver. When func device is
                   fully detached from the host driver, func exits
                   this state and enters detached state.

    3. detached    State when driver is fully unbound, it enters
                   into detached state.

func state machine:
-------------------
                               func state set inactive
                              ----<------------------<---
                              | or port delete          |
                              |                         |
  __________              ____|_______              ____|_______
 |          |  port add  |            | func state |            |
 |          |-------->---|            |------>-----|            |
 | invalid  |            |  inactive  | set active |   active   |
 |          |  port del  |            |            |            |
 |__________|--<---------|____________|            |____________|



func operational state machine:
-------------------------------
  __________                ____________              ___________
 |          | func state   |            | driver bus |           |
 | invalid  |-------->-----|  detached  |------>-----| attached  |
 |          | set active   |            | probe()    |           |
 |__________|              |____________|            |___________|
                                 |                        |
                                 ^                    func set
                                 |                    inactive
                            successful detach             |
                              or pf reset                 |
                             ____|_______                 |
                            |            | driver bus     |
                 -----------| detaching  |---<-------------
                 |          |            | remove()
                 ^          |____________|
                 |   timeout      |
                 --<---------------



==================================================================
||                                                              ||
||             Port func rate user cmdline API draft            ||
||                                                              ||
==================================================================

Note that some of the "devlink port func" attributes in show commands
are omitted on purpose.

$ devlink port show
pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
pci/0000:06:00.0/1: flavour pcivf pfnum 0 vfnum 1 type eth netdev enp6s0pf0vf1
    func: hw_addr 10:22:33:44:55:66 state active
pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 2 type eth netdev enp6s0pf0vf2
    func: hw_addr 10:22:33:44:55:77 state active
pci/0000:06:00.0/3: flavour pcivf pfnum 0 vfnum 3 type eth netdev enp6s0pf0vf3
    func: hw_addr 10:22:33:44:55:88 state active
pci/0000:06:00.0/4: flavour pcisf pfnum 0 sfnum 1 type eth netdev enp6s0pf0vf1
    func: hw_addr 10:22:33:44:55:99 state active

port/func object is extended with new rate object.

$ devlink port func rate
pci/0000:06:00.0/1: type leaf
pci/0000:06:00.0/2: type leaf
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf

This shows the leafs created by default alongside with port/func objects.
No min or max tx rates were set, so their values are omitted.


Now create new node rate object:

$ devlink port func rate add pci/0000:06:00.0/somerategroup

$ devlink port func rate
pci/0000:06:00.0/1: type leaf
pci/0000:06:00.0/2: type leaf
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/somerategroup: type node

New node rate object was created - the last line.


Now create another new node object was created, this time with some attributes:

$ devlink port func rate add pci/0000:06:00.0/secondrategroup min_tx_rate 20 max_tx_rate 1000

$ devlink port func rate
pci/0000:06:00.0/1: type leaf
pci/0000:06:00.0/2: type leaf
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/somerategroup: type node
pci/0000:06:00.0/secondrategroup: type node min_tx_rate 20 max_tx_rate 1000

Another new node object was created - the last line. The object has min and max
tx rates set, so they are displayed after the object type.


Now set node named somerategroup min/max rate using rate object:

$ devlink port func rate set pci/0000:06:00.0/somerategroup min_tx_rate 50 max_tx_rate 5000

$ devlink port func rate
pci/0000:06:00.0/1: type leaf
pci/0000:06:00.0/2: type leaf
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/somerategroup: type node min_tx_rate 50 max_tx_rate 5000
pci/0000:06:00.0/secondrategroup: type node min_tx_rate 20 max_tx_rate 1000


Now set leaf port/func rate using rate object:

$ devlink port func rate set pci/0000:06:00.0/2 min_tx_rate 10 max_tx_rate 10000

$ devlink port func rate
pci/0000:06:00.0/1: type leaf
pci/0000:06:00.0/2: type leaf min_tx_rate 10 max_tx_rate 10000
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/somerategroup: type node min_tx_rate 50 max_tx_rate 5000
pci/0000:06:00.0/secondrategroup: type node min_tx_rate 20 max_tx_rate 1000


Now set leaf func of port with index 2 parent node using rate object:

$ devlink port func rate set pci/0000:06:00.0/2 parent somerategroup

$ devlink port func rate
pci/0000:06:00.0/1: type leaf
pci/0000:06:00.0/2: type leaf min_tx_rate 10 max_tx_rate 10000 parent somerategroup
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/somerategroup: type node min_tx_rate 50 max_tx_rate 5000
pci/0000:06:00.0/secondrategroup: type node min_tx_rate 20 max_tx_rate 1000


Now set leaf func of port with index 1 parent node using rate object:

$ devlink port func rate set pci/0000:06:00.0/1 parent somerategroup

$ devlink port func rate
pci/0000:06:00.0/1: type leaf parent somerategroup
pci/0000:06:00.0/2: type leaf min_tx_rate 10 max_tx_rate 10000 parent somerategroup
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/somerategroup: type node min_tx_rate 50 max_tx_rate 5000
pci/0000:06:00.0/secondrategroup: type node min_tx_rate 20 max_tx_rate 1000


Now unset leaf func of port with index 1 parent node using rate object:

$ devlink port func rate set pci/0000:06:00.0/1 noparent

$ devlink port func rate
pci/0000:06:00.0/1: type leaf
pci/0000:06:00.0/2: type leaf min_tx_rate 10 max_tx_rate 10000 parent somerategroup
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/somerategroup: type node min_tx_rate 50 max_tx_rate 5000
pci/0000:06:00.0/secondrategroup: type node min_tx_rate 20 max_tx_rate 1000


Now delete node object:

$ devlink port func rate del pci/0000:06:00.0/somerategroup

$ devlink port func rate
pci/0000:06:00.0/1: type leaf
pci/0000:06:00.0/2: type leaf
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf

Rate node object was removed and its only child pci/0000:06:00.0/2 automatically
detached.



==================================================================
||                                                              ||
||        Port func ib groupping user cmdline API draft         ||
||                                                              ||
==================================================================

Note that some of the "devlink port func" attributes in show commands
are omitted on purpose.

The reason for this IB groupping is that the VFs inside virtual machine
get information (via device) about which two of more VF devices should
be combined together to form one multi-port IB device. In the virtual
machine it is driver's responsibility to setup the combined
multi-port IB devices.

Consider following setup:

$ devlink port show
pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 type eth netdev enp6s0pf0vf0
    func: hw_addr 10:22:33:44:55:66 state active
pci/0000:06:00.0/3: flavour pcivf pfnum 0 vfnum 1 type eth netdev enp6s0pf0vf1
    func: hw_addr 10:22:33:44:55:77 state active
pci/0000:06:00.0/4: flavour pcivf pfnum 1 vfnum 0 type eth netdev enp6s0pf1vf0
    func: hw_addr 10:22:33:44:55:88 state active
pci/0000:06:00.0/5: flavour pcivf pfnum 1 vfnum 1 type eth netdev enp6s0pf1vf1
    func: hw_addr 10:22:33:44:55:99 state active


Each VF/SF port/func has IB leaf object related to it:

$ devlink port func ib
pci/0000:06:00.0/2: type leaf
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/5: type leaf

You see that by default, each port/func is marked as a leaf.
There is no groupping set.


User may add a ib group node by issuing following command:

$ devlink port func ib add pci/0000:06:00.0/somempgroup1

$ devlink port func ib
pci/0000:06:00.0/2: type leaf
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/5: type leaf
pci/0000:06:00.0/someibgroup1: type node

New node ib node object was created - the last line.


Now set leaf func of port with index 2 parent node using ib object:

$ devlink port func ib set pci/0000:06:00.0/2 parent someibgroup1

$ devlink port func ib
pci/0000:06:00.0/2: type leaf parent someibgroup1
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/5: type leaf
pci/0000:06:00.0/someibgroup1: type node


Now set leaf func of port with index 5 parent node using ib object:

$ devlink port func ib set pci/0000:06:00.0/5 parent someibgroup1

$ devlink port func ib
pci/0000:06:00.0/2: type leaf parent someibgroup1
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/5: type leaf parent someibgroup1
pci/0000:06:00.0/someibgroup1: type node

Now you can see there are 2 leaf funcs configured to have one parent.


To remove the parent link, user should issue following command:

$ devlink port func ib set pci/0000:06:00.0/5 noparent

$ devlink port func ib
pci/0000:06:00.0/2: type leaf parent someibgroup1
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/5: type leaf
pci/0000:06:00.0/someibgroup1: type node


Now delete node object:

$ devlink port func ib del pci/0000:06:00.0/somempgroup1
$ devlink port func ib
pci/0000:06:00.0/2: type leaf
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/5: type leaf

Node object was removed and its only child pci/0000:06:00.0/2 automatically
detached.


It is not possible to delete leafs:

$ devlink port func ib del pci/0000:06:00.0/2
devlink answers: Operation not supported



==================================================================
||                                                              ||
||            Dynamic PFs user cmdline API draft                ||
||                                                              ||
==================================================================

User might want to create another PF, similar as VF.
TODO
