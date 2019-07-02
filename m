Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD3A5D461
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfGBQiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:38:01 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:47706 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfGBQiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:38:01 -0400
Received: from [5.158.153.52] (helo=mitra)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <b.spranger@linutronix.de>)
        id 1hiLn4-0007Jw-4a; Tue, 02 Jul 2019 18:37:58 +0200
Date:   Tue, 2 Jul 2019 18:28:34 +0200
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH v2 2/2] Documentation: net: dsa: b53: Describe b53
 configuration
Message-ID: <20190702182834.7d2eb022@mitra>
In-Reply-To: <20190701173550.GH30468@lunn.ch>
References: <20190701154209.27656-1-b.spranger@linutronix.de>
        <20190701154209.27656-3-b.spranger@linutronix.de>
        <20190701173550.GH30468@lunn.ch>
Organization: Linutronix GmbH
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Mon, 1 Jul 2019 19:35:50 +0200
schrieb Andrew Lunn <andrew@lunn.ch>:

> > +Configuration without tagging support
> > +-------------------------------------
> 
> How does this differ to the text you just added in the previous patch?
The b53 has some implementation specific detail:

The b53 DSA driver tags the CPU port in all VLANs, since otherwise any
PVID untagged VLAN programming would basically change the CPU port's
default PVID and make it untagged, undesirable.

This need some attention while configuring. Therefore the configuration
is slightly different to the generic one:

The following extra commands are needed on b53 single port and gateway
configuration:

  bridge vlan del dev lan1 vid 1
  bridge vlan del dev lan2 vid 1

On bridge config the following commands are not needed:

  bridge vlan add dev lan1 vid 1 pvid untagged
  bridge vlan add dev lan2 vid 1 pvid untagged
  bridge vlan add dev lan3 vid 1 pvid untagged

> Do we need both?
I like full configuration examples. But it can also be done by
describing the changes. I would prefer both - description and full
script:

...
Configuration without tagging support
-------------------------------------

Older models (5325, 5365) support a different tag format that is not
supported yet. 539x and 531x5 require managed mode and some special
handling, which is also not yet supported. The tagging support is
disabled in these cases and the switch need a different configuration.

The configuration slightly differ from
the :ref:`dsa-vlan-configuration`.

+ The b53 tags the CPU port in all VLANs, since otherwise any PVID
+ untagged VLAN programming would basically change the CPU port's
+ default PVID and make it untagged, undesirable.

+ In difference to the configuration described
+ in :ref:`dsa-vlan-configuration` the default VLAN 1 has to be removed
+ from the slave interface configuration in single port and gateway
+ configuration, while there is no need to add an extra VLAN
+ configuration in the bridge showcase.

single port
~~~~~~~~~~~
...

Regards
    Bene Spranger
