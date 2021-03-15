Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D21333C7EB
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 21:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbhCOUoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 16:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbhCOUoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 16:44:06 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E0AC06174A;
        Mon, 15 Mar 2021 13:44:06 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id f8so2388033plg.10;
        Mon, 15 Mar 2021 13:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gnqsd573zZlQYyXiRV6aGjmdvXijjmPqldHUoXMDfu8=;
        b=vfMMAesX0+rn+X7Wj2z5RMXsCPGLZjCMN8eWSbUrbT9g0JBZPuVf2Gs7reRyy/1mBO
         lp2ecDobKwedGZU27DX61TEAAgRScaDFkC0TOMCDoRUZVxz6jyt23dU2iREeQYu0qYdg
         6gv6ZXGPcWaVcgRONG5OPGsQCMFYGD84Piuho2TT5vjNLgYuSlqQzI/8+iTH29sYCf8T
         qTKuWZdNZgOeFwADWV3ojVrsl7RCpALi6Hxlk476/H4V4pP42oYSwLKSHU83wvsQQG1M
         fx7ygt+BYQSLUuBXXoSjpR3BBZKqzWmqtTqpxfDouYOxKevgM99Vvcsm7BDWTwDp/yR9
         kE3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gnqsd573zZlQYyXiRV6aGjmdvXijjmPqldHUoXMDfu8=;
        b=W4/W3NxWMw3BlLBrKkfK1jGQd9phjOZOx+5l22etMNdurwk7qnMmXvGmhygNM68Z2t
         fIYybr0leWp5tJLVoQ6f1tSP+baOPM/pvYtnp3Dpfe7bq9HMHm04K61AgEJKbphIQ05C
         ntV5bPpoaIdHjfnNpyZQqtJU8YobElJN8KBtc4GJRwoZ+SKP+3dV4UlnAimILB2y6Rxm
         efGfbWSW65hPwtFgNeRNd3dr5DuaJ6OFXd7AUS19Nay8R9snWsdud6LgZQog0osyzGLo
         FjSCxj3nn/esGqX0M8vOHn1+C0hOzv9WhJxvDEOz39oWFWCAKV49/yRzyblW6FiP6kb1
         yNZA==
X-Gm-Message-State: AOAM531fcUcjR/cfyeeNB/YfrceXOC289TI/xPtpxuY3P+a452IDEb9r
        7CDhY+i6jrOqbDol5UGx6Ng=
X-Google-Smtp-Source: ABdhPJzdN21z/GugGt/PCV1b2jwA8YdA2VVf3bQs+ITDMpcq/FcfL3yglsVSyegGfeCgSTAQAobkgQ==
X-Received: by 2002:a17:902:9b84:b029:e5:ee87:6840 with SMTP id y4-20020a1709029b84b02900e5ee876840mr13424129plp.82.1615841046061;
        Mon, 15 Mar 2021 13:44:06 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e83sm14414215pfh.80.2021.03.15.13.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 13:44:05 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: mt7530: support MDB and bridge flag
 operations
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>
References: <20210315170940.2414854-1-dqfext@gmail.com>
 <892918f1-bee6-7603-b8e1-3efb93104f6f@gmail.com>
 <20210315200939.irwyiru6m62g4a7f@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <84bb93da-cc3b-d2a5-dda8-a8fb973c3bae@gmail.com>
Date:   Mon, 15 Mar 2021 13:44:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315200939.irwyiru6m62g4a7f@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/15/2021 1:09 PM, Vladimir Oltean wrote:
> On Mon, Mar 15, 2021 at 01:03:10PM -0700, Florian Fainelli wrote:
>>
>>
>> On 3/15/2021 10:09 AM, DENG Qingfang wrote:
>>> Support port MDB and bridge flag operations.
>>>
>>> As the hardware can manage multicast forwarding itself, offload_fwd_mark
>>> can be unconditionally set to true.
>>>
>>> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
>>> ---
>>> Changes since RFC:
>>>   Replaced BR_AUTO_MASK with BR_FLOOD | BR_LEARNING
>>>
>>>  drivers/net/dsa/mt7530.c | 124 +++++++++++++++++++++++++++++++++++++--
>>>  drivers/net/dsa/mt7530.h |   1 +
>>>  net/dsa/tag_mtk.c        |  14 +----
>>>  3 files changed, 122 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
>>> index 2342d4528b4c..f765984330c9 100644
>>> --- a/drivers/net/dsa/mt7530.c
>>> +++ b/drivers/net/dsa/mt7530.c
>>> @@ -1000,8 +1000,9 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
>>>  	mt7530_write(priv, MT7530_PVC_P(port),
>>>  		     PORT_SPEC_TAG);
>>>  
>>> -	/* Unknown multicast frame forwarding to the cpu port */
>>> -	mt7530_rmw(priv, MT7530_MFC, UNM_FFP_MASK, UNM_FFP(BIT(port)));
>>> +	/* Disable flooding by default */
>>> +	mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK,
>>> +		   BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) | UNU_FFP(BIT(port)));
>>
>> It's not clear to me why this is appropriate especially when the ports
>> operated in standalone mode, can you expand a bit more on this?
> 
> We are in the function called "mt753x_cpu_port_enable" here. It's ok to
> apply this config for the CPU port.

Because the user ports will flood unknown traffic and we have mediatek
tags enabled presumably, so all traffic is copied to the CPU port, OK.
-- 
Florian
