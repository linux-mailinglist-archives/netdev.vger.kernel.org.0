Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98E6571400
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 10:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbiGLIJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 04:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbiGLIJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 04:09:20 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A630B63933
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:09:15 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id o8so4259174wms.2
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=IziEOuGYcYme/mdtH68Fi57lU8K4LMkTI3NOGe9gZsc=;
        b=D/dGd/tZtAbaSbYqE2R7bO3IuKlbCY/b/9/iJwqxtI4LSxKKRbIniVSJ48TzY1w9+B
         re4y8GKSwnZQth43oDykh0EZWdJhE1Sr6/3fv7QLL41qffvGZCkSOcpXlbOmgvQLH0Hp
         VAJTfV8olMOicf6GFRTZLqVhjLbh4aCMaMN5buJWjBmFTQMqdxL4gK/2q7TiQJ7GXCbq
         deTQkuAfpU0J2GvHqbrYJ+NL2jUrPVuJ1/3N7obLS8l6e+FZ0o2lyW+tUgBfuHDpUYl4
         RQs4wTJAwDCsiPlCLBUJcupEUNRcAYhuzUgzkm2tSeSk9iofWJacWOPEqfmqMeOBVj54
         Bojg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=IziEOuGYcYme/mdtH68Fi57lU8K4LMkTI3NOGe9gZsc=;
        b=MDOo8lgTAYdOXYBiYYzJDyuAHivRboeWVpMNQtydPrCYZDnGcTJedkfxZ4QggAW3dw
         5XD1JJ8oS7tsn2Em205hKRumYQrBBQHs6s/9dh7591nr/Z7ydbs6y5tSkBigKoXdS/Us
         TumAGPZ/sLPOsJH/kHg6v3Iuq0mhVQmycMYV6xrtp1hgHQfVG+aEHDwyQ/LmlkNCIH81
         51z7VgUVw5m+KfmikTfJQfWqbBAVUPMwe48uuuRwHAuKPt3v+J9NxcCs6i40EzLx6+/d
         P0W/cWANNOyglVFQCsnHJfe4tOL5bnuqPpJlAgjEAoFkYz5Vi56Wi+w+nv2mOJlxyiaS
         EJ4w==
X-Gm-Message-State: AJIora/ssFfKF6DOX5FC5mzXXe6gu6k+XY39JknGxh9tpnXm2eDqez2c
        al4C1AMTT0rI5II+8ofOYpi2qQ==
X-Google-Smtp-Source: AGRyM1sKm0XRvOSRGpjXEgzFqIyWN1y6Tr8b5k9ykapxwoI7Djpq9IFu3cMOfkbJiKFBHOiAAI7YiQ==
X-Received: by 2002:a05:600c:898:b0:3a2:cef5:9d80 with SMTP id l24-20020a05600c089800b003a2cef59d80mr2433280wmp.39.1657613354518;
        Tue, 12 Jul 2022 01:09:14 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:6422:a9c9:641f:c60b? ([2a01:e0a:b41:c160:6422:a9c9:641f:c60b])
        by smtp.gmail.com with ESMTPSA id n18-20020a5d4012000000b0021d83eed0e9sm7710681wrp.30.2022.07.12.01.09.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 01:09:13 -0700 (PDT)
Message-ID: <f8eb52c3-40a7-6de2-9496-7a118c4af077@6wind.com>
Date:   Tue, 12 Jul 2022 10:09:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP
 frames
Content-Language: en-US
To:     Matthias May <matthias.may@westermo.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Jakub Kicinski <kuba@kernel.org>
References: <20220705145441.11992-1-matthias.may@westermo.com>
 <20220705182512.309f205e@kernel.org>
 <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
 <20220706131735.4d9f4562@kernel.org>
 <bcfcb4a9-0a2f-3f12-155c-393ac86a8974@westermo.com>
 <20220707170145.0666cd4c@kernel.org>
 <b046ef4e-cb97-2430-ab56-e2b615ac29eb@westermo.com>
 <20220711112911.6e387608@kernel.org>
 <331695e3-bfa3-9ea7-3ba9-aebd0689251c@westermo.com>
 <42015af3-daa5-7435-725e-8197adbbf3b8@6wind.com>
 <88cbeaff-4300-b2c4-3d00-79918ec88042@westermo.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <88cbeaff-4300-b2c4-3d00-79918ec88042@westermo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 12/07/2022 à 09:51, Matthias May a écrit :
> On 7/12/22 09:17, Nicolas Dichtel wrote:
>> Le 12/07/2022 à 00:06, Matthias May a écrit :
>> [snip]
>>> One thing that puzzles me a bit: Is there any reason why the IPv6 version of ip
>>> tunnels is so... distributed?
>> Someone does the factorization for ipv4, but nobody for ipv6 ;-)
>>
>>> The IPv4 version does everything in a single function in ip_tunnels, while the
>>> IPv6 delegates some? of the parsing to
>>> the respective tunnel types, but then does some of the parsing again in
>>> ip6_tunnel (e.g the ttl parsing).
>> Note that geneve and vxlan use ip_tunnel_get_dsfield() / ip_tunnel_get_ttl()
>> which also miss the vlan case.
>>
>> Regards,
>> Nicolas
> 
> Hi Nicolas
> 
> Yeah i feared as much.
> My plan is to do the selftest for gretap, vxlan and geneve.
> Are there any other tunnel types that can carry L2 that i don't know about?
I don't think of another kind of tunnel.


Thank you,
Nicolas
