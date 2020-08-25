Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8162925184B
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 14:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730168AbgHYMLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 08:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729051AbgHYML1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 08:11:27 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA8EC061757;
        Tue, 25 Aug 2020 05:01:35 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id x7so6387569wro.3;
        Tue, 25 Aug 2020 05:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=snf7xzSq1+7sAAY1FkgIm/Dy4E/puXZF38YMoitWgY8=;
        b=MiECm9oCSRH6Ovco3ytlPbF5/Ah9Naz9NpWeCHEx2YOlcObioWB0Cy9pCn9OMGnU/I
         HsxslivSndSqAdkJ6MXiSJQ7SZHh9F6thsA/ZQ7uYUFDm1uW24tUS7dbmP+iPBV28eGh
         ie7XWy52niJA55qKPLrNeORO3b+cO+vWABmrOv3eU8voiU01rEUVjjwKhloCNnOED4Io
         eSh+lO3cktym0nT+EHbmU9wKzQR9n/GdkvqGRWnS67GeDOx/aVARmYmidmSKuzJmGY7h
         mDgYApq6IzEfNYuLvyluNrn83UYgxyJrU3M08EGvm1VTMbNmdQAkJkZyNU7El0cSw/t4
         Y6sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=snf7xzSq1+7sAAY1FkgIm/Dy4E/puXZF38YMoitWgY8=;
        b=VA5OBJH9mAhGrpnswVh/NoqOGegwMh0it7K0Ctb+kOTQj1ZNSu65Osru4LTfkvbaLy
         Rcv2EXxHHpXRO7eQ4j4xsBZgNb93Qg9vGDavvhBTxhCDk+qdhBwNZQzD/EZbvcge/IdK
         8lQBIetRdKno098wLurOtUqrMkaJiGpWi4BTXAcYhF0eDsGXWe8Tg4lgF15SvH5YEpVS
         PtfleRbP4VhcqN1Qxt+ZoYelxwJV6VGPXDMZZiP2n5fgAcOyXykBemQgyC1M93HMUigB
         v/tGHtwejHECEhaGCj47ZXTrACWZTBTkL/sr+eqW5/iBaZN0VcQg97CzRgYJ/CGCt49S
         4jMA==
X-Gm-Message-State: AOAM532br1Ppw6Wqkcoj5M8eqLMwWOdFrjrOhlhVvj9h2XLdismC8xgf
        rMF9RUPDSIYd3Y4TOjEu8Z8=
X-Google-Smtp-Source: ABdhPJz+R9gST7o6En4Qt37CLqkDx8CgeT01PCib7Nwwph2ezuBhMcdXogZldY11cH6gtFsvru7B2Q==
X-Received: by 2002:a5d:684b:: with SMTP id o11mr10905113wrw.101.1598356893527;
        Tue, 25 Aug 2020 05:01:33 -0700 (PDT)
Received: from [192.168.1.125] (dynamic-adsl-84-220-30-184.clienti.tiscali.it. [84.220.30.184])
        by smtp.gmail.com with ESMTPSA id d10sm18469936wrg.3.2020.08.25.05.01.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 05:01:32 -0700 (PDT)
Subject: Re: [net-next v4] seg6: using DSCP of inner IPv4 packets
To:     David Miller <davem@davemloft.net>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it
References: <20200824085124.2488-1-ahabdels@gmail.com>
 <20200824.181109.421299456838417383.davem@davemloft.net>
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
Message-ID: <e8f49be9-f658-e863-3359-c28f122dc382@gmail.com>
Date:   Tue, 25 Aug 2020 14:01:27 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200824.181109.421299456838417383.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25/08/2020 03:11, David Miller wrote:
> From: Ahmed Abdelsalam <ahabdels@gmail.com>
> Date: Mon, 24 Aug 2020 08:51:24 +0000
> 
>> This patch allows copying the DSCP from inner IPv4 header to the
>> outer IPv6 header, when doing SRv6 Encapsulation.
>>
>> This allows forwarding packet across the SRv6 fabric based on their
>> original traffic class.
>>
>> Signed-off-by: Ahmed Abdelsalam <ahabdels@gmail.com>
> 
> "Allows" sounds like the behavior is optional, but that is not what
> is happening here.  You are making this DSCP inheritance behavior
> unconditional.
> 
> I've stated that the current behavior matches what other ipv6
> tunneling devices do, and therefore we should keep it that way.
> 
> Furthermore, this behavior has been in place for several releases
> so you cannot change it by default.  People may be depending upon
> how things work right now.
> 

Ok. I added a new sysctl (seg6_inherit_inner_ipv4_dscp) to 
enable/disable the new behavior.

The sysctl will be checked in case of IPv4 traffic.
In the IPv6 case, there is no change as the code is already copying the 
DSCP from the inner IPv6 packet.

I'm sending a new patch.


> Also:
> 
>> @@ -130,6 +129,7 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
>>   	struct ipv6_sr_hdr *isrh;
>>   	int hdrlen, tot_len, err;
>>   	__be32 flowlabel;
>> +	u8 tos = 0, hop_limit;
> 
> Need to preserve reverse christmas tree here.
> 
Fixed in the new patch.
