Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F7A2B2A2E
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgKNAy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgKNAy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 19:54:58 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1105CC0613D1;
        Fri, 13 Nov 2020 16:54:58 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id o9so16399611ejg.1;
        Fri, 13 Nov 2020 16:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zYDEJkVFc0RWkkgZhCNMA5qq/JVYdMxhqD9EnHngA7w=;
        b=YtBALwGbe8cVc5s69SPiRdd5CNohEOuq87jBI7WZq7ungyXsyqMuG4KraGwFAvRU4T
         ABPdKineUW1Sq8PTzQm/l1ItZx2Njdjhm8Z3SM/jfVfcKmgkMs9iA54c/6IR5mzZR5Y5
         kI5F6Bj8Fo0aPp+GeTsdWU/0Abv9ogkvbXpI+dqtbxi56PAsu7c1Gn9uICKOHZbXNjuM
         W2KTQuv2F+KnwjIVkGtvnj906tU1Uc0TDUTeab2Ykj9vwM94rWVERzRorc8w3oLk1o8K
         u5e4eZehd8K2/90L+QtQBgQ8sJZyzraOGE2UA/H47XhvIySp6ocksKORIDEVBJkjftAC
         w1QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zYDEJkVFc0RWkkgZhCNMA5qq/JVYdMxhqD9EnHngA7w=;
        b=B+/RsQ5uBxZ6bl5U5x+TQRsj3TYyajQNAz0Ij6mIyKjL9bYqyr6LLb6n8M8gAfBx3Q
         4gJk61X57/Jn1X/fV9QsrQluV5Uorw6mkb6kJKR/FoN4QJZaODBwxT4e2HnhqjuMJueL
         xTtoGh6d43pXO8Wor5wrlBJZtgrMDehHxKRikEid6KbK9TPDfigEjkehRldpxziHj+9L
         yKeT4NOkzJYLWTcC8MdPM0FwmDJSXYDESd1hO++dBs3ZLOT7LRR2FUYfaXIAzSXOFNZg
         wj+UbbjwGPPhX9qSYIpVqwrbCA1GO9ODfdg17CMgT5bkFkRunV8jMCiomdXqLOUFynR9
         aZmA==
X-Gm-Message-State: AOAM532DBE9IDdBRRgr6t3TsRP6V66BiIw9t8EEcKfoKZ9OKS4dE5KvE
        plXVoKxWl6A/DHMtdDKJ/5E=
X-Google-Smtp-Source: ABdhPJw7+/Ijax+bGZqknn2xBFKkyP6f8pzwfkypevpU247mRy/YSDCxLomXDtvLkc8K4wxPfT5/kA==
X-Received: by 2002:a17:906:7247:: with SMTP id n7mr4759822ejk.174.1605315296651;
        Fri, 13 Nov 2020 16:54:56 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id f16sm5297552edc.44.2020.11.13.16.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 16:54:55 -0800 (PST)
Date:   Sat, 14 Nov 2020 02:54:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 09/11] net: dsa: microchip: ksz9477: add
 hardware time stamping support
Message-ID: <20201114005454.jdmt3ixhwseamcv6@skbuf>
References: <20201112153537.22383-1-ceggers@arri.de>
 <20201112153537.22383-10-ceggers@arri.de>
 <20201113024020.ixzrpjxjfwme3wur@skbuf>
 <4328015.hLoEoa8eMr@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4328015.hLoEoa8eMr@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 07:57:32PM +0100, Christian Eggers wrote:
> On Friday, 13 November 2020, 03:40:20 CET, Vladimir Oltean wrote:
> > On Thu, Nov 12, 2020 at 04:35:35PM +0100, Christian Eggers wrote:
> [...]
> > > @@ -103,6 +108,10 @@ static int ksz9477_ptp_adjtime(struct ptp_clock_info
> > > *ptp, s64 delta)>
> > >     if (ret)
> > >
> > >             goto error_return;
> > >
> > > +   spin_lock_irqsave(&dev->ptp_clock_lock, flags);
> >
> > I believe that spin_lock_irqsave is unnecessary, since there is no code
> > that runs in hardirq context.
> I'll check this again. Originally I had only a mutex for everything, but later
> it turned out that for ptp_clock_time a spinlock is required. Maybe this has
> changed since starting of my work on the driver.

Yes, it's called from the networking softirq.
The typical assumption is that the networking data path can run in
both hardirq and softirq context (or, well, in process context if it
gets picked up by ksoftirqd), so one would think that _irqsave would be
justified. But the hardirq stuff is only used by netpoll, for
netconsole. So you would never hit that condition for PTP timestamping.

> >
> > > +   dev->ptp_clock_time = timespec64_add(dev->ptp_clock_time, delta64);
> > > +   spin_unlock_irqrestore(&dev->ptp_clock_lock, flags);
> > > +
>
> [...]
>
> > Could we make this line shorter?
> ...
> > Additionally, you exceed the 80 characters limit.
> ...
> > Also, you exceeded 80 characters by quite a bit.
> ...
> > In networking we still have the 80-characters rule, please follow it.
> Can this be added to the netdev-FAQ (just below the section about
> "comment style convention")?
>
> > > +static void ksz9477_ptp_ports_deinit(struct ksz_device *dev)
> > > +{
> > > +   int port;
> > > +
> > > +   for (port = dev->port_cnt - 1; port >= 0; --port)
> >
> > Nice, but also probably not worth the effort?
> What do you mean. Shall I used forward direction?

Yes, that's what I meant.

> > > +
> > > +   /* Should already been tested in dsa_skb_tx_timestamp()? */
> > > +   if (!(skb_shinfo(clone)->tx_flags & SKBTX_HW_TSTAMP))
> > > +           return false;
> >
> > Yeah, should have...
> > What do you think about this one though:
> > https://lore.kernel.org/netdev/20201104015834.mcn2eoibxf6j3ksw@skbuf/
> I am not an expert for performance stuff. But for me it looks obvious that
> cheaper checks should be performed first. What about also moving checking
> for ops->port_txtstamp above ptp_classify_raw()?

I am no expert either. Also, it looks like I'm not even keeping on top
of things lately. I'll try to return to that investigation during this
weekend.

>
> Is there any reason why this isn't already applied?

Probably because nobody sent a patch for it?

> > case in which you'll need an skb_queue and a process context
> > to wait for the TX timestamp of the previous PTP message before calling
> > dsa_enqueue_skb for the next PTP event message. There are already
> > implementations of both models in DSA that you can look at.
> In the past I got sometimes a "timeout waiting for hw timestamp" (or similar)
> message from ptp4l. I am not sure whether this is still the case, but this may
> explain this type of problems.

Yeah, well, the default tx_timestamp_timeout value of 1 ms chosen by
ptp4l is not going to be enough in general for DSA. If you schedule a
workqueue for timestamping, that delay will only get worse, but luckily
you can increase the timestamp timeout value and all should be fine.

> > So good for you that you can use a function so simple for timestamp
> > reconstruction.
> You already told me that another hardware has much less budget than 4 seconds.

sja1105 has 24 bits of partial timestamp (and 1 bit measures 8 ns). So
it wraps around in 135 ms. You can imagine that periodically reading the
PTP clock over SPI is not an option there :)

> How is timestamp reconstruction done there? Is there any code which I should
> reuse?

No, I wasn't suggesting you reuse that logic, since it's very
error-prone. If you can get away with reconstruction done on-the-fly,
great. But just for reference:
- In drivers/net/dsa/sja1105/, the actual transmission of the PTP
  packets is done synchronously, from process context, and an interrupt
  is not even used. See sja1105_ptp_txtstamp_skb and
  sja1105_tstamp_reconstruct. Actually, more interesting would be the RX
  timestamping case, since we have a worse problem there: the partial
  PTP timestamp is obtained in softirq context, and we need process
  context for the current PTP time. For that, see sja1105_port_rxtstamp
  and sja1105_rxtstamp_work.
- In drivers/net/dsa/ocelot/, the reconstruction is done in IRQ context,
  since it is a memory-mapped switch and therefore, reading the PTP time
  is "cheap". See ocelot_get_txtstamp and ocelot_get_hwtimestamp.
The point is that both these drivers read the full PTP current time
_after_ the partial timestamp was obtained. That's what gives you a
solid guarantee that the "partial_timestamp > current_ptp_time & lower_bits"
condition means "wraparound occurred" and not something else.

> > > +static void ksz9477_rcv_timestamp(struct sk_buff *skb __maybe_unused, u8
> > > *tag __maybe_unused, +                                struct net_device *dev __maybe_unused,
> > > +                             unsigned int port __maybe_unused)
> >
> > Where did you see __maybe_unused being utilized in this way? And what's
> > so "maybe" about it? They are absolutely unused, and the compiler should
> > not complain. Please remove these variable attributes.
> ok, __always_unused would fit.
>
> I added the attributes due to Documentation/process/4.Coding.rst:
>
> "Code submitted for review should, as a rule, not produce any compiler
> warnings." [...] "Note that not all compiler warnings are enabled by default.  Build the
> kernel with "make EXTRA_CFLAGS=-W" to get the full set."
>
> I assumed that reducing the number of warnings raised by "-W" should be reduced
> as a long term goal. Is this wrong.

Uhm, I don't know of any compiler flag that would cause warnings for
unused arguments of a function. And the kernel uses this stub function
scheme for so many things, that even if that flag existed, the chance of
it getting enabled in the kernel's Makefile would be zero. It would
flood everybody in useless warning messages.

So please don't add __maybe_unused or __always_unused or whatever. Just
do what everybody else does.

> Side note: Documentation/kbuild/makefiles.rst declares usage of EXTRA_CFLAGS as
> deprecated.

Yeah, if you can build-test with "make W=1" and "make W=2" you should be
safe, no need to overthink anything. Beware though, there's going to be
a lot of output coming your way... There's also "make C=1" for sparse,
if you want to be proactive and avoid later patches from the static
analysis crew. But you'll need to use a source-built sparse binary
there, the one packaged by typical distributions won't cut it, and will
give up saying "error: too many
errors".
