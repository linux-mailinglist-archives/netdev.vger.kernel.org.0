Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C31763DEC
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 00:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfGIWlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 18:41:44 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37672 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbfGIWln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 18:41:43 -0400
Received: by mail-pl1-f193.google.com with SMTP id b3so130229plr.4
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 15:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=oquXujVVj/mA9mt07aD6iftZk12o/ePyte82wqTKuY8=;
        b=Za1jc4PQLZ9FUSzxX/T4uv22AhClfzpLH+IU7XM9/xrdOn2Bln9x+X1mU18BWtOCYs
         idMqaximlJwfjZnGEE8ESBUMFpvGEjg2qsOXolOJAleB+JKGJSrCxnkm6o0KIGhaYewf
         KMqIB5+hCNBQOdjALo3xdkB0+w9jWnyuaupHugT0bzuo+2qPWZHfZKE0oGpB9FdbxPfn
         7MqItJffixdDBz2zJ7YuNbcAYpJW4nushGpAoyl/1gz55AKpnGycbRxNQV0N7hajt+qh
         1ezGj+jdIqRWc/eZS1uZg5UIrifNNLzy54aTxC5H2KDMZt92n7mgTsugQMEXO0EY10NR
         dCxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oquXujVVj/mA9mt07aD6iftZk12o/ePyte82wqTKuY8=;
        b=PSSM0U+vRMS6jsl5nL410rPm0h16+RuI9vHdpWa5UhGo3hyTq3NFg3BElKMRMA9UGS
         Ctxgu/xwOZc4WnubJd04GKx4+XuP9Y4PTz79q2nFC3ifIHfiL1Kt0xzqFWDpvxnh3+nk
         /pm/Izb1WdXzqyRnQitiXxnBeQYpibRP0os3UD2O0dVPBMyFWPn6rQ2Rq4GmmEBf3VPM
         Ea9OHnLrzA3B2RIwPepOuTswK2/JZD6ULmjsMeCHPIOepl2BgqCB3n/PWlOBZlmh7fpB
         dTYmgeOlDMQPZOUsZlHHa0diFIwMeTmcfIK0GiJ0I1O9vFZqaZvqGrWTncimb+NWWBmk
         JXlw==
X-Gm-Message-State: APjAAAVioQygmE1/gNL6tb4F/814w6YXJpYqcqVDhzUQdlOyTTc0ax75
        +ipBRtSZDHU1pEfg9WxYLopIdJBSW78=
X-Google-Smtp-Source: APXvYqybzbaNCD8X20r1IBv8mjW9wrgZFf2UfpmJVxwIqUgqQ7mJHxAw5HEQTXLnwFTb7G6CsOCCug==
X-Received: by 2002:a17:902:2865:: with SMTP id e92mr34379662plb.264.1562712102886;
        Tue, 09 Jul 2019 15:41:42 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id m10sm92568pgq.67.2019.07.09.15.41.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 15:41:42 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io> <20190709022703.GB5835@lunn.ch>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <649f7e96-a76b-79f0-db25-d3ce57397df5@pensando.io>
Date:   Tue, 9 Jul 2019 15:42:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190709022703.GB5835@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/19 7:27 PM, Andrew Lunn wrote:
>> +static int ionic_get_module_eeprom(struct net_device *netdev,
>> +				   struct ethtool_eeprom *ee,
>> +				   u8 *data)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +	struct ionic_dev *idev = &lif->ionic->idev;
>> +	struct xcvr_status *xcvr;
>> +	u32 len;
>> +
>> +	/* copy the module bytes into data */
>> +	xcvr = &idev->port_info->status.xcvr;
>> +	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
>> +	memcpy(data, xcvr->sprom, len);
> Hi Shannon
>
> This also looks odd. Where is the call into the firmware to get the
> eeprom contents? Even though it is called 'eeprom', the data is not
> static. It contains real time diagnostic values, temperature, transmit
> power, receiver power, voltages etc.

idev->port_info is a memory mapped space that the device keeps up-to-date.

>
>> +
>> +	dev_dbg(&lif->netdev->dev, "notifyblock eid=0x%llx link_status=0x%x link_speed=0x%x link_down_cnt=0x%x\n",
>> +		lif->info->status.eid,
>> +		lif->info->status.link_status,
>> +		lif->info->status.link_speed,
>> +		lif->info->status.link_down_count);
>> +	dev_dbg(&lif->netdev->dev, "  port_status id=0x%x status=0x%x speed=0x%x\n",
>> +		idev->port_info->status.id,
>> +		idev->port_info->status.status,
>> +		idev->port_info->status.speed);
>> +	dev_dbg(&lif->netdev->dev, "    xcvr status state=0x%x phy=0x%x pid=0x%x\n",
>> +		xcvr->state, xcvr->phy, xcvr->pid);
>> +	dev_dbg(&lif->netdev->dev, "  port_config state=0x%x speed=0x%x mtu=0x%x an_enable=0x%x fec_type=0x%x pause_type=0x%x loopback_mode=0x%x\n",
>> +		idev->port_info->config.state,
>> +		idev->port_info->config.speed,
>> +		idev->port_info->config.mtu,
>> +		idev->port_info->config.an_enable,
>> +		idev->port_info->config.fec_type,
>> +		idev->port_info->config.pause_type,
>> +		idev->port_info->config.loopback_mode);
> It is a funny place to have all the debug code.

Someone wanted a hook for getting some link info on the fly on request.

sln

>
>     Andrew

