Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEFC010006F
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 09:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfKRIg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 03:36:28 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48497 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726627AbfKRIg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 03:36:28 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BFFCD2243B;
        Mon, 18 Nov 2019 03:36:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 18 Nov 2019 03:36:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=vf0MWU
        /veoUYzJPs11FtzGdFscQ0LhEudJIe2D5IyJM=; b=H+eIDHSSTnOYaMwMlBh09s
        SjemYoEzIl6Y0tV4ijIFJjgpskRJO4om9urRDkd2vVX3uqQEmW9i3qVXRxCe79+H
        T+dKej885xfTQb93/hGJoFZSeUet40egW3/0B7XYpmsmsPtbOkz665NNYOHrozQU
        PlpwJLlrvEANXt5xZGmfTm4bncvagnZbTCywzgwj1dtpZAwknnPcD6mVcumDpnST
        dqV6xTKtBNKOixPI2+aJhxOuSYCrpEa1JxSIIHANRUziLBhLyWWpIFlOVVl3iwhc
        GhKABWISXvI1zh4nO5HjlTBl4xE8nzSae1B9cU2QBdEpa7MD6xcglRibjx8ZYS9Q
        ==
X-ME-Sender: <xms:CljSXbWblJb6TPi6N2VZUJ3y709zyGfljW3e_alsqgiA9qENT2do9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeggedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:CljSXV2WSx-_jzLCTkXZMNKrJ9mUuqP8LnmTK-tbeBFOxr2p-KbxpQ>
    <xmx:CljSXXeyQZ4LiaQoIeDLKpW_rfs5puQxwp07WiaUcpyuDIJfpUr44w>
    <xmx:CljSXfTstEwkgklNYlANKxCIP2_oV7W9WZFg6FdgqYYNn4TiUYJxiA>
    <xmx:CljSXSW5v-rSeQ6N4wuN8BjQVA9z2Cwo9oLEXnxRbiklhcIfh6hryQ>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D42258005C;
        Mon, 18 Nov 2019 03:36:25 -0500 (EST)
Date:   Mon, 18 Nov 2019 10:36:24 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: dsa: sja1105: Make HOSTPRIO a devlink
 param
Message-ID: <20191118083624.GA2149@splinter>
References: <20191116172325.13310-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116172325.13310-1-olteanv@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 16, 2019 at 07:23:25PM +0200, Vladimir Oltean wrote:
> Unfortunately with this hardware, there is no way to transmit in-band
> QoS hints with management frames (i.e. VLAN PCP is ignored). The traffic
> class for these is fixed in the static config (which in turn requires a
> reset to change).
> 
> With the new ability to add time gates for individual traffic classes,
> there is a real danger that the user might unknowingly turn off the
> traffic class for PTP, BPDUs, LLDP etc.
> 
> So we need to manage this situation the best we can. There isn't any
> knob in Linux for this, so create a driver-specific devlink param which
> is a runtime u8. The default value is 7 (the highest priority traffic
> class).
> 
> Patch is largely inspired by the mv88e6xxx ATU_hash devlink param
> implementation.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
> Changes in v2:
> Turned the NET_DSA_SJA1105_HOSTPRIO kernel config into a "hostprio"
> runtime devlink param.
> 
>  .../networking/devlink-params-sja1105.txt     |  9 ++
>  Documentation/networking/dsa/sja1105.rst      | 19 +++-
>  MAINTAINERS                                   |  1 +
>  drivers/net/dsa/sja1105/sja1105.h             |  1 +
>  drivers/net/dsa/sja1105/sja1105_main.c        | 94 +++++++++++++++++++
>  5 files changed, 122 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/networking/devlink-params-sja1105.txt
> 
> diff --git a/Documentation/networking/devlink-params-sja1105.txt b/Documentation/networking/devlink-params-sja1105.txt
> new file mode 100644
> index 000000000000..5096a4cf923c
> --- /dev/null
> +++ b/Documentation/networking/devlink-params-sja1105.txt
> @@ -0,0 +1,9 @@
> +hostprio		[DEVICE, DRIVER-SPECIFIC]
> +			Configure the traffic class which will be used for
> +			management (link-local) traffic injected and trapped
> +			to/from the CPU. This includes STP, PTP, LLDP etc, as
> +			well as hardware-specific meta frames with RX
> +			timestamps.  Higher is better as long as you care about
> +			your PTP frames.

Vladimir,

I have some concerns about this. Firstly, I'm not sure why you need to
expose this and who do you expect to be able to configure this? I'm
asking because once you expose it to users there might not be a way
back. mlxsw is upstream for over four years and the traffic classes for
the different packet types towards the CPU are hard coded in the driver
and based on "sane" defaults. It is therefore surprising to me that you
already see the need to expose this.

Secondly, I find the name confusing. You call it "hostprio", but the
description says "traffic class". These are two different things.
Priority is a packet attribute based on which you can classify the
packet to a transmission queue (traffic class). And if you have multiple
transmission queues towards the CPU, how do you configure their
scheduling and AQM? This relates to my next point.

Thirdly, the fact that "there isn't any knob in Linux for this" does not
mean that we should not create a proper one. As I see it, the CPU port
(switch side, not DSA master) is a port like any other and therefore
should have a netdev. With a netdev you can properly configure its
different QoS attributes using tc instead of introducing driver-specific
devlink-params.

Yes, I understand that this is a large task compared to just adding this
devlink-param, but adding a new user interface always scares me and I
think we should do the right thing here.

Thanks
