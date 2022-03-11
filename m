Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5139B4D5D33
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 09:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiCKIYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 03:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbiCKIYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 03:24:08 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16D8F11A6;
        Fri, 11 Mar 2022 00:23:05 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id v1-20020a17090a088100b001bf25f97c6eso8319167pjc.0;
        Fri, 11 Mar 2022 00:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=UKtyCUMP3qwcACml1aXOWoi8Ga3gmD02zYRaxw20XDg=;
        b=OKXcvYE7pZfwMF/H2CFbDgpq4NKsosl8jKLB9g1Jb1UPKlPc8xRKISjMR8p/04+N/1
         WWngWA2/HCZWdoo5DBTDdWvFXyDEcnBm7INxV0SAjDRUAFL+PUBFksRSWC80JijIzetA
         SZfxkWZn9//Xwz6029MF2V6jexf8oGCT0lVAU8Qa1Zhcqy+strQZO9Wwhbhl0zLJHd4O
         FzAedLwzHmlAnlne/3vFWz+pjfmzyYepH0bPWKJAJZhWARfWPemPISflNMCuZqLCp3Ee
         ekFjmrAnhPsoPuOAglJe/Pe51ZmyqY2c7UE530I4s9X2Q5AiQCadGSyzbjklKma7qjHk
         ZRkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=UKtyCUMP3qwcACml1aXOWoi8Ga3gmD02zYRaxw20XDg=;
        b=ydHPEedWcSeLMGDa7tDeoIHwj44h27slWI57JN4YfoyLFfxHTqTZ0W/X6xhYk2Ewwz
         StRtL6QdjNmQ2xoGVlq9P6zO2dmIEM3d4SODvyotIVCDnmCuXm+G9pgCHF0Linjx8Cgx
         oXrc4faYbwvqtaJG0giOrlGmnuMgxcMAiDv4poBIy1JdzXikgQLXQjz0C9LJuosIpzKP
         cNpnEStMroi3zE0OK3bN/MTcX0ynT47D/FKYgzmPAAkacoFPHIUCpEOIE5fcehuQ1Sp5
         onqkx0NbKGf8JMgoMcY/CePbyV2wfiud70FmepAEdhISYCioOabU1GQXwsm8nosZvHBJ
         z9CA==
X-Gm-Message-State: AOAM530KZ66bPNAx+yv+jXj4OeTQ5gDyig6sNK0IWimn0t+waT93DglK
        /AqiMxZTbGD9aApmR5ghkRU=
X-Google-Smtp-Source: ABdhPJxd00Q0953VCQDeINPY4API18sBytnPe3qEwrjsEiYqqPoF+BtUDK2Kikg8S6xKgQVuxiBTHw==
X-Received: by 2002:a17:903:2308:b0:151:8b3a:e43e with SMTP id d8-20020a170903230800b001518b3ae43emr9357770plh.30.1646986985289;
        Fri, 11 Mar 2022 00:23:05 -0800 (PST)
Received: from [10.11.37.162] ([103.84.139.53])
        by smtp.gmail.com with ESMTPSA id s6-20020a056a0008c600b004f667b8a6b6sm9192433pfu.193.2022.03.11.00.23.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 00:23:04 -0800 (PST)
Message-ID: <03303592-ad5c-ffd0-80f5-8d1e64c2b011@gmail.com>
Date:   Fri, 11 Mar 2022 16:22:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] can: usb: delete a redundant dev_kfree_skb() in
 ems_usb_start_xmit()
Content-Language: en-US
From:   Hangyu Hua <hbh25y@gmail.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        stefan.maetje@esd.eu, mailhol.vincent@wanadoo.fr,
        paskripkin@gmail.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220228083639.38183-1-hbh25y@gmail.com>
 <20220228085536.pa5wdq3w4ul5wqn5@pengutronix.de>
 <75c14302-b928-1e09-7cd1-78b8c2695f06@gmail.com>
 <20220228104514.der655r4jkl42e7o@pengutronix.de>
 <f0e068ce-49bf-a13d-53ff-d81b4f5a8a65@gmail.com>
In-Reply-To: <f0e068ce-49bf-a13d-53ff-d81b4f5a8a65@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

I didn't find this("can: usb: ems_usb_start_xmit(): fix double 
dev_kfree_skb() in error path") in can/testing. Did I miss it or did you 
forget to submit it?

Anyway, i find this problem also exists in two other places. You can 
check them in:
mcba_usb:
https://lore.kernel.org/all/20220311080208.45047-1-hbh25y@gmail.com/
usb_8dev:
https://lore.kernel.org/all/20220311080614.45229-1-hbh25y@gmail.com/

Thanks,
Hangyu


On 2022/2/28 18:47, Hangyu Hua wrote:
> All right. :)
> 
> On 2022/2/28 18:45, Marc Kleine-Budde wrote:
>> On 28.02.2022 18:44:06, Hangyu Hua wrote:
>>> I get it. I'll remake a patch that matches your suggestions.
>>
>> Not needed, it's already applied:
>>>> Added patch to can/testing.
>>
>> Marc
>>
