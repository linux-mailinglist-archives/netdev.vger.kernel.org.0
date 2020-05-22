Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC6B1DDF3D
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 07:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgEVFUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 01:20:50 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36558 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgEVFUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 01:20:49 -0400
Received: by mail-pf1-f193.google.com with SMTP id e11so3738141pfn.3;
        Thu, 21 May 2020 22:20:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XV4g1eLH5eU7HQYN5ExRZo8EC66pHuJWFUL/99/5lUQ=;
        b=gFbQMEjRb7A24eeSJRIuIVrRw4JUzk3SvHJVe3WKu/NK4nYIE7JPs0nHHHcUM/2cx2
         F1yCFskosT0QQE4/oo9eb+nphQSUMlVrqgL3uwUfCDY0KOcdDiW9PactfsYrKnmmyyBU
         hooJ68XUAdCfaVzrjy6IGB/ysC+4UaNvIeXiNDECLBcyNyiUjOqvn83eYsVXb0QZOhW4
         T7jqDbPMHyOmdSfKrO6JgvFThHiEE+1nr6sfFxVq6uSUdKmZ2RJrWGxJYZZJ+sst7SJ1
         ZipKwYemU3L7zuQYyicPErRhUbYvMU81k04Hn7nn+nHf/XhTJvaKnLqBrSrebR64LRFN
         tlsg==
X-Gm-Message-State: AOAM531JJIwq+xjviidwlz0rzcOGZ/b6ufo1I5L8U6qtUJCxpVqQb3DQ
        YDb/pvJlreTvu2tIAAiCiDs=
X-Google-Smtp-Source: ABdhPJzQMULwCgw2xtMvegjYDudMSTpjW6Ghu7LwHLqK8H2+SLu0p3ctbuD5WXVwcIhChmgssYsjgQ==
X-Received: by 2002:a63:d318:: with SMTP id b24mr11236491pgg.403.1590124848774;
        Thu, 21 May 2020 22:20:48 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id d126sm5897716pfc.81.2020.05.21.22.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 22:20:47 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 929FA4088B; Fri, 22 May 2020 05:20:46 +0000 (UTC)
Date:   Fri, 22 May 2020 05:20:46 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     johannes@sipsolutions.net, derosier@gmail.com,
        greearb@candelatech.com, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, jiri@resnulli.us,
        briannorris@chromium.org
Subject: Re: [RFC 1/2] devlink: add simple fw crash helpers
Message-ID: <20200522052046.GY11244@42.do-not-panic.com>
References: <20200519010530.GS11244@42.do-not-panic.com>
 <20200519211531.3702593-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519211531.3702593-1-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 02:15:30PM -0700, Jakub Kicinski wrote:
> Add infra for creating devlink instances for a device to report

Thanks for doing this series as a PoC, counter to the module_firmware_crash()
which I proposed to taint the kernel with a firmware crash flag to the kernel
and module.

For those not famliar about devlink:

https://lwn.net/Articles/677967/
https://www.kernel.org/doc/html/latest/networking/devlink/index.html

The github page also is now 404 as Jiri merged that stuff into iproute2:

git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

> fw crashes. This patch expects the devlink instance to be registered
> at probe time. I belive to be the cleanest. We can also add a devm
> version of the helpers, so that we don't have to do the clean up.
> Or we can go even further and register the devlink instance only
> once error has happened (for the first time, then we can just
> find out if already registered by traversing the list like we
> do here).
> 
> With the patch applied and a sample driver converted we get:
> 
> $ devlink dev
> pci/0000:07:00.0
> 
> Then monitor for errors:
> 
> $ devlink mon health
> [health,status] pci/0000:07:00.0:
>   reporter fw
>     state error error 1 recover 0
> [health,status] pci/0000:07:00.0:
>   reporter fw
>     state error error 2 recover 0
> 
> These are the events I triggered on purpose. One can also inspect
> the health of all devices capable of reporting fw errors:
> 
> $ devlink health
> pci/0000:07:00.0:
>   reporter fw
>     state error error 7 recover 0
> 
> Obviously drivers may upgrade to the full devlink health API
> which includes state dump, state dump auto-collect and automatic
> error recovery control.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/linux/devlink.h               |  11 +++
>  net/core/Makefile                     |   2 +-
>  net/core/devlink_simple_fw_reporter.c | 101 ++++++++++++++++++++++++++
>  3 files changed, 113 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/devlink.h
>  create mode 100644 net/core/devlink_simple_fw_reporter.c
> 
> diff --git a/include/linux/devlink.h b/include/linux/devlink.h
> new file mode 100644
> index 000000000000..2b73987eefca
> --- /dev/null
> +++ b/include/linux/devlink.h
> @@ -0,0 +1,11 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#ifndef _LINUX_DEVLINK_H_
> +#define _LINUX_DEVLINK_H_
> +
> +struct device;
> +
> +void devlink_simple_fw_reporter_prepare(struct device *dev);
> +void devlink_simple_fw_reporter_cleanup(struct device *dev);
> +void devlink_simple_fw_reporter_report_crash(struct device *dev);
> +
> +#endif
> diff --git a/net/core/Makefile b/net/core/Makefile
> index 3e2c378e5f31..6f1513781c17 100644
> --- a/net/core/Makefile
> +++ b/net/core/Makefile
> @@ -31,7 +31,7 @@ obj-$(CONFIG_LWTUNNEL_BPF) += lwt_bpf.o
>  obj-$(CONFIG_BPF_STREAM_PARSER) += sock_map.o
>  obj-$(CONFIG_DST_CACHE) += dst_cache.o
>  obj-$(CONFIG_HWBM) += hwbm.o
> -obj-$(CONFIG_NET_DEVLINK) += devlink.o
> +obj-$(CONFIG_NET_DEVLINK) += devlink.o devlink_simple_fw_reporter.o

This was looking super sexy up to here. This is networking specific.
We want something generic for *anything* that requests firmware.

I'm afraid this won't work for something generic. I don't think its
throw-away work though, the idea to provide a generic interface to
dump firmware through netlink might be nice for networking, or other
things.

But I have a feeling we'll want something still more generic than this.

So networking may want to be aware that a firmware crash happened as
part of this network device health thing, but firmware crashing is a
generic thing.

I have now extended my patch set to include uvents and I am more set on
that we need the taint now more than ever.

  Luis

>  obj-$(CONFIG_GRO_CELLS) += gro_cells.o
>  obj-$(CONFIG_FAILOVER) += failover.o
>  obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
> diff --git a/net/core/devlink_simple_fw_reporter.c b/net/core/devlink_simple_fw_reporter.c
> new file mode 100644
> index 000000000000..48dde9123c3c
> --- /dev/null
> +++ b/net/core/devlink_simple_fw_reporter.c
> @@ -0,0 +1,101 @@
> +#include <linux/devlink.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <net/devlink.h>
> +
> +struct devlink_simple_fw_reporter {
> +	struct list_head list;
> +	struct devlink_health_reporter *reporter;
> +};
> +
> +
> +static LIST_HEAD(devlink_simple_fw_reporters);
> +static DEFINE_MUTEX(devlink_simple_fw_reporters_mutex);
> +
> +static const struct devlink_health_reporter_ops simple_devlink_health = {
> +	.name = "fw",
> +};
> +
> +static const struct devlink_ops simple_devlink_ops = {
> +};
> +
> +static struct devlink_simple_fw_reporter *
> +devlink_simple_fw_reporter_find_for_dev(struct device *dev)
> +{
> +	struct devlink_simple_fw_reporter *simple_devlink, *ret = NULL;
> +	struct devlink *devlink;
> +
> +	mutex_lock(&devlink_simple_fw_reporters_mutex);
> +	list_for_each_entry(simple_devlink, &devlink_simple_fw_reporters,
> +			    list) {
> +		devlink = priv_to_devlink(simple_devlink);
> +		if (devlink->dev == dev) {
> +			ret = simple_devlink;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&devlink_simple_fw_reporters_mutex);
> +
> +	return ret;
> +}
> +
> +void devlink_simple_fw_reporter_report_crash(struct device *dev)
> +{
> +	struct devlink_simple_fw_reporter *simple_devlink;
> +
> +	simple_devlink = devlink_simple_fw_reporter_find_for_dev(dev);
> +	if (!simple_devlink)
> +		return;
> +
> +	devlink_health_report(simple_devlink->reporter, "firmware crash", NULL);
> +}
> +EXPORT_SYMBOL_GPL(devlink_simple_fw_reporter_report_crash);
> +
> +void devlink_simple_fw_reporter_prepare(struct device *dev)
> +{
> +	struct devlink_simple_fw_reporter *simple_devlink;
> +	struct devlink *devlink;
> +
> +	devlink = devlink_alloc(&simple_devlink_ops,
> +				sizeof(struct devlink_simple_fw_reporter));
> +	if (!devlink)
> +		return;
> +
> +	if (devlink_register(devlink, dev))
> +		goto err_free;
> +
> +	simple_devlink = devlink_priv(devlink);
> +	simple_devlink->reporter =
> +		devlink_health_reporter_create(devlink, &simple_devlink_health,
> +					       0, NULL);
> +	if (IS_ERR(simple_devlink->reporter))
> +		goto err_unregister;
> +
> +	mutex_lock(&devlink_simple_fw_reporters_mutex);
> +	list_add_tail(&simple_devlink->list, &devlink_simple_fw_reporters);
> +	mutex_unlock(&devlink_simple_fw_reporters_mutex);
> +
> +	return;
> +
> +err_unregister:
> +	devlink_unregister(devlink);
> +err_free:
> +	devlink_free(devlink);
> +}
> +EXPORT_SYMBOL_GPL(devlink_simple_fw_reporter_prepare);
> +
> +void devlink_simple_fw_reporter_cleanup(struct device *dev)
> +{
> +	struct devlink_simple_fw_reporter *simple_devlink;
> +	struct devlink *devlink;
> +
> +	simple_devlink = devlink_simple_fw_reporter_find_for_dev(dev);
> +	if (!simple_devlink)
> +		return;
> +
> +	devlink = priv_to_devlink(simple_devlink);
> +	devlink_health_reporter_destroy(simple_devlink->reporter);
> +	devlink_unregister(devlink);
> +	devlink_free(devlink);
> +}
> +EXPORT_SYMBOL_GPL(devlink_simple_fw_reporter_cleanup);
> -- 
> 2.25.4
> 
