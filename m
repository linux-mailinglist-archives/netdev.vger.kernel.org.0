Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B338A21BD40
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 20:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgGJS5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 14:57:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36105 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726872AbgGJS5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 14:57:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594407449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g3vr4p3HOtOZH3FqPih/GiIpdmOKnnPMCPNV6jgpCAc=;
        b=CCkEY7gbdI/8oCPGGZnp9v+BSAKjP6Vhs2aUVX/V7x0RrlGWHHHe49n8MGKPCRnQwYf/6r
        bcK0cZHNlyflPrG3NBAI676yUswh/bQkQaB/hNQz52dJ6sPy4EjVJxzFmsuGnah7ONoZ+J
        2eBWj1FTtS8ToQj+AvaFIR2fHBnd7iU=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-MUvmlh3pNnOCKOyVn-HQOg-1; Fri, 10 Jul 2020 14:57:25 -0400
X-MC-Unique: MUvmlh3pNnOCKOyVn-HQOg-1
Received: by mail-pg1-f198.google.com with SMTP id s1so4735054pge.16
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 11:57:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=g3vr4p3HOtOZH3FqPih/GiIpdmOKnnPMCPNV6jgpCAc=;
        b=WfOtGoIAt4IXvuAbRsx+yxq0tv8uIehZHMy4rUDBgjKylOsUWUIqjDnDwIVZ/4OPBF
         O637smxs7sGKux7n5Qv7nxAPh+b8BIYU/ueh8HsiKJoUBRfjm2QhHXpf/a67PhqmeEQy
         TRJf8NUXK4Glq9YDVBVHBwCax5V6fdPqq//96EJFrd8hAajOnUw8MKZ+pPZaOjBK/fdo
         n9z2DcLQgaAgLhThDaXxHjZlgle2xpk+k/jkMX520Srq0aTCAh9SYh/yKq95tm5IClpb
         Q17lFm2XpP5LuEEfyJrqgV57QIqOidJafxbrn5cL0XEApQ9HKZdzRC8FY5sR47UYtbVl
         nWWA==
X-Gm-Message-State: AOAM530t9/dAq3Q0NY/3tJ2YHQlEWBASQuMKVyYVrhbqCDVRoZYz/mA9
        YRqje/PKGlCli/CNKsKS5SV/pEmtpRjKw4sJbTBMXKSxuKegqaLoUkkR+Eg3WrEl1swD9ezd8hA
        kso1VeoHwhuJJ36sv
X-Received: by 2002:a17:902:9f96:: with SMTP id g22mr15845517plq.306.1594407444709;
        Fri, 10 Jul 2020 11:57:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/tVx6cQ9PiRSX4L09kZ6HuM+5mJq1HjYk1MsqxC65kL5z0rrT8cvGQ00NqVS3PFpZ66gdNg==
X-Received: by 2002:a17:902:9f96:: with SMTP id g22mr15845508plq.306.1594407444386;
        Fri, 10 Jul 2020 11:57:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id y7sm6084764pgk.93.2020.07.10.11.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 11:57:23 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BA49D1808CD; Fri, 10 Jul 2020 20:57:17 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Joe Perches <joe@perches.com>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, mchehab+huawei@kernel.org,
        robh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: XDP: restrict N: and K:
In-Reply-To: <a91354960fc97437bd872fa22a2ce1c60bda3e25.camel@perches.com>
References: <20200709194257.26904-1-grandmaster@al2klimov.de> <d7689340-55fc-5f3f-60ee-b9c952839cab@iogearbox.net> <19a4a48b-3b83-47b9-ac48-e0a95a50fc5e@al2klimov.de> <7d4427cc-a57c-ca99-1119-1674d509ba9d@iogearbox.net> <a2f48c734bdc6b865a41ad684e921ac04b221821.camel@perches.com> <875zavjqnj.fsf@toke.dk> <458f6e74-b547-299a-4255-4c1e20cdba1b@al2klimov.de> <a91354960fc97437bd872fa22a2ce1c60bda3e25.camel@perches.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 10 Jul 2020 20:57:17 +0200
Message-ID: <87tuyfi4fm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Fri, 2020-07-10 at 20:18 +0200, Alexander A. Klimov wrote:
>>=20
>> Am 10.07.20 um 18:12 schrieb Toke H=C3=B8iland-J=C3=B8rgensen:
>> > Joe Perches <joe@perches.com> writes:
>> >=20
>> > > On Fri, 2020-07-10 at 17:14 +0200, Daniel Borkmann wrote:
>> > > > On 7/10/20 8:17 AM, Alexander A. Klimov wrote:
>> > > > > Am 09.07.20 um 22:37 schrieb Daniel Borkmann:
>> > > > > > On 7/9/20 9:42 PM, Alexander A. Klimov wrote:
>> > > > > > > Rationale:
>> > > > > > > Documentation/arm/ixp4xx.rst contains "xdp" as part of "ixdp=
465"
>> > > > > > > which has nothing to do with XDP.
>> > > []
>> > > > > > > diff --git a/MAINTAINERS b/MAINTAINERS
>> > > []
>> > > > > > > @@ -18708,8 +18708,8 @@ F:    include/trace/events/xdp.h
>> > > > > > >    F:    kernel/bpf/cpumap.c
>> > > > > > >    F:    kernel/bpf/devmap.c
>> > > > > > >    F:    net/core/xdp.c
>> > > > > > > -N:    xdp
>> > > > > > > -K:    xdp
>> > > > > > > +N:    (?:\b|_)xdp(?:\b|_)
>> > > > > > > +K:    (?:\b|_)xdp(?:\b|_)
>> > > > > >=20
>> > > > > > Please also include \W to generally match on non-alphanumeric =
char given you
>> > > > > > explicitly want to avoid [a-z0-9] around the term xdp.
>> > > > > Aren't \W, ^ and $ already covered by \b?
>> > > >=20
>> > > > Ah, true; it says '\b really means (?:(?<=3D\w)(?!\w)|(?<!\w)(?=3D=
\w))', so all good.
>> > > > In case this goes via net or net-next tree:
>> > >=20
>> > > This N: pattern does not match files like:
>> > >=20
>> > > 	samples/bpf/xdp1_kern.c
>> > >=20
>> > > and does match files like:
>> > >=20
>> > > 	drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
>> > >=20
>> > > Should it?
>> >=20
>> > I think the idea is that it should match both?
>> In *your* opinion: Which of these shall it (not) match?
>
> Dunno, but it doesn't match these files.
> The first 5 are good, the rest probably should.

Yup, I agree, all but the first 5 should be matched...

-Toke

> $ git ls-files | grep xdp | grep -v -P '(?:\b|_)xdp(?:\b|_)'
> Documentation/hwmon/xdpe12284.rst
> arch/arm/mach-ixp4xx/ixdp425-pci.c
> arch/arm/mach-ixp4xx/ixdp425-setup.c
> arch/arm/mach-ixp4xx/ixdpg425-pci.c
> drivers/hwmon/pmbus/xdpe12284.c
> samples/bpf/xdp1_kern.c
> samples/bpf/xdp1_user.c
> samples/bpf/xdp2_kern.c
> samples/bpf/xdp2skb_meta.sh
> samples/bpf/xdp2skb_meta_kern.c
> samples/bpf/xdpsock.h
> samples/bpf/xdpsock_kern.c
> samples/bpf/xdpsock_user.c
> tools/testing/selftests/bpf/progs/xdping_kern.c
> tools/testing/selftests/bpf/test_xdping.sh
> tools/testing/selftests/bpf/xdping.c
> tools/testing/selftests/bpf/xdping.h

