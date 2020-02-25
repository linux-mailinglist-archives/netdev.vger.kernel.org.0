Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 679F716EB09
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 17:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730573AbgBYQNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 11:13:24 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35462 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729189AbgBYQNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 11:13:24 -0500
Received: by mail-ot1-f67.google.com with SMTP id r16so50324otd.2;
        Tue, 25 Feb 2020 08:13:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VL+DlyeyetOp4hj4Wd5H2StakcvzqSai3gD2cxZNaVU=;
        b=TCJFthGcpQjUV/t0A1xP4NxNmzxtaPk8RQ9L0c7x7ukdLOADNc4qsmFQrs3s1cmoF8
         12OJSRL5wKhACXCm27oGkuuYuW7pO9CAg5YbTrV7Vei+8vsE0t4TuP1G0LmpPC9VTaip
         w5j0I5h/f15lY1x+pA/NDnOrH26xHCVTAZJ/kx21em7dlwQt2iS8k/IbfYGGvwTfCXse
         R3zQYnBAD8W47X7+04bYE3DzPXpddDYSdUsmwuQvcZwTvtEdmtM3ew2rNtqsgVY/mx1M
         Kcbdu3XfjKovb6hlbilsLbL8M5YdCd+KOxDlAnRvhHsPAPSjgm5/0yhnrHk4qvaqLlyb
         oWWQ==
X-Gm-Message-State: APjAAAW7ljdwiaM5XkKnXBJ86E0jKvTp2+SvMU9QbCSl1TJJgRiC9XFu
        sIYuvWsTI40kP9k57U7gE1bIQDY8Ci/PWouK5HA=
X-Google-Smtp-Source: APXvYqy63J+4B+eRAxGKURNWKgaKqO36eFLFSszHvTNIVZUAJvPu1RoqON1pZkTd0zEjWOHRd5HvC3NhPplF8VrLqMI=
X-Received: by 2002:a9d:7653:: with SMTP id o19mr43546746otl.118.1582647202902;
 Tue, 25 Feb 2020 08:13:22 -0800 (PST)
MIME-Version: 1.0
References: <20200225131938.120447-1-christian.brauner@ubuntu.com> <20200225131938.120447-7-christian.brauner@ubuntu.com>
In-Reply-To: <20200225131938.120447-7-christian.brauner@ubuntu.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 25 Feb 2020 17:13:11 +0100
Message-ID: <CAJZ5v0ip8Z78_tOrDB+dR_t+V6YfKi6qY14nr6j6fW=zPu99wQ@mail.gmail.com>
Subject: Re: [PATCH v6 6/9] drivers/base/power: add dpm_sysfs_change_owner()
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Linux PM <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 2:22 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> Add a helper to change the owner of a device's power entries. This
> needs to happen when the ownership of a device is changed, e.g. when
> moving network devices between network namespaces.
> This function will be used to correctly account for ownership changes,
> e.g. when moving network devices between network namespaces.
>
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>

Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
> /* v2 */
> - "Rafael J. Wysocki" <rafael@kernel.org>:
>   -  Fold if (dev->power.wakeup && dev->power.wakeup->dev) check into
>      if (device_can_wakeup(dev)) check since the former can never be true if
>      the latter is false.
>
> - Christian Brauner <christian.brauner@ubuntu.com>:
>   - Place (dev->power.wakeup && dev->power.wakeup->dev) check under
>     CONFIG_PM_SLEEP ifdefine since it will wakeup_source will only be available
>     when this config option is set.
>
> /* v3 */
> -  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>    - Add explicit uid/gid parameters.
>
> /* v4 */
> - "Rafael J. Wysocki" <rafael@kernel.org>:
>    - Remove in-function #ifdef in favor of separate helper that is a nop
>      whenver !CONFIG_PM_SLEEP.
>
> /* v5 */
> - "Rafael J. Wysocki" <rafael@kernel.org>:
>    - Return directly if condition is true in dpm_sysfs_wakeup_change_owner()
>      instead of using additional variable.
>
> /* v6 */
> - Christian Brauner <christian.brauner@ubuntu.com>:
>   - Make dpm_sysfs_wakeup_change_owner() static inline.
> ---
>  drivers/base/core.c        |  4 +++
>  drivers/base/power/power.h |  3 +++
>  drivers/base/power/sysfs.c | 55 +++++++++++++++++++++++++++++++++++++-
>  3 files changed, 61 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 988f34ce2eb0..fb8b7990f6fd 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -3552,6 +3552,10 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
>         if (error)
>                 goto out;
>
> +       error = dpm_sysfs_change_owner(dev, kuid, kgid);
> +       if (error)
> +               goto out;
> +
>  #ifdef CONFIG_BLOCK
>         if (sysfs_deprecated && dev->class == &block_class)
>                 goto out;
> diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
> index 444f5c169a0b..54292cdd7808 100644
> --- a/drivers/base/power/power.h
> +++ b/drivers/base/power/power.h
> @@ -74,6 +74,7 @@ extern int pm_qos_sysfs_add_flags(struct device *dev);
>  extern void pm_qos_sysfs_remove_flags(struct device *dev);
>  extern int pm_qos_sysfs_add_latency_tolerance(struct device *dev);
>  extern void pm_qos_sysfs_remove_latency_tolerance(struct device *dev);
> +extern int dpm_sysfs_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid);
>
>  #else /* CONFIG_PM */
>
> @@ -88,6 +89,8 @@ static inline void pm_runtime_remove(struct device *dev) {}
>
>  static inline int dpm_sysfs_add(struct device *dev) { return 0; }
>  static inline void dpm_sysfs_remove(struct device *dev) {}
> +static inline int dpm_sysfs_change_owner(struct device *dev, kuid_t kuid,
> +                                        kgid_t kgid) { return 0; }
>
>  #endif
>
> diff --git a/drivers/base/power/sysfs.c b/drivers/base/power/sysfs.c
> index d7d82db2e4bc..2b99fe1eb207 100644
> --- a/drivers/base/power/sysfs.c
> +++ b/drivers/base/power/sysfs.c
> @@ -480,6 +480,14 @@ static ssize_t wakeup_last_time_ms_show(struct device *dev,
>         return enabled ? sprintf(buf, "%lld\n", msec) : sprintf(buf, "\n");
>  }
>
> +static inline int dpm_sysfs_wakeup_change_owner(struct device *dev, kuid_t kuid,
> +                                               kgid_t kgid)
> +{
> +       if (dev->power.wakeup && dev->power.wakeup->dev)
> +               return device_change_owner(dev->power.wakeup->dev, kuid, kgid);
> +       return 0;
> +}
> +
>  static DEVICE_ATTR_RO(wakeup_last_time_ms);
>
>  #ifdef CONFIG_PM_AUTOSLEEP
> @@ -501,7 +509,13 @@ static ssize_t wakeup_prevent_sleep_time_ms_show(struct device *dev,
>
>  static DEVICE_ATTR_RO(wakeup_prevent_sleep_time_ms);
>  #endif /* CONFIG_PM_AUTOSLEEP */
> -#endif /* CONFIG_PM_SLEEP */
> +#else /* CONFIG_PM_SLEEP */
> +static inline int dpm_sysfs_wakeup_change_owner(struct device *dev, kuid_t kuid,
> +                                               kgid_t kgid)
> +{
> +       return 0;
> +}
> +#endif
>
>  #ifdef CONFIG_PM_ADVANCED_DEBUG
>  static ssize_t runtime_usage_show(struct device *dev,
> @@ -684,6 +698,45 @@ int dpm_sysfs_add(struct device *dev)
>         return rc;
>  }
>
> +int dpm_sysfs_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
> +{
> +       int rc;
> +
> +       if (device_pm_not_required(dev))
> +               return 0;
> +
> +       rc = sysfs_group_change_owner(&dev->kobj, &pm_attr_group, kuid, kgid);
> +       if (rc)
> +               return rc;
> +
> +       if (pm_runtime_callbacks_present(dev)) {
> +               rc = sysfs_group_change_owner(
> +                       &dev->kobj, &pm_runtime_attr_group, kuid, kgid);
> +               if (rc)
> +                       return rc;
> +       }
> +
> +       if (device_can_wakeup(dev)) {
> +               rc = sysfs_group_change_owner(&dev->kobj, &pm_wakeup_attr_group,
> +                                             kuid, kgid);
> +               if (rc)
> +                       return rc;
> +
> +               rc = dpm_sysfs_wakeup_change_owner(dev, kuid, kgid);
> +               if (rc)
> +                       return rc;
> +       }
> +
> +       if (dev->power.set_latency_tolerance) {
> +               rc = sysfs_group_change_owner(
> +                       &dev->kobj, &pm_qos_latency_tolerance_attr_group, kuid,
> +                       kgid);
> +               if (rc)
> +                       return rc;
> +       }
> +       return 0;
> +}
> +
>  int wakeup_sysfs_add(struct device *dev)
>  {
>         return sysfs_merge_group(&dev->kobj, &pm_wakeup_attr_group);
> --
> 2.25.1
>
