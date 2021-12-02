Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E41A46686F
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 17:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359590AbhLBQjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 11:39:12 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:42813 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242448AbhLBQjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 11:39:12 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 57355580341;
        Thu,  2 Dec 2021 11:35:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 02 Dec 2021 11:35:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=qO5TWxz0VslvcOPL4PWFP816jxX9utC+/FimQIERU
        oE=; b=DvpkVY4eNf/ISg9YT7lCd2aobYCRqQiD7VaWgVEwTOrDLgJg/RsCVl9kR
        sgb2lmGWZIWsU8WfQnCJFATzzzT7Mu5CgGSonU7A561T7ib5noFGuAsTzmJl8kJL
        qpvdIv0prOhQ+6yzhnNz0ix7szhlWqY/3eeBNfFc1efjLljZwmuAx22XwnSgLHKl
        CRsYep934PXyCY7TblM5W1R8yMaFVDTUUIo5xYQY2PYZrJHcUsId8mKQL3M5srHp
        iT93plcXQd9iwwwOGL3qYCiTwrueTO+L+094r40oN6MHqds9AOMDqkHz4CwQMjO5
        jhboK8QuzfexHcuXSbeqN4r7tQLlA==
X-ME-Sender: <xms:5PWoYXaqOPyybGbY5I3Zb_oCog9pe3AhEUUYReJn05L61kdPJwjGMA>
    <xme:5PWoYWa0BA4bjelgU2Se6lF9SZcP8i9FAowAKxH9MrlBgBl-Xvt0C7VsvuDdQ3ZlM
    rkIWSkk5LhFl7s>
X-ME-Received: <xmr:5PWoYZ_LfOu10llXNK7sCW28cLN69Oo7pPcIHvL_YIcLTbMahD6kecWlHzYs-By_NrePUNShOfTG88NbnBh0mkgJGwmzRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrieehgdeltdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeefheethffhhfdvueevkeffffefjeejffefuedtfedvgfettdetkedtgfejtdeh
    udenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:5PWoYdr4ikClrFN0UvQNPm_Y5eE5-c5o_3QUTXh3XOSmAARhxRwZ5w>
    <xmx:5PWoYSqV-wd9DCF_9KQhJGiu1n2SybsYCB0K0-J5BeYIe5IriFRQeQ>
    <xmx:5PWoYTTbwN3opt7JNHRXOrIpWpeZpa2ES6EcOaAh8C_ZiSQShAYa7g>
    <xmx:5fWoYfQi1OGKqDll9M4pqZzdy6oYdmikVu9XJEgYTIpX_97nlRzK5Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Dec 2021 11:35:47 -0500 (EST)
Date:   Thu, 2 Dec 2021 18:35:42 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>
Subject: Re: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
 recovered clock for SyncE feature
Message-ID: <Yaj13pwDKrG78W5Y@shredder>
References: <20211201180208.640179-1-maciej.machnikowski@intel.com>
 <20211201180208.640179-3-maciej.machnikowski@intel.com>
 <Yai/e5jz3NZAg0pm@shredder>
 <MW5PR11MB5812455176BC656BABCFF1B0EA699@MW5PR11MB5812.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MW5PR11MB5812455176BC656BABCFF1B0EA699@MW5PR11MB5812.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 03:17:06PM +0000, Machnikowski, Maciej wrote:
> > -----Original Message-----
> > From: Ido Schimmel <idosch@idosch.org>
> > Sent: Thursday, December 2, 2021 1:44 PM
> > To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> > Subject: Re: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
> > recovered clock for SyncE feature
> > 
> > On Wed, Dec 01, 2021 at 07:02:06PM +0100, Maciej Machnikowski wrote:
> > > +RCLK_GET
> > > +========
> > > +
> > > +Get status of an output pin for PHY recovered frequency clock.
> > > +
> > > +Request contents:
> > > +
> > > +  ======================================  ======
> > ==========================
> > > +  ``ETHTOOL_A_RCLK_HEADER``               nested  request header
> > > +  ``ETHTOOL_A_RCLK_OUT_PIN_IDX``          u32     index of a pin
> > > +  ======================================  ======
> > ==========================
> > > +
> > > +Kernel response contents:
> > > +
> > > +  ======================================  ======
> > ==========================
> > > +  ``ETHTOOL_A_RCLK_OUT_PIN_IDX``          u32     index of a pin
> > > +  ``ETHTOOL_A_RCLK_PIN_FLAGS``            u32     state of a pin
> > > +  ``ETHTOOL_A_RCLK_RANGE_MIN_PIN``        u32     min index of RCLK pins
> > > +  ``ETHTOOL_A_RCLK_RANGE_MAX_PIN``        u32     max index of RCLK
> > pins
> > > +  ======================================  ======
> > ==========================
> > > +
> > > +Supported device can have mulitple reference recover clock pins available
> > 
> > s/mulitple/multiple/
> > 
> > > +to be used as source of frequency for a DPLL.
> > > +Once a pin on given port is enabled. The PHY recovered frequency is being
> > > +fed onto that pin, and can be used by DPLL to synchonize with its signal.
> > 
> > s/synchonize/synchronize/
> > 
> > Please run a spell checker on documentation
> > 
> > > +Pins don't have to start with index equal 0 - device can also have different
> > > +external sources pins.
> > > +
> > > +The ``ETHTOOL_A_RCLK_OUT_PIN_IDX`` is optional parameter. If present
> > in
> > > +the RCLK_GET request, the ``ETHTOOL_A_RCLK_PIN_ENABLED`` is
> > provided in a
> > 
> > The `ETHTOOL_A_RCLK_PIN_ENABLED` attribute is no where to be found in
> > this submission
> > 
> > > +response, it contatins state of the pin pointed by the index. Values are:
> > 
> > s/contatins/contains/
> > 
> > > +
> > > +.. kernel-doc:: include/uapi/linux/ethtool.h
> > > +    :identifiers: ethtool_rclk_pin_state
> > 
> > This structure is also no where to be found
> > 
> > > +
> > > +If ``ETHTOOL_A_RCLK_OUT_PIN_IDX`` is not present in the RCLK_GET
> > request,
> > > +the range of available pins is returned:
> > > +``ETHTOOL_A_RCLK_RANGE_MIN_PIN`` is lowest possible index of a pin
> > available
> > > +for recovering frequency from PHY.
> > > +``ETHTOOL_A_RCLK_RANGE_MAX_PIN`` is highest possible index of a pin
> > available
> > > +for recovering frequency from PHY.
> > > +
> > > +RCLK_SET
> > > +==========
> > > +
> > > +Set status of an output pin for PHY recovered frequency clock.
> > > +
> > > +Request contents:
> > > +
> > > +  ======================================  ======
> > ========================
> > > +  ``ETHTOOL_A_RCLK_HEADER``               nested  request header
> > > +  ``ETHTOOL_A_RCLK_OUT_PIN_IDX``          u32     index of a pin
> > > +  ``ETHTOOL_A_RCLK_PIN_FLAGS``            u32      requested state
> > > +  ======================================  ======
> > ========================
> > > +
> > > +``ETHTOOL_A_RCLK_OUT_PIN_IDX`` is a index of a pin for which the
> > change of
> > > +state is requested. Values of ``ETHTOOL_A_RCLK_PIN_ENABLED`` are:
> > > +
> > > +.. kernel-doc:: include/uapi/linux/ethtool.h
> > > +    :identifiers: ethtool_rclk_pin_state
> > 
> > Same.
> 
> Done - rewritten the manual
> 
> > Looking at the diagram from the previous submission [1]:
> > 
> >       ┌──────────┬──────────┐
> >       │ RX       │ TX       │
> >   1   │ ports    │ ports    │ 1
> >   ───►├─────┐    │          ├─────►
> >   2   │     │    │          │ 2
> >   ───►├───┐ │    │          ├─────►
> >   3   │   │ │    │          │ 3
> >   ───►├─┐ │ │    │          ├─────►
> >       │ ▼ ▼ ▼    │          │
> >       │ ──────   │          │
> >       │ \____/   │          │
> >       └──┼──┼────┴──────────┘
> >         1│ 2│        ▲
> >  RCLK out│  │        │ TX CLK in
> >          ▼  ▼        │
> >        ┌─────────────┴───┐
> >        │                 │
> >        │       SEC       │
> >        │                 │
> >        └─────────────────┘
> > 
> > Given a netdev (1, 2 or 3 in the diagram), the RCLK_SET message allows
> > me to redirect the frequency recovered from this netdev to the EEC via
> > either pin 1, pin 2 or both.
> > 
> > Given a netdev, the RCLK_GET message allows me to query the range of
> > pins (RCLK out 1-2 in the diagram) through which the frequency can be
> > fed into the EEC.
> > 
> > Questions:
> > 
> > 1. The query for all the above netdevs will return the same range of
> > pins. How does user space know that these are the same pins? That is,
> > how does user space know that RCLK_SET message to redirect the frequency
> > recovered from netdev 1 to pin 1 will be overridden by the same message
> > but for netdev 2?
> 
> We don't have a way to do so right now. When we have EEC subsystem in place
> the right thing to do will be to add EEC input index and EEC index as additional
> arguments
> 
> > 2. How does user space know the mapping between a netdev and an EEC?
> > That is, how does user space know that RCLK_SET message for netdev 1
> > will cause the Tx frequency of netdev 2 to change according to the
> > frequency recovered from netdev 1?
> 
> Ditto - currently we don't have any entity to link the pins to ATM,
> but we can address that in userspace just like PTP pins are used now
> 
> > 3. If user space sends two RCLK_SET messages to redirect the frequency
> > recovered from netdev 1 to RCLK out 1 and from netdev 2 to RCLK out 2,
> > how does it know which recovered frequency is actually used an input to
> > the EEC?

User space doesn't know this as well?

> >
> > 4. Why these pins are represented as attributes of a netdev and not as
> > attributes of the EEC? That is, why are they represented as output pins
> > of the PHY as opposed to input pins of the EEC?
> 
> They are 2 separate beings. Recovered clock outputs are controlled
> separately from EEC inputs. 

Separate how? What does it mean that they are controlled separately? In
which sense? That redirection of recovered frequency to pin is
controlled via PHY registers whereas priority setting between EEC inputs
is controlled via EEC registers? If so, this is an implementation detail
of a specific design. It is not of any importance to user space.

> If we mix them it'll be hard to control everything especially that a
> single EEC can support multiple devices.

Hard how? Please provide concrete examples.

What do you mean by "multiple devices"? A multi-port adapter with a
single EEC or something else?

> Also if we make those pins attributes of the EEC it'll become extremally hard
> to map them to netdevs and control them from the userspace app that will
> receive the ESMC message with a given QL level on netdev X.

Hard how? What is the problem with something like:

# eec set source 1 type netdev dev swp1

The EEC object should be registered by the same entity that registers
the netdevs whose Tx frequency is controlled by the EEC, the MAC driver.

>  
> > 5. What is the problem with the following model?
> > 
> > - The EEC is a separate object with following attributes:
> >   * State: Invalid / Freerun / Locked / etc
> >   * Sources: Netdev / external / etc
> >   * Potentially more
> > 
> > - Notifications are emitted to user space when the state of the EEC
> >   changes. Drivers will either poll the state from the device or get
> >   interrupts
> > 
> > - The mapping from netdev to EEC is queried via ethtool
> 
> Yep - that will be part of the EEC (DPLL) subsystem

This model avoids all the problems I pointed out in the current
proposal.

> 
> > [1] https://lore.kernel.org/netdev/20211110114448.2792314-1-
> > maciej.machnikowski@intel.com/
