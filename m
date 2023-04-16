Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752026E38F9
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 15:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjDPNj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 09:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjDPNj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 09:39:26 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214C75584;
        Sun, 16 Apr 2023 06:38:46 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a5so935380ejb.6;
        Sun, 16 Apr 2023 06:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681652271; x=1684244271;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aEdduBrOHVPPAZh6e9nR9KJblJ34cCz6crM0qfQk9aw=;
        b=LEEsGXUCPA5AFOw8N9hJ2GMnzrIier4q5CO/SYXPypDBXcz5qkoQYCZJddoo/Q1MRv
         QvKiYa+Ode4vw7DZ5yb/EFDBlj+dwbaqAcIvc5FmqzrVgtOygDmoXn/zKRbuRCseDTAU
         OaQkZ18WLYts3tQNtX65Tmm8WkHkbW6InqjKt9+e5eBL2iGWbBuuUd8Vjh6m590BBmyP
         h9L0JeSUYZCCDTIO1kk92/b8Nareml73Xe56pt/V6zf4znh2WKuKzjil//qWgqvplhZo
         fBip1et3sgxKrRbWpZBP090+4nog5OWxmrl1HTe9YuwhDXT95yO7Jas/Cav4ZU5OKehx
         psyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681652271; x=1684244271;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aEdduBrOHVPPAZh6e9nR9KJblJ34cCz6crM0qfQk9aw=;
        b=dhUMLkFGmcGYB2YF7/8rJMdMGAF6DdCE7vttZA/PrMeOPm2LkZOmmcc2UORCSps+pP
         gH0dhubXfVl3J/A0zreNQoCIlHJN2K4s0DcLfbYE/PWFWnoqtpKM7gPbxkf/j56pDost
         ScxGnsgbqnQoIG9v+bhiZbl6gKSPJvPIJbO8sceY8+8ziXi+rzYeNtg6s6gn8IBxYN6N
         C6OIboZqt2U8HcstlkKUJvn70GuYwSaziQbiUEJBeo1EquECPViQgeJGmJ3dG2a4W1tT
         h1GyXKsAAfEZv97yoQGb5I/mmL4m0deBXbJJDU3qEzh9mzIE+9rYMzH6U9HWhFMGwmw9
         7NrQ==
X-Gm-Message-State: AAQBX9fEsl9Cj62FMm632IvNGoU+hmJYAmxReGsl7/RbhuiMFfOnjm+W
        OzhTQ8KEZUKYVw3QdENgYpE=
X-Google-Smtp-Source: AKy350ZQGZ5fHJhNFZKImOhO3+jco8u4+nfG+IgTY/pa0WXEMSbd1Z6geq8kH9zEg1ITyyI5uZQDRQ==
X-Received: by 2002:a17:906:2dda:b0:92b:f118:ef32 with SMTP id h26-20020a1709062dda00b0092bf118ef32mr4968428eji.48.1681652270834;
        Sun, 16 Apr 2023 06:37:50 -0700 (PDT)
Received: from shift.daheim (p4fd09287.dip0.t-ipconnect.de. [79.208.146.135])
        by smtp.gmail.com with ESMTPSA id hs13-20020a1709073e8d00b0094ece70481csm4039382ejc.197.2023.04.16.06.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 06:37:50 -0700 (PDT)
Received: from localhost ([127.0.0.1])
        by shift.daheim with esmtp (Exim 4.96)
        (envelope-from <chunkeey@gmail.com>)
        id 1po2Zi-0006ZX-0H;
        Sun, 16 Apr 2023 15:37:50 +0200
Message-ID: <8caecebf-bd88-dffe-7749-b79b7ea61cc7@gmail.com>
Date:   Sun, 16 Apr 2023 15:37:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] ath9k: fix calibration data endianness
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        f.fainelli@gmail.com, jonas.gorski@gmail.com, nbd@nbd.name,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230415150542.2368179-1-noltari@gmail.com>
 <87leitxj4k.fsf@toke.dk> <a7895e73-70a3-450d-64f9-8256c9470d25@gmail.com>
 <03a74fbb-dd77-6283-0b08-6a9145a2f4f6@gmail.com> <874jpgxfs7.fsf@toke.dk>
Content-Language: de-DE
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <874jpgxfs7.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/16/23 12:50, Toke Høiland-Jørgensen wrote:
> Christian Lamparter <chunkeey@gmail.com> writes:
> 
>> On 4/15/23 18:02, Christian Lamparter wrote:
>>> Hi,
>>>
>>> On 4/15/23 17:25, Toke Høiland-Jørgensen wrote:
>>>> Álvaro Fernández Rojas <noltari@gmail.com> writes:
>>>>
>>>>> BCM63xx (Big Endian MIPS) devices store the calibration data in MTD
>>>>> partitions but it needs to be swapped in order to work, otherwise it fails:
>>>>> ath9k 0000:00:01.0: enabling device (0000 -> 0002)
>>>>> ath: phy0: Ignoring endianness difference in EEPROM magic bytes.
>>>>> ath: phy0: Bad EEPROM VER 0x0001 or REV 0x00e0
>>>>> ath: phy0: Unable to initialize hardware; initialization status: -22
>>>>> ath9k 0000:00:01.0: Failed to initialize device
>>>>> ath9k: probe of 0000:00:01.0 failed with error -22
>>>>
>>>> How does this affect other platforms? Why was the NO_EEP_SWAP flag set
>>>> in the first place? Christian, care to comment on this?
>>>
>>> I knew this would come up. I've written what I know and remember in the
>>> pull-request/buglink.
>>>
>>> Maybe this can be added to the commit?
>>> Link: https://github.com/openwrt/openwrt/pull/12365
>>>
>>> | From what I remember, the ah->ah_flags |= AH_NO_EEP_SWAP; was copied verbatim from ath9k_of_init's request_eeprom.
>>>
>>> Since the existing request_firmware eeprom fetcher code set the flag,
>>> the nvmem code had to do it too.
>>>
>>> In theory, I don't think that not setting the AH_NO_EEP_SWAP flag will cause havoc.
>>> I don't know if there are devices out there, which have a swapped magic (which is
>>> used to detect the endianess), but the caldata is in the correct endiannes (or
>>> vice versa - Magic is correct, but data needs swapping).
>>>
>>> I can run tests with it on a Netzgear WNDR3700v2 (AR7161+2xAR9220)
>>> and FritzBox 7360v2 (Lantiq XWAY+AR9220). (But these worked fine.
>>> So I don't expect there to be a new issue there).
>>
>> Nope! This is a classic self-own!... Well at least, this now gets documented!
>>
>> Here are my findings. Please excuse the overlong lines.
>>
>> ## The good news / AVM FritzBox 7360v2 ##
>>
>> The good news: The AVM FritzBox 7360v2 worked the same as before.
> 
> [...]
> 
>> ## The not so good news / Netgear WNDR3700v2 ##
>>
>> But not the Netgar WNDR3700v2. One WiFi (The 2.4G, reported itself now as the 5G @0000:00:11.0 -
>> doesn't really work now), and the real 5G WiFi (@0000:00:12.0) failed with:
>> "phy1: Bad EEPROM VER 0x0001 or REV 0x06e0"
> 
> [...]
> 
> Alright, so IIUC, we have a situation where some devices only work
> *with* the flag, and some devices only work *without* the flag? So we'll
> need some kind of platform-specific setting? Could we put this in the
> device trees, or is there a better solution?

Depends. From what I gather, ath9k calls this "need_swap". Thing is,
the flag in the EEPROM is called "AR5416_EEPMISC_BIG_ENDIAN". In the
official documentation about the AR9170 Base EEPROM (has the same base
structure as AR5008 up to AR92xx) this is specified as:

"Only bit 0 is defined as Big Endian. This bit should be written as 1
when the structure is interpreted in big Endian byte ordering. This bit
must be reviewed before any larger than byte parameters can be interpreted."

It makes sense that on a Big-Endian MIPS device (like the Netgear WNDR3700v2),
the  caldata should be in "Big-Endian" too... so no swapping is necessary.

Looking in ath9k's eeprom.c function ath9k_hw_nvram_swap_data() that deals
with this eepmisc flag:

|       if (ah->eep_ops->get_eepmisc(ah) & AR5416_EEPMISC_BIG_ENDIAN) {
|               *swap_needed = true;
|               ath_dbg(common, EEPROM,
|                       "Big Endian EEPROM detected according to EEPMISC register.\n");
|       } else {
|               *swap_needed = false;
|       }

This doesn't take into consideration that swapping is not needed if
the data is in big endian format on a big endian device. So, this
could be changed so that the *swap_needed is only true if the flag and
device endiannes disagrees?

That said, Martin and Felix have written their reasons in the cover letter
and patches for why the code is what it is:
<https://ath9k-devel.ath9k.narkive.com/2q5A6nu0/patch-0-5-ath9k-eeprom-swapping-improvements>

Toke, What's your take on this? Having something similar like the
check_endian bool... but for OF? Or more logic that can somehow
figure out if it's big or little endian.

Cheers,
Christian
