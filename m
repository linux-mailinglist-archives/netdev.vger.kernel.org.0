Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950CE498392
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 16:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiAXPbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 10:31:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiAXPbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 10:31:51 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12516C06173B
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 07:31:51 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id s5so22373737ejx.2
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 07:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lqb6Nt5Gp3HD1ZBtAUDee9MOCnwx9t419AKqxeWSPto=;
        b=V0IXk6TMhJKXE2eQw/UFt1TyUOW4MdZyfi0FBBEAzuKrHh5TaUJ/E5JoMFI0M+Q+zb
         WybMy0NLqzuAXb1HTmpwNBfMcTZIWMuISlyIai8YsW8FqFwgNf3+fVoD1OD9ru/NvSg3
         9RKz7iIIRPpEpLP+p+wnVmEnLxD7WM+epvq7DFddk6oWQYp77Hq7/YTeZQbyJv92WbDE
         /saDLnXwfB+Be6MylIH6O/HzWoELgl6UVjVvkMYX1B0HYRWDgcPYdUmKvoRbtMcDdP5w
         qK2SaXk9g3ZqWFrxPyHl1SNqmIXpVVUkuCW+ZmokBkl+rj1l4o0OBU6jJ2MMA63YHSo0
         J4nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lqb6Nt5Gp3HD1ZBtAUDee9MOCnwx9t419AKqxeWSPto=;
        b=viIJDaWh/1G5eGfBHpSBmxMVGqVgX0EPqdIm3qNa+PKz7JcjdnpdpwyM3xtd7ropCg
         Ed+lRipjhq1o5k+p8ddMWQO1cyCp3Qrzt+UTczWPodJenSJyB8H61lOwN/69LH9yOh6m
         57oUGI/DDlyLUniMpB8opL4hefHIv3z6OnCcNNLwlMmxQnRQMiUtnMiAlwfnFi6i6jLh
         VzjvVnemxAhz1xvQT0hC8Y3jJQg6YQmAc/Un2I7Zj4v4Kf8RKEY32dvoaY9aLOaqc7rO
         j1h7551iH6GyijuwpH+3JWvfUgfs8fEZ+aUl/6U1cZ6JZ71jQHsXEooAU6jP2gUx/LDc
         vVoQ==
X-Gm-Message-State: AOAM532NRjJgI2SOozOFR3pyAISSNlvb4RlB8BbXHP+YZKmIDHyzA6CA
        4Q/tLl2ofnVONJBunHVrd3s=
X-Google-Smtp-Source: ABdhPJytC1+1xwSTyBTbWcKnxfKAki1jWmCssYZ8c0XSU7XIUyUTltjT4TbSMbOulq1kMBVOGMrS6Q==
X-Received: by 2002:a17:907:a412:: with SMTP id sg18mr13106453ejc.383.1643038309382;
        Mon, 24 Jan 2022 07:31:49 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id d2sm5034977ejw.70.2022.01.24.07.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 07:31:48 -0800 (PST)
Date:   Mon, 24 Jan 2022 17:31:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Message-ID: <20220124153147.agpxxune53crfawy@skbuf>
References: <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
 <Yea+uTH+dh9/NMHn@lunn.ch>
 <20220120151222.dirhmsfyoumykalk@skbuf>
 <CAJq09z6UE72zSVZfUi6rk_nBKGOBC0zjeyowHgsHDHh7WyH0jA@mail.gmail.com>
 <20220121020627.spli3diixw7uxurr@skbuf>
 <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
 <20220121185009.pfkh5kbejhj5o5cs@skbuf>
 <CAJq09z7v90AU=kxraf5CTT0D4S6ggEkVXTQNsk5uWPH-pGr7NA@mail.gmail.com>
 <20220121224949.xb3ra3qohlvoldol@skbuf>
 <CAJq09z6aYKhjdXm_hpaKm1ZOXNopP5oD5MvwEmgRwwfZiR+7vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z6aYKhjdXm_hpaKm1ZOXNopP5oD5MvwEmgRwwfZiR+7vg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 22, 2022 at 05:12:28PM -0300, Luiz Angelo Daros de Luca wrote:
> I'm new to DSA but I think that a solution like that might not scale
> well. For every possible master network driver, it needs to know if
> its offload feature will handle every different tag.

Correct, with the sensible default being that no checksum offloading in
the presence of DSA tags is supported.

> Imagining that both new offload HW and new switch tags will still
> appear in the kernel, it might be untreatable.

You don't see DSA masters understanding DSA tagging protocols every day,
I think you're overstating this. We'd have to cover Marvell-on-Marvell,
Broadcom-on-Broadcom, Mediatek-on-Mediatek, and the rest will have to
add their support when they add the hardware.

> I know dsa properties are not the solution for everything (and I'm
> still adapting to where that border is) but, in this case, it is a
> device specific arrangement between the ethernet device and the
> switch. Wouldn't it be better to allow the
> one writing the device-tree description inform if a master feature
> cannot be copied to slave devices?

Assuming an ultra-generic Ethernet controller with advanced soft parser
capabilities, you'd have to teach it the format of each DSA tagging
protocol you intend it to understand anyway, so this doesn't appear the
kind of thing best described in the device tree, since it may easily be
out of sync with what the driver is able to tell the hardware to do.

> 
> I checked DSA doc again and it says:
> 
> "Since tagging protocols in category 1 and 2 break software (and most
> often also hardware) packet dissection on the DSA master, features
> such as RPS (Receive Packet Steering) on the DSA master would be
> broken. The DSA framework deals with this by hooking into the flow
> dissector and shifting the offset at which the IP header is to be
> found in the tagged frame as seen by the DSA master. This behavior is
> automatic based on the overhead value of the tagging protocol. If not
> all packets are of equal size, the tagger can implement the
> flow_dissect method of the struct dsa_device_ops and override this
> default behavior by specifying the correct offset incurred by each
> individual RX packet. Tail taggers do not cause issues to the flow
> dissector."
> 
> It makes me think that it is the master network driver that does not
> implement that IP header location shift. Anyway, I believe it also
> depends on HW capabilities to inform that shift, right?
> 
> I'm trying to think as a DSA newbie (which is exactly what I am).
> Differently from an isolated ethernet driver, with DSA, the system
> does have control of "something" after the offload should be applied:
> the dsa switch. Can't we have a generic way to send a packet to the
> switch and make it bounce back to the CPU (passing through the offload
> engine)? Would it work if I set the destination port as the CPU port?
> This way, we could simply detect if the offload worked and disable
> those features that did not work. It could work with a generic
> implementation or, if needed, a specialized optional ds_switch_ops
> function just to setup that temporary lookback forwarding rule.

To be clear, do you consider this simpler than an ndo operation that
returns true or false if a certain DSA master can offload a certain
netdev feature in the presence of a certain DSA tag?

Ignoring the fact that there are subtly different ways in which various
hardware manufacturers implement packet injection from the CPU (and this
is reflected in the various struct dsa_device_ops :: xmit operation),
plus the fact that dsa_device_ops :: xmit takes a slave net_device as
argument, for which there is none to represent the CPU port. These
points mean that you'd need to implement a separate, hardware-specific
loopback xmit for each tagging protocol. But again, ignoring that for a
second.

When would be a good time to probe for DSA master features? The DSA
master might be down when DSA switches probe. What should we do with
packets sent on a DSA port until we've finished probing for DSA master
capabilities?

> > So the sad news for you is that this is pretty much "net-next" material,
> > even if it fixes what is essentially a design shortcoming. If we're
> > quick, we could start doing this right as net-next reopens, and that
> > would give other developers maximum opportunity to fix up the
> > performance regressions caused by lack of TX checksumming.
> 
> No problem. I'm already playing the long game. I'm just trying to fix
> a device I own using my free time and I don't have any manager with
> impossible deadlines.
> However, any solution with a performance regression would break the
> kernel API. I would rather add a new device-tree option :-)

Feel free to do whatever you want in OpenWRT, but as a general rule of
thumb, if something can be solved without involving the device tree,
then involving the device tree is probably the wrong approach.
