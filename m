Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690406A16A4
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 07:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjBXGcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 01:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjBXGcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 01:32:18 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6FA3251E;
        Thu, 23 Feb 2023 22:32:17 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id s20so16393974lfb.11;
        Thu, 23 Feb 2023 22:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0CI8dGZhMqbOB7JbzbHObrywPoWru1EeEJHklBtAPx4=;
        b=FYRvPQN6koR/pf2uAiJqkboYOkQBsPde2ErImXMdwpi5uTIg/Clk9Q8YzBfS5uAT4e
         xZRrF3jFZB6ggKvxdaDJl/2LdoHuxxlRfaoW72joacdua1/cSVnWG8HfZIqKOGE2XdWL
         TDl1ipiIW5/soeLh2oB8sI8DJtXr0A0QASnH/EjRctZgsbSm5RBNHYbaAC4FwaFnL140
         nu7flqdSykdG7ISz4E2uEmQjCaNlap3pQVUDRrIm0YQfA+S2utokQ8KPlt8B7Yt8niZL
         LVeGimLNmmJDLBKZ0Swhehw99+5rTHCBKj11TDGf0MtZp6N/HxBJ2E8OCraigqcEOG6h
         cHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0CI8dGZhMqbOB7JbzbHObrywPoWru1EeEJHklBtAPx4=;
        b=Jz8L7h4HTwSAXZqCmF6t5ycAml9Usmpy7x2CsIutxdSJMejAgQHN5qcAhE723Baofi
         sa1/nIACjS7fQoYNnk9hw03MQzJ9vatZVT6BQLVCM3/mM7MfQxqLNle9PHZ6Hl6uYtTz
         Y4bABl3nriTYyYL0BY8RpCDqa+GBFHQh7gJky0ovvt59tP2lwIVknbJbDh5kVlQDZmrQ
         FQOIQc1Xn7O6V1nCwMMmADgZja0U+xSRjRWXx7GmwWHMtdgo48rm3M6O9hYcEJeIPp1w
         igJ5VVOCOS77JWoxxUyQHFUItGRl2vEBmcwD7P8+Qir7q6wn3bLZnvwEHKlRAM0CZQL3
         m85w==
X-Gm-Message-State: AO0yUKVk/FhPQANR5LWhGSwyfPJltOafJCR9h3WxpY55jQ0hIYtGyUAN
        U5BtI8q6sVCVT6mQWmk/1qo=
X-Google-Smtp-Source: AK7set8KX1DgE590Q4FrYY9hOWLG4Aw/fpHD8/H6A6ZT2lxj0Ui+EhzK8Ieaud5ylOD9pryMjBfNMA==
X-Received: by 2002:ac2:4904:0:b0:4d2:a821:5f1c with SMTP id n4-20020ac24904000000b004d2a8215f1cmr5416189lfi.3.1677220335813;
        Thu, 23 Feb 2023 22:32:15 -0800 (PST)
Received: from [192.168.0.101] (89-109-49-189.dynamic.mts-nn.ru. [89.109.49.189])
        by smtp.gmail.com with ESMTPSA id x23-20020ac24897000000b004b564e1a4e0sm783142lfc.76.2023.02.23.22.32.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 22:32:15 -0800 (PST)
Message-ID: <195983bd-f3ab-f281-de4e-756ccda15b8c@gmail.com>
Date:   Fri, 24 Feb 2023 09:32:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2] bnxt: avoid overflow in bnxt_get_nvram_directory()
To:     Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
References: <20230219084656.17926-1-korotkov.maxim.s@gmail.com>
 <Y/Iuu9SiAxh7qhJM@corigine.com>
 <5ad788427171d3c0374f24d4714ba0b429cbcfdf.camel@redhat.com>
 <9a2c3c1ef2e879911a1c62a1e8de0ae612727aae.camel@redhat.com>
From:   Maxim Korotkov <korotkov.maxim.s@gmail.com>
In-Reply-To: <9a2c3c1ef2e879911a1c62a1e8de0ae612727aae.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

23.02.2023 11:01, Paolo Abeni wrote:
> On Tue, 2023-02-21 at 10:34 +0100, Paolo Abeni wrote:
>> On Sun, 2023-02-19 at 15:14 +0100, Simon Horman wrote:
>>> On Sun, Feb 19, 2023 at 11:46:56AM +0300, Maxim Korotkov wrote:
>>>> The value of an arithmetic expression is subject
>>>> of possible overflow due to a failure to cast operands to a larger data
>>>> type before performing arithmetic. Used macro for multiplication instead
>>>> operator for avoiding overflow.
>>>>
>>>> Found by Security Code and Linux Verification
>>>> Center (linuxtesting.org) with SVACE.
>>>>
>>>> Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
>>>> Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
>>>> Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
>>>
>>> I agree that it is correct to use mul_u32_u32() for multiplication
>>> of two u32 entities where the result is 64bit, avoiding overflow.
>>>
>>> And I agree that the fixes tag indicates the commit where the code
>>> in question was introduced.
>>>
>>> However, it is not clear to me if this is a theoretical bug
>>> or one that can manifest in practice - I think it implies that
>>> buflen really can be > 4Gbytes.
>>>
>>> And thus it is not clear to me if this patch should be for 'net' or
>>> 'net-next'.
>>
>> ... especially considered that both 'dir_entries' and 'entry_length'
>> are copied back to the user-space using a single byte each.
> 
> To be clear: if this is really a bug you should update the commit
> message stating how the bug could happen. Otherwise you could repost
> for net-next stripping the fixes tag.
> 
> Thanks,
> 
> Paolo
> 
This is more of a hypothetical issue in my opinion. At least I don't 
have proof of concept. I'll resend this patch when net-next tree be open.
Best regards, Max
