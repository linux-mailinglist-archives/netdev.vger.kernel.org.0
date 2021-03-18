Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A7C3409D4
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbhCRQO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbhCRQOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:14:10 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C230EC06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 09:14:10 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id l123so3818995pfl.8
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 09:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dxgCvJS5sm61Y+9uDITxqjOpTyHG+5c1RJ5iHbV3WWs=;
        b=hIOTg/rYP0K2c8R7TtJLGfr2CKWbrvFCS2eVL9+vaRD91muzmM33ubRuPr2KF3MOJt
         VHCUo0JH1p3sA2XRuECxdCXcfCWx3alQC7qLAwzqOQLPLp2zWhCxyB3h7fygYWOaiDv/
         IN7cl/Hgd/lkutbAOkcaAN/kP0gICVRW3oziBdQVBmZQqEsR9Dqmc12TuTp+V0V9R7AF
         q9fCuhjLh/r/I91kal4nEY+R30v5SRUGI4qhzUDHRlmQFa/z4Lfu535ueSlT8TJO6lEt
         TtjAtAmnL4jSqEEwDST54crTfBy0CBCxnahkUNuhB7P0SvjMrzpH+Fd4lQxtIun29G6i
         V/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dxgCvJS5sm61Y+9uDITxqjOpTyHG+5c1RJ5iHbV3WWs=;
        b=id/QpfqIdqtddP/ZgnCMKgkjdSaqCBizh0K6CuYCO1yJaC/xyQYfz8eUUgoKJE0olX
         3evJhwvVhITNwfLzR2ehyY/L8WLrmaXKoQp+Qv8kTydnEM5LTR3+mhDOjkfLxtGEFrB+
         QoC4HErquHvkydmyeUT1De7fUs+LN2uvgymSyDrEP60D7hCSF0E1yjjJfBvleOdaHhMY
         OTsdCh5iUia0Mw1LdBVbvYjgewJ/pAGqtuuTGvY9tPZnPVUumHA2zVeS0mRrlH5TsLPZ
         brk15A8xLnnqhuuOBrSUTcL/kCEKfFGZepZEau9LOEBowktUxPHIZOcyXGS1b34CCSUP
         Ohwg==
X-Gm-Message-State: AOAM530zS2f4+UWuyDeiit2HyQkpi4LXDXlWhx86XwDkXW6srr8BIGaG
        uHpCgX1aUvQ9226znhUqYZv4m5UliLg=
X-Google-Smtp-Source: ABdhPJwG77oCI5GHQLw4LXWIg+jF166eiANunvATVGH2k9l64gUxtqwhUnfLTPI12GXWZWlewJ8Ibg==
X-Received: by 2002:a62:160c:0:b029:20a:7b41:f10f with SMTP id 12-20020a62160c0000b029020a7b41f10fmr4704476pfw.67.1616084049941;
        Thu, 18 Mar 2021 09:14:09 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g21sm2649941pjl.28.2021.03.18.09.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 09:14:09 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 8/8] net: dsa: mv88e6xxx: Offload bridge
 broadcast flooding flag
To:     Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, netdev@vger.kernel.org
References: <20210318141550.646383-1-tobias@waldekranz.com>
 <20210318141550.646383-9-tobias@waldekranz.com>
 <20210318143505.5lu3ebozbkrayygp@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b8043682-c312-4521-e7d9-03354f689e3e@gmail.com>
Date:   Thu, 18 Mar 2021 09:14:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318143505.5lu3ebozbkrayygp@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 7:35 AM, Vladimir Oltean wrote:
> On Thu, Mar 18, 2021 at 03:15:50PM +0100, Tobias Waldekranz wrote:
>> These switches have two modes of classifying broadcast:
>>
>> 1. Broadcast is multicast.
>> 2. Broadcast is its own unique thing that is always flooded
>>    everywhere.
>>
>> This driver uses the first option, making sure to load the broadcast
>> address into all active databases. Because of this, we can support
>> per-port broadcast flooding by (1) making sure to only set the subset
>> of ports that have it enabled whenever joining a new bridge or VLAN,
>> and (2) by updating all active databases whenever the setting is
>> changed on a port.
>>
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>>  drivers/net/dsa/mv88e6xxx/chip.c | 73 +++++++++++++++++++++++++++++++-
>>  1 file changed, 72 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
>> index 7976fb699086..3baa4dadb0dd 100644
>> --- a/drivers/net/dsa/mv88e6xxx/chip.c
>> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
>> @@ -1982,6 +1982,21 @@ static int mv88e6xxx_broadcast_setup(struct mv88e6xxx_chip *chip, u16 vid)
>>  	int err;
>>  
>>  	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
>> +		struct dsa_port *dp = dsa_to_port(chip->ds, port);
>> +		struct net_device *brport;
>> +
>> +		if (dsa_is_unused_port(chip->ds, port))
>> +			continue;
>> +
>> +		brport = dsa_port_to_bridge_port(dp);
>> +
>> +		if (dp->bridge_dev &&
>> +		    !br_port_flag_is_set(brport, BR_BCAST_FLOOD))
> 
> I think I would have liked to see a dsa_port_to_bridge_port helper that
> actually returns NULL when dp->bridge_dev is NULL.
> 
> This would make your piece of code look as follows:
> 
> 		brport = dsa_port_to_bridge_port(dp);
> 		if (brport && !br_port_flag_is_set(brport, BR_BCAST_FLOOD)
> 			continue;

Agreed, with that fixed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
