Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB406B99ED
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjCNPjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjCNPix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:38:53 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AA5B06C3
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:38:14 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id o11-20020a05600c4fcb00b003eb33ea29a8so10471422wmq.1
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678808256;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7GlU5FlfqZLNdwifJAA0Utk/ibVxeSQBhLWgq8BgMWk=;
        b=eoRVnkAEjY8iQPQ/R5+tNuPsk/3zgvCeY/mSziGETSQ/jSTFY/Jlx31u+GXkjQ8Yjb
         H86PIMraR1om2E9GFppJGfEttRV0kuhZkCaEY46mvGd/95cWN+gnchmKMlaNEtDNQ9j6
         Lpxv1JC1xeACAb36nSuGtWNNr79u6uGRNRxrHXQnvf+iPloJbv60d4qtpe/mXqLgqAgF
         c7/gbqXt3YJTotJDbqw74J5eBYcwHN7YLwO6jzulslr9ZEaTmvB5W7fGhe8561oEo4zk
         5eMXy7tEfF2gfa2D3AkJQakhK4GCYAJcgppkJ7TXg6RgK31daWzHzpghYbg4ZdipjFq6
         ctUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678808256;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7GlU5FlfqZLNdwifJAA0Utk/ibVxeSQBhLWgq8BgMWk=;
        b=8QVMPa9wu4sZU/6mZoEprNo4iHAYFy7FzlgbpieKDLUASo92A/3Bt+5nhaRe/6rrMH
         KP6T+9rUFPageyxEQHK/5acU/LUlT2MWr3Bk717AuNZMvq5vXXi7PyGv1GyPujeXlX+S
         VL7zUKJq2jOLRfzsRkk9jT+NnHhugM4oxGPfZxeB0etK4A211/1Rr1oatqLXTEJBtxOP
         anpIAI2YdMQARMUxgC1lwS++5gI6EA7nbyoYCNzvyQuPKNUzpGQhT9MlTUKSDl56VOXd
         oZvLzqkolJTDJXeighdWlklmYSIKE1UZqBKhnVCF0Y7rjg+hGVCnqwPRpIkH8W96HGfL
         fNvQ==
X-Gm-Message-State: AO0yUKXpqEQDceaRnLvvxIkcm9bi1UZsKVsQF8Mi21lr4AnrOcoSk8O+
        XnceScoopqMxXIqY9ljDMK9g0g==
X-Google-Smtp-Source: AK7set9pdl0IaRIcAWLhepeq2yGqCuDlwxylkFe2FMrDc0V8oJh5WRpzh4LTG/oDIIelnDQ0gxiq+Q==
X-Received: by 2002:a05:600c:468e:b0:3ea:f73e:9d8c with SMTP id p14-20020a05600c468e00b003eaf73e9d8cmr14756700wmo.16.1678808256522;
        Tue, 14 Mar 2023 08:37:36 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id t11-20020a7bc3cb000000b003eb3933ef10sm3086375wmj.46.2023.03.14.08.37.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 08:37:36 -0700 (PDT)
Message-ID: <f94409d7-4864-43cc-35f7-90ae319f54da@blackwall.org>
Date:   Tue, 14 Mar 2023 17:37:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net v2 1/4] bonding: add bond_ether_setup helper
Content-Language: en-US
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, monis@voltaire.com, syoshida@redhat.com,
        andy@greyhouse.net, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
References: <20230314111426.1254998-1-razor@blackwall.org>
 <20230314111426.1254998-2-razor@blackwall.org> <28497.1678808095@famine>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <28497.1678808095@famine>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2023 17:34, Jay Vosburgh wrote:
> Nikolay Aleksandrov <razor@blackwall.org> wrote:
> 
>> Add bond_ether_setup helper which will be used in the following patches
>> to fix all ether_setup() calls in the bonding driver. It takes care of both
>> IFF_MASTER and IFF_SLAVE flags, the former is always restored and the
>> latter only if it was set.
>>
>> Fixes: e36b9d16c6a6d ("bonding: clean muticast addresses when device changes type")
>> Fixes: 7d5cd2ce5292 ("bonding: correctly handle bonding type change on enslave failure")
>> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
>> ---
>> drivers/net/bonding/bond_main.c | 12 ++++++++++++
>> 1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index 00646aa315c3..d41024ad2c18 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -1775,6 +1775,18 @@ void bond_lower_state_changed(struct slave *slave)
>> 		slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
>> } while (0)
>>
>> +/* ether_setup() resets bond_dev's flags so we always have to restore
>> + * IFF_MASTER, and only restore IFF_SLAVE if it was set
>> + */
>> +static void bond_ether_setup(struct net_device *bond_dev)
>> +{
>> +	unsigned int slave_flag = bond_dev->flags & IFF_SLAVE;
>> +
>> +	ether_setup(bond_dev);
>> +	bond_dev->flags |= IFF_MASTER | slave_flag;
>> +	bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
>> +}
> 
> 	Is setting IFF_MASTER always correct here?  I note that patch #2
> is replacing code that does not set IFF_MASTER, whereas patch #3 is
> replacing code that does set IFF_MASTER.
> 
> 	Presuming that this is the desired behavior, perhaps mention
> explicitly in the commentary that bond_ether_setup() is only for use on
> a bond master device.  The nomenclature "bond_dev" does imply that, but
> it's not explicit.
> 

Setting IFF_MASTER is always correct because we're talking about a bond master device.
I.e. we're restoring the flags to a bond device itself. The bugs are different because
previously I had fixed the error path (partly, missed the IFF_SLAVE), but I just noticed
the normal enslave path while fixing the IFF_SLAVE one now. :)
So yes, both paths need the same treatment for both flags.

> 	Also, why is the call to ether_setup() from bond_setup() not
> also being converted to bond_ether_setup()?

That is more of a cleanup, the one there is correct because flags are set after that.
In that case only IFF_MASTER is needed, IFF_SLAVE cannot be set. Once these are
merged in net-next I'll send a followup to use it there, too.

> 
> 	-J
> 

Thanks,
 Nik

>> +
>> /* enslave device <slave> to bond device <master> */
>> int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
>> 		 struct netlink_ext_ack *extack)
>> -- 
>> 2.39.2
>>
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com

