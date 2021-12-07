Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CC746BC68
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 14:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237045AbhLGN1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 08:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbhLGN1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 08:27:46 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A957C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 05:24:16 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id y12so56633790eda.12
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 05:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XnMR7eMN7qGz4bJi2ziwgBF7+vQA1pNH5AQEmWgik10=;
        b=P6o70GWL6euYCyzhs76P1tm1j+E8XCktcNfUMG3comegTgAtVK6XHSM6lrdrtyVJKH
         aHfT5Jx2jV1ladwsDP+EK9rs5OiVckTnqQLT5YViwCCk4arvjJT3BW2a7m87YLCCWtiP
         2fIrHua11EZYisvENeQqrGyROF58uZzIsjQ5zsahnlG9Zs5BO5yOgxBjuGCwh7GwKUA5
         +tzYsZYqWP3d7KqVL3QCyOqtxJkzHSpnVzEY6J2QA45dAfYBIriOC7g6JIxNh4OjWFLI
         PLFfmoD29QfR+xT+pJuSpWvz4o0upe9LvVgD6SsdjoGd057MCGcTcFQoMo3bIdc3TDZi
         nS1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XnMR7eMN7qGz4bJi2ziwgBF7+vQA1pNH5AQEmWgik10=;
        b=AVagMQ2mwwbc2as2Nv3sigGQmtLLmtRMpqFM3B8vsk6sdb13/QNkJZDbRsDkE38V8b
         rWeR3M5gpmJTInPx4GLDVuKFVrLpe3SRVN5C16qYeDiXVZn88L59W3A3xe/xXKt5eLei
         +V6py2KhCN5+/lIjGZfAAcTdfL/jalmDhofuXOcP6d0fZYGAr7TBs/f1FqmYZJvWT5wJ
         q7j/npRGMPJbFloJslXAAsZm838s7tSiNz2M+zoppvECL8m9S+3yvY9cIeLvGMg/8X1f
         bZQ/z88xA6uLbFUjC2T2Nci7MsSvTvL1Y5vDb5tYa1LWDMCEEKbYjRt6r2xOnhgXzlk6
         6ZvA==
X-Gm-Message-State: AOAM530u06veCIuI3Hf6bMWtFG2Z4rRDq749HMcUxUvEWPjycs6ZaNqX
        ARme8Rd+VvG72FxFoAhpxXyDcegZs4E=
X-Google-Smtp-Source: ABdhPJzh4N5Yghiff/werCpZk0GaZGVxyl42F+D3mKYsSph8J4KRChXO4bX9brbXYWhX56ay/TQaNw==
X-Received: by 2002:a17:907:2cc5:: with SMTP id hg5mr52957797ejc.138.1638883454550;
        Tue, 07 Dec 2021 05:24:14 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id nc29sm8559789ejc.3.2021.12.07.05.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 05:24:14 -0800 (PST)
Date:   Tue, 7 Dec 2021 15:24:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <20211207132413.f4av4d3expfzhnwl@skbuf>
References: <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5tkXU3AXalFRg2@shell.armlinux.org.uk>
 <20211206202308.xoutfymjozfyhhkl@skbuf>
 <Ya53vXp7Wz5YPf7Y@shell.armlinux.org.uk>
 <20211206211341.ppllxa7ve2jdyzt4@skbuf>
 <Ya6ARQBGl2C4Z3il@shell.armlinux.org.uk>
 <Ya6FcTIbyO+zXj7V@shell.armlinux.org.uk>
 <20211206232735.vvjgm664y67nggmm@skbuf>
 <Ya6xrNbwZUxCbH3X@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya6xrNbwZUxCbH3X@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 12:58:20AM +0000, Russell King (Oracle) wrote:
> > Anyway, so be it. Essentially, what is the most frustrating is that I
> > haven't been doing anything else for the past 4 hours, and I still
> > haven't understood enough of what you're saying to even understand why
> > it is _relevant_ to Martyn's report. All I understand is that you're
> > also looking in that area of the code for a completely unrelated reason
> > which you've found adequate to mention here and now.
> 
> I hope you realise that _your_ attitude here is frustrating and
> inflamatory. This is _not_ a "completely unrelated reason" - this
> is about getting the right solution to Martyn's problem. I thought
> about doing another detailed reply, but when I got to the part
> about you wanting to check 6390X, I discarded that reply and
> wrote this one instead. You clearly have a total distrust for
> everything that I write in any email, so I just won't bother.

I think getting the right solution to Martyn's problem is the most
important part. I'd be very happy if I understood it too, although that
isn't mandatory, since it may be beyond me but still correct, and I hope
I'm not standing in the way if that is the case.
I've explained my current state of understanding, which is that I saw in
the manual for 6097 that forcing the link is unnecessary for internal
PHY ports regardless of whether the PPU is enabled or not. Yet, DSA will
still force these ports down with your proposed change (because DSA lies
that it is a MLO_AN_FIXED mode despite what's in the device tree), and
it relies on unforcing them in mv88e6xxx_mac_config(), which in itself
makes sense considering the other discussion about kexec and such. But
it appears that it may not unforce them again - because that condition
depends on mv88e6xxx_port_ppu_updates() which may be false. So if it is
false, things are still broken.
It isn't a matter of distrust and I'm sorry that you take it personal,
but your proposed solution doesn't appear to me to have a clear
correlation to the patch that introduced a regression.
