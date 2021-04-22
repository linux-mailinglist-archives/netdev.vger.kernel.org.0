Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CF436867B
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 20:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236903AbhDVSVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 14:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236873AbhDVSVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 14:21:37 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F23FC06138B
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 11:21:01 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id f11-20020a17090a638bb02901524d3a3d48so1450624pjj.3
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 11:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k6MO6W4PcnXzP6uuyjmhxnwfDotiZ6sasWpgvoL068E=;
        b=i0pRqER/1z6lfSeBcdJMNqEfwIaFjUGjAlgKC8/uqmBsOfOcPxlOainv03U0ezAop1
         azHBuG49EdjGv1WSSXAzD/kG3HDYh4utZ9vwAz/eqtmHbS/3aWPbm9GQxHfNkhTimANu
         8bIy91/FGzOyJ5ryQ46xNy05PfvFPPie0q9LE5BnhACFpOeSq0x/UnlZUtmGy93bPg/9
         vvFOtHsSTeyLHlczEY/mQMir17Y+UaWb1pFZXVa7xwOV71gjoVEI73fB6Ktm1Rd9LElw
         jVg3RpX03sLCMvK03yxOEPxWgxpqQ9aeSxjYyNekP4m59QXgzdbSVP2OiBKziAVlbiQ4
         +W7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k6MO6W4PcnXzP6uuyjmhxnwfDotiZ6sasWpgvoL068E=;
        b=cjrVuhQSd62p7AdBPYuwPBYW4VHtSsRmFjDs3JA6e6ZtiHFfjjhFyXAfWbKp88c8eJ
         0nCMgu+oEO/W/sW4l1Sk5LTWgvvvXhDF/Rslc1L8Ud6zr2JZ/YWcICO1Ljq53ol8aQbq
         d+/YQQr3YrJzgGP4WFuR6sTuDhhu/N4DjicEum+/qm8f0/cU8qMG3Fl8KPCiQ1DYQI/d
         Tdg+sXc/I9uWgsS3OtQwvG+RLKEOGZNLk0qReL4s2jRm5XthBM6299sA1SuKDBBT2u2i
         1UOMRr0NcBweV3TLZI3Xpdwg5jNtPKref7ekIKMuMNUrXEAu0ybMUNfLo9sYPJ9JRs8a
         yhuQ==
X-Gm-Message-State: AOAM533UkEsuN/VdEY2kyDq6UNSP6umHZipiRf02sgTqqr4exzojM6+E
        R6packBc856QRP6qIh35fQWArIvoGG8=
X-Google-Smtp-Source: ABdhPJyshwAsDq3MCvazwBuItbM10KSfAg+/4EIvdg4ekhpb8CG94HrMmvy0eMtk3Dktr7bbORccbw==
X-Received: by 2002:a17:90a:4d8a:: with SMTP id m10mr81742pjh.42.1619115660236;
        Thu, 22 Apr 2021 11:21:00 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id f19sm2847020pga.71.2021.04.22.11.20.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 11:20:59 -0700 (PDT)
Subject: Re: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
To:     Jon Hunter <jonathanh@nvidia.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
 <f00e1790-5ba6-c9f0-f34f-d8a39c355cd7@nvidia.com>
 <DB8PR04MB67954D37A59B2D91C69BF6A9E6489@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <cec17489-2ef9-7862-94c8-202d31507a0c@nvidia.com>
 <DB8PR04MB67953A499438FF3FF6BE531BE6469@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <2cf60306-e2b9-cc24-359c-774c9d339074@gmail.com>
 <9abe58c4-a788-e07d-f281-847ee5b9fcf3@nvidia.com>
 <22bf351b-3f01-db62-8185-7a925f19998e@gmail.com>
 <bd184c72-7b12-db4c-0dd3-25f0fd45b7aa@nvidia.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3ba28b13-15eb-85bd-0625-f99450c8341b@gmail.com>
Date:   Thu, 22 Apr 2021 11:20:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <bd184c72-7b12-db4c-0dd3-25f0fd45b7aa@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/2021 11:18 AM, Jon Hunter wrote:
> 
> On 22/04/2021 18:32, Florian Fainelli wrote:
>>
>>
>> On 4/22/2021 10:00 AM, Jon Hunter wrote:
>>>
>>> On 22/04/2021 17:12, Florian Fainelli wrote:
>>>
>>> ...
>>>
>>>> What does the resumption failure looks like? Does the stmmac driver
>>>> successfully resume from your suspend state, but there is no network
>>>> traffic? Do you have a log by any chance?
>>>
>>> The board fails to resume and appears to hang. With regard to the
>>> original patch I did find that moving the code to re-init the RX buffers
>>> to before the PHY is enabled did work [0].
>>
>> You indicated that you are using a Broadcom PHY, which specific PHY are
>> you using?
>>
>> I suspect that the stmmac is somehow relying on the PHY to provide its
>> 125MHz RXC clock back to you in order to have its RX logic work correctly.
>>
>> One difference between using the Broadcom PHY and the Generic PHY
>> drivers could be whether your Broadcom PHY driver entry has a
>> .suspend/.resume callback implemented or not.
> 
> 
> This board has a BCM89610 and uses the drivers/net/phy/broadcom.c
> driver. Interestingly I don't see any suspend/resume handlers for this phy.

Now if you do add .suspend = genphy_suspend and .resume = bcm54xx_resume
for this PHY entry does it work better?
-- 
Florian
