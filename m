Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 605861941A4
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgCZOhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:37:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44091 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgCZOhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:37:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id m17so8047046wrw.11
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 07:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W1ReFUAZYhfzenPEIOYllIMZiz7+qwf9R8fsVyzvXbI=;
        b=hiHtNjrmXfBgjt/CTPrBee8qKXPX5+7MUeYZjnulcAWEeJ7x8DnO1zcRrgetjYWNpV
         YCyVtlaIRhxVhpHnENYCjXeWb/iTI0ZDTYgPUE9lPQuMnZdE+QUoQ5GPqdtqkkRM1sX8
         6bnxCiMgsLg1H3W4lwL0mdKHFg9oLUCAWTglUrqAis+egWNG1AqcjqwEatgaV0B1j0P2
         pPSQIicBOGpmylZSYXR3uaY6xFa6eZw6JnDa3I7FTtuiu21GaUPeAEfrgL75lfj9cDTS
         6fK+eR4FyDKxMOOpv5Ei+Ol+L+dY2Gh6SebjqH86+TEdY9fj+wLoNeIa2/vIaaws8Egg
         Ytpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W1ReFUAZYhfzenPEIOYllIMZiz7+qwf9R8fsVyzvXbI=;
        b=gbLvU9Krhpwjuj+2ZVKxBEXLVX9Tcn3Y01DRuRGKgKoxwItvE1iDd0c2R0H4nxni4b
         w8EZfpQ5eNTlnXEEfrE92PLXlcGplq6qp7GZFGA/mogGHDn84J/AuzZfH7bxHFgD493h
         70i6Y7r45T78UClPeiJqSXXIs9a2Cuoc3yRiUBd3hEbTIemRcPBV0AIuQYeKMhwSh2Up
         t7TE+3oiOnB+NOHSSG0pb3aitaJ1QgS8xsC4r5Yfn+832ECoPVi2RvqoHJ81+DpJCJYQ
         kSsDSY6cruSAh8EnQzbTsUdCURUlevUJhmm6ABW29csRFYvbC9QfysD2xmhntpY0D0at
         X7YQ==
X-Gm-Message-State: ANhLgQ0eMxRJouyP+Blbv1jGPu/slNlcLfhSfCGnNCSpW7VJV5LScX4U
        9uNFj1k2T9etcz4VTfiN2tuD6A==
X-Google-Smtp-Source: ADFU+vuDHaYHC1Phqwl1Xjq4OvZn+RjQyCnXbd7C5KIN8wx2jOtoeL82d79Ptvsdrg2tjrXbx27rsA==
X-Received: by 2002:adf:9e8c:: with SMTP id a12mr6028400wrf.273.1585233437308;
        Thu, 26 Mar 2020 07:37:17 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id d124sm3767109wmd.37.2020.03.26.07.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 07:37:15 -0700 (PDT)
Date:   Thu, 26 Mar 2020 15:37:14 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, parav@mellanox.com,
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
        vikas.gupta@broadcom.com, magnus.karlsson@intel.com
Subject: Re: [RFC] current devlink extension plan for NICs
Message-ID: <20200326143714.GU11304@nanopsycho.orion>
References: <20200319192719.GD11304@nanopsycho.orion>
 <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
 <20200320073555.GE11304@nanopsycho.orion>
 <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
 <20200321093525.GJ11304@nanopsycho.orion>
 <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 23, 2020 at 08:21:23PM CET, kuba@kernel.org wrote:
>> >> >> Note that the PF is merged with physical port representor.
>> >> >> That is due to simpler and flawless transition from legacy mode and back.
>> >> >> The devlink_ports and netdevs for physical ports are staying during
>> >> >> the transition.    
>> >> >
>> >> >When users put an interface under bridge or a bond they have to move 
>> >> >IP addresses etc. onto the bond. Changing mode to "switchdev" is a more
>> >> >destructive operation and there should be no expectation that
>> >> >configuration survives.    
>> >> 
>> >> Yeah, I was saying the same thing when our arch came up with this, but
>> >> I now think it is just fine. It is drivers responsibility to do the
>> >> shift. And the entities representing the uplink port: netdevs and
>> >> devlink_port instances. They can easily stay during the transition. The
>> >> transition only applies to the eswitch and VF entities.  
>> >
>> >If PF is split from the uplink I think the MAC address should stay with
>> >the PF, not the uplink (which becomes just a repr in a Host case).
>> >  
>> >> >The merging of the PF with the physical port representor is flawed.    
>> >> 
>> >> Why?  
>> >
>> >See below.
>> >  
>> >> >People push Qdisc offloads into devlink because of design shortcuts
>> >> >like this.    
>> >> 
>> >> Could you please explain how it is related to "Qdisc offloads"  
>> >
>> >Certain users have designed with constrained PCIe bandwidth in the
>> >server. Meaning NIC needs to do buffering much like a switch would.
>> >So we need to separate the uplink from the PF to attach the Qdisc
>> >offload for configuring details of PCIe queuing.  
>> 
>> Hmm, I'm not sure I understand. Then PF and uplink is the same entity,
>> you can still attach the qdisc to this entity, right? What prevents the
>> same functionality as with the "split"?
>
>The same problem we have with the VF TX rate. We only have Qdisc APIs
>for the TX direction. If we only have one port its TX is the TX onto
>wire. If we split it into MAC/phys and PCIe - the TX of PCI is the RX
>of the host, allowing us to control queuing on the PCIe interface.

I see. But is it needed? I mean, this is for the "management pf" on the
local host. You don't put it into VM. You should only use it for
slowpath (like arps, OVS, etc). If you want to have traffic from
localhost that you need to rate limit, you can either create dynamic PF
or VF or SF for it.
