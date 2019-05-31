Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D67A31078
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 16:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfEaOqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 10:46:37 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33332 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfEaOqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 10:46:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id d9so6744060wrx.0
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 07:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rZQYx0sfOVBJiI82TzgbbG1aRSIvbp+SnVQCCJZ93hw=;
        b=QYGMBdN818EmjHtrdbUl0XCnQUYiP0fByvbx1zL9Y1SQtNn6v20CYW3ULe9PxnaWHW
         pIKwtkBxoGZOyBBjymUaQZIbV3sMpohGadFozqFsq1z4J5kkyMaVJe15IKej0tN5lfCi
         74zjjmlT1ywTLDy+0PksZp77KtFdLNUlru05b8Sw2Bivk0Q3dZovt6qqIq3d0RfFKShy
         ZUoVLisIQ6T7B0qja4i58lXlIPKk7alsZOsz7Li+QkPDhvyH8Mi7sBoie+Dz1zYOTyL9
         xcHxIXKGvbmIriEwtqnKnbMsqk0VfWUGQuSKwUnsknqkMIEIs1aml3jtSmIc+/l+oX/U
         teRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rZQYx0sfOVBJiI82TzgbbG1aRSIvbp+SnVQCCJZ93hw=;
        b=jp3m3mywPcDcGXlgQsT9DNGibLgcGDjqEOx+L5Qk1gMZw/170h4ujZgT0Bj4e68vv7
         JiAn2MFoLpVCTDrN88dv/dkYHzSnW6T8wjMaG4W04c/7ArP+oUDvxYmvbMX+I+Wp5K+k
         TwCo1JEW6MLa4luYHIjxGxNxHjee+HcGVWSzY7eAqSIlqVPRn+52D4CPKf8f4FC45Bk/
         jG9ati77I0SMcjmMDT2DuOkQgWwh3oagDkpfiMrcQ3q4HOr4/D+NXhftWJkz7to1fpyg
         SnX1U1UeDwiGueX7M3JJHH6/n3rjUOfgvEezUJX/09aKsN5GwRGeZo6a/mLOI9rmxVHH
         hr+g==
X-Gm-Message-State: APjAAAVSZcEANRoAF5iHgpa6R2KYXw3hSuAcqO3+AF9ook+LbfJT6Cl+
        v2K3OAlP8QemTZxtdFiY5aN6uQ==
X-Google-Smtp-Source: APXvYqyscR5zODXGlLGwvT+mCTgGS4EvmpPkRdYWrdiJnzEhPlaSI775Dh9vceu9TUIV8sutdX8+Bg==
X-Received: by 2002:adf:eb45:: with SMTP id u5mr4332044wrn.38.1559313992677;
        Fri, 31 May 2019 07:46:32 -0700 (PDT)
Received: from [192.168.112.17] (nikaet.starlink.ru. [94.141.168.29])
        by smtp.gmail.com with ESMTPSA id c2sm3206840wrf.75.2019.05.31.07.46.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 07:46:31 -0700 (PDT)
Subject: Re: [PATCH] net: dsa: mv88e6xxx: avoid error message on remove from
 VLAN 0
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <marek.behun@nic.cz>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
References: <20190531073514.2171-1-nikita.yoush@cogentembedded.com>
 <20190531103105.GE23464@t480s.localdomain> <20190531143758.GB23821@lunn.ch>
From:   Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Message-ID: <422482dc-8887-0f92-c8c9-f9d639882c77@cogentembedded.com>
Date:   Fri, 31 May 2019 17:46:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190531143758.GB23821@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



31.05.2019 17:37, Andrew Lunn wrote:
>> I'm not sure that I like the semantic of it, because the driver can actually
>> support VID 0 per-se, only the kernel does not use VLAN 0. Thus I would avoid
>> calling the port_vlan_del() ops for VID 0, directly into the upper DSA layer.
>>
>> Florian, Andrew, wouldn't the following patch be more adequate?
>>
>>     diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>>     index 1e2ae9d59b88..80f228258a92 100644
>>     --- a/net/dsa/slave.c
>>     +++ b/net/dsa/slave.c
>>     @@ -1063,6 +1063,10 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
>>             struct bridge_vlan_info info;
>>             int ret;
>>      
>>     +       /* VID 0 has a special meaning and is never programmed in hardware */
>>     +       if (!vid)
>>     +               return 0;
>>     +
>>             /* Check for a possible bridge VLAN entry now since there is no
>>              * need to emulate the switchdev prepare + commit phase.
>>              */
>  
> Hi Vivien
> 
> If we put this in rx_kill_vid, we should probably have something
> similar in rx_add_vid, just in case the kernel does start using VID 0.

Kernel currently does, but it is caught in
mv88e6xxx_port_check_hw_vlan() and returns -ENOTSUPP from there.
