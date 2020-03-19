Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F5418C041
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 20:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgCST13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 15:27:29 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43033 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbgCST12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 15:27:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id b2so4579247wrj.10
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 12:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=IIntgYcXiubVLNcRyfY6W8beg4ZO/2AfQkgblyDqW5U=;
        b=wfxhkAK+C3EnDdeLWlNDGvVuHWpcY5UwAKbYlf0fDDgdSS7XAAkCcmxbuwif/sAiCi
         7TfEBtP3AlNy4gbezZmZvuPnwbC0vYDvHBjSpW7b65a44Lzi5GerNHryqHSe7e3cPYJi
         N9DQR2vpqkrglBlFGSZMyz9jXRk7W2Fyli+WcuM9hJL6zUAJ2V8obGB79x5Czg8Jdr4x
         KsL+xXA/7Pf0kyugpUDBY84gWTrNiJw1Wi8eivkwOLHh9QllRYgm1eFSzTgku316hV8I
         tLqv5oppLgeUzYRNrmCfnd/53oqdD+an1hDKgBjsXtmfR3u8nNFpCtERsBdEu5RSx65J
         5u5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=IIntgYcXiubVLNcRyfY6W8beg4ZO/2AfQkgblyDqW5U=;
        b=lvSg3zF+0pKY8rH/8gaD7l66kSC5qR/SGtZKq7/u9n12JtLjE+wtMGmjip1T1r4l+3
         av1yUawLVvMcU6uEWaBo8HHa4kHgn9eqPe7mkYmQFTu0FQ20Yvy8qsM6etPQBOZfkcBB
         rDvK7/phvwhaJ+eAKDUMD+vZY7HrQN//LPy+TM37pO3GxT8KJfv9u/hr3asvznxpBxNX
         ZBgtaIAlRRlnwOeefL3Fa2N1vND4yux+J4iWnAW0hCkvRikNsF/Nttka9Daq8YTWb30h
         5c7HLd5hZdNmOM6S6frCSMHIG8QHNAwyqGShqjSomoaK0mcM9wtbz3VyrQomoLAjyxHb
         ug/Q==
X-Gm-Message-State: ANhLgQ2rifhmj8xhi6W5bzqtayUdIfKqBhRm/TA+1+8j2xhJk7Is0mdw
        DMbn/vL10AIL5+lTqMcf08pdTSbjJj4=
X-Google-Smtp-Source: ADFU+vuh0xSRuqLuB/TdEdjoiEMZamM0Z+kdS9O5pf2B6cG42+6D/vATd7mafuwnUH90UTUVGideOA==
X-Received: by 2002:adf:ed0a:: with SMTP id a10mr6564182wro.198.1584646041246;
        Thu, 19 Mar 2020 12:27:21 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b203sm4397230wmc.45.2020.03.19.12.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 12:27:20 -0700 (PDT)
Date:   Thu, 19 Mar 2020 20:27:19 +0100
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
        vikas.gupta@broadcom.com
Subject: [RFC] current devlink extension plan for NICs
Message-ID: <20200319192719.GD11304@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all.

First, I would like to apologize for very long email. But I think it
would be beneficial to the see the whole picture, where we are going.

Currently in Mellanox we are working on several features with need of
extension of the current devlink infrastructure. I took a stab at
putting it all together in a single txt file, inlined below.

Most of the stuff is based on a new object called "slice" (called
"subdev" originally in Yuval's patchsets sent some while ago).

The text describes how things should behave and provides a draft
of user facing console input/outputs. I think it is important to clear
that up before we go in and implement the devlink core and
driver pieces.

I would like to ask you to read this and comment. Especially, I would
like to ask vendors if what is described fits the needs of your
NIC/e-switch.

Please note that something is already implemented, but most of this
isn't (see "what needs to be implemented" section).




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
|  +-+port_pci/0000:06:00.0/0+-----------------------+-------------|--+ |
|  | |  flavour physical pfnum 0  (phys port and pf) ^             |    |
|  | |  netdev enp6s0f0np1                           |             |    |
|  | +->health reporters, params                     |             |    |
|  | |                                               |             |    |
|  | +->slice_pci/0000:06:00.0/0+--------------------+             |    |
|  |       flavour physical                                        |    |
|  |                                                               |    |
|  +-+port_pci/0000:06:00.0/1+-----------------------+-------------|----+
|  | |  flavour physical pfnum 1  (phys port and pf) |             |
|  | |  netdev enp6s0f0np2                           |             |
|  | +->health reporters, params                     |             |
|  | |                                               |             |
|  | +->slice_pci/0000:06:00.0/1+--------------------+             |
|  |       flavour physical                                        |
|  |                                                               |
|  +-+-+port_pci/0000:06:00.0/2+-----------+-------------------+   |
|  | | |  flavour pcipf pfnum 2            ^                   |   |
|  | | |  netdev enp6s0f0pf2               |                   |   |
|  | + +->params                           |                   |   |
|  | |                                     |                   |   |
|  | +->slice_pci/0000:06:00.0/2+----------+                   |   |
|  |       flavour pcipf                                       |   |
|  |                                                           |   |
|  +-+-+port_pci/0000:06:00.0/3+-----------+----------------+  |   |
|  | | |  flavour pcivf pfnum 2 vfnum 0    ^                |  |   |
|  | | |  netdev enp6s0pf2vf0              |                |  |   |
|  | | +->params                           |                |  |   |
|  | |                                     |                |  |   |
|  | +-+slice_pci/0000:06:00.0/3+----------+                |  |   |
|  |   |   flavour pcivf                                    |  |   |
|  |   +->rate (qos), mpgroup, mac                          |  |   |
|  |                                                        |  |   |
|  +-+-+port_pci/0000:06:00.0/4+-----------+-------------+  |  |   |
|  | | |  flavour pcivf pfnum 0 vfnum 0    ^             |  |  |   |
|  | | |  netdev enp6s0pf0vf0              |             |  |  |   |
|  | | +->params                           |             |  |  |   |
|  | |                                     |             |  |  |   |
|  | +-+slice_pci/0000:06:00.0/4+----------+             |  |  |   |
|  |   |   flavour pcivf                                 |  |  |   |
|  |   +->rate (qos), mpgroup, mac                       |  |  |   |
|  |                                                     |  |  |   |
|  +-+-+port_pci/0000:06:00.0/5+-----------+----------+  |  |  |   |
|  | | |  flavour pcisf pfnum 0 sfnum 1    ^          |  |  |  |   |
|  | | |  netdev enp6s0pf0sf1              |          |  |  |  |   |
|  | | +->params                           |          |  |  |  |   |
|  | |                                     |          |  |  |  |   |
|  | +-+slice_pci/0000:06:00.0/5+----------+          |  |  |  |   |
|  |   |   flavour pcisf                              |  |  |  |   |
|  |   +->rate (qos), mpgroup, mac                    |  |  |  |   |
|  |                                                  |  |  |  |   |
|  +-+slice_pci/0000:06:00.0/6+--------------------+  |  |  |  |   |
|        flavour pcivf pfnum 0 vfnum 1             |  |  |  |  |   |
|            (non-ethernet (IB, NVE)               |  |  |  |  |   |
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

4) slice is not implemented yet. This is the original "vdev/subdev" concept.
   See below section "Slice user cmdline API draft".

5) SFs are not implemented.
   See below section "SF (subfunction) user cmdline API draft".

6) rate for slice are not implemented yet.
   See below section "Slice rate user cmdline API draft".

7) mpgroup for slice is not implemented yet.
   See below section "Slice mpgroup user cmdline API draft".

8) VF manual creation using devlink is not implemented yet.
   See below section "VF manual creation and activation user cmdline API draft".
 
9) PF aliasing. One devlink instance and multiple PFs sharing it as they have one
   merged e-switch.



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



==================================================================
||                                                              ||
||                Slice user cmdline API draft                  ||
||                                                              ||
==================================================================

Note that some of the "devlink port" attributes may be forgotten or misordered.

Slices and ports are created together by device driver. The driver defines
the relationships during creation.


$ devlink port show
pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 type eth netdev enp6s0pf0vf0 slice 0
pci/0000:06:00.0/3: flavour pcivf pfnum 0 vfnum 1 type eth netdev enp6s0pf0vf1 slice 1
pci/0000:06:00.0/4: flavour pcivf pfnum 1 vfnum 0 type eth netdev enp6s0pf1vf0 slice 2
pci/0000:06:00.0/5: flavour pcivf pfnum 1 vfnum 1 type eth netdev enp6s0pf1vf1 slice 3

$ devlink slice show
pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
pci/0000:06:00.0/1: flavour physical pfnum 1 port 1 state active
pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 port 2 hw_addr 10:22:33:44:55:66 state active
pci/0000:06:00.0/3: flavour pcivf pfnum 0 vfnum 1 port 3 hw_addr 10:22:33:44:55:77 state active
pci/0000:06:00.0/4: flavour pcivf pfnum 1 vfnum 0 port 4 hw_addr 10:22:33:44:55:88 state active
pci/0000:06:00.0/5: flavour pcivf pfnum 1 vfnum 1 port 5 hw_addr 10:22:33:44:55:99 state active
pci/0000:06:00.0/6: flavour pcivf pfnum 1 vfnum 2

In these 2 outputs you can see the relationships. Attributes "slice" and "port"
indicate the slice-port pairs.

Also, there is a fixed "state" attribute with value "active". This is by
default as the VFs are always created active. In future, it is planned
to implement manual VF creation and activation, similar to what is below
described for SFs.

Note that for non-ethernet slice (the last one) does not have any
related port port. It can be for example NVE or IB. But since
the "hw_addr" attribute is also omitted, it isn't IB.

 
Now set a different MAC address for VF1 on PF0:
$ devlink slice set pci/0000:06:00.0/3 hw_addr aa:bb:cc:dd:ee:ff

$ devlink slice show
pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
pci/0000:06:00.0/1: flavour physical pfnum 1 port 1 state active
pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 port 2 hw_addr 10:22:33:44:55:66 state active
pci/0000:06:00.0/3: flavour pcivf pfnum 0 vfnum 1 port 3 hw_addr aa:bb:cc:dd:ee:ff state active
pci/0000:06:00.0/4: flavour pcivf pfnum 1 vfnum 0 port 4 hw_addr 10:22:33:44:55:88 state active
pci/0000:06:00.0/5: flavour pcivf pfnum 1 vfnum 1 port 5 hw_addr 10:22:33:44:55:99 state active
pci/0000:06:00.0/6: flavour pcivf pfnum 1 vfnum 2



==================================================================
||                                                              ||
||          SF (subfunction) user cmdline API draft             ||
||                                                              ||
==================================================================

Note that some of the "devlink port" attributes may be forgotten or misordered.

Note that some of the "devlink slice" attributes in show commands
are omitted on purpose.

$ devlink port show
pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 type eth netdev enp6s0pf0vf0 slice 2

$ devlink slice show
pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
pci/0000:06:00.0/1: flavour physical pfnum 1 port 1 state active
pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 port 2 hw_addr 10:22:33:44:55:66

There is one VF on the NIC.


Now create subfunction of SF0 on PF1, index of the slice is going to be 100
and hw_address aa:bb:cc:aa:bb:cc.

$ devlink slice add pci/0000.06.00.0/100 flavour pcisf pfnum 1 sfnum 10 hw_addr aa:bb:cc:aa:bb:cc

The devlink kernel code calls down to device driver (devlink op) and asks
it to create a slice with particular attributes. Driver then instatiates
the slice and port in the same way it is done for VF:

$ devlink port show
pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 type eth netdev enp6s0pf0vf0 slice 2
pci/0000:06:00.0/3: flavour pcisf pfnum 1 sfnum 10 type eth netdev enp6s0pf1sf10 slice 100

$ devlink slice show
pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
pci/0000:06:00.0/1: flavour physical pfnum 1 port 1 state active
pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 port 2 hw_addr 10:22:33:44:55:66
pci/0000:06:00.0/100: flavour pcisf pfnum 1 sfnum 10 port 3 hw_addr aa:bb:cc:aa:bb:cc state inactive

Note that the SF slice is created but not active. That means the
entities are created on devlink side, the e-switch port representor
is created, but the SF device itself it not yet out there (same host
or different, depends on where the parent PF is - in this case the same host).
User might use e-switch port representor enp6s0pf1sf10 to do settings,
putting it into bridge, adding TC rules, etc.
It's like the cable is unplugged on the other side.


Now we activate (deploy) the SF:
$ devlink slice set pci/0000:06:00.0/100 state active

$ devlink slice show
pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
pci/0000:06:00.0/1: flavour physical pfnum 1 port 1 state active
pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 port 2 hw_addr 10:22:33:44:55:66
pci/0000:06:00.0/100: flavour pcisf pfnum 1 sfnum 10 port 3 hw_addr aa:bb:cc:aa:bb:cc state active

Upon the activation, the device driver asks the device to instantiate
the actual SF device on particular PF. Does not matter if that is
on the same host or not.

On the other side, the PF driver instance gets the event from device
that particular SF was activated. It's the cue to put the device on bus
probe it and instantiate netdev and devlink instances for it.

For every SF a device is created on wirtbus with an ID assigned by the
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


User can deactivate the slice by:

$ devlink slice set pci/0000:06:00.0/100 state inactive

This eventually leads to event delivered to PF driver, which is a
cue to remove the SF device from virtbus and remove all related devlink
and netdev instances.

The slice may be activated again.

Now on the teardown process, user might either remove the SF slice
right away, without deactivation. However, it is possible to remove
deactivated SF too. To remove the SF, user should do:

$ devlink slice del pci/0000:06:00.0/100

$ devlink port show
pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 type eth netdev enp6s0pf0vf0 slice 2

$ devlink slice show
pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
pci/0000:06:00.0/1: flavour physical pfnum 1 port 1 state active
pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 port 2 hw_addr 10:22:33:44:55:66



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

$ devlink slice add pci/0000:06:00.0/99 flavour pcivf pfnum 1 vfnum 8 hw_addr aa:bb:cc:aa:bb:cc

The devlink kernel code calls down to device driver (devlink op) and asks
it to create a slice with particular attributes. Driver then instatiates
the slice and port:

$ devlink port show
pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
pci/0000:06:00.0/2: flavour pcivf pfnum 1 vfnum 8 type eth netdev enp6s0pf1vf0 slice 99

$ devlink slice show
pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
pci/0000:06:00.0/1: flavour physical pfnum 1 port 1 state active
pci/0000:06:00.0/99: flavour pcivf pfnum 1 vfnum 8 port 2 hw_addr aa:bb:cc:aa:bb:cc state inactive

Now we activate (deploy) the VF:
$ devlink slice set pci/0000:06:00.0/99 state active

$ devlink slice show
pci/0000:06:00.0/99: flavour pcivf pfnum 1 vfnum 8 port 2 hw_addr aa:bb:cc:aa:bb:cc state active



==================================================================
||                                                              ||
||                             PFs                              ||
||                                                              ||
==================================================================

There are 2 flavours of PFs:
1) Parent PF. That is coupled with uplink port. The slice flavour is
   therefore "physical", to be in sync of the flavour of the uplink port.
   In case this Parent PF is actually a leg of upstream embedded switch,
   the slice flavour is "virtual" (same as the port flavour).

   $ devlink port show
   pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1 slice 0

   $ devlink slice show
   pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active

   This slice is shown in both "switchdev" and "legacy" modes.

   If there is another parent PF, say "0000:06:00.1", that share the
   same embedded switch, the aliasing is established for devlink handles.

   The user can use devlink handles:
   pci/0000:06:00.0
   pci/0000:06:00.1
   as equivalents, pointing to the same devlink instance.

   Parent PFs are the ones that may be in control of managing
   embedded switch, on any hierarchy level.

2) Child PF. This is a leg of a PF put to the parent PF. It is
   represented by a slice, and a port (with a netdevice):

   $ devlink port show
   pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1 slice 0
   pci/0000:06:00.0/1: flavour pcipf pfnum 2 type eth netdev enp6s0f0pf2 slice 20

   $ devlink slice show
   pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
   pci/0000:06:00.0/20: flavour pcipf pfnum 1 port 1 hw_addr aa:bb:cc:aa:bb:87 state active  <<<<<<<<<<

   This is a typical smartnic scenario. You would see this list on
   the smartnic CPU. The slice pci/0000:06:00.0/20 is a leg to
   one of the hosts. If you send packets to enp6s0f0pf2, they will
   go to he host.

   Note that inside the host, the PF is represented again as "Parent PF"
   and may be used to configure nested embedded switch.



==================================================================
||                                                              ||
||               Slice operational state extension              ||
||                                                              ||
==================================================================

In addition to the "state" attribute that serves for the purpose
of setting the "admin state", there is "opstate" attribute added to
reflect the operational state of the slice:


    opstate                description
    -----------            ------------
    1. attached    State when slice device is bound to the host
                   driver. When the slice device is unbound from the
                   host driver, slice device exits this state and
                   enters detaching state.

    2. detaching   State when host is notified to deactivate the
                   slice device and slice device may be undergoing
                   detachment from host driver. When slice device is
                   fully detached from the host driver, slice exits
                   this state and enters detached state.

    3. detached    State when driver is fully unbound, it enters
                   into detached state.

slice state machine:
--------------------
                               slice state set inactive
                              ----<------------------<---
                              | or  slice delete        |
                              |                         |
  __________              ____|_______              ____|_______
 |          | slice add  |            |slice state |            |
 |          |-------->---|            |------>-----|            |
 | invalid  |            |  inactive  | set active |   active   |
 |          | slice del  |            |            |            |
 |__________|--<---------|____________|            |____________|

slice device operational state machine:
---------------------------------------
  __________                ____________              ___________
 |          | slice state  |            |driver bus  |           |
 | invalid  |-------->-----|  detached  |------>-----| attached  |
 |          | set active   |            | probe()    |           |
 |__________|              |____________|            |___________|
                                 |                        |
                                 ^                    slice set
                                 |                    set inactive
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
||             Slice rate user cmdline API draft                ||
||                                                              ||
==================================================================

Note that some of the "devlink slice" attributes in show commands
are omitted on purpose.


$ devlink slice show
pci/0000:06:00.0/0: flavour physical pfnum
pci/0000:06:00.0/1: flavour pcivf pfnum 0 vfnum 1
pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0
pci/0000:06:00.0/3: flavour pcivf pfnum 0 vfnum 1
pci/0000:06:00.0/4: flavour pcisf pfnum 0 sfnum 1

Slice object is extended with new rate object.


$ devlink slice rate
pci/0000:06:00.0/1: type leaf
pci/0000:06:00.0/2: type leaf
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf

This shows the leafs created by default alongside with slice objects. No min or
max tx rates were set, so their values are omitted.


Now create new node rate object:

$ devlink slice rate add pci/0000:06:00.0/somerategroup

$ devlink slice rate
pci/0000:06:00.0/1: type leaf
pci/0000:06:00.0/2: type leaf
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/somerategroup: type node

New node rate object was created - the last line.


Now create another new node object was created, this time with some attributes:

$ devlink slice rate add pci/0000:06:00.0/secondrategroup min_tx_rate 20 max_tx_rate 1000

$ devlink slice rate
pci/0000:06:00.0/1: type leaf
pci/0000:06:00.0/2: type leaf
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/somerategroup: type node
pci/0000:06:00.0/secondrategroup: type node min_tx_rate 20 max_tx_rate 1000

Another new node object was created - the last line. The object has min and max
tx rates set, so they are displayed after the object type.


Now set node named somerategroup min/max rate using rate object:

$ devlink slice rate set pci/0000:06:00.0/somerategroup min_tx_rate 50 max_tx_rate 5000

$ devlink slice rate
pci/0000:06:00.0/1: type leaf
pci/0000:06:00.0/2: type leaf
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/somerategroup: type node min_tx_rate 50 max_tx_rate 5000
pci/0000:06:00.0/secondrategroup: type node min_tx_rate 20 max_tx_rate 1000


Now set leaf slice rate using rate object:

$ devlink slice rate set pci/0000:06:00.0/2 min_tx_rate 10 max_tx_rate 10000

$ devlink slice rate
pci/0000:06:00.0/1: type leaf
pci/0000:06:00.0/2: type leaf min_tx_rate 10 max_tx_rate 10000
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/somerategroup: type node min_tx_rate 50 max_tx_rate 5000
pci/0000:06:00.0/secondrategroup: type node min_tx_rate 20 max_tx_rate 1000


Now set leaf slice with index 2 parent node using rate object:

$ devlink slice rate set pci/0000:06:00.0/2 parent somerategroup

$ devlink slice rate
pci/0000:06:00.0/1: type leaf
pci/0000:06:00.0/2: type leaf min_tx_rate 10 max_tx_rate 10000 parent somerategroup
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/somerategroup: type node min_tx_rate 50 max_tx_rate 5000
pci/0000:06:00.0/secondrategroup: type node min_tx_rate 20 max_tx_rate 1000


Now set leaf slice with index 1 parent node using rate object:

$ devlink slice rate set pci/0000:06:00.0/1 parent somerategroup

$ devlink slice rate
pci/0000:06:00.0/1: type leaf parent somerategroup
pci/0000:06:00.0/2: type leaf min_tx_rate 10 max_tx_rate 10000 parent somerategroup
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/somerategroup: type node min_tx_rate 50 max_tx_rate 5000
pci/0000:06:00.0/secondrategroup: type node min_tx_rate 20 max_tx_rate 1000


Now unset leaf slice with index 1 parent node using rate object:

$ devlink slice rate set pci/0000:06:00.0/1 noparent

$ devlink slice rate
pci/0000:06:00.0/1: type leaf
pci/0000:06:00.0/2: type leaf min_tx_rate 10 max_tx_rate 10000 parent somerategroup
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/somerategroup: type node min_tx_rate 50 max_tx_rate 5000
pci/0000:06:00.0/secondrategroup: type node min_tx_rate 20 max_tx_rate 1000


Now delete node object:

$ devlink slice rate del pci/0000:06:00.0/somerategroup

$ devlink slice rate
pci/0000:06:00.0/1: type leaf
pci/0000:06:00.0/2: type leaf
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf

Rate node object was removed and its only child pci/0000:06:00.0/2 automatically
detached.



==================================================================
||                                                              ||
||            Slice ib groupping user cmdline API draft         ||
||                                                              ||
==================================================================

Note that some of the "devlink slice" attributes in show commands
are omitted on purpose.

The reason for this IB groupping is that the VFs inside virtual machine
get information (via device) about which two of more VF devices should
be combined together to form one multi-port IB device. In the virtual
machine it is driver's responsibility to setup the combined
multi-port IB devices.

Consider following setup:

$ devlink slice show
pci/0000:06:00.0/0: flavour physical pfnum 0
pci/0000:06:00.0/1: flavour physical pfnum 1
pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0
pci/0000:06:00.0/3: flavour pcivf pfnum 0 vfnum 1
pci/0000:06:00.0/4: flavour pcivf pfnum 1 vfnum 0
pci/0000:06:00.0/5: flavour pcivf pfnum 1 vfnum 1


Each VF/SF slice has IB leaf object related to it:

$ devlink slice ib
pci/0000:06:00.0/2: type leaf
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/5: type leaf

You see that by default, each slice is marked as a leaf.
There is no groupping set.


User may add a ib group node by issuing following command:

$ devlink slice ib add pci/0000:06:00.0/somempgroup1

$ devlink slice ib
pci/0000:06:00.0/2: type leaf
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/5: type leaf
pci/0000:06:00.0/someibgroup1: type node

New node ib node object was created - the last line.


Now set leaf slice with index 2 parent node using ib object:

$ devlink slice ib set pci/0000:06:00.0/2 parent someibgroup1

$ devlink slice ib
pci/0000:06:00.0/2: type leaf parent someibgroup1
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/5: type leaf
pci/0000:06:00.0/someibgroup1: type node


Now set leaf slice with index 5 parent node using ib object:

$ devlink slice ib set pci/0000:06:00.0/5 parent someibgroup1

$ devlink slice ib
pci/0000:06:00.0/2: type leaf parent someibgroup1
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/5: type leaf parent someibgroup1
pci/0000:06:00.0/someibgroup1: type node

Now you can see there are 2 leaf devices configured to have one parent.


To remove the parent link, user should issue following command:

$ devlink slice ib set pci/0000:06:00.0/5 noparent

$ devlink slice ib
pci/0000:06:00.0/2: type leaf parent someibgroup1
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/5: type leaf
pci/0000:06:00.0/someibgroup1: type node


Now delete node object:

$ devlink slice ib del pci/0000:06:00.0/somempgroup1
$ devlink slice ib
pci/0000:06:00.0/2: type leaf
pci/0000:06:00.0/3: type leaf
pci/0000:06:00.0/4: type leaf
pci/0000:06:00.0/5: type leaf

Node object was removed and its only child pci/0000:06:00.0/2 automatically
detached.


It is not possible to delete leafs:

$ devlink slice ib del pci/0000:06:00.0/2
devlink answers: Operation not supported



==================================================================
||                                                              ||
||            Dynamic PFs user cmdline API draft                ||
||                                                              ||
==================================================================

User might want to create another PF, similar as VF.
TODO
