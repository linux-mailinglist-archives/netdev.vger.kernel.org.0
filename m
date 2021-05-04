Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DB037329B
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 01:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhEDXFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 19:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbhEDXFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 19:05:10 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAB3C061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 16:04:14 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id l13so9450004wru.11
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 16:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XS9eVQQm0ICA5clq7aGO+GeBxT02cu0PyE0FYwLbSn0=;
        b=KRZJRmSFkpfNmsXGHBLowNForVyQalqpK2f3Smci2Be07uF52HFbmgCnclGxRYM1Fs
         gJhFFkRrIMe1AVE4ZP+T0MonB3c+o8xTChaJ7EEeWw91ONXnKg26OQumIH7JyaCRLX7E
         2qUJ0eJS8PbhV1+osyUsDALyMB4NJYvfSqxrUXEVjvHM0QuMj1tQyTtrh2u+F0SRhb55
         gb/VNqVd6JYM7ElLiCWM0DUkCpUgV8OYti8XNvLOt85hQEv2qChMjO/Tj/sd6CAcRrnW
         KSl6tx6X1W90X1G3UuWQr25hg17UheGN0HkyBaEh7NJnyCgYodsGME13IN7JD3+Dd7wQ
         LPkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XS9eVQQm0ICA5clq7aGO+GeBxT02cu0PyE0FYwLbSn0=;
        b=H9WiOlvb8aDYMqcz6WLgWehfakTZ00pWwwj1FmXPS/d03m4zY44/asybeq7kPKEeKC
         uxKXVXJnZdRAcP32HJ66bDqD/KMSRvU5H8LvEXCmlBeo9RvE+f40cosWPXsWCK6sqoXR
         YTTPNJiFq1aTE3i1E47MpFucltZwaLJbZoJ7wfrsaeJsLH6Rio/Qf/U4VPOouz+mkE+D
         HlsIAHaJBGqWK3q44oW/GMF/u4kHSRB2NSiDfz3pM/viwekIP9YDO0oVWZ822B5NuyBE
         PEsCAwVbmGF54b5N7AUOj5Wg9Nn/QPApomx9075JtbdZR9WDEFYeYPGvbaOrCI/DeYvL
         63mg==
X-Gm-Message-State: AOAM531evcRp4ZsuUdjxHizW3rFjjUFeeIYpCunw6QBzmoE0VpVkupXH
        GToZxVbQNbd6lgaRuW/sIek=
X-Google-Smtp-Source: ABdhPJymHTiQGpFW2f+Ef+2YygYwikderfEGsdLlWVEZ8dBP+4XDKTL427lTLquKih/VXDt/tn2W/Q==
X-Received: by 2002:a5d:5047:: with SMTP id h7mr21337523wrt.287.1620169453211;
        Tue, 04 May 2021 16:04:13 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id p3sm3319064wmq.31.2021.05.04.16.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 16:04:10 -0700 (PDT)
Date:   Wed, 5 May 2021 02:04:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, jiri@resnulli.us, idosch@idosch.org,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 6/9] net: dsa: Forward offloading
Message-ID: <20210504230409.kohxoc4cl7sjpkrg@skbuf>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
 <20210426170411.1789186-7-tobias@waldekranz.com>
 <20210427101747.n3y6w6o7thl5cz3r@skbuf>
 <878s4uo8xc.fsf@waldekranz.com>
 <20210504152106.oppawchuruapg4sb@skbuf>
 <874kfintzh.fsf@waldekranz.com>
 <20210504205823.j5wg547lgyw776rl@skbuf>
 <87y2cum9mo.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2cum9mo.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 12:12:15AM +0200, Tobias Waldekranz wrote:
> > and you create a dependency between the tagger and the switch driver
> > which was supposed by design to not exist.
> 
> Sure, but _why_ should it not exist? Many fields in the tag can only be
> correctly generated/interpreted in combination with knowledge of the
> current configuration, which is the driver's domain. The dependency is
> already there, etched in silicon.

I'm a bit more of a pragmatic person, it's not so much that I think that
Lennert Buytenhek's original DSA design from 2008 was the holy grail and
that we should do everything we can to preserve it intact. Far from it.
But I actually like having the option to inject a DSA-tagged packet
using Spirent TestCenter and measure IP forwarding between dsa_loop
"switch" ports (actually a one-armed router is what it is). I also like,
as a reviewer, to be able to test, if I want to, how a tail tagger
behaves even if I don't own a switch with tail tagging. And this
separation between the switch driver and the tag protocol driver makes
that possible, just see it as a nice perk which we don't want to lose.

As for more advanced features, like "the hardware requires me to invent
a unique number based on a rolling counter, call it a TX timestamp ID,
put it in the DSA header, then when transmission is done, an IRQ will be
raised, and I need to match that TX timestamp that just became available
to me, which is identifiable via the timestamp ID that I put in the DSA
header, with the original skb", of course you can't do that without
communication between the tagger and the driver itself, unless you make
the tagger handle interrupts (and then there's the whole issue that the
tagging protocol driver needs to be instantiated per switch, if it's
going to be stateful), or the switch driver send packets. As a general
rule of thumb, just don't break dsa_loop and we should be fine. For
example, yes, PTP requires driver <-> tagger communication, but PTP
timestamping is also not enabled by default, and guarded by an ioctl
which dsa_loop doesn't implement. So the tagger can never trigger faulty
code, dereferencing a ds->priv pointer which it thinks is "struct
mv88e6xxx_chip" but is actually "struct dsa_loop_priv".
