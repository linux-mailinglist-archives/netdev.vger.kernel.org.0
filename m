Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2FCE2A2268
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 00:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgKAXly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 18:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727062AbgKAXly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 18:41:54 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A9CC0617A6;
        Sun,  1 Nov 2020 15:41:53 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id j24so16423167ejc.11;
        Sun, 01 Nov 2020 15:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HI3PP9QtZ/Qjyb8cABlBJfJjZ1881bFjtbOEqr8Ox1E=;
        b=TdNmNydvS2e5El/zxmcPdjc8QJ1Z8bXlvOqzXk1PFihmDPzyZ3sLGPNsWRekq5SsLd
         hKJXRmTfbp9QFkZIFMlvk5nr770pnysrzNUdLzt8odSp4DnKBHZYVU3ymJ/UwremQByJ
         TH16FxjYKqxklm8iV3y+CpRdoNhvSVWJ6jLXTQ1Lf4KrxTCWr97d3D9ghoKOaQN8/XPP
         NWaTPP81E3KFD0Vdpa0jtmPHnB+gVBUJCHIpttGfEmQSRFUk5izWXgf5mtr2u5b8QKDv
         Ht6jGbNB2Gas3SApQT48xPzdK/sPQfgZn1KmVsKRaKVAIE1wfaDDY+AnH3gUmZWJfQIT
         CXIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HI3PP9QtZ/Qjyb8cABlBJfJjZ1881bFjtbOEqr8Ox1E=;
        b=BpWO/zjsf2cBNmm2sf+fpqjD1L0dos7ggrWHYYJWIm1D2cZmzMgXS44YNuh0uiZjXV
         844XqLgpCDCRR8adWkgevW/DL2JU0GLZ7+JI1WIC3uTqFBCMPBMqBzEMkAjRdN+b5Jo7
         zYXK47xyFLCH7caYOJiJgNtrmlTTcC+etPe0vJlvR+d+tLVL5QZlu4nrm3YIfoBCcAFj
         i/Cpcd1Ow9N+6rWZQ2HL6vWRjRAcsK53zfDr452YaaP7Ih17IVQlIJCb4DLP0GODnWK+
         Bo2C2uKXGhoBSjwE7nka8dLK0ahr3UylIS3CdWyR9s0RnXrrQ+7FhHMeuyCKdxUFY47A
         WADQ==
X-Gm-Message-State: AOAM531MUwqS35Zjb9aznveUx2I6ramQJ2HBVD3p7dYDRuokonW/cNNM
        gmNSCmFREsmQK1EIUzZNNHYboMZv3Vk=
X-Google-Smtp-Source: ABdhPJzykCVuMx9nPZ/dEAIrvTSyri7TStVMgSGxjSj2D7VG4NkQfh4YoDPaIeovXdlFIRTJM9Tuew==
X-Received: by 2002:a17:906:c20f:: with SMTP id d15mr12565235ejz.341.1604274112091;
        Sun, 01 Nov 2020 15:41:52 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id sa23sm8424267ejb.80.2020.11.01.15.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 15:41:51 -0800 (PST)
Date:   Mon, 2 Nov 2020 01:41:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add
 hardware time stamping support
Message-ID: <20201101234149.rrhrjiyt7l4orkm7@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de>
 <4928494.XgmExmOR0V@n95hx1g2>
 <20201101111008.vl4lj4iqmqjdpbyg@skbuf>
 <3355013.oZEI4y40TO@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3355013.oZEI4y40TO@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 11:14:24PM +0100, Christian Eggers wrote:
> I am not sure whether I understand the question.

When the port is in standalone mode, there is no other destination for
packets except for the CPU. So if the switch filters out Sync or
Delay_Req packets depending on the operating mode, then naturally those
packets would get dropped somewhere, and I wanted to see where.

> I have run "ethtool -S" two times on the PTP master clock (E2E mode):
> - When "ocmode" is set to master (DelayReq messages can be received)
> - When "ocmode" is set to slave (DelayReq messages cannot be received)
> 
> Here is the diff output:
> --- /home/root/ethtool1
> +++ /home/root/ethtool2
> @@ -1,8 +1,8 @@
>  NIC statistics:
> -     tx_packets: 1421
> -     tx_bytes: 133641
> -     rx_packets: 488
> -     rx_bytes: 35904
> +     tx_packets: 1455
> +     tx_bytes: 136783
> +     rx_packets: 496
> +     rx_bytes: 36459
>       rx_hi: 0
>       rx_undersize: 0
>       rx_fragments: 0
> @@ -14,10 +14,10 @@
>       rx_mac_ctrl: 0
>       rx_pause: 0
>       rx_bcast: 4
> -     rx_mcast: 667
> +     rx_mcast: 683
>       rx_ucast: 0
>       rx_64_or_less: 0
> -     rx_65_127: 659
> +     rx_65_127: 675
>       rx_128_255: 11
>       rx_256_511: 1
>       rx_512_1023: 0
> @@ -27,15 +27,15 @@
>       tx_hi: 0
>       tx_late_col: 0
>       tx_pause: 0
> -     tx_bcast: 713
> -     tx_mcast: 1852
> -     tx_ucast: 324
> +     tx_bcast: 733
> +     tx_mcast: 1897
> +     tx_ucast: 333
>       tx_deferred: 0
>       tx_total_col: 0
>       tx_exc_col: 0
>       tx_single_col: 0
>       tx_mult_col: 0
> -     rx_total: 61158
> -     tx_total: 307225
> +     rx_total: 62577
> +     tx_total: 313773
>       rx_discards: 20
>       tx_discards: 0

These counters seem to be on the front-panel port, and the discard seems
to not be recorded there. But nonetheless, even if you do see the drops
in the ethtool statistics for the CPU port, it's probably going to be at
'tx_discards' which is pretty unspecific and not useful. I was thinking
that the drop reason would be more elaborate, which it looks like it
isn't.

> My assumption is that the KSZ9563 simply doesn't forward specific PTP
> packages from the slave ports to the CPU port. In my imagination this
> happens in hardware and is not visible in software.

You talked about tracking the BMCA by snooping Announce messages. I
don't think that is going to be the path forward either. Think about the
general case, where there might not even be a BMCA (like in the
automotive profile).

It almost seems to me as if the hardware is trying to be helpful by
dropping the PTP messages that the application layer would drop anyway.
Too bad that nobody seems to have told them to make this helpful
mechanism optional, because as it is, it's standing in the way more than
helping.

You know what the real problem is, with DSA you don't have the concept
of the host port being an Ordinary Clock. DSA does not treat the host
port as a switched endpoint (aka a plain net device attached to a dumb
switch, and unaware of that switch), but instead is the conduit interface
for each front-panel switch interface, which is an individually
addressable network interface in its own right. You are not supposed to
use a DSA master interface for networking directly, not for regular
networking and not for PTP. In fact, DSA-enabled ports, only the PTP
clock of the switch is usable. If you attempt to run ptp4l on the master
interface an error will be thrown back at you.

Why am I mentioning this? Because the setting that's causing trouble for
us is 'port state of the host port OC', which in the context of what I
said above is nonsense. There _is_ no host port OC. There are 2 switch
ports which can act as individual OCs, or as a BC, or as a TC. But
consider the case when the switch is a BC, with one of the front-panel
ports being a master and the other a slave. What mode are you supposed
to put the host port in, so that it receives both the Sync packets from
the slave port, and the Delay_Req packets from the master port?! It just
makes no sense to me. In principle I don't see any reason why this
switch would not be able to operate as a one-step peer delay BC.

Unless somebody from Microchip could shed some light on the design
decisions of this switch (and there are enough Microchip people copied
already), here's what I would do. I would cut my losses and just support
peer delay, no E2E delay request-response mechanism (this means you'll
need to deploy peer delay to all devices within your network, but the
gains might be worth it). Because peer delay is symmetrical (both link
partners are both requestors as well as responders), there's no help in
the world that this switch could volunteer to give you in dropping
packets on your behalf. So I expect that if you hardcode:
- the port state for the host port OC as slave, then you'd get the Sync
  messages from all ports, and the Delay_Req messages would be dropped
  but you wouldn't care about those anyway, and
- the selection of TC mode to P2P TC.

Then I would negotiate with Richard whether it's ok to add these extra
values to enum hwtstamp_rx_filters:
	HWTSTAMP_FILTER_PTP_V2_PDELAY
	HWTSTAMP_FILTER_PTP_V2_L4_PDELAY

Given the fact that you're only limiting the timestamping to Pdelay
because we don't fully understand the hardware, I don't really know
whether introducing UAPI for this one situation is justifiable. If not,
then your driver will not have a chance to reject ptp4l -E, and it will
Simply Not Work.
