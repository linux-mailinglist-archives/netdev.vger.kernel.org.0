Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA022BBB81
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 02:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbgKUB0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 20:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgKUB0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 20:26:17 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F1AC0613CF;
        Fri, 20 Nov 2020 17:26:15 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id bo9so9659019ejb.13;
        Fri, 20 Nov 2020 17:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EABbKjZEY14y+isUKqIGvWYP0FHXdvAjUi1vl8mqG8I=;
        b=oNo/UV2Nyhili9xdPtSgxVwqM3i4HJYYvFnfrv1fDso3YH/b7effxNQSUxmYdrFW43
         yTPWavrjOuv4CD6L/0Vyhg3mIcuC852SHhZbosEqzGg8oMX0JI8osbc2vSbWboxhrA0u
         n4HMfjbIZ7P72GnErXDpS4h37FsxM4WppnPYWV/8LOpIX4ukG4cjL/C0E//i5A//gwRv
         ghFSizc45aRgDNba9r89W+N/LPAn1WrWIt3PbNPPyUkEyw1Byzy3Dx2brgZ9YQXEtSUz
         K6Oz130Q6xFWv/O5uDG8s1tImwHm7u7WMz7KCp+aWN7yBI+6GdLlslBQiIrF/WGylz6Z
         fq7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EABbKjZEY14y+isUKqIGvWYP0FHXdvAjUi1vl8mqG8I=;
        b=BTxCWIo7pcRLkp6iYjQjyA12BveaEtv+yNmdsWcNaBtedtl1TLGXka13uGyIWuh0t9
         vTdAVrONvNWyJRx4wHjIQTsoW/Lqw/XTjo8SXf11qmy228TIfTQvqTlYk2exNGsan+of
         CD7/EoDW7XYfsBurFzFLLux3ZfMIPlefl5NCALQK02FddNPbRqNeKnJahoTdPY82RS1v
         8G2r6zaasLSxmJVILP+mboCUI4gKBFnERYumIHY0FM9y1fGbT8Q+qbD0xPAP8s6qaSK3
         bGU+gljrvs6JZROkOEUihZfw2dxhk30vxkzC21/bRpzWpKX4eMLAghTZxHRf3xGBx5r1
         xovw==
X-Gm-Message-State: AOAM533jgN6G+WdkLtMs1hCvn2TIaaoPWIHe7RcQpn8bsI7sqA+Ht7ST
        cg01fW7jPv0qN1UwjIqDgPc=
X-Google-Smtp-Source: ABdhPJxskYu6oKv316/cMM881GPXN887ydYMVX2r0OdBpcIL+EPuzvrH0CR0Yi16TK/Z+ljAht21+g==
X-Received: by 2002:a17:906:8c6:: with SMTP id o6mr33216875eje.230.1605921973916;
        Fri, 20 Nov 2020 17:26:13 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id f19sm1724057ejk.116.2020.11.20.17.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 17:26:13 -0800 (PST)
Date:   Sat, 21 Nov 2020 03:26:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tristram.Ha@microchip.com
Cc:     ceggers@arri.de, kuba@kernel.org, andrew@lunn.ch,
        richardcochran@gmail.com, robh+dt@kernel.org,
        vivien.didelot@gmail.com, davem@davemloft.net,
        kurt.kanzenbach@linutronix.de, george.mccollister@gmail.com,
        marex@denx.de, helmut.grohne@intenta.de, pbarker@konsulko.com,
        Codrin.Ciubotariu@microchip.com, Woojung.Huh@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 00/12] net: dsa: microchip: PTP support for
 KSZ956x
Message-ID: <20201121012611.r6h5zpd32pypczg3@skbuf>
References: <20201118203013.5077-1-ceggers@arri.de>
 <20201118234018.jltisnhjesddt6kf@skbuf>
 <2452899.Bt8PnbAPR0@n95hx1g2>
 <BYAPR11MB35582F880B533EB2EE0CDD1DECE00@BYAPR11MB3558.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR11MB35582F880B533EB2EE0CDD1DECE00@BYAPR11MB3558.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 06:51:15PM +0000, Tristram.Ha@microchip.com wrote:
> The initial proposal in tag_ksz.c is for the switch driver to provide callback functions
> to handle receiving and transmitting.  Then each switch driver can be added to
> process the tail tag in its own driver and leave tag_ksz.c unchanged.
>
> It was rejected because of wanting to keep tag_ksz.c code and switch driver code
> separate and concern about performance.
>
> Now tag_ksz.c is filled with PTP code that is not relevant for other switches and will
> need to be changed again when another switch driver with PTP function is added.
>
> Can we implement that callback mechanism?

I, too, lack the context here. But it sounds like feedback that Andrew
would give.

If you don't like the #ifdef's, I am not in love with them either. But
maybe Christian is just optimizing too aggressively, and doesn't actually
need to put those #ifdef's there and provide stub implementations, but
could actually just leave the ksz9477_rcv_timestamp and ksz9477_xmit_timestamp
always compiled-in, and "dead at runtime" in the case there is no PTP.

If there is something else you don't like, what is it? If you know that
other KSZ switches don't implement timestamping in the same way, well,
we don't know that. I thought that it's generally up to the second
implementer to recognize which parts of the code are common and should
be reused, not for the first one to guess. I would not add function
pointers for a single implementation if they don't have a clear
justification.

> One issue with transmission with PTP enabled is that the tail tag needs to contain 4
> additional bytes.  When the PTP function is off the bytes are not added.  This should
> be monitored all the time.
>
> The extra 4 bytes are only used for 1-step Pdelay_Resp.  It should contain the receive
> timestamp of previous Pdelay_Req with latency adjusted.  The correction field in
> Pdelay_Resp should be zero.  It may be a hardware bug to have wrong UDP checksum
> when the message is sent.

It "may" be a hardware bug? Are you unsure or polite?
As for the phrase "the correction field in Pdelay_Resp should be zero".
Consider the case where there is an E2E TC switch attached to that port.
It will update the correctionField of the Pdelay_Req message. Then the
application stack running on this ksz9477 switch is forced by the
standard to copy the correctionField as-is from the Pdelay_Req into the
Pdelay_Resp message. So that correctionField is never guaranteed to be
zero, even if Christian doesn't fiddle with it within the driver. Are
you saying that for proper UDP checksum calculation, the driver should
be forcing the correctionField to zero and moving that value into the
tail tag?

> I think the right implementation is for the driver to remember this receive timestamp
> of Pdelay_Req and puts it in the tail tag when it sees a 1-step Pdelay_Resp is sent.

I have mixed feelings about this. IIUC, you're saying "let's implement a
fixed-size FIFO of RX timestamps of Pdelay_Req messages, and let's match
them on TX to Pdelay_Resp messages, by {sequenceId, domainNumber}."

But how deep should we make that FIFO? I.e. how many Pdelay_Req messages
should we expect before the user space will inject back a Pdelay_Resp
for transmission?

Again, consider the case of an E2E TC attached to a ksz9477 port. Even
if we run peer delay, it's not guaranteed that we only have one peer.
That E2E TC might connect us to a plethora of other peers. And the more
peers we are connected to, the higher the chance that the size of this
Pdelay_Req RX timestamp FIFO will not be adequately chosen.

> There is one more requirement that is a little difficult to do.  The calculated peer delay
> needs to be programmed in hardware register, but the regular PTP stack has no way to
> send that command.  I think the driver has to do its own calculation by snooping on the
> Pdelay_Req/Pdelay_Resp/Pdelay_Resp_Follow_Up messages.

What register, and what does the switch do with this peer delay information?

> The receive and transmit latencies are different for different connected speed.  So the
> driver needs to change them when the link changes.  For that reason the PTP stack
> should not use its own latency values as generally the application does not care about
> the linked speed.

The thing is, ptp4l already has ingressLatency and egressLatency
settings, and I would not be surprised if those config options would get
extended to cover values at multiple link speeds.

In the general case, the ksz9477 MAC could be attached to any external
PHY, having its own propagation delay characteristics, or any number of
other things that cause clock domain crossings. I'm not sure how feasible
it is for the kernel to abstract this away completely, and adjust
timestamps automatically based on any and all combinations of MAC and
PHY. Maybe this is just wishful thinking.

Oh, and by the way, Christian, I'm not even sure if you aren't in fact
just beating around the bush with these tstamp_rx_latency_ns and
tstamp_tx_latency_ns values? I mean, the switch adds the latency value
to the timestamps. And you, from the driver, read the value of the
register, so you can subtract the value from the timestamp, to
compensate for its correction. So, all in all, there is no net latency
compensation seen by the outside world?! If that is the case, can't you
just set the latency registers to zero, do your compensation from the
application stack and call it a day?
