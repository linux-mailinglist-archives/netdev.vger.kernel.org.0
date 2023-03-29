Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342016CD3A5
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 09:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbjC2Ht2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 03:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjC2HtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 03:49:12 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53304219
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 00:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4YoSvgbWaReAwaF/VbBAgVHAJsclyJPGAsIGg9VGiy0=; b=EQHfTUMBjxbV90cbdkMnqWkFG6
        nL7ww2e+QeQ2b9MM5gwox7pqj4Pzp17HHJiOVb5P3f8Ygu7oMxChvnhxcHLbNzBLflPNf9SyD5hP5
        lqra/x7Ua7lZLHK9Wbjme2cqGvAIChl0cP5vbqP4mH3LXOdRzfyG9gUuC+YdNxO/Y9bk=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1phQYA-0086Iq-O3; Wed, 29 Mar 2023 09:48:54 +0200
Message-ID: <3c4bbce9-a66c-f458-f971-a162ef13a03c@nbd.name>
Date:   Wed, 29 Mar 2023 09:48:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: Aw: Re: Re: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix tx
 throughput regression with direct 1G links
Content-Language: en-US
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     netdev@vger.kernel.org, Daniel Golle <daniel@makrotopia.org>
References: <20230324140404.95745-1-nbd@nbd.name>
 <trinity-84b79570-2de7-496a-870e-a9678a55f4a4-1679736481816@3c-app-gmx-bap48>
 <2e7464a7-a020-f270-4bc7-c8ef47188dcd@nbd.name>
 <trinity-30bf2ced-ef19-4ce1-9738-07015a93dede-1679850603745@3c-app-gmx-bap64>
 <4a67ee73-f4ee-2099-1b5b-8d6b74acf429@nbd.name>
 <trinity-6b2ecbe5-7ad8-4740-b691-8b9868fae223-1679852966887@3c-app-gmx-bap64>
 <956879eb-a902-73dd-2574-1e6235571647@nbd.name>
 <trinity-79a1a243-0b80-402f-8c65-4bda591d6aa1-1679938094805@3c-app-gmx-bs30>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <trinity-79a1a243-0b80-402f-8c65-4bda591d6aa1-1679938094805@3c-app-gmx-bs30>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.03.23 19:28, Frank Wunderlich wrote:
> 
>> Gesendet: Sonntag, 26. März 2023 um 22:09 Uhr
>> Von: "Felix Fietkau" <nbd@nbd.name>
>> On 26.03.23 19:49, Frank Wunderlich wrote:
>> >> Gesendet: Sonntag, 26. März 2023 um 19:27 Uhr
>> >> Von: "Felix Fietkau" <nbd@nbd.name>
> 
>> >> On 26.03.23 19:10, Frank Wunderlich wrote:
>> >> >> Gesendet: Sonntag, 26. März 2023 um 17:56 Uhr
>> >> >> Von: "Felix Fietkau" <nbd@nbd.name>
> 
>> >> >> On 25.03.23 10:28, Frank Wunderlich wrote:
>> >> >> >> Gesendet: Freitag, 24. März 2023 um 15:04 Uhr
>> >> >> >> Von: "Felix Fietkau" <nbd@nbd.name>
> 
>> >> >> > thx for the fix, as daniel already checked it on mt7986/bpi-r3 i tested bpi-r2/mt7623
>> >> >> > 
>> >> >> > but unfortunately it does not fix issue on bpi-r2 where the gmac0/mt7530 part is affected.
>> >> >> > 
>> >> >> > maybe it needs a special handling like you do for mt7621? maybe it is because the trgmii mode used on this path?
>> >> >> Could you please test if making it use the MT7621 codepath brings back 
>> >> >> performance? I don't have any MT7623 hardware for testing right now.
> 
>> > used the CONFIG_MACH_MT7623 (which is set in my config) boots up fine, but did not fix the 622Mbit-tx-issue
>> > 
>> > and i'm not sure i have tested it before...all ports of mt7531 are affected, not only wan (i remembered you asked for this)
>> Does the MAC that's connected to the switch use flow control? Can you 
>> test if changing that makes a difference?
> 
> it does use flow control/pause on mac and switch-port, disabled it, but it does not change anything (still ~620Mbit on tx)
> 
> +++ b/arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts
> @@ -182,7 +182,7 @@ gmac0: mac@0 {
>                  fixed-link {
>                          speed = <1000>;
>                          full-duplex;
> -                       pause;
> +                       //pause;
>                  };
>          };
>   
> @@ -235,7 +235,7 @@ port@6 {
>                                          fixed-link {
>                                                  speed = <1000>;
>                                                  full-duplex;
> -                                               pause;
> +                                               //pause;
>                                          };
>                                  };
>                          };
> 
> regards Frank
I think I have an idea on how to properly deal with this issue now. I 
had overlooked the fact that on MT7623 the link to the switch is only 
1000M, so any QDMA shaping to that speed does not make any sense, since 
throughput is already limited by MAC speed.
I will make a patch that enables shaping only if port_speed < mac_speed.

- Felix
