Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8942D492F78
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 21:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344127AbiARUiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 15:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349143AbiARUiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 15:38:05 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FCEC06173E;
        Tue, 18 Jan 2022 12:38:04 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id hv15so389616pjb.5;
        Tue, 18 Jan 2022 12:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IaxE0iuIwz0AoW+Z/URJBr05Hjb4c7XWxY/huAktPfI=;
        b=qvBs9BU5EbDqQiQS3uFQejrmHvTRfFhJ06l2BhoqqicYpbTRhYT42VB0cakGga+0P9
         DeakUd2h7rF6uCpzHDQSdyE3adLQmjFxcBAyJQ0A1zvPg2o1Mgm5pAb4QUFsDMjyOCmj
         xzuP9gGX7j4aLP7FZmyK7OqNKP1CwxbYkRbW3QYPQ0U1plOp/Doa/zoxdMjmrdGJW7M4
         aNXfrWfJiNdxvdX16yu452mcng0yJ/G33Y1cBx/MTsV3AO3/W9WXy0xI1QoJLiStwzyc
         eYjar0GPv8keOtF4jNr4gCIMPedzURST8RE1zfxjMVTvcE7/s7riVgAxDBEHJ+O7C27x
         HtoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IaxE0iuIwz0AoW+Z/URJBr05Hjb4c7XWxY/huAktPfI=;
        b=vsgXR4SJ6+JmzgOE/c8e6Ogd9fBeHop12hJmr2BVkZfFljPFV1ml6uRkoWzgQfBNXj
         elQ5v0iO8iWGzbfFVh9QHivXMidZFurImNlWnWq+RQJWe+kJ7bdPByTImNYQo6oUgIwD
         PNmHMePxmFfspjDGIjT4ltVfpZfCNYYlFVKqr7TRBLDUqWFXydxlfldr7xvZAoh2nbow
         mUJ6DilPU397GXHw+10gpPg9rfM57XfO4L0ZXhdoA4j+TDw++EztfugArAagWHcr5CBF
         /OhchUjXB2m3OJPUNRqvMNGdxa3+qQ7leVAwpxf3A5zCSLaCLGcRw5z5K2pfw2y4Uv40
         wDBA==
X-Gm-Message-State: AOAM532tEqnmXLsU/lhVfplAwtuXE2Q6be31a5HW3K/oCHNW3EekO7M7
        Z6yswy+v2CUppL6HMhhgn5dWLPyFECTwxmAY3yrwzCzmg3c=
X-Google-Smtp-Source: ABdhPJyaFWQV8oG8oMsKF88Mbi2Rn2xXV1/7hqYxz4vIVPrrU1kr8G9W4g1QcV1R833XYsGdGcnhPo5+a5jcTdOaLjQ=
X-Received: by 2002:a17:902:860c:b0:149:1017:25f0 with SMTP id
 f12-20020a170902860c00b00149101725f0mr28796314plo.116.1642538283919; Tue, 18
 Jan 2022 12:38:03 -0800 (PST)
MIME-Version: 1.0
References: <20220113000650.514270-1-quic_twear@quicinc.com>
 <CAADnVQLQ=JTiJm6FTWR-ZJ5PDOpGzoFOS4uFE+bNbr=Z06hnUQ@mail.gmail.com>
 <BYAPR02MB523848C2591E467973B5592EAA539@BYAPR02MB5238.namprd02.prod.outlook.com>
 <BYAPR02MB5238AEC23C7287A41C44C307AA549@BYAPR02MB5238.namprd02.prod.outlook.com>
 <CAADnVQJc=qgz47S1OuUBmX5Rb_opZUCADKqzqGnBruxtJONO7Q@mail.gmail.com> <CANP3RGfJ2G8P40hN2F=PGDYUc3pm84=SNppHp_J0V+YiDkLM_A@mail.gmail.com>
In-Reply-To: <CANP3RGfJ2G8P40hN2F=PGDYUc3pm84=SNppHp_J0V+YiDkLM_A@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 18 Jan 2022 12:37:52 -0800
Message-ID: <CAADnVQ+5YbkVOHqVGgusGYYYc0sB0uLKNJC+JKZu5Hs07=dgvw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 1/2] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     "Tyler Wear (QUIC)" <quic_twear@quicinc.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 1:18 PM Maciej =C5=BBenczykowski <maze@google.com> =
wrote:
>
> > > > > This is wrong.
> > > > > CGROUP_INET_EGRESS bpf prog cannot arbitrary change packet data.
>
> I agree with this sentiment, which is why the original proposal was
> simply to add a helper which is only capable of modifying the
> tos/tclass/dscp field, and not any arbitrary bytes.  (note: there
> already is such a helper to set the ECN congestion notification bits,
> so there's somewhat of a precedent)

True. bpf_skb_ecn_set_ce() is available to cg_skb progs.
An arbitrary tos rewriting helper would screw it up.

> > > > > The networking stack populated the IP header at that point.
> > > > > If the prog changes it to something else it will be confusing oth=
er
> > > > > layers of stack. neigh(L2) will be wrong, etc.
> > > > > We can still change certain things in the packet, but not arbitra=
ry bytes.
> > > > >
> > > > > We cannot change the DS field directly in the packet either.
>
> This part I won't agree with.  In most cases there is no DSCP based
> routing decision, in which case it seems perfectly reasonable to
> change the DSCP bits here.  Indeed last I checked (though this was a
> few years ago) the ipv4 tos routing code wasn't even capable of making
> sane decisions, because it looks at the bottom 4 bits of the TOS
> field, instead of the top 6 bits, ie. you can route on ECN bits, but
> you can't route on the full DSCP field.  Additionally afaik the ipv6
> tclass routing simply wasn't implemented.  However, I last had to deal
> with this probably half a decade ago, on even older kernels, so
> perhaps the situation has changed.
>
> Additionally DSCP bits may affect transmit queue selection (for
> something like wifi qos / traffic prioritization across multiple
> transmit queues with different air-time behaviours - which can use
> dscp), so ideally we need dscp to be set *before* the mq qdisc /
> dispatch.  I think this implies it needs to happen before tc (though
> again, I'm not too certain of the ordering here).

and that's where tc bpf progs are running. Right before qdiscs.
They can change any byte of the packet.
So I still don't see a use case of adding a specific
tos/tclass/dscp rewriting helper to cg_skb when tc bpf prog
are already capable.
