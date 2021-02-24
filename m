Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4096323651
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 04:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbhBXDzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 22:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbhBXDzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 22:55:00 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9372C061574
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 19:54:20 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id f8so393085plg.5
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 19:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z6Osm67d2AArzPC4l7g8L8F3u9MJV7CFRNX7wp9hW0M=;
        b=RMXJv30qbbvsZIa4OvzbnMJYBB0lPYqQJU+DjWDbJOLmZ+vSrvkfITSBJ1uSDo4hq5
         cxHsosOVAUy+rLn18oP844KnEUFvTyj7tmllxitIr9SlYMyWb6ZyYM9MBYGABh2YlKiZ
         4TAVlVbAmCICO/IeEyDJv+tnAnpQIYsG9YnRrDKloFYm3IIvp92DyUGd8NKKt289qE2z
         lf0N2AElTnYQmZE4sNpqPXOp0HpObeoD5JTo060AVCLxwRq1LSBVtexJHsU5HvbW7Rci
         5bUgFri81rYhVy70Z9XJ7YQSu/cRZj1ggksmib8iQLW31OT7pi5Fk/V6KRyAbQmtPBxm
         Ho+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z6Osm67d2AArzPC4l7g8L8F3u9MJV7CFRNX7wp9hW0M=;
        b=qFJb5k0wpxlQo8puh8xb3SfhD6fHtcMCVG/874irdyKScSM9NPoKL7Yat02ZlU1iKs
         BYG+mFigx1WIjsM25FN79sZp9taEplIAtq/Vc0YbQL9TB41wLs210BzEgrp9yfhYGs5S
         EvHu44kCR9Gg38IhDtAz2YuYfCtXU+838VOv641JE2mK83Jgxt1wv+FveJ3Y/wWTTy0p
         NI+q4q1jzlgyQe87B0AflI0g3jyileTEKtVBepWLAFDVkm7lQHqd9ZjefD+M+nNIVi9u
         zVozdHSM6PNyjmDdfIFX0jQXed0gTN4csFSJtqF3FfMV+okJmIeH/hm68DnZqyfFZCIQ
         g62g==
X-Gm-Message-State: AOAM532SF+cCNqCiflZsS4WYfswjsXfbcxNdBiBtlZAVjBKHCZe7hLsS
        wTDYMW4TDtayA94EG/bqGT1tSv8/cjY=
X-Google-Smtp-Source: ABdhPJx664keH0eNG8WD+Esloclnep7U3fTtF/Von1mrzq3LRhnFtJtJ+66RMfwp9e6iqKbuOdfwMg==
X-Received: by 2002:a17:902:ed8d:b029:e2:b3fb:ca95 with SMTP id e13-20020a170902ed8db02900e2b3fbca95mr30033525plj.17.1614138860255;
        Tue, 23 Feb 2021 19:54:20 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 11sm438540pgz.22.2021.02.23.19.54.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 19:54:19 -0800 (PST)
Subject: Re: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
 <20210223084503.34ae93f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DB8PR04MB6795925488C63791C2BD588EE69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210223175441.2a1b86f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DB8PR04MB6795663DB5336C8BDB16A159E69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210223183438.0984bc20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DB8PR04MB6795C1D02AAB9F01571AFED9E69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7866cb18-b50e-7e1f-545a-86f4678f868b@gmail.com>
Date:   Tue, 23 Feb 2021 19:54:17 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB6795C1D02AAB9F01571AFED9E69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/23/2021 6:47 PM, Joakim Zhang wrote:
> 
>> -----Original Message-----
>> From: Jakub Kicinski <kuba@kernel.org>
>> Sent: 2021Äê2ÔÂ24ÈÕ 10:35
>> To: Joakim Zhang <qiangqing.zhang@nxp.com>
>> Cc: peppe.cavallaro@st.com; alexandre.torgue@st.com;
>> joabreu@synopsys.com; davem@davemloft.net; netdev@vger.kernel.org;
>> dl-linux-imx <linux-imx@nxp.com>
>> Subject: Re: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
>>
>> On Wed, 24 Feb 2021 02:13:05 +0000 Joakim Zhang wrote:
>>>>> The aim is to enable clocks when it needs, others keep clocks disabled.
>>>>
>>>> Understood. Please double check ethtool callbacks work fine. People
>>>> often forget about those when disabling clocks in .close.
>>>
>>> Hi Jakub,
>>>
>>> If NIC is open then clocks are always enabled, so all ethtool
>>> callbacks should be okay.
>>>
>>> Could you point me which ethtool callbacks could be invoked when NIC
>>> is closed? I'm not very familiar with ethtool use case. Thanks.
>>
>> Well, all of them - ethtool does not check if the device is open.
>> User can access and configure the device when it's closed.
>> Often the callbacks access only driver data, but it's implementation specific so
>> you'll need to validate the callbacks stmmac implements.
> 
> Thanks Jakub, I will check these callbacks.

You can implement ethtool_ops::begin and ethtool_ops::complete where you
would enable the clock, and respectively disable it just for the time of
the operation. The ethtool framework guarantees that begin is called at
the beginning and complete at the end. You can also make sure that if
the interface is disabled you only return a cached copy of the
settings/MIB counters (they are not updating since the HW is disabled)
and conversely only store parameters in a cached structure and apply
those when the network device gets opened again. Either way would work.
-- 
Florian
