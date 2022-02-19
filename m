Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22BC94BC86E
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 13:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242258AbiBSMwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 07:52:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbiBSMwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 07:52:01 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA7224587;
        Sat, 19 Feb 2022 04:51:43 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id g1so4629171pfv.1;
        Sat, 19 Feb 2022 04:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=IMJgWx7dxr7dZx5sJ73qfcNpld1JI4tT0p225zF6cG0=;
        b=dU/T2yqk+TgCmfiFg32eSwNa84h7ucHYxp5k0GjToJPUGg8v7ZihB1stJ++D67aQ3W
         awd9XD+tPTro0CV5GOLHn0rUksImEBCRzv9NXCWW2tqzKuu1MQF7z6B6ZLcDmtBYzdWo
         oUMVr57B7QWpLDosa6OWHGxNRc48/OoPNT0v9oG5u6cmzq9SkNzdadnRivYFHHOjb2rA
         Jr0eyhUnHBkDjshM6OCuEk+YezSUQN8X+5oho8uBnZjDAPO38uIkHrG/gsGzswnRjegK
         VIcV5EF5vGdYs7CopG20Pc9MYDG/GHtXQXF1tQsbPq4EltMLXC3nOHshSjY1ItkN0xrc
         6A+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=IMJgWx7dxr7dZx5sJ73qfcNpld1JI4tT0p225zF6cG0=;
        b=mbkfqW03MeY0t+wpbvudVW6BXzRawQcGkjWjLbA5RaJCNAL/Vl+jo6vwgNv6bdPsWl
         E2SXUqnfcLuIN/D/g+sOi0PKGXRp4Q+Nmlqd/lRt6uYEqvLw+n0agWQCY9iuE/nmW7Dv
         R4QZYXtBZHC4RPYypv2f4mOSak3vwFEZJYQmyz0j8D20fRiyYV5OjaLvR6ku1BZuC0FU
         vSEkdF+vuiIWgyENUi5muOvpzLwo69J4fvzCh7IVxaXm4rmttB6jldFR6cZ12qQPkWMX
         zC05LUCifQ7PC1AdmjNAS9TqYslYSXQZyLadAfeKjxWsk/QzbjIauIJLvi6T0o5yKvC2
         Db9w==
X-Gm-Message-State: AOAM532YOhXKe5DrWj64OSSzZnSS+RoTJgvDhRIpprdUtnS47s5x279s
        KKWp9EKfSg35nbj0tGd3pPA=
X-Google-Smtp-Source: ABdhPJwO8xMzwzBLV7r4jxRlT9diEn26HFgySlHax5JoawxF3lfofBhUPh7s2vAQrZR/TVeGrJVCPA==
X-Received: by 2002:a05:6a00:b41:b0:4e1:3a1:50a7 with SMTP id p1-20020a056a000b4100b004e103a150a7mr12427960pfo.30.1645275102690;
        Sat, 19 Feb 2022 04:51:42 -0800 (PST)
Received: from [192.168.99.7] (i220-99-138-239.s42.a013.ap.plala.or.jp. [220.99.138.239])
        by smtp.googlemail.com with ESMTPSA id v20sm2181201pju.9.2022.02.19.04.51.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Feb 2022 04:51:42 -0800 (PST)
Message-ID: <24910a58-5d23-a97c-650f-7b53030dd40d@gmail.com>
Date:   Sat, 19 Feb 2022 21:51:37 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next 1/3] netfilter: flowtable: Support GRE
Content-Language: en-US
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Paul Blakey <paulb@nvidia.com>
References: <20220203115941.3107572-1-toshiaki.makita1@gmail.com>
 <20220203115941.3107572-2-toshiaki.makita1@gmail.com>
 <YgFdS0ak3LIR2waA@salvia> <9d4fd782-896d-4a44-b596-517c84d97d5a@gmail.com>
 <YgOQ6a0itcJjQJqx@salvia> <8309e037-840d-0a7d-26c1-f07fda9ba744@gmail.com>
In-Reply-To: <8309e037-840d-0a7d-26c1-f07fda9ba744@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ping, Pablo?

On 2022/02/12 10:54, Toshiaki Makita wrote:
> On 2022/02/09 19:01, Pablo Neira Ayuso wrote:
>> On Tue, Feb 08, 2022 at 11:30:03PM +0900, Toshiaki Makita wrote:
>>> On 2022/02/08 2:56, Pablo Neira Ayuso wrote:
>>>> On Thu, Feb 03, 2022 at 08:59:39PM +0900, Toshiaki Makita wrote:
>> [...]
>>>>> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
>>>>> index 889cf88..48e2f58 100644
>>>>> --- a/net/netfilter/nf_flow_table_ip.c
>>>>> +++ b/net/netfilter/nf_flow_table_ip.c
>> [...]
>>>>> @@ -202,15 +209,25 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const 
>>>>> struct net_device *dev,
>>>>>        if (!pskb_may_pull(skb, thoff + *hdrsize))
>>>>>            return -1;
>>>>> +    if (ipproto == IPPROTO_GRE) {
>>>>
>>>> No ifdef here? Maybe remove these ifdef everywhere?
>>>
>>> I wanted to avoid adding many ifdefs and I expect this to be compiled out
>>> when CONFIG_NF_CT_PROTO_GRE=n as this block is unreachable anyway. It rather
>>> may have been unintuitive though.
>>>
>>> Removing all of these ifdefs will cause inconsistent behavior between
>>> CONFIG_NF_CT_PROTO_GRE=n/y.
>>> When CONFIG_NF_CT_PROTO_GRE=n, conntrack cannot determine GRE version, thus
>>> it will track GREv1 without key infomation, and the flow will be offloaded.
>>> When CONFIG_NF_CT_PROTO_GRE=y, GREv1 will have key information and will not
>>> be offloaded.
>>> I wanted to just refuse offloading of GRE to avoid this inconsistency.
>>> Anyway this kind of inconsistency seems to happen in software conntrack, so
>>> if you'd like to remove ifdefs, I will do.
>>
>> Good point, thanks for explaining. LGTM.
> 
> Let me confirm, did you agree to keep ifdefs, or delete them?
> 
> Toshiaki Makita
