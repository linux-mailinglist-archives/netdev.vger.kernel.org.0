Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE0F661516
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 13:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbjAHMeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 07:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbjAHMeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 07:34:02 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3534EBF5C;
        Sun,  8 Jan 2023 04:34:00 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id fy8so13661313ejc.13;
        Sun, 08 Jan 2023 04:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XIRyk2y61xmdD/0Njep3MetjdHYndWgObyJ8GP2ZYB4=;
        b=aP2b+SBDI9HY41lQH+8nV2TbYOdNkT1EO/CEIdf1NKDSydYCP8mA/4iKToqbH7Omvq
         8FfTJ6U20cYvRrfZcfTLuUQB1w7hZkSMGBPc1IjqQCT2E0zjMF2hpZn/gAHOYnfB4PRS
         gfObBLsJf4aM7sYLHSTWBaHNDcl1ZkEiPbmhBTq8qunKs8L/Uhed4c11SJB+nPhzqXzs
         vBqERoJxTQ2laQ0uch2+aVeZProxRntTMTLOx/J90fZt4dzjP2qZWn3W/Y29cabMVh01
         jI9M2ymQVuLb/oSGND0h3+9eIQzNEmAdf7+8dSFyieLMWeNnDHwgrAxoXf2Ta1YUjySt
         wNVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XIRyk2y61xmdD/0Njep3MetjdHYndWgObyJ8GP2ZYB4=;
        b=RU5SJ+XjJIb3zRLNoEzLMq3jGUhcS6z5Qeb07XSlWXTS97iaINSZeprOa1xzHxbYZ+
         +mMSYFVTz7Aj2ANefspo1NOqw6jXjvhHt/IKz0FllMCBDHHY69fIS5DE3Aqw8XHmXAwR
         AtebMkx075qurPMGhwUjpj1pKmClfBtC7pX1PvPczWxEntP5gOCuHOZQPKo+WKGA+413
         PP1bbyW7fByTkKevz8DEcJlwc5aCCuAk2l4iJ+mpbBTXLkewRWbGI5DgsVlyduZqTsKD
         cGrVG4VPdC8AE8MLfN3kS3jdgrUdAXkuafN2cRT03z0AK/6xfUptQRRNR9ROCPDYvV4T
         Vvlg==
X-Gm-Message-State: AFqh2kolxN/vhblgEn8BH8Tv2qdQS064Oc5op2G0CApUo0+I94ZKafgc
        2u8PlJ0e1MXt74J4lh0H9iUGvVyGgL0RMQFi
X-Google-Smtp-Source: AMrXdXtKLATHJHv5VOm2Ma50GBMoIQUnOoUDsUz4NfJvShg0zUAs4YevNRlSYHpPOgUq30dCa/2hCQ==
X-Received: by 2002:a17:906:958:b0:7c0:be4d:46d6 with SMTP id j24-20020a170906095800b007c0be4d46d6mr47584747ejd.59.1673181238720;
        Sun, 08 Jan 2023 04:33:58 -0800 (PST)
Received: from [192.168.0.105] ([77.126.9.245])
        by smtp.gmail.com with ESMTPSA id lb24-20020a170907785800b008448d273670sm2453924ejc.49.2023.01.08.04.33.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jan 2023 04:33:58 -0800 (PST)
Message-ID: <8b8107bd-87da-7a86-6284-119e440d2aaf@gmail.com>
Date:   Sun, 8 Jan 2023 14:33:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        lorenzo.bianconi@redhat.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>, gal@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>, tariqt@nvidia.com
References: <20220621175402.35327-1-gospo@broadcom.com>
 <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com> <87k0234pd6.fsf@toke.dk>
 <20230103172153.58f231ba@kernel.org> <Y7U8aAhdE3TuhtxH@lore-desk>
 <87bkne32ly.fsf@toke.dk> <a12de9d9-c022-3b57-0a15-e22cdae210fa@gmail.com>
 <871qo90yxr.fsf@toke.dk> <Y7cBfE7GpX04EI97@C02YVCJELVCG.dhcp.broadcom.net>
 <20230105101642.1a31f278@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230105101642.1a31f278@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
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



On 05/01/2023 20:16, Jakub Kicinski wrote:
> On Thu, 5 Jan 2023 11:57:32 -0500 Andy Gospodarek wrote:
>>> So my main concern would be that if we "allow" this, the only way to
>>> write an interoperable XDP program will be to use bpf_xdp_load_bytes()
>>> for every packet access. Which will be slower than DPA, so we may end up
>>> inadvertently slowing down all of the XDP ecosystem, because no one is
>>> going to bother with writing two versions of their programs. Whereas if
>>> you can rely on packet headers always being in the linear part, you can
>>> write a lot of the "look at headers and make a decision" type programs
>>> using just DPA, and they'll work for multibuf as well.
>>
>> The question I would have is what is really the 'slow down' for
>> bpf_xdp_load_bytes() vs DPA?  I know you and Jesper can tell me how many
>> instructions each use. :)
> 
> Until we have an efficient and inlined DPA access to frags an
> unconditional memcpy() of the first 2 cachelines-worth of headers
> in the driver must be faster than a piece-by-piece bpf_xdp_load_bytes()
> onto the stack, right?
> 
>> Taking a step back...years ago Dave mentioned wanting to make XDP
>> programs easy to write and it feels like using these accessor APIs would
>> help accomplish that.  If the kernel examples use bpf_xdp_load_bytes()
>> accessors everywhere then that would accomplish that.
> 
> I've been pushing for an skb_header_pointer()-like helper but
> the semantics were not universally loved :)

Maybe it's time to re-consider.

Is it something like an API that given an offset returns a pointer + 
allowed length to be accessed?

This sounds like a good direction to me, that avoids having any 
linear-part-length assumptions, while preserving good performance.

Maybe we can still require/guarantee that each single header (eth, ip, 
tcp, ...) does not cross a frag/page boundary. For otherwise, a prog 
needs to handle cases where headers span several fragments, so it has to 
reconstruct the header by copying the different parts into some local 
buffer.

This can be achieved by having another assumption that AFAIK already 
holds today: all fragments are of size PAGE_SIZE.

Regards,
Tariq
