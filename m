Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCEA3338BE
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhCJJag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 04:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbhCJJaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 04:30:08 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD41C06174A;
        Wed, 10 Mar 2021 01:30:07 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id u18so8168463plc.12;
        Wed, 10 Mar 2021 01:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=7hG+7twcez7MRZ/W+scBmz//nBOUL19Yr2GHqNWu7Is=;
        b=LahTqfCcgLxfDbgjtQzdMG4P4FE2PXpu8jeWAgvx/yAlN2mjy+d1rzEdxQH5KCLgYE
         hAhhvjCfjgj7px2xsplLnlTrHmA19f47wvzqxFK/QpciGvD4lcnZSG6Xuh9IMlxqEkbr
         in72RqQOMIxlcGoNOuX1W5kTwQ5Ja7njIczrbLxN5I8CMzuqAmjLh+GGflIIlMIyYUMQ
         6ChNAaLxK5hOLqtiq/bzH7TE6ao4jznaK4XpISjXzM3FucFsj50zE1678vDl6eZpnF1L
         rvYBB/SpOU5CbGmjTjaI87Jq5i60Xs7K9dzEuh8c5MCT+fxkUuL2GK2tRKnRGrZJl53r
         6KEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7hG+7twcez7MRZ/W+scBmz//nBOUL19Yr2GHqNWu7Is=;
        b=HBd8TLbcx4WDH5M8oBOaNapDeEnQI33YvZTPnwHHtew7fuq8kDrCYPbElOAkKBV2yz
         QdoiCSmVHYhRUOc2I8QvWpZEjm/rfmt8nj7Xu1psko5plbDCgXSrVGcgs+TkyqZqJ/2V
         6pMTbfWYNVIAYGa2nvgawKa8Gtv23aPks1dzTg/lb3m55FKxjOOSflOvrPx8areWG1nk
         QVdN+DOTf8eaqi9MYkuBKKEqUHgRgdllGmRpDMcrGLFiu1t6pQxNiKpjWce2YJIogc5v
         iVpmfrxntQQAai5FXWRZWp5Ks156+jE1wtKML3vOF/Dlui5byILL+nZocvMh5s4zRzcV
         2fqg==
X-Gm-Message-State: AOAM530ZmsECP1O5s55krP/cfaisr22Ze6AmtrITzFuPsicW7hulX16k
        id9ztBBVATJknCfIegMbbNE=
X-Google-Smtp-Source: ABdhPJy1vfKSygh4rO1ndPybvPGAsVYVzApfh2e3zrvI0YfuwmH9JvBQ2yQ2xbkOGE9050KUoQQOrw==
X-Received: by 2002:a17:90a:70c2:: with SMTP id a2mr2579432pjm.63.1615368607511;
        Wed, 10 Mar 2021 01:30:07 -0800 (PST)
Received: from [10.38.0.26] ([45.135.186.59])
        by smtp.gmail.com with ESMTPSA id f14sm7908511pfk.92.2021.03.10.01.30.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 01:30:07 -0800 (PST)
Subject: Re: [PATCH] net: bonding: fix error return code of bond_neigh_init()
To:     Roi Dayan <roid@nvidia.com>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20210308031102.26730-1-baijiaju1990@gmail.com>
 <e15f36f7-6421-69a3-f10a-45b83621b96f@nvidia.com>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <ff2fdc70-4ee5-a0eb-64d7-4deb39a62e03@gmail.com>
Date:   Wed, 10 Mar 2021 17:29:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <e15f36f7-6421-69a3-f10a-45b83621b96f@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/3/10 17:24, Roi Dayan wrote:
>
>
> On 2021-03-08 5:11 AM, Jia-Ju Bai wrote:
>> When slave is NULL or slave_ops->ndo_neigh_setup is NULL, no error
>> return code of bond_neigh_init() is assigned.
>> To fix this bug, ret is assigned with -EINVAL in these cases.
>>
>> Fixes: 9e99bfefdbce ("bonding: fix bond_neigh_init()")
>> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>> ---
>>   drivers/net/bonding/bond_main.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/bonding/bond_main.c 
>> b/drivers/net/bonding/bond_main.c
>> index 74cbbb22470b..456315bef3a8 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -3978,11 +3978,15 @@ static int bond_neigh_init(struct neighbour *n)
>>         rcu_read_lock();
>>       slave = bond_first_slave_rcu(bond);
>> -    if (!slave)
>> +    if (!slave) {
>> +        ret = -EINVAL;
>>           goto out;
>> +    }
>>       slave_ops = slave->dev->netdev_ops;
>> -    if (!slave_ops->ndo_neigh_setup)
>> +    if (!slave_ops->ndo_neigh_setup) {
>> +        ret = -EINVAL;
>>           goto out;
>> +    }
>>         /* TODO: find another way [1] to implement this.
>>        * Passing a zeroed structure is fragile,
>>
>
>
> Hi,
>
> This breaks basic functionally that always worked. A slave doesn't need
> to exists nor to implement ndo_neigh_setup.
> Now trying to add a neigh entry because of that fails.
> This commit needs to be reverted.
>

Okay, thanks for the explanation, and I am sorry for this false report...


Best wishes,
Jia-Ju Bai
