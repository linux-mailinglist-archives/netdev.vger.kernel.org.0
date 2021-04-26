Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C4E36B4DB
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 16:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhDZOaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 10:30:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35930 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231862AbhDZOaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 10:30:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619447380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n46EzFusagW/ahDlcIl8UfUPxeR1VDuzUwzOh9SYcv0=;
        b=JIu4lwJQypzVhJnwPCk1MHjaWfBBrCLpAAZAVat/Fmq/4tLZgbE8P5lwqBjtTewWu65bMT
        6E7Q6FNH4DjWJ/R869RBo5N2C45yAdIOXs9M02ij+NjoF/8vyRTCOwUPgYTCS9cBcU8ZUV
        yxV48MJ77QOPyFGe0cnyLCb2S5NCbm0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-TPdaPW_iMR270PEyDLqsBA-1; Mon, 26 Apr 2021 10:29:38 -0400
X-MC-Unique: TPdaPW_iMR270PEyDLqsBA-1
Received: by mail-ed1-f71.google.com with SMTP id v5-20020a0564023485b029037ff13253bcso23113746edc.3
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 07:29:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=n46EzFusagW/ahDlcIl8UfUPxeR1VDuzUwzOh9SYcv0=;
        b=kca7dkinjBugh7dV9C9V/MouQUBUeWDIM2/qJ+PGWLC6VAnGKaZWhdfMm891ODSpDS
         MvBVX1zZxyMC1IEXIuxC7PITKP+v415Pq5DCDVmB+9tDc0jUVv1PKiC3rGBoOiENOq1/
         lutVa8E052NB7C2f0q+7k3/Ec9E7BIk8wJu3SgJ2oF6ctcFhhlz8C6Ta4QlHeS2n7O++
         DpYcMx9ng++NZRmb5kMYZjqwhehxqZ8ZsHE1qF4knse9ozB9HqahfuEYnm/9ygzV5Ckl
         hSythUBrIODP7orcJps9LWUJybcn8W07Ygx+msZnIxAkBg4qbmg9G0/6kj/m9RGuHTu/
         tqxA==
X-Gm-Message-State: AOAM530cnUfHNUoGjs7eF+RrC0UdQlrcyNKrYdMb8QpYSDqWB6uscKSD
        wfdeMcP29mUp/LgZ/Ud4J4TD8OYUHaIFEYCJNR2LYwid/LPY77YGOEXSA7QY9jPR1hhfEjtONL8
        mks+8E44O8ytxqDKO
X-Received: by 2002:a17:906:3949:: with SMTP id g9mr18990009eje.7.1619447376591;
        Mon, 26 Apr 2021 07:29:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/vyK35PDWKExWj9FjIbhZnWZPZu/9axc5kKeS2p7CnpOoAsINFe2QXhzu02C2aENU0YLqbA==
X-Received: by 2002:a17:906:3949:: with SMTP id g9mr18989967eje.7.1619447376154;
        Mon, 26 Apr 2021 07:29:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 9sm11378126ejv.73.2021.04.26.07.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 07:29:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B1A08180615; Mon, 26 Apr 2021 16:29:33 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?utf-8?B?QmrDtnJuIFQ=?= =?utf-8?B?w7ZwZWw=?= 
        <bjorn.topel@gmail.com>, Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCHv9 bpf-next 4/4] selftests/bpf: add xdp_redirect_multi test
In-Reply-To: <20210426101940.GP3465@Leo-laptop-t470s>
References: <20210422071454.2023282-1-liuhangbin@gmail.com>
 <20210422071454.2023282-5-liuhangbin@gmail.com>
 <20210426112832.0b746447@carbon> <20210426101940.GP3465@Leo-laptop-t470s>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 26 Apr 2021 16:29:33 +0200
Message-ID: <878s55ce5u.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> On Mon, Apr 26, 2021 at 11:28:32AM +0200, Jesper Dangaard Brouer wrote:
>> On Thu, 22 Apr 2021 15:14:54 +0800
>> Hangbin Liu <liuhangbin@gmail.com> wrote:
>> 
>> > Add a bpf selftest for new helper xdp_redirect_map_multi(). In this
>> > test there are 3 forward groups and 1 exclude group. The test will
>> > redirect each interface's packets to all the interfaces in the forward
>> > group, and exclude the interface in exclude map.
>> > 
>> > Two maps (DEVMAP, DEVMAP_HASH) and two xdp modes (generic, drive) will
>> > be tested. XDP egress program will also be tested by setting pkt src MAC
>> > to egress interface's MAC address.
>> > 
>> > For more test details, you can find it in the test script. Here is
>> > the test result.
>> > ]# ./test_xdp_redirect_multi.sh
>> 
>> Running this test takes a long time around 3 minutes.
>
> Yes, there are some sleeps, ping tests. Don't know if I missed
> anything, is there a time limit for the selftest?

Not formally, but we already get complaints about tests running too
long, and if you write a test that takes three minutes to run you all
but guarantee that no one is going to run it in practice... :)

You could play with things like decreasing the ping interval (with -i),
maybe running fewer of them, and getting rid of all those 'sleep'
statements to decrease the runtime...

-Toke

