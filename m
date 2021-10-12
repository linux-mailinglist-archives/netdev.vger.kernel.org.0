Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAAB642A6DE
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 16:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbhJLON4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:13:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26566 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236888AbhJLONz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 10:13:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634047913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0iK1/pGNnUtvxIpXr8vij/Yx3QTTCdY0pXxA5X8g5Gc=;
        b=fVmZoqFQothaIjCXdy9asvNYwevrQxqMb6Kji9q+VCjetCGuIZ+go8Oqml+uIo5NmkUEdH
        oxtXLmJIcJcvWctdDG5ImRtlITGhV1VeDwF1vMC01KGSnWeiuX63H2D2pVJQRnGRZHyIy9
        u5zim4xV1k/L7vaZilJPKeLcbxgXwUs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-sarYPBWsNXC1XE4tPs09oA-1; Tue, 12 Oct 2021 10:11:52 -0400
X-MC-Unique: sarYPBWsNXC1XE4tPs09oA-1
Received: by mail-ed1-f70.google.com with SMTP id c30-20020a50f61e000000b003daf3955d5aso45212edn.4
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 07:11:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=0iK1/pGNnUtvxIpXr8vij/Yx3QTTCdY0pXxA5X8g5Gc=;
        b=cYUFhDJlSUj6XKygXvPoGMdyxLyTzzkAhgxDQ5K5Nv3MjVXBuebfNnzWYZJjUAHj9m
         DBpFCAuoIb/WEIt0EjlaHXGIh7aLb/+4aJvQIuYp9VNWcl6ys8hwXkf+YhLsCC0fhMXY
         xtJdvc/J7YK/LItw0GLU8n/DOYuwnj8pus1lkSkK+cQ+cXsgwfprirDkTqK+FWg5bAuA
         ssVtzdvh9dZJW3bgc2n2tPd8jIjfyT8l2xLFUGo7ReVnemL3LvVaD7mTr1FlXle86IyD
         GyoAOoXkyz3BUnjSIKO94WC9Lnd2yNu1VZSdsLKdkgPtqzSSV9B3PFCSmcOe8VnhjQby
         vkyw==
X-Gm-Message-State: AOAM532bO0uWjnaPhNHLFH4EDQcaYPO/cWWY8axq0q3BxhlDbClAOfW4
        ai2MqX85VSsRDcmf0JtW2Me06nGkFFvtQPoZabVU9c7hJDUo0NyGLYKMqYrTdo70VqcOc8BLQua
        aa6dDqt0dGQ7i7Ecy
X-Received: by 2002:a50:cf86:: with SMTP id h6mr184924edk.104.1634047910256;
        Tue, 12 Oct 2021 07:11:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0Cl6+LJW1EksJuzAgqSLF1FNTHg1p7RnOXfBgT0U4JakKnBEfKK33kzhBFIW3GQufFwaz7w==
X-Received: by 2002:a50:cf86:: with SMTP id h6mr184844edk.104.1634047909506;
        Tue, 12 Oct 2021 07:11:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f12sm2470365edx.90.2021.10.12.07.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 07:11:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 041FC180151; Tue, 12 Oct 2021 16:11:48 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Joanne Koong <joannekoong@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Kernel-team@fb.com
Subject: Re: [PATCH bpf-next v2 0/3] Add XDP support for bpf_load_hdr_opt
In-Reply-To: <20211011184333.sb7zjdsty7gmtlvl@kafai-mbp>
References: <20211006230543.3928580-1-joannekoong@fb.com>
 <87h7dsnbh5.fsf@toke.dk> <9f8c195c-9c03-b398-2803-386c7af99748@fb.com>
 <43bfb0fe-5476-c62c-51f2-a83da9fef659@iogearbox.net>
 <20211007235203.uksujks57djohg3p@kafai-mbp> <87lf33jh04.fsf@toke.dk>
 <20211011184333.sb7zjdsty7gmtlvl@kafai-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 12 Oct 2021 16:11:47 +0200
Message-ID: <87v922gwnw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> writes:

> On Sat, Oct 09, 2021 at 12:20:27AM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> So if we can't fix the verifier, maybe we could come up with a more
>> general helper for packet parsing? Something like:
>>=20
>> bpf_for_each_pkt_chunk(ctx, offset, callback_fn, callback_arg)
>> {
>>   ptr =3D ctx->data + offset;
>>   while (ptr < ctx->data_end) {
>>     offset =3D callback_fn(ptr, ctx->data_end, callback_arg);
>>     if (offset =3D=3D 0)
>>       return 0;
>>     ptr +=3D offset;
>>   }
>>=20=20=20
>>   // out of bounds before callback was done
>>   return -EINVAL;
>> }
>>=20=20=20=20
>> This would work for parsing any kind of packet header or TLV-style data
>> without having to teach the kernel about each header type. It'll have
>> quite a bit of overhead if all the callbacks happen via indirect calls,
>> but maybe the verifier can inline the calls (or at least turn them into
>> direct CALL instructions)?
> Direct call different callback_fn?  bpf_for_each_pkt_chunk() is a kernel
> function.  It would be nice if the verifier could do that.

Ohh, right, think-o on my part. It could be done if the helper was
inlined in its entirety, though? Not sure if that's feasible?

> This for_each helper had been considered also. Other than the need to
> callback in a loop, the thought was to extend the existing
> bpf_load_hdr_opt() because our initial feedback is the same header
> handling logic cannot be used in xdp which is confusing.

TBH, I had not noticed this helper before. Now that I have, it does
seems like the kind of thing that belongs as a BPF library function
rather than a helper in the first place :)

> I don't mind to go with the for_each helper.  However, with another
> thought, if it needs to call a function in the loop anyway, I think
> it could also be done in bpf by putting a global function in a loop.
> Need to try and double check.

Hmm, that would be interesting if possible!

-Toke

