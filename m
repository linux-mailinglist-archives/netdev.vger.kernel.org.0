Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC326F287A
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 12:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjD3Kg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 06:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjD3Kgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 06:36:55 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049891BFF;
        Sun, 30 Apr 2023 03:36:54 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-3062c1e7df8so108151f8f.1;
        Sun, 30 Apr 2023 03:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682851012; x=1685443012;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bNpv0WM5O3XzF1IvDudqU5WB9Uw2W8qTwnpkdxgYnb8=;
        b=CuJLyjLNFiDvzdpjC3oEp3zc0I5OKagwgy8U3Ax2St7kCJ07KCpTmSeoBQf9TtsY3H
         cZsYhUSG7A1g3ELJ14qYEmQvgZUeA5GMj+MR355dqZHayO/RJ3d0erG7/agN6uBdG/qR
         Mk0w/YfuM6/A2ldTlQxbnuByFyzxbLcB/ZMk+7Ku2LvK5Ihj7tGsIQ91GRklcvf6+PCq
         Uu9knlx2hTVhoGqCP+NyiyTPT+1tYfbU7CQ8625gUbm/uFzjjGiC7mLsO4zudx/KMIrf
         zlDidRyB6+ms7hTgYqUyF9YlFgq2Wuepku9L0lSo1TWFUcVnJi5j83zSV23ak5JqiKuz
         cjcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682851012; x=1685443012;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bNpv0WM5O3XzF1IvDudqU5WB9Uw2W8qTwnpkdxgYnb8=;
        b=Xf/MQUWP6dpX3DoWMxXkcY+7g1rJ90Bgn7Yk5NIMXw9b/z92yfOAeUwLUvTFz94VRX
         61QuY/v2O5Jo0vUUtLrJoWLFIaZkh1mfoJ1/h12P4ninZokGVg9ggTnfHMbCW/uxKIHX
         agc1u51XSCVPT0PGYV0advE6nbOzVridtKi5W/JyksTCnNRgYMa99zxksN3Iyht2Hqsp
         Yem7VVXAd3++R6S4CbUAgRo/sTMF85VyUQOH+GyJx9H/HZv5RkvJh33zgWD6pJg1eapn
         stgVtczp0znlSpZAfUl5bEtDPpF3nig1MyxNCga+argaQxePkoSGxxAgzGrXrDKudrH8
         zL/Q==
X-Gm-Message-State: AC+VfDxzruztrF5NMEjpbGScyMaB5XbeD/8xRPeBe2vJWGfU/bE3fMfb
        0oy2h4XhGYeLSeIPQ+kE6M4=
X-Google-Smtp-Source: ACHHUZ7yAWo8Z+cdUwaQzKvRpUpHO+kW7h597KI6nQ25igD829dtStATqMgbjB6eofom0+jOzNe1zA==
X-Received: by 2002:a05:6000:181:b0:306:2b64:fd1b with SMTP id p1-20020a056000018100b003062b64fd1bmr995166wrx.52.1682851012190;
        Sun, 30 Apr 2023 03:36:52 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.55])
        by smtp.gmail.com with ESMTPSA id g13-20020adfe40d000000b002f8d402b191sm25592077wrm.112.2023.04.30.03.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Apr 2023 03:36:51 -0700 (PDT)
Message-ID: <794ab671-43a3-7548-13f0-4b289f07425f@gmail.com>
Date:   Sun, 30 Apr 2023 13:36:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] wifi: rtl8xxxu: fix authentication timeout due to
 incorrect RCR value
To:     Yun Lu <luyun_611@163.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Jes.Sorensen@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20230427020512.1221062-1-luyun_611@163.com>
 <866570c9-38d8-1006-4721-77e2945170b9@lwfinger.net>
 <76a784b2.2cb3.187c60f0f68.Coremail.luyun_611@163.com>
 <d3743b66-23b1-011c-9dcd-c408b1963fca@lwfinger.net>
 <62d9fe90.63b.187cb1481f8.Coremail.luyun_611@163.com>
Content-Language: en-US
From:   Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <62d9fe90.63b.187cb1481f8.Coremail.luyun_611@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2023 06:35, Yun Lu wrote:
> At 2023-04-29 01:06:03, "Larry Finger" <Larry.Finger@lwfinger.net> wrote:
>> On 4/27/23 23:11, wo wrote:
>>> [  149.595642] [pid:7,cpu6,kworker/u16:0,0]BEFORE: REG_RCR differs from regrcr: 
>>> 0x1830613 insted of 0x7000604e
>>> [  160.676422] [pid:237,cpu6,kworker/u16:5,3]BEFORE: REG_RCR differs from 
>>> regrcr: 0x70006009 insted of 0x700060ce
>>> [  327.234588] [pid:7,cpu7,kworker/u16:0,5]BEFORE: REG_RCR differs from 
>> regrcr: 0x1830d33 insted of 0x7000604e
>>
>>
>> My patch was messed up, but it got the information that I wanted, which is shown 
>> in the quoted lines above. One of these differs only in the low-order byte, 
>> while the other 2 are completely different. Strange!
>>
>> It is possible that there is a firmware error. My system, which does not show 
>> the problem, reports the following:
>>
>> [54130.741148] usb 3-6: RTL8192CU rev A (TSMC) romver 0, 2T2R, TX queues 2, 
>> WiFi=1, BT=0, GPS=0, HI PA=0
>> [54130.741153] usb 3-6: RTL8192CU MAC: xx:xx:xx:xx:xx:xx
>> [54130.741155] usb 3-6: rtl8xxxu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
>> [54130.742301] usb 3-6: Firmware revision 88.2 (signature 0x88c1)
>>
>> Which firmware does your unit use?
> 
> The firmware verion we used is 80.0 (signature 0x88c1)
>  [  903.873107] [pid:14,cpu0,kworker/0:1,2]usb 1-1.2: RTL8192CU rev A (TSMC) 2T2R, TX queues 2, WiFi=1, BT=0, GPS=0, HI PA=0
> [  903.873138] [pid:14,cpu0,kworker/0:1,3]usb 1-1.2: RTL8192CU MAC: 08:be:xx:xx:xx:xx
> [  903.873138] [pid:14,cpu0,kworker/0:1,4]usb 1-1.2: rtl8xxxu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
> [  903.873474] [pid:14,cpu0,kworker/0:1,5]usb 1-1.2: Firmware revision 80.0 (signature 0x88c1)
> 
>>
>> Attached is a new test patch. When it logs a CORRUPTED value, I would like to 
>> know what task is attached to the pid listed in the message. Note that the two 
>> instances where the entire word was wrong came from pid:7.
>>
>> Could improper locking could produce these results?
>>
>> Larry
> 
> Apply your new patch, then turn on/off the wireless network switch on the network control panel serverl loops.
> The log shows:
> [   85.384429] [pid:221,cpu6,kworker/u16:6,5]REG_RCR corrupted in rtl8xxxu_configure_filter: 0x70006009 insted of 0x700060ce
> [  121.681976] [pid:216,cpu6,kworker/u16:3,0]REG_RCR corrupted in rtl8xxxu_configure_filter: 0x70006009 insted of 0x700060ce
> [  144.416992] [pid:217,cpu6,kworker/u16:4,1]REG_RCR corrupted in rtl8xxxu_configure_filter: 0x70006009 insted of 0x700060ce
> 
> And if we up/down the interface serverl loops as follows:
> ifconfig wlx08bexxxxxx down
> sleep 1
> ifconfig wlx08bexxxxxx up
> sleep 10
> The log shows:
> [  282.112335] [2023:04:29 10:30:34][pid:95,cpu6,kworker/u16:1,3]REG_RCR corrupted in rtl8xxxu_configure_filter: 0x1832e13 insted of 0x7000604e
> [  293.311462] [2023:04:29 10:30:45][pid:217,cpu7,kworker/u16:4,9]REG_RCR corrupted in rtl8xxxu_configure_filter: 0x1830e72 insted of 0x7000604e
> [  304.435089] [2023:04:29 10:30:56][pid:217,cpu6,kworker/u16:4,9]REG_RCR corrupted in rtl8xxxu_configure_filter: 0x1830ed3 insted of 0x7000604e
> [  315.532257] [2023:04:29 10:31:07][pid:95,cpu7,kworker/u16:1,8]REG_RCR corrupted in rtl8xxxu_configure_filter: 0x7000604e insted of 0x7000604e
> [  324.114379] [2023:04:29 10:31:16][pid:221,cpu6,kworker/u16:6,7]REG_RCR corrupted in rtl8xxxu_configure_filter: 0x1832e14 insted of 0x7000604e
> 
> We also update the  firmware verion to 88.2, and the test results are the same as above.
> 
> Thank you for helping debug this issue, which seems to be related to specific devices.
> 
> Yun Lu
> 
> 
> 
> 
There was this bug report about phantom MAC addresses with
the RTL8188CUS:
https://lore.kernel.org/linux-wireless/a31d9500-73a3-f890-bebd-d0a4014f87da@reto-schneider.ch/

See the pcap file. I wonder if it's related?
