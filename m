Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B292CFECF
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 21:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgLEU2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 15:28:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:46212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgLEU17 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 15:27:59 -0500
Date:   Sat, 5 Dec 2020 12:27:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607200038;
        bh=eXUI1dkkAvNrnO2Izklpx/5OjcKa6S9izAG97hMR46U=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=IugFc/0fBcY7bJj6oIQLOwHf6O2DJ6YXDHZzz5tIBXdy9Btpp70aejz0VGMQmdJMO
         Kq1z1Q0BwnU/B1OBHLVxvYqK1mWx2QFLXrkC9eOe1jp6oPPD7KKflkl2m9VEq/T/J8
         3GV3rqXqlScH9NVE+IJLtnYZ3JpsL4jMxP5RiHRKiKpQyCbOxPjvPayLqTaV7wjYE5
         fKZMM4xtVnNKUmAMntcDO0YMrWOai5v6nyi+1tM5hvdpoGMaD/40V7c/axR0vwTJGs
         ZdEcuPxbPejLL6qu03JWZi0pvzuK4+aLGfO23yj8iPSVjvzs3I9q5LMeZcEjEmLwrY
         z5A2crL5CfVJg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <jacob.e.keller@intel.com>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v4] devlink: Add devlink port documentation
Message-ID: <20201205122717.76d193a2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203180255.5253-1-parav@nvidia.com>
References: <20201130164119.571362-1-parav@nvidia.com>
        <20201203180255.5253-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 20:02:55 +0200 Parav Pandit wrote:
> Added documentation for devlink port and port function related commands.
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> +============
> +Devlink Port
> +============
> +
> +``devlink-port`` is a port that exists on the device. 

Can we add something like:

Each port is a logically separate ingress/egress point of the device.

?

> A devlink port can
> +be of one among many flavours. A devlink port flavour along with port
> +attributes describe what a port represents.
> +
> +A device driver that intends to publish a devlink port sets the
> +devlink port attributes and registers the devlink port.
> +
> +Devlink port flavours are described below.
> +
> +.. list-table:: List of devlink port flavours
> +   :widths: 33 90
> +
> +   * - Flavour
> +     - Description
> +   * - ``DEVLINK_PORT_FLAVOUR_PHYSICAL``
> +     - Any kind of physical networking port. This can be an eswitch physical
> +       port or any other physical port on the device.
> +   * - ``DEVLINK_PORT_FLAVOUR_DSA``
> +     - This indicates a DSA interconnect port.
> +   * - ``DEVLINK_PORT_FLAVOUR_CPU``
> +     - This indicates a CPU port applicable only to DSA.
> +   * - ``DEVLINK_PORT_FLAVOUR_PCI_PF``
> +     - This indicates an eswitch port representing a networking port of
> +       PCI physical function (PF).
> +   * - ``DEVLINK_PORT_FLAVOUR_PCI_VF``
> +     - This indicates an eswitch port representing a networking port of
> +       PCI virtual function (VF).
> +   * - ``DEVLINK_PORT_FLAVOUR_VIRTUAL``
> +     - This indicates a virtual port for the virtual PCI device such as PCI VF.
> +
> +Devlink port types are described below.

How about:

Physical ports can have different types based on the link layer:

> +.. list-table:: List of devlink port types
> +   :widths: 23 90
> +
> +   * - Type
> +     - Description
> +   * - ``DEVLINK_PORT_TYPE_ETH``
> +     - Driver should set this port type when a link layer of the port is Ethernet.
> +   * - ``DEVLINK_PORT_TYPE_IB``
> +     - Driver should set this port type when a link layer of the port is InfiniBand.

Please wrap at 80 chars.

> +   * - ``DEVLINK_PORT_TYPE_AUTO``
> +     - This type is indicated by the user when user prefers to set the port type
> +       to be automatically detected by the device driver.

How about:

This type is indicated by the user when driver should detect the port 
type automatically.

> +A controller consists of one or more PCI functions. 

This need some intro. Like:

PCI controllers
---------------

In most cases PCI devices will have only one controller, with
potentially multiple physical and virtual functions. Devices connected
to multiple CPUs and SmartNICs, however, may have multiple controllers.

> Such PCI function consists
> +of one or more networking ports.

PCI function consists of networking ports? What do you mean by 
a networking port? All devlink ports are networking ports.

> A networking port of such PCI function is
> +represented by the eswitch devlink port.

What's eswitch devlink port? It was never defined.

> A devlink instance holds ports of two
> +types of controllers.

For devices with multiple controllers we can distinguish...

> +(1) controller discovered on same system where eswitch resides:
> +This is the case where PCI PF/VF of a controller and devlink eswitch
> +instance both are located on a single system.

How is eswitch located on a system? Eswitch is in the NIC

I think you should say refer to eswitch being controlled by a system.

> +(2) controller located on external host system.
> +This is the case where a controller is in one system and its devlink
> +eswitch ports are in a different system. Such controller is called
> +external controller.

> +An example view of two controller systems::
> +
> +In this example, external controller (identified by controller number = 1)
> +doesn't have eswitch. Local controller (identified by controller number = 0)
> +has the eswitch. Devlink instance on local Controller has eswitch devlink
> +ports representing networking ports for both the controllers.
> +
> +                 ---------------------------------------------------------
> +                 |                                                       |
> +                 |           --------- ---------         ------- ------- |
> +    -----------  |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
> +    | server  |  | -------   ----/---- ---/----- ------- ---/--- ---/--- |
> +    | pci rc  |=== | pf0 |______/________/       | pf1 |___/_______/     |
> +    | connect |  | -------                       -------                 |
> +    -----------  |     | controller_num=1 (no eswitch)                   |
> +                 ------|--------------------------------------------------
> +                 (internal wire)
> +                       |
> +                 ---------------------------------------------------------
> +                 | devlink eswitch ports and reps                        |
> +                 | ----------------------------------------------------- |
> +                 | |ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 |ctrl-0 | |
> +                 | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN | |
> +                 | ----------------------------------------------------- |
> +                 | |ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 |ctrl-1 | |
> +                 | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN | |
> +                 | ----------------------------------------------------- |
> +                 |                                                       |
> +                 |                                                       |
> +                 |           --------- ---------         ------- ------- |
> +                 |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
> +                 | -------   ----/---- ---/----- ------- ---/--- ---/--- |
> +                 | | pf0 |______/________/       | pf1 |___/_______/     |
> +                 | -------                       -------                 |
> +                 |                                                       |
> +                 |  local controller_num=0 (eswitch)                     |
> +                 ---------------------------------------------------------
> +
> +Port function configuration
> +===========================
> +
> +When a port flavor is ``DEVLINK_PORT_FLAVOUR_PCI_PF`` or
> +``DEVLINK_PORT_FLAVOUR_PCI_VF``, it represents the networking port of a
> +PCI function. 

Networking port of a PCI function?

> A user can configure the port function attributes 

port function attributes?

> before
> +enumerating the function.

What does this mean? What does enumerate mean in this context?

> For example user may set the hardware address of
> +the function represented by the devlink port function.

What's a hardware address? You mean MAC address?
