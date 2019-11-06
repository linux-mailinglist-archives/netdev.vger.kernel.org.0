Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23CEEF1AA1
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 16:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731937AbfKFP7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 10:59:50 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:44724 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfKFP7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 10:59:49 -0500
Received: by mail-io1-f65.google.com with SMTP id w12so27540523iol.11
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 07:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dgOxOCbGhXasIM0i1a0YtlkRSPnSVkf2XN3Y3IugUnI=;
        b=DocDu3sL1LEkd+NJJu1qa8/sa3z082G/Xi2Rg5SAv+xPe4Pl15363eGEygNejevD6y
         PEJPVvTT76lp/JaeFhZTbAcCfylvEADS9GV0S4BiATsCnt0w9MwwqfM5MkYwOwTnM6uL
         9BSssncpItACrRgQc1DcOom2ioJZsYwWZMu46Z6ziASMKXjiWmtwSZAt13GI5pwHyVfz
         YUVuWQ5OIIqgkFzsUGkqtZDnG7EVcuudjsbq+FeZEtNQSWOKZzS9zkgZCj55XcMSAOoX
         zrBZKn5evV25P5fZQ0xmsCTMJv86kKLpFO6Q/GC8sK/8Ek+JQKybyeDhRokIs9mTzM6+
         Y1aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dgOxOCbGhXasIM0i1a0YtlkRSPnSVkf2XN3Y3IugUnI=;
        b=EuP2bFTECVtL9BYo3KY1wSsHItq5VCzX99M8pVGSLXMiVRRsbHMZ/STKBA6bmW1s+F
         gv1SQ9JMXkcrgZvyDt3e1ujJCxDdKSccNCRLr6UJSWrHsGINawdCcyfZGowQZgogbHHj
         54DsBqhPz2wcRSuYtm1OjbPTBdStdzOfAEdCVfC2NxbL/7HtlrseopcJqJbPtbp9Ohrx
         QjbVf7t7O2d/3UNm0TiBKYfGeomvjv3JEPOCmPIAnSUdncpgUCduf4rrj5NLmzIqHOaL
         EuG/Ine4DiMql0OH5wIqUKzoWt7aLL65xH9REEgWMAI1SB1s+/5B/lTDgMKxNHsv/tz8
         m1/g==
X-Gm-Message-State: APjAAAVa/dbG0f30hMD0aC6h+s7PlC2xm31W8MgDFz/mVdWD8rqqZ8EY
        FKd41GVVI/MjYaRYu2PAYEfFQnG1
X-Google-Smtp-Source: APXvYqxaib40NDzfJzrc0zaYjImX7MC0H9CV/9VHiBuc6qLqYBbLuMOFUIX+MGqhoj/v0t5qPHVlrA==
X-Received: by 2002:a02:840a:: with SMTP id k10mr5710244jah.26.1573055989138;
        Wed, 06 Nov 2019 07:59:49 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:ec38:6775:b8e6:ab09])
        by smtp.googlemail.com with ESMTPSA id y1sm1496177iob.42.2019.11.06.07.59.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2019 07:59:48 -0800 (PST)
Subject: Re: [Possible regression?] ip route deletion behavior change
To:     Hendrik Donner <hd@os-cillation.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
References: <603d815f-f6db-3967-c0df-cbf084a1cbcd@os-cillation.de>
 <9384f54f-67a0-f2dc-68f8-3216717ee63e@gmail.com>
 <b7d44dcf-6382-a668-1a6a-4385f77fb0f5@os-cillation.de>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <458df7c4-7be0-cc2e-cc9b-828fac22a841@gmail.com>
Date:   Wed, 6 Nov 2019 08:59:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <b7d44dcf-6382-a668-1a6a-4385f77fb0f5@os-cillation.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/6/19 8:56 AM, Hendrik Donner wrote:
>> devices not associated with a VRF table are implicitly tied to the
>> default == main table.
>>
>> Can you test this change:
>>
>> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
>> index 0913a090b2bf..f1888c683426 100644
>> --- a/net/ipv4/fib_semantics.c
>> +++ b/net/ipv4/fib_semantics.c
>> @@ -1814,8 +1814,8 @@ int fib_sync_down_addr(struct net_device *dev,
>> __be32 local)
>>         int ret = 0;
>>         unsigned int hash = fib_laddr_hashfn(local);
>>         struct hlist_head *head = &fib_info_laddrhash[hash];
>> +       int tb_id = l3mdev_fib_table(dev) ? : RT_TABLE_MAIN;
>>         struct net *net = dev_net(dev);
>> -       int tb_id = l3mdev_fib_table(dev);
>>         struct fib_info *fi;
>>
>>         if (!fib_info_laddrhash || local == 0)
>>
>> [ As DaveM noted, you should cc maintainers and author(s) of suspected
>> regression patches ]
>>
> 
> I've tested your patch and it restores the expected behavior.

ok, I will send a formal patch.

> 
> + Mark Tomlinson so he can have a look at it too.
> 
> And my mail server can't deliver to Shrijeet Mukherjee <shm@cumulusnetworks.com>.
> Is that email address correct?
> 

Maintainers file in top of tree has the correct address:

$ grep Shrijeet MAINTAINERS
M:	Shrijeet Mukherjee <shrijeet@gmail.com>

