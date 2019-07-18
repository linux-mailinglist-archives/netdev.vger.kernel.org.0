Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF346D343
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 19:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfGRRya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 13:54:30 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44902 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbfGRRya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 13:54:30 -0400
Received: by mail-pg1-f193.google.com with SMTP id i18so13230071pgl.11
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 10:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=bExNOHQBiq6aT+nLI4HUGBEtXMJq/eogr4ly3MVyxWg=;
        b=xSz+TP498AP138xRbdhD3Mr55wqrvECu4A3jINNozBMV61dyyBnKC1GddbBKzsTndU
         lDhg3SMgVarvrMSM96jpt6tHct6KRsDDhrDO6ht/d+1dsNwCDyA6A+s2sjSqa7WQfcWi
         waZCmE0UAFBmNZoKfTBnW9WzGrl1HhkFOMDAd+DgjuUkU6AIxVGOYDzAaZ49QfIMqDco
         efeTWUgiTjkiP66ugRrnMe8kJ6QH7bsiAmNcOWlVokqZ1f9R7bZ03NMu/UJAfXHpSHpU
         OgJc7GFdy4uHAYPYYFKVgxTE/8NEU8MRdg3Dkzk6HEnJVGuYZR6zaS8+BdK5odm9zWkJ
         ynag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=bExNOHQBiq6aT+nLI4HUGBEtXMJq/eogr4ly3MVyxWg=;
        b=Yz9WIhWLjLVnYTnJ8Er9kh5L7lXbIs43EDWbZ9e02hyqCBeBxE8+mJPPM6Ue41V19S
         bQEdOXwgmOJPE+t/VUKbT7p4CcnbX76nOSFsJSqu4QkuKXOAqWIiRHJjinjarCDed2as
         Acc+DOHubaOxwniDhuhwoI+qLTAKAfO3tcXf1VzBlqhM1EuVIZbqGPqRK7Xhwv6CnuZr
         cH2QHJJ5iZYwj9Bs8Fzel0jnYzuCYD2dH5R+151iB21NHuSuOR8L6Ze2GkQ+EoQCai3A
         oCAwOJVGZAOq+C7ufC5+cBF0+4HWaZiZWY4/6VB0y+YXEKVKiuKPyhosYcfx2MqircI9
         ZA8w==
X-Gm-Message-State: APjAAAVDlugBl9EuGB+Rp09/EUJ6f/EyKnqXo8DTb3FpooGsVUwJrRjf
        wAvN472z4y3oDghTgpVQEQpdR91Jh30=
X-Google-Smtp-Source: APXvYqwbPLaEESnvyvS4DESY+Axtq80FKwHVkGLl/t+2NZlLhGkyl2UPiaIktc5I1U4EkZWSaSV45w==
X-Received: by 2002:a63:6f41:: with SMTP id k62mr2995437pgc.32.1563472469409;
        Thu, 18 Jul 2019 10:54:29 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id bo20sm21175148pjb.23.2019.07.18.10.54.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 10:54:28 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io> <20190709022703.GB5835@lunn.ch>
 <649f7e96-a76b-79f0-db25-d3ce57397df5@pensando.io>
 <20190718032137.GG6962@lunn.ch>
 <35761cbb-aa2d-d698-7368-6ebe25607fe0@pensando.io>
 <20190718172823.GH25635@lunn.ch>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <5a131da9-d7cf-a477-e622-783f14c8e385@pensando.io>
Date:   Thu, 18 Jul 2019 10:54:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190718172823.GH25635@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/18/19 10:28 AM, Andrew Lunn wrote:
> On Thu, Jul 18, 2019 at 10:05:23AM -0700, Shannon Nelson wrote:
>> On 7/17/19 8:21 PM, Andrew Lunn wrote:
>>> On Tue, Jul 09, 2019 at 03:42:39PM -0700, Shannon Nelson wrote:
>>>> On 7/8/19 7:27 PM, Andrew Lunn wrote:
>>>>>> +static int ionic_get_module_eeprom(struct net_device *netdev,
>>>>>> +				   struct ethtool_eeprom *ee,
>>>>>> +				   u8 *data)
>>>>>> +{
>>>>>> +	struct lif *lif = netdev_priv(netdev);
>>>>>> +	struct ionic_dev *idev = &lif->ionic->idev;
>>>>>> +	struct xcvr_status *xcvr;
>>>>>> +	u32 len;
>>>>>> +
>>>>>> +	/* copy the module bytes into data */
>>>>>> +	xcvr = &idev->port_info->status.xcvr;
>>>>>> +	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
>>>>>> +	memcpy(data, xcvr->sprom, len);
>>>>> Hi Shannon
>>>>>
>>>>> This also looks odd. Where is the call into the firmware to get the
>>>>> eeprom contents? Even though it is called 'eeprom', the data is not
>>>>> static. It contains real time diagnostic values, temperature, transmit
>>>>> power, receiver power, voltages etc.
>>>> idev->port_info is a memory mapped space that the device keeps up-to-date.
>>> Hi Shannon
>>>
>>> It at least needs a comment. How frequently does the device update
>>> this chunk of memory? It would be good to comment about that as
>>> well. Or do MMIO reads block while i2c operations occur to update the
>>> memory?
>> The device keeps this updated when changes happen internally so that there
>> is no need to block on MMIO read.
> Hi Shannon
>
> I'm thinking about the diagnostic page. RX and TX power, temperature,
> alarms etc. These are real time values, so you should read them on
> demand, or at last only cache them for a short time.
>
>

They *are* read on demand.  The port_info and lif_info structs are dma 
mapped spaces that the device keeps up-to-date with PCI writes in the 
background so that the driver can do a quick memory read for current data.

sln

