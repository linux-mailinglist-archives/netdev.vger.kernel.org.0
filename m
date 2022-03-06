Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6DC4CEDE2
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 22:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbiCFVJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 16:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbiCFVJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 16:09:57 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F066460F9
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 13:09:04 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id s8so8011031pfk.12
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 13:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=5yTlHUG29TEjBAVMlekemybNZzAYbTUoHZ78vTln6xM=;
        b=PmrggrlZwpJVuSK230P0OgcHJ8ZBNMCwA6KHZUYr54Hsw0bMegJGo5gAwAZKwIN+xz
         Z92wMP1nR11RDlbr8olFkhAh9upKlMDfupqViv/CTxJoiyhNG/Qxe+buUDc3QLCmchNO
         pH8fFDPh3lwYmTTwt3GKCbtbidzhhGkwFNoWXX0/8CK9HB9CdpIuCnQ2KhkZIm2x4GCv
         2srt4wV6fkSTgKhezQauS0j0attXD39Nve78m5sbimg2eMoZ54F6g/Cr3o3uvh5b/AxZ
         bAByj/5AO8j4J8gBb7Re9o4NuZADrpoLOCp8zx/xSWhyiU5ZjFEE1QlxQaKtWlwi7crD
         qfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=5yTlHUG29TEjBAVMlekemybNZzAYbTUoHZ78vTln6xM=;
        b=I0GxWMx2eOzsEeD5NpjxWD3+kID27mLsAfGQ/OFrGLELopTQT+wnToSRaJ93RLmHnW
         xj59MwWm/fDZTDqf/3AnUX7jly8y/IGdM2T/Sxzgn3aTqbf9znLehOKmSGz/lyLUSGcP
         csaddd7NgK+hsCGLPxwlchcprFKuRbZW1TzeAj0OnuXR7v0d6TJtoHmBB9Ubj3icFtJ+
         nyb9f6FalBdIuTvXVRwz1QRbzIz16Z28oNcGpHnPLj/CYj7gOosqbMns9dS800wZWfQf
         w+ObSEP02/Jiz967og8pCB9ee+NEuhfe8uFJg4jCoykK0rzA1vDdCBQeFTyWiHT0cM5o
         kLzA==
X-Gm-Message-State: AOAM5311qjPmgNFg4VqCa7rgyYTDNTFGz8mLnOi5StfE0x7wJuBlrZzv
        P9rM42j7gWzw5sTuKYk9/dU=
X-Google-Smtp-Source: ABdhPJxwFhTIJfobPV9cqwLaUru7qyJYAT4ZhYVHSxHshLDOrYeq/QyK2e4uK+Trj9Wg1XZsY9rZJw==
X-Received: by 2002:a05:6a00:1304:b0:4e1:2338:f11e with SMTP id j4-20020a056a00130400b004e12338f11emr9780323pfu.24.1646600944324;
        Sun, 06 Mar 2022 13:09:04 -0800 (PST)
Received: from [192.168.111.130] ([108.180.194.153])
        by smtp.googlemail.com with ESMTPSA id z2-20020a17090a170200b001bf2d530d64sm8755937pjd.2.2022.03.06.13.09.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 13:09:03 -0800 (PST)
Message-ID: <7e75125d-c222-46cf-50b3-c80978cbfff2@gmail.com>
Date:   Sun, 6 Mar 2022 13:09:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
From:   Dimitrios Bouras <dimitrios.bouras@gmail.com>
Subject: Re: [PATCH 1/1] eth: Transparently receive IP over LLC/SNAP
To:     David Laight <David.Laight@ACULAB.COM>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <462fa134-bc85-a629-b9c5-8c6ea08b751d@gmail.com>
 <4baebbcb95d84823a7f4ecbe18cbbc3c@AcuMS.aculab.com>
Content-Language: en-US
In-Reply-To: <4baebbcb95d84823a7f4ecbe18cbbc3c@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URI_DOTEDU autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022-03-04 11:02 p.m., David Laight wrote:
> From: Dimitrios P. Bouras
>> Sent: 05 March 2022 00:33
>>
>> Practical use cases exist where being able to receive Ethernet packets
>> encapsulated in LLC SNAP is useful, while at the same time encapsulating
>> replies (transmitting back) in LLC SNAP is not required.
> I think you need to be more explicit.
> If received frames have the SNAP header I'd expect transmitted ones
> to need it as well.

Hi David,

Yes, in the general case, I agree. In the existing implementation of the
stack,however, (as far as I have researched) there is nothing available to
process IP over LLC/SNAP for Ethernet interfaces.

In the thread I've quoted in my explanation Alan Cox says so explicitly:
https://lkml.iu.edu/hypermail/linux/kernel/1107.3/01249.html

Maybe I should change the text to read:

   Practical use cases exist where being able to receive IP packets
   encapsulated in LLC/SNAP over an Ethernet interface is useful, while
   at the same time encapsulating replies (transmitting back) in LLC/SNAP
   is not required.

Would that be better? Maybe I should also change the following sentence:

   Accordingly, this is not an attempt to add full-blown support for IP over
   LLC/SNAP for Ethernet devices, only a "hack" that "just works".

>> Accordingly, this
>> is not an attempt to add full-blown support for IP over LLC SNAP, only a
>> "hack" that "just works" -- see Alan's comment on the the Linux-kernel
>> list on this subject ("Linux supports LLC/SNAP and various things over it
>> (IPX/Appletalk DDP etc) but not IP over it, as it's one of those standards
>> bodies driven bogosities which nobody ever actually deployed" --
>> http://lkml.iu.edu/hypermail/linux/kernel/1107.3/01249.html).
> IP over SNAP is needed for Token ring networks (esp. 16M ones) where the
> mtu is much larger than 1500 bytes.
>
> It is all too long ago though, I can't remember whether token ring
> tends to bit-reverse the MAC address (like FDDI does) which means you
> can't just bridge ARP packets.
> So you need a better bridge - and that can add/remove some SNAP headers.
I've read that some routers are able to do this but it is out of scope for my
simple patch. The goal is just to be able to receive LLC/SNAP-encapsulated
IP packets over an Ethernet interface.

>
> ...
>
> 	David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

Additional feedback you may have is greatly appreciated.

Many thanks,
Dimitri

