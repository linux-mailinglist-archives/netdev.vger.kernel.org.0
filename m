Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7FFA5B8FB3
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 22:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiINUia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 16:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiINUi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 16:38:29 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A6D8274F
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 13:38:24 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id z12so9211990wrp.9
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 13:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=MMPhIioCDl5LTSlyXAdHiVt49IyDeCUSBboP9daWQU8=;
        b=xZ8taZyncHfB0MAY/ux5F1NcmdPCp7z7Yv+GkR3WKjFK6I6v8OpENWlNItTAMjnLXm
         U6k9ey0HBlldSnZLsgia9/Uo55+BKXscs7kEpzHMqH0KD3opuUOYsLCb2ObCY7Le3wLa
         SHVepnr8jt5spHQV8fklEPeyo4Tlrm0/rsjG94Q4d1YhToLL5n9BLWLPbFGoZR8lfVbw
         ZNbZv3+ABfRJIa2u0L96fl/kHxq5F+/BBHFmcqG07pPRAQ7qqbFebnpsLurgpHwR9mDz
         z/Kp5lBX6JO8itF0pIZZ1qUug+ZOlcYg1yoQZgd+Qm1HX+GQsumBEKJGOFGRJUxWMjg5
         tEZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=MMPhIioCDl5LTSlyXAdHiVt49IyDeCUSBboP9daWQU8=;
        b=ypS+NUf3faqA9KpbGIF7BRXbfdmx5arLNFhB9yh+9cRhJoo3UCmWtpfmLB9e5UybhO
         IGV78xFhu0Mq/o5n1nvswbv3g0oIPz7LxlZ5Pi15y5D8o9WV1OAqogpMaFo97sqV76z4
         WqemMWxXi7qACVSLn1bl1Kdr9059bbg7zTFFC1UjQT8dtUre6CP6YEQFA54YHUe5RR8C
         SyrI6Is9EfmSyyvXfaBypMB5BurfliB3Nrae28TKjjQb6/s3Z0AkvXrlDBHA/FLfYfmm
         BPZnGm1vbl/q/9tQ02ZSbN719K6bD0tR1xUovtux0bMK/bod6YrZ0fJrMcv/AwCp71ba
         kIPQ==
X-Gm-Message-State: ACgBeo1+E0trwAs4RrgYBWiLdoQwBbrUit1gZxHLchdmgOgVipHvvapn
        XO1d7NO589nosmShmJP2QjZixA==
X-Google-Smtp-Source: AA6agR41uiv/+CEdH8sU0GbZYsumr937+XE0nRtZnjyt8moehr2Tusx1foAVAj0kRRryTLxJaol9sw==
X-Received: by 2002:a5d:650e:0:b0:228:b09e:de9a with SMTP id x14-20020a5d650e000000b00228b09ede9amr23455385wru.360.1663187902206;
        Wed, 14 Sep 2022 13:38:22 -0700 (PDT)
Received: from [192.168.0.162] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id n19-20020a7bc5d3000000b003a8434530bbsm202834wmk.13.2022.09.14.13.38.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 13:38:21 -0700 (PDT)
Message-ID: <9145cfd7-5c7c-da58-7453-3b8fd47bf76f@linaro.org>
Date:   Wed, 14 Sep 2022 21:38:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] wcn36xx: Add RX frame SNR as a source of system entropy
Content-Language: en-US
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
References: <20220913174224.1399480-1-bryan.odonoghue@linaro.org>
 <CAMZdPi_jZEHSz9+WaR3N-MANU7YdYK0zqO7VXNwAcES=YkNaxg@mail.gmail.com>
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
In-Reply-To: <CAMZdPi_jZEHSz9+WaR3N-MANU7YdYK0zqO7VXNwAcES=YkNaxg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/09/2022 13:53, Loic Poulain wrote:
> Hi Bryan,
> 
> On Tue, 13 Sept 2022 at 19:42, Bryan O'Donoghue
> <bryan.odonoghue@linaro.org> wrote:
>>
>> The signal-to-noise-ratio of a received frame is a representation of noise
>> in a given received frame.
>>
>> RSSI - received signal strength indication can appear pretty static
>> frame-to-frame but noise will "bounce around" more depending on the EM
>> environment, temperature or placement of obstacles between the transmitter
>> and receiver.
>>
>> Other WiFi drivers offer up the noise component of the FFT as an entropy
>> source for the random pool i.e.
>>
>> Commit: 2aa56cca3571 ("ath9k: Mix the received FFT bins to the random pool")
>>
>> I attended Jason's talk on sources of randomness at Plumbers and it occured
>> to me that SNR is a reasonable candidate to add.
>>
>> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
>> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
>> ---
>>   drivers/net/wireless/ath/wcn36xx/txrx.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
>> index 8da3955995b6e..f3b77d7ffebe4 100644
>> --- a/drivers/net/wireless/ath/wcn36xx/txrx.c
>> +++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
>> @@ -16,6 +16,7 @@
>>
>>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>
>> +#include <linux/random.h>
>>   #include "txrx.h"
>>
>>   static inline int get_rssi0(struct wcn36xx_rx_bd *bd)
>> @@ -297,6 +298,8 @@ static void wcn36xx_update_survey(struct wcn36xx *wcn, int rssi, int snr,
>>          wcn->chan_survey[idx].rssi = rssi;
>>          wcn->chan_survey[idx].snr = snr;
>>          spin_unlock(&wcn->survey_lock);
>> +
>> +       add_device_randomness(&snr, sizeof(int));
> 
> We store the SNR in an integer, but isn't it reported as u8 (or s8) by
> the firmware? So maybe we should just inject the LSByte since the upper
> ones will always be 0?

sizeof(s8) makes sense to me, also I can massage the commit text a bit, 
it doesn't scan well on a second reading

---
bod

