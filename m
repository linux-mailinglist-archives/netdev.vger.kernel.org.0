Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4822CC4B7
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 19:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgLBSLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 13:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389357AbgLBSLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 13:11:32 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E283C0617A7
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 10:10:52 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id t8so2880268iov.8
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 10:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vEV4fu903fYOvRzTVs1GAE1bS7x+k6+f6iWKBT4VmFk=;
        b=gZiqLPB3HXaucHZC3DcMfH5DxHVkmp9L8C17erp9caWBhAhdjwu2yy9AIBE17C4yzl
         y/fkgwknxQ2lEpWSs8MO9h01il30x6GG5b2PAI1LhSX5slyib9ohK/Ni68XnBqleRYWH
         qhV5ngc/cnE6iFSrJGhiLJq3Dk5ybumvnJBlYH0LKoizziIj4Oop1df5xWudNDqYp5pU
         SR+9uvB8AW7qwEoH6aQRYKteoHfFr+apvqblrC+CmvZnM8vqwEOQKWIvx0Vm7qMjAI+n
         ht+EA8t4X6X9+D41n+eS5T+SKUOdDqIEffT3hZe3OAMx2JN5ZPsFmGX5nsImH7izhb6B
         13Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vEV4fu903fYOvRzTVs1GAE1bS7x+k6+f6iWKBT4VmFk=;
        b=si9UVRvx2yBHEEd9MbKNbi1mc39FJy+IWzdpnPkulz8fhfsxI5L+0LDyizfKr5BxnS
         LM8v+P/DbY9yerspnrXruphu7aMXug/t3dIk5aeAJ8jL96I9Ql46dfALQ70TsSEKVWee
         EiU9VvdSYLs/tMAyHIVkOALT7DIF0PL2608mm1NkYXM7II5Q3WWWm32EekKWIYdL4OEx
         Yefmh8C08n0Z/GkC8XicoxrRaCE3X4fLwxEOj7gikDby/jKYZ/53wbAf5r38A0JZHyIf
         RyzGKSUzKLEG8OdzozBHhrVLxLYfWW94nSUFdhbB9D/b/FQdofGQ87X8ayObeKcLylvz
         6jHA==
X-Gm-Message-State: AOAM530TFlmCByb9pbL2duV4cilO9hmWJIVqpfPS7SP8AzYjZGLlMYhL
        Knm1N9BzK5IDUGPS3tc/Uxk=
X-Google-Smtp-Source: ABdhPJy0hEoHM9kywgzYXm23ZI8H6Z4WNMwLVqH4Hx0aBOHWxPCGFNqKbc2eTIIdHZeJgNy2/tmRxQ==
X-Received: by 2002:a02:834b:: with SMTP id w11mr3342976jag.5.1606932651703;
        Wed, 02 Dec 2020 10:10:51 -0800 (PST)
Received: from localhost (c-68-46-86-141.hsd1.mn.comcast.net. [68.46.86.141])
        by smtp.gmail.com with ESMTPSA id v62sm1279034iod.50.2020.12.02.10.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 10:10:51 -0800 (PST)
Date:   Wed, 2 Dec 2020 12:10:49 -0600
From:   Grant Edwards <grant.b.edwards@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: net: macb: fail when there's no PHY
Message-ID: <X8fYqefWagIl15En@grante>
References: <20170921195905.GA29873@grante>
 <66c0a032-4d20-69f1-deb4-6c65af6ec740@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66c0a032-4d20-69f1-deb4-6c65af6ec740@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 21, 2017 at 01:05:57PM -0700, Florian Fainelli wrote:
> On 09/21/2017 12:59 PM, Grant Edwards wrote:
> > Several years back (circa 2.6.33) I had to hack up macb.c to work on
> > an at91 board that didn't have a PHY connected to the macb controller.
> > [...]
> > It looks like the macb driver still can't handle boards that don't
> > have a PHY.  Is that correct?
> 
> Not since:
> dacdbb4dfc1a1a1378df8ebc914d4fe82259ed46 ("net: macb: add fixed-link
> node support")
> 
> > What's the right way to deal with this?
> 
> Declaring a fixed PHY that will present an emulated link UP, with a
> fixed speed/duplex etc. is the way to go.

Apologies, I know this thread is a few years old, but I finally got
around to working with a newer kernel (5.4) that has the "fixed phy"
support. Unfortunately, the existing "fixed phy" support is unusable
for us. It doesn't just present a fake fixed, PHY. It replaces the
entire mii (mdio/mdc) bus with a fake _bus_. That means our code loses
the ability to talk to the devices that are attached to the macb's
mdio management bus.

So, I ended up porting my hack from the 2.6.33 macb.c driver to the
5.4 macb.c driver. It presents a fake PHY at one address on the mdio
bus, but still allows normal communication with devices at other
addresses on the bus. We use SIOC[SG]MIIREG ioctl() calls from
userspace to talk to those real devices. Adding a fake PHY to the
macb's mdio bus takes a total of about two dozen lines of code.

Was there some other way I should have done this with a 5.4 kernel
that I was unable to discover?

[Unfortunately, the performance of the 5.4 kernel on an ARM926 is so
bad I don't think we're going to be able to use it.]

--
Grant
