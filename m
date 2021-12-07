Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F63146C32B
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 19:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236181AbhLGS5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 13:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbhLGS5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 13:57:17 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAD1C061574;
        Tue,  7 Dec 2021 10:53:46 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id w1so60648866edc.6;
        Tue, 07 Dec 2021 10:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=fUlY4LTKHwXbxbYcpl4JSEaEiScO6d6eYAb4xAw34iQ=;
        b=oCGB3vLyLBqgQ6j5jmoCZ5acU0AYWQ8OHaTFP9sJ5p3TpK2x5KFbH2sfjCy+QgHlda
         cVdeSM8MW0Zh8joch1QozcclebVkHnbW14qDSv3eFWvoZw+JH9IFo6ecllIFeoLCdsuK
         7w6i8xDj1+SYlilCXkRNMK+VqKUU0RseZcNkblemogSSTAOMg+sPRrCAsagDX2h02lp3
         QIX8oAhfl9r/06f4fJlNOA9vFsMoDOg4BOsvmhnbKB9xgrGwSkA5pThxBVzFv/9By7wW
         Yj6A7iRX4GpcusMHQ00bwox5USh0EAU/qlGR7GX47MgI740mp6cz98SGjlgczNpio+Ah
         hxDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=fUlY4LTKHwXbxbYcpl4JSEaEiScO6d6eYAb4xAw34iQ=;
        b=TUxgjz6M/ejtIzDxZq7bl/AN9fT2C+Xrb9tC9V1i1lKvmqn6E5k4j+La5LxV0tnf/5
         1WYIPmWbHrJLCPO5XbJ1YQnUxHoGf56x9cRJvuqimsBGJqrxvAvixS643UaxZZ+I2UIQ
         MSh8Koz3d0xiLr1yeXhVuKaN4JySAEZQiatM1znnxTEpwIHqbirWY4pMLHYn9rvEVyDW
         wR/rK510v+9MnD3Jr5FhuIfZQ7GkhH9Q62XO6TjouG9vgc6gxiWHtLkziAEVgIIq7pCO
         XP/y4IABvndoPBp7pRqauLaJYBO7SeAusNrICCvE8nUPsQpeVu3CBB+RoPt4d4CCB4qT
         CGHg==
X-Gm-Message-State: AOAM532IWL58bM21239ujF2wAFCTH8p4lJm5iCWW6FjtZiKPzf3l4iB2
        QB9+qA9x56JklRlmcLlLeWA=
X-Google-Smtp-Source: ABdhPJwNQAcKlRruoBZ9uvD3AcJo37DxxZDZVQ/J/370BZxibOdllX0sCAYxLwy1la5Md9YtGc4SfA==
X-Received: by 2002:a17:907:8a20:: with SMTP id sc32mr1359019ejc.65.1638903225261;
        Tue, 07 Dec 2021 10:53:45 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id t5sm404482edd.68.2021.12.07.10.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 10:53:45 -0800 (PST)
Message-ID: <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
X-Google-Original-Message-ID: <Ya+tt/I+gFi95GI6@Ansuel-xps.>
Date:   Tue, 7 Dec 2021 19:53:43 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya+q02HlWsHMYyAe@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya+q02HlWsHMYyAe@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 07:41:23PM +0100, Andrew Lunn wrote:
> > I still have to find a solution to a slowdown problem and this is where
> > I would love to get some hint.
> > Currently I still didn't find a good way to understand when the tagger
> > starts to accept packets and because of this the initial setup is slow
> > as every completion timeouts. Am I missing something or is there a way
> > to check for this?
> 
> I've not looked at this particular driver, i just know the general
> architecture.
> 
> The MDIO bus driver probes first, maybe as part of the Ethernet
> driver, maybe as a standalone MDIO driver. The switch is found in DT
> and the driver code will at some point later probe the switch driver.
> 
> The switch driver has working MDIO at this point. It should use MDIO
> to talk to the switch, make sure it is there, maybe do some initial
> configuration. Once it is happy, it registers the switch with the DSA
> core using dsa_register_switch().
> 
> If this is a single switch, the DSA core will then start setting
> things up. As part of dsa_switch_setup() it will call the switch
> drivers setup() method. It then figures out what tag driver to use, by
> calling dsa_switch_setup_tag_protocol(). However, the tag driver
> itself is not inserted into the chain yet. That happens later.  Once
> the switch is setup, dsa_tree_setup_master() is called which does
> dsa_master_setup() and in the middle there is:
> 
> 	/* If we use a tagging format that doesn't have an ethertype
> 	 * field, make sure that all packets from this point on get
> 	 * sent to the tag format's receive function.
> 	 */
> 	wmb();
> 
> 	dev->dsa_ptr = cpu_dp;
> 
> This is the magic to actually enable the tagger receiving frames.
> 

Will check if using this is the correct way to prevent use of this
alternative way before it's available.

> I need to look at your patches, but why is the tagger involved?  At
> least for the Marvell switch, you send a pretty normal looking
> Ethernet frame to a specific MAC address, and the switch replies using
> that MAC address. And it has an Ether Type specific to switch
> control. Since this is all normal looking, there are hooks in the
> network stack which can be used to get these frames.
>

The qca tag header provide a TYPE value that refer to a big list of
Frame type. In all of this at value 2 we have the type that tells us
that is a READ_WRITE_REG_ACK (aka a mdio rw Ethernet packet)

The idea of using the tagger is to skip parsing the packet 2 times
considering the qca tag header is present at the same place in both
normal packet and mdio rw Ethernet packet.

Your idea would be hook this before the tagger and parse it?
I assume that is the only way if this has to be generilized. But I
wonder if this would create some overhead by the double parsing.

> 	Andrew
> 

-- 
	Ansuel
