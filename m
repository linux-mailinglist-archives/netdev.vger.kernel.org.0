Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30472D1FD7
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 02:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgLHBPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 20:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgLHBPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 20:15:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E9CC061749
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 17:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=QgrrXKR0Iyd6eBvwKhSAAn81nT94r/42RHE6oQXp8Cc=; b=Psc5WR+C7xQmg2+0BogGYo9QYa
        sPDSq99Tk8u2WAL7TG6Nhvi56LmTIpUyDpxVtuo9p7ZUyXzg26vCQ6QdVqnT0zbCglTCbzEeedV/W
        YDXV1ioMcPDgMooht+T2Bx6yCMVaG2FGmX2c84WW9YYmkqj0lBxkCBMX61OZ3/vMdAZyM0QOXdUBi
        WXLT7poFX8L5mkiNMJ2Uqu/Dk7gO+JKgM1whDfv3dMQSbhdoAKeC9AvV3YJ2imOwW8IXw2hvbsm87
        wrDeHyYHK1Yp/YPbNYGzEQ12GjeTQYigrAxlSU/gpDSV6jGmEhSi+KOswO8cJwbWy5AY+/yNfVazI
        b+SPCnJQ==;
Received: from [2601:1c0:6280:3f0::1494]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmRag-0007E2-UE; Tue, 08 Dec 2020 01:14:55 +0000
Subject: Re: [PATCH net-next v5] devlink: Add devlink port documentation
To:     Parav Pandit <parav@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     jacob.e.keller@intel.com, Jiri Pirko <jiri@nvidia.com>
References: <20201130164119.571362-1-parav@nvidia.com>
 <20201207221342.553976-1-parav@nvidia.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <02fd2fa9-f93e-a60b-6fc3-f309495ccf99@infradead.org>
Date:   Mon, 7 Dec 2020 17:14:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201207221342.553976-1-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi--

On 12/7/20 2:13 PM, Parav Pandit wrote:
> Added documentation for devlink port and port function related commands.
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
> Changelog:
> v4->v5:
>  - described logically ingress and egress point of devlink port
>  - removed networking from devlink port description
>  - rephrased port type description
>  - introdue PCI controller section and description

     introduce

>  - rephrased controller, device, function description
>  - removed confusing eswitch to system wording
>  - rephrased port function description
>  - added example of mac address in port function attribute description

> ---
>  .../networking/devlink/devlink-port.rst       | 116 ++++++++++++++++++
>  Documentation/networking/devlink/index.rst    |   1 +
>  2 files changed, 117 insertions(+)
>  create mode 100644 Documentation/networking/devlink/devlink-port.rst
> 
> diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
> new file mode 100644
> index 000000000000..dce87d2c07ac
> --- /dev/null
> +++ b/Documentation/networking/devlink/devlink-port.rst
> @@ -0,0 +1,116 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +============
> +Devlink Port
> +============
> +
> +``devlink-port`` is a port that exists on the device. It has a logically
> +separate ingress/egress point of the device. A devlink port can be of one

                                                          port can be any one
   of many flavours.

> +among many flavours. A devlink port flavour along with port attributes
> +describe what a port represents.
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
> +Devlink port can have a different type based on the link layer described below.
> +
> +.. list-table:: List of devlink port types
> +   :widths: 23 90
> +
> +   * - Type
> +     - Description
> +   * - ``DEVLINK_PORT_TYPE_ETH``
> +     - Driver should set this port type when a link layer of the port is
> +       Ethernet.
> +   * - ``DEVLINK_PORT_TYPE_IB``
> +     - Driver should set this port type when a link layer of the port is
> +       InfiniBand.
> +   * - ``DEVLINK_PORT_TYPE_AUTO``
> +     - This type is indicated by the user when driver should detect the port
> +       type automatically.
> +
> +PCI controllers
> +---------------
> +In most cases PCI device has only one controller. A controller consists of

either           PCI devices have
or               a PCI device has

> +potentially multiple physical and virtual functions. Such PCI function consists
> +of one or more ports. This port of the function is represented by the devlink
> +eswitch port.
> +
> +A PCI Device connected to multiple CPUs or multiple PCI root complex or

                                                                complexes

> +SmartNIC, however, may have multiple controllers. For a device with multiple
> +controllers, each controller is distinguished by a unique controller number.
> +An eswitch on the PCI device may suppport ports of multiple controllers. 

                                    support

> +
> +An example view of two controller systems::

I think that this is

  An example view of a two-controller system::

instead of 2 controller systems.  ?

> +
> +In this example, external controller (identified by controller number = 1)
> +doesn't have eswitch. Local controller (identified by controller number = 0)
> +has the eswitch. Devlink instance on local controller has eswitch devlink
> +ports representing ports for both the controllers.
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
> +    -----------  |           --------- ---------         ------- ------- |
> +    | smartNIC|  |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
> +    | pci rc  |==| -------   ----/---- ---/----- ------- ---/--- ---/--- |
> +    | connect |  | | pf0 |______/________/       | pf1 |___/_______/     |
> +    -----------  | -------                       -------                 |
> +                 |                                                       |
> +                 |  local controller_num=0 (eswitch)                     |
> +                 ---------------------------------------------------------
> +
> +Port function configuration
> +===========================
> +
> +A user can configure the port function attribute before enumerating the
> +PCI function. Usually it means, user should configure port function attribute
> +before a bus specific device for the function is created. However, when
> +SRIOV is enabled, virtual function devices are created on the PCI bus.
> +Hence, function attribute should be configured before binding virtual
> +function device to the driver.
> +
> +User may set the hardware address of the function represented by the devlink
> +port function. For Ethernet port function this means a MAC address.


-- 
~Randy

