Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E1D44C2A8
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 15:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhKJODh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 09:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbhKJODh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 09:03:37 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8608EC061764;
        Wed, 10 Nov 2021 06:00:49 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id f4so10833904edx.12;
        Wed, 10 Nov 2021 06:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fA8D8LQx/YlXJQkaVJ74h14pOC3ijTEjTXiuJ9pKPnM=;
        b=HD9VcgWKF8LgMg5q5Bq3yYcwOVFUKV370Y+JxFK5pWvhIsudDy9N+3Plv6YfUcAuMh
         hMqR9+NThlduVa6K5G8gFr+YmiBly/RxJa/q3PSjXkWXBxpjIfG+8FM+OA666YmwFdjy
         mhtPtBqbGfViVsv6ExBIf3TiPG72ApVJL6hAv6iQf5wJvgGXmLsE/L5qafS6QUeSFDtb
         WpUpO/b73SltIxv2KoQfsBKy4vV5lkAzPczxhK97OXIUBivylaHUcQmcIXmkS3Dz2JSv
         mL/fztJ06PIRAMsJ9VeLUs1qZPWfNCNLiFHcnQrYPJTiiCOt7i9EbiyfY5bp9tsJgx38
         aloQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fA8D8LQx/YlXJQkaVJ74h14pOC3ijTEjTXiuJ9pKPnM=;
        b=UaijSr15PB7n3BE7XjMKF7f0tsi/o2ZF6Ijhcj2LG0Ek9NHM6uGEUrYRxBk6fyVGLc
         Ysj7nN3+bwDKdWSmHjO5ZGS79rIf6JlNnGGf1CSnqoLKktVXNgNVOO9qv9R1NMX0iEUS
         /gZhclYLehVYubu7SSsbqhKVdk8huIslE+JccmAg0KtA7jO0t0QhfY43MhswHzc5ReuP
         Rz0bsrjLmWzsa0HkxYVTh3kWNPg0niYsJjQrQSBySNsBRwO8JlVImRPWF2K7FGSiex4E
         pH+JOkPowDpNHlaApqKxMj0Jd2S9eiFFJ557aXUaf+IkfemIXPjpzCfdBtcMVB78OnRs
         Ke5w==
X-Gm-Message-State: AOAM5333F4iOrqJgr7LIU5BgYJRIVnZ/cWUJVA8rScE3ES8Y+FIY/9yB
        BNNTTphDiwZqE7FtEl4krFw=
X-Google-Smtp-Source: ABdhPJz0AxGxyM39WNtkOjgFEJf9//jgLKeboZV4AMdH1nNuR6GOhmSxxLxjLrJlDefjVy2qK2Jz7Q==
X-Received: by 2002:a05:6402:34d0:: with SMTP id w16mr21260996edc.360.1636552846305;
        Wed, 10 Nov 2021 06:00:46 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id mc3sm8246022ejb.24.2021.11.10.06.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 06:00:45 -0800 (PST)
Date:   Wed, 10 Nov 2021 16:00:44 +0200
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
Message-ID: <20211110140044.6qgnwqn4lpabymle@skbuf>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-7-martin.kaistra@linutronix.de>
 <20211109111213.6vo5swdhxjvgmyjt@skbuf>
 <87ee7o8otj.fsf@kurt>
 <20211110130545.ga7ajracz2vvzotg@skbuf>
 <8735o486mw.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735o486mw.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 02:47:19PM +0100, Kurt Kanzenbach wrote:
> On Wed Nov 10 2021, Vladimir Oltean wrote:
> > Hi Kurt,
> >
> > On Wed, Nov 10, 2021 at 08:14:32AM +0100, Kurt Kanzenbach wrote:
> >> Hi Vladimir,
> >> 
> >> On Tue Nov 09 2021, Vladimir Oltean wrote:
> >> >> +void b53_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
> >> >> +{
> >> >> +	struct b53_device *dev = ds->priv;
> >> >> +	struct b53_port_hwtstamp *ps = &dev->ports[port].port_hwtstamp;
> >> >> +	struct sk_buff *clone;
> >> >> +	unsigned int type;
> >> >> +
> >> >> +	type = ptp_classify_raw(skb);
> >> >> +
> >> >> +	if (type != PTP_CLASS_V2_L2)
> >> >> +		return;
> >> >> +
> >> >> +	if (!test_bit(B53_HWTSTAMP_ENABLED, &ps->state))
> >> >> +		return;
> >> >> +
> >> >> +	clone = skb_clone_sk(skb);
> >> >> +	if (!clone)
> >> >> +		return;
> >> >> +
> >> >> +	if (test_and_set_bit_lock(B53_HWTSTAMP_TX_IN_PROGRESS, &ps->state)) {
> >> >
> >> > Is it ok if you simply don't timestamp a second skb which may be sent
> >> > while the first one is in flight, I wonder? What PTP profiles have you
> >> > tested with? At just one PTP packet at a time, the switch isn't giving
> >> > you a lot.
> >> 
> >> PTP only generates a couple of messages per second which need to be
> >> timestamped. Therefore, this behavior shouldn't be a problem.
> >> 
> >> hellcreek (and mv88e6xxx) do the same thing, simply because the device
> >> can only hold only one Tx timestamp. If we'd allow more than one PTP
> >> packet in flight, there will be correlation problems. I've tested with
> >> default and gPTP profile without any problems. What PTP profiles do have
> >> in mind?
> >
> > First of all, let's separate "more than one packet in flight" at the
> > hardware/driver level vs user space level. Even if there is any hardware
> > requirement to not request TX timestamping for the 2nd frame until the
> > 1st has been acked, that shouldn't necessarily have an implication upon
> > what user space sees. After all, we don't tell user space anything about
> > the realities of the hardware it's running on.
> 
> Fair enough.
> 
> >
> > So it is true that ptp4l is single threaded and always polls
> > synchronously for the reception of a TX timestamp on the error queue
> > before proceeding to do anything else. But writing a kernel driver to
> > the specification of a single user space program is questionable.
> > Especially with the SOF_TIMESTAMPING_OPT_ID flag of the SO_TIMESTAMPING
> > socket option, it is quite possible to write a different PTP stack that
> > handles TX timestamps differently. It sends event messages on their
> > respective timer expiry (sync, peer delay request, whatever), and
> > processes TX timestamps as they come, asynchronously instead of blocking.
> > That other PTP stack would not work reliably with this driver (or with
> > mv88e6xxx, or with hellcreek).
> 
> Yeah, a PTP stack which e.g. runs delay measurements independently from
> the other tasks (sync, announce, ...) may run into trouble with such as
> an implementation. I'm wondering how would you solve that problem for
> hardware such as hellcreek? If a packet for timestamping is "in-flight"
> the Tx path for a concurrent frame would have to be delayed. That might
> be a surprise to the user as well.

Yes, of course it would have to be delayed. But it would at least see
the timestamp, on the other hand...

Christian Eggers, while working on the mythical ksz9477 PTP support, had
the same kind of hardware to work with, and he unconditionally deferred
PTP packets, then in a kthread owned by the driver (not the tagger), he
initialized a completion structure, sent the packet, slept until the
completion was done (signaled by an irq thread in his case, can be
signaled by the tagger in Martin's case), and proceeded with the next
packet. See ksz9477_defer_xmit() here:
https://patchwork.ozlabs.org/project/netdev/patch/20201203102117.8995-9-ceggers@arri.de/

It might look like I'm trying really hard to sell deferred xmit here,
and that's not the case - I really hate it myself. But when putting two
and two together, it really seems to be what is needed.
