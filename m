Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2050F3343F6
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 17:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbhCJQz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 11:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbhCJQzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 11:55:08 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681B9C061760;
        Wed, 10 Mar 2021 08:55:08 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id a18so24086546wrc.13;
        Wed, 10 Mar 2021 08:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xvXCi+ZA93XCGEQDvUcBtJfy5hMDY05M48bcNWKSXvM=;
        b=D+10ukdYOKCe2WcZwhUbwo5dw9yLADpXBvXlHL+PsCKlgwhSGq7dC8C4z7u6feuPd+
         IM80iWrEb6a4bed0lZ3nKWoNxmMTzazvxLJc0Dp4IDbT9dKC0AxywZXd/2cR1vWgLD7L
         7WhtOTqOZyDZDlXKdRu/Gwk76CfhH3YS5bErqKPSLlm7uiR89Ju6rYGkPVpaDji8FT6l
         15NcSf6hjEJmho8SQC0Vau7z+uIdNPkCLzNzKcpqHnKO3yBNRIs17RLxe+f9T9gp4Vy+
         xWjvDfB5a+8CuMsSpoWFMDn+WZthun5Kmprj7xjJYwQJN/fu/8vMFVSfZM+tFYtPsKG8
         oXtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xvXCi+ZA93XCGEQDvUcBtJfy5hMDY05M48bcNWKSXvM=;
        b=l0vBxlrtapIYPWLvyu9QUkmUP4FoKvrC46Q9YL9sQMH7s7/T4yr7NctWsFMogLLgz1
         Ya26/fQhXB/ReB5A4szGidCe80Ydc35dSbzi+oR0lG1y+fqVFLeWDnGeNkJAMzES9hcO
         M8Dt3Ii2fAei+RW8ikfBiFzphC6ZlxMKRzE8L/+qS+fEc4eEB+Fc0r/EEMNxhwRPwV2Y
         FLvZjDkCzUxMQVFeFLaBPEK/1N5Mhc4oeBFsWP/sMgxaN9TbGuaQT5WvrFFqcyBRBGt3
         m8FugRAr2BQ9HJbDvMHfK73lyutvf6QvtUWuHbSUT9wLfShuLfcyBDBroph7xNKCoWmm
         uwzQ==
X-Gm-Message-State: AOAM5304pkKxVIdFdKENbpt5BmI0kMsFWquzBoidWsWBGh+jLzA1cj08
        5kwpxo7VGLdNcbXMsXTLDAc=
X-Google-Smtp-Source: ABdhPJyDipQnv/eO+BidOVnpi3D2qrisKG6WnrnRdBYTNBUpcFjOCDjdXOyMgc986rJET5m4slm+sA==
X-Received: by 2002:adf:a3c2:: with SMTP id m2mr4471158wrb.195.1615395307139;
        Wed, 10 Mar 2021 08:55:07 -0800 (PST)
Received: from [192.168.1.101] ([37.171.47.61])
        by smtp.gmail.com with ESMTPSA id h6sm56288wmi.6.2021.03.10.08.55.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 08:55:06 -0800 (PST)
Subject: Re: [PATCH] net: bonding: fix error return code of bond_neigh_init()
To:     Roi Dayan <roid@nvidia.com>, Jia-Ju Bai <baijiaju1990@gmail.com>,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20210308031102.26730-1-baijiaju1990@gmail.com>
 <e15f36f7-6421-69a3-f10a-45b83621b96f@nvidia.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5d4cbafa-dbad-9b66-c5be-bca6ecc8e6f3@gmail.com>
Date:   Wed, 10 Mar 2021 17:55:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <e15f36f7-6421-69a3-f10a-45b83621b96f@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/21 10:24 AM, Roi Dayan wrote:
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
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
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
> Thanks,
> Roi

Agreed, this commit made no sense, please revert.
