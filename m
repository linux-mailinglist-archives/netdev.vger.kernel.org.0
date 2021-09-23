Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08090415ECC
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241067AbhIWMuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:50:51 -0400
Received: from mail-ot1-f52.google.com ([209.85.210.52]:37566 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240787AbhIWMub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:50:31 -0400
Received: by mail-ot1-f52.google.com with SMTP id r43-20020a05683044ab00b0054716b40005so1434657otv.4;
        Thu, 23 Sep 2021 05:49:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HPho5pdPE80Ol42nlkZkWLtxK1B46FluJvPe15qBAgc=;
        b=7rVbIfl1b/C++IYVIWXpNB3EA8xFGzByqqszAQZAdjoOq30ZWWwVGi9e/MxCoBamhF
         btsben525ir2iPjbuYOHsA2EWnM2LLVPOJg0OLZrzUE6TiSN0Vp4b1HW08eKs7W/lqyq
         efWjm9C5slyMqsYr0vsd/2+oIcLvrRGWqZ634k8MlfjcTGdKCsDXPdnW1tG1kZk3kSf+
         RNHufJzgQK2EXGvl1JfmHFmHZje+hsJmD2mmw4jNWH/2FA0PiB8Rx4feT4SRLFdXtLxb
         0gpGSGi09ICzLYDbjAJNoXdeXlwCE+jG557qCAFiG4k5OPSViPwSx1Ug7jdHOjNXqSPD
         rE1A==
X-Gm-Message-State: AOAM530Ch7mGj31FqJh5giljUlwAiJIqtndlgeGp/lGgetpM9DQwgU3Q
        mc/YaL8aqp70vSBbI5i8hTDx9SjY4LFSIb3bRZ4=
X-Google-Smtp-Source: ABdhPJzqIyB8PZUiSI/+lxuDijrE0Lm85sXH1TPxYCbh18wwxFZKnOcawv+pJ9UsVPnnVvNwjuumEoIDYRDPdAZKE10=
X-Received: by 2002:a9d:4d93:: with SMTP id u19mr4185271otk.86.1632401339990;
 Thu, 23 Sep 2021 05:48:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210915170940.617415-1-saravanak@google.com> <20210915170940.617415-3-saravanak@google.com>
 <CAJZ5v0h11ts69FJh7LDzhsDs=BT2MrN8Le8dHi73k9dRKsG_4g@mail.gmail.com>
 <YUaPcgc03r/Dw0yk@lunn.ch> <YUoFFXtWFAhLvIoH@kroah.com> <CAJZ5v0jjvf6eeEKMtRJ-XP1QbOmjEWG=DmODbMhAFuemNn4rZg@mail.gmail.com>
 <YUocuMM4/VKzNMXq@lunn.ch> <CAJZ5v0iU3SGqrw909GLtuLwAxdyOy=pe2avxpDW+f4dP4ArhaQ@mail.gmail.com>
 <YUo3kD9jgx6eNadX@lunn.ch> <CAGETcx9hTFhY4+fHd71zYUsWW223GfUWBp8xxFCb2SNR6YUQ4Q@mail.gmail.com>
In-Reply-To: <CAGETcx9hTFhY4+fHd71zYUsWW223GfUWBp8xxFCb2SNR6YUQ4Q@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 23 Sep 2021 14:48:48 +0200
Message-ID: <CAJZ5v0h4M1Rp2fVWWYN5qjTi4QjYjjjZ5Nc9=mNU-UtrN1RSXg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] driver core: fw_devlink: Add support for FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
To:     Saravana Kannan <saravanak@google.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 10:07 PM Saravana Kannan <saravanak@google.com> wrote:
>
> Sorry I've been busy with LPC and some other stuff and could respond earlier.
>
> On Tue, Sep 21, 2021 at 12:50 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > It works at a device level, so it doesn't know about resources.  The
> > > only information it has is of the "this device may depend on that
> > > other device" type and it uses that information to figure out a usable
> > > probe ordering for drivers.
> >
> > And that simplification is the problem. A phandle does not point to a
> > device, it points to a resource of a device. It should really be doing
> > what the driver would do, follow the phandle to the resource and see
> > if it exists yet. If it does not exist then yes it can defer the
> > probe. If the resource does exist, allow the driver to probe.
> >
> > > Also if the probe has already started, it may still return
> > > -EPROBE_DEFER at any time in theory
> >
> > Sure it can, and does. And any driver which is not broken will
> > unregister its resources on the error path. And that causes users of
> > the resources to release them. It all nicely unravels, and then tries
> > again later. This all works, it is what these drivers do.
>
> One of the points of fw_devlink=on is to avoid the pointless deferred
> probes that'd happen in this situation. So saying "let this happen"
> when fw_devlink=on kinda beats the point of it. See further below.

Well, you need to define "pointless deferred probes" in the first
place.  fw_devlink adds deferred probes by itself, so why are those
not pointless whereas the others are?

> >
> > > However, making children wait for their parents to complete probing is
> > > generally artificial, especially in the cases when the children are
> > > registered by the parent's driver.  So waiting should be an exception
> > > in these cases, not a rule.
>
> Rafael,
>
> There are cases where the children try to probe too quickly (before
> the parent has had time to set up all the resources it's setting up)
> and the child defers the probe. Even Andrew had an example of that
> with some ethernet driver where the deferred probe is attempted
> multiple times wasting time and then it eventually succeeds.

You seem to be arguing that it may be possible to replace multiple
probe attempts that each are deferred with one probe deferral which
then is beneficial from the performance perspective.

Yes, there are cases like that, but when this is used as a general
rule, it introduces a problem if it does a deferred probe when there
is no need for a probe deferral at all (like in the specific problem
case at hand).  Also if the probing of the child is deferred just
once, adding an extra dependency on the parent to it doesn't really
help.

> Considering there's no guarantee that a device_add() will result in
> the device being bound immediately, why shouldn't we make the child
> device wait until the parent has completely probed and we know all the
> resources from the parent are guaranteed to be available? Why can't we
> treat drivers that assume a device will get bound as soon as it's
> added as the exception (because we don't guarantee that anyway)?

Because this adds artificial constraints that otherwise aren't there
in some cases to the picture and asking drivers to mark themselves as
"please don't add these artificial constraints for me" is not
particularly straightforward.  Moreover, it does that retroactively
causing things that are entirely correct and previously worked just
fine to now have to paint themselves red to continue working as
before.

The fact that immediate probe completion cannot be guaranteed in
general doesn't mean that it cannot be assumed in certain situations.
For example, a parent driver registering a child may know what the
child driver is and so it may know that the child will either probe
successfully right away or the probing of it will fail and your extra
constraint breaks that assumption.  You can't really know how many of
such cases there are and trying to cover them with a new flag is a
retroactive whack-a-mole game.

> Also, this assumption that the child will be bound successfully upon
> addition forces the parent/child drivers to play initcall chicken --
> the child's driver has to be registered before the parent's driver.

That's true, but why is this a general problem?  For example, they
both may be registered by the same function in the right order.
What's wrong with that?

> We should be getting away from those by fixing the parent driver that's
> making these assumptions (I'll be glad to help with that). We need to
> be moving towards reducing pointless deferred probes and initcall
> ordering requirements instead of saying "this bad assumption used to
> work, so allow me to continue doing that".

It is not always a bad assumption.  It may be code designed this way.
