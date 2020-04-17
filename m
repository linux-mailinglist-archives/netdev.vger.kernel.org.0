Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6573F1ADD5D
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 14:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgDQMdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 08:33:12 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:46091 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbgDQMdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 08:33:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587126791; x=1618662791;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=KoXqWzqYq/w2d+HZn8byhgpTiDLf6r5C2Ybuny75IaM=;
  b=lEkRi338fpxiPrzC9aJzRjUyPBe7RecCPnaXou8o50KgDn+7o+3uM+0G
   WSwSeQwyXW+AszRtYdQjG5Iny+kM6zIy40CwydmikGvFy2ljmdc+poBMT
   gp4XRrMfDGNtcdYpTRhInq2pHfG0VcKYtI50rqDEODEae9um0Valbo5cC
   wU+uB4SYniFp/DSGFOseJkkdY3lO+Qk8jv2GFIcZfcheV6nbl7gwn5KsV
   DAJ2las9SXssP+ruEbrWP1AY+Q67TogET2zY2VfnEgIQct9pOXKvZ1LZq
   kvhoeKwxSm88+skr6Kq8umRfYNKOozQZZX5Uisbo1yPzcgey8kHvwZFYZ
   A==;
IronPort-SDR: gWqIczFLyA96iDGpH5JnlYbjBaosq3zeGhSGMYW1MpmLw6wBaKd/m5lzsnC5A5lxqflsMkBCcl
 iK3RqGgR+ZruiKh3p0qZfV+wvJTGOrxpeOi9iag8qESRYzg2gs/CxlvksC7ml19M6F1iGRXOpa
 nd+76P8dKowiZQG9+x5WTbDs5pggHwxnCKqxAVlqgnhIbOPr3JYqNOI0fYG9beh4qv/8dkYCkD
 COoII3vOvnVHdONyprH1PlugE6r8DyEwdj1OSQ1yPjbWyp62/+406rTyTtTNE1tsmvbEtnvmp8
 eNc=
X-IronPort-AV: E=Sophos;i="5.72,395,1580799600"; 
   d="scan'208";a="9534003"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Apr 2020 05:33:10 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 17 Apr 2020 05:33:10 -0700
Received: from [10.205.29.56] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Fri, 17 Apr 2020 05:32:45 -0700
Subject: Re: [PATCH 1/5] net: macb: fix wakeup test in runtime suspend/resume
 routines
To:     Harini Katakam <harinik@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "pthombar@cadence.com" <pthombar@cadence.com>,
        "sergio.prado@e-labworks.com" <sergio.prado@e-labworks.com>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Michal Simek <michals@xilinx.com>,
        Rafal Ozieblo <rafalo@cadence.com>
References: <cover.1587058078.git.nicolas.ferre@microchip.com>
 <eba7f3605d6dcad37f875b2584d519cd6cae9fd1.1587058078.git.nicolas.ferre@microchip.com>
 <MW2PR02MB37706E6E182F19F278B35707C9D80@MW2PR02MB3770.namprd02.prod.outlook.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <ba239f44-b3e4-723e-ad3d-3fbb90e8bfc1@microchip.com>
Date:   Fri, 17 Apr 2020 14:33:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <MW2PR02MB37706E6E182F19F278B35707C9D80@MW2PR02MB3770.namprd02.prod.outlook.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/04/2020 at 20:26, Harini Katakam wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Hi Nicolas,
> 
>> -----Original Message-----
>> From: nicolas.ferre@microchip.com [mailto:nicolas.ferre@microchip.com]
>> Sent: Thursday, April 16, 2020 11:14 PM
>> To: linux-arm-kernel@lists.infradead.org; netdev@vger.kernel.org; Claudiu
>> Beznea <claudiu.beznea@microchip.com>; Harini Katakam
>> <harinik@xilinx.com>
>> Cc: linux-kernel@vger.kernel.org; David S. Miller <davem@davemloft.net>;
>> Alexandre Belloni <alexandre.belloni@bootlin.com>; pthombar@cadence.com;
>> sergio.prado@e-labworks.com; antoine.tenart@bootlin.com;
>> f.fainelli@gmail.com; linux@armlinux.org.uk; andrew@lunn.ch; Michal Simek
>> <michals@xilinx.com>; Nicolas Ferre <nicolas.ferre@microchip.com>; Rafal
>> Ozieblo <rafalo@cadence.com>
>> Subject: [PATCH 1/5] net: macb: fix wakeup test in runtime suspend/resume
>> routines
>>
>> From: Nicolas Ferre <nicolas.ferre@microchip.com>
>>
>> Use the proper struct device pointer to check if the wakeup flag and wakeup
>> source are positioned.
>> Use the one passed by function call which is equivalent to &bp->dev-
>>> dev.parent.
>>
>> It's preventing the trigger of a spurious interrupt in case the Wake-on-Lan
>> feature is used.
> 
> Sorry I have some mail issues; meant to reply earlier.
> Tested patches 1, 2, 3 in this set and they work for me.

Brilliant! Thanks for the feedback.

> I'll try patch 4; it looks similar to what I'm using locally but I'll add whatever
> tie-off queue handling is required on top of your series, thanks.

Alright, I'll hold my v2 for a few days then. Thanks. Best regards,
   Nicolas


-- 
Nicolas Ferre
