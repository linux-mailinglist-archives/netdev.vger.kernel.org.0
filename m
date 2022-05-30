Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5219B5373B7
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 05:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbiE3Dfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 23:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiE3Dfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 23:35:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 11F3E6F48D
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 20:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653881725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4JkUbeFm3IAC7DyHjwzBXT2LJ0swGcfB7yhow1rougs=;
        b=A6AhHEqjgyw9Dc8gYfiNWnVD4vt8cc+gdOIwFHxgJCzvLqkD7/zQav0bb1M7AO8ORHZUV2
        bwgy992phJrle/untxVcpuwvdKJMPdB3qeblstzN680puWPsUNvw0nvkSLUKXYZ81mwcgA
        OAR+r1jGy4N9/vNOfwuTukzj3fPRVLM=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-srwEaQzNOgCFkw48k_G61Q-1; Sun, 29 May 2022 23:35:24 -0400
X-MC-Unique: srwEaQzNOgCFkw48k_G61Q-1
Received: by mail-qv1-f71.google.com with SMTP id q11-20020a05621410eb00b0046261e8925bso7465107qvt.14
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 20:35:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4JkUbeFm3IAC7DyHjwzBXT2LJ0swGcfB7yhow1rougs=;
        b=PoTwzqYfDKLEc61iWvi9btyvWnlistSGGtvVUyvvTjng4Sngmf+ITii4G+ELT3b5FW
         WUPo8/R/7C1du5qaTZ5GNiHG7wndz1tYLChRw8RHYbz5OR88XC7qhkOZOUeXo/lhLK6q
         J6O/BlEPscbXg2uNn914B1Kp9EYJ5N7X4Y0K6d7dEpyS3RVPOmKTqFyG6mBHdxzq7t0w
         j/ZpXZqzyUL/tXuJS3vsQEld2oTc5F+oqnjZWYJOQcBxHQZJWwrdZpP9NR5/htcVbND9
         qpbt9GyStfX56hcQ56wdbmg0Z3Qd68XMLT72jvUthVEaNTlsrpGFof8uVy3I05H+iFiM
         KLpg==
X-Gm-Message-State: AOAM533Yd4Itzlhu8WsNNy8lClLSRutNvJTC59OgoIUdoxTLdUwLJRe0
        SYNAj9HMjbUAGNGE308O92vW8oNhwUFbR7iMBDvxPbrbNuo9Ti9b62GSXpxL+AUgHEavPiDSR65
        UK9ZLO/hFsJfmA2dC
X-Received: by 2002:a05:620a:170e:b0:6a5:8d56:302c with SMTP id az14-20020a05620a170e00b006a58d56302cmr18530394qkb.620.1653881723606;
        Sun, 29 May 2022 20:35:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+fE7LuXHRjoI3i6VSjKTjd46+IlheVR7EGzoy2dYaOewm8xeV3Rwtfrlh0RGodRopnDJ8eA==
X-Received: by 2002:a05:620a:170e:b0:6a5:8d56:302c with SMTP id az14-20020a05620a170e00b006a58d56302cmr18530384qkb.620.1653881723392;
        Sun, 29 May 2022 20:35:23 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id 13-20020a37040d000000b006a603142d7fsm3556621qke.82.2022.05.29.20.35.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 May 2022 20:35:23 -0700 (PDT)
Message-ID: <734fdf5d-2647-274c-92b5-dab81abe4cbb@redhat.com>
Date:   Sun, 29 May 2022 23:35:21 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net] bonding: show NS IPv6 targets in proc master info
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, Li Liang <liali@redhat.com>
References: <20220527064419.1837522-1-liuhangbin@gmail.com>
 <e09cd8cf-4779-273e-a354-c1cfba120305@redhat.com> <18039.1653693705@famine>
 <YpQzd8BqidUc4IsT@Laptop-X1>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <YpQzd8BqidUc4IsT@Laptop-X1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/22 23:01, Hangbin Liu wrote:
> On Fri, May 27, 2022 at 04:21:45PM -0700, Jay Vosburgh wrote:
>> Jonathan Toppins <jtoppins@redhat.com> wrote:
>>
>>> On 5/27/22 02:44, Hangbin Liu wrote:
>>>> When adding bond new parameter ns_targets. I forgot to print this
>>>> in bond master proc info. After updating, the bond master info will looks
>>>                                                                look ---^
>>>> like:
>>>> ARP IP target/s (n.n.n.n form): 192.168.1.254
>>>> NS IPv6 target/s (XX::XX form): 2022::1, 2022::2
>>>> Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
>>>> Reported-by: Li Liang <liali@redhat.com>
>>>> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>>>> ---
>>>>    drivers/net/bonding/bond_procfs.c | 13 +++++++++++++
>>>>    1 file changed, 13 insertions(+)
>>>> diff --git a/drivers/net/bonding/bond_procfs.c
>>>> b/drivers/net/bonding/bond_procfs.c
>>>> index cfe37be42be4..b6c012270e2e 100644
>>>> --- a/drivers/net/bonding/bond_procfs.c
>>>> +++ b/drivers/net/bonding/bond_procfs.c
>>>> @@ -129,6 +129,19 @@ static void bond_info_show_master(struct seq_file *seq)
>>>>    			printed = 1;
>>>>    		}
>>>>    		seq_printf(seq, "\n");
>>>
>>> Does this need to be guarded by "#if IS_ENABLED(CONFIG_IPV6)"?
>>
>> 	On looking at it, the definition of ns_targets in struct
>> bond_params isn't gated by CONFIG_IPV6, either (and is 256 bytes for
>> just ns_targets).
>>
>> 	I suspect this will all compile even if CONFIG_IPV6 isn't
>> enabled, since functions like ipv6_addr_any are defined regardless of
>> the CONFIG_IPV6 setting, but it's dead code that shouldn't be built if
>> CONFIG_IPV6 isn't set.
> 
> Yes, I didn't protect the code if if could be build without CONFIG_IPV6.
> e.g. function bond_get_targets_ip6(). Do you think if I should also
> add the condition for bond_get_targets_ip6() and ns_targets in struct
> bond_params?

Yes, if the code that will use the entries in `struct bonding` and 
`struct bond_params` is going to be compiled out these entries should be 
compiled out as well.

Also, I was looking over the code in bond_options.c:bond_opts, and the 
entry `BOND_OPT_NS_TARGETS` is the only bonding option that will be left 
uninitialized if IPv6 is disabled. Does the bonding options infra handle 
this correctly or do you need a dummy set of values when IPv6 is disabled?

