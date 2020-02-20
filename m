Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 271DE165722
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 06:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgBTFp2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Feb 2020 00:45:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33702 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgBTFp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 00:45:27 -0500
Received: from mail-pj1-f71.google.com ([209.85.216.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1j4eeK-0003DU-5X
        for netdev@vger.kernel.org; Thu, 20 Feb 2020 05:45:24 +0000
Received: by mail-pj1-f71.google.com with SMTP id ds13so513457pjb.6
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 21:45:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=86xicwbBMVlu3E1kZ8TRtsoqUJxXhtsMMBSAf01pH9M=;
        b=J+jeZlJcVi1ToOgjz4RyNfBeZ1KdGwX80IKcSPfi3ZPkrrLmw82+9He1Jb95vdEVT7
         I49pSAdXE9R1D7sIUwj4aUWMpy9F4rWQDNSqykQNVW6HFvNTb+Z9SeOe31hj7lZE2whv
         0hiz27z4dTps82Ta+VuEZgbX5FMznjlwlk7G1kzrFEPboSdEmI+Pi8Xd6tkTDCPoJydf
         rRUL+8IZIGVan0HyQ3RunlKI0mSn/R1TG+JXFacaewImZ1OBLzNKSqgB3rTtrkTvOyXS
         ezs62qAhGpI+hK5ZE/mAz2Ob7CMMb/ExcBmu314l9io6fHX+wwYQWjkRP4N/PmXKyiy+
         Q2dQ==
X-Gm-Message-State: APjAAAXsJte9rnh/5SxRXCk73Hj9NPNT7E4hcd+fNAN4xRxgFoWa/eqi
        n3LJIiM2sMOwnH10E15krnbMwQcF7eBAZZtyKWGPuuKQ3AegKnig/RP9Ge1ID00Hg0PCMitv1jw
        EL3Vcie53b7/5dskf52SAPEnjPZZbS7QxzQ==
X-Received: by 2002:a17:90a:8685:: with SMTP id p5mr1651652pjn.92.1582177522509;
        Wed, 19 Feb 2020 21:45:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqyv5WsL7Ac7zUI5dJnfJAsVVE/VOjA6kasW67DyZxI/Z5fZlIVI/Pzm0eNk+3FF5xRw8oeqXg==
X-Received: by 2002:a17:90a:8685:: with SMTP id p5mr1651611pjn.92.1582177522044;
        Wed, 19 Feb 2020 21:45:22 -0800 (PST)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id 64sm1572652pfd.48.2020.02.19.21.45.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Feb 2020 21:45:21 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH v3 2/2] net-sysfs: Ensure begin/complete are called in
 speed_show() and duplex_show()
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20200207101005.4454-2-kai.heng.feng@canonical.com>
Date:   Thu, 20 Feb 2020 13:45:16 +0800
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jouni Hogander <jouni.hogander@unikie.com>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wang Hai <wanghai26@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Kimberly Brown <kimbrownkd@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Andrew Lunn <andrew@lunn.ch>,
        Li RongQing <lirongqing@baidu.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <425AF2D4-1FEE-437B-8520-452F818F7DEE@canonical.com>
References: <20200207101005.4454-1-kai.heng.feng@canonical.com>
 <20200207101005.4454-2-kai.heng.feng@canonical.com>
To:     David Miller <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Feb 7, 2020, at 18:10, Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:
> 
> Device like igb gets runtime suspended when there's no link partner. We
> can't get correct speed under that state:
> $ cat /sys/class/net/enp3s0/speed
> 1000
> 
> In addition to that, an error can also be spotted in dmesg:
> [  385.991957] igb 0000:03:00.0 enp3s0: PCIe link lost
> 
> It's because the igb device doesn't get runtime resumed before calling
> get_link_ksettings().
> 
> So let's use a new helper to call begin() and complete() like what
> dev_ethtool() does, to runtime resume/suspend or power up/down the
> device properly.
> 
> Once this fix is in place, igb can show the speed correctly without link
> partner:
> $ cat /sys/class/net/enp3s0/speed
> -1
> 
> -1 here means SPEED_UNKNOWN, which is the correct value when igb is
> runtime suspended.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

A gentle ping...

Kai-Heng

> ---
> v3:
> - Specify -1 means SPEED_UNKNOWN.
> v2:
> - Add a new helper with begin/complete and use it in net-sysfs.
> 
> include/linux/ethtool.h |  4 ++++
> net/core/net-sysfs.c    |  4 ++--
> net/ethtool/ioctl.c     | 33 ++++++++++++++++++++++++++++++++-
> 3 files changed, 38 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 95991e4300bf..785ec1921417 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -160,6 +160,10 @@ extern int
> __ethtool_get_link_ksettings(struct net_device *dev,
> 			     struct ethtool_link_ksettings *link_ksettings);
> 
> +extern int
> +__ethtool_get_link_ksettings_full(struct net_device *dev,
> +				  struct ethtool_link_ksettings *link_ksettings);
> +
> /**
>  * ethtool_intersect_link_masks - Given two link masks, AND them together
>  * @dst: first mask and where result is stored
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 4c826b8bf9b1..a199e15a080f 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -201,7 +201,7 @@ static ssize_t speed_show(struct device *dev,
> 	if (netif_running(netdev)) {
> 		struct ethtool_link_ksettings cmd;
> 
> -		if (!__ethtool_get_link_ksettings(netdev, &cmd))
> +		if (!__ethtool_get_link_ksettings_full(netdev, &cmd))
> 			ret = sprintf(buf, fmt_dec, cmd.base.speed);
> 	}
> 	rtnl_unlock();
> @@ -221,7 +221,7 @@ static ssize_t duplex_show(struct device *dev,
> 	if (netif_running(netdev)) {
> 		struct ethtool_link_ksettings cmd;
> 
> -		if (!__ethtool_get_link_ksettings(netdev, &cmd)) {
> +		if (!__ethtool_get_link_ksettings_full(netdev, &cmd)) {
> 			const char *duplex;
> 
> 			switch (cmd.base.duplex) {
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index b987052d91ef..faeba247c1fb 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -420,7 +420,9 @@ struct ethtool_link_usettings {
> 	} link_modes;
> };
> 
> -/* Internal kernel helper to query a device ethtool_link_settings. */
> +/* Internal kernel helper to query a device ethtool_link_settings. To be called
> + * inside begin/complete block.
> + */
> int __ethtool_get_link_ksettings(struct net_device *dev,
> 				 struct ethtool_link_ksettings *link_ksettings)
> {
> @@ -434,6 +436,35 @@ int __ethtool_get_link_ksettings(struct net_device *dev,
> }
> EXPORT_SYMBOL(__ethtool_get_link_ksettings);
> 
> +/* Internal kernel helper to query a device ethtool_link_settings. To be called
> + * outside of begin/complete block.
> + */
> +int __ethtool_get_link_ksettings_full(struct net_device *dev,
> +				      struct ethtool_link_ksettings *link_ksettings)
> +{
> +	int rc;
> +
> +	ASSERT_RTNL();
> +
> +	if (!dev->ethtool_ops->get_link_ksettings)
> +		return -EOPNOTSUPP;
> +
> +	if (dev->ethtool_ops->begin) {
> +		rc = dev->ethtool_ops->begin(dev);
> +		if (rc  < 0)
> +			return rc;
> +	}
> +
> +	memset(link_ksettings, 0, sizeof(*link_ksettings));
> +	rc = dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
> +
> +	if (dev->ethtool_ops->complete)
> +		dev->ethtool_ops->complete(dev);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL(__ethtool_get_link_ksettings_full);
> +
> /* convert ethtool_link_usettings in user space to a kernel internal
>  * ethtool_link_ksettings. return 0 on success, errno on error.
>  */
> -- 
> 2.17.1
> 

