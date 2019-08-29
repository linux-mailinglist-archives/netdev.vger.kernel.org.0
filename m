Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD7E0A1528
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 11:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfH2JvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 05:51:04 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36416 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfH2JvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 05:51:04 -0400
Received: by mail-wr1-f68.google.com with SMTP id y19so2760647wrd.3
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 02:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QpWY7e5HA7D/+8ZJsDVBlHpT/6GIeAsAxtRUNzDzcSE=;
        b=cXcxxBTVIk7eLydhgcft8pgMip4aYKEcyi8SiJzuzGlPVYp0QMJBC6ieBdQRSN8IFo
         yGD5Q+D02QFGpsaK4iMK7dMs6MbSYG4gjb4pQZ08BIfTTaLMvzoEDBPl8ckOQDe+lG0x
         vtBYc7H/M9CcgfT5ldxd3a82X16+H0Or+iSRPscWoZ/LuHBgOandGh0QiKul5X1jfUwC
         46Xrrosf9jiMNaPKUan72OOc3X4JtULkwIZLTQHsI8Dis7SDE5nkLNlu6gt5VNFwkJG3
         yKSxXvhgfalOI8R4ocMDQ6NBLn47k+HWafTG5tN5aTcEHUhDWcqDW68ozc7wiYzARF6e
         51oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QpWY7e5HA7D/+8ZJsDVBlHpT/6GIeAsAxtRUNzDzcSE=;
        b=GlYCgOnyLyEwKiBXYX7DXWa+4swyPgkc+Pr7ogQpYM+13y3akfOdqQQAjfFZKihZjA
         R5KRhy6vc1twZKTccvCR9cD7W7P5cZon0K2B3LCrbrNkyaSvng502iYNPV8+M0pHKhPz
         6n5/3/HZoCfp4UIMwMEC35k0yoVanrz2u+JMyFIcnIIrLnwo+ReTRcZHwXr/kbgXhxmo
         NAEP0oP52Xlo7y2MO6T0AMHhyLI+bjo8DdFY98gFbECMkL6q8XbMhTdiB8uKxhjRUyCY
         KJMTW+q+WGF4jqFbM+o5PWx23nikybLDnqg+uj7f6T2c5xXzYYQPAHFcX2+hWZkwt55v
         Y7xg==
X-Gm-Message-State: APjAAAWJa5IbGw2xT4GBfmNQFghF5ZeSFtSbkrDNkS+TnYX7KZ48zRD5
        hzTxjvvscQnSiK3ghsuBX053sA==
X-Google-Smtp-Source: APXvYqxL6jG6QBSSyhTL7CBwnilVDkqWY5B33svIqaWC8sMhj1IrifAWVl9tzmM/DENruIJtNT1Pjg==
X-Received: by 2002:adf:f812:: with SMTP id s18mr10970097wrp.32.1567072261456;
        Thu, 29 Aug 2019 02:51:01 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id w8sm13161464wmc.1.2019.08.29.02.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 02:51:01 -0700 (PDT)
Date:   Thu, 29 Aug 2019 11:51:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, andrew@lunn.ch, allan.nielsen@microchip.com,
        ivecera@redhat.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190829095100.GH2312@nanopsycho>
References: <1567070549-29255-1-git-send-email-horatiu.vultur@microchip.com>
 <1567070549-29255-2-git-send-email-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567070549-29255-2-git-send-email-horatiu.vultur@microchip.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Aug 29, 2019 at 11:22:28AM CEST, horatiu.vultur@microchip.com wrote:
>Add the SWITCHDEV_ATTR_ID_PORT_PROMISCUITY switchdev notification type,
>used to indicate whenever the dev promiscuity counter is changed.
>
>The notification doesn't use any switchdev_attr attribute because in the
>notifier callbacks is it possible to get the dev and read directly
>the promiscuity value.
>
>Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
>---
> include/net/switchdev.h | 1 +
> net/core/dev.c          | 9 +++++++++
> 2 files changed, 10 insertions(+)
>
>diff --git a/include/net/switchdev.h b/include/net/switchdev.h
>index aee86a1..14b1617 100644
>--- a/include/net/switchdev.h
>+++ b/include/net/switchdev.h
>@@ -40,6 +40,7 @@ enum switchdev_attr_id {
> 	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING,
> 	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
> 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
>+	SWITCHDEV_ATTR_ID_PORT_PROMISCUITY,
> };
> 
> struct switchdev_attr {
>diff --git a/net/core/dev.c b/net/core/dev.c
>index 49589ed..40c74f2 100644
>--- a/net/core/dev.c
>+++ b/net/core/dev.c
>@@ -142,6 +142,7 @@
> #include <linux/net_namespace.h>
> #include <linux/indirect_call_wrapper.h>
> #include <net/devlink.h>
>+#include <net/switchdev.h>
> 
> #include "net-sysfs.h"
> 
>@@ -7377,6 +7378,11 @@ static void dev_change_rx_flags(struct net_device *dev, int flags)
> static int __dev_set_promiscuity(struct net_device *dev, int inc, bool notify)
> {
> 	unsigned int old_flags = dev->flags;
>+	struct switchdev_attr attr = {
>+		.orig_dev = dev,
>+		.id = SWITCHDEV_ATTR_ID_PORT_PROMISCUITY,
>+		.flags = SWITCHDEV_F_DEFER,

NACK

This is invalid usecase for switchdev infra. Switchdev is there for
bridge offload purposes only.

For promiscuity changes, the infrastructure is already present in the
code. See __dev_notify_flags(). it calls:
call_netdevice_notifiers_info(NETDEV_CHANGE, &change_info.info)
and you can actually see the changed flag in ".flags_changed".

You just have to register netdev notifier block in your driver. Grep
for: register_netdevice_notifier


>+	};
> 	kuid_t uid;
> 	kgid_t gid;
> 
>@@ -7419,6 +7425,9 @@ static int __dev_set_promiscuity(struct net_device *dev, int inc, bool notify)
> 	}
> 	if (notify)
> 		__dev_notify_flags(dev, old_flags, IFF_PROMISC);
>+
>+	switchdev_port_attr_set(dev, &attr);
>+
> 	return 0;
> }
> 
>-- 
>2.7.4
>
