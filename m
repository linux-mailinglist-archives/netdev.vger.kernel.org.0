Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E430A293238
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389215AbgJTAKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgJTAKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 20:10:46 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9137BC0613CE;
        Mon, 19 Oct 2020 17:10:44 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id i5so1115522edr.5;
        Mon, 19 Oct 2020 17:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UaGR/k85ndlivJXlwq6kQBoqmuWnMtK/i/ntraNCDd4=;
        b=GbaSrHMu1eDdv3ko21utX8CHvaFIEpnbqR99SQv2SBWMsNlQ0VQN9VsyoIPIRviS35
         mrb1q1lJuDAcWLnjKlbkICfKhy5IaFfa9XPDPCLL3xmSUKf5EzDBcYW+zaHK4kGM8tIO
         aNWtTJ0Z8+vWofckG/pWbKVBy6GQtpX+srXcW841YDSTiEadEo9BAF/34jlUWYhJdUgm
         3qmBpzzaGDT9kqEuZZS2O71YgE5Tgfv2hzeDnkeWrvvKVe4O/RzjNVxBa93JxHkiQLBZ
         rbu8Utkqq6TvqwR6rJU4u66B3gSsYURbKKvF/y2bMeXyTbErOl1L2QdK6MP84JQum/LO
         VsYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UaGR/k85ndlivJXlwq6kQBoqmuWnMtK/i/ntraNCDd4=;
        b=B0MJ0xDLBYY2vyty1Yf7qWNvKeqVjfBjk4QrLe8mndTqVd8xX4kIFyfaTT5UtvWl/N
         GB8r5ji/UsYdyHgDsRbJaZoyQwcAr4H2r8WNkTLY7TZ/wmHSuDZVscazfQOTL6CjEwlK
         GzsFoaYAUwGZMfU+36AjcPj/89gkyj4dfDyW3ZiwOApOeXtSs96g6pwuInxx+RcMNRO0
         oJ82CzzVWsoZdTSPGDZ7wLKg5E6eUSCLYb1mYOTdKNBDyGAoUBF0RO2nsHd4f1kN7uJ0
         Gom21V4iSQfw2oCPzgW2WXtuJ2sEfRPwnLXH9pvBaxLlQ/5PgBv+73uZ4Lsyx9ve3o5o
         ScSQ==
X-Gm-Message-State: AOAM531+d/0F/vou5S0qBmGU3fNYj70u9RedIdoBplRAXhf28bQl5p2A
        Q+g2msbYBAzIW5FpxAvt88k=
X-Google-Smtp-Source: ABdhPJyzNkfsLUGzZGiVNP/za5ispsG8OmDioLR59WhI7EdkUTtwXfHu+EEhTbLoGDxkEzbu9O3k0w==
X-Received: by 2002:a50:d64c:: with SMTP id c12mr78514edj.44.1603152643206;
        Mon, 19 Oct 2020 17:10:43 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id u18sm151126ejn.122.2020.10.19.17.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 17:10:42 -0700 (PDT)
Date:   Tue, 20 Oct 2020 03:10:40 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
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
Message-ID: <20201020001040.avkzgltrijaz4ujb@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de>
 <20201019172435.4416-8-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019172435.4416-8-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 07:24:33PM +0200, Christian Eggers wrote:
> Add routines required for TX hardware time stamping.
> 
> The KSZ9563 only supports one step time stamping
> (HWTSTAMP_TX_ONESTEP_P2P), which requires linuxptp-2.0 or later. PTP
> mode is permanently enabled (changes tail tag; depends on
> CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP).TX time stamps are reported via an
> interrupt / device registers whilst RX time stamps are reported via an
> additional tail tag.
> 
> One step TX time stamping of PDelay_Resp requires the RX time stamp from
> the associated PDelay_Req message. linuxptp assumes that the RX time
> stamp has already been subtracted from the PDelay_Req correction field
> (as done by the TI PHYTER). linuxptp will echo back the value of the
> correction field in the PDelay_Resp message.
> 
> In order to be compatible to this already established interface, the
> KSZ9563 code emulates this behavior. When processing the PDelay_Resp
> message, the time stamp is moved back from the correction field to the
> tail tag, as the hardware doesn't support negative values on this field.
> Of course, the UDP checksums (if any) have to be corrected after this
> (for both directions).
> 
> The PTP hardware performs internal detection of PTP frames (likely
> similar as ptp_classify_raw() and ptp_parse_header()). As these filters
> cannot be disabled, the current delay mode (E2E/P2P) and the clock mode
> (master/slave) must be configured via sysfs attributes. Time stamping
> will only be performed on PTP packets matching the current mode
> settings.
> 
> Everything has been tested on a Microchip KSZ9563 switch.

I looked a little bit at the KSZ9563 datasheet and I'm more confused
than I was before opening it.

-----------------------------[cut here]-----------------------------
The device supports V2 (2008) of the IEEE 1588 PTP specification and can
be programmed as either an end-to-end (E2E) or peer-to-peer (P2P)
transparent clock (TC) between ports. In addition, the host port can be
programmed as either a slave or master ordinary clock (OC) port.
Ingress timestamp capture, egress timestamp recording, correction field
update with residence time and link delay, delay turn-around time
insertion, egress timestamp insertion, and checksum update are
supported.
-----------------------------[cut here]-----------------------------

So it's a 1-step transparent clock, fair enough. That works autonomously
without any sort of involvement from the operating system, you know
that, right? This is stateless functionality.

BUT, if that is the case, what do you need PTP support in the kernel
for? What profiles are you using with linuxptp? What benefit does it
bring you if you report timestamps to the operating system, for
terminated 1588 traffic? Why would you even terminate 1588 traffic on
the host CPU? I fail to understand many of the use cases that this
switch is tailored for.

Also, I know that Microchip support does a pretty bad job at giving
useful answers, and the datasheet isn't quite clear either (looks like
there's info that has been copied from other switches, like for 2-step
timestamping, then removed, and too much was removed because now nothing
is clear) so you'll have to give your best shot at explaining some
things.


Global PTP Message Config 1 Register
------------------------------------

Bit 2: Selection of P2P or E2E
1 = Peer-to-peer (P2P) transparent clock mode
0 = End-to-end (E2E) transparent clock mode

What does this bit do exactly?
Does it change the switch's behavior as an autonomous 1-step transparent
clock? Or does it have anything to do with how/which timestamps are
delivered to the CPU? The point is, why do you care to configure this?
Sysfs is not going to fly without a solid explanation, which you did not
provide here.

My understanding of E2E vs P2P TC is that an E2E TC will correct the
timestamps of Pdelay messages, while a P2P TC won't. The P2P TC must
speak proper PDelay and not forward those packets sheepishly. Which
starts to answer my question, I believe... So my comment above, that the
1-step TC functionality doesn't require any involvement from the CPU, is
only correct for E2E TC, am I right? For P2P TC, you would need the host
CPU to speak peer delay. But you wouldn't need it for anything else (the
SYNC messages would have no reason to go to the CPU, would they?). So,
again, what profile are you using with linuxptp for this one?

If my understanding is right, maybe you want to just leave the switch
operate in E2E TC mode by default, and put it into P2P TC as soon as
your .port_hwtstamp_set() method is called?


Ok, on to my next question....

Bit 1: Selection of Master or Slave
1 = Host port is PTP master ordinary clock
0 = Host port is PTP slave ordinary clock

What does this _actually_ do? Here I really have no idea. I can only
imagine that this has again to do with the 1-step TC operation, and that
it's treating the host port as a switched endpoint, and this has to do
with the port states of the P2P TC. I'm so confused by this one that I
don't even know what to ask...
Ok, let's put it differently. You bothered to add a sysfs for it, so you
must be using it for something. What are you using it for?
