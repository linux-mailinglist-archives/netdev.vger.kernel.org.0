Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBE6368476
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 18:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236603AbhDVQM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 12:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236504AbhDVQM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 12:12:56 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7D7C06174A
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 09:12:19 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id nm3-20020a17090b19c3b029014e1bbf6c60so1231090pjb.4
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 09:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YxBLj5GGV+GkWwmQ7gNGvnovQhQ8K9wXuO65rEm1nhw=;
        b=jldYHE1J26+6U7yuMzmNSGybidnn4cE5iOCE6lfh/ytsAtWqj2kLwx/qxjgqiFuyC+
         eD5zDXQRCEPJP72GImSIiIXa40J2AouKWJW9x/2rvwZ0u0bnGoQmrYXHTQtmnab35jIu
         GHHBp0qLaYf7Z/+pUWX/Rh7KGFHp+iXryb7UGpAksQo9GXse1HDpl299NeEcBJrlrl0i
         d6ktMNQLXGploXkVFIaN0qd656B4LII8uvC3hyVtUOCKtcxPkIvl4I9jUtEbeO9R3g8n
         2Cz9YWnALq32Z9m63gPKQwcK/kbwCUCyrgotG5dxAJapoXzgHyJjLlRGz/gqzX/y5Ady
         I/mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YxBLj5GGV+GkWwmQ7gNGvnovQhQ8K9wXuO65rEm1nhw=;
        b=JH2yjd5vwoMEjL3JfXtXAu0qU58d4PZ7AUSf/hywtMA2+c89yJyH4O81SnQPw7zPr2
         uI8/96lxLHKUAX4jOQnjUn7ExGIX+CBs7UQq2MrdsnNacopV9psnn5GMScjciK50w/wH
         1G7d9LvtZ7/PzBZcLShxANemTbLxquSTma1jlhnLON95dRbzidIhzyPnvzEHnoRuL0gj
         4aDp2jGqm5oKubNfaw0/XcicbUB33DhJDw5RohISvlLdFT8gjFrkBpFjT5vEaV+kwYMS
         7sbimeM9YKqxL37Cob3HD1WGDxez0FC1ngnb2gUQdAwFDU6JLjPdLYPcaKoA2WBYuzHA
         nzmA==
X-Gm-Message-State: AOAM530sDRU/lXmMCAsqnvO5NNe8knXQZ2C03ezo9Zmlz6SIQWHX+hWL
        6L2b0x1kkz7wQtK3yR6NbeADDBwjcm0=
X-Google-Smtp-Source: ABdhPJwUNQR8KeIbXZindama1hZp31BltzABBgX8G5vu7+Q7qB+ZkekKVemrF6G/99Xs7wNKhu9hXg==
X-Received: by 2002:a17:90a:c589:: with SMTP id l9mr828596pjt.24.1619107938946;
        Thu, 22 Apr 2021 09:12:18 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id f5sm2469225pfd.62.2021.04.22.09.12.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 09:12:18 -0700 (PDT)
Subject: Re: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jon Hunter <jonathanh@nvidia.com>,
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
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2cf60306-e2b9-cc24-359c-774c9d339074@gmail.com>
Date:   Thu, 22 Apr 2021 09:12:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB67953A499438FF3FF6BE531BE6469@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/21/2021 9:53 PM, Joakim Zhang wrote:
> 
>> -----Original Message-----
>> From: Jon Hunter <jonathanh@nvidia.com>
>> Sent: 2021年4月20日 21:34
>> To: Joakim Zhang <qiangqing.zhang@nxp.com>; peppe.cavallaro@st.com;
>> alexandre.torgue@foss.st.com; joabreu@synopsys.com;
>> davem@davemloft.net; kuba@kernel.org; mcoquelin.stm32@gmail.com;
>> andrew@lunn.ch; f.fainelli@gmail.com
>> Cc: dl-linux-imx <linux-imx@nxp.com>; treding@nvidia.com;
>> netdev@vger.kernel.org
>> Subject: Re: [RFC net-next] net: stmmac: should not modify RX descriptor when
>> STMMAC resume
>>
>>
>>
>> On 20/04/2021 02:49, Joakim Zhang wrote:
>>
>> ...
>>
>>>> I have tested this patch, but unfortunately the board still fails to
>>>> resume correctly. So it appears to suffer with the same issue we saw
>>>> on the previous implementation.
>>>
>>> Could I double check with you? Have you reverted Commit 9c63faaa931e
>> ("net: stmmac: re-init rx buffers when mac resume back") and then apply above
>> patch to do the test?
>>>
>>> If yes, you still saw the same issue with Commit 9c63faaa931e? Let's recall
>> the problem, system suspended, but system hang when STMMAC resume back,
>> right?
>>
>>
>> I tested your patch on top of next-20210419 which has Thierry's revert of
>> 9c63faaa931e. So yes this is reverted. Unfortunately, with this change
>> resuming from suspend still does not work.
> 
> 
> Hi Jakub, Andrew,
> 
> Could you please help review this patch? It's really beyond my comprehension, why this patch would affect Tegra186 Jetson TX2 board?
> Thanks a lot!

What does the resumption failure looks like? Does the stmmac driver
successfully resume from your suspend state, but there is no network
traffic? Do you have a log by any chance?

Is power to the Ethernet MAC turned off in this suspend state, in which
case could we be missing an essential register programming stage?
-- 
Florian
