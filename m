Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E372C8E11
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 20:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbgK3TaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 14:30:04 -0500
Received: from mga14.intel.com ([192.55.52.115]:38849 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728899AbgK3T35 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 14:29:57 -0500
IronPort-SDR: c25+A9aUxwOxEb1KD2R4vDtTenUqfT5rg2DHqFj/H5sGqvrlaQgQwrgMMNYXoUgZ6QiVvx1J4d
 tEQr1BSeaCMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="171913082"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="171913082"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 11:29:16 -0800
IronPort-SDR: ENqvB01QmiYGnLIbTsnbZ7G/iQRD54WlNY90KRttWEjtyLZkiE/k8AVG9Yg+Ik1DAzeQI0Y0YS
 jcuaCMe5PNqw==
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="549233883"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.29.232]) ([10.209.29.232])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 11:29:15 -0800
Subject: Re: [PATCH net-next] devlink: Add devlink port documentation
To:     Parav Pandit <parav@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20201130164119.571362-1-parav@nvidia.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <835d53da-25e2-04fd-fec5-7bd2b0e4427f@intel.com>
Date:   Mon, 30 Nov 2020 11:29:13 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201130164119.571362-1-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/30/2020 8:41 AM, Parav Pandit wrote:
> Added documentation for devlink port and port function related commands.
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Good to see this! I saw a couple of minor nits.

- Jake

> ---
>  .../networking/devlink/devlink-port.rst       | 102 ++++++++++++++++++
>  Documentation/networking/devlink/index.rst    |   1 +
>  2 files changed, 103 insertions(+)
>  create mode 100644 Documentation/networking/devlink/devlink-port.rst
> 
> diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
> new file mode 100644
> index 000000000000..966d2ee328a6
> --- /dev/null
> +++ b/Documentation/networking/devlink/devlink-port.rst
> @@ -0,0 +1,102 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +============
> +Devlink Port
> +============
> +
> +``devlink-port`` provides capability for a driver to expose various
> +flavours of ports which exist on device. A devlink port can of an
> +embedded switch (eswitch) present on the device.
> +

Seems like a word is missing here in the "A devlink port can of an
embedded switch". Perhaps "Can be of"?

> +A devlink port can be of 3 diffferent types.
> +
> +.. list-table:: List of devlink port types
> +   :widths: 23 90
> +
> +   * - Type
> +     - Description
> +   * - ``DEVLINK_PORT_TYPE_ETH``
> +     - This type is set for a devlink port when a physical link layer of the port
> +       is Ethernet.
> +   * - ``DEVLINK_PORT_TYPE_IB``
> +     - This type is set for a devlink port when a physical link layer of the port
> +       is InfiniBand.
> +   * - ``DEVLINK_PORT_TYPE_AUTO``
> +     - This type is indicated by the user when user prefers to set the port type
> +       to be automatically detected by the device driver.
> +
> +Devlink port can be of few different flavours described below.
> +
> +.. list-table:: List of devlink port flavours
> +   :widths: 33 90
> +
> +   * - Flavour
> +     - Description
> +   * - ``DEVLINK_PORT_FLAVOUR_PHYSICAL``
> +     - Any kind of port which is physically facing the user. This can be
> +       a eswitch physical port or any other physical port on the device.
> +   * - ``DEVLINK_PORT_FLAVOUR_CPU``
> +     - This indicates a CPU port.
> +   * - ``DEVLINK_PORT_FLAVOUR_DSA``
> +     - This indicates a interconnect port in a distributed switch architecture.
> +   * - ``DEVLINK_PORT_FLAVOUR_PCI_PF``
> +     - This indicates an eswitch port representing PCI physical function(PF).
> +   * - ``DEVLINK_PORT_FLAVOUR_PCI_VF``
> +     - This indicates an eswitch port representing PCI virtual function(VF).
> +   * - ``DEVLINK_PORT_FLAVOUR_VIRTUAL``
> +     - This indicates a virtual port facing the user.
> +   * - ``DEVLINK_PORT_FLAVOUR_VIRTUAL``
> +     - This indicates an virtual port facing the user.

DEVLINK_PORT_FLAVOUR_VIRTUAL is repeated.

> +
> +A devlink port may be for a controller consist of one or more PCI device(s).
> +A devlink instance holds ports of two types of controllers.
> +

s/consist/consisting/ ?

> +(1) controller discovered on same system where eswitch resides
> +This is the case where PCI PF/VF of a controller and devlink eswitch
> +instance both are located on a single system.
> +
> +(2) controller located on external host system.
> +This is the case where a controller is located in one system and its
> +devlink eswitch ports are located in a different system.
> +
> +An example view of two controller systems::
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
> +``DEVLINK_PORT_FLAVOUR_PCI_VF``, it represents the port of a PCI function.
> +A user can configure the port function attributes before enumerating the
> +function. For example user may set the hardware address of the function
> +represented by the devlink port.
> diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
> index d82874760ae2..aab79667f97b 100644
> --- a/Documentation/networking/devlink/index.rst
> +++ b/Documentation/networking/devlink/index.rst
> @@ -18,6 +18,7 @@ general.
>     devlink-info
>     devlink-flash
>     devlink-params
> +   devlink-port
>     devlink-region
>     devlink-resource
>     devlink-reload
> 
