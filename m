Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E98592ACB
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 10:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbiHOHcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 03:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiHOHcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 03:32:18 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33B818B15
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 00:32:16 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a7so12203257ejp.2
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 00:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=WJLEPHsAZp8U37aoOrddvhy4zTgTsBLms1gLLOoidx8=;
        b=Apiwg8lXWfx0PuHphZbC+0CSw/jecCBMO4b4h6hmcINbjWREv2rl1SeXAn7r5NEZN6
         BCxZfoOq0tp+FSVLcgR3MYKwJIEi/l9BfvdCuAib3La4b5VBblthG2Lj2q3O8wMlbvBI
         oJANIx421UuLYpOSwIMHsynvxi9Cm2EJNUDIIG5JnvF1HjGUJ9keBoofJgEeNWmS1SDy
         VZxC3zCdqrMwgVM/U4J1vf8M3KFgNGdrJCVK94XY/tdLJcrBE+rkLhdn1PY8XSJ31ukI
         vw4pcSW7DYwX7PNmhDvQvlMUSrscDHBTibnECxoWwdk7RbsserN0v8OXSXVX2UmcEkjm
         Bt0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=WJLEPHsAZp8U37aoOrddvhy4zTgTsBLms1gLLOoidx8=;
        b=SbLcuQsdYmYdwyqWBFkHJwQeY8YYBeYgsDIdMj20GgMhZAJhDIj/dxw+VNiVEyscSc
         3uVjd8RHo4BT3/8LNCuXcvdcCo1UIT0Kvo36xBG19Qnpt6zpJvqQ7iHDd0RuKYU98cTB
         l0xBdZ8CUlUTynav05RTnADO04EJmPNXQkCG1WFqNB0PVefFSR6jSjJDdgVLzAGG5+hz
         uGfUhR0VTQViCXeQ8Y8zp+8c4bsPZEgZ0g4LnwyyKULSylKraM01PedFIO09zdfXRME2
         POqVx0Kr44fW8lhW5vKOczcvZNI0g0KAOI2t4BjKxPK7nDgebDWvN/lZSHwb3kQDhTGM
         22Mg==
X-Gm-Message-State: ACgBeo3yafZXUb953VkJzu4tWikZmbzfvAqojhmz9KdvIEOBgpEvYZGJ
        vS4OFIE7URpTmPlQ4cRM0QepiQ==
X-Google-Smtp-Source: AA6agR5aKYPCzgLDNmCoxSU0zm6D7mFfVrKEn7+YQ7XB5w7ebixaOlegmzsNAq3fiAoaNyIoRR2CNA==
X-Received: by 2002:a17:907:1ca8:b0:730:871e:498c with SMTP id nb40-20020a1709071ca800b00730871e498cmr9570990ejc.651.1660548735151;
        Mon, 15 Aug 2022 00:32:15 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id bt2-20020a0564020a4200b0043d1eff72b3sm6206029edb.74.2022.08.15.00.32.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 00:32:14 -0700 (PDT)
Message-ID: <94ab0304-a674-3504-c1bd-3492e2ded0b1@blackwall.org>
Date:   Mon, 15 Aug 2022 10:32:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next] net: rtnetlink: fix module reference count leak
 issue in rtnetlink_rcv_msg
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     idosch@nvidia.com, petrm@nvidia.com, florent.fourcot@wifirst.fr,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
References: <20220815024629.240367-1-shaozhengchao@huawei.com>
 <feff23c6-529c-3421-c48c-463846e59630@blackwall.org>
In-Reply-To: <feff23c6-529c-3421-c48c-463846e59630@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/08/2022 08:44, Nikolay Aleksandrov wrote:
> On 15/08/2022 05:46, Zhengchao Shao wrote:
>> When bulk delete command is received in the rtnetlink_rcv_msg function,
>> if bulk delete is not supported, module_put is not called to release
>> the reference counting. As a result, module reference count is leaked.
>>
>> Fixes: a6cec0bcd342("net: rtnetlink: add bulk delete support flag")
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>>  net/core/rtnetlink.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>> index ac45328607f7..4b5b15c684ed 100644
>> --- a/net/core/rtnetlink.c
>> +++ b/net/core/rtnetlink.c
>> @@ -6070,6 +6070,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
>>  	if (kind == RTNL_KIND_DEL && (nlh->nlmsg_flags & NLM_F_BULK) &&
>>  	    !(flags & RTNL_FLAG_BULK_DEL_SUPPORTED)) {
>>  		NL_SET_ERR_MSG(extack, "Bulk delete is not supported");
>> +		module_put(owner);
>>  		goto err_unlock;
>>  	}
>>  
> 
> Oops, thanks.
> Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

By the way I think this should be targeted at -net,
I didn't notice the net-next tag earlier.
