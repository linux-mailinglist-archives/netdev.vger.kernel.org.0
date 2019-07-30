Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDDD67B20D
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 20:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbfG3Sfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 14:35:30 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42521 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfG3Sf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 14:35:29 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so30273419pff.9
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 11:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:subject:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=xM1Xp4uCiUgVOPTcQxnVyxQmDigD4A9W58iB+S72o2Q=;
        b=PJ4XUOnOohAN5uGC4mYKatI9EKZKzYHo3aB19J2R+MLgZOY52R142K3ENlqRWrWbdR
         tStb05wVAERhw3UYOsg6NAGmA7qxo0jMxx0lVcjnbhDC4AsrqxxCxhEpvHa7jAyTFrhq
         TDyRqP8/ydBma7Vuo/u6xKTj7twkLOfAspWJTSerB3qBV1PzouZ4wTqqbA/nKYLhpFSc
         ZhQRmsKIMscg/KPIqlGzu+9VfHn4fOaUWwN7yqNr3Dk5njmk39j9NfF3wQgutMAGE6qj
         MEN+Ty5Dj3Hs8p0P4/kvWA5cj7ZPwzM3bUC2AdKk9N9igHZyZRb1ofyGLCTtcUJlyYkl
         lRFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=xM1Xp4uCiUgVOPTcQxnVyxQmDigD4A9W58iB+S72o2Q=;
        b=R7hzp/MXNQnHwzvki66dSKcFbYD4gmGMAEQWv5JTnqYFbmj7JEzF/de5P23JpBAgDr
         lqVo69TrjrMberpKl4poptohHj92DH90R2gmakh0dVo/G//dGhX8c2XKGYafni1WhqJc
         f5pPeWYCSlPFZAZRK4ZMP2BbLxlKbIcH40joyfug5ImEz0qHYNI0vam1pTKF0nuiCNOx
         Rhv8Oxz0DgcwsYGG2/9WkfvCvAWGvy27TeVD4zM206r+3HQdzvMFEarcclPd256eVO5f
         Csn5e86+/EC3BUVTM4+Y3wx6nF02U2AgpPWlBQJwXpJtJi21eP6lCQptgEn6iqj72PfH
         FUIw==
X-Gm-Message-State: APjAAAU7VJX/ouOGy14Da/vsbCzaMJHcQba6zMBXvInOKnpEYI2vvo1F
        /gEI6RBd588FnZCID7YMMo/ke3gAus9lXw==
X-Google-Smtp-Source: APXvYqxGb5CdAOH28Yc30Z36L52+XA0BAKhVxKe3iGUPMDvGMTyvXvCFHOp03CQCWNYtaTEDnZ5YZw==
X-Received: by 2002:a17:90a:246f:: with SMTP id h102mr116785117pje.126.1564511728983;
        Tue, 30 Jul 2019 11:35:28 -0700 (PDT)
Received: from Shannons-MBP.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id i123sm90080164pfe.147.2019.07.30.11.35.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 11:35:28 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
Subject: Re: [PATCH v4 net-next 09/19] ionic: Add the basic NDO callbacks for
 netdev support
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-10-snelson@pensando.io>
 <c5d6315ee4b72d9b2a977866b9849ffe9183f4b6.camel@mellanox.com>
Message-ID: <3a149646-2cb4-1fc8-7b2e-6dff5a36d6c5@pensando.io>
Date:   Tue, 30 Jul 2019 11:35:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <c5d6315ee4b72d9b2a977866b9849ffe9183f4b6.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/19 4:45 PM, Saeed Mahameed wrote:
> On Mon, 2019-07-22 at 14:40 -0700, Shannon Nelson wrote:
>> Set up the initial NDO structure and callbacks for netdev
>> to use, and register the netdev.  This will allow us to do
>> a few basic operations on the device, but no traffic yet.
>>
>> Signed-off-by: Shannon Nelson<snelson@pensando.io>
>> ---
>>   drivers/net/ethernet/pensando/ionic/ionic.h   |   1 +
>>   .../ethernet/pensando/ionic/ionic_bus_pci.c   |   9 +
>>   .../net/ethernet/pensando/ionic/ionic_dev.h   |   2 +
>>   .../net/ethernet/pensando/ionic/ionic_lif.c   | 348
>> ++++++++++++++++++
>>   .../net/ethernet/pensando/ionic/ionic_lif.h   |   5 +
>>   5 files changed, 365 insertions(+)
>>
[...]
>>   
>> +static int ionic_set_nic_features(struct lif *lif, netdev_features_t
>> features);
>>   static int ionic_notifyq_clean(struct lif *lif, int budget);
>>   
>> +int ionic_open(struct net_device *netdev)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +
>> +	netif_carrier_off(netdev);
>> +
>> +	set_bit(LIF_UP, lif->state);
>> +
>> +	if (netif_carrier_ok(netdev))
> always false ? you just invoked netif_carrier_off two lines ago..

Hmmm... an artifact of splitting up an existing driver.  This makes more 
sense when there's a link status check in between these, which comes in 
about 3 patches later.  Unless this really causes someone significant 
heartburn, I'm going to leave this as is for now.


>> +		netif_tx_wake_all_queues(netdev);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ionic_lif_stop(struct lif *lif)
>> +{
>> +	struct net_device *ndev = lif->netdev;
>> +	int err = 0;
>> +
>> +	if (!test_bit(LIF_UP, lif->state)) {
>> +		dev_dbg(lif->ionic->dev, "%s: %s state=DOWN\n",
>> +			__func__, lif->name);
>> +		return 0;
>> +	}
>> +	dev_dbg(lif->ionic->dev, "%s: %s state=UP\n", __func__, lif-
>>> name);
>> +	clear_bit(LIF_UP, lif->state);
>> +
>> +	/* carrier off before disabling queues to avoid watchdog
>> timeout */
>> +	netif_carrier_off(ndev);
>> +	netif_tx_stop_all_queues(ndev);
>> +	netif_tx_disable(ndev);
>> +	synchronize_rcu();
> why synchronize_rcu ?

Looks like a little leakage from a feature in the internal driver, I'll 
remove it.

>> +
>> +	return err;
>> +}
>> +
>> +int ionic_stop(struct net_device *netdev)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +
>> +	return ionic_lif_stop(lif);
>> +}
>> +
>> +int ionic_reset_queues(struct lif *lif)
>> +{
>> +	bool running;
>> +	int err = 0;
>> +
>> +	/* Put off the next watchdog timeout */
>> +	netif_trans_update(lif->netdev);
> this doesn't seem right to me also this won't help you if the next
> while loop takes too long.. also netif_trans_update is marked to be
> only used for legacy drivers.

If the loop takes too long, then I don't mind if the watchdog goes off.

Yes, its primary use is now handled by netdev_start_xmit(), but it is 
still a handy gizmo to give a little more cushion until the carrier is 
set off in ionic_lif_stop().

sln

