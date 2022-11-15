Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0EA62AEAA
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 23:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbiKOWyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 17:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiKOWyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 17:54:18 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFF72B271;
        Tue, 15 Nov 2022 14:54:16 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id f27so39968479eje.1;
        Tue, 15 Nov 2022 14:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tS7itbUVU0VT0dkwZPn1BAAjaVKk6+KaYVTgLf/SfTo=;
        b=DYqo9KKntKJjmEdFY8Pi0MZOMz1ZtOgJkp/EkvXbcw2fMSAox+swrc6SoOaTAEvCVW
         0W+/2g8gPfIeIbtkTk6liz+UZz100NuyHMaq1d/9c48i9GOHv5lDryGHj7fA/53AZ6wA
         N02KoGIJ8VNY5RL6sn+77iRa8+gzD1LoMlnEfvxOPsmDE01dviDTI8f5IARg37MJdaQg
         8Cd2oxwTz8BJaOeHTSeQmdRl4TxOdydRDb+/Z80Nefi2yC0tj7kSqgSUomoDjJSnwiDJ
         u+Gf55yXuhanUIt336yDfQAfhxdUYEUlhIVQkb1YKX0wcM9GCDJ7v00Huu9//cvvIMXe
         dpRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tS7itbUVU0VT0dkwZPn1BAAjaVKk6+KaYVTgLf/SfTo=;
        b=ZCpPo90M3DWyc5k3tmJ0oGyPN7qgyZlJvoBm5bqahFwOLO0lLD+rDvuxU/2I93oJu0
         S5NCOIgO9R/dyKVdn59BHew5mdPLGXxqb/WAcT0cKKcWlHReYJZ8YYMTG/kldC89vw8k
         VdhSgeJEctZrjUG+sVux/+dtbTgnNrBwZYg3C04KRxlsOm9BHx2FC1lj4IyXxL8rt3KU
         O603QjC/ngwW6a/cV+NIVBn1Ooz8sb3TFyJvahW6f4pPC0RvOntoUBLwAViyfefhXaEM
         319xzHSnNqZ15npn8OD4N9tN1RU5vjZqDPU13Du+SNa4/Cm/YwMf2jiEoqYRgMotd0iG
         8b3Q==
X-Gm-Message-State: ANoB5pnxFnmPwaCFlr+aHt0vveJTiuUn6a0th/S6tRr5nFYx7O1nvHZZ
        VJj8MeN6MUTT+trvHvotaD4PleyFp28PF9++N8s=
X-Google-Smtp-Source: AA0mqf6sPgQHEUxw4WJdC/SaR9y5RJiZLK4nfQ6acj7MHepRTEu8qIhCXM99URaFwS4AFQRfLUFZlkFvd3gnGQLsYKk=
X-Received: by 2002:a17:907:a701:b0:78d:9858:e538 with SMTP id
 vw1-20020a170907a70100b0078d9858e538mr16152395ejc.502.1668552854643; Tue, 15
 Nov 2022 14:54:14 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <87mt8si56i.fsf@toke.dk> <CAKH8qBszV6Ni_k8JYOxtAQ2j79qe5KVryAzDqtb1Ng8+TW=+7A@mail.gmail.com>
In-Reply-To: <CAKH8qBszV6Ni_k8JYOxtAQ2j79qe5KVryAzDqtb1Ng8+TW=+7A@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 15 Nov 2022 14:54:03 -0800
Message-ID: <CAADnVQKs=2zJ3=3BQp=OfCre3s6zTffjKRK+kbnwpQqvxF9ygA@mail.gmail.com>
Subject: Re: [xdp-hints] [PATCH bpf-next 00/11] xdp: hints via kfuncs
To:     Stanislav Fomichev <sdf@google.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 10:38 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Tue, Nov 15, 2022 at 7:54 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > Stanislav Fomichev <sdf@google.com> writes:
> >
> > > - drop __randomize_layout
> > >
> > >   Not sure it's possible to sanely expose it via UAPI. Because every
> > >   .o potentially gets its own randomized layout, test_progs
> > >   refuses to link.
> >
> > So this won't work if the struct is in a kernel-supplied UAPI header
> > (which would include the __randomize_layout tag). But if it's *not* in =
a
> > UAPI header it should still be included in a stable form (i.e., without
> > the randomize tag) in vmlinux.h, right? Which would be the point:
> > consumers would be forced to read it from there and do CO-RE on it...
>
> So you're suggesting something like the following in the uapi header?
>
> #ifndef __KERNEL__
> #define __randomize_layout
> #endif
>

1.
__randomize_layout in uapi header makes no sense.

2.
It's supported by gcc plugin and afaik that plugin is broken
vs debug info, so dwarf is broken, hence BTF is broken too,
and CO-RE doesn't work on kernels compiled with that gcc plugin.
