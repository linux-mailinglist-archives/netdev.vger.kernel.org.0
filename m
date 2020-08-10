Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624FC240D67
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 21:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgHJTD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 15:03:59 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50481 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728215AbgHJTD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 15:03:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597086236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jgjf2NshHAceA99G9hTTil7sUKhf3WdGM7KeEQ2smd8=;
        b=bcxgbG2HS5derymWDeNkpLU1gA5ZtyRvVS1S8Ydff+odSDabF8ZSImT5f61HPcCc3Sb1S6
        NBybIm1r+UPn2lHBuI1xFDOzXoaLy6YGZamjpj6+z7OZmDiH4gqU0y7HDaSXKXfjHP6M5s
        e55YyHDhrGDyxN75D1+vnACsMSufKrQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-AKgKBiJvME-rQR0u8N1-CQ-1; Mon, 10 Aug 2020 15:03:55 -0400
X-MC-Unique: AKgKBiJvME-rQR0u8N1-CQ-1
Received: by mail-wr1-f72.google.com with SMTP id b18so4586084wrn.6
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 12:03:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Jgjf2NshHAceA99G9hTTil7sUKhf3WdGM7KeEQ2smd8=;
        b=fvCWZi8rt+Hg7K9WyJlV9e/IrEZOrgK1a12qgRSIYaAJ4JSHn8SeTK1n8AGYkQHFSb
         4ZTmDlX8yz5eSSTUpyQs07MFFmDMbdxdL0vM51KElB7MhQ216+sdeGLvAp+8xh/x6/ea
         EBuqOU/IC+KJ6UydTniHOhGBZDo/x4mbGb+NrJpdPeItOkKbJVY+b1r6AOupGo77Ci7K
         nCaPrEgRlkxCCBxq/pur2nmC91FHviHc1lqL3v7lt1DRfi5v/TKyMS2vMiPp6oiNmrb+
         P1v0iclKM9m7J2ZNi75fH6BiVA6nJIE9/7M6Mzx+e3jpn87Y4Zz46BPmU4cqMCnYlIHX
         pzlQ==
X-Gm-Message-State: AOAM530eQVuv6wogPCsIigAD07bd8D6jjGgIz5PPjkI3uM4aQY21aybe
        cEXTeUXHrcVUb/jlzgMhwtDmesikg4kVpbh8XkTQlfSxUHs6ehrbljGZffLu3UrpAlwb+2DHn+B
        0NEuI8JuhC4vmOdRx
X-Received: by 2002:a1c:e184:: with SMTP id y126mr555067wmg.141.1597086234034;
        Mon, 10 Aug 2020 12:03:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyF5VEVaO8RQpZHKKvjl2zgFvHMR0mhQHML8IsXTpk7OixAn7Tw4J651/QIuYp1uNfh8Ka6UQ==
X-Received: by 2002:a1c:e184:: with SMTP id y126mr555054wmg.141.1597086233865;
        Mon, 10 Aug 2020 12:03:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id d11sm22161320wrw.77.2020.08.10.12.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2020 12:03:53 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D607B18282F; Mon, 10 Aug 2020 21:03:52 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/5] BPF link force-detach support
In-Reply-To: <CAEf4BzZMC4LWpgOMBgKaLAGLPmt4rz0D7_sNC+i=yaVhEtDG9g@mail.gmail.com>
References: <20200729230520.693207-1-andriin@fb.com> <874kpa4kag.fsf@toke.dk> <CAEf4BzZMC4LWpgOMBgKaLAGLPmt4rz0D7_sNC+i=yaVhEtDG9g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 10 Aug 2020 21:03:52 +0200
Message-ID: <87mu322uhz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

>> BTW, I've noticed that you tend to drop Ccs on later versions of your
>> patch series (had to go and lookup v2 of this to check that it was in
>> fact merged). Is that intentional? :)
>
> Hm.. not sure about whether I tend to do that. But in this it was
> intentional and I dropped you from CC because I've seen enough
> reminders about your vacation, didn't need more ;)

Haha, that's fair ;)

> In general, though, I try to keep CC list short, otherwise vger blocks
> my patches. People directly CC'd get them, but they never appear on
> bpf@vger mailing list. So it probably happened a few times where I
> started off with longer CC and had to drop people from it just to get
> my patches into patchworks.

Ah, I have had that happen to me (patches not showing up on vger), but
had no idea that could be related to a long Cc list. Good to know! And
thanks for the explanation - it's not a huge issue for me (I do
generally keep up with netdev@ and bpf@ although as you can no doubt
imagine I'm a wee bit behind right now), was just wondering...

-Toke

