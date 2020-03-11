Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADDF5180E82
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 04:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgCKDbA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 10 Mar 2020 23:31:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37131 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727659AbgCKDbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 23:31:00 -0400
Received: from mail-pf1-f197.google.com ([209.85.210.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jBs5B-0007lF-FR
        for netdev@vger.kernel.org; Wed, 11 Mar 2020 03:30:57 +0000
Received: by mail-pf1-f197.google.com with SMTP id c17so425063pfi.20
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 20:30:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=JAj39y4cSkPD8V1E4/a4ReHRXvM9rblHsG5Ml1/Bwlg=;
        b=Z7Hi+N/6E/AtZozhwX/KzaFvwCnYy62d4E3f+M36p/pWST3WtaFpbveexrVs23oQNV
         M8bzh6zM+xtP7gzNcQIEOlsSFJqtmSsV95y5t7wMEhtjPWEixbGnhs5PO5dLbccWA/BU
         ouGqVbIrngfB6srAeua7mRO5XnjO7eO/Os/UjE1ldN651IyH5SS3sfkPopRwR+9x26qH
         Iz/14pWUSxm7pPr11ki5Y+pICN1SyQCtoNk8A7XEe++gWHEpT1G604y4EsqGLwOFe8IN
         O9qED72BGvrdrP6nsjWOYImldlwjHrq8SXbFOV9jAEmWBdyxmO5HtucfaVlBsZD/4hIc
         s4Aw==
X-Gm-Message-State: ANhLgQ2oMuJhYQQ3w3ovhPo73tx9tJyA69wDimPw4LRrPAtFVbFviEtj
        P2rUV0KKAzupyf70WkZaHr0Hv0h+GCbPyyTJCR85P3JfDgjdq8Lrp2cARyTj/loQiC1JhY/qLUx
        GNdY9BMH2H0W466Brxha4nOPgD1ZhEJqPww==
X-Received: by 2002:a63:1c4a:: with SMTP id c10mr911365pgm.252.1583897455932;
        Tue, 10 Mar 2020 20:30:55 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsEErfC0z0HElIsPQwHJRDDdA2hHxEBoyTBij97kd4MeYBIaxapOby5p099widGMm2WCiMq9w==
X-Received: by 2002:a63:1c4a:: with SMTP id c10mr911334pgm.252.1583897455506;
        Tue, 10 Mar 2020 20:30:55 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id u3sm3623345pjv.32.2020.03.10.20.30.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Mar 2020 20:30:54 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH v3 2/2] net-sysfs: Ensure begin/complete are called in
 speed_show() and duplex_show()
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <425AF2D4-1FEE-437B-8520-452F818F7DEE@canonical.com>
Date:   Wed, 11 Mar 2020 11:30:49 +0800
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
Message-Id: <BEFADD90-2EC7-4B46-8AF4-F1D1CCD81993@canonical.com>
References: <20200207101005.4454-1-kai.heng.feng@canonical.com>
 <20200207101005.4454-2-kai.heng.feng@canonical.com>
 <425AF2D4-1FEE-437B-8520-452F818F7DEE@canonical.com>
To:     David Miller <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 20, 2020, at 13:45, Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:
> 
>> 
>> On Feb 7, 2020, at 18:10, Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:
>> 
>> Device like igb gets runtime suspended when there's no link partner. We
>> can't get correct speed under that state:
>> $ cat /sys/class/net/enp3s0/speed
>> 1000
>> 
>> In addition to that, an error can also be spotted in dmesg:
>> [  385.991957] igb 0000:03:00.0 enp3s0: PCIe link lost
>> 
>> It's because the igb device doesn't get runtime resumed before calling
>> get_link_ksettings().
>> 
>> So let's use a new helper to call begin() and complete() like what
>> dev_ethtool() does, to runtime resume/suspend or power up/down the
>> device properly.
>> 
>> Once this fix is in place, igb can show the speed correctly without link
>> partner:
>> $ cat /sys/class/net/enp3s0/speed
>> -1
>> 
>> -1 here means SPEED_UNKNOWN, which is the correct value when igb is
>> runtime suspended.
>> 
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> 
> A gentle ping...

Another gentle ping...

> 
> Kai-Heng
> 
>> ---
>> v3:
>> - Specify -1 means SPEED_UNKNOWN.
>> v2:
>> - Add a new helper with begin/complete and use it in net-sysfs.
>> 
>> include/linux/ethtool.h |  4 ++++
>> net/core/net-sysfs.c    |  4 ++--
>> net/ethtool/ioctl.c     | 33 ++++++++++++++++++++++++++++++++-
>> 3 files changed, 38 insertions(+), 3 deletions(-)
>> 
>> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
>> index 95991e4300bf..785ec1921417 100644
>> --- a/include/linux/ethtool.h
>> +++ b/include/linux/ethtool.h
>> @@ -160,6 +160,10 @@ extern int
>> __ethtool_get_link_ksettings(struct net_device *dev,
>> 			     struct ethtool_link_ksettings *link_ksettings);
>> 
>> +extern int
>> +__ethtool_get_link_ksettings_full(struct net_device *dev,
>> +				  struct ethtool_link_ksettings *link_ksettings);
>> +
>> /**
>> * ethtool_intersect_link_masks - Given two link masks, AND them together
>> * @dst: first mask and where result is stored
>> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
>> index 4c826b8bf9b1..a199e15a080f 100644
>> --- a/net/core/net-sysfs.c
>> +++ b/net/core/net-sysfs.c
>> @@ -201,7 +201,7 @@ static ssize_t speed_show(struct device *dev,
>> 	if (netif_running(netdev)) {
>> 		struct ethtool_link_ksettings cmd;
>> 
>> -		if (!__ethtool_get_link_ksettings(netdev, &cmd))
>> +		if (!__ethtool_get_link_ksettings_full(netdev, &cmd))
>> 			ret = sprintf(buf, fmt_dec, cmd.base.speed);
>> 	}
>> 	rtnl_unlock();
>> @@ -221,7 +221,7 @@ static ssize_t duplex_show(struct device *dev,
>> 	if (netif_running(netdev)) {
>> 		struct ethtool_link_ksettings cmd;
>> 
>> -		if (!__ethtool_get_link_ksettings(netdev, &cmd)) {
>> +		if (!__ethtool_get_link_ksettings_full(netdev, &cmd)) {
>> 			const char *duplex;
>> 
>> 			switch (cmd.base.duplex) {
>> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
>> index b987052d91ef..faeba247c1fb 100644
>> --- a/net/ethtool/ioctl.c
>> +++ b/net/ethtool/ioctl.c
>> @@ -420,7 +420,9 @@ struct ethtool_link_usettings {
>> 	} link_modes;
>> };
>> 
>> -/* Internal kernel helper to query a device ethtool_link_settings. */
>> +/* Internal kernel helper to query a device ethtool_link_settings. To be called
>> + * inside begin/complete block.
>> + */
>> int __ethtool_get_link_ksettings(struct net_device *dev,
>> 				 struct ethtool_link_ksettings *link_ksettings)
>> {
>> @@ -434,6 +436,35 @@ int __ethtool_get_link_ksettings(struct net_device *dev,
>> }
>> EXPORT_SYMBOL(__ethtool_get_link_ksettings);
>> 
>> +/* Internal kernel helper to query a device ethtool_link_settings. To be called
>> + * outside of begin/complete block.
>> + */
>> +int __ethtool_get_link_ksettings_full(struct net_device *dev,
>> +				      struct ethtool_link_ksettings *link_ksettings)
>> +{
>> +	int rc;
>> +
>> +	ASSERT_RTNL();
>> +
>> +	if (!dev->ethtool_ops->get_link_ksettings)
>> +		return -EOPNOTSUPP;
>> +
>> +	if (dev->ethtool_ops->begin) {
>> +		rc = dev->ethtool_ops->begin(dev);
>> +		if (rc  < 0)
>> +			return rc;
>> +	}
>> +
>> +	memset(link_ksettings, 0, sizeof(*link_ksettings));
>> +	rc = dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
>> +
>> +	if (dev->ethtool_ops->complete)
>> +		dev->ethtool_ops->complete(dev);
>> +
>> +	return rc;
>> +}
>> +EXPORT_SYMBOL(__ethtool_get_link_ksettings_full);
>> +
>> /* convert ethtool_link_usettings in user space to a kernel internal
>> * ethtool_link_ksettings. return 0 on success, errno on error.
>> */
>> -- 
>> 2.17.1

