Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B1423E5B7
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 04:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHGCJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 22:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgHGCJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 22:09:30 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E463DC061757
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 19:09:29 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id 93so487461otx.2
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 19:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UXDzWg/XP+2sEYoVhG4gJfqwuqtmZXkmnkeb5iVh2iE=;
        b=xRVx7pmJO/zgnmDPgxBODMiXXblNkdoeRjHXmhtFHUwUlpQxf7nYRXHHu9BNt2Hp8i
         76kWUw7L3zpb9iMmyjcw2br1Wju7Q6dwIe79tqy4yr4oK5wtgTOVMpUc2rECYHCYsu9I
         TcoaqnuUBgUEfeM+ZWZDU2CjurnWfmYp8IMnt/d7wNpSIf4mlqj1ZH8JVNvxvoHJ5a2p
         uBF5+ggJjW1IUrkPnyH4niRERLtxkTIXZrtk1JNFb26gxC0RlgWewBXO+y12ZwRtfzse
         mhLNykEUYuKZ/Iz2NnEH0KikWzaYpnbtc+3DPUt8pKC1/A5tDxdgt+lNq3/L4ucJgD23
         gpvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UXDzWg/XP+2sEYoVhG4gJfqwuqtmZXkmnkeb5iVh2iE=;
        b=M7XJYnWz6AwVPKxTtAs5xnM4UXsC4ff/cnRaXdzXIqdld2vtSBaD6nH+6egxUVW8/d
         y/MgxN6vjh62/Sq+v2qrNKIhTmmROnxUIUK6qYAyCMzwTiKbm7I/O1OjEHvn5yvRpCya
         EVZaHvNobDs9DeCmf2LP5ZB5/i2pYcHG/bWkuCAanajGF2p2WKedbs2ZDwNZtoyxQwa3
         Iyy3T8R7QuOwhe5+txzzG+ueXU2w7fH5c+6YrH9Id5QaJHMjhbtEOLhbhEQXOxlwM/nJ
         U6M9e81xzS1tNTTh1eck9zmOmJFYHVnTsv8n2v6kPzwBCb4w0u8SD4R/2ABlyYCOTQV2
         J8/Q==
X-Gm-Message-State: AOAM53196tgKkTRU1XbhrKS/9ITWgaE3SBkyrQ4Gt8o7EP2Y1mTY8faq
        XE3I/gapymMOurFFbBtHFFx2woFpBWh2CELoAIxErw==
X-Google-Smtp-Source: ABdhPJxpkfgvvlB6dJX/jSYtlNEZQF79RdUNfSy2KapZFTawN302cQpYn6luuDiz+1kWHSQ6VcY0la2Eq+7jSP4C/LY=
X-Received: by 2002:a9d:6f8f:: with SMTP id h15mr3718655otq.221.1596766168877;
 Thu, 06 Aug 2020 19:09:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200422203245.83244-1-john.stultz@linaro.org>
 <20200422203245.83244-2-john.stultz@linaro.org> <20200806135251.GB3351349@ulmo>
In-Reply-To: <20200806135251.GB3351349@ulmo>
From:   John Stultz <john.stultz@linaro.org>
Date:   Thu, 6 Aug 2020 19:09:16 -0700
Message-ID: <CALAqxLU=a+KXKya2FkgCuYyw5ttZJ_NXjNbszFzSjP49wMN84g@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] driver core: Revert default driver_deferred_probe_timeout
 value to 0
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Ferry Toth <fntoth@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>,
        netdev <netdev@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-tegra@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 6, 2020 at 6:52 AM Thierry Reding <thierry.reding@gmail.com> wrote:
>
> On Wed, Apr 22, 2020 at 08:32:43PM +0000, John Stultz wrote:
> > This patch addresses a regression in 5.7-rc1+
> >
> > In commit c8c43cee29f6 ("driver core: Fix
> > driver_deferred_probe_check_state() logic"), we both cleaned up
> > the logic and also set the default driver_deferred_probe_timeout
> > value to 30 seconds to allow for drivers that are missing
> > dependencies to have some time so that the dependency may be
> > loaded from userland after initcalls_done is set.
> >
> > However, Yoshihiro Shimoda reported that on his device that
> > expects to have unmet dependencies (due to "optional links" in
> > its devicetree), was failing to mount the NFS root.
> >
> > In digging further, it seemed the problem was that while the
> > device properly probes after waiting 30 seconds for any missing
> > modules to load, the ip_auto_config() had already failed,
> > resulting in NFS to fail. This was due to ip_auto_config()
> > calling wait_for_device_probe() which doesn't wait for the
> > driver_deferred_probe_timeout to fire.
> >
> > Fixing that issue is possible, but could also introduce 30
> > second delays in bootups for users who don't have any
> > missing dependencies, which is not ideal.
> >
> > So I think the best solution to avoid any regressions is to
> > revert back to a default timeout value of zero, and allow
> > systems that need to utilize the timeout in order for userland
> > to load any modules that supply misisng dependencies in the dts
> > to specify the timeout length via the exiting documented boot
> > argument.
> >
> > Thanks to Geert for chasing down that ip_auto_config was why NFS
> > was failing in this case!
> >
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> > Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> > Cc: Rob Herring <robh@kernel.org>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > Cc: Robin Murphy <robin.murphy@arm.com>
> > Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> > Cc: Sudeep Holla <sudeep.holla@arm.com>
> > Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
> > Cc: Basil Eljuse <Basil.Eljuse@arm.com>
> > Cc: Ferry Toth <fntoth@gmail.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Anders Roxell <anders.roxell@linaro.org>
> > Cc: netdev <netdev@vger.kernel.org>
> > Cc: linux-pm@vger.kernel.org
> > Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > Fixes: c8c43cee29f6 ("driver core: Fix driver_deferred_probe_check_state() logic")
> > Signed-off-by: John Stultz <john.stultz@linaro.org>
> > ---
> >  drivers/base/dd.c | 13 ++-----------
> >  1 file changed, 2 insertions(+), 11 deletions(-)
>
> Sorry for being a bit late to the party, but this breaks suspend/resume
> support on various Tegra devices. I've only noticed now because, well,
> suspend/resume have been broken for other reasons for a little while and
> it's taken us a bit to resolve those issues.
>
> But now that those other issues have been fixed, I've started seeing an
> issue where after resume from suspend some of the I2C controllers are no
> longer working. The reason for this is that they share pins with DP AUX
> controllers via the pinctrl framework. The DP AUX driver registers as
> part of the DRM/KMS driver, which usually happens in userspace. Since
> the deferred probe timeout was set to 0 by default this no longer works
> because no pinctrl states are assigned to the I2C controller and
> therefore upon resume the pins cannot be configured for I2C operation.

Oof. My apologies!

> I'm also somewhat confused by this patch and a few before because they
> claim that they restore previous default behaviour, but that's just not
> true. Originally when this timeout was introduced it was -1, which meant
> that there was no timeout at all and hence users had to opt-in if they
> wanted to use a deferred probe timeout.

I don't think that's quite true, since the point of my original
changes were to avoid troubles I was seeing with drivers not loading
because once the timeout fired after init, driver loading would fail
with ENODEV instead of returning EPROBE_DEFER. The logic that existed
was buggy so the timeout handling didn't really work (changing the
boot argument wouldn't help, because after init the logic would return
ENODEV before it checked the timeout value).

That said, looking at it now, I do realize the
driver_deferred_probe_check_state_continue() logic in effect never
returned ETIMEDOUT before was consolidated in the earlier changes, and
now we've backed the default timeout to 0, old user (see bec6c0ecb243)
will now get ETIMEDOUT where they wouldn't before.

So would the following fix it up for you? (sorry its whitespace corrupted)

diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index c6fe7d64c913..c7448be64d07 100644
--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -129,9 +129,8 @@ static int dt_to_map_one_config(struct pinctrl *p,
                if (!np_pctldev || of_node_is_root(np_pctldev)) {
                        of_node_put(np_pctldev);
                        ret = driver_deferred_probe_check_state(p->dev);
-                       /* keep deferring if modules are enabled
unless we've timed out */
-                       if (IS_ENABLED(CONFIG_MODULES) && !allow_default &&
-                           (ret == -ENODEV))
+                       /* keep deferring if modules are enabled */
+                       if (IS_ENABLED(CONFIG_MODULES) &&
!allow_default && ret < 0)
                                ret = -EPROBE_DEFER;
                        return ret;
                }

(you could probably argue calling driver_deferred_probe_check_state
checking ret at all is silly here, since EPROBE_DEFER is the only
option you want)

> But now after this series the default is for there to be a very short
> timeout, which in turn causes existing use-cases to potentially break.
> I'm also going to suggest here that in most cases a driver will require
> the resources that it asks for, so the case that Yoshihiro described and
> that this patch is meant to fix sounds to me like it's the odd one out
> rather than the other way around.
>
> But I realize that that's not very constructive. So perhaps we can find
> some other way for drivers to advertise that their dependencies are
> optional? I came up with the below patch, which restores suspend/resume
> on Tegra and could be used in conjunction with a patch that opts into
> this behaviour for the problematic driver in Yoshihiro's case to make
> this again work for everyone.
>
> --- >8 ---
> From a95f8f41b8a32dee3434db4f0515af7376d1873a Mon Sep 17 00:00:00 2001
> From: Thierry Reding <treding@nvidia.com>
> Date: Thu, 6 Aug 2020 14:51:59 +0200
> Subject: [PATCH] driver core: Do not ignore dependencies by default
>
> Many drivers do require the resources that they ask for and timing out
> may not always be an option. While there is a way to allow probing to
> continue to be deferred for some time after the system has booted, the
> fact that this is controlled via a command-line parameter is undesired
> because it require manual intervention, whereas in can be avoid in the
> majority of cases.
>
> Instead of requiring users to edit the kernel command-line, add a way
> for drivers to specify whether or not their dependencies are optional
> so that they can continue deferring probe indefinitely.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/base/dd.c             | 2 +-
>  include/linux/device/driver.h | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 857b0a928e8d..11e747070eae 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -279,7 +279,7 @@ int driver_deferred_probe_check_state(struct device *dev)
>                 return -ENODEV;
>         }
>
> -       if (!driver_deferred_probe_timeout && initcalls_done) {
> +       if (dev->driver->ignore_dependencies && !driver_deferred_probe_timeout && initcalls_done) {
>                 dev_warn(dev, "deferred probe timeout, ignoring dependency\n");
>                 return -ETIMEDOUT;
>         }
> diff --git a/include/linux/device/driver.h b/include/linux/device/driver.h
> index ee7ba5b5417e..6994455e8a2e 100644
> --- a/include/linux/device/driver.h
> +++ b/include/linux/device/driver.h
> @@ -100,6 +100,7 @@ struct device_driver {
>         const char              *mod_name;      /* used for built-in modules */
>
>         bool suppress_bind_attrs;       /* disables bind/unbind via sysfs */
> +       bool ignore_dependencies;       /* ignores dependencies */
>         enum probe_type probe_type;
>
>         const struct of_device_id       *of_match_table;
> --
> 2.27.0
> --- >8 ---
>
> Although, thinking about it a bit more it sounds to me like an even
> better approach would be to make this part of the API where a resource
> is requested. There are in fact already APIs that can request optional
> resources (such as regulator_get_optional()), so I think it would make
> more sense for any driver that can live without a resource to request
> it with an optional flag, which in turn could then trigger this code
> path for the deferred probe timeout. For anyone that really needs the
> resources that they request, they really shouldn't have to jump through
> hoops to get there.

I do like these suggestions. I feel like the optional dt links
handling is very opaque as there's no real way to tell if a dt link is
truly optional or not. Having the timeout is a really subtle and
implicit way of getting that optional link handling behavior.

thanks
-john
