Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A9D4FF2C9
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbiDMI5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbiDMI5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:57:33 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15984B85A
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 01:55:12 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id k23so2551284ejd.3
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 01:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ez9/yP1s87N+1yj0ixi93WFUp2UAs8p8KEyavyAbZ4o=;
        b=Jc4YQVsDKpV89pGPAWo5qWsUEX9okNNbUdQX5waBxGzmnQiQa/mbsc9ZD/haG+LijO
         wBtj5avf0qvFtY4eZxpnnA55k5A2OspSD97kZ2fYlOs84zBpTqO//g12Z/5lFFrmpFKF
         Mfr+40RnFzzv60rkA2OUXGs29OLkiUcAnggK05totC4vJ7EGKgIFy+aQCAq4g2JHb3Wa
         mRLTWBPSvbroOmN593TaRbfmmE5cHaHAgkjsKMFYStHg83RLu/zcao595PAyeZ+ymfWT
         AN5Zi08DkUGSccOOFOoDGdHrNkipiDg9RUFpdoEgBismi6W5WqQPWVh83jz/NBHz675E
         g2mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ez9/yP1s87N+1yj0ixi93WFUp2UAs8p8KEyavyAbZ4o=;
        b=ZgBZlfKWNvLWctE14pBaR5s5n39dsG/m5+prreofE7ytYssVkUc0eZrBBIFk9gJWwb
         zTv1BYzDDVrMUQFZpgJhYrYPI2/7kLD3izn0YbKAXxpLrFcFNXGtF4sUQ2rBliygTEPS
         tUzGD3t3t/zpPRhWAh+CRLzNqP4mZWTAklcICRjX0Qj4TJeRgDdUPAVie0DUsJx7hHWb
         PP3RtO0mIQjjcpBZuUhDrcRdOXXq148zL0ZLBl0rQ0Nglc5cmCsWqEjvSqQtbyez2u85
         ZMWItdJ/d8sYZIxCQBLmI3eCfB29uvWEo6lboabVGUgoXwBEiaHJSGYTcnAJRD6LQT/s
         aVLA==
X-Gm-Message-State: AOAM532N3QLsW2GAsF1ro3zforYy2alLQUYkYHNvvpzigKfjMSa2Nj90
        vJHi7RufuhDJo9hizepT/TTBXA==
X-Google-Smtp-Source: ABdhPJyt2pD1+D9SWy2qEWWoMVlRshABpiAdz6j/3FBhooBaVqJtmlotjh+vBVhh2gPEFQkFGrRfcw==
X-Received: by 2002:a17:907:1b20:b0:6da:649b:d99e with SMTP id mp32-20020a1709071b2000b006da649bd99emr37888295ejc.712.1649840111115;
        Wed, 13 Apr 2022 01:55:11 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id do8-20020a170906c10800b006dfe680dbfcsm13899620ejc.43.2022.04.13.01.55.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 01:55:10 -0700 (PDT)
Message-ID: <96bb8ff0-26d8-e9d3-e7c8-78f2abd28126@blackwall.org>
Date:   Wed, 13 Apr 2022 11:55:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RFC net-next 08/13] net: bridge: avoid classifying unknown
 multicast as mrouters_only
Content-Language: en-US
To:     Joachim Wiberg <troglobit@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220411133837.318876-1-troglobit@gmail.com>
 <20220411133837.318876-9-troglobit@gmail.com>
 <ebd182a2-20bc-471c-e649-a2689ea5a5d1@blackwall.org>
 <87v8ve9ppr.fsf@gmail.com>
 <5d597756-2fe1-e7cc-9ef3-c0323e2274f2@blackwall.org>
 <87pmll9xj1.fsf@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <87pmll9xj1.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/04/2022 11:51, Joachim Wiberg wrote:
> On Tue, Apr 12, 2022 at 20:37, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>> On 12/04/2022 20:27, Joachim Wiberg wrote:
>>> [snip]
>>> From this I'd like to argue that our current behavior in the bridge is
>>> wrong.  To me it's clear that, since we have a confiugration option, we
>>> should forward unknown IP multicast to all MCAST_FLOOD ports (as well as
>>> the router ports).
>> Definitely not wrong. In fact:
>> "Switches that do not forward unregistered packets to all ports must
>>  include a configuration option to force the flooding of unregistered
>>  packets on specified ports. [..]"
>> is already implemented because the admin can mark any port as a router and
>> enable flooding to it.
> 
> Hmm, I understand your point (here and below), and won't drive this
> point further.  Instead I'll pick up on what you said in your first
> reply ... (below, last)
> 
> Btw, thank you for taking the time to reply and explain your standpoint,
> really helps my understanding of how we can develop the bridge further,
> without breaking userspace! :)
> 
>>> [1]: https://www.rfc-editor.org/rfc/rfc4541.html#section-2.1.2
>> RFC4541 is only recommending, it's not a mandatory behaviour. This
>> default has been placed for a very long time and a lot of users and
>> tests take it into consideration.
> 
> Noted.
> 
>> We cannot break such assumptions and start suddenly flooding packets,
>> but we can leave it up to the admin or distribution/network software
>> to configure it as default.
> 
> So, if I add a bridge flag, default off as you mentioned out earlier,
> which changes the default behavior of MCAST_FLOOD, then you'd be OK with
> that?  Something cheeky like this perhaps:
> 
>     if (!ipv4_is_local_multicast(ip_hdr(skb)->daddr))
>        	BR_INPUT_SKB_CB(skb)->mrouters_only = !br_opt_get(br, BROPT_MCAST_FLOOD_RFC4541);

Exactly! And that is exactly what I had in mind when I wrote it. :)

Thanks,
 Nik

> 
> 
> Best regards
>  /Joachim

