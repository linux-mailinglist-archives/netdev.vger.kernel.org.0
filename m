Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456C53257B8
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 21:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234212AbhBYUc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 15:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhBYUac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 15:30:32 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1811EC06178A
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 12:29:25 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id q14so8032889ljp.4
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 12:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=7QYUiOFTzNYSbDaUQW0ndoamvpPDOjzU7K7ei8p78+E=;
        b=DK3xB9tRaSavoAlKKNoAuiAkiDQ+D9Mw3f1PKtztAw4GBmpkrvkEuUMBB68mrPM6Oe
         2hQQ4KXyS4Xx0xjSl/SdpC4kjtWu2DKVjqk5BZ6l96o7fD9nMxLt5jkRRnKQqISx19E9
         bELvc6iit6wKnx6hsSf1V+M4TCBSEtXd34OhwIEa4RsxDYkK2Xov9l2Lxhdn/unPfqJN
         4idJ+Y45oU1tc3xVOJaUZph2dNZUh5xgYUEjUlIrf8DrLD7RCdo6nwjc9tmOVopdrxQ4
         CnVhkESrf+Ym7+VzZ5x5oP2txQ9b0oX7cFEW1xdVrjNFzw33pZKS11S90gyEAWwrR4Br
         EWSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7QYUiOFTzNYSbDaUQW0ndoamvpPDOjzU7K7ei8p78+E=;
        b=auGVdsZ32x0Zd0RlY6iRK0vJMwLbluWiQ91mcbYoUFymoegFHSwcz358SqRpMWaWBc
         rMTTrkDrM1Xu6Q3FvgaupKfkROEP7jLUBC77M5dvH6oPA/m01ENlu3C9VxrgRWgUk6Ue
         Vp4piKWWdumsPGklBEUrGQAHde5xmPY4U2dUNGEFCtBME/fZfVBN8UMr3davaGDsfCYR
         QomXQSowUyjQcDAFovx2kBOeraNccmEuzWUDxGUlIF7yXIa+XXNU031+ituUECmcbWL4
         YP5PVCXRM5Fgcc1Qqs7UywPlM3P7FlTQMNkhhxfiDyH4yOw8kfLm6x/Y6EBE2meVgF6A
         nlSw==
X-Gm-Message-State: AOAM5333I4GJan5caJxKLg9KyPO0sf/9P7wMM6GGAvIIUy4EWQtmmz28
        JGhhFODgXVaY8enhRpm4dDVqjA==
X-Google-Smtp-Source: ABdhPJxOKwMYx74MIOvvLMC119wknibZPRFlmBuTdwblOWnJ4iBfp129312j3Dt1xWGtMfNsp1wfVA==
X-Received: by 2002:a2e:890b:: with SMTP id d11mr2439784lji.3.1614284963494;
        Thu, 25 Feb 2021 12:29:23 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id q26sm440391ljg.90.2021.02.25.12.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 12:29:22 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH net-next 02/12] Documentation: networking: dsa: rewrite chapter about tagging protocol
In-Reply-To: <20210221213355.1241450-3-olteanv@gmail.com>
References: <20210221213355.1241450-1-olteanv@gmail.com> <20210221213355.1241450-3-olteanv@gmail.com>
Date:   Thu, 25 Feb 2021 21:29:21 +0100
Message-ID: <87y2fbrivy.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 21, 2021 at 23:33, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> The chapter about tagging protocols is out of date because it doesn't
> mention all taggers that have been added since last documentation
> update. But judging based on that, it will always tend to lag behind,
> and there's no good reason why we would enumerate the supported
> hardware. Instead we could do something more useful and explain what
> there is to know about tagging protocols instead.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  Documentation/networking/dsa/dsa.rst | 126 +++++++++++++++++++++++++--
>  1 file changed, 118 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
> index e20fbad2241a..fc98b5774fb6 100644
> --- a/Documentation/networking/dsa/dsa.rst
> +++ b/Documentation/networking/dsa/dsa.rst
> @@ -65,14 +65,8 @@ Note that DSA does not currently create network interfaces for the "cpu" and
>  Switch tagging protocols
>  ------------------------
>  
> -DSA currently supports 5 different tagging protocols, and a tag-less mode as
> -well. The different protocols are implemented in:
> -
> -- ``net/dsa/tag_trailer.c``: Marvell's 4 trailer tag mode (legacy)
> -- ``net/dsa/tag_dsa.c``: Marvell's original DSA tag
> -- ``net/dsa/tag_edsa.c``: Marvell's enhanced DSA tag
> -- ``net/dsa/tag_brcm.c``: Broadcom's 4 bytes tag
> -- ``net/dsa/tag_qca.c``: Qualcomm's 2 bytes tag
> +DSA supports many vendor-specific tagging protocols, one software-defined
> +tagging protocol, and a tag-less mode as well (``DSA_TAG_PROTO_NONE``).
>  
>  The exact format of the tag protocol is vendor specific, but in general, they
>  all contain something which:
> @@ -80,6 +74,122 @@ all contain something which:
>  - identifies which port the Ethernet frame came from/should be sent to
>  - provides a reason why this frame was forwarded to the management interface
>  
> +All tagging protocols are in ``net/dsa/tag_*.c`` files and implement the
> +methods of the ``struct dsa_device_ops`` structure, which are detailed below.
> +
> +Tagging protocols generally fall in one of three categories:
> +
> +- The switch-specific frame header is located before the Ethernet header,
> +  shifting to the right (from the perspective of the DSA master's frame
> +  parser) the MAC DA, MAC SA, EtherType and the entire L2 payload.
> +- The switch-specific frame header is located before the EtherType, keeping the
> +  MAC DA and MAC SA in place from the DSA master's perspective, but shifting
> +  the 'real' EtherType and L2 payload to the right.
> +- The switch-specific frame header is located at the tail of the packet,
> +  keeping all frame headers in place and not altering the view of the packet
> +  that the DSA master's frame parser has.

A nit, but should this be a numbered list since "category 1 and 2" is
referenced later?

> +
> +A tagging protocol may tag all packets with switch tags of the same length, or
> +the tag length might vary (for example packets with PTP timestamps might
> +require an extended switch tag, or there might be one tag length on TX and a
> +different one on RX). Either way, the tagging protocol driver must populate the
> +``struct dsa_device_ops::overhead`` with the length in octets of the longest
> +switch frame header. The DSA framework will automatically adjust the MTU of the
> +master interface to accomodate for this extra size in order for DSA user ports
> +to support the standard MTU (L2 payload length) of 1500 octets. The ``overhead``
> +is also used to request from the network stack, on a best-effort basis, the
> +allocation of packets with a ``needed_headroom`` or ``needed_tailroom``
> +sufficient such that the act of pushing the switch tag on transmission of a
> +packet does not cause it to reallocate due to lack of memory.
> +
> +Even though applications are not expected to parse DSA-specific frame headers,
> +the format on the wire of the tagging protocol represents an Application Binary
> +Interface exposed by the kernel towards user space, for decoders such as
> +``libpcap``. The tagging protocol driver must populate the ``proto`` member of
> +``struct dsa_device_ops`` with a value that uniquely describes the
> +characteristics of the interaction required between the switch hardware and the
> +data path driver: the offset of each bit field within the frame header and any
> +stateful processing required to deal with the frames (as may be required for
> +PTP timestamping).
> +
> +By definition, all switches within the same DSA switch tree use the same
> +tagging protocol. In case of a packet transiting a fabric with more than one

This is not strictly true for mv88e6xxx. The connection between the tree
and the CPU may use Ethertyped DSA tags, while inter-switch links use
regular DSA tags.

However, I think it is better to keep this definition short, as it is
"true enough" :)

> +switch, the switch-specific frame header is inserted by the first switch in the
> +fabric that the packet was received on. This header typically contains
> +information regarding its type (whether it is a control frame that must be
> +trapped to the CPU, or a data frame to be forwarded). Control frames should be
> +decapsulated only by the software data path, whereas data frames might also be
> +autonomously forwarded towards other user ports of other switches from the same
> +fabric, and in this case, the outermost switch ports must decapsulate the packet.
> +
> +It is possible to construct cascaded setups of DSA switches even if their
> +tagging protocols are not compatible with one another. In this case, there are
> +no DSA links in this fabric, and each switch constitutes a disjoint DSA switch
> +tree. The DSA links are viewed as simply a pair of a DSA master (the out-facing
> +port of the upstream DSA switch) and a CPU port (the in-facing port of the
> +downstream DSA switch).
> +
> +The tagging protocol of the attached DSA switch tree can be viewed through the
> +``dsa/tagging`` sysfs attribute of the DSA master::
> +
> +    cat /sys/class/net/eth0/dsa/tagging
> +
> +If the hardware and driver are capable, the tagging protocol of the DSA switch
> +tree can be changed at runtime. This is done by writing the new tagging
> +protocol name to the same sysfs device attribute as above (the DSA master and
> +all attached switch ports must be down while doing this).
> +
> +It is desirable that all tagging protocols are testable with the ``dsa_loop``
> +mockup driver, which can be attached to any network interface. The goal is that
> +any network interface should be able of transmitting the same packet in the
> +same way, and the tagger should decode the same received packet in the same way
> +regardless of the driver used for the switch control path, and the driver used
> +for the DSA master.
> +
> +The transmission of a packet goes through the tagger's ``xmit`` function.
> +The passed ``struct sk_buff *skb`` has ``skb->data`` pointing at
> +``skb_mac_header(skb)``, i.e. at the destination MAC address, and the passed
> +``struct net_device *dev`` represents the virtual DSA user network interface
> +whose hardware counterpart the packet must be steered to (i.e. ``swp0``).
> +The job of this method is to prepare the skb in a way that the switch will
> +understand what egress port the packet is for (and not deliver it towards other
> +ports). Typically this is fulfilled by pushing a frame header. Checking for
> +insufficient size in the skb headroom or tailroom is unnecessary provided that
> +the ``overhead`` and ``tail_tag`` properties were filled out properly, because
> +DSA ensures there is enough space before calling this method.
> +
> +The reception of a packet goes through the tagger's ``rcv`` function. The
> +passed ``struct sk_buff *skb`` has ``skb->data`` pointing at
> +``skb_mac_header(skb) + ETH_ALEN`` octets, i.e. to where the first octet after
> +the EtherType would have been, were this frame not tagged. The role of this
> +method is to consume the frame header, adjust ``skb->data`` to really point at
> +the first octet after the EtherType, and to change ``skb->dev`` to point to the
> +virtual DSA user network interface corresponding to the physical front-facing
> +switch port that the packet was received on.
> +
> +Some tagging protocols, such as those in category 1 (shifting the MAC DA as
> +seen by the DSA master), require the DSA master to operate in promiscuous mode,
> +to receive all frames regardless of the value of the MAC DA. This can be done
> +by setting the ``promisc_on_master`` property of the ``struct dsa_device_ops``.
> +
> +Since tagging protocols in category 1 and 2 break software (and most often also
> +hardware) packet dissection on the DSA master, features such as RPS (Receive
> +Packet Steering) on the DSA master would be broken. The DSA framework deals
> +with this by hooking into the flow dissector and shifting the offset at which
> +the IP header is to be found in the tagged frame as seen by the DSA master.
> +This behavior is automatic based on the ``overhead`` value of the tagging
> +protocol. If not all packets are of equal size, the tagger can implement the
> +``flow_dissect`` method of the ``struct dsa_device_ops`` and override this
> +default behavior by specifying the correct offset incurred by each individual
> +RX packet. Tail taggers do not cause issues to the flow dissector.
> +
> +Hardware manufacturers are strongly discouraged to do this, but some tagging
> +protocols might not provide source port information on RX for all packets, but
> +e.g. only for control traffic (link-local PDUs). In this case, by implementing
> +the ``filter`` method of ``struct dsa_device_ops``, the tagger might select
> +which packets are to be redirected on RX towards the virtual DSA user network
> +interfaces, and which are to be left in the DSA master's RX data path.
> +
>  Master network devices
>  ----------------------
>  
> -- 
> 2.25.1

Great stuff!

Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
