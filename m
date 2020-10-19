Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923D7292827
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 15:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgJSN27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 09:28:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43888 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727796AbgJSN27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 09:28:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603114137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LVvoxKlVxXg3INfBZ85MFvyvFnl4kGjDE0EL+WH7YIQ=;
        b=RAfYOosHnwS6jQ+4tAznvEFCwbpic8fkPZAn8uLT0DuWWFJIh5usiP/V83/AgMYxwaQrEf
        gbQKEjaw92V7VWAnwo5jRmP8GrKs/eVLskIeEkDDz/DOTV+HhPr2Fa6Y5nR/PrvsNoBrmG
        lLqwbqwvjdjdD+Jy4JUNjiycYPZmvss=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-_ZD5HdwQMY6TSP7nJZvCeg-1; Mon, 19 Oct 2020 09:28:56 -0400
X-MC-Unique: _ZD5HdwQMY6TSP7nJZvCeg-1
Received: by mail-vk1-f198.google.com with SMTP id j129so177139vkb.15
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 06:28:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=LVvoxKlVxXg3INfBZ85MFvyvFnl4kGjDE0EL+WH7YIQ=;
        b=fAakviRA9ecgwH1NEVJ5limOn6FYOeJKvK6FS5ZsaYA43/n11l3HXagIMd5OJnIsMj
         /zdQsNbiJK+RmQW3iIOf4pkSSz73WXT2d0pdDIJrSrRNZC8T7v7Rpzzt9ey5VGRv2GC8
         4HVBYN7tQi/fJzUfUgAJCtCdslnlEwtk/vDOAfyuxuEDXh3z8GY2daDHUqRVUjrb3+LD
         dCiM+FKy+t703lNxX1zET87FjLeinS+VrJqKWvBLYYFfoHRIlAgiTJ9znBQ5hh4+XBO8
         9Q/ImkaH/D6TqPuYBfSu2SKi7cyHKeKt0A1/5KPHDKJXZo0s7eWbM1+DUKSThXf9jyen
         C27w==
X-Gm-Message-State: AOAM533GDXZC711HYfQUpNRr1Wo6/fK9fELeruIrpGjxg+CCO65AWk2H
        CUdiVH3S2A9wLgjPZIK9YtuVbIV1VYjiiBjYW4zog7QUbwID8x0n2GBcjc1MSWY2jeJwSchETR6
        NKPYFqHtPt9hRu49W
X-Received: by 2002:ab0:21cf:: with SMTP id u15mr7346850uan.20.1603114135271;
        Mon, 19 Oct 2020 06:28:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCEtVdHF49zdXS99rhpE+S168nX94ZiTP7ZddD3I8zuyZLQ+JHuJI3oFlRKDCHoG8QXGp4nA==
X-Received: by 2002:ab0:21cf:: with SMTP id u15mr7346824uan.20.1603114134876;
        Mon, 19 Oct 2020 06:28:54 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j15sm456471vke.49.2020.10.19.06.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 06:28:54 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 929F01837DD; Mon, 19 Oct 2020 15:28:51 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH RFC bpf-next 1/2] bpf_redirect_neigh: Support supplying
 the nexthop as a helper parameter
In-Reply-To: <5365aae3-dd9c-fdde-822b-636cbcd33669@iogearbox.net>
References: <160277680746.157904.8726318184090980429.stgit@toke.dk>
 <160277680864.157904.8719768977907736015.stgit@toke.dk>
 <d5c14618-089d-5f29-7f10-11d11b0d59ab@gmail.com> <87blh3gu5q.fsf@toke.dk>
 <5365aae3-dd9c-fdde-822b-636cbcd33669@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 19 Oct 2020 15:28:51 +0200
Message-ID: <87362afip8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 10/15/20 9:34 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> David Ahern <dsahern@gmail.com> writes:
>>> On 10/15/20 9:46 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>>> index bf5a99d803e4..980cc1363be8 100644
>>>> --- a/include/uapi/linux/bpf.h
>>>> +++ b/include/uapi/linux/bpf.h
>>>> @@ -3677,15 +3677,19 @@ union bpf_attr {
>>>>    * 	Return
>>>>    * 		The id is returned or 0 in case the id could not be retrieved.
>>>>    *
>>>> - * long bpf_redirect_neigh(u32 ifindex, u64 flags)
>>>> + * long bpf_redirect_neigh(u32 ifindex, struct bpf_redir_neigh *param=
s, int plen, u64 flags)
>>>
>>> why not fold ifindex into params? with params and plen this should be
>>> extensible later if needed.
>>=20
>> Figured this way would make it easier to run *without* the params (like
>> in the existing examples). But don't feel strongly about it, let's see
>> what Daniel thinks.
>
> My preference is what Toke has here, this simplifies use by just being ab=
le to
> call bpf_redirect_neigh(ifindex, NULL, 0, 0) when just single external fa=
cing
> device is used.
>
>>> A couple of nits below that caught me eye.
>>=20
>> Thanks, will fix; the kernel bot also found a sparse warning, so I guess
>> I need to respin anyway (but waiting for Daniel's comments and/or
>> instructions on what tree to properly submit this to).
>
> Given API change, lets do bpf. (Will review the rest later today.)

Right, ACK. I'll wait for your review, then resubmit against the bpf
tree :)

-Toke

