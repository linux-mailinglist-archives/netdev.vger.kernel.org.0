Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFE3661526
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 13:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjAHMmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 07:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjAHMmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 07:42:31 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43101D10A;
        Sun,  8 Jan 2023 04:42:27 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id u19so13703042ejm.8;
        Sun, 08 Jan 2023 04:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yOn8TIRPR00PG6A/NUA1Jektk3ukD3peWvLx0zwGx7Y=;
        b=e5OtxWdlX2eBenfQ/1tJAVrdnL0IAIQXB0GHAa/C634tBF0XVGMFI+LrUhYqFmuCjB
         B6YQQxvMnCbtSzDswNwq/C2Jhb4F16SMiJPrOZzNjgK0v6tAKsZG11KEnoZt0r1UP5lS
         SGZqk508QYVyeZpSdH/4A/E8HQPYLkgp0mE2sbJ8O4bRG0AsaJsrxYC3vfGiOd1grtDr
         4nposOCmN17/Wf3uNQYI5uJkZ/GU9RPzICL+3x/rAuxphyTKTwQZ2VHRBu0XwQL+XMZx
         Njyq/k39kiyddB4LBtbDvSe/3eOF1asxJ2OHsGCY67dVjhAxsTlsKTt303AowLn64ira
         wvgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yOn8TIRPR00PG6A/NUA1Jektk3ukD3peWvLx0zwGx7Y=;
        b=sKkbNv3yot8LA9mwtL+fbn4T0pxAl2FjlaD4zRGfnX9yXHsk4ZQGspY+w6GkKHiFgc
         3r7dDGSNbQM3RNumRCGwyNxD5Il+gLRfzEpi0KhJWDoy6EsdciUNhLjg0ZY30dPw8+sC
         0xOHB/DemsA2vjFMwiaeo0e068B6O7BtJGyOcdf9X5egvXiq3HVqNmqnO6nm3LR+7U+5
         TvZm4espY1aGOeiM9i+8np8EwPiVpeZLpFVEB/Fo3eFaBsuZgszKELA0k0enfqtFK8RM
         tfOt5IgFzavuHFuMkoommbXca6Dt3EveaIouVwCB9k2sNw0y00qmgrwanRutcUclmDej
         /Qvg==
X-Gm-Message-State: AFqh2kqkGrLqhTa4fcB/IRnx6PmKStS5BtvWhP3ZxxajLNoFpsG3+vqq
        V+O4dYCsfckzH2hbVa6hYbg=
X-Google-Smtp-Source: AMrXdXt8JklWAMvi/D9dJNyn4Gf4Lah2CYnhPybggTPx4LEmNCUdvDsMXOFAAYTLRdUROyyxkB44rg==
X-Received: by 2002:a17:906:5048:b0:7c0:b770:df94 with SMTP id e8-20020a170906504800b007c0b770df94mr53211397ejk.63.1673181745719;
        Sun, 08 Jan 2023 04:42:25 -0800 (PST)
Received: from [192.168.0.105] ([77.126.9.245])
        by smtp.gmail.com with ESMTPSA id ba6-20020a0564021ac600b0045cf4f72b04sm2465611edb.94.2023.01.08.04.42.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jan 2023 04:42:25 -0800 (PST)
Message-ID: <4a44bdec-b635-20ef-e915-1733e53c6f38@gmail.com>
Date:   Sun, 8 Jan 2023 14:42:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
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
 <8369e348-a8ec-cb10-f91f-4277e5041a27@nvidia.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <8369e348-a8ec-cb10-f91f-4277e5041a27@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08/01/2023 14:33, Tariq Toukan wrote:
> 
> 
> On 05/01/2023 20:16, Jakub Kicinski wrote:
>> On Thu, 5 Jan 2023 11:57:32 -0500 Andy Gospodarek wrote:
>>>> So my main concern would be that if we "allow" this, the only way to
>>>> write an interoperable XDP program will be to use bpf_xdp_load_bytes()
>>>> for every packet access. Which will be slower than DPA, so we may 
>>>> end up
>>>> inadvertently slowing down all of the XDP ecosystem, because no one is
>>>> going to bother with writing two versions of their programs. Whereas if
>>>> you can rely on packet headers always being in the linear part, you can
>>>> write a lot of the "look at headers and make a decision" type programs
>>>> using just DPA, and they'll work for multibuf as well.
>>>
>>> The question I would have is what is really the 'slow down' for
>>> bpf_xdp_load_bytes() vs DPA?  I know you and Jesper can tell me how many
>>> instructions each use. :)
>>
>> Until we have an efficient and inlined DPA access to frags an
>> unconditional memcpy() of the first 2 cachelines-worth of headers
>> in the driver must be faster than a piece-by-piece bpf_xdp_load_bytes()
>> onto the stack, right?
>>
>>> Taking a step back...years ago Dave mentioned wanting to make XDP
>>> programs easy to write and it feels like using these accessor APIs would
>>> help accomplish that.  If the kernel examples use bpf_xdp_load_bytes()
>>> accessors everywhere then that would accomplish that.
>>
>> I've been pushing for an skb_header_pointer()-like helper but
>> the semantics were not universally loved :)
> 
> Maybe it's time to re-consider.
> 
> Is it something like an API that given an offset returns a pointer + 
> allowed length to be accessed?
> 
> This sounds like a good direction to me, that avoids having any 
> linear-part-length assumptions, while preserving good performance.
> 
> Maybe we can still require/guarantee that each single header (eth, ip, 
> tcp, ...) does not cross a frag/page boundary. For otherwise, a prog 
> needs to handle cases where headers span several fragments, so it has to 
> reconstruct the header by copying the different parts into some local 
> buffer.
> 
> This can be achieved by having another assumption that AFAIK already 
> holds today: all fragments are of size PAGE_SIZE.
> 
> Regards,
> Tariq

This can be a good starting point:
static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)

It's currently not exposed as a bpf-helper, and it works a bit 
differently to what I mentioned earlier: It gets the desired length, and 
fails in case it's not continuously accessible (i.e. this piece of data 
spans multiple frags).
