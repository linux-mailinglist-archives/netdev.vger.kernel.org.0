Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A156BA545
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 03:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjCOCfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 22:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjCOCfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 22:35:30 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68EA222E8
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 19:35:28 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id cu4so10814391qvb.3
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 19:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678847728;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=k60uTOzXuChvzn2np5uUQNVn4LZ9LzazDqYnay7JMh8=;
        b=oNrDvj+VP5qTnk9gH+Rk4zAmBnunsYOOU8y+sStXEm8l+CFB5z+VNihkhzCYQcT8RN
         d7pmPqFWSPzRQX0n5VjxPrAG9hJnMCv0ItloQy6s9GrDuGm+frgrW4ZZ0TNUaRG+yw7s
         uRtuD+WUHhgYD0HE5Lmsjqbkse6/Bda46uvVqn/RZuQzwTaufYfZvsRwrnX2ietqq4TY
         XLmpMIq22Uw6le+Ug5UQ3Ag9FCKBX6/eJAADwkO7A181gQj9eHl0kRdeGMjpEJxqbyS+
         eSL6KLcXS2LGs+LZO3ZsJhMiZQL8prcungPf9gBgzPokyQYGJsRFJSVRsGHDeQV5ZMaq
         WHMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678847728;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k60uTOzXuChvzn2np5uUQNVn4LZ9LzazDqYnay7JMh8=;
        b=VDbLMf+4xFsgBOIsd0pg9d8hZGUYpOOwCBhnOEUEV1aMx1C7xN4UN1XIaeARwHBPcq
         CTjIjK94rOwHUM6eC+kFYKYdfCMuZg2dwUaPbZGmMjHP+pg2nsCGQWYP77mXNO7mZVgG
         4cYzUS4E5nZakpSkAA1UoBMBYjIEyelWk3Pzzn9RYWDter1zjJ01TS6dML9r1xl8/BYz
         I1/oxVJs3OzCQUWptUJWY8+6sNYZPe8UyOb5RBkNSWVC5eGl3lubyDGBXWlZyrl1vsSE
         xC85K6QLpm0KcwIm4Ais3qsacqYaI22Yx8XbzhBOMTNFKiwqymcpsVWo6MD74JWiwHtL
         DYnQ==
X-Gm-Message-State: AO0yUKWsyyRW6B4AiEV8mZMh7Yp2PxgNz40fwNEYGEZXVpHjVnegZiKL
        i+fx4c/hxCfb6zT/RSIhmEOQcVInv8Q=
X-Google-Smtp-Source: AK7set+TQbsOVJxVLu2616o6Qh2KI/bvFRGbgZEFJ4Gm40w5qDAbHZO6i4k1lcc+gRfKcdgFPrd96A==
X-Received: by 2002:a05:6214:e6c:b0:56e:a980:e8f1 with SMTP id jz12-20020a0562140e6c00b0056ea980e8f1mr21676194qvb.32.1678847727839;
        Tue, 14 Mar 2023 19:35:27 -0700 (PDT)
Received: from ?IPV6:2607:fea8:1b9f:c5b0::4c4? ([2607:fea8:1b9f:c5b0::4c4])
        by smtp.gmail.com with ESMTPSA id do51-20020a05620a2b3300b007435a646354sm3001139qkb.0.2023.03.14.19.35.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 19:35:27 -0700 (PDT)
Message-ID: <5b77c287-aad3-3bdb-8d7f-56d91ba1c282@gmail.com>
Date:   Tue, 14 Mar 2023 22:35:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Etienne Champetier <champetier.etienne@gmail.com>
Subject: Re: mv88e6xxx / MV88E6176 + VLAN-aware unusable in 5.15.98 (ok in
 5.10.168) (resend)
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Linux Netdev List <netdev@vger.kernel.org>
References: <cd306c78-14a6-bebb-e174-2917734b4799@gmail.com>
 <20230313223049.sjlxagsmbpjwwyqj@skbuf>
Content-Language: en-US, fr-FR
In-Reply-To: <20230313223049.sjlxagsmbpjwwyqj@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 13/03/2023 à 18:30, Vladimir Oltean a écrit :
> Hi Etienne,
>
> On Sun, Mar 12, 2023 at 12:41:32AM -0500, Etienne Champetier wrote:
>> I get tagged frame with VID 3 on lan4 (at least some multicast & broadcast), but lan4 is not a member of VLAN 3
>> Also unicast frames from wifi to lan4 exit tagged with VID 2, broadcast frames are fine (verifed with scapy)
>> Reverting
>> 5bded8259ee3 "net: dsa: mv88e6xxx: isolate the ATU databases of standalone and bridged ports" from Vladimir
>> and
>> b80dc51b72e2 "net: dsa: mv88e6xxx: Only allow LAG offload on supported hardware"
>> 57e661aae6a8 "net: dsa: mv88e6xxx: Link aggregation support"
>> from Tobias allow me to get back to 5.10 behavior / working system.
>>
>> On the OpenWrt side, 5.15 is the latest supported kernel, so I was not able to try more recent for now.
> I don't know and I am not able to reproduce this on Turris MOX with a linux-5.15.y
> kernel fromhttps://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git.
>
> Could we approach this from the other end? I would like to try and
> reproduce the issue with the kernel you are using. But I have no idea
> how to use OpenWRT or to navigate through its build system. Could you
> help me figure out which source code is built for the Omnia board (plus
> additional OpenWRT patches, if any)?

OpenWrt doesn't support Turris Mox, but here is what is built for Omnia 
as far as I understand

- Linux 5.15.98: 
https://github.com/openwrt/openwrt/blob/0aedf916df364771be47ffda8ff3465250ecee77/include/kernel-5.15

- some generic patches (backport-5.15 / pending-5.15 / hack-5.15): 
https://github.com/openwrt/openwrt/tree/0aedf916df364771be47ffda8ff3465250ecee77/target/linux/generic

- some arch specific patches: 
https://github.com/openwrt/openwrt/tree/0aedf916df364771be47ffda8ff3465250ecee77/target/linux/mvebu/patches-5.15

(not 100% sure in what order they are applied)

- config is generated by taking config-5.15 in generic, mvebu and 
mvebu/cortexa9 and somehow merging them

The wifi code (mac80211 / ath10k) uses kernel backports, so it's 
actually 6.1-rc8 based 
https://github.com/openwrt/openwrt/blob/0aedf916df364771be47ffda8ff3465250ecee77/package/kernel/mac80211/Makefile


While writting this I stumbled upon 
https://github.com/openwrt/openwrt/blob/master/target/linux/generic/hack-5.15/600-bridge_offload.patch,

reverting it fixes half of the problem (frame tagged that should be 
untagged), but I still see frames with VID 3 on a port that is not a 
member of VLAN 3.

I'll continue to look at 'hack' and old 'pending' patches that were 
never accepted,

and loop back with the author of the bridge_offload patch.


> I might also ask you to provide a reproducer for the issue using regular
> iproute2 tools starting from an unconfigured system (bridge, ip, etc, as
> opposed to the network manager from OpenWRT and its /etc/config/network
> configuration file), if this wouldn't be too much effort.

I don't have a serial cable right now, but if reverting suspicious patches

is not enough I'll likely go down that route.


> Also, not clear which interface exactly you mean by "wifi" ("unicast
> frames from wifi to lan4 exit tagged with VID 2").

wifi interface here would be wlan0 / bridged to vlan2

> Thanks.
