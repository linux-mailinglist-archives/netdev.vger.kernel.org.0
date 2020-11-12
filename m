Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACEB2B11C8
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgKLWhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:37:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727708AbgKLWge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 17:36:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605220593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XhgHn2WJtZkLF+ApGVLkt0XduVBcSMTHxp7BqhQwEiI=;
        b=f/bzZU57CajRBXsk7gDkfhI7QcXO6yMiOP/vFDlToE+4UzOTexVdHztAAOyqO7RsTa4mat
        o2sK4kEXuhgmZ/Oi9+hxXzLwUdoQOUySj4eqZHGCUQMcyH/8bFvnhc3sQ2fV8zPl0yoagy
        eV7kgFx+Zap5N4iH5qmyKE1T71QF6DA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-ZWCFdUiXNGe3qSyfDt-1wg-1; Thu, 12 Nov 2020 17:36:31 -0500
X-MC-Unique: ZWCFdUiXNGe3qSyfDt-1wg-1
Received: by mail-wr1-f72.google.com with SMTP id y2so2693187wrl.3
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 14:36:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XhgHn2WJtZkLF+ApGVLkt0XduVBcSMTHxp7BqhQwEiI=;
        b=cIqTkor+YW7xYMeGoVHcdfhDDj7OkdnBuzdF9RvrSlHXL5fI/thkf0t76kICQ+nlri
         bTEXbHQ5bdFLqnPEk5Jt/KotoQoiPWpgi09LoiFEuUd5AJpvCkEkQGTTSKvJ+7qjDj4d
         z4010hOsL0bL+kDghOltqXcVKF9LFyZDo97hzKC3UqD5fmnQZDHyVTxtHtDFR8NGs59l
         3rpmboDJBfWNnmUGBMo1J06OFr402F9b1PreHHNSXpGv96DIQJFCXTZy00iklFVjyhAn
         KaOQVigwnXbuUSsEXzSpBLISyqF3CF8JqESveZCTBvyDWE9UZffTrAudlO/XE1d1HLYY
         2B9w==
X-Gm-Message-State: AOAM5308wJBjfewonR8MlI56y9IEq7ui+6Zp7XFnuGkUrUjy4u8buCUB
        +rEvYSZqKZE3lc5GJEH8CzgOmKL0XdLc/IRyHhdB677AtnuziPzMCb4RdJU+kSkiBjjklrZwQZc
        oYcbwLg9LPqFh+gCw
X-Received: by 2002:a5d:5643:: with SMTP id j3mr2011653wrw.43.1605220589963;
        Thu, 12 Nov 2020 14:36:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw5B1dz4Y5fMvfHGo7//UMwx0YvrMv+zb6yd42EN8mu+BvkRseRV5thcGxkng82q5Gf+Ffp3w==
X-Received: by 2002:a5d:5643:: with SMTP id j3mr2011535wrw.43.1605220588373;
        Thu, 12 Nov 2020 14:36:28 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f13sm3157112wrq.78.2020.11.12.14.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 14:36:27 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EDE5A1833E9; Thu, 12 Nov 2020 23:36:25 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Hangbin Liu <haliu@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
In-Reply-To: <321a2728-7a43-4a48-fe97-dab45b76e6fb@iogearbox.net>
References: <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
 <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com>
 <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
 <20201106094425.5cc49609@redhat.com>
 <CAEf4Bzb2fuZ+Mxq21HEUKcOEba=rYZHc+1FTQD98=MPxwj8R3g@mail.gmail.com>
 <CAADnVQ+S7fusZ6RgXBKJL7aCtt3jpNmCnCkcXd0fLayu+Rw_6Q@mail.gmail.com>
 <20201106152537.53737086@hermes.local>
 <45d88ca7-b22a-a117-5743-b965ccd0db35@gmail.com>
 <20201109014515.rxz3uppztndbt33k@ast-mbp>
 <14c9e6da-e764-2e2c-bbbb-bc95992ed258@gmail.com>
 <20201111004749.r37tqrhskrcxjhhx@ast-mbp> <874klwcg1p.fsf@toke.dk>
 <321a2728-7a43-4a48-fe97-dab45b76e6fb@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 12 Nov 2020 23:36:25 +0100
Message-ID: <871rgy8aom.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

>> Besides, for the entire history of BPF support in iproute2 so far, the
>> benefit has come from all the features that libbpf has just started
>> automatically supporting on load (BTF, etc), so users would have
>> benefited from automatic library updates had it *not* been vendored in.
>
> Not really. What you imply here is that we're living in a perfect
> world and that all distros follow suite and i) add libbpf dependency
> to their official iproute2 package, ii) upgrade iproute2 package along
> with new kernel releases and iii) upgrade libbpf along with it so that
> users are able to develop BPF programs against the feature set that
> the kernel offers (as intended). These are a lot of moving parts to
> get right, and as I pointed out earlier in the conversation, it took
> major distros 2 years to get their act together to officially include
> bpftool as a package - I'm not making this up, and this sort of pace
> is simply not sustainable. It's also not clear whether distros will
> get point iii) correct.

I totally get that you've been frustrated with the distro adoption and
packaging of BPF-related tools. And rightfully so. I just don't think
that the answer to this is to try to work around distros, but rather to
work with them to get things right.

I'm quite happy to take a shot at getting a cross-distro effort going in
this space; really, having well-supported BPF tooling ought to be in
everyone's interest!

-Toke

