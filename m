Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B303350DF54
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 13:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbiDYLvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 07:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241859AbiDYLvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 07:51:25 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA70419BA;
        Mon, 25 Apr 2022 04:47:28 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id i5so1385357wrc.13;
        Mon, 25 Apr 2022 04:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zL3zAyFVSY3b9tOnPyfU+7HZbn2fwn34DVHclMTOxIM=;
        b=LrsaqLT1q3SQ0uASZlNpLZwn2OT10CWeUnsTzofQWIG4W4bfOEmT13Q91UpjOLMq7s
         lrpBPBf94SI7EbFNxbrX+Z/FunV8lwcQwOa8PswQHuORAvup4TEAo9xf7hVSakwwOPnA
         GuyV9BEc3s+TJiupOCo9LTsOKC9C6/h//ZfyR20aJ+FFVWNNnmWzPtf364WCXaoPaiM5
         lJvrTGrUjdYY83vBcra2zXLR6P5SmQ0YLe3A8WGIcfxftiwix3egfw7A3/HPPdM1/fDx
         ZBTN1+CxT+TbhNO/G/yP80ZMrIydOgwnA8vEQlWD/vnscKXAi3LFneb72yKNQ2XFhKBZ
         2N3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zL3zAyFVSY3b9tOnPyfU+7HZbn2fwn34DVHclMTOxIM=;
        b=XGOdm79+Txkp8Bm/ZtNaosl/Th6ULIPA+uOXtBvEcqXujxtMttB+uF2PGmkjrRnWd3
         Jtz4rYhDiMM9LOj/WD3J3QkPamMjTkIXU+5wakZJFx/LASxkw8NZSgKk96JwadMGQvYa
         Ic+OOqJ5u7d0miG/9+Kpd2afIJs4N48QnRfkh18Q8bdymJls+YjmK18RunWTmNbPnjEH
         NkaAuK7zFZKQzED/+wcKLOuO221n49MGudmNNah8U0wELzITNXpmsFLoXYByx7YfXmku
         JrQXD9ewklh3AXVeJIyqaocMq/qWx3szQJBHzEVBfGC6spSqsefs/caFRwaR9Nl6cVco
         vmaw==
X-Gm-Message-State: AOAM5320HPqZ17xZt35+8Iriaw1hg2HT15EvybCshFwsVui3xrjIlw9X
        gaG+zL3Q1O2LG/OIe3U8Pdw=
X-Google-Smtp-Source: ABdhPJyszTsPH0cgFDvwgEGg3ulNmRSFpWw0T28e1SHB0fW84CGCOgMtYS/1BwvzpMIoRdQ6c5PcsA==
X-Received: by 2002:a5d:5228:0:b0:20a:d7e9:7ed8 with SMTP id i8-20020a5d5228000000b0020ad7e97ed8mr5654205wra.687.1650887247334;
        Mon, 25 Apr 2022 04:47:27 -0700 (PDT)
Received: from [192.168.1.5] ([41.42.183.233])
        by smtp.gmail.com with ESMTPSA id f4-20020a7bc8c4000000b0038ebbe10c5esm11185583wml.25.2022.04.25.04.47.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 04:47:26 -0700 (PDT)
Message-ID: <1efd4c00-4c78-2330-cfb3-fe81493e7e68@gmail.com>
Date:   Mon, 25 Apr 2022 13:47:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v3 1/2] rtnetlink: add extack support in fdb del
 handlers
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa@nvidia.com, jdenham@redhat.com,
        sbrivio@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, shshaikh@marvell.com,
        manishc@marvell.com, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        GR-Linux-NIC-Dev@marvell.com, bridge@lists.linux-foundation.org
References: <cover.1650800975.git.eng.alaamohamedsoliman.am@gmail.com>
 <c3a882e4fb6f9228f704ebe3c1fcace14ee6cdf2.1650800975.git.eng.alaamohamedsoliman.am@gmail.com>
 <7c8367b6-95c7-ea39-fafe-72495f343625@blackwall.org>
 <d89eefc2-664f-8537-d10e-6fdfbb6823ed@gmail.com>
 <4bf69eef-7444-1238-0f4a-fb0fccda080c@blackwall.org>
 <3bcb2d3d-8b8b-8a8f-1285-7277394b4e6b@gmail.com>
 <0f1e1250-920a-c7d1-900c-98ef3e0456d8@blackwall.org>
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
In-Reply-To: <0f1e1250-920a-c7d1-900c-98ef3e0456d8@blackwall.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On ٢٤‏/٤‏/٢٠٢٢ ٢٣:٥٢, Nikolay Aleksandrov wrote:
> On 4/25/22 00:09, Alaa Mohamed wrote:
>>
>> On ٢٤‏/٤‏/٢٠٢٢ ٢١:٥٥, Nikolay Aleksandrov wrote:
>>> On 24/04/2022 22:49, Alaa Mohamed wrote:
>>>> On ٢٤‏/٤‏/٢٠٢٢ ٢١:٠٢, Nikolay Aleksandrov wrote:
>>>>> On 24/04/2022 15:09, Alaa Mohamed wrote:
>>>>>> Add extack support to .ndo_fdb_del in netdevice.h and
>>>>>> all related methods.
>>>>>>
>>>>>> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
>>>>>> ---
>>>>>> changes in V3:
>>>>>>           fix errors reported by checkpatch.pl
>>>>>> ---
>>>>>>    drivers/net/ethernet/intel/ice/ice_main.c        | 4 ++--
>>>>>>    drivers/net/ethernet/mscc/ocelot_net.c           | 4 ++--
>>>>>>    drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 2 +-
>>>>>>    drivers/net/macvlan.c                            | 2 +-
>>>>>>    drivers/net/vxlan/vxlan_core.c                   | 2 +-
>>>>>>    include/linux/netdevice.h                        | 2 +-
>>>>>>    net/bridge/br_fdb.c                              | 2 +-
>>>>>>    net/bridge/br_private.h                          | 2 +-
>>>>>>    net/core/rtnetlink.c                             | 4 ++--
>>>>>>    9 files changed, 12 insertions(+), 12 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c 
>>>>>> b/drivers/net/ethernet/intel/ice/ice_main.c
>>>>>> index d768925785ca..7b55d8d94803 100644
>>>>>> --- a/drivers/net/ethernet/intel/ice/ice_main.c
>>>>>> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
>>>>>> @@ -5678,10 +5678,10 @@ ice_fdb_add(struct ndmsg *ndm, struct 
>>>>>> nlattr __always_unused *tb[],
>>>>>>    static int
>>>>>>    ice_fdb_del(struct ndmsg *ndm, __always_unused struct nlattr 
>>>>>> *tb[],
>>>>>>            struct net_device *dev, const unsigned char *addr,
>>>>>> -        __always_unused u16 vid)
>>>>>> +        __always_unused u16 vid, struct netlink_ext_ack *extack)
>>>>>>    {
>>>>>>        int err;
>>>>>> -
>>>>>> +
>>>>> What's changed here?
>>>> In the previous version, I removed the blank line after "int err;" 
>>>> and you said I shouldn't so I added blank line.
>>>>
>>> Yeah, my question is are you fixing a dos ending or something else?
>>> The blank line is already there, what's wrong with it?
>> No, I didn't.
>>>
>>> The point is it's not nice to mix style fixes and other changes, 
>>> more so
>>> if nothing is mentioned in the commit message.
>> Got it, So, what should I do to fix it?
>
> Don't change that line? I mean I'm even surprised this made it in the 
> patch. As I mentioned above, there is already a new line there so I'm 
> not sure how you're removing it and adding it again. :)
>
> Cheers,
>  Nik


Thanks Nik, I will fix this.

