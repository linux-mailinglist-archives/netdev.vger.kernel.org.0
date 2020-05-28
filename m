Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD421E5356
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgE1BuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgE1BuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 21:50:14 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B799C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 18:50:13 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id a25so19738662ljp.3
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 18:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7HO4VGvfJaO11WnCrH8phwMHWakJOaP4I3gStGNewAU=;
        b=VjIO/D8JPp89pt86vIIXXzNnI93QBiaxJUHUJ7PgGNfZt0GVlKHs+4za4HFma3SqMl
         Wi78kuIfrqFv98OAEv4/IzfqHxudAeatLc+uK2o7YePydrAzr5nff+3euKNYJC6sRG/1
         fVL0NTrZ/K6wGelNi+Tdncp8LewqsWLl1g/iQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7HO4VGvfJaO11WnCrH8phwMHWakJOaP4I3gStGNewAU=;
        b=M0M6Mi9TySIOxPlnqwU/oVc1iNxMjimnNNdXe437nDG9kWVd34XlFEZ0uTv7upq15x
         16ZXGnl6wCzoZkWEdUHvChjJOb5WUstTSxSZ6LRqtqs6TKbnruEsSqzGp+VvcOabc8Me
         5MtK/ankGtibrizeZ5qGT1xjYT1HZNRM3HYERA+NnqCZSW0BBdtHDSk2vsM6uBmHIvhy
         b9tCttDk/ctr5V4GfeuraEsBJMH7M8RgezMuTrGX+RrSqv02as6hTG9YAdsxIaB4ZmE1
         wYfCNwaZc2Br8SYlgwwbGXDuY3kSMgBo6XsQSKJ0jBu5AoSxxxBa8ArEL6uGUo9KHzcf
         xbAw==
X-Gm-Message-State: AOAM533I22xJUMvRZ0aCP91kfNVLqALLph5Z5jUFVZpB50cHzMM792/q
        1V7A0Ti6J3fG+tQssf0zURroBkgo+bjdzlDkm5j5Rg==
X-Google-Smtp-Source: ABdhPJzFCU869zoPYes/CovfJuX7jSdZqaHe4yS6KrvSfleWqeGGfUmv3rtUWQplV5Jm8cOWlYCG7KANQMnvySG4It4=
X-Received: by 2002:a2e:2a43:: with SMTP id q64mr238301ljq.419.1590630611623;
 Wed, 27 May 2020 18:50:11 -0700 (PDT)
MIME-Version: 1.0
References: <1590214105-10430-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1590214105-10430-2-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200524045335.GA22938@nanopsycho> <CAACQVJpbXSnf0Gc5HehFc6KzKjZU7dV5tY9cwR72pBhweVRkFw@mail.gmail.com>
 <20200525172602.GA14161@nanopsycho> <CAACQVJpRrOSn2eLzS1z9rmATrmzA2aNG-9pcbn-1E+sQJ5ET_g@mail.gmail.com>
 <20200526044727.GB14161@nanopsycho> <CAACQVJp8SfmP=R=YywDWC8njhA=ntEcs5o_KjBoHafPkHaj-iA@mail.gmail.com>
 <20200526134032.GD14161@nanopsycho> <CAACQVJrwFB4oHjTAw4DK28grxGGP15x52+NskjDtOYQdOUMbOg@mail.gmail.com>
 <CAACQVJqTc9s2KwUCEvGLfG3fh7kKj3-KmpeRgZMWM76S-474+w@mail.gmail.com>
 <20200527131401.2e269ab8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CACKFLi=+Q4CkOvaxQQm5Ya8+Ft=jNMwCAuK+=5SMxAfNGGriBw@mail.gmail.com> <20200527141608.3c96f618@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200527141608.3c96f618@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Thu, 28 May 2020 07:20:00 +0530
Message-ID: <CAACQVJqs9=PJ5UBrW9R9UmVYX1jqkJvZWj3j6FmVB9S5mOn+mg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset"
 generic device parameter.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 2:46 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 27 May 2020 13:57:11 -0700 Michael Chan wrote:
> > On Wed, May 27, 2020 at 1:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Wed, 27 May 2020 09:07:09 +0530 Vasundhara Volam wrote:
> > > > Here is a sample sequence of commands to do a "live reset" to get some
> > > > clear idea.
> > > > Note that I am providing the examples based on the current patchset.
> > > >
> > > > 1. FW live reset is disabled in the device/adapter. Here adapter has 2
> > > > physical ports.
> > > >
> > > > $ devlink dev
> > > > pci/0000:3b:00.0
> > > > pci/0000:3b:00.1
> > > > pci/0000:af:00.0
> > > > $ devlink dev param show pci/0000:3b:00.0 name allow_fw_live_reset
> > > > pci/0000:3b:00.0:
> > > >   name allow_fw_live_reset type generic
> > > >     values:
> > > >       cmode runtime value false
> > > >       cmode permanent value false
> > > > $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
> > > > pci/0000:3b:00.1:
> > > >   name allow_fw_live_reset type generic
> > > >     values:
> > > >       cmode runtime value false
> > > >       cmode permanent value false
> > >
> > > What's the permanent value? What if after reboot the driver is too old
> > > to change this, is the reset still allowed?
> >
> > The permanent value should be the NVRAM value.  If the NVRAM value is
> > false, the feature is always and unconditionally disabled.  If the
> > permanent value is true, the feature will only be available when all
> > loaded drivers indicate support for it and set the runtime value to
> > true.  If an old driver is loaded afterwards, it wouldn't indicate
> > support for this feature and it wouldn't set the runtime value to
> > true.  So the feature will not be available until the old driver is
> > unloaded or upgraded.
>
> Setting this permanent value to false makes the FW's life easier?

It just disables the feature.

> Otherwise why not always have it enabled and just depend on hosts
> not opting in?

We are providing permanent value as a flexibility to user. We can
remove it, if it makes things easy and clear.

>
> > > > 2. If a user issues "ethtool --reset p1p1 all", the device cannot
> > > > perform "live reset" as capability is not enabled.
> > > >
> > > > User needs to do a driver reload, for firmware to undergo reset.
> > >
> > > Why does driver reload have anything to do with resetting a potentially
> > > MH device?
> >
> > I think she meant that all drivers have to be unloaded before the
> > reset would take place in case it's a MH device since live reset is
> > not supported.  If it's a single function device, unloading this
> > driver is sufficient.
yes.

>
> I see.
>
> > > > $ ethtool --reset p1p1 all
> > >
> > > Reset probably needs to be done via devlink. In any case you need a new
> > > reset level for resetting MH devices and smartnics, because the current
> > > reset mask covers port local, and host local cases, not any form of MH.
> >
> > RIght.  This reset could be just a single function reset in this example.
>
> Well, for the single host scenario the parameter dance is not at all
> needed, since there is only one domain of control. If user can issue a
> reset they can as well change the value of the param or even reload the
> driver. The runtime parameter only makes sense in MH/SmartNIC scenario,
> so IMHO the param and devlink reset are strongly dependent.
>
> > > > ETHTOOL_RESET 0xffffffff
> > > > Components reset:     0xff0000
> > > > Components not reset: 0xff00ffff
> > > > $ dmesg
> > > > [  198.745822] bnxt_en 0000:3b:00.0 p1p1: Firmware reset request successful.
> > > > [  198.745836] bnxt_en 0000:3b:00.0 p1p1: Reload driver to complete reset
> > >
> > > You said the reset was not performed, yet there is no information to
> > > that effect in the log?!
> >
> > The firmware has been requested to reset, but the reset hasn't taken
> > place yet because live reset cannot be done.  We can make the logs
> > more clear.
>
> Thanks
>
> > > > 3. Now enable the capability in the device and reboot for device to
> > > > enable the capability. Firmware does not get reset just by setting the
> > > > param to true.
> > > >
> > > > $ devlink dev param set pci/0000:3b:00.1 name allow_fw_live_reset
> > > > value true cmode permanent
> > > >
> > > > 4. After reboot, values of param.
> > >
> > > Is the reboot required here?
> >
> > In general, our new NVRAM permanent parameters will take effect after
> > reset (or reboot).
> >
> > > > $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
> > > > pci/0000:3b:00.1:
> > > >   name allow_fw_live_reset type generic
> > > >     values:
> > > >       cmode runtime value true
> > >
> > > Why is runtime value true now?
> > >
> >
> > If the permanent (NVRAM) parameter is true, all loaded new drivers
> > will indicate support for this feature and set the runtime value to
> > true by default.  The runtime value would not be true if any loaded
> > driver is too old or has set the runtime value to false.
>
> Okay, the parameter has a bit of a dual role as it controls whether the
> feature is available (false -> true transition requiring a reset/reboot)
> and the default setting of the runtime parameter. Let's document that
> more clearly.
Please look at the 3/4 patch for more documentation in the bnxt.rst
file. We can add more documentation, if needed, in the bnxt.rst file.

Thanks.
