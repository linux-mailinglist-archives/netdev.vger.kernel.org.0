Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C866D281
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 19:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731025AbfGRRF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 13:05:27 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38685 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbfGRRF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 13:05:27 -0400
Received: by mail-pg1-f195.google.com with SMTP id f5so4344185pgu.5
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 10:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ZkiQOHmYUObE+u6mkiyP2PutKnbl79cKWj9HJ94HFDs=;
        b=RrsZHuq4lSB33+yf9ovhxAhCvuUp2Ww9xPmCXPIuZA5g1OIsnOgDSSxcldDS6cZ6f3
         YblAb63OeFSxM57v7Q4AThZzzgsLcoFiHUGq910CKdLtd04oV48N7P3p9u19E+1porsG
         tgz9nfNciTlW+dqUp4csjFe997fCDL0fUXmLC+/m6chiP40EtBeMTp5UnNB98/cXzevC
         kn+QCYqySuSY0wVzmc0xWuJsa64orAN4W5y2Vt7X82rP2VdXsHEocXvp9sqqbUM8C6tl
         rGVrsIwdOngTfCqEBT1ZRq5C28b65ZJRn2AKWa1b4vNSFXG4/SDzVM6ZehWxfm6rkZuz
         21cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZkiQOHmYUObE+u6mkiyP2PutKnbl79cKWj9HJ94HFDs=;
        b=IgbGYkIC85UM+oM6XQT51id+hlBAv+X6QIvG9oP5IDz3lQSnTYbdmF5Q2yD0UPU9eV
         se5dWH8zp4acHePEuzQgotzpAUBN4JlxX97r8VoaSYO6sKCtA6V1sDNMYE0IivkqcxUl
         VrH4fyGlvHQadH+cgw9hxICLQOg3swgJYbFmB3DCC+ri7ZdphD30tgvnkrDFtoo4FYgq
         FplpYNhTa/Qsev+wA3lcAqVZDgjtOw4sM5ACWdiTOaMK5vMujkL9irn5vFj311206qBh
         P2wTRF3PKp9QxvnclLGN0AAGufZRObnEmRTIBYWDJDEWt6xdA2sO2FgpOQqrBOMg+oDO
         dAYg==
X-Gm-Message-State: APjAAAWMNc8GFYiE9Ml40Aq+SoweVTtAUhbXPzP8XTckfe3tyW4CpH0i
        IJ7WFHS4z0kpOp01lVck1ShnG4xq0Cs=
X-Google-Smtp-Source: APXvYqwCD+wgtBX1v7ygLXwxHQEr7USnPBssZrxQsRqZOaDIzEfu/JfY1ai5eRQ1Uog897/VDX6+Eg==
X-Received: by 2002:a65:620a:: with SMTP id d10mr3368872pgv.8.1563469526062;
        Thu, 18 Jul 2019 10:05:26 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id br18sm23435699pjb.20.2019.07.18.10.05.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 10:05:25 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io> <20190709022703.GB5835@lunn.ch>
 <649f7e96-a76b-79f0-db25-d3ce57397df5@pensando.io>
 <20190718032137.GG6962@lunn.ch>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <35761cbb-aa2d-d698-7368-6ebe25607fe0@pensando.io>
Date:   Thu, 18 Jul 2019 10:05:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190718032137.GG6962@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/17/19 8:21 PM, Andrew Lunn wrote:
> On Tue, Jul 09, 2019 at 03:42:39PM -0700, Shannon Nelson wrote:
>> On 7/8/19 7:27 PM, Andrew Lunn wrote:
>>>> +static int ionic_get_module_eeprom(struct net_device *netdev,
>>>> +				   struct ethtool_eeprom *ee,
>>>> +				   u8 *data)
>>>> +{
>>>> +	struct lif *lif = netdev_priv(netdev);
>>>> +	struct ionic_dev *idev = &lif->ionic->idev;
>>>> +	struct xcvr_status *xcvr;
>>>> +	u32 len;
>>>> +
>>>> +	/* copy the module bytes into data */
>>>> +	xcvr = &idev->port_info->status.xcvr;
>>>> +	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
>>>> +	memcpy(data, xcvr->sprom, len);
>>> Hi Shannon
>>>
>>> This also looks odd. Where is the call into the firmware to get the
>>> eeprom contents? Even though it is called 'eeprom', the data is not
>>> static. It contains real time diagnostic values, temperature, transmit
>>> power, receiver power, voltages etc.
>> idev->port_info is a memory mapped space that the device keeps up-to-date.
> Hi Shannon
>
> It at least needs a comment. How frequently does the device update
> this chunk of memory? It would be good to comment about that as
> well. Or do MMIO reads block while i2c operations occur to update the
> memory?

The device keeps this updated when changes happen internally so that 
there is no need to block on MMIO read.  Sure, I'll add a little more 
commentary here and perhaps in a couple other similar places.

>
>>>> +
>>>> +	dev_dbg(&lif->netdev->dev, "notifyblock eid=0x%llx link_status=0x%x link_speed=0x%x link_down_cnt=0x%x\n",
>>>> +		lif->info->status.eid,
>>>> +		lif->info->status.link_status,
>>>> +		lif->info->status.link_speed,
>>>> +		lif->info->status.link_down_count);
>>>> +	dev_dbg(&lif->netdev->dev, "  port_status id=0x%x status=0x%x speed=0x%x\n",
>>>> +		idev->port_info->status.id,
>>>> +		idev->port_info->status.status,
>>>> +		idev->port_info->status.speed);
>>>> +	dev_dbg(&lif->netdev->dev, "    xcvr status state=0x%x phy=0x%x pid=0x%x\n",
>>>> +		xcvr->state, xcvr->phy, xcvr->pid);
>>>> +	dev_dbg(&lif->netdev->dev, "  port_config state=0x%x speed=0x%x mtu=0x%x an_enable=0x%x fec_type=0x%x pause_type=0x%x loopback_mode=0x%x\n",
>>>> +		idev->port_info->config.state,
>>>> +		idev->port_info->config.speed,
>>>> +		idev->port_info->config.mtu,
>>>> +		idev->port_info->config.an_enable,
>>>> +		idev->port_info->config.fec_type,
>>>> +		idev->port_info->config.pause_type,
>>>> +		idev->port_info->config.loopback_mode);
>>> It is a funny place to have all the debug code.
>> Someone wanted a hook for getting some link info on the fly on request.
> I would suggest deleting it all. Most of it is already available via
> ethtool.
>
Sure.

sln

