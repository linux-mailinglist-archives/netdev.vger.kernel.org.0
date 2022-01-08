Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705EE4885EA
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 21:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbiAHUbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 15:31:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229822AbiAHUbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 15:31:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641673898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dh/KH9uD8FIprLuXVq8Q8sWK983oPsbIjBghc2ryCqg=;
        b=M9jevI4KOZiVtcb7rYL4VpcXRFNvg+pNsbyFTBeW4llRmTwJsfWtXvx5It6/Rv9WMf+/lD
        TbSUOYL7R8xbCdcIWG7E/fGbml5dRHurHpAKtIxCb8zB3fVK8CeGbUhYbDIdXTyD6QsQtO
        bcbMRD/TezGcDcjotgbNfWuprVYBQ3E=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-K_JeWRqbMYukYI-ATT4Sgw-1; Sat, 08 Jan 2022 15:30:31 -0500
X-MC-Unique: K_JeWRqbMYukYI-ATT4Sgw-1
Received: by mail-ed1-f72.google.com with SMTP id t1-20020a056402524100b003f8500f6e35so7256916edd.8
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 12:29:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Dh/KH9uD8FIprLuXVq8Q8sWK983oPsbIjBghc2ryCqg=;
        b=A0EUkGkvGzWu+PjP4WlY8B9l6w68UYI0WH0QPRfCCFky9tueGGKrs0vHA15Q/vSeR3
         0BnelM9GlKMbwNTl8SDOJ9TSi/HTc8I5XpNDEJvyR+CViDdfZ/stlmoaZvq3nVZODyiD
         Tc3vQKLjivfDreSFz72adxXJWVBJcHmo81F5Nwi3zlfNzGpFqoG34irD08xxDHIFvVdM
         G7R7GaD8lFmC3Bz1wiwtnDUcpgV/72y0lGEOfauBQqxhoGoGA6WJ95pUS2yeVv4wFfYP
         iHfIJgO3JXdNoVTWqph4qgccYZJLDc+IgU6Qdj5B5L2orOJrENIvz91PbjZjLzqlIV8f
         PkSw==
X-Gm-Message-State: AOAM532PXZg2xVD+adh9pA+Vuhl7X/qGvfhZaGcvu2J8oeMRhM0ibD/b
        lPl5hJ6tankjDh0hx/xbCTMDrNMAKdHjYPaW3dqgfi8rZ0cYqZm0f5p0JHEHvwwFGI50UtL5nd5
        TvUzRB3mERm4H/wUn
X-Received: by 2002:a17:906:f1c1:: with SMTP id gx1mr55930406ejb.554.1641673790476;
        Sat, 08 Jan 2022 12:29:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwTr5VGtDdGiudJAk1ztySeNuhP9qd+XBHQLnY8va9CaPUamGD8dX8c6oZmwI31EEz+qeH68Q==
X-Received: by 2002:a17:906:f1c1:: with SMTP id gx1mr55930389ejb.554.1641673790115;
        Sat, 08 Jan 2022 12:29:50 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g9sm1134615edb.53.2022.01.08.12.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 12:29:49 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C0956181F2A; Sat,  8 Jan 2022 21:29:48 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v7 3/3] selftests/bpf: Add selftest for
 XDP_REDIRECT in bpf_prog_run()
In-Reply-To: <CAADnVQ+oqGuvm1FCnXUrfPcvNFF5iwK-FeajLO0PpnifNNZ05g@mail.gmail.com>
References: <20220107215438.321922-1-toke@redhat.com>
 <20220107215438.321922-4-toke@redhat.com>
 <CAADnVQ+oqGuvm1FCnXUrfPcvNFF5iwK-FeajLO0PpnifNNZ05g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 08 Jan 2022 21:29:48 +0100
Message-ID: <87h7ae7yyr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Fri, Jan 7, 2022 at 1:54 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>> +
>> +#define NUM_PKTS 1000000
>
> It takes 7 seconds on my kvm with kasan and lockdep
> and will take much longer in BPF CI.
> So it needs to be lower otherwise CI will struggle.

OK, I'll lower it.

>> +       /* The XDP program we run with bpf_prog_run() will cycle through=
 all
>> +        * three xmit (PASS/TX/REDIRECT) return codes starting from abov=
e, and
>> +        * ending up with PASS, so we should end up with two packets on =
the dst
>> +        * iface and NUM_PKTS-2 in the TC hook. We match the packets on =
the UDP
>> +        * payload.
>> +        */
>
> could you keep cycling through all return codes?
> That should make the test stronger.

Can do.

>> +
>> +       /* We enable forwarding in the test namespace because that will =
cause
>> +        * the packets that go through the kernel stack (with XDP_PASS) =
to be
>> +        * forwarded back out the same interface (because of the packet =
dst
>> +        * combined with the interface addresses). When this happens, the
>> +        * regular forwarding path will end up going through the same
>> +        * veth_xdp_xmit() call as the XDP_REDIRECT code, which can caus=
e a
>> +        * deadlock if it happens on the same CPU. There's a local_bh_di=
sable()
>> +        * in the test_run code to prevent this, but an earlier version =
of the
>> +        * code didn't have this, so we keep the test behaviour to make =
sure the
>> +        * bug doesn't resurface.
>> +        */
>> +       SYS("sysctl -qw net.ipv6.conf.all.forwarding=3D1");
>
> Does it mean that without forwarding=3D1 the kernel will dead lock ?!

No, the deadlock is referring to the lockdep warning you posted. Which I
fixed by moving around the local_bh_disable(); that comment is just
meant to explain why the forwarding sysctl is set (so that the code path
is still exercised even though it's no longer faulty). Reading it again
now I can see that this was not entirely clear, will try to improve the
wording :)

-Toke

