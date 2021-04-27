Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4B136CEC9
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 00:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238826AbhD0WwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 18:52:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235382AbhD0WwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 18:52:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619563887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v6as3D7HAGsYOs+DVp3bYCUFIcYaa3W/8WdFsvXeV4c=;
        b=hOJj45UlohtoCTu8s3rEexhmwaumJ7kkGC4rbM82hpBAeJNhbxjKYIpUXAby9upmebpRoj
        bIi8w3pKX1CJKVwz/k3u1V9KOhu7Po6wPgRfdcV+qeNdrtjc8WEZp/r4lA77VMnwrsv1fl
        bx3AaVwfrJJj3lm5fpwj620OcCCELds=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-X_IYUcDAP3inJQHPZL_Wcw-1; Tue, 27 Apr 2021 18:51:25 -0400
X-MC-Unique: X_IYUcDAP3inJQHPZL_Wcw-1
Received: by mail-ed1-f71.google.com with SMTP id i2-20020a0564020542b02903875c5e7a00so6329882edx.6
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 15:51:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=v6as3D7HAGsYOs+DVp3bYCUFIcYaa3W/8WdFsvXeV4c=;
        b=Zadi2VF77G0uns7PwdS9y/gfarE2IXycsSbw8IyPqqkDVrPV6nTst23NDTjWklq3XX
         Osbz94cXpHYtZisbVaIOuWak2/nf9gH3GxnOGS5XaWDfg0Hvp6zDVN2zD6fnCSqCKk9p
         yOXvM/Hm7HxaVM7mTj7Z0cYqG+e6Gx3QH66xpjUmajF3ogaeHElgrT/r5WI0Ap8zsmg/
         kzEW4f/mwq1QGti2sSNBONSRTR+amr60ZEAvKN7yqXkvatmBlLUuTuGlUncRWA/rRHuk
         tYGfwTSwntfBPthJhW/uRquCS4zOubNjyXMQoz4kWL1i5DPLuHzIGWxoL0kTVuijzE0G
         qSMQ==
X-Gm-Message-State: AOAM532nacCc1N8vLQ+YqKBIDT/e51mWQjp7Orx1oWrUdpspjrk/PWWA
        JZfxEaIGzC6YYoqm5Kz/OwT7jbrXA6f18c/TZnkw3NXCLrz3CK3/L0vQNS01F/3Bt++W03I0yZN
        2fD/arpiiPS+z/XQJ
X-Received: by 2002:a17:906:4b01:: with SMTP id y1mr25205820eju.218.1619563884020;
        Tue, 27 Apr 2021 15:51:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyztZbJDoTySJqf6uSsR3a06TeEX9zed0qruvOxlQH/kpOFktb1tXU7ILK+dIZx3fhRQNo5kA==
X-Received: by 2002:a17:906:4b01:: with SMTP id y1mr25205797eju.218.1619563883683;
        Tue, 27 Apr 2021 15:51:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id x7sm674019ejc.116.2021.04.27.15.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 15:51:23 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4FA97180615; Wed, 28 Apr 2021 00:51:22 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 2/3] libbpf: add low level TC-BPF API
In-Reply-To: <8e6d24fa-d3ef-af20-b2a5-dbdc9a284f6d@iogearbox.net>
References: <20210423150600.498490-1-memxor@gmail.com>
 <20210423150600.498490-3-memxor@gmail.com>
 <5811eb10-bc93-0b81-2ee4-10490388f238@iogearbox.net>
 <20210427180202.pepa2wdbhhap3vyg@apollo>
 <9985fe91-76ea-7c09-c285-1006168f1c27@iogearbox.net>
 <7a75062e-b439-68b3-afa3-44ea519624c7@iogearbox.net>
 <87sg3b8idy.fsf@toke.dk>
 <8e6d24fa-d3ef-af20-b2a5-dbdc9a284f6d@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 28 Apr 2021 00:51:22 +0200
Message-ID: <87pmyf8hp1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 4/28/21 12:36 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
> [...]
>>> Small addendum:
>>>
>>>       DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex =3D 42, .which =
=3D BPF_TC_INGRESS|BPF_TC_EGRESS);
>>>
>>>       err =3D bpf_tc_hook_create(&hook);
>>>       [...]
>>>
>>> ... is also possible, of course, and then both bpf_tc_hook_{create,dest=
roy}() are symmetric.
>>=20
>> It should be allowed, but it wouldn't actually make any difference which
>> combination of TC_INGRESS and TC_EGRESS you specify, as long as one of
>> them is set, right? I.e., we just attach the clsact qdisc in both
>> cases...
>
> Yes, that is correct, for the bpf_tc_hook_create() whether you pass in BP=
F_TC_INGRESS,
> BPF_TC_EGRESS or BPF_TC_INGRESS|BPF_TC_EGRESS, you'll end up creating cls=
act qdisc in
> either of the three cases. Only the bpf_tc_hook_destroy() differs
> between all of them.

Right, just checking. Other than that, I like your proposal; it loses
the "automatic removal of qdisc if we added it" feature, but that's
probably OK: less magic is good. And as long as bpf_tc_hook_create()
returns EEXIST if the qdisc already exists, the caller can do the same
thing if they want.

-Toke

