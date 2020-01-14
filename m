Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F95D13A725
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 11:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgANKTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 05:19:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43010 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730351AbgANKG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 05:06:28 -0500
Received: from mail-pg1-f198.google.com ([209.85.215.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1irJ5e-0002hu-LZ
        for netdev@vger.kernel.org; Tue, 14 Jan 2020 10:06:26 +0000
Received: by mail-pg1-f198.google.com with SMTP id c8so8150070pgl.15
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 02:06:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=VN6q/GxJ7GOTvYmgVxwq5L3uVSb170dA2xY4o1EBnsg=;
        b=Y/SmFDjbAcTZKchZh3h9ayzUcc3DvRKiS51nUrHT7wDGhP2KbezmbIAH/t1bqMO9c4
         EzPQNCf2VjgwVzWZLfwAiX/Ja5U3dJv0n+XtabzDpOMarQKhdI0Q7gRgnQHsLallTpYY
         cLmgEt2GbWRu4TzZJtjx/ysml1uQ/7aj31zrfq5Zi06eijREXReX3/xNUexoSg3lg3Ri
         TEm4gqxjBrtvKWoIKAmknbXC9Uta6PH5nGvYqtKyEKDPPxn52bKgdAx/TnolHfcqyy/v
         uCDVGdnoY2dAzdnJ4yA4LfDD1YL2mc0Lyeh0+E6UYcOFnrU6nQyLxCrgAk+VozcXiv+y
         bGDg==
X-Gm-Message-State: APjAAAUSQa8uij6OPkLVArT5k28LTphJ4dq+uKGch/7QFihRs3WsaES/
        IjVpf6z0JhmwRaQzusErJexirb3dnzk065DS0NUdqqaIB4QLa0olsPrFfHfKJKs5imVYRX5ixMO
        Alo3qBzFLp2Uhvy3uJnWEl+bAeGlB6qy5sQ==
X-Received: by 2002:a63:5d03:: with SMTP id r3mr25979778pgb.306.1578996385104;
        Tue, 14 Jan 2020 02:06:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqxZHX+WNcTDIfSChzPivJEbgVYq5+c2W8ImUJW9Swv6JQHChlydKLp/72pvPwHHX3HMEHFxqA==
X-Received: by 2002:a63:5d03:: with SMTP id r3mr25979746pgb.306.1578996384750;
        Tue, 14 Jan 2020 02:06:24 -0800 (PST)
Received: from 2001-b011-380f-35a3-5d99-e277-e07f-4d26.dynamic-ip6.hinet.net (2001-b011-380f-35a3-5d99-e277-e07f-4d26.dynamic-ip6.hinet.net. [2001:b011:380f:35a3:5d99:e277:e07f:4d26])
        by smtp.gmail.com with ESMTPSA id a12sm16002053pga.11.2020.01.14.02.06.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 02:06:24 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [PATCH 2/2] ethtool: Call begin() and complete() in
 __ethtool_get_link_ksettings()
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20200113125129.GD25361@unicorn.suse.cz>
Date:   Tue, 14 Jan 2020 18:06:21 +0800
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Li RongQing <lirongqing@baidu.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <4AC365A3-3091-46A7-B938-F63A11115464@canonical.com>
References: <20200110074159.18473-1-kai.heng.feng@canonical.com>
 <20200110074159.18473-2-kai.heng.feng@canonical.com>
 <20200113125129.GD25361@unicorn.suse.cz>
To:     Michal Kubecek <mkubecek@suse.cz>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> On Jan 13, 2020, at 20:51, Michal Kubecek <mkubecek@suse.cz> wrote:
> 
> On Fri, Jan 10, 2020 at 03:41:59PM +0800, Kai-Heng Feng wrote:
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
>> So let's call begin() and complete() like what dev_ethtool() does, to
>> runtime resume/suspend or power up/down the device properly.
>> 
>> Once this fix is in place, igb can show the speed correctly without link
>> partner:
>> $ cat /sys/class/net/enp3s0/speed
>> -1
> 
> I agree that we definitely should make sure ->begin() and ->complete()
> are always called around ethtool_ops calls. But even if nesting should
> be safe now (for in-tree drivers, that is), I'm not really happy about
> calling them even in places where we positively know we are always
> inside a begin / complete block as e.g. vxlan or net_failover do. (And
> also linkinfo.c and linkmodes.c but it may be easier to call
> ->get_link_ksettings() directly there.)

Ok. Maybe use set_bit() to know it's inside of begin() and complete()?

> 
> How about having two helpers: one simple for "ethtool context" where we
> know we already are between ->begin() and ->complete() and one with the
> begin/complete calls for the rest?

Or I can rebase this patch on top of the refactoring work.

Kai-Heng

> Another interesting question is if
> any of the callers which do not have their own begin()/complete() wrap
> does actually need anything more than speed and duplex (I didn't do
> a full check).

For sysfs yes, I am not sure about other cases though.

Kai-Heng

> 
> Michal
> 
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> ---
>> net/ethtool/ioctl.c | 15 ++++++++++++++-
>> 1 file changed, 14 insertions(+), 1 deletion(-)
>> 
>> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
>> index 182bffbffa78..c768dbf45fc4 100644
>> --- a/net/ethtool/ioctl.c
>> +++ b/net/ethtool/ioctl.c
>> @@ -423,13 +423,26 @@ struct ethtool_link_usettings {
>> int __ethtool_get_link_ksettings(struct net_device *dev,
>> 				 struct ethtool_link_ksettings *link_ksettings)
>> {
>> +	int rc;
>> +
>> 	ASSERT_RTNL();
>> 
>> 	if (!dev->ethtool_ops->get_link_ksettings)
>> 		return -EOPNOTSUPP;
>> 
>> +	if (dev->ethtool_ops->begin) {
>> +		rc = dev->ethtool_ops->begin(dev);
>> +		if (rc  < 0)
>> +			return rc;
>> +	}
>> +
>> 	memset(link_ksettings, 0, sizeof(*link_ksettings));
>> -	return dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
>> +	rc = dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
>> +
>> +	if (dev->ethtool_ops->complete)
>> +		dev->ethtool_ops->complete(dev);
>> +
>> +	return rc;
>> }
>> EXPORT_SYMBOL(__ethtool_get_link_ksettings);
>> 
>> -- 
>> 2.17.1
>> 

