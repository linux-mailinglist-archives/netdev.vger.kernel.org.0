Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C9450011F
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 23:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239046AbiDMVYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 17:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239057AbiDMVYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 17:24:37 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB93D6A036;
        Wed, 13 Apr 2022 14:22:14 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id t12so3013854pll.7;
        Wed, 13 Apr 2022 14:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+X08DSG/wNY3wo7nWD+dVOpfZxmyUQ5QFyn/yBwqpvM=;
        b=an44rIKGAbQ06/p6QvCLRLjVZ+F34I0eg+iMhW7XJx6yPlvfIeHFvPJMr7Z7/pIn0S
         9GC20kjhsZjoODkQLQIWkd59pUHQM4/99wXtaqFM5Yi7jP5hWlK/YcqHhFWn5CbxJnR2
         gIjpHyI1nyjtjvv1QccC4qAxgx6QMbh/QoiDqWIry7BRp8gW0BZZm2FDS6qrswnc6Bdo
         xSj4rkONzAbK/+RUVY1oGjG5b2Nmn7/thqChKcxHNcHnymC727azLRETn2MaNU3W+OHZ
         SXkvjJvnL+50389O7j12r5LQbpArv3OVmuraqSwKIkIk6/m0/+rDM10LS0DAzz9Cto7d
         5zgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+X08DSG/wNY3wo7nWD+dVOpfZxmyUQ5QFyn/yBwqpvM=;
        b=JRp4cN6QsO7y0MOJUAjXHyjr6XVa9Xsgxw1YUWdtqTBIoMt18ZbSIsFvzWpa+KQbdO
         OYN0Sd+qNaihah/1BOfuXCH6Jr95397LGJyPc21fnMc179xOEfvMBrjOz58wcSKEkX1k
         LtG285fbhIn+tq/WUSdQGVl6TjgS6RIx22ufjXkfeeVpLOw8eXPDY0f+DmFubnctHk4k
         Q//bIwPAREvPOl8W4N8REOHFlrC+CBnDv+6CxwuICYbNDy7jkNqfUFM3BKvD0lpiVfJD
         yMvX2rkUFBEAlEiIuLBU+dKzxo3U3gDUDLx5M5DsTGQintX6TBxnYPTWpPTQpTUomwBV
         lteQ==
X-Gm-Message-State: AOAM533lkPIzcXnBWLDqI/LWRSI7NPusd4QchvHi8DrrmjiZhTR0nztl
        30YXOByghJAur8D1it1uRYM=
X-Google-Smtp-Source: ABdhPJzyrfk1LaEa181NDaE4Bh3o0Uwb2eaPySFMcmtdLjnUwvvdCWJXLA0PoL9SPkRMg0G56lAnWg==
X-Received: by 2002:a17:90b:3e8b:b0:1c7:852d:e843 with SMTP id rj11-20020a17090b3e8b00b001c7852de843mr103082pjb.244.1649884934409;
        Wed, 13 Apr 2022 14:22:14 -0700 (PDT)
Received: from ?IPV6:2620:15c:2c1:200:4cf8:b337:73c1:2c25? ([2620:15c:2c1:200:4cf8:b337:73c1:2c25])
        by smtp.gmail.com with ESMTPSA id d24-20020aa797b8000000b0050759ced9d9sm13100pfq.119.2022.04.13.14.22.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 14:22:13 -0700 (PDT)
Message-ID: <5a92f5cd-9af4-4228-dc44-b0c363f30e18@gmail.com>
Date:   Wed, 13 Apr 2022 14:22:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v3] net/ipv6: Introduce accept_unsolicited_na
 knob to implement router-side changes for RFC9131
Content-Language: en-US
To:     Arun Ajith S <aajith@arista.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, prestwoj@gmail.com, gilligan@arista.com,
        noureddine@arista.com, gk@arista.com
References: <20220413143434.527-1-aajith@arista.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220413143434.527-1-aajith@arista.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/13/22 07:34, Arun Ajith S wrote:
> Add a new neighbour cache entry in STALE state for routers on receiving
> an unsolicited (gratuitous) neighbour advertisement with
> target link-layer-address option specified.
> This is similar to the arp_accept configuration for IPv4.
> A new sysctl endpoint is created to turn on this behaviour:
> /proc/sys/net/ipv6/conf/interface/accept_unsolicited_na.


Do we really need to expose this to /proc/sys, for every interface added 
in the host ?

/proc files creations/deletion cost a lot in environments 
adding/deleting netns very often.

I would prefer using NETLINK attributes, a single recvmsg() syscall can 
fetch/set hundreds of them.



