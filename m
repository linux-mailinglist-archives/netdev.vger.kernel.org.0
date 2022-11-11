Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D22624F2F
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 01:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbiKKA5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 19:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiKKA5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 19:57:31 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BCE61751
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 16:57:30 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id e19so1904360ili.4
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 16:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ohsVTY0+AppaPSGsrQcQNw4gk9Ng3zPq/bVf3xQ23IA=;
        b=mFhIWCfCA8oZYsYoC3Oz8pFx4GEi9hMyKbkGA4OdTlyXMYckxxkpRfntg9fRMuf6+0
         nMoXWSRvLQF1KQkPDGYmUv7z0arcBDJohM4WHrm43KLB0Ho+9fn/llT+zPWM+zNGMDi6
         T3NbvfWKlt406xNqwRJbV+d0Sojf9dTFwHx8YvRIG9eJ821xdieITBz+iS0ZPwTDY6YI
         X2nyUugU4bbs0GvrXivuXODuUlNkq0xmmHVKz8rvpDZWjmeL8EkYcTn50gFWdur2gqAM
         WbWF0wg5dX3vBwi7KGabPb84XY40Fo7l/Na67mH0MesQN1ineEzvfqqFWvgcoT1nsHci
         AecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ohsVTY0+AppaPSGsrQcQNw4gk9Ng3zPq/bVf3xQ23IA=;
        b=2yumiXQntlo4urzrqXtHmgBW5uf2hPcdDPDvokm6WuAFib1aRD1x9yhl8c0qF2mpA2
         sYX8N//6tlJ+jCIHtObs8Vk74GnQJ5xrzmfohkgNezcTXrYuiE/QNW3It/AgPAi7Ef2H
         IQ+Q82VlfQH8Ft5b5/U9OpZTg77nPZz1ylWf6NZgJreOENDnyi8mokojeSpqBSIajy0/
         L6uvFnM3WbLFXXYvrLE1buyrk+UTKGwq1ZvdxP8KvO4yVPfJ30uWOFa1+ludTNkZ5I4q
         vlg9/POLwKcusvexPQyqMhdnWkYM+k2gJDkM8VGQk4EgWIh7doD+OX5PBQJ708wwaZuU
         o8TA==
X-Gm-Message-State: ACrzQf1aUjJBUG/ETz979LPYwpEQuAjCJLQCNqnFtalC4FPd+Tl4hfGy
        jg07Nc2Hn5Ni75Zv9Js46NKdhrVx1SnrEu2x8zKRXA==
X-Google-Smtp-Source: AMsMyM6keRn4ZVXwqjSjPvOBE/W+hlCk6X00Dsu/mfa7jQfH/+8EVKeJzHvSEtFUVPoTmt5+autkcz0xLl3KDcBFrBQ=
X-Received: by 2002:a05:6e02:925:b0:300:d39b:4d03 with SMTP id
 o5-20020a056e02092500b00300d39b4d03mr3905825ilt.137.1668128249545; Thu, 10
 Nov 2022 16:57:29 -0800 (PST)
MIME-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com> <20221104032532.1615099-7-sdf@google.com>
 <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev> <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
 <9a8fefe4-2fcb-95b7-cda0-06509feee78e@linux.dev> <6f57370f-7ec3-07dd-54df-04423cab6d1f@linux.dev>
 <87leokz8lq.fsf@toke.dk> <5a23b856-88a3-a57a-2191-b673f4160796@linux.dev>
 <CAKH8qBsfVOoR1MNAFx3uR9Syoc0APHABsf97kb8SGpK+T1qcew@mail.gmail.com>
 <32f81955-8296-6b9a-834a-5184c69d3aac@linux.dev> <CAKH8qBuLMZrFmmi77Qbt7DCd1w9FJwdeK5CnZTJqHYiWxwDx6w@mail.gmail.com>
 <87y1siyjf6.fsf@toke.dk> <CAKH8qBsfzYmQ9SZXhFetf_zQPNmE_L=_H_rRxJEwZzNbqtoKJA@mail.gmail.com>
 <87o7texv08.fsf@toke.dk> <CAKH8qBtjYV=tb28y6bvo3tGonzjvm2JLyis9AFPSMTuXsL3NPA@mail.gmail.com>
 <d8d23d7b-c997-ae8d-b4ee-a1182ff657f5@linux.dev>
In-Reply-To: <d8d23d7b-c997-ae8d-b4ee-a1182ff657f5@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 10 Nov 2022 16:57:18 -0800
Message-ID: <CAKH8qBvoR36wJShRE5zbgif2L9hweM6vSPVEHugY_ctOQgvpdQ@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp
 metadata into skb context
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 4:33 PM Martin KaFai Lau <martin.lau@linux.dev> wro=
te:
>
> On 11/10/22 3:52 PM, Stanislav Fomichev wrote:
> > On Thu, Nov 10, 2022 at 3:14 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Skipping to the last bit:
> >>
> >>>>>>>     } else {
> >>>>>>>       use kfuncs
> >>>>>>>     }
> >>>>>>>
> >>>>>>> 5. Support the case where we keep program's metadata and kernel's
> >>>>>>> xdp_to_skb_metadata
> >>>>>>>     - skb_metadata_import_from_xdp() will "consume" it by mem-mov=
ing the
> >>>>>>> rest of the metadata over it and adjusting the headroom
> >>>>>>
> >>>>>> I was thinking the kernel's xdp_to_skb_metadata is always before t=
he program's
> >>>>>> metadata.  xdp prog should usually work in this order also: read/w=
rite headers,
> >>>>>> write its own metadata, call bpf_xdp_metadata_export_to_skb(), and=
 return
> >>>>>> XDP_PASS/XDP_REDIRECT.  When it is XDP_PASS, the kernel just needs=
 to pop the
> >>>>>> xdp_to_skb_metadata and pass the remaining program's metadata to t=
he bpf-tc.
> >>>>>>
> >>>>>> For the kernel and xdp prog, I don't think it matters where the
> >>>>>> xdp_to_skb_metadata is.  However, the xdp->data_meta (program's me=
tadata) has to
> >>>>>> be before xdp->data because of the current data_meta and data comp=
arison usage
> >>>>>> in the xdp prog.
> >>>>>>
> >>>>>> The order of the kernel's xdp_to_skb_metadata and the program's me=
tadata
> >>>>>> probably only matters to the userspace AF_XDP.  However, I don't s=
ee how AF_XDP
> >>>>>> supports the program's metadata now.  afaict, it can only work now=
 if there is
> >>>>>> some sort of contract between them or the AF_XDP currently does no=
t use the
> >>>>>> program's metadata.  Either way, we can do the mem-moving only for=
 AF_XDP and it
> >>>>>> should be a no op if there is no program's metadata?  This behavio=
r could also
> >>>>>> be configurable through setsockopt?
> >>>>>
> >>>>> Agreed on all of the above. For now it seems like the safest thing =
to
> >>>>> do is to put xdp_to_skb_metadata last to allow af_xdp to properly
> >>>>> locate btf_id.
> >>>>> Let's see if Toke disagrees :-)
> >>>>
> >>>> As I replied to Martin, I'm not sure it's worth the complexity to
> >>>> logically split the SKB metadata from the program's own metadata (as
> >>>> opposed to just reusing the existing data_meta pointer)?
> >>>
> >>> I'd gladly keep my current requirement where it's either or, but not =
both :-)
> >>> We can relax it later if required?
> >>
> >> So the way I've been thinking about it is simply that the skb_metadata
> >> would live in the same place at the data_meta pointer (including
> >> adjusting that pointer to accommodate it), and just overriding the
> >> existing program metadata, if any exists. But looking at it now, I gue=
ss
> >> having the split makes it easier for a program to write its own custom
> >> metadata and still use the skb metadata. See below about the ordering.
> >>
> >>>> However, if we do, the layout that makes most sense to me is putting=
 the
> >>>> skb metadata before the program metadata, like:
> >>>>
> >>>> --------------
> >>>> | skb_metadata
> >>>> --------------
> >>>> | data_meta
> >>>> --------------
> >>>> | data
> >>>> --------------
> >>>>
>
> Yeah, for the kernel and xdp prog (ie not AF_XDP), I meant this:
>
> | skb_metadata | custom metadata | data |
>
> >>>> Not sure if that's what you meant? :)
> >>>
> >>> I was suggesting the other way around: |custom meta|skb_metadata|data=
|
> >>> (but, as Martin points out, consuming skb_metadata in the kernel
> >>> becomes messier)
> >>>
> >>> af_xdp can check whether skb_metdata is present by looking at data -
> >>> offsetof(struct skb_metadata, btf_id).
> >>> progs that know how to handle custom metadata, will look at data -
> >>> sizeof(skb_metadata)
> >>>
> >>> Otherwise, if it's the other way around, how do we find skb_metadata
> >>> in a redirected frame?
> >>> Let's say we have |skb_metadata|custom meta|data|, how does the final
> >>> program find skb_metadata?
> >>> All the progs have to agree on the sizeof(tc/custom meta), right?
> >>
> >> Erm, maybe I'm missing something here, but skb_metadata is fixed size,
> >> right? So if the "skb_metadata is present" flag is set, we know that t=
he
> >> sizeof(skb_metadata) bytes before the data_meta pointer contains the
> >> metadata, and if the flag is not set, we know those bytes are not vali=
d
> >> metadata.
>
> right, so to get to the skb_metadata, it will be
> data_meta -=3D sizeof(skb_metadata);  /* probably need alignment */
>
> >>
> >> For AF_XDP, we'd need to transfer the flag as well, and it could apply
> >> the same logic (getting the size from the vmlinux BTF).
> >>
> >> By this logic, the BTF_ID should be the *first* entry of struct
> >> skb_metadata, since that will be the field AF_XDP programs can find
> >> right off the bat, no? >
> > The problem with AF_XDP is that, IIUC, it doesn't have a data_meta
> > pointer in the userspace.
>
> Yep. It is my understanding also.  Missing data_meta pointer in the AF_XD=
P
> rx_desc is a potential problem.  Having BTF_ID or not won't help.
>
> >
> > You get an rx descriptor where the address points to the 'data':
> > | 256 bytes headroom where metadata can go | data |
> >
> > So you have (at most) 256 bytes of headroom, some of that might be the
> > metadata, but you really don't know where it starts. But you know it
> > definitely ends where the data begins.
> >
> > So if we have the following, we can locate skb_metadata:
> > | 256-sizeof(skb_metadata) headroom | custom metadata | skb_metadata | =
data |
> > data - sizeof(skb_metadata) will get you there
> >
> > But if it's the other way around, the program has to know
> > sizeof(custom metadata) to locate skb_metadata:
> > | 256-sizeof(skb_metadata) headroom | skb_metadata | custom metadata | =
data |
>
> Right, this won't work if the AF_XDP user does not know how big the custo=
m
> metadata is.  The kernel then needs to swap the "skb_metadata" and "custo=
m
> metadata" + setting a flag in the AF_XDP rx_desc->options to make it look=
s like
> this:
> | custom metadata | skb_metadata | data |
>
> However, since data_meta is missing from the rx_desc, may be we can safel=
y
> assume the AF_XDP user always knows the size of the custom metadata or th=
ere is
> usually no "custom metadata" and no swap is needed?

If we can assume they can share that info, can they also share more
info on what kind of metadata they would prefer to get?
If they can agree on the size, maybe they also can agree on the flows
that need skb_metdata vs the flows that need a custom one?

Seems like we can start with supporting either one, but not both and
extend in the future once we have more understanding on whether it's
actually needed or not?

bpf_xdp_metadata_export_to_skb: adjust data meta, add uses-skb-metadata fla=
g
bpf_xdp_adjust_meta: unconditionally reset uses-skb-metadata flag
