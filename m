Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F2847AAA8
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 14:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbhLTNur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 08:50:47 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:57891 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230044AbhLTNup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 08:50:45 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id BFEB75809FA;
        Mon, 20 Dec 2021 08:50:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 20 Dec 2021 08:50:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+QPN1c
        5bRykaMvRVB5arLM7fYrJy/+xYuiv3UDMKEOo=; b=kARNE/k+jOS4+C+uw6ZM2V
        bEqUeDf6nDBLIuiyOS5ZAVuhmmd2v5z4IWfAQIvW+66Zsx1oGcv6BAFYhKUyg0eL
        qG79K7sZJ1Y9JCfxeP84Fd/Jo6rY8UJv9Qqqk5TNOAIMIz2zmcjRACQrHSJHAZBC
        zjTaBa8kdd3MN2Y5MRZvSYZr0dwy7X3KskPgE+Y+Po3FxM9frgCEyJVrq7nuPeBT
        EBa9JF/XOjEOJOa5b+3jJsoTEcWJXDBfr6yhEZYCBLZr/Go0t17yCw5ixlHdi8sE
        rZmBhne27bc1w1+s/I14E8arI4Wrnf31J1yoPUME6kyI3fYE5f8BStD/O78DWROQ
        ==
X-ME-Sender: <xms:M4rAYc5lk7HnuYLPrnhYMkoJVup5uojPNLlpnHeqk8WZkayibmxmcw>
    <xme:M4rAYd6IF8-t9eAxfofYd_U-z42BbGsC0bTrcXDq0lMRlX6k8w_sVtCACMdwCApIO
    IMuiyEcklps74Y>
X-ME-Received: <xmr:M4rAYbcSBfp3A79b7LxSScQlUZvAmwjuU2Rkh1WYUdn96CAK1s7qBRejenp3YF51MLEouPifwjvWoLXMURbiMZ-qFpSmLQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddtvddgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:M4rAYRLOkDr3ZOzPBBYkKeNARu-uOKc8EQ50G0OP-HH5-qTnfmspxA>
    <xmx:M4rAYQKup9nF6_WqT9WZXbKucQDcPfJbv8yR9vWR_4SifFOGK0Ssag>
    <xmx:M4rAYSx_efnJ9vjCEQmOB4c3RZZRqueGEhmbVQPlamqVVeYNWKFv3A>
    <xmx:NIrAYSCUzKceuaBxKwqDcDWZzXu1aNr5dAifAfCobkkhHD_87eNz8g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Dec 2021 08:50:42 -0500 (EST)
Date:   Mon, 20 Dec 2021 15:50:38 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "Byagowi, Ahmad" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: Re: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
Message-ID: <YcCKLnrvbu9RBlR8@shredder>
References: <20211210134550.1195182-1-maciej.machnikowski@intel.com>
 <YbXhXstRpzpQRBR8@shredder>
 <MW5PR11MB5812E5A30C05E2F1EAB2D9D5EA769@MW5PR11MB5812.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW5PR11MB5812E5A30C05E2F1EAB2D9D5EA769@MW5PR11MB5812.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 12:13:47PM +0000, Machnikowski, Maciej wrote:
> > -----Original Message-----
> > From: Ido Schimmel <idosch@idosch.org>
> > Sent: Sunday, December 12, 2021 12:48 PM
> > To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> > Subject: Re: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
> > 
> > On Fri, Dec 10, 2021 at 02:45:46PM +0100, Maciej Machnikowski wrote:
> > > Synchronous Ethernet networks use a physical layer clock to syntonize
> > > the frequency across different network elements.
> > >
> > > Basic SyncE node defined in the ITU-T G.8264 consist of an Ethernet
> > > Equipment Clock (EEC) and have the ability to synchronize to reference
> > > frequency sources.
> > >
> > > This patch series is a prerequisite for EEC object and adds ability
> > > to enable recovered clocks in the physical layer of the netdev object.
> > > Recovered clocks can be used as one of the reference signal by the EEC.
> > 
> > The dependency is the other way around. It doesn't make sense to add
> > APIs to configure the inputs of an object that doesn't exist. First add
> > the EEC object, then we can talk about APIs to configure its inputs from
> > netdevs.
> 
> This API configures frequency outputs of the PTY layer of
> a PHY/integrated MAC. It does not configure any inputs nor it interacts
> with the EEC. The goal of it is to expose the clock to the piece that
> requires it as a reference one (a DPLL/FPGA/anything else).

My fundamental issue with these patches is that instead of abstracting
the hardware from user space they give user space direct control over
it.

This approach has the advantage of keeping the kernel relatively simple
and fitting more use cases than just EEC, but these are also its
disadvantages. Complexity needs to live somewhere and if this complexity
is related to the abstraction of hardware, then it should live in the
kernel and not in user space. We should strive to come up with an API
that does the same thing regardless of the underlying hardware
implementation.

Look at the proposed API, it basically says "Make the clock recovered
from eth0 available on pin 1". If user space issues this command on
different systems, it will mean different things, based on the
underlying design of the hardware and the connection of the pin: To
"DPLL/FPGA/anything else".

Contrast that with an API that says "Set the source of EEC X to the
clock recovered from eth0". This API is well defined and does the same
thing across different systems.

Lets assume that these patches are merged as-is and tomorrow we get
another implementation of these two ethtool operations in a different
driver. We can't tell if these are used to feed the recovered clock into
an EEC like ice does or enable some other use case that we never
intended to enable.

Even if all the implementations use this API to feed the EEC, consider
how difficult it is going to be for user space to use it. Ideally, user
space should be able to query the state of the EEC and its source via an
EEC object in a single command. With the current approach in which we
have some amorphic object called "DPLL" that is only aware of pins and
not netdevs, it's going to be very hard. User space will see that the
DPLL is locked to the clock fed via pin 1. How user space is supposed to
understand what is the source of this clock? Issue RCLK_GET dump and
check for matching pin index that is enabled? User space has no reason
to do it given that it doesn't even know that the source is a netdev.

> 
> I don't agree with the statement that we must have EEC object first,
> as we can already configure different frequency sources using different
> subsystems.

Regardless of all the above technical arguments, I think that these
patches should not be merged now based on common sense alone. Not only
these patches are of very limited use without an EEC object, they also
prevent us from making changes to the API when such an object is
introduced.

> The source of signal should be separated from its consumer.

If it is completely separated (despite being hardwired on the board),
then user space does not know how the signal is used when it issues the
command. Is this signal fed into an EEC that controls that transmission
rate of other netdev? Is this signal fed into an FPGA that blinks a led?

>  
> > With these four patches alone, user space doesn't know how many EECs
> > there are in the system, it doesn't know the mapping from netdev to EEC,
> > it doesn't know the state of the EEC, it doesn't know which source is
> > chosen in case more than one source is enabled. Patch #3 tries to work
> > around it by having ice print to kernel log, when the information should
> > really be exposed via the EEC object.
> 
> The goal of them is to add API for recovered clocks - not for EECs.

What do you mean by "not for EECs"? The file is called
"net/ethtool/synce.c", if the signal is not being fed into an EEC then
into what? It is unclear what kind of back doors this API will open.

> This part is there for observability and will still be there when EEC
> is in place.  Those will need to be addressed by the DPLL subsystem.

If it is it only meant for observability, then why these messages are
emitted as warnings to the kernel log? Regardless, the user API should
be designed with observability in mind so that you wouldn't need to rely
on prints to the kernel log.

> 
> > +		dev_warn(ice_pf_to_dev(pf),
> > +			 "<DPLL%i> state changed to: %d, pin %d",
> > +			 ICE_CGU_DPLL_SYNCE,
> > +			 pf->synce_dpll_state,
> > +			 pin);
> > 
> > >
> > > Further work is required to add the DPLL subsystem, link it to the
> > > netdev object and create API to read the EEC DPLL state.
> > 
> > When the EEC object materializes, we might find out that this API needs
> > to be changed / reworked / removed, but we won't be able to do that
> > given it's uAPI. I don't know where the confidence that it won't happen
> > stems from when there are so many question marks around this new
> > object.
> 
> This API follows the functionality of other frequency outputs that exist
> in the kernel, like PTP period file for frequency output of PTP clock
> or other GPIOs. I highly doubt it'll change - we may extend it to add mapping
> between pins, but like I indicated - this will not always be known to SW.
> 
> Regards
> Maciek
