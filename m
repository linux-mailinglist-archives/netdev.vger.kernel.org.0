Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F198B624862
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiKJRa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiKJRa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:30:27 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B171BF5AC;
        Thu, 10 Nov 2022 09:30:26 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id v28so2749228pfi.12;
        Thu, 10 Nov 2022 09:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bu35ayYE/oHboUTxifvNQOjweAO5e58LGfKsLXtIQqo=;
        b=K3SfXTHOAmn5hMqzEe6sEMxO+sa+VO0H206bXLWkyZ5RGXkVRqvb2XCa3E5jlSPGEW
         o3dZuKXYEDE32KoJFz7m/wFkM6Ga9RMromonynjF5pNqgn7vGOs2lZjAd6osSchiCT9j
         OFA8eOOxwzPRt5oRqLBrk+PsrdkrkXC3u+0k4qj2/JOzzfcEDBS27tcUqsb5BWiTJb6w
         2TJjQ9Cgr4VbR5h8BmMThIZU7Jj9Rjxp2JT/bq6w5pTtv8yqAxeKpKzl/UYIt1Y8n75S
         uypE3R7h512IW5M/Q7QQdvJNatnuLtI+NgBfyONd8XYcEkufhCXidEO7vhbAopUTl+rm
         I/vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Bu35ayYE/oHboUTxifvNQOjweAO5e58LGfKsLXtIQqo=;
        b=0+vHEzbFy0I+NHhx42mLw31iudHANQ26AQzCBaW3lwGGhfTEo6b6nOwMNUDumQ3f5p
         xVaWQTBd2Xnw1me0CSjIUCEW7OB51SIJBd3YY+Q/NKkUdH0Ih1bhUwn4armVr90kuv7S
         BGKd2kcXITL0EMtFug5MGmz6pyqke7VE4gOHoTkDBhhECKXyY75MY22zodjWtQQIhuDT
         CGg8LHAktBpJj42Kc/vsmlkaVfPtlm9PiYnd7C2zs9t5b0LxrspBFeBhKCgpsMWpuOcd
         GoyEys3LSyl++Xlmjpy+K5UViOi9BdPiogA8F/TSQkXyPZonhYAj0lvNcrsUHRFtmNJT
         kZKg==
X-Gm-Message-State: ACrzQf1V034e1hPGRN7zcg7Kn2vjbipxyt+7aSOlpUB2NGztBhKMPFxb
        wxMLBu2y4e5FA3qNH25bl98=
X-Google-Smtp-Source: AMsMyM4/9G/c9cci4E8Mv9IUtooeL/Obt8DmQtayYBxhgWsmcMCoEkq8s6nQMzJmEqN1UCuzizHYkQ==
X-Received: by 2002:a65:6e4d:0:b0:46f:53cb:65b5 with SMTP id be13-20020a656e4d000000b0046f53cb65b5mr2809442pgb.507.1668101426090;
        Thu, 10 Nov 2022 09:30:26 -0800 (PST)
Received: from localhost ([98.97.42.169])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902e94500b00176d218889esm11494681pll.228.2022.11.10.09.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 09:30:25 -0800 (PST)
Date:   Thu, 10 Nov 2022 09:30:23 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <636d352fdf18e_145693208e5@john.notmuch>
In-Reply-To: <87v8nmyj5r.fsf@toke.dk>
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-7-sdf@google.com>
 <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev>
 <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
 <9a8fefe4-2fcb-95b7-cda0-06509feee78e@linux.dev>
 <6f57370f-7ec3-07dd-54df-04423cab6d1f@linux.dev>
 <87leokz8lq.fsf@toke.dk>
 <636c533231572_13c9f42087c@john.notmuch>
 <87v8nmyj5r.fsf@toke.dk>
Subject: Re: [xdp-hints] Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp
 metadata into skb context
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
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

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> John Fastabend <john.fastabend@gmail.com> writes:
> =

> > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> Snipping a bit of context to reply to this bit:
> >> =

> >> >>>> Can the xdp prog still change the metadata through xdp->data_me=
ta? tbh, I am not
> >> >>>> sure it is solid enough by asking the xdp prog not to use the s=
ame random number
> >> >>>> in its own metadata + not to change the metadata through xdp->d=
ata_meta after
> >> >>>> calling bpf_xdp_metadata_export_to_skb().
> >> >>>
> >> >>> What do you think the usecase here might be? Or are you suggesti=
ng we
> >> >>> reject further access to data_meta after
> >> >>> bpf_xdp_metadata_export_to_skb somehow?
> >> >>>
> >> >>> If we want to let the programs override some of this
> >> >>> bpf_xdp_metadata_export_to_skb() metadata, it feels like we can =
add
> >> >>> more kfuncs instead of exposing the layout?
> >> >>>
> >> >>> bpf_xdp_metadata_export_to_skb(ctx);
> >> >>> bpf_xdp_metadata_export_skb_hash(ctx, 1234);
> >> =

> >
> > Hi Toke,
> >
> > Trying not to bifurcate your thread. Can I start a new one here to
> > elaborate on these use cases. I'm still a bit lost on any use case
> > for this that makes sense to actually deploy on a network.
> >
> >> There are several use cases for needing to access the metadata after=

> >> calling bpf_xdp_metdata_export_to_skb():
> >> =

> >> - Accessing the metadata after redirect (in a cpumap or devmap progr=
am,
> >>   or on a veth device)
> >
> > I think for devmap there are still lots of opens how/where the skb
> > is even built.
> =

> For veth it's pretty clear; i.e., when redirecting into containers.

Ah but I think XDP on veth is a bit questionable in general. The use
case is NFV I guess but its not how I would build out NFV. I've never
seen it actually deployed other than in CI. Anyways not necessary to
drop into that debate here. It exists so OK.

> =

> > For cpumap I'm a bit unsure what the use case is. For ice, mlx and
> > such you should use the hardware RSS if performance is top of mind.
> =

> Hardware RSS works fine if your hardware supports the hashing you want;=

> many do not. As an example, Jesper wrote this application that uses
> cpumap to divide out ISP customer traffic among different CPUs (solving=

> an HTB scaling problem):
> =

> https://github.com/xdp-project/xdp-cpumap-tc

I'm going to argue hw should be able to do this still and we
should fix the hw but maybe not easily doable without convincing
hardware folks to talk to us.

Also not obvious tto me how linked code works without more studying, its
ingress HTB? So you would push the rxhash and timestamp into cpumap and
then build the skb here with the correct skb->timestamp?

OK even if I can't exactly find the use case for cpumap if I had
a use case I can see how passing metadata through is useful.

> =

> > And then for specific devices on cpumap (maybe realtime or ptp
> > things?) could we just throw it through the xdp_frame?
> =

> Not sure what you mean here? Throw what through the xdp_frame?

Doesn't matter reread patches and figured it out I was slightly
confused.

> =

> >> - Transferring the packet+metadata to AF_XDP
> >
> > In this case we have the metadata and AF_XDP program and XDP program
> > simply need to agree on metadata format. No need to have some magic
> > numbers and driver specific kfuncs.
> =

> See my other reply to Martin: Yeah, for AF_XDP users that write their
> own kernel XDP programs, they can just do whatever they want. But many
> users just rely on the default program in libxdp, so having a standard
> format to include with that is useful.
> =


I don't think your AF_XDP program is any different than other AF_XDP
programs. Your lib can create a standard format if it wants but
kernel doesn't need to enforce it anyway.


> >> - Returning XDP_PASS, but accessing some of the metadata first (whet=
her
> >>   to read or change it)
> >> =

> >
> > I don't get this case? XDP_PASS should go to stack normally through
> > drivers build_skb routines. These will populate timestamp normally.
> > My guess is simply descriptor->skb load/store is cheaper than carryin=
g
> > around this metadata and doing the call in BPF side. Anyways you
> > just built an entire skb and hit the stack I don't think you will
> > notice this noise in any benchmark.
> =

> If you modify the packet before calling XDP_PASS you may want to update=

> the metadata as well (for instance the RX hash, or in the future the
> metadata could also carry transport header offsets).

OK. So when you modify the pkt fixing up the rxhash makes sense. Thanks
for the response I can see the argument.

Thanks,
John=
