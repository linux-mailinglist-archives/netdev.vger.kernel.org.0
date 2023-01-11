Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74C2666349
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 20:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbjAKTMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 14:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbjAKTMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 14:12:50 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F709F5B5;
        Wed, 11 Jan 2023 11:12:48 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id bt23so24981970lfb.5;
        Wed, 11 Jan 2023 11:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8EiI9R96gCdmCFi5CyO8T9qRDKhT2cs8fqWKf1z80Mk=;
        b=mzP921o8SwxZAZEKBG9QuzQEM4g4HTRqQDGWD4Vvl3pIdF397Tspd5R6U95sNohcI8
         q/6G2gGVJmOcxtpKysysfTOLz/6C4+6L1BnMZ3tkSck7mz6F+FgsTbB0Ohq/6Z4Nf0D4
         F6ZJi2yDRRh1Eww9vuARHHI3KHG4fli1oWQtI4EXzQeslYlt9HzXKC/4XZw1LXGMKa42
         RlQj1YFfC+HRTIOYHb6PZXn20IhxjxeY9LLEwiPC9oh1TY+lacjhYV7m7eKE0ab4hxnV
         EW6XFKwWKpM1fY+T98H1uhQx8dOHNhfmKi1rOs8d6F4MygvO42BRgUhLTttJ6ocGw+wG
         xk/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8EiI9R96gCdmCFi5CyO8T9qRDKhT2cs8fqWKf1z80Mk=;
        b=dIzgBPFo0WncW90A2cBuvctgpQVevNLC9PmKd+GENH9uh0LIh1w2S8HO6cSNv+x2H9
         I4oroIhCgqcDhAsLqvuCqsZR5pr4X/h8y4cOOCqWYTCeVb2QKmlmC4EKf6tRhZXCewOw
         UxbyxE0uIsf35mY+dCF8VWJKzHxCHknOq4+yOGx+BqfwYbmIepqeps0/fOo6cZIFn4ST
         exBg622BtPN6yO8VGCKKTyVB76c8nChvYRnrni0fd6gypkFtZ9UttKINeTda4vEvMe5h
         8jaFWkg4zJ4UM+bXFojgLWec/CsbLAMFpz/gimRIzJLJFKybjnGE80hVXPxyITE/Elhc
         RKsA==
X-Gm-Message-State: AFqh2kr8uutLbTeMY0qc7m7qf7C9y7kucuQ9sinSwsVhVnvdyZoFOoU+
        gWAPKG2z9/mPBIjRtT09uXU=
X-Google-Smtp-Source: AMrXdXs3/hbAhL+hlD/dNGWChGW0aOZpS9pbfNrVsjqJj+ib+NAPcZVYUPYFwJ4N128WPlpSgS67RQ==
X-Received: by 2002:a05:6512:3901:b0:4c7:d0ed:9605 with SMTP id a1-20020a056512390100b004c7d0ed9605mr19183485lfu.6.1673464366599;
        Wed, 11 Jan 2023 11:12:46 -0800 (PST)
Received: from [192.168.50.20] (077222238029.warszawa.vectranet.pl. [77.222.238.29])
        by smtp.gmail.com with ESMTPSA id s28-20020a056512203c00b004cb0e527515sm2831407lfs.249.2023.01.11.11.12.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 11:12:45 -0800 (PST)
Message-ID: <f8471471-3b9f-526c-b8d0-88bd3de6d409@gmail.com>
Date:   Wed, 11 Jan 2023 20:12:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v2] rndis_wlan: Prevent buffer overflow in rndis_query_oid
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kvalo@kernel.org, jussi.kivilinna@iki.fi, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        greg@kroah.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAKgT0UePq+Gg5mpvD7ag=ern9JN5JyAFv5RPc05Zn9jSh4W+0g@mail.gmail.com>
 <20230111175031.7049-1-szymon.heidrich@gmail.com>
 <CAKgT0UeiFGyttyQg_yWHA5L6ZPy9W8__b6DFSQe0-CNnLEvY7w@mail.gmail.com>
Content-Language: en-US
From:   Szymon Heidrich <szymon.heidrich@gmail.com>
In-Reply-To: <CAKgT0UeiFGyttyQg_yWHA5L6ZPy9W8__b6DFSQe0-CNnLEvY7w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/01/2023 19:28, Alexander Duyck wrote:
> On Wed, Jan 11, 2023 at 9:51 AM Szymon Heidrich
> <szymon.heidrich@gmail.com> wrote:
>>
>> Since resplen and respoffs are signed integers sufficiently
>> large values of unsigned int len and offset members of RNDIS
>> response will result in negative values of prior variables.
>> This may be utilized to bypass implemented security checks
>> to either extract memory contents by manipulating offset or
>> overflow the data buffer via memcpy by manipulating both
>> offset and len.
>>
>> Additionally assure that sum of resplen and respoffs does not
>> overflow so buffer boundaries are kept.
>>
>> Fixes: 80f8c5b434f9 ("rndis_wlan: copy only useful data from rndis_command respond")
>> Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
>> ---
>> V1 -> V2: Use size_t and min macro, fix netdev_dbg format
>>
>>  drivers/net/wireless/rndis_wlan.c | 19 ++++++-------------
>>  1 file changed, 6 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
>> index 82a7458e0..bf72e5fd3 100644
>> --- a/drivers/net/wireless/rndis_wlan.c
>> +++ b/drivers/net/wireless/rndis_wlan.c
>> @@ -696,8 +696,8 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
>>                 struct rndis_query      *get;
>>                 struct rndis_query_c    *get_c;
>>         } u;
>> -       int ret, buflen;
>> -       int resplen, respoffs, copylen;
>> +       int ret;
>> +       size_t buflen, resplen, respoffs, copylen;
>>
>>         buflen = *len + sizeof(*u.get);
>>         if (buflen < CONTROL_BUFFER_SIZE)
>> @@ -732,22 +732,15 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
>>
>>                 if (respoffs > buflen) {
>>                         /* Device returned data offset outside buffer, error. */
>> -                       netdev_dbg(dev->net, "%s(%s): received invalid "
>> -                               "data offset: %d > %d\n", __func__,
>> -                               oid_to_string(oid), respoffs, buflen);
>> +                       netdev_dbg(dev->net,
>> +                                  "%s(%s): received invalid data offset: %zu > %zu\n",
>> +                                  __func__, oid_to_string(oid), respoffs, buflen);
>>
>>                         ret = -EINVAL;
>>                         goto exit_unlock;
>>                 }
>>
>> -               if ((resplen + respoffs) > buflen) {
>> -                       /* Device would have returned more data if buffer would
>> -                        * have been big enough. Copy just the bits that we got.
>> -                        */
>> -                       copylen = buflen - respoffs;
>> -               } else {
>> -                       copylen = resplen;
>> -               }
>> +               copylen = min(resplen, buflen - respoffs);
>>
>>                 if (copylen > *len)
>>                         copylen = *len;
> 
> Looks good to me.
> 
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

Awesome, thank you very much.

