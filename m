Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7DEB6D7A6
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 02:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfGSAMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 20:12:10 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37959 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfGSAMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 20:12:10 -0400
Received: by mail-pf1-f196.google.com with SMTP id y15so13349979pfn.5
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 17:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Zs0lOHdYwPPsMqVvU5VUoKk6oyJ+lXqC9L0C+dH2Wvk=;
        b=Esvaa7eGYuRFBGma53Yqa9fFW3Fo1fvJKV4CwDI3R1VTAmQ3Pgz0t79pX9dcbZo8N1
         QO54bCv4V3jNClP5TNHnZ2JDQz3MkDA8nupB1nVmjsrDdln60hi9LWJ0ZZQFuK8gWdGr
         KLZoCP8HRjQMgQnTk+FYx4SWcApx+61bfBCO4cOUb/101L/qkCRiAOKDu3vMR+UCrja9
         ShoBLzZ2J0NMWdp+fO60lY4VErHjdjmPaOzHDywIQDs+GoOIoP9Pa70+OIcWXzeR3NwS
         ZRZuMuxE1BSRsBYiaAzVk5OPFMrZl6KdHtpE6o81Kl7Bbw2UpmOF/8D0Ayg6Vr6ifYNI
         kv8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Zs0lOHdYwPPsMqVvU5VUoKk6oyJ+lXqC9L0C+dH2Wvk=;
        b=qhFI7dP36OFwAoG4uqujPCXnmkwwOJLq3rVWuKD70uYsvS1buc2nWPFLpdSuXbLmTN
         H/aK4fJLYmK1xSAr4OTWqkLbVNcsRuCmKHniWwhRWG1tcxmuZB3XRKQXnmuPBJEOdXD4
         lNlrDlN6q1dyVCMCF9T00wIYIvQIpDCy20wwlmQ2PHb2KrGMvXYkeX08afp1RWNuGBo1
         F8fyuZj/Z3pFpsgzcR5Ia7IAP5Lc89B0QOi+Hgg7mnx3GICgYpBWJEA7umUloUC1AWJp
         yY2CPR8B/1I2lS969rmcs3RRdEz3yQELu1V+Y+5ba6Q2+97dFtYroLanJF1UCx5LEWgM
         pQcg==
X-Gm-Message-State: APjAAAW+TsqfpTF45wD8EtQGI89KVNp0dsIPfxp4oUB2AGy4n93gTXHC
        6p92ZK0KcSphPHsntKYzWqx2tErUrJY=
X-Google-Smtp-Source: APXvYqw0mubzap6AbuIZFrg/dAJ8CBS50N6/K6EqASowVzNjCtclHfjd0EnKG2oxDnR0vSLIGuhTAA==
X-Received: by 2002:a63:d950:: with SMTP id e16mr52744832pgj.271.1563495129114;
        Thu, 18 Jul 2019 17:12:09 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 21sm19421629pfj.76.2019.07.18.17.12.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 17:12:08 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io> <20190709021426.GA5835@lunn.ch>
 <10c66ecf-6d67-d206-b496-6f8139f218a8@pensando.io>
 <20190718032814.GH6962@lunn.ch>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <00a22345-4904-57b4-f40b-9ddd2e7398ec@pensando.io>
Date:   Thu, 18 Jul 2019 17:12:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190718032814.GH6962@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/17/19 8:28 PM, Andrew Lunn wrote:
> On Fri, Jul 12, 2019 at 10:16:31PM -0700, Shannon Nelson wrote:
>> On 7/8/19 7:14 PM, Andrew Lunn wrote:
>>>> +static int ionic_set_pauseparam(struct net_device *netdev,
>>>> +				struct ethtool_pauseparam *pause)
>>>> +{
>>>> +	struct lif *lif = netdev_priv(netdev);
>>>> +	struct ionic *ionic = lif->ionic;
>>>> +	struct ionic_dev *idev = &lif->ionic->idev;
>>>> +
>>>> +	u32 requested_pause;
>>>> +	u32 cur_autoneg;
>>>> +	int err;
>>>> +
>>>> +	cur_autoneg = idev->port_info->config.an_enable ? AUTONEG_ENABLE :
>>>> +								AUTONEG_DISABLE;
>>>> +	if (pause->autoneg != cur_autoneg) {
>>>> +		netdev_info(netdev, "Please use 'ethtool -s ...' to change autoneg\n");
>>>> +		return -EOPNOTSUPP;
>>>> +	}
>>>> +
>>>> +	/* change both at the same time */
>>>> +	requested_pause = PORT_PAUSE_TYPE_LINK;
>>>> +	if (pause->rx_pause)
>>>> +		requested_pause |= IONIC_PAUSE_F_RX;
>>>> +	if (pause->tx_pause)
>>>> +		requested_pause |= IONIC_PAUSE_F_TX;
>>>> +
>>>> +	if (requested_pause == idev->port_info->config.pause_type)
>>>> +		return 0;
>>>> +
>>>> +	idev->port_info->config.pause_type = requested_pause;
>>>> +
>>>> +	mutex_lock(&ionic->dev_cmd_lock);
>>>> +	ionic_dev_cmd_port_pause(idev, requested_pause);
>>>> +	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
>>>> +	mutex_unlock(&ionic->dev_cmd_lock);
>>>> +	if (err)
>>>> +		return err;
>>> Hi Shannon
>>>
>>> I've no idea what the firmware black box is doing, but this looks
>>> wrong.
>>>
>>> pause->autoneg is about if the results of auto-neg should be used or
>>> not. If false, just configure the MAC with the pause settings and you
>>> are done. If the interface is being forced, so autoneg in general is
>>> disabled, just configure the MAC and you are done.
>>>
>>> If pause->autoneg is true and the interface is using auto-neg as a
>>> whole, you pass the pause values to the PHY for it to advertise and
>>> trigger an auto-neg. Once autoneg has completed, and the resolved
>>> settings are available, the MAC is configured with the resolved
>>> values.
>>>
>>> Looking at this code, i don't see any difference between configuring
>>> the MAC or configuring the PHY. I would expect pause->autoneg to be
>>> part of requested_pause somehow, so the firmware knows what is should
>>> do.
>>>
>>> 	Andrew
>> In this device there's actually very little the driver can do to directly
>> configure the mac or phy besides passing through to the firmware what the
>> user has requested - that happens here for the pause values, and in
>> ionic_set_link_ksettings() for autoneg.  The firmware is managing the port
>> based on these requests with the help of internally configured rules defined
>> in a customer setting.
> I get that. But the firmware needs to conform to what Linux
> expects. And what i see here does not conform. That is why i gave a
> bit of detail in my reply.
>
> What exactly does the firmware do? Once we know that, we can figure
> out when the driver should return -EOPNOTSUPP because of firmware
> limitations, and what it can configure and should return 0.

Because this is fairly smart FW, it handles this as expected.  I can add 
this as another comment in the code.

sln




