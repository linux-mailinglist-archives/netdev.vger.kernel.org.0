Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374F230C3EC
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbhBBPfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235313AbhBBPcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 10:32:50 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F82C06174A
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 07:32:10 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id 36so20176670otp.2
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 07:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LRmqZ3tw+zetHLrXqwaSWbO7HLeZnwC1YRbKDLAzweQ=;
        b=uiqqHBskr7ItrcUTA7QndDDfrhbu647QsAR7m2JJPm8892p9UNhvCU3MzDM8Efe3/B
         3hMxXZvT6AGEIhLCpob1ptE4ZYQtkEXdeTWqkHHdv+UVs0WXpKZldah1b23zuZKW1/Ie
         7hsTOAtRFQt0kz8pRbxfj1MHgjyLrS/AO0PR5TjEwS2TjjfITN9M3tTTfB1lOEd8W6Ox
         B2333I42hxGmXoTMsZobNnAozklZi8c8A+ACBnxVq6vl7E8CZ/aSO9xtHbjQtaGStVIy
         s8Geyqh3w08XESdiup3DkGpw+1kL8p/9J04xr6lmx9IHfaYLNWR3mJ+YyWvK/RPfE63x
         ORsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LRmqZ3tw+zetHLrXqwaSWbO7HLeZnwC1YRbKDLAzweQ=;
        b=XNBvNqo/1mMVK5WZrlxxvjyeEzLB2BNa2Xywf0gSdkUfMfcgPYtQdCrcOXFBtb720C
         WCjsTlmxXjtvgki/+An+Qa+4Z/PLeyeeFyplgg+Q5E+jaObjWhBjb0iS2CGl7RituV3U
         RYzOFZg/fYy+MTGCAUJ/zltdBEHjPFmYRDysNu7DcdVqw0IMCU5BZuEjoEG55/Aiu6CW
         stT0Lo/pwu+gKljR5zhyZNYXJVP+Uc2AaZhQpvkEF44XT3CHkmisfnwI9Q1cs4vCDDUP
         iY+vEOhHKd4ZhUkM/mQsYc1FUsm0CNH3Sbb6LeLVttBNjqpw+JN8QFjy9nY5/haJO2cS
         cjsg==
X-Gm-Message-State: AOAM533sfqZNdtMx2SGRnteUidiMxR+oQuUcJhxhpbQ7bqVHelIWtUmA
        idGrf4tNeU/z7zjPsZhYzzc=
X-Google-Smtp-Source: ABdhPJxc62i+K1TaeMGVCgzgxQZf9SzJ9ukgNBrPRaD+Z32aOXi3VOPktir41QEUTGwd+PgYQS8CqA==
X-Received: by 2002:a05:6830:18a:: with SMTP id q10mr15470484ota.115.1612279929462;
        Tue, 02 Feb 2021 07:32:09 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id y10sm4868966ooy.11.2021.02.02.07.32.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 07:32:08 -0800 (PST)
Subject: Re: [PATCH iproute2-next] tc/htb: Hierarchical QoS hardware offload
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>
References: <20201215074213.32652-1-maximmi@mellanox.com>
 <8c818766-ec3f-4c0b-f737-ec558613b946@gmail.com>
 <01ce90dc-9880-ccad-cce4-e13dc22f8118@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7ddf3098-a190-95ae-0536-dc664580e298@gmail.com>
Date:   Tue, 2 Feb 2021 08:32:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <01ce90dc-9880-ccad-cce4-e13dc22f8118@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/21 4:46 AM, Maxim Mikityanskiy wrote:
> On 2021-01-29 18:05, David Ahern wrote:
>> On 12/15/20 12:42 AM, Maxim Mikityanskiy wrote:
>>> This commit adds support for configuring HTB in offload mode. HTB
>>> offload eliminates the single qdisc lock in the datapath and offloads
>>> the algorithm to the NIC. The new 'offload' parameter is added to
>>> enable this mode:
>>>
>>>      # tc qdisc replace dev eth0 root handle 1: htb offload
>>>
>>> Classes are created as usual, but filters should be moved to clsact for
>>> lock-free classification (filters attached to HTB itself are not
>>> supported in the offload mode):
>>>
>>>      # tc filter add dev eth0 egress protocol ip flower dst_port 80
>>>      action skbedit priority 1:10
>>
>> please add the dump in both stdout and json here.
> 
> Do you mean to add example output to the commit message?

yes.

>>>   diff --git a/tc/q_htb.c b/tc/q_htb.c
>>> index c609e974..fd11dad6 100644
>>> --- a/tc/q_htb.c
>>> +++ b/tc/q_htb.c
>>> @@ -30,11 +30,12 @@
>>>   static void explain(void)
>>>   {
>>>       fprintf(stderr, "Usage: ... qdisc add ... htb [default N] [r2q
>>> N]\n"
>>> -        "                      [direct_qlen P]\n"
>>> +        "                      [direct_qlen P] [offload]\n"
>>>           " default  minor id of class to which unclassified packets
>>> are sent {0}\n"
>>>           " r2q      DRR quantums are computed as rate in Bps/r2q
>>> {10}\n"
>>>           " debug    string of 16 numbers each 0-3 {0}\n\n"
>>>           " direct_qlen  Limit of the direct queue {in packets}\n"
>>> +        " offload  hardware offload\n"
>>
>> why 'offload hardware offload'? does not make sense to me and
> 
> "offload" is a new parameter, and "hardware offload" is the description,
> just like the other parameters above.
> 
>> you don't
>> reference hardware below.
> 
> Where should I reference it?

I see now. More words are needed to make it clear 'hardware offload' is
the explanation of offload. As it is, the words run together as 'offload
 hardware offload' which is the source of my confusion.
