Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F203736B0
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 11:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhEEJCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 05:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhEEJCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 05:02:09 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A732C061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 02:01:12 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id v6so1481924ljj.5
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 02:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=CHszZK7LblPbIXozkASGXG0KNy6kheJ5G3pXtlHdYnQ=;
        b=k6bHhtUS4olAAtkrAOahBxLSc5WpKrfi4zD12DHNMLUAjYB6RGAXtjuP4hmnDJGhIy
         xUowlwnIr1SvmdcLgavdkJpQs1ajPmjaIqxezkolP5XvjRWlSuMB6qiACRyd8Nz7SqQB
         4Mbqj6cHA272gLGFBZ6FfpvDLTHDdjE5v/zn3ZhVvHJUYR9g/XwJ4q0vjJRTv/F+2fqx
         pmCcjQ4Y5yGc18g9k2DxfXm18Bs7JuyNhnzsGeeD6Qb5X3lRJVyoHFzxb6h3kLtDtLU0
         FGunUYRveXcjLVzUFE/NzElQ3hysDDDBtfWjDc2aFWsvXDbHHBbn+YUUfBfrLnSH3A16
         MPwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=CHszZK7LblPbIXozkASGXG0KNy6kheJ5G3pXtlHdYnQ=;
        b=pdOpbtO4jUpsrpNT3seZSo+pUFr/ZoOfrnydG7s7Nwu/mIbv9khcfAmU/dUrxdtoJk
         5l8JmfMrFIH+nMCZnQgAgO4P4md3zKt7Wk/JL5tfezIeiX1PYDnhmLZp2H+MVi36Qqd3
         xTlB/B4WNu8VZFHSJYOzS3Y5QsZXTfR9GeI3N2z8wHF4Jnla4QIxu+7PfFEeGcLu1W7A
         XZ+f4MCGsIleAe44L0hGXNirdlT3UnMvxOBV5lbnB7bI96p9ZCPu+gpsZL/xsNL2VcxW
         2a6xan9sF4OOO57bZtVnrVRE3MplIxd8lcVg86Q7oYcBU0enkwdbLQnoxS3JQImpvlWH
         4Img==
X-Gm-Message-State: AOAM5312zUQxJ0z9av4Uf3NhH9rORcZmsOPrr2bUzAFXrarkTjPpRa3I
        M15bs/cD7rPpW3gJxjRf/keZ1g==
X-Google-Smtp-Source: ABdhPJzAq8p38vqysHThVjNdLyomEUJ7rUdLeUrbXdQcCLO4QeXk/YDc/UttBRLNdlSwCApCKlkGkA==
X-Received: by 2002:a2e:8283:: with SMTP id y3mr20906981ljg.51.1620205270712;
        Wed, 05 May 2021 02:01:10 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id q20sm368123lfm.194.2021.05.05.02.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 02:01:10 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, jiri@resnulli.us, idosch@idosch.org,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 6/9] net: dsa: Forward offloading
In-Reply-To: <20210504230409.kohxoc4cl7sjpkrg@skbuf>
References: <20210426170411.1789186-1-tobias@waldekranz.com> <20210426170411.1789186-7-tobias@waldekranz.com> <20210427101747.n3y6w6o7thl5cz3r@skbuf> <878s4uo8xc.fsf@waldekranz.com> <20210504152106.oppawchuruapg4sb@skbuf> <874kfintzh.fsf@waldekranz.com> <20210504205823.j5wg547lgyw776rl@skbuf> <87y2cum9mo.fsf@waldekranz.com> <20210504230409.kohxoc4cl7sjpkrg@skbuf>
Date:   Wed, 05 May 2021 11:01:09 +0200
Message-ID: <87pmy5mu5m.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 02:04, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, May 05, 2021 at 12:12:15AM +0200, Tobias Waldekranz wrote:
>> > and you create a dependency between the tagger and the switch driver
>> > which was supposed by design to not exist.
>> 
>> Sure, but _why_ should it not exist? Many fields in the tag can only be
>> correctly generated/interpreted in combination with knowledge of the
>> current configuration, which is the driver's domain. The dependency is
>> already there, etched in silicon.
>
> I'm a bit more of a pragmatic person,

Excuse me sir, I believe you left your dagger IN MY HEART :)

> it's not so much that I think that
> Lennert Buytenhek's original DSA design from 2008 was the holy grail and
> that we should do everything we can to preserve it intact. Far from it.
> But I actually like having the option to inject a DSA-tagged packet
> using Spirent TestCenter and measure IP forwarding between dsa_loop
> "switch" ports (actually a one-armed router is what it is). I also like,
> as a reviewer, to be able to test, if I want to, how a tail tagger
> behaves even if I don't own a switch with tail tagging. And this
> separation between the switch driver and the tag protocol driver makes
> that possible, just see it as a nice perk which we don't want to lose.

Completely understandable. I was trying to extrapolate where we will end
up with this separation as we add more and more features and couple the
tagger closer to the driver, and see if the current architecture was
still the optimal one. Trying to be ...pragmatic, if you will.

> As for more advanced features, like "the hardware requires me to invent
> a unique number based on a rolling counter, call it a TX timestamp ID,
> put it in the DSA header, then when transmission is done, an IRQ will be
> raised, and I need to match that TX timestamp that just became available
> to me, which is identifiable via the timestamp ID that I put in the DSA
> header, with the original skb", of course you can't do that without
> communication between the tagger and the driver itself, unless you make
> the tagger handle interrupts (and then there's the whole issue that the
> tagging protocol driver needs to be instantiated per switch, if it's
> going to be stateful), or the switch driver send packets. As a general
> rule of thumb, just don't break dsa_loop and we should be fine. For
> example, yes, PTP requires driver <-> tagger communication, but PTP
> timestamping is also not enabled by default, and guarded by an ioctl
> which dsa_loop doesn't implement. So the tagger can never trigger faulty
> code, dereferencing a ds->priv pointer which it thinks is "struct
> mv88e6xxx_chip" but is actually "struct dsa_loop_priv".

This should also hold for forward offloading, since dsa_loop would not
implement .ndo_dfwd_{add,del}_station.

Alright, include/linux/dsa/mv88e6xxx.h here I come!
