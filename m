Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B402E1EA164
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 11:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgFAJ5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 05:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgFAJ5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 05:57:43 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFE9C03E96B
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 02:57:42 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id 202so3562355lfe.5
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 02:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n8mzCEnvJ5t5kVYRYLbiEJF4XC85iiaeMaH2b/vwgSI=;
        b=W1NowyxVUwCAKmbSPGr6jLv+naUSGpGLIHWEbsnZSgeNGlGBC1C0DBJx+uMWt2C7Me
         VMm/z1XqQFabYBfN8a60UqZYrvZ4GrXOg8S2QEYA83Aja3VXyFBVNu9DoJlszZ9Nhys2
         zIUsvVTgZNjlpZYs4Y3pGw4KBrIPC2Qjt3fys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n8mzCEnvJ5t5kVYRYLbiEJF4XC85iiaeMaH2b/vwgSI=;
        b=J6ExaOeYJnR3epL+fxytR9wmwEVcl1ZTjGJTSY4JTuJ47lt5Dz206KtflMyWJmoeiA
         rMwY7x2p5iTVfdBODc47ogIS9Kl8GINOO8fq3GXsPyjY6NZR3b6+4+q5r5Ib3lr/i6pG
         yDHoTR1AaZvrYAgJiu+N2AuftTII20sXrcwAevEDxGKDXSORvOTaj01Zrjusdwc0IpIf
         e81y29vCCsOH1hL5Z4fTheIUMSaxTCK+uUuMQK58O5TSU7ZUxuSZHdYYkKF2uf3S/UwP
         BTX/rLsMFR+BjO5rcqdb6unM11Z1RoqX5WrXyjQgy4npN2FvkYbBhWEqWckhGYJZN4+d
         PRdQ==
X-Gm-Message-State: AOAM531Tl3LG6HchnlacSkCqxUcwxWeaBKTrY610pQD50EUgHQijOizY
        ACG1+TSCiZA6F8AclmGXOEKH5022wX1eNL+vitlUxGEL
X-Google-Smtp-Source: ABdhPJyEIAyBgycr1Gd8UDwNorjRiL42O2JQCrGifz+MhEx64vHAi6DUTecoPu2sTD0LTw4DMt6RQPSAX3qx+awRAfY=
X-Received: by 2002:ac2:5cac:: with SMTP id e12mr10980333lfq.92.1591005460672;
 Mon, 01 Jun 2020 02:57:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAACQVJpRrOSn2eLzS1z9rmATrmzA2aNG-9pcbn-1E+sQJ5ET_g@mail.gmail.com>
 <20200526044727.GB14161@nanopsycho> <CAACQVJp8SfmP=R=YywDWC8njhA=ntEcs5o_KjBoHafPkHaj-iA@mail.gmail.com>
 <20200526134032.GD14161@nanopsycho> <CAACQVJrwFB4oHjTAw4DK28grxGGP15x52+NskjDtOYQdOUMbOg@mail.gmail.com>
 <CAACQVJqTc9s2KwUCEvGLfG3fh7kKj3-KmpeRgZMWM76S-474+w@mail.gmail.com>
 <20200527131401.2e269ab8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CACKFLi=+Q4CkOvaxQQm5Ya8+Ft=jNMwCAuK+=5SMxAfNGGriBw@mail.gmail.com>
 <20200601063918.GD2282@nanopsycho> <CAACQVJqvEmvrFywLP+67W0vLVJqgtuynUxvtfrSbUc8_mHkCUQ@mail.gmail.com>
 <20200601094935.GH2282@nanopsycho>
In-Reply-To: <20200601094935.GH2282@nanopsycho>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Mon, 1 Jun 2020 15:27:28 +0530
Message-ID: <CAACQVJrhEoi__t+HtC1sx0SJF50QmiF8CqbyexEjFhi=Jnqt1w@mail.gmail.com>
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

On Mon, Jun 1, 2020 at 3:19 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Mon, Jun 01, 2020 at 10:50:50AM CEST, vasundhara-v.volam@broadcom.com wrote:
> >On Mon, Jun 1, 2020 at 12:09 PM Jiri Pirko <jiri@resnulli.us> wrote:
> >>
> >> Wed, May 27, 2020 at 10:57:11PM CEST, michael.chan@broadcom.com wrote:
> >> >On Wed, May 27, 2020 at 1:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >> >>
> >> >> On Wed, 27 May 2020 09:07:09 +0530 Vasundhara Volam wrote:
> >> >> > Here is a sample sequence of commands to do a "live reset" to get some
> >> >> > clear idea.
> >> >> > Note that I am providing the examples based on the current patchset.
> >> >> >
> >> >> > 1. FW live reset is disabled in the device/adapter. Here adapter has 2
> >> >> > physical ports.
> >> >> >
> >> >> > $ devlink dev
> >> >> > pci/0000:3b:00.0
> >> >> > pci/0000:3b:00.1
> >> >> > pci/0000:af:00.0
> >> >> > $ devlink dev param show pci/0000:3b:00.0 name allow_fw_live_reset
> >> >> > pci/0000:3b:00.0:
> >> >> >   name allow_fw_live_reset type generic
> >> >> >     values:
> >> >> >       cmode runtime value false
> >> >> >       cmode permanent value false
> >> >> > $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
> >> >> > pci/0000:3b:00.1:
> >> >> >   name allow_fw_live_reset type generic
> >> >> >     values:
> >> >> >       cmode runtime value false
> >> >> >       cmode permanent value false
> >> >>
> >> >> What's the permanent value? What if after reboot the driver is too old
> >> >> to change this, is the reset still allowed?
> >> >
> >> >The permanent value should be the NVRAM value.  If the NVRAM value is
> >> >false, the feature is always and unconditionally disabled.  If the
> >> >permanent value is true, the feature will only be available when all
> >> >loaded drivers indicate support for it and set the runtime value to
> >> >true.  If an old driver is loaded afterwards, it wouldn't indicate
> >> >support for this feature and it wouldn't set the runtime value to
> >> >true.  So the feature will not be available until the old driver is
> >> >unloaded or upgraded.
> >> >
> >> >>
> >> >> > 2. If a user issues "ethtool --reset p1p1 all", the device cannot
> >> >> > perform "live reset" as capability is not enabled.
> >> >> >
> >> >> > User needs to do a driver reload, for firmware to undergo reset.
> >> >>
> >> >> Why does driver reload have anything to do with resetting a potentially
> >> >> MH device?
> >> >
> >> >I think she meant that all drivers have to be unloaded before the
> >> >reset would take place in case it's a MH device since live reset is
> >> >not supported.  If it's a single function device, unloading this
> >> >driver is sufficient.
> >> >
> >> >>
> >> >> > $ ethtool --reset p1p1 all
> >> >>
> >> >> Reset probably needs to be done via devlink. In any case you need a new
> >> >> reset level for resetting MH devices and smartnics, because the current
> >> >> reset mask covers port local, and host local cases, not any form of MH.
> >> >
> >> >RIght.  This reset could be just a single function reset in this example.
> >> >
> >> >>
> >> >> > ETHTOOL_RESET 0xffffffff
> >> >> > Components reset:     0xff0000
> >> >> > Components not reset: 0xff00ffff
> >> >> > $ dmesg
> >> >> > [  198.745822] bnxt_en 0000:3b:00.0 p1p1: Firmware reset request successful.
> >> >> > [  198.745836] bnxt_en 0000:3b:00.0 p1p1: Reload driver to complete reset
> >> >>
> >> >> You said the reset was not performed, yet there is no information to
> >> >> that effect in the log?!
> >> >
> >> >The firmware has been requested to reset, but the reset hasn't taken
> >> >place yet because live reset cannot be done.  We can make the logs
> >> >more clear.
> >> >
> >> >>
> >> >> > 3. Now enable the capability in the device and reboot for device to
> >> >> > enable the capability. Firmware does not get reset just by setting the
> >> >> > param to true.
> >> >> >
> >> >> > $ devlink dev param set pci/0000:3b:00.1 name allow_fw_live_reset
> >> >> > value true cmode permanent
> >> >> >
> >> >> > 4. After reboot, values of param.
> >> >>
> >> >> Is the reboot required here?
> >> >>
> >> >
> >> >In general, our new NVRAM permanent parameters will take effect after
> >> >reset (or reboot).
> >>
> >> Ah, you need a reboot. I was not expecting that :/ So the "devlink dev
> >> reload" attr would not work for you. MLNX hardware can change this on
> >> runtime.
> >
> >NVRAM parameter configuration will take effect only on reboot or on
> >"live reset" (except few). But to enable "live reset", system needs a
> >reboot.
> >>
> >>
> >> >
> >> >> > $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
> >> >> > pci/0000:3b:00.1:
> >> >> >   name allow_fw_live_reset type generic
> >> >> >     values:
> >> >> >       cmode runtime value true
> >> >>
> >> >> Why is runtime value true now?
> >> >>
> >> >
> >> >If the permanent (NVRAM) parameter is true, all loaded new drivers
> >> >will indicate support for this feature and set the runtime value to
> >> >true by default.  The runtime value would not be true if any loaded
> >> >driver is too old or has set the runtime value to false.
> >>
> >> This is a bit odd. It is a configuration, not an indication. When you
> >> want to indicate what you support something, I think it should be done
> >> in a different place. I think that "devlink dev info" is the place to
> >> put it, I think that we need "capabilities" there.
> >>
> >Indication can be shown in 'devlink dev info', but users can configure
> >this parameter also to control the 'live reset' at runtime.
>
> I'm totally confused. You wrote above that you need reboot (cmode
> permanent) for that. What is the usecase for cmode runtime?
>

Okay let me brief it completely, probably some repetition.

Permanent cmode, is to enable the "live reset" feature in the device,
which takes effect after reboot, as it is configuration the parameter
in NVRAM configuration. After reboot, if the parameter is enabled,
user can initiate the live reset from a separate command.

Runtime cmode, default value is true and available only when permanent
cmode is true. This allows the user to temporarily disallow the "live
reset", if the host is running any mission critical application.

Thanks.
