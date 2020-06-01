Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A351D1EA056
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 10:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgFAIvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 04:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgFAIvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 04:51:04 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CCCC061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 01:51:03 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id c12so3449806lfc.10
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 01:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Uz6IW2FNV4ApExE0H60aD8KB5mmAvw/KutRETmXI8U=;
        b=ZUONmxqwNidkU0S7M5gZYXviWRK02LqH5JgX+70UthY7ojp3nab724YJ3g3f4CjtrC
         PViWiaFTYEuF8kI36L5Jz5AqAy9mRL5HASR7hpYVgJSfjIAmWmoevetJWh39EoMk8qRs
         LKHCxJxckY91cfUS18VUKjoVDEN2PX/Ux7qq0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Uz6IW2FNV4ApExE0H60aD8KB5mmAvw/KutRETmXI8U=;
        b=lNO3jptjxCrxsxiDU9qKWYMNs6ZRU0psQFo/VIPniEbtQ9hN+G/fAhtQMSqBqqqYus
         ei7cCbxWMeiOdqV8DLdyNGlwkpCwhJDYqBIur0nYBk7J+W1YaBHODjOw3K+irjQ8ljIa
         HIsHs77pLsxmmYYKZIxATuO3dXN1d7Yn+VDnOkTCIDzx7QWvbsNsmmS6YYtStPjVayQe
         /qTw2LJtvGWP5AegNGitZbAYIJWToyfeNjs9H7X7VcbTkemN6g/KVWLrHrO9ATQaAcR3
         2RoW/8BxYl7Mg7veMi71nzVVG5zyiDPLLv8+MCKU7D92POaYT6ePwSdme56sptTP0QJB
         emzw==
X-Gm-Message-State: AOAM533IqiWxe/SmZ4pj2isL0tPGydN+pFtVwu5jYRhgQAKbjnJVtIpl
        wJ7N0psoMaHzQRwD4+9B41W8SawAQcN0C4zChuHuag==
X-Google-Smtp-Source: ABdhPJyo+fWeNQyvgtvPO5WnmmQMOt5TT3+wUhs5r+VmgHMpjOhIwYjtgG7kMM9w2eyaKl8sDlG09dTvSx1qOcxjouU=
X-Received: by 2002:ac2:4119:: with SMTP id b25mr10643138lfi.208.1591001461797;
 Mon, 01 Jun 2020 01:51:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAACQVJpbXSnf0Gc5HehFc6KzKjZU7dV5tY9cwR72pBhweVRkFw@mail.gmail.com>
 <20200525172602.GA14161@nanopsycho> <CAACQVJpRrOSn2eLzS1z9rmATrmzA2aNG-9pcbn-1E+sQJ5ET_g@mail.gmail.com>
 <20200526044727.GB14161@nanopsycho> <CAACQVJp8SfmP=R=YywDWC8njhA=ntEcs5o_KjBoHafPkHaj-iA@mail.gmail.com>
 <20200526134032.GD14161@nanopsycho> <CAACQVJrwFB4oHjTAw4DK28grxGGP15x52+NskjDtOYQdOUMbOg@mail.gmail.com>
 <CAACQVJqTc9s2KwUCEvGLfG3fh7kKj3-KmpeRgZMWM76S-474+w@mail.gmail.com>
 <20200527131401.2e269ab8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CACKFLi=+Q4CkOvaxQQm5Ya8+Ft=jNMwCAuK+=5SMxAfNGGriBw@mail.gmail.com> <20200601063918.GD2282@nanopsycho>
In-Reply-To: <20200601063918.GD2282@nanopsycho>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Mon, 1 Jun 2020 14:20:50 +0530
Message-ID: <CAACQVJqvEmvrFywLP+67W0vLVJqgtuynUxvtfrSbUc8_mHkCUQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset"
 generic device parameter.
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 12:09 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Wed, May 27, 2020 at 10:57:11PM CEST, michael.chan@broadcom.com wrote:
> >On Wed, May 27, 2020 at 1:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >>
> >> On Wed, 27 May 2020 09:07:09 +0530 Vasundhara Volam wrote:
> >> > Here is a sample sequence of commands to do a "live reset" to get some
> >> > clear idea.
> >> > Note that I am providing the examples based on the current patchset.
> >> >
> >> > 1. FW live reset is disabled in the device/adapter. Here adapter has 2
> >> > physical ports.
> >> >
> >> > $ devlink dev
> >> > pci/0000:3b:00.0
> >> > pci/0000:3b:00.1
> >> > pci/0000:af:00.0
> >> > $ devlink dev param show pci/0000:3b:00.0 name allow_fw_live_reset
> >> > pci/0000:3b:00.0:
> >> >   name allow_fw_live_reset type generic
> >> >     values:
> >> >       cmode runtime value false
> >> >       cmode permanent value false
> >> > $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
> >> > pci/0000:3b:00.1:
> >> >   name allow_fw_live_reset type generic
> >> >     values:
> >> >       cmode runtime value false
> >> >       cmode permanent value false
> >>
> >> What's the permanent value? What if after reboot the driver is too old
> >> to change this, is the reset still allowed?
> >
> >The permanent value should be the NVRAM value.  If the NVRAM value is
> >false, the feature is always and unconditionally disabled.  If the
> >permanent value is true, the feature will only be available when all
> >loaded drivers indicate support for it and set the runtime value to
> >true.  If an old driver is loaded afterwards, it wouldn't indicate
> >support for this feature and it wouldn't set the runtime value to
> >true.  So the feature will not be available until the old driver is
> >unloaded or upgraded.
> >
> >>
> >> > 2. If a user issues "ethtool --reset p1p1 all", the device cannot
> >> > perform "live reset" as capability is not enabled.
> >> >
> >> > User needs to do a driver reload, for firmware to undergo reset.
> >>
> >> Why does driver reload have anything to do with resetting a potentially
> >> MH device?
> >
> >I think she meant that all drivers have to be unloaded before the
> >reset would take place in case it's a MH device since live reset is
> >not supported.  If it's a single function device, unloading this
> >driver is sufficient.
> >
> >>
> >> > $ ethtool --reset p1p1 all
> >>
> >> Reset probably needs to be done via devlink. In any case you need a new
> >> reset level for resetting MH devices and smartnics, because the current
> >> reset mask covers port local, and host local cases, not any form of MH.
> >
> >RIght.  This reset could be just a single function reset in this example.
> >
> >>
> >> > ETHTOOL_RESET 0xffffffff
> >> > Components reset:     0xff0000
> >> > Components not reset: 0xff00ffff
> >> > $ dmesg
> >> > [  198.745822] bnxt_en 0000:3b:00.0 p1p1: Firmware reset request successful.
> >> > [  198.745836] bnxt_en 0000:3b:00.0 p1p1: Reload driver to complete reset
> >>
> >> You said the reset was not performed, yet there is no information to
> >> that effect in the log?!
> >
> >The firmware has been requested to reset, but the reset hasn't taken
> >place yet because live reset cannot be done.  We can make the logs
> >more clear.
> >
> >>
> >> > 3. Now enable the capability in the device and reboot for device to
> >> > enable the capability. Firmware does not get reset just by setting the
> >> > param to true.
> >> >
> >> > $ devlink dev param set pci/0000:3b:00.1 name allow_fw_live_reset
> >> > value true cmode permanent
> >> >
> >> > 4. After reboot, values of param.
> >>
> >> Is the reboot required here?
> >>
> >
> >In general, our new NVRAM permanent parameters will take effect after
> >reset (or reboot).
>
> Ah, you need a reboot. I was not expecting that :/ So the "devlink dev
> reload" attr would not work for you. MLNX hardware can change this on
> runtime.

NVRAM parameter configuration will take effect only on reboot or on
"live reset" (except few). But to enable "live reset", system needs a
reboot.
>
>
> >
> >> > $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
> >> > pci/0000:3b:00.1:
> >> >   name allow_fw_live_reset type generic
> >> >     values:
> >> >       cmode runtime value true
> >>
> >> Why is runtime value true now?
> >>
> >
> >If the permanent (NVRAM) parameter is true, all loaded new drivers
> >will indicate support for this feature and set the runtime value to
> >true by default.  The runtime value would not be true if any loaded
> >driver is too old or has set the runtime value to false.
>
> This is a bit odd. It is a configuration, not an indication. When you
> want to indicate what you support something, I think it should be done
> in a different place. I think that "devlink dev info" is the place to
> put it, I think that we need "capabilities" there.
>
Indication can be shown in 'devlink dev info', but users can configure
this parameter also to control the 'live reset' at runtime.
