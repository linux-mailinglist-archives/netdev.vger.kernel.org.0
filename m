Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A659265FE3
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 21:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbfGKTJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 15:09:36 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41570 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728394AbfGKTJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 15:09:36 -0400
Received: by mail-pl1-f196.google.com with SMTP id m9so3491169pls.8
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 12:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=M4WeZcWrGd18YeXjzMUXq9YEJOlHeqxtQB8+6/gTd3s=;
        b=bef+xSvFmTUnEIzeZ36IHCRoL6XCUCNflOIQxs+rUuZ04HcQuOvIb0ydjSjbVCgLYm
         UG3/+XUu1xWVm9+7PUBHK9bmDFm7vdr9OZkLWMilxvkqRhVSC1+P10BEAKuqy+YdMm5A
         e6wo5cK+Ip1jW5VgBGsbScH4niAMV/rlKZNQ8tKlCdxwvNOc9Oky8HGnHJFa63vnfKWU
         UAKgttk/dzTqNR6egglCZobN9SkYuf/S+8/e/1coPvXwmShAp5CaW/2SQQTkk7/Wd9tc
         A0bySatQa4Rzqfz6SM+mTl/dq2RI3oXCBQCvhe9nd0WBwjluK7I3RjDmqgDYT8o7cyXv
         jThw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=M4WeZcWrGd18YeXjzMUXq9YEJOlHeqxtQB8+6/gTd3s=;
        b=XTmLudnY+jYaj7NyMmYQ0YutNPFdRfDDwPHrQxViV5wq0yIbvV/EYWQQNJQ7AeplgN
         0GX0rj/NgzNAGOODGlSZAgbExybWyfjnslmV+fU5tcZzhC7g4PTWVR4KNDIhUBbqhX2b
         5JA/R7m5Pt9RykjJ1HfO7X/Nd1hKaGHYafq8bgybXajZgXjkZ93BOdfNSCT90J3U+hem
         6XKfNdhEFme1oct/DOYZxfZ2B8jhxh9OhACBr0s3kCvxZ8se+8wuBnCQRRXTM6yj5fAN
         aeuDJdQeGmZz/dul+6sCkOkSrupRD1Su5P8ZzwUlGJdGpYCY47oUnxH5ed4xL95Q6iF7
         D7Vw==
X-Gm-Message-State: APjAAAW+14kuduimAb+kbS8FnSEtC4LYl3XIybq3lLFnvyy0KftMdOwH
        QloXTmiyUnR1SZKKBABdhBmCydfRC30=
X-Google-Smtp-Source: APXvYqzzFrQQjv3Gr2VwW6cXI9Da6kjQWabirJSV4MFgqcSvaicBFnCfAhubiVMI5EWpJFcxVTu7KA==
X-Received: by 2002:a17:902:9a82:: with SMTP id w2mr6319109plp.291.1562872175609;
        Thu, 11 Jul 2019 12:09:35 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id c69sm8330896pje.6.2019.07.11.12.09.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 12:09:35 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io>
 <20190708220406.GB17857@lunn.ch>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <d81a0f1d-1051-3160-a9bc-dbbc645be857@pensando.io>
Date:   Thu, 11 Jul 2019 12:10:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708220406.GB17857@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/19 3:04 PM, Andrew Lunn wrote:

>> +	case XCVR_PID_SFP_10GBASE_ER:
>> +		ethtool_link_ksettings_add_link_mode(ks, supported,
>> +						     10000baseER_Full);
>> +		break;
> I don't know these link modes too well. But only setting a single bit
> seems odd. What i do know is that an SFP which supports 2500BaseX
> should also be able to support 1000BaseX. So should a 100G SFP also
> support 40G, 25G, 10G etc? The SERDES just runs a slower bitstream
> over the basic bitpipe?

Yes, but in this initial release we're not supporting changes to the 
modes yet.  That flexibility will come later.

>
>> +	case XCVR_PID_QSFP_100G_ACC:
>> +	case XCVR_PID_QSFP_40GBASE_ER4:
>> +	case XCVR_PID_SFP_25GBASE_LR:
>> +	case XCVR_PID_SFP_25GBASE_ER:
>> +		dev_info(lif->ionic->dev, "no decode bits for xcvr type pid=%d / 0x%x\n",
>> +			 idev->port_info->status.xcvr.pid,
>> +			 idev->port_info->status.xcvr.pid);
>> +		break;
> Why not add them?

Yes, this has been mentioned before.  I might in the future, but I have 
my hands full at the moment.

>
>
>> +	memcpy(ks->link_modes.advertising, ks->link_modes.supported,
>> +	       sizeof(ks->link_modes.advertising));
> bitmap_copy() would be a better way to do this. You could consider
> adding a helper to ethtool.h.

Sure.

Thanks for your comments, and sorry I haven't responded as quickly as 
I'd like... I'll be going through these and your other comments over the 
next few days.

sln


