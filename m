Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F22F670E61
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 01:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjARAFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 19:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjARAE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 19:04:59 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1234B46731;
        Tue, 17 Jan 2023 15:17:55 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id vw16so16006182ejc.12;
        Tue, 17 Jan 2023 15:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wzoFsN2BtIwkV7J9p1OybyavGXclmQ9kcPW4uj8vI+4=;
        b=WHkz1zPwXkTNrAiIJUYxeLo3UGJReyuX52LQMNDjwPjA7k3W/kAYzvCsEzteUoEbu4
         yPAJWqnKYjN3T9Y0xfzCw8HsGJQdEZTqj4u0qMr0hYP9TSroZy6ZGbd1QX0+RpWNR5h/
         OigdrmABYXR+MFv/Ar3o2IjM9bOQZkEATabOuTvlr4F6PSGsFeKKtNt4P6DfO8grzL8a
         Wlt6QM8UkV7I4gD+iqf96i0VPn97OK4iwvJSA5WSIRl3e3GhvaJZFO4S+kKSuRBvmNOP
         8p7Mgj/QnaBU9sQdFLHhnetF3dMl9apL4Ry5w8QJZIcBcBEM2uC+DT6QDtQpH8K0QaS4
         1+vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wzoFsN2BtIwkV7J9p1OybyavGXclmQ9kcPW4uj8vI+4=;
        b=fC08j7fxE3Y4Es1khCDhBEVK9IP2Gmf34rrX5Zhb2ZPZJ3j/6MPd30oIUCSn6Rve6g
         ll55EOJqBQdfsGc7lQjVqV4qVhX6A7OP4gObgx8fmhJNnWZSLtjI9vFoZH3IQzZCpW5U
         2EBIFIIkMvv5Ol8ozl88OAPtlyIxl3YGh8rmruPIotG8A1GvMwfjG50IzDoACxKGmZ08
         oV5zRpzvWzH5q4TSzy6KWDzViQOyK9q48vx59z6zs1mu1faQM4IQzGrLA9HT2HMAUIEk
         GPsl6JwWYW51kc2ANvelxRtlrYe1STSHf4y7dSsyK0jxdeKqfXGWgEQoLfJcROksGilt
         FccA==
X-Gm-Message-State: AFqh2krNA4KUvfv9Omq4Qrt2vffK/nkJBYdEX81AuwXAQtvxprQ+eF4u
        blkkVKuIBu7rZ66pC0/YTqc=
X-Google-Smtp-Source: AMrXdXsHkUY7XfIE1B2bjhbcIkUoum8bNrkbJ1XX/wIp0s+lBwNIEiBdSnR4Jk843e+5/9ZDSuNesw==
X-Received: by 2002:a17:906:358f:b0:829:6064:bc52 with SMTP id o15-20020a170906358f00b008296064bc52mr4616096ejb.74.1673997473518;
        Tue, 17 Jan 2023 15:17:53 -0800 (PST)
Received: from skbuf ([188.27.184.249])
        by smtp.gmail.com with ESMTPSA id g18-20020a1709061c9200b007c1675d2626sm13977440ejh.96.2023.01.17.15.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 15:17:53 -0800 (PST)
Date:   Wed, 18 Jan 2023 01:17:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [RFC PATCH net-next 2/5] net: dsa: propagate flags down towards
 drivers
Message-ID: <20230117231750.r5jr4hwvpadgopmf@skbuf>
References: <20230117185714.3058453-1-netdev@kapio-technology.com>
 <20230117185714.3058453-3-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117185714.3058453-3-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 07:57:11PM +0100, Hans J. Schultz wrote:
> Dynamic FDB flag needs to be propagated through the DSA layer to be
> added to drivers.
> Use a u16 for fdb flags for future use, so that other flags can also be
> sent the same way without having to change function interfaces.
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---
> @@ -3364,6 +3368,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
>  	bool host_addr = fdb_info->is_local;
>  	struct dsa_switch *ds = dp->ds;
> +	u16 fdb_flags = 0;
>  
>  	if (ctx && ctx != dp)
>  		return 0;
> @@ -3410,6 +3415,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
>  		   orig_dev->name, fdb_info->addr, fdb_info->vid,
>  		   host_addr ? " as host address" : "");
>  
> +	if (fdb_info->is_dyn)
> +		fdb_flags |= DSA_FDB_FLAG_DYNAMIC;
> +

Hmm, I don't think this is going to work with the assisted_learning_on_cpu_port
feature ("if (switchdev_fdb_is_dynamically_learned(fdb_info))"). The reason being
that a "dynamically learned" FDB entry (defined as this):

static inline bool
switchdev_fdb_is_dynamically_learned(const struct switchdev_notifier_fdb_info *fdb_info)
{
	return !fdb_info->added_by_user && !fdb_info->is_local;
}

is also dynamic in the DSA_FDB_FLAG_DYNAMIC sense. But we install a
static FDB entry for it on the CPU port.

And in your follow-up patch 3/5, you make all drivers except mv88e6xxx
ignore all DSA_FDB_FLAG_DYNAMIC entries (including the ones snooped from
address learning on software interfaces). So this breaks those drivers
which don't implement DSA_FDB_FLAG_DYNAMIC but do set ds->assisted_learning_on_cpu_port
to true.

I think you also want to look at the added_by_user flag to disambiguate
between a dynamic FDB entry added from learning (which it's ok to
offload as static, because software ageing will remove it) and one added
by the user.

>  	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
>  	switchdev_work->event = event;
>  	switchdev_work->dev = dev;
> @@ -3418,6 +3426,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
>  	ether_addr_copy(switchdev_work->addr, fdb_info->addr);
>  	switchdev_work->vid = fdb_info->vid;
>  	switchdev_work->host_addr = host_addr;
> +	switchdev_work->fdb_flags = fdb_flags;
>  
>  	dsa_schedule_work(&switchdev_work->work);
>  
