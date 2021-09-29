Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA5B41CC25
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 20:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346372AbhI2S4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 14:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346355AbhI2S4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 14:56:39 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6E1C06161C;
        Wed, 29 Sep 2021 11:54:57 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id lp15-20020a17090b4a8f00b0019f4059bd90so1263055pjb.3;
        Wed, 29 Sep 2021 11:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xyughrCx7mjtDwdPoFBC9OuYzX+dOvCWt5NXeNWYJBQ=;
        b=U7PPCQAoaeZpwkQYnKeAcdtpc/aHnkOe3t5ukAtm+yqdVe0HdfrJCKREk5gEmtaDHI
         07z9PIiZ5vGb4GaLCzC1CbJ4orhRffhwZ1c9vv3EmypeyKJDqHEfPsenJsZYkXrQo8os
         A/vNibxRuXlCOdihVzfNRcmVveq/8AHYVyyleE5OKkxtqeDukoxeYMrgBK20focDq9+f
         n8cGlmzWpZezNo4TnAuGqu3glzao2IytDasmeXqRhA0OJkJCiQRLJErx/cBQHy+XsFGg
         QycfkfQ4AegtcCTjPooYC/Xar3KBcXrnYO2ZG1g0ioX5fPlT+bxe0/G77ARkFmq88bJc
         LUpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xyughrCx7mjtDwdPoFBC9OuYzX+dOvCWt5NXeNWYJBQ=;
        b=Afs3H8mfkashct3XKVQntmaZ8fr+k07cK4XVcWD8LZQci0Hnc2CfCMu5iAGXbPh9b2
         u/jN4FHztVp9Jqr9VYW5QPSNliwlqMXrrrpPmNsBMTjc0arxdaqELFqWKzP8RRfB1yEd
         5v2a+zs2Haft2ohnhnwYxY3HQGEKfXapiWDmKKjCB8g4uYyqclqw4ca0JcX9qSQfYUjZ
         D7izBG63JU7amKBeUjxRF6G+l7MH7YE2VYGGRJsvxIoB4I6L7DcJ3ZWeFNw4U3Qo+FFK
         IdlLZpdbEHg6DKfoddmaVhDgfEDHsk4+7lj6shB5OBVhxMvxmDPw/cECuXYR4iXQ2znV
         NK1Q==
X-Gm-Message-State: AOAM532xmji4pCV/xKl9idOMikWLrIXtgzsN6bZU4Q52YvXaITjCdzKm
        AuGnbnudnDVk+OhmqrKeqoU9de+GgBUaW/stcc4=
X-Google-Smtp-Source: ABdhPJwHSrUkOsp98gdz800if+Yld6ekqWPo5gDkzvYfnI6kroI5IXb1eWEmXjOmWJUJiwGzF1ReiXtiLeLXJQaryzU=
X-Received: by 2002:a17:90a:19d2:: with SMTP id 18mr8164837pjj.122.1632941697340;
 Wed, 29 Sep 2021 11:54:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1631289870.git.lorenzo@kernel.org> <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACAyw9-8t8RpJgJUTd7u6bOLnJ1xQsgK7z37QrL9T1FUaJ7WNQ@mail.gmail.com>
 <87v92jinv7.fsf@toke.dk> <CACAyw99S9v658UyiKz3ad4kja7rDNfYv+9VOXZHCUOtam_C8Wg@mail.gmail.com>
In-Reply-To: <CACAyw99S9v658UyiKz3ad4kja7rDNfYv+9VOXZHCUOtam_C8Wg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 29 Sep 2021 11:54:46 -0700
Message-ID: <CAADnVQ+XXGUxzqMdbPMYf+t_ViDkqvGDdogrmv-wH-dckzujLw@mail.gmail.com>
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer support
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 5:38 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Wed, 29 Sept 2021 at 13:10, Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
> >
> > Lorenz Bauer <lmb@cloudflare.com> writes:
> >
> > > On Thu, 16 Sept 2021 at 18:47, Jakub Kicinski <kuba@kernel.org> wrote=
:
> > >>
> > >> Won't applications end up building something like skb_header_pointer=
()
> > >> based on bpf_xdp_adjust_data(), anyway? In which case why don't we
> > >> provide them what they need?
> > >>
> > >> say:
> > >>
> > >> void *xdp_mb_pointer(struct xdp_buff *xdp_md, u32 flags,
> > >>                      u32 offset, u32 len, void *stack_buf)
> > >>
> > >> flags and offset can be squashed into one u64 as needed. Helper retu=
rns
> > >> pointer to packet data, either real one or stack_buf. Verifier has t=
o
> > >> be taught that the return value is NULL or a pointer which is safe w=
ith
> > >> offsets up to @len.
> > >>
> > >> If the reason for access is write we'd also need:
> > >>
> > >> void *xdp_mb_pointer_flush(struct xdp_buff *xdp_md, u32 flags,
> > >>                            u32 offset, u32 len, void *stack_buf)

I'm missing something. Why do we need a separate flush() helper?
Can't we do:
char buf[64], *p;
p =3D xdp_mb_pointer(ctx, flags, off, len, buf);
read/write p[]
if (p =3D=3D buf)
    xdp_store_bytes(ctx, off, buf, len, flags);
