Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22563FBEF0
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 00:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbhH3WVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 18:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbhH3WVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 18:21:05 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88BCC061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 15:20:10 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id k20-20020a05600c0b5400b002e87ad6956eso999379wmr.1
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 15:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+QqRcja9w0/dOIxlhqX/P8WBVbZLqErRCLlrxdcvgRw=;
        b=YIPwfPIbieMe8xA7r7cwiQWXZvXAr98HoAzS7pLatEb4i+axwZULpZPRuGYRYNM0zK
         3Dqnb/z7G+HHoStsAa2MrkxqBNVn5ZMBUgBBFUYKFaUcs5g9bl7iI8RkCIlWINRbTfU2
         GOFEt/eb99rfrCjDbfNNr7mNqUDF5uc3OQGCAqi2Hhn9/6UNM3vRGCNZTV2fsLle4M8T
         AgqaPA1NuSw4iMc4ZJjn4KMMipiNzrbAJ/y7JyspAjXQn3I+i6pCbsFYBne4LfKk+WkZ
         /e0d6u8wj5FIYF+fRYSbJskG2Y/pWCuVifJ88Hb3Ve5v8VfXLlgZAwzm5SdPeuo9tsnM
         0W4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+QqRcja9w0/dOIxlhqX/P8WBVbZLqErRCLlrxdcvgRw=;
        b=XlMuFsZeiAdikedt0+QIe5c6eJCy0pa/Anu5V4p1cbAi8F6l1VM+rVoB5Jh2WvjCrM
         PFLoFT/gh46CgdMHAV6CyQXlIkjJjg4C2uChK0GXmR5ODCUZm1eWA2gSIkTIcXvtZo5R
         FObxAFMlM8TKQH/nf+B16a6m1U726IFna5RmXB2XYLW5tQMLMmZ3C3porFY+PbQoLrMI
         6GaHpvhp054b9HQj+o6SkUZkUYMs+PxWQalNKwTGuMD04kK1Gq8KKFDOLSVR4viS/d6P
         tcA1toLWdfskPecAA6zbgM7ribiiGiX4SoY9SaDmidEE87k41nkXCfsC+OByPPofBLx8
         UzIw==
X-Gm-Message-State: AOAM532a3gfs6Hj2dj2qC86twDqGSgeeuNi2HQwKxCwENH7wKtdWVjtX
        xkL6IoIT0+9yDkxFTRFVfi4=
X-Google-Smtp-Source: ABdhPJyPFC5dqP0XyKXM5vNRxIqZF25J3Vwf/iiiD0KSwW7CbNAO3wkKDazM3uej0PcDBdM/vuwYMg==
X-Received: by 2002:a1c:7e12:: with SMTP id z18mr1085042wmc.60.1630362009323;
        Mon, 30 Aug 2021 15:20:09 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id i20sm705018wml.37.2021.08.30.15.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 15:20:08 -0700 (PDT)
Date:   Tue, 31 Aug 2021 01:20:07 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: Re: [PATCH net] net: dsa: tag_rtl4_a: Fix egress tags
Message-ID: <20210830222007.2i6k7pg72yuoygwh@skbuf>
References: <20210828235619.249757-1-linus.walleij@linaro.org>
 <20210830072913.fqq6n5rn3nkbpm3q@skbuf>
 <CACRpkdbVs9H8CPYV9Fgwje40qqS=wxXqVkDc=Du=c82eqeKCAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbVs9H8CPYV9Fgwje40qqS=wxXqVkDc=Du=c82eqeKCAw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 11:56:22PM +0200, Linus Walleij wrote:
> On Mon, Aug 30, 2021 at 9:29 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Sun, Aug 29, 2021 at 01:56:19AM +0200, Linus Walleij wrote:
> > > I noticed that only port 0 worked on the RTL8366RB since we
> > > started to use custom tags.
> > >
> > > It turns out that the format of egress custom tags is actually
> > > different from ingress custom tags. While the lower bits just
> > > contain the port number in ingress tags, egress tags need to
> > > indicate destination port by setting the bit for the
> > > corresponding port.
> > >
> > > It was working on port 0 because port 0 added 0x00 as port
> > > number in the lower bits, and if you do this the packet gets
> > > broadcasted to all ports, including the intended port.
> > > Ooops.
> >
> > Does it get broadcast, or forwarded by MAC DA/VLAN ID as you'd expect
> > for a regular data packet?
> 
> It gets broadcast :/

Okay, so a packet sent to a port mask of zero behaves just the same as a
packet sent to a port mask of all ones is what you're saying?
Sounds a bit... implausible?

When I phrased the question whether it gets "forwarded by MAC DA/VLAN ID",
obviously this includes the possibility of _flooding_, if the MAC
DA/VLAN ID is unknown to the FDB. The behavior of flooding a packet due
to unknown destination can be practically indistinguishable from a
"broadcast" (the latter having the sense that "you've told the switch to
broadcast this packet to all ports", at least this is what is implied by
the context of your commit message).

The point is that if the destination is not unknown, the packet is not
flooded (or "broadcast" as you say). So "broadcast" would be effectively
a mischaracterization of the behavior.

Just want to make sure that the switch does indeed "broadcast" packets
with a destination port mask of zero. Also curious if by "all ports",
the CPU port itself is also included (effectively looping back the packet)?

> > > -     out = (RTL4_A_PROTOCOL_RTL8366RB << 12) | (2 << 8);
> >
> > What was 2 << 8? This patch changes that part.
> 
> It was a bit set in the ingress packets, we don't really know
> what egress tag bits there are so first I just copied this
> and since it turns out the bits in the lower order are not
> correct I dropped this too and it works fine.
> 
> Do you want me to clarify in the commit message and
> resend?

Well, it is definitely not a logical part of the change. Also, a bug fix
patch that goes to stable kernels seems like the last place to me where
you'd want to change something that you don't really know what it does...
In net-next, this extra change is more than welcome. Possibly has
something to do with hardware address learning on the CPU port, but this
is just a very wild guess based on some other Realtek tagging protocol
drivers I've looked at recently. Anyway, more than likely not just a
random number with no effect.
