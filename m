Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD27855D8E4
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245372AbiF1IXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245440AbiF1IWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:22:19 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DEF2E0B6;
        Tue, 28 Jun 2022 01:21:22 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x4so11359504pfq.2;
        Tue, 28 Jun 2022 01:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=K38YHnI8KKXEsu+LVCyhxZDBDqf305H9Xn5K2Tu2gdA=;
        b=N6AaPW03jIoV2m3jDKOx4pZa24jTgD/3obADz9jYwVMbUqqYOjh9HHQepI7obo9wo1
         bGAnpuqAsT6TCAz72wo6D/wlLXkKIQht7p667oB/N8IjpA74e4UlPc0XMIhBJm1B7Nig
         V7dwJqhlz4TcofZTq6TLk9Jj6p/adcYBVBMkO+cvR3feAbT1uzgx8vShHwdXAeYI8c1F
         7bCFh3bcy1qEySiJHQlp321EH3/2dWywbkNqSmS316O/pfb725/OcysXIwe+Ru+WIrHI
         B43issXB70i//e3PNTODJkyyapwE+Qlnuq+deTrSejnld9dVqe4KdErNZ+2IYyWJ20ji
         dCFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K38YHnI8KKXEsu+LVCyhxZDBDqf305H9Xn5K2Tu2gdA=;
        b=KRDnFXF985oDli69q00w8RKSISzMqqd48Q7sulfQ6P8xnaVIjCEFiVg0OweIUEPz/H
         k6+wMQe3rkbD+FAhGMoKiIlVVSlfyRC79by238aM++5i63xziNQLJiKxAd/BPAmk0B0m
         jwKegt9OFZz8Hm7+aNpKPg+gdIdo0xnpPHuKhSTmKidreOsdW4NRJlx8Vamk2ryFte95
         hHRERkdyMlBbNl+VOwzsynqA9eFz3m2ZW9D3HLTUIrfh/+7eQ7ejjyA6KuloYzWHbay9
         WqMeoMutHVr/Yay58y1tSa2quIvOExTQyyQpUd0gZuSbs69MHAYP1n3I0iE/2oGuwk4T
         SSdA==
X-Gm-Message-State: AJIora9AudDD9ajG1uIHNUfJKW6ElF9YSwPkSwIDoaVUvcZ7IxXijfQW
        taBoC0eFb6jgykWp7O1McqA=
X-Google-Smtp-Source: AGRyM1vzV0946cmKDfPi8etd9t3x9Axs+ph84lTvs8chlDQbrEfCA3LifQ8bYyHlY/LrpZ2pZ2PEpw==
X-Received: by 2002:a63:ef0b:0:b0:40d:287d:71e1 with SMTP id u11-20020a63ef0b000000b0040d287d71e1mr16695519pgh.330.1656404482154;
        Tue, 28 Jun 2022 01:21:22 -0700 (PDT)
Received: from [192.168.50.247] ([103.84.139.165])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902bd8500b001640beeebf1sm8510168pls.268.2022.06.28.01.21.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 01:21:21 -0700 (PDT)
Message-ID: <8f647d13-ed5d-6799-97b1-3f5061879d9e@gmail.com>
Date:   Tue, 28 Jun 2022 16:21:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] net: tipc: fix possible infoleak in tipc_mon_rcv()
Content-Language: en-US
To:     Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
References: <20220628025921.14767-1-hbh25y@gmail.com>
 <DB9PR05MB9078C87512422E22556EDA3888B89@DB9PR05MB9078.eurprd05.prod.outlook.com>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <DB9PR05MB9078C87512422E22556EDA3888B89@DB9PR05MB9078.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/6/28 11:35, Tung Quang Nguyen wrote:
>> -----Original Message-----
>> From: Hangyu Hua <hbh25y@gmail.com>
>> Sent: Tuesday, June 28, 2022 9:59 AM
>> To: jmaloy@redhat.com; ying.xue@windriver.com; davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
>> pabeni@redhat.com
>> Cc: netdev@vger.kernel.org; tipc-discussion@lists.sourceforge.net; linux-kernel@vger.kernel.org; Hangyu Hua <hbh25y@gmail.com>
>> Subject: [PATCH] net: tipc: fix possible infoleak in tipc_mon_rcv()
>> 
>> dom_bef is use to cache current domain record only if current domain
>> exists. But when current domain does not exist, dom_bef will still be used
>> in mon_identify_lost_members. This may lead to an information leak.
>> 
>> Fix this by adding a memset before using dom_bef.
>> 
>> Fixes: 35c55c9877f8 ("tipc: add neighbor monitoring framework")
>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com <mailto:hbh25y@gmail.com>>
>> ---
>>  net/tipc/monitor.c | 1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
>> index 2f4d23238a7e..67084e5aa15c 100644
>> --- a/net/tipc/monitor.c
>> +++ b/net/tipc/monitor.c
>> @@ -534,6 +534,7 @@ void tipc_mon_rcv(struct net *net, void *data, u16 dlen, u32 addr,
>>        state->peer_gen = new_gen;
>> 
>>        /* Cache current domain record for later use */
>> +     memset(&dom_bef, 0, sizeof(dom_bef));
>>        dom_bef.member_cnt = 0;
> Please remove /dom_bef.member_cnt = 0;/ if memset() is used instead.

I get it. I will send a v2.

Thanks,
Hangyu

>>        dom = peer->domain;
>>        if (dom)
>> --
>> 2.25.1
