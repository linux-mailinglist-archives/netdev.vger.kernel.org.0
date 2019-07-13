Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 038DD67890
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 07:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfGMFPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 01:15:30 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36617 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbfGMFP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 01:15:29 -0400
Received: by mail-pg1-f196.google.com with SMTP id l21so5446292pgm.3
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 22:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=BPtONmHqfqyqkhuifonJaqe+cnoqeMMEfRqzTJc3H2Y=;
        b=yxijRyUhwOfVDW+jiXpLq9ZCPUWk6u/j0UaGjQPqM2w7vKngYl7N9R9BhpIipd2Xvw
         g6gyR+AC2pdQwi8mz8CWzlr8cHt+BTqezknCmetqTE2VTyu3C1cj33H26zmoU06SSBwK
         Ze6Idfk376MA2k3lcGi5Y0K8DobzUEYrSpAXpc8ayxSK4JKSIyL6opqg2gt7uYs3KEt/
         4M1I8wtEnAzWMFP6WuXLplICPwevAnAf//Qcupnm0XJm8OUl19NVYMPxjzF38TxKI6kF
         hTlKI0s0t0Dw3RbdSXeFDJZszJBkxJ/BydNWT86Q1kiovd81xALY0Bg0uBBG1wmjvuTo
         CEFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=BPtONmHqfqyqkhuifonJaqe+cnoqeMMEfRqzTJc3H2Y=;
        b=OIAQwwAo3KFnRotz80nCFqca0rv7MdbaOvAAxp6qKVL9vfv3ornFfrWHUA1vQpDSQ1
         yEvxqVGUOL036zhB2Ao26IdxOK5u1HTKoHxxVj2MzV4IPjNGJ9GT0NjQk52NcJkV33/f
         WdUQaDM2rOHeSFhDVod6T3rmW0JqGasXgGBHG/NBY1Uup/d9kUI9WbVRYH7aVUlyZVk9
         ZaD7Gc6rVYQesq3Uwpf7Py0x8LAUMrHB7LpeaKCItx2ow16aO/SDDHrNk7rPxAsFkqA2
         FQZXn6aqM5Ku3QoN4zDTvXZwGFMK6YuKoZRJrEDzBGKRPsQcbU0WMcmgWSPGeqfzu0jX
         vPtA==
X-Gm-Message-State: APjAAAW2VmMCEF6V1HYqCb3X8RTcYXq7ez3JBre7c255je7X0hW2FRrm
        Bp0CGUU84k3G0OqZAXbkgEgAeR4/Kuk=
X-Google-Smtp-Source: APXvYqwZEoPlQXhXr/eDP87ub1BAR0Snv4Z5sut2B5YS90XGcor2VARTMk88V6D3453+C0Ew62u98g==
X-Received: by 2002:a17:90a:710c:: with SMTP id h12mr16094122pjk.36.1562994928906;
        Fri, 12 Jul 2019 22:15:28 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id p19sm14138218pfn.99.2019.07.12.22.15.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 22:15:28 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io> <20190709021426.GA5835@lunn.ch>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <10c66ecf-6d67-d206-b496-6f8139f218a8@pensando.io>
Date:   Fri, 12 Jul 2019 22:16:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190709021426.GA5835@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/19 7:14 PM, Andrew Lunn wrote:
>> +static int ionic_set_pauseparam(struct net_device *netdev,
>> +				struct ethtool_pauseparam *pause)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +	struct ionic *ionic = lif->ionic;
>> +	struct ionic_dev *idev = &lif->ionic->idev;
>> +
>> +	u32 requested_pause;
>> +	u32 cur_autoneg;
>> +	int err;
>> +
>> +	cur_autoneg = idev->port_info->config.an_enable ? AUTONEG_ENABLE :
>> +								AUTONEG_DISABLE;
>> +	if (pause->autoneg != cur_autoneg) {
>> +		netdev_info(netdev, "Please use 'ethtool -s ...' to change autoneg\n");
>> +		return -EOPNOTSUPP;
>> +	}
>> +
>> +	/* change both at the same time */
>> +	requested_pause = PORT_PAUSE_TYPE_LINK;
>> +	if (pause->rx_pause)
>> +		requested_pause |= IONIC_PAUSE_F_RX;
>> +	if (pause->tx_pause)
>> +		requested_pause |= IONIC_PAUSE_F_TX;
>> +
>> +	if (requested_pause == idev->port_info->config.pause_type)
>> +		return 0;
>> +
>> +	idev->port_info->config.pause_type = requested_pause;
>> +
>> +	mutex_lock(&ionic->dev_cmd_lock);
>> +	ionic_dev_cmd_port_pause(idev, requested_pause);
>> +	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
>> +	mutex_unlock(&ionic->dev_cmd_lock);
>> +	if (err)
>> +		return err;
> Hi Shannon
>
> I've no idea what the firmware black box is doing, but this looks
> wrong.
>
> pause->autoneg is about if the results of auto-neg should be used or
> not. If false, just configure the MAC with the pause settings and you
> are done. If the interface is being forced, so autoneg in general is
> disabled, just configure the MAC and you are done.
>
> If pause->autoneg is true and the interface is using auto-neg as a
> whole, you pass the pause values to the PHY for it to advertise and
> trigger an auto-neg. Once autoneg has completed, and the resolved
> settings are available, the MAC is configured with the resolved
> values.
>
> Looking at this code, i don't see any difference between configuring
> the MAC or configuring the PHY. I would expect pause->autoneg to be
> part of requested_pause somehow, so the firmware knows what is should
> do.
>
> 	Andrew

In this device there's actually very little the driver can do to 
directly configure the mac or phy besides passing through to the 
firmware what the user has requested - that happens here for the pause 
values, and in ionic_set_link_ksettings() for autoneg.  The firmware is 
managing the port based on these requests with the help of internally 
configured rules defined in a customer setting.

sln

