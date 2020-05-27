Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3E41E4FB7
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 22:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgE0U5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 16:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgE0U5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 16:57:23 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC5AC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 13:57:23 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id z1so8374296qtn.2
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 13:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vb7HtBs/AWjeuby2BhCfCxuMEVlvnnUDFNR4Y4qQPJI=;
        b=Pjv3Rn+0oXbB+u917d6mptsgIdWn+b2B5bS2geWj5qXfKmjXaMmaIRwQhG1zhMzKox
         a2EWnz9F/OUrxbYILZWmmeD2LiUYM2+wGrFSIqwigK80yS72r5ME07bb7+QgOkkZ6Iu4
         zca1VjnDl8T0zaxtNwgPy39RI5jh6rMCx5/Qw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vb7HtBs/AWjeuby2BhCfCxuMEVlvnnUDFNR4Y4qQPJI=;
        b=nTm5NFSx3YsrKqvpt4N4ScTBEsupPiAntu1+0ssnq3AcsD+v+ynh4o+DaaoXahpPM0
         Q/pcMmt/8D2jIFbtBk5nNXeDEIwW+idExV5wqU2ZLC/Tw/jIsXivQCL35to+p9Zv/Ea+
         kfa+NCeIzur/QdA7o8ExBwVTDQE6rLl7xgjFc8VppIdeKMa42303hBc30m0zyTdDWcyY
         VZp1gLu18/3TsRM9N2j2/tRz6CLs67Ioh2ZojIIzAn1b54p9fBxFLTDwHNYvRcZ9pT8c
         VYSvtQidD+duIp3GWD9rR8+Wvryhjz5XaALvytvnMF2y0xEcFxyV7Eg/V0AqNAxHKQ0/
         cIAg==
X-Gm-Message-State: AOAM533ysikgqaAsK98e3zPuo1O9jc1UNhLUN1VwLKJL6m4f6PEvqEqI
        1G9/SFEgaCKNafJzsVCRPoThfh2N8Jn2FIukWPhuyw==
X-Google-Smtp-Source: ABdhPJz1nMbZwk39o7uIxT4zZ3PQFnQQVq6nFkXgtyJONcCREkr4FYiNha5i5NpDKePr3fFK6mmurJWTN6femjwUrek=
X-Received: by 2002:aed:3fa4:: with SMTP id s33mr6479938qth.148.1590613042616;
 Wed, 27 May 2020 13:57:22 -0700 (PDT)
MIME-Version: 1.0
References: <1590214105-10430-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1590214105-10430-2-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200524045335.GA22938@nanopsycho> <CAACQVJpbXSnf0Gc5HehFc6KzKjZU7dV5tY9cwR72pBhweVRkFw@mail.gmail.com>
 <20200525172602.GA14161@nanopsycho> <CAACQVJpRrOSn2eLzS1z9rmATrmzA2aNG-9pcbn-1E+sQJ5ET_g@mail.gmail.com>
 <20200526044727.GB14161@nanopsycho> <CAACQVJp8SfmP=R=YywDWC8njhA=ntEcs5o_KjBoHafPkHaj-iA@mail.gmail.com>
 <20200526134032.GD14161@nanopsycho> <CAACQVJrwFB4oHjTAw4DK28grxGGP15x52+NskjDtOYQdOUMbOg@mail.gmail.com>
 <CAACQVJqTc9s2KwUCEvGLfG3fh7kKj3-KmpeRgZMWM76S-474+w@mail.gmail.com> <20200527131401.2e269ab8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200527131401.2e269ab8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Wed, 27 May 2020 13:57:11 -0700
Message-ID: <CACKFLi=+Q4CkOvaxQQm5Ya8+Ft=jNMwCAuK+=5SMxAfNGGriBw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset"
 generic device parameter.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 1:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 27 May 2020 09:07:09 +0530 Vasundhara Volam wrote:
> > Here is a sample sequence of commands to do a "live reset" to get some
> > clear idea.
> > Note that I am providing the examples based on the current patchset.
> >
> > 1. FW live reset is disabled in the device/adapter. Here adapter has 2
> > physical ports.
> >
> > $ devlink dev
> > pci/0000:3b:00.0
> > pci/0000:3b:00.1
> > pci/0000:af:00.0
> > $ devlink dev param show pci/0000:3b:00.0 name allow_fw_live_reset
> > pci/0000:3b:00.0:
> >   name allow_fw_live_reset type generic
> >     values:
> >       cmode runtime value false
> >       cmode permanent value false
> > $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
> > pci/0000:3b:00.1:
> >   name allow_fw_live_reset type generic
> >     values:
> >       cmode runtime value false
> >       cmode permanent value false
>
> What's the permanent value? What if after reboot the driver is too old
> to change this, is the reset still allowed?

The permanent value should be the NVRAM value.  If the NVRAM value is
false, the feature is always and unconditionally disabled.  If the
permanent value is true, the feature will only be available when all
loaded drivers indicate support for it and set the runtime value to
true.  If an old driver is loaded afterwards, it wouldn't indicate
support for this feature and it wouldn't set the runtime value to
true.  So the feature will not be available until the old driver is
unloaded or upgraded.

>
> > 2. If a user issues "ethtool --reset p1p1 all", the device cannot
> > perform "live reset" as capability is not enabled.
> >
> > User needs to do a driver reload, for firmware to undergo reset.
>
> Why does driver reload have anything to do with resetting a potentially
> MH device?

I think she meant that all drivers have to be unloaded before the
reset would take place in case it's a MH device since live reset is
not supported.  If it's a single function device, unloading this
driver is sufficient.

>
> > $ ethtool --reset p1p1 all
>
> Reset probably needs to be done via devlink. In any case you need a new
> reset level for resetting MH devices and smartnics, because the current
> reset mask covers port local, and host local cases, not any form of MH.

RIght.  This reset could be just a single function reset in this example.

>
> > ETHTOOL_RESET 0xffffffff
> > Components reset:     0xff0000
> > Components not reset: 0xff00ffff
> > $ dmesg
> > [  198.745822] bnxt_en 0000:3b:00.0 p1p1: Firmware reset request successful.
> > [  198.745836] bnxt_en 0000:3b:00.0 p1p1: Reload driver to complete reset
>
> You said the reset was not performed, yet there is no information to
> that effect in the log?!

The firmware has been requested to reset, but the reset hasn't taken
place yet because live reset cannot be done.  We can make the logs
more clear.

>
> > 3. Now enable the capability in the device and reboot for device to
> > enable the capability. Firmware does not get reset just by setting the
> > param to true.
> >
> > $ devlink dev param set pci/0000:3b:00.1 name allow_fw_live_reset
> > value true cmode permanent
> >
> > 4. After reboot, values of param.
>
> Is the reboot required here?
>

In general, our new NVRAM permanent parameters will take effect after
reset (or reboot).

> > $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
> > pci/0000:3b:00.1:
> >   name allow_fw_live_reset type generic
> >     values:
> >       cmode runtime value true
>
> Why is runtime value true now?
>

If the permanent (NVRAM) parameter is true, all loaded new drivers
will indicate support for this feature and set the runtime value to
true by default.  The runtime value would not be true if any loaded
driver is too old or has set the runtime value to false.
