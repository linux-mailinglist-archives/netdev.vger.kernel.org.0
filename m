Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584B24C4981
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 16:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242215AbiBYPsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 10:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240685AbiBYPsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 10:48:37 -0500
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF4E6212B;
        Fri, 25 Feb 2022 07:48:04 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id k13-20020a4a948d000000b003172f2f6bdfso6725162ooi.1;
        Fri, 25 Feb 2022 07:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gWZ4k2dTIF+KQYdLjdoJdXgFuc+j8wPi3Dg4q2AoyAo=;
        b=iLf8Ixoep+7/J3JJqqWIStpEmQb2AEaQMZoiRwBYWTbe+IGLltv5i6T5eey+qrWdb4
         t992d9qpgI10I2id82bAhwaEiRA23iyB+NHG/KScsr6UtUuIZWRyt6nFvA8wQc5gU1HX
         iM25AfFMNZSJLMty1P/HPHddZ7Om/+YBEUzeYqj5aEU2FtOhJHaVvo9zbIvf9l2ezHzQ
         2S4vwZ6exzsaiJOdB4mARDDLxyh29AQ6+DFPBDTIaYxvPQ7iYsrV3k77kCYBKTQI5c4u
         KRwBb6k3RaX0i3ANO9mjFru3EoRdeKddLlWHhBb2Jy8dg6bBf25irr5zw3o8mRJX36e3
         oejw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gWZ4k2dTIF+KQYdLjdoJdXgFuc+j8wPi3Dg4q2AoyAo=;
        b=tQRfbIowTTD/7IfOzMaVuKV4d8j58LLQu4AVr6Uqc0ZA5lY/HMEphLTOEXbXRfzIqZ
         FfY9uhyXrNz4xm1geXTSKP1M+Hn6CyI2JYzZvZURK1nJWC5GAAScRz2GMcGTHmt/ENe8
         c4dorx3hrMqKjWrQKgrquXMrc7zyQHSF8qPwMDXX0RHzhsHH6SdHFwe0G/0r8JGviwee
         eV546CEaxDt4O9ggwktXtQjh3voUoLA4Ki4aRObJRAOn+LfPjLtxFqcZt2K6ZtY1fj8v
         4bc28QHhO6s24CDpipndixPdCD5Ej38F9u6qIJHQgMvTey2fBmyd/Eqky4stsaX/OjYz
         twQg==
X-Gm-Message-State: AOAM533I/eUE3Bemz6nbvjZOvgvNYh1M/PtqQdG6QQwLcCDcw8tbgUl5
        BikjGskXFj2tdpqYQals25c=
X-Google-Smtp-Source: ABdhPJxSe4kW9fBFv+61h6hRdMiN9B8RVylTM9oqSRayEPqFT+n3/9C3FHIxGeXChk1h95hFIa++uA==
X-Received: by 2002:a05:6870:1b14:b0:d2:bcb8:7496 with SMTP id hl20-20020a0568701b1400b000d2bcb87496mr1517847oab.37.1645804083400;
        Fri, 25 Feb 2022 07:48:03 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:641f:b8d5:43f6:63e9? ([2601:282:800:dc80:641f:b8d5:43f6:63e9])
        by smtp.googlemail.com with ESMTPSA id y2-20020a056808130200b002d542a72882sm1603919oiv.3.2022.02.25.07.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 07:48:02 -0800 (PST)
Message-ID: <41d055e3-9d88-bc43-cb3b-bd67ab071e11@gmail.com>
Date:   Fri, 25 Feb 2022 08:48:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next v3 4/4] net: tun: track dropped skb via
 kfree_skb_reason()
Content-Language: en-US
To:     Menglong Dong <menglong8.dong@gmail.com>, dongli.zhang@oracle.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        imagedong@tencent.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, rostedt@goodmis.org
References: <edddb6f9-70d1-4fcf-5630-cbdfe175e8ee@oracle.com>
 <20220225055732.1830237-1-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220225055732.1830237-1-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
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

On 2/24/22 10:57 PM, Menglong Dong wrote:
>>>
>>> For tun unique filters, how about using a shortened version of the ioctl
>>> name used to set the filter.
>>>
>>
>> Although TUN is widely used in virtualization environment, it is only one of
>> many drivers. I prefer to not introduce a reason that can be used only by a
>> specific driver.
>>
>> In order to make it more generic and more re-usable (e.g., perhaps people may
>> add ebpf filter to TAP driver as well), how about we create below reasons.
>>
>> SKB_DROP_REASON_DEV_FILTER,     /* dropped by filter attached to
>> 				 * or directly implemented by a
>> 				 * specific driver
>> 				 */
>> SKB_DROP_REASON_BPF_DEV,	/* dropped by bpf directly
>> 				 * attached to a specific device,
>> 				 * e.g., via TUNSETFILTEREBPF
>> 				 */
> 
> Aren't DEV_FILTER and BPF_DEV too generic? eBPF atached to netdev can
> be many kinds, such as XDP, TC, etc.

yes.

> 
> I think that use TAP_TXFILTER instaed of DEV_FILTER maybe better?
> and TAP_FILTER->BPF_DEV. Make them similar to the name in
> __tun_chr_ioctl() may be easier for user to understand.
> 

in this case given the unique attach points and API tap in the name
seems more appropriate
