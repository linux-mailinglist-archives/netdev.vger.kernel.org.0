Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC68A44C21B
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 14:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhKJNdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 08:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhKJNdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 08:33:41 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347B3C061764;
        Wed, 10 Nov 2021 05:30:54 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id ee33so10547927edb.8;
        Wed, 10 Nov 2021 05:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PdcubBZGgzy6nCoanrqJmpFMiZMmdU7pQANUJ/vf8eY=;
        b=D1RKrIP8CxU3TOmiu3Pl8kzv3oznBHOjPzBh6CJfrs59HK1ges5QS/xmYXP8JFeFWA
         u6hHFxRioeYQl5J5Bo/klURzfjPSecO/kekFvMMI3Y/fK9gydsYqsuUybG+DZNuEiGRm
         P8Lgf1JYlG3ZyyUwEeOol12sX3EJTCXz8cAfUujHpe2HmLXCWqeMc9Ng/nv5ORfFgwh+
         4A9+vMp9PzFqYvXaJiP7nf8lUUZzRzcwankpDxapKbSR2dk06RunYg9dklrry5ETwexV
         KVmuLKxMFUmNaip3r9b5h/x1/vfySS/q2uPfAh85PSTu/MEs8aQZhDbVKf7EeWjy7XJ3
         FZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PdcubBZGgzy6nCoanrqJmpFMiZMmdU7pQANUJ/vf8eY=;
        b=8P9id9/hsTcyfYQsiQ2MZLhZ/vQS5ZeBIWrNnu6iNTOE0KY8gZD6XS4ku567pR/YX0
         p64m9mhIazYyEKk+bRbK7EjP9bxbyGIllN01YqHbaFGuTYu8CSxU3ZHFCAmblD+NUHXK
         63ylmfvMZ6Ccgvb7tsBfhknvxGg2iv79pbgQ4ZH1w4xeGvmcaaeet5XO2Eg8BCJFJkAf
         bn+qg+KbwpZEmFgaEBKmQmNqk5IMliqR1FKo3fynuSHgTpf/Yi6eYuU/G5b+yjmgqyPe
         5H549Nb1dAL6koTzxikZcUK1DLU8UVhXwJP6njY9JhpH5Em3E5E6v4Zs8E2r2pXfIa4w
         sPog==
X-Gm-Message-State: AOAM533uTfIgucRdxcQYcSmTgv2RtuXlY5IBqwx64zN+sUhD9cU7Fw+g
        7BPVRDSu56Lw5P4ccdU1xSg=
X-Google-Smtp-Source: ABdhPJwBS8X7ydnbTxbWZvcRu4+oL7W0gBpGmbGJr7GwZAoZXhjwe+BJk0DXl08PvgkistfaUFRO1g==
X-Received: by 2002:a05:6402:182:: with SMTP id r2mr4932991edv.313.1636551052034;
        Wed, 10 Nov 2021 05:30:52 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id t6sm12885365edj.27.2021.11.10.05.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 05:30:50 -0800 (PST)
Date:   Wed, 10 Nov 2021 15:30:48 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 6/7] net: dsa: b53: Add logic for TX timestamping
Message-ID: <20211110133048.3ml6wpjncd6ivqbz@skbuf>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-7-martin.kaistra@linutronix.de>
 <20211109111213.6vo5swdhxjvgmyjt@skbuf>
 <87ee7o8otj.fsf@kurt>
 <20211110130545.ga7ajracz2vvzotg@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110130545.ga7ajracz2vvzotg@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 03:05:45PM +0200, Vladimir Oltean wrote:
> Hi Kurt,
> 
> On Wed, Nov 10, 2021 at 08:14:32AM +0100, Kurt Kanzenbach wrote:
> > Hi Vladimir,
> > 
> > On Tue Nov 09 2021, Vladimir Oltean wrote:
> > >> +void b53_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
> > >> +{
> > >> +	struct b53_device *dev = ds->priv;
> > >> +	struct b53_port_hwtstamp *ps = &dev->ports[port].port_hwtstamp;
> > >> +	struct sk_buff *clone;
> > >> +	unsigned int type;
> > >> +
> > >> +	type = ptp_classify_raw(skb);
> > >> +
> > >> +	if (type != PTP_CLASS_V2_L2)
> > >> +		return;
> > >> +
> > >> +	if (!test_bit(B53_HWTSTAMP_ENABLED, &ps->state))
> > >> +		return;
> > >> +
> > >> +	clone = skb_clone_sk(skb);
> > >> +	if (!clone)
> > >> +		return;
> > >> +
> > >> +	if (test_and_set_bit_lock(B53_HWTSTAMP_TX_IN_PROGRESS, &ps->state)) {
> > >
> > > Is it ok if you simply don't timestamp a second skb which may be sent
> > > while the first one is in flight, I wonder? What PTP profiles have you
> > > tested with? At just one PTP packet at a time, the switch isn't giving
> > > you a lot.
> > 
> > PTP only generates a couple of messages per second which need to be
> > timestamped. Therefore, this behavior shouldn't be a problem.
> > 
> > hellcreek (and mv88e6xxx) do the same thing, simply because the device
> > can only hold only one Tx timestamp. If we'd allow more than one PTP
> > packet in flight, there will be correlation problems. I've tested with
> > default and gPTP profile without any problems. What PTP profiles do have
> > in mind?
> 
> First of all, let's separate "more than one packet in flight" at the
> hardware/driver level vs user space level. Even if there is any hardware
> requirement to not request TX timestamping for the 2nd frame until the
> 1st has been acked, that shouldn't necessarily have an implication upon
> what user space sees. After all, we don't tell user space anything about
> the realities of the hardware it's running on.
> 
> So it is true that ptp4l is single threaded and always polls
> synchronously for the reception of a TX timestamp on the error queue
> before proceeding to do anything else. But writing a kernel driver to
> the specification of a single user space program is questionable.
> Especially with the SOF_TIMESTAMPING_OPT_ID flag of the SO_TIMESTAMPING
> socket option, it is quite possible to write a different PTP stack that
> handles TX timestamps differently. It sends event messages on their
> respective timer expiry (sync, peer delay request, whatever), and
> processes TX timestamps as they come, asynchronously instead of blocking.
> That other PTP stack would not work reliably with this driver (or with
> mv88e6xxx, or with hellcreek).

Another example that may be closer to you is using vclocks and multiple
ptp4l instances in multiple domains, over the same ports. Since ptp4l
doesn't claim exclusive ownership of an interface, there you don't even
need to have a different stack to see issues with the timestamps of one
ptp4l instance getting dropped just because a different one happened to
send an event message at the same time.

> > > Is it a hardware limitation?
> > 
> > Not for the b53. It will generate status frames for each to be
> > timestamped packet. However, I don't see the need to allow more than one
> > Tx packet per port to be timestamped at the moment.
> > 
> > Thanks,
> > Kurt
> 
> 
