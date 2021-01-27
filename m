Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2BB3050EA
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239019AbhA0EaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405381AbhA0Bp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 20:45:56 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D68C061574
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 17:33:32 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id s24so299313pjp.5
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 17:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XH+/xVGaXKzIq5b5K3dHIvtV2CiBj6g8TqASwEJdReI=;
        b=I9MC1F8ROT5JNjQG0VW50Grr7Z4XajYO8O6Ev2jyMaD0uXKNJc5BNquXesJKGyfyUX
         RRAh4FgVkWRxr+8k4nwp82uwTFri4Imq0SNNJvGHhBR1coj3fyYaeS3aPPh3JV8Q0qNT
         3iXFfKD2oMFOf//TH1NFB/vfvVl5FX78SKRI1ztPLs11lPn3e1qHJLKBnQTsOyE0B0oE
         +M6bnkIRtJpYKk8Lc7ZB+rlk9To0A1EqLRe2v29D3xDHgxuTM9OZWSAoh40qYESeV80o
         wxTUC6sitcIunD7bWAflKvdZuq33ODi3UNUuWyPo9/wRWONA5yHPuBdC6kLdtF4HHALt
         ky9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XH+/xVGaXKzIq5b5K3dHIvtV2CiBj6g8TqASwEJdReI=;
        b=DtN1yxcoYPn9GHPlXn79DUGx3dkoMNQbjPWgSVdVmpWYkOY1uElErQVMnYNk1m2Sog
         xq719ECwiBhR9UELPbKVFHRwYnS9OqlJZL406JWiBPsExkMmHPQH5F36W7qQk0AWgk3w
         qb9yGH6XLcyGh74Py23iNvj5JKtZ0Lf1wHwKo5U/F8KP/od1NsF4+Ic4T7xLFjUpYXsQ
         ul41wOFDleRZmMmP97hKRQLU5P2GffX3nnzBndSQcuwYd5J8D8CWEr57IL/kZCQkbTiF
         icvLtEQ+71kimcdChhxyQl7BW63YY8LdRMgrFR4sMpSoS0UTsLO25y7kbIlroVZ5Xpoj
         PfxA==
X-Gm-Message-State: AOAM5319CVCScySqCXflexesCqnVsOYfGhwGyqFGU6KpnCrkQoDAhY1z
        SZh7gP2CvVk+EbndQqX+EBs=
X-Google-Smtp-Source: ABdhPJzvMBBSiFOCRfi6x6KWzrneGtkpmVmZm4ncbDmq2YnPDcvOjK9qWxTcwOegEEN9U3VMknfuQQ==
X-Received: by 2002:a17:90a:77ca:: with SMTP id e10mr2828010pjs.53.1611711211517;
        Tue, 26 Jan 2021 17:33:31 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm303393pfc.153.2021.01.26.17.33.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 17:33:30 -0800 (PST)
Subject: Re: [PATCH V3 1/6] net: stmmac: remove redundant null check for ptp
 clock
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>, Andrew Lunn <andrew@lunn.ch>
References: <20210126115854.2530-1-qiangqing.zhang@nxp.com>
 <20210126115854.2530-2-qiangqing.zhang@nxp.com>
 <CAF=yD-J-WDY6GPP-4B-9v78wJf3yj6vrqhHnbyhg1kx6Wc1yHg@mail.gmail.com>
 <DB8PR04MB67953865C100029E0088CE69E6BB0@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e2f16f61-4f45-de76-65fc-272900cd14f7@gmail.com>
Date:   Tue, 26 Jan 2021 17:33:28 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB67953865C100029E0088CE69E6BB0@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/26/2021 5:30 PM, Joakim Zhang wrote:
> 
>> -----Original Message-----
>> From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
>> Sent: 2021年1月27日 6:46
>> To: Joakim Zhang <qiangqing.zhang@nxp.com>
>> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre Torgue
>> <alexandre.torgue@st.com>; Jose Abreu <joabreu@synopsys.com>; David
>> Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Network
>> Development <netdev@vger.kernel.org>; dl-linux-imx <linux-imx@nxp.com>;
>> Andrew Lunn <andrew@lunn.ch>; Florian Fainelli <f.fainelli@gmail.com>
>> Subject: Re: [PATCH V3 1/6] net: stmmac: remove redundant null check for ptp
>> clock
>>
>> On Tue, Jan 26, 2021 at 7:05 AM Joakim Zhang <qiangqing.zhang@nxp.com>
>> wrote:
>>>
>>> Remove redundant null check for ptp clock.
>>>
>>> Fixes: 1c35cc9cf6a0 ("net: stmmac: remove redundant null check before
>>> clk_disable_unprepare()")
>>
>> This does not look like a fix to that patch, but another instance of a cleanup.
>>
>> The patchset also does not explicitly target net (for fixes) or net-next (for new
>> improvements). I suppose this patch targets net-next.
> 
> I forgot to explicitly target as net when format the patch set again. This could be a fix even original patch(1c35cc9cf6a0) doesn't break anything, but it didn't do all the work as commit message commit.
> This patch targets net or net-next, this matter doesn't seem to be that important. If it is necessary, I can repost it next time as a separate patch for net-next. Thanks.

Your patch series is titled "ethernet: fixes for stmmac driver" so we
sort of expect to find only bug fixes in there.

Given this patch has no dependency and does not create one on the
others, you should post that as a separate patch targeting the
'net-next' tree.
-- 
Florian
