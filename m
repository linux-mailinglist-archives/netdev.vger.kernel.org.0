Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17E2F6EB88
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 22:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730861AbfGSUUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 16:20:30 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33811 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbfGSUU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 16:20:29 -0400
Received: by mail-pl1-f196.google.com with SMTP id i2so16156140plt.1
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 13:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ZZpvE/zu8w6qfDkqqcEWEfv6g/P8g9fAeH+0sOWsdIA=;
        b=UdRmacIgEVe7YRsnVYbnqOuHVRopxBZ5Qyg/mPLUJIdGp4yAp41FKLHdzEtcENWzsc
         VgF7xqXyU7tmtT5FICGVbeOYN1oWNps0fanAYBJ8e39riZZaScW2KiWkd5IwOOgp3KMo
         nhNJWpf2InqOJaOXhBHcy/9+Fv4A73z45mA8t6m/CWvUd0zDUkRF7Sdn6sbNHjcnQKbf
         Tta/SmD5/Q8DZYCU7EphcKG4wugUGkNH1YWYd7/iVJ3LYBAGHH4E+CSLjHlqkP1TfcmX
         v/Ym2JIbxK17e9MJEkRUmM7Wiq+YswO+fs61vAlBZxD+FZRkHGgk9TIhyX5F8lWb72KD
         1GpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZZpvE/zu8w6qfDkqqcEWEfv6g/P8g9fAeH+0sOWsdIA=;
        b=AJCD4dg7Ay/1Uz5oxSNLjg0JvKs2jgqB4D8xU07C7W1pkio58nebFbEKkQZ2Vgppm2
         1B+xK+mY9qo+lcSo57iDatbcwaXbAhT1VCTjDUamCZHdXm4nE5ZfM5lWXyuWnymJqzR2
         IX8N4H35sNMWJAoOiRhpT3IcicXPS3WjoR68L8hTF5wDK5zR/Gbgcb/Qd9oEmWCCB+Bx
         M1rK9ZH7XXExijA3c6etnjomLDIyMqZCs3edT7PhcAylDnanOBzoxcVQ37iIRxnMpvQY
         NJhzWqTjEm2Nbc/JJVlG1oUOqhy58IoD4gRv6igvtq7EXDwq6RUT+uEJRRgatGqKH6SF
         B/Sg==
X-Gm-Message-State: APjAAAXB2KpEiS5r/b9QVoSq/mrhO60DOo8oOpo/NEh8oQqZ/DsP3Eqp
        Peta4yVpWcIXT8WD/zdO6yPbFfr4Ha8=
X-Google-Smtp-Source: APXvYqx/ztalkD6cQhTyzCePyzv6iVlrq26uhHchhjF1aoIsQzo5/cyKv6tLSCAi7qgzJm69m0S19Q==
X-Received: by 2002:a17:902:70cc:: with SMTP id l12mr17329172plt.87.1563567628477;
        Fri, 19 Jul 2019 13:20:28 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id y10sm32786030pfm.66.2019.07.19.13.20.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 13:20:27 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io> <20190709021426.GA5835@lunn.ch>
 <10c66ecf-6d67-d206-b496-6f8139f218a8@pensando.io>
 <20190718032814.GH6962@lunn.ch>
 <00a22345-4904-57b4-f40b-9ddd2e7398ec@pensando.io>
 <20190719024013.GC24765@lunn.ch>
 <15796ade-68dd-4350-e481-3a3a1e7ce3d5@pensando.io>
 <20190719190715.GO25635@lunn.ch>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <087d62dc-5a73-b924-8b03-d92fc03acd23@pensando.io>
Date:   Fri, 19 Jul 2019 13:20:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190719190715.GO25635@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/19 12:07 PM, Andrew Lunn wrote:
> On Fri, Jul 19, 2019 at 11:41:28AM -0700, Shannon Nelson wrote:
>> On 7/18/19 7:40 PM, Andrew Lunn wrote:
>>> On Thu, Jul 18, 2019 at 05:12:07PM -0700, Shannon Nelson wrote:
>>>> On 7/17/19 8:28 PM, Andrew Lunn wrote:
>>>>> On Fri, Jul 12, 2019 at 10:16:31PM -0700, Shannon Nelson wrote:
>>>>>> On 7/8/19 7:14 PM, Andrew Lunn wrote:
>>>>>>>> +static int ionic_set_pauseparam(struct net_device *netdev,
>>>>>>>> +				struct ethtool_pauseparam *pause)
>>>>>>>> +{
>>>>>>>> +	struct lif *lif = netdev_priv(netdev);
>>>>>>>> +	struct ionic *ionic = lif->ionic;
>>>>>>>> +	struct ionic_dev *idev = &lif->ionic->idev;
>>>>>>>> +
>>>>>>>> +	u32 requested_pause;
>>>>>>>> +	u32 cur_autoneg;
>>>>>>>> +	int err;
>>>>>>>> +
>>>>>>>> +	cur_autoneg = idev->port_info->config.an_enable ? AUTONEG_ENABLE :
>>>>>>>> +								AUTONEG_DISABLE;
>>>>>>>> +	if (pause->autoneg != cur_autoneg) {
>>>>>>>> +		netdev_info(netdev, "Please use 'ethtool -s ...' to change autoneg\n");
>>>>>>>> +		return -EOPNOTSUPP;
>>>>>>>> +	}
>>>>>>>> +
>>>>>>>> +	/* change both at the same time */
>>>>>>>> +	requested_pause = PORT_PAUSE_TYPE_LINK;
>>>>>>>> +	if (pause->rx_pause)
>>>>>>>> +		requested_pause |= IONIC_PAUSE_F_RX;
>>>>>>>> +	if (pause->tx_pause)
>>>>>>>> +		requested_pause |= IONIC_PAUSE_F_TX;
>>>>>>>> +
>>>>>>>> +	if (requested_pause == idev->port_info->config.pause_type)
>>>>>>>> +		return 0;
>>>>>>>> +
>>>>>>>> +	idev->port_info->config.pause_type = requested_pause;
>>>>>>>> +
>>>>>>>> +	mutex_lock(&ionic->dev_cmd_lock);
>>>>>>>> +	ionic_dev_cmd_port_pause(idev, requested_pause);
>>>>>>>> +	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
>>>>>>>> +	mutex_unlock(&ionic->dev_cmd_lock);
>>>>>>>> +	if (err)
>>>>>>>> +		return err;
>>>>>>> Hi Shannon
>>>>>>>
>>>>>>> I've no idea what the firmware black box is doing, but this looks
>>>>>>> wrong.
>>>>>>>
>>>>>>> pause->autoneg is about if the results of auto-neg should be used or
>>>>>>> not. If false, just configure the MAC with the pause settings and you
>>>>>>> are done. If the interface is being forced, so autoneg in general is
>>>>>>> disabled, just configure the MAC and you are done.
>>>>>>>
>>>>>>> If pause->autoneg is true and the interface is using auto-neg as a
>>>>>>> whole, you pass the pause values to the PHY for it to advertise and
>>>>>>> trigger an auto-neg. Once autoneg has completed, and the resolved
>>>>>>> settings are available, the MAC is configured with the resolved
>>>>>>> values.
>>>>>>>
>>>>>>> Looking at this code, i don't see any difference between configuring
>>>>>>> the MAC or configuring the PHY. I would expect pause->autoneg to be
>>>>>>> part of requested_pause somehow, so the firmware knows what is should
>>>>>>> do.
>>>>>>>
>>>>>>> 	Andrew
>>>>>> In this device there's actually very little the driver can do to directly
>>>>>> configure the mac or phy besides passing through to the firmware what the
>>>>>> user has requested - that happens here for the pause values, and in
>>>>>> ionic_set_link_ksettings() for autoneg.  The firmware is managing the port
>>>>>> based on these requests with the help of internally configured rules defined
>>>>>> in a customer setting.
>>>>> I get that. But the firmware needs to conform to what Linux
>>>>> expects. And what i see here does not conform. That is why i gave a
>>>>> bit of detail in my reply.
>>>>>
>>>>> What exactly does the firmware do? Once we know that, we can figure
>>>>> out when the driver should return -EOPNOTSUPP because of firmware
>>>>> limitations, and what it can configure and should return 0.
>>>> Because this is fairly smart FW, it handles this as expected.  I can add
>>>> this as another comment in the code.
>>> Hi Shannon
>>>
>>> Looking at the code, i don't see how it can handle this
>>> correctly. Please look at my comments, particularly the meaning of
>>> pause->autoneg and describe how the firmware does the right thing,
>>> given what information it is passed.
>>>
>> I guess I'm not sure how much better I can answer your question. Like
>> several other devices, we don't support selecting pause->autoneg.  The
>> firmware manages the PHY itself, the driver doesn't have direct access to
>> the PHY.  The driver passes the tx and rx pause info down to the firmware in
>> a command request.  The NIC firmware does an autoneg if autoneg is enabled
>> on the port.
> Hi Shannon
>
> Thanks. That was the information i was looking for.
>
> Please return -EOPNOTSUPP if pause->autoneg indicates autoneg results
> should not be used. Your firmware does not support it, so the driver
> should error out. Also the get function should use a hard coded value
> for pause->autoneg.
>
> If you ever fix your firmware, you can add full support for pause
> configuration.
>
>

Thanks for the help,
sln

