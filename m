Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95ED3488EF3
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 04:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238374AbiAJDjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 22:39:35 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:53926
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238371AbiAJDjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 22:39:35 -0500
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E14E540A58
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 03:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641785973;
        bh=pQ19/9SUWFmu9QWaYJWAgIjttlL4E8YQab0OKaz5DsA=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=q2ptJYO0ewt7UUY7kt1GbShK1W0z0kKUwbRBZu6eR+mUYTm6U7TmxRrjFGRQ0p/oi
         J1+kjTpKauoqglTasIXygBnMIg49eYRcpnyG96oDKrkmQnYewO3qHhjGxaGgjxlCPf
         miUwWYzBAIbqYBm0pHPKeridO1fm1ub+Glm7RXv2OAIgbVfrgrZfwvGiGUimx16N2v
         /lLSsBwvDqBdjglcD0qaurme8Miw9JPqhFb8N/8aJw5jfpmQ2XtkZHokm2xOiN9ZkE
         OXeFDyfP0I67dh0ggxDheLnE7xSmSBWwuFf9fw9r8I0MorXhqPidL+P7Arz1PZkbC/
         7DnHcK9eAfhcw==
Received: by mail-oo1-f72.google.com with SMTP id n5-20020a4ab345000000b002dc79e4a2baso3639552ooo.15
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 19:39:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pQ19/9SUWFmu9QWaYJWAgIjttlL4E8YQab0OKaz5DsA=;
        b=sPUsRF3JHjhxkKG7qFhOCuLQIjSy0J03rLFh8U88Mt+U8mVevlgxQjkxLMS3+AFTa6
         TXuZn4F9r53mY6MjZ82aSB8C0BOnCWoJFJHkRfi8E56kr1ihpCV5bX+cpwH3hWeCkW8v
         VgDDp8Ao9RDKf8pcbXkbQ32mOYhQXMV34CeSGiGm0yvKQj5zLGxfP0/hsGROszsDBN3i
         U+4jx51evDg9le2VxkIvB6X/H4U14Fux4FXGbc1tj7VkK9Z6LvPpektxjn7x37LoiKCn
         u5NEbrqDfuE+Ab/6rsU2DQn6XOfDKH/q0TJ9CoUlTx+/S6vu2ju3sMScejHX98rbSSp8
         yY4A==
X-Gm-Message-State: AOAM531CCjq3umEblxFY1902Ivzj8ARNPfxKuumaW9yXEJ0zjRqfxwYf
        ZnQz41M8D6Az7ROaH+1m5SRHzyEXncpKIFXsOfqvbFECTZ7v2ql3yypWR5og4D7HQ/XOvQ6MrlD
        ugL1PnaC9Qx5Dh+ev86KDUkHccLHkxBr2mgahCEexYXofLUhheQ==
X-Received: by 2002:a05:6808:198c:: with SMTP id bj12mr3768731oib.146.1641785972689;
        Sun, 09 Jan 2022 19:39:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz05xk4ZBJfcYO9IQwZKVBtMGSiPz0jY4s034Wxc925wwPuDP2ai5KfuJBp99zDtCJRoyXhOt6lcdvyHA9pNDU=
X-Received: by 2002:a05:6808:198c:: with SMTP id bj12mr3768719oib.146.1641785972457;
 Sun, 09 Jan 2022 19:39:32 -0800 (PST)
MIME-Version: 1.0
References: <20220105151427.8373-1-aaron.ma@canonical.com> <YdXVoNFB/Asq6bc/@lunn.ch>
 <bb6d8bc4-abee-8536-ca5b-bac11d1ecd53@suse.com> <YdYbZne6pBZzxSxA@lunn.ch>
 <CAAd53p52uGFjbiuOWAA-1dN7mTqQ0KFe9PxWvPL+fjfQb9K5vQ@mail.gmail.com>
 <YdbuXbtc64+Knbhm@lunn.ch> <CAAd53p5YnQZ0fDiwwo-q3bNMVFTJSMLcdkUuH-7=OSaRrW954Q@mail.gmail.com>
 <YdhA6QqOKQ19uKWG@lunn.ch>
In-Reply-To: <YdhA6QqOKQ19uKWG@lunn.ch>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Mon, 10 Jan 2022 11:39:21 +0800
Message-ID: <CAAd53p7C_j6FTfnRK9L-UDmMrbkm75-mYN50_NpPiE2Y=Zgj1g@mail.gmail.com>
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough address
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oliver Neukum <oneukum@suse.com>,
        Aaron Ma <aaron.ma@canonical.com>, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 7, 2022 at 9:32 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > You should be thinking of this in more general terms. You want to
> > > design a system that will work for any vendors laptop and dock.
> > >
> > > You need to describe the two interfaces using some sort of bus
> > > address, be it PCIe, USB, or a platform device address as used by
> > > device tree etc.
> > >
> > > Let the kernel do whatever it wants with MAC addresses for these two
> > > interfaces. The only requirement you have is that the laptop internal
> > > interface gets the vendor allocated MAC address, and that the dock get
> > > some sort of MAC address, even if it is random.
> >
> > Those laptops and docks are designed to have duplicated MACs. I don't
> > understand why but that's why Dell/HP/Lenovo did.
>
> But it also sounds like the design is broken. So the question is, is
> it possible to actually implement it correctly, without breaking
> networking for others with sane laptop/docks/USB dongles.

It's possible, just stick to whitelist and never over generalize the
device matching rule.

>
> > What if the kernel just abstract the hardware/firmware as intended, no
> > matter how stupid it is, and let userspace to make the right policy?
>
> Which is exactly what is being suggested here. The kernel gives the
> laptop internal interface its MAC address from ACPI or where ever, and
> the dock which has no MAC address gets a random MAC address. That is
> the normal kernel abstract. Userspace, in the form of udev, can then
> change the MAC addresses in whatever way it wants.

That's not what I mean. I mean the kernel should do what
firmware/hardware expects kernel should do - copy the MAC from ACPI to
the external NIC in the dock.
Then the userspace can assign a random MAC to external interface if
internal interface is already up.

>
> > But power users may also need to use corporate network to work as
> > Aaron mentioned.
> > Packets from unregistered MAC can be filtered under corporate network,
> > and that's why MAC pass-through is a useful feature that many business
> > laptops have.
>
> Depends on the cooperate network, but power users generally know more
> than the IT department, and will just make their machine work, copying
> the 802.3x certificate where ever it needs to go, us ebtables to
> mangle the MAC address, build their own little network with an RPi
> acting as a gateway doing NAT and MAC address translation, etc.

That's true, but as someone who work closely with other Distro folks,
we really should make this feature works for (hopefully) everyone.

Kai-Heng

>
>        Andrew
