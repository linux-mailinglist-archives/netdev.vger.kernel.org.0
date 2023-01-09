Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E95B6627BF
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236991AbjAINvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234464AbjAINvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:51:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C5E34D60
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673272238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VuOIdD/WEfpoJLynNTHzxtmnrk74A30Mt5Qb8Fjwiys=;
        b=hwbM0J4EcH7XzRRhtVXIYi9T/MLZyIhW1nxl2hb/w/fwwQB0vW5EpEsCVP7tT+eEk6BY9v
        WiCJ5Sw0ttDgQB8SolndzymRgcVrnMAIoiI/2+8OWIBIPDMZlGRLza5IaBhL636WN4Urpv
        +xRW1i0u9zi5nvRfuZWkyxhSMVS7X/I=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-532-3lhKo2D4P5y-HRVLF-MEXg-1; Mon, 09 Jan 2023 08:50:37 -0500
X-MC-Unique: 3lhKo2D4P5y-HRVLF-MEXg-1
Received: by mail-ed1-f72.google.com with SMTP id r14-20020a05640251ce00b0047d67ab2019so5282168edd.12
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 05:50:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VuOIdD/WEfpoJLynNTHzxtmnrk74A30Mt5Qb8Fjwiys=;
        b=y37/GN2vMeJy775Xi1eUEtsRGuSyNAdMtAuH39aoNT1uBEEEb0K9De/U3e8HFa/DJL
         K6cIoT0WOn7OoQwzqUVEWnc/D3WS1EdLSuO8rjN9j4rHeQlP6aZZ2bOyRLLO69KOXK88
         4R0mQTWrsbafQSwDHLHm5mVPRP9APHeFTWc7aVbdCQhTN/MF1TQnn6MTfb2Mux8GAS5p
         05xJBlXgFATedCACS3dnicgkVtk2XOeKyrpO6SBBSiZBVbsBnnCl3ruSWAK9p94pNpUc
         OArA//Vr1S0BjD8BwHWXGhh8lEuxzgXk4todOaodk0dFG2n/fgMdByM13GNcoUSGeTRf
         ACnA==
X-Gm-Message-State: AFqh2kpAwsF6ltsKPQ9zUa7e5CtCxpYk80QOVHxr+s/Qe/XFRotOKOBN
        wIXBjIArpDGFAMiBSlU423ciAKswGmblZvng2r17a/SSceTWXFtrDcVxDrNJt91M/vOoPQ0tMBp
        S+rl0w8qPNAYJNns3
X-Received: by 2002:a17:906:b00d:b0:7c1:435c:d777 with SMTP id v13-20020a170906b00d00b007c1435cd777mr53804627ejy.9.1673272235400;
        Mon, 09 Jan 2023 05:50:35 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtnzvpUi3hn0k9bF9Hzds5wwVbnGtACM4C4O+W/mU2OrGwJ5iYVoktmdCHZpfvT3LRy6Kxafw==
X-Received: by 2002:a17:906:b00d:b0:7c1:435c:d777 with SMTP id v13-20020a170906b00d00b007c1435cd777mr53804590ejy.9.1673272234656;
        Mon, 09 Jan 2023 05:50:34 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k11-20020a1709062a4b00b0073022b796a7sm3851312eje.93.2023.01.09.05.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 05:50:33 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 641B7900180; Mon,  9 Jan 2023 14:50:33 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        lorenzo.bianconi@redhat.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>, gal@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>, tariqt@nvidia.com
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
In-Reply-To: <4a44bdec-b635-20ef-e915-1733e53c6f38@gmail.com>
References: <20220621175402.35327-1-gospo@broadcom.com>
 <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com> <87k0234pd6.fsf@toke.dk>
 <20230103172153.58f231ba@kernel.org> <Y7U8aAhdE3TuhtxH@lore-desk>
 <87bkne32ly.fsf@toke.dk> <a12de9d9-c022-3b57-0a15-e22cdae210fa@gmail.com>
 <871qo90yxr.fsf@toke.dk> <Y7cBfE7GpX04EI97@C02YVCJELVCG.dhcp.broadcom.net>
 <20230105101642.1a31f278@kernel.org>
 <8369e348-a8ec-cb10-f91f-4277e5041a27@nvidia.com>
 <4a44bdec-b635-20ef-e915-1733e53c6f38@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 09 Jan 2023 14:50:33 +0100
Message-ID: <87fscjakba.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tariq Toukan <ttoukan.linux@gmail.com> writes:

> On 08/01/2023 14:33, Tariq Toukan wrote:
>>=20
>>=20
>> On 05/01/2023 20:16, Jakub Kicinski wrote:
>>> On Thu, 5 Jan 2023 11:57:32 -0500 Andy Gospodarek wrote:
>>>>> So my main concern would be that if we "allow" this, the only way to
>>>>> write an interoperable XDP program will be to use bpf_xdp_load_bytes()
>>>>> for every packet access. Which will be slower than DPA, so we may=20
>>>>> end up
>>>>> inadvertently slowing down all of the XDP ecosystem, because no one is
>>>>> going to bother with writing two versions of their programs. Whereas =
if
>>>>> you can rely on packet headers always being in the linear part, you c=
an
>>>>> write a lot of the "look at headers and make a decision" type programs
>>>>> using just DPA, and they'll work for multibuf as well.
>>>>
>>>> The question I would have is what is really the 'slow down' for
>>>> bpf_xdp_load_bytes() vs DPA?=C2=A0 I know you and Jesper can tell me h=
ow many
>>>> instructions each use. :)
>>>
>>> Until we have an efficient and inlined DPA access to frags an
>>> unconditional memcpy() of the first 2 cachelines-worth of headers
>>> in the driver must be faster than a piece-by-piece bpf_xdp_load_bytes()
>>> onto the stack, right?
>>>
>>>> Taking a step back...years ago Dave mentioned wanting to make XDP
>>>> programs easy to write and it feels like using these accessor APIs wou=
ld
>>>> help accomplish that.=C2=A0 If the kernel examples use bpf_xdp_load_by=
tes()
>>>> accessors everywhere then that would accomplish that.
>>>
>>> I've been pushing for an skb_header_pointer()-like helper but
>>> the semantics were not universally loved :)
>>=20
>> Maybe it's time to re-consider.
>>=20
>> Is it something like an API that given an offset returns a pointer +=20
>> allowed length to be accessed?
>>=20
>> This sounds like a good direction to me, that avoids having any=20
>> linear-part-length assumptions, while preserving good performance.
>>=20
>> Maybe we can still require/guarantee that each single header (eth, ip,=20
>> tcp, ...) does not cross a frag/page boundary. For otherwise, a prog=20
>> needs to handle cases where headers span several fragments, so it has to=
=20
>> reconstruct the header by copying the different parts into some local=20
>> buffer.
>>=20
>> This can be achieved by having another assumption that AFAIK already=20
>> holds today: all fragments are of size PAGE_SIZE.
>>=20
>> Regards,
>> Tariq
>
> This can be a good starting point:
> static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
>
> It's currently not exposed as a bpf-helper, and it works a bit=20
> differently to what I mentioned earlier: It gets the desired length, and=
=20
> fails in case it's not continuously accessible (i.e. this piece of data=20
> spans multiple frags).

Did a bit of digging through the mail archives. Exposing
bpf_xdp_pointer() as a helper was proposed back in March last year:

https://lore.kernel.org/r/20220306234311.452206-1-memxor@gmail.com

The discussion of this seems to have ended on "let's use dynptrs
instead". There was a patch series posted for this as well, which seems
to have stalled out with this comment from Alexei in October:

https://lore.kernel.org/r/CAADnVQKhv2YBrUAQJq6UyqoZJ-FGNQbKenGoPySPNK+GaOjB=
Og@mail.gmail.com

-Toke

