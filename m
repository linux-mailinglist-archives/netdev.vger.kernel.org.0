Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE36624E97
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 00:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbiKJXwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 18:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiKJXwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 18:52:36 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DE810FF5
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 15:52:35 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id 11so2588252iou.0
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 15:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fqw6jViJ3ciqenxJsnS3Bs7/H5V0XPi+dXHXXGO5vWg=;
        b=VfnIaJYjWb4hYilFDKmYjvr8KVMkySzTkmisugm9WMRz2zjlebIMucyH8FShDU5GO4
         JD7X8/EVqS5UTUqE/UQPtH+YzhH6mzMxp1YkmEeDf0UQXlfGmkwe9u0Z+uyMbKUPHV2h
         P5bpjb/EtMyTKjvJY3Xv8w8SL14ZOX9JkISZD2q59gU+jq0183WhPTzBVPqDv/yMe2w5
         d5al3h7V55pQVE3JrVX6Vx+FhlrbZnkvtMGW961VLYbOtj6pf1CinRPl759KEHEuaoIo
         w1QNcbP6l5W7xt5YZ3f2QTHolzGIcfwpk9ZESfm+1UjduNRrbLkoyx+G4sVxXT5Sm2B8
         SF+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fqw6jViJ3ciqenxJsnS3Bs7/H5V0XPi+dXHXXGO5vWg=;
        b=kIEhDMqb0wLJ4UhuD58eUp8epRsciiLSPswJIZLg0CrPzFb6QdRlLg8Pe7gFqifTMA
         Zb7KC9zfO/YkiXii469A8UJq1R2Qtpq1xMIEbwMVs3gPCU++Ke6AxLshvx2DR3Oww+08
         gMulQZp5fbqU9ucir4WdmnYVuFldZoZG+etR/I/PbavIoyJKeqVpWG+q9M2KLJW+OV9N
         EZifBnMKdVCNrFkzDLuQ/0ZdOzQByQmGNrhSx8itBdFiNyyvYxhe5QP3t065+FGJHaCH
         P8dTBIJZ6HTPZRFJP9c1Zrj3VInXZiYyv1PMcYQwzvrefTYdtaTNNs6pHxyzamqADz3o
         TDAw==
X-Gm-Message-State: ACrzQf3ZevRlxUaVONh0GE4BSNOfarFQuNRWxi6gSYuE8iLZl47YiuUz
        Pu87oZy77l1KrzVh47tOoZMCiWoWqx/l3o5jrIiwzw==
X-Google-Smtp-Source: AMsMyM4YWKEy3238V27C3Pd+R311sQZMF4avZ30HOLUkB+bnMErl3IyMaOGz2bjVaEn+k9jYbrEOFCQtfeZ+33zzy9c=
X-Received: by 2002:a5e:c744:0:b0:6ce:46a:ec7b with SMTP id
 g4-20020a5ec744000000b006ce046aec7bmr3723391iop.79.1668124354396; Thu, 10 Nov
 2022 15:52:34 -0800 (PST)
MIME-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com> <20221104032532.1615099-7-sdf@google.com>
 <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev> <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
 <9a8fefe4-2fcb-95b7-cda0-06509feee78e@linux.dev> <6f57370f-7ec3-07dd-54df-04423cab6d1f@linux.dev>
 <87leokz8lq.fsf@toke.dk> <5a23b856-88a3-a57a-2191-b673f4160796@linux.dev>
 <CAKH8qBsfVOoR1MNAFx3uR9Syoc0APHABsf97kb8SGpK+T1qcew@mail.gmail.com>
 <32f81955-8296-6b9a-834a-5184c69d3aac@linux.dev> <CAKH8qBuLMZrFmmi77Qbt7DCd1w9FJwdeK5CnZTJqHYiWxwDx6w@mail.gmail.com>
 <87y1siyjf6.fsf@toke.dk> <CAKH8qBsfzYmQ9SZXhFetf_zQPNmE_L=_H_rRxJEwZzNbqtoKJA@mail.gmail.com>
 <87o7texv08.fsf@toke.dk>
In-Reply-To: <87o7texv08.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 10 Nov 2022 15:52:23 -0800
Message-ID: <CAKH8qBtjYV=tb28y6bvo3tGonzjvm2JLyis9AFPSMTuXsL3NPA@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp
 metadata into skb context
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
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

On Thu, Nov 10, 2022 at 3:14 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Skipping to the last bit:
>
> >> >> >    } else {
> >> >> >      use kfuncs
> >> >> >    }
> >> >> >
> >> >> > 5. Support the case where we keep program's metadata and kernel's
> >> >> > xdp_to_skb_metadata
> >> >> >    - skb_metadata_import_from_xdp() will "consume" it by mem-movi=
ng the
> >> >> > rest of the metadata over it and adjusting the headroom
> >> >>
> >> >> I was thinking the kernel's xdp_to_skb_metadata is always before th=
e program's
> >> >> metadata.  xdp prog should usually work in this order also: read/wr=
ite headers,
> >> >> write its own metadata, call bpf_xdp_metadata_export_to_skb(), and =
return
> >> >> XDP_PASS/XDP_REDIRECT.  When it is XDP_PASS, the kernel just needs =
to pop the
> >> >> xdp_to_skb_metadata and pass the remaining program's metadata to th=
e bpf-tc.
> >> >>
> >> >> For the kernel and xdp prog, I don't think it matters where the
> >> >> xdp_to_skb_metadata is.  However, the xdp->data_meta (program's met=
adata) has to
> >> >> be before xdp->data because of the current data_meta and data compa=
rison usage
> >> >> in the xdp prog.
> >> >>
> >> >> The order of the kernel's xdp_to_skb_metadata and the program's met=
adata
> >> >> probably only matters to the userspace AF_XDP.  However, I don't se=
e how AF_XDP
> >> >> supports the program's metadata now.  afaict, it can only work now =
if there is
> >> >> some sort of contract between them or the AF_XDP currently does not=
 use the
> >> >> program's metadata.  Either way, we can do the mem-moving only for =
AF_XDP and it
> >> >> should be a no op if there is no program's metadata?  This behavior=
 could also
> >> >> be configurable through setsockopt?
> >> >
> >> > Agreed on all of the above. For now it seems like the safest thing t=
o
> >> > do is to put xdp_to_skb_metadata last to allow af_xdp to properly
> >> > locate btf_id.
> >> > Let's see if Toke disagrees :-)
> >>
> >> As I replied to Martin, I'm not sure it's worth the complexity to
> >> logically split the SKB metadata from the program's own metadata (as
> >> opposed to just reusing the existing data_meta pointer)?
> >
> > I'd gladly keep my current requirement where it's either or, but not bo=
th :-)
> > We can relax it later if required?
>
> So the way I've been thinking about it is simply that the skb_metadata
> would live in the same place at the data_meta pointer (including
> adjusting that pointer to accommodate it), and just overriding the
> existing program metadata, if any exists. But looking at it now, I guess
> having the split makes it easier for a program to write its own custom
> metadata and still use the skb metadata. See below about the ordering.
>
> >> However, if we do, the layout that makes most sense to me is putting t=
he
> >> skb metadata before the program metadata, like:
> >>
> >> --------------
> >> | skb_metadata
> >> --------------
> >> | data_meta
> >> --------------
> >> | data
> >> --------------
> >>
> >> Not sure if that's what you meant? :)
> >
> > I was suggesting the other way around: |custom meta|skb_metadata|data|
> > (but, as Martin points out, consuming skb_metadata in the kernel
> > becomes messier)
> >
> > af_xdp can check whether skb_metdata is present by looking at data -
> > offsetof(struct skb_metadata, btf_id).
> > progs that know how to handle custom metadata, will look at data -
> > sizeof(skb_metadata)
> >
> > Otherwise, if it's the other way around, how do we find skb_metadata
> > in a redirected frame?
> > Let's say we have |skb_metadata|custom meta|data|, how does the final
> > program find skb_metadata?
> > All the progs have to agree on the sizeof(tc/custom meta), right?
>
> Erm, maybe I'm missing something here, but skb_metadata is fixed size,
> right? So if the "skb_metadata is present" flag is set, we know that the
> sizeof(skb_metadata) bytes before the data_meta pointer contains the
> metadata, and if the flag is not set, we know those bytes are not valid
> metadata.
>
> For AF_XDP, we'd need to transfer the flag as well, and it could apply
> the same logic (getting the size from the vmlinux BTF).
>
> By this logic, the BTF_ID should be the *first* entry of struct
> skb_metadata, since that will be the field AF_XDP programs can find
> right off the bat, no?

The problem with AF_XDP is that, IIUC, it doesn't have a data_meta
pointer in the userspace.

You get an rx descriptor where the address points to the 'data':
| 256 bytes headroom where metadata can go | data |

So you have (at most) 256 bytes of headroom, some of that might be the
metadata, but you really don't know where it starts. But you know it
definitely ends where the data begins.

So if we have the following, we can locate skb_metadata:
| 256-sizeof(skb_metadata) headroom | custom metadata | skb_metadata | data=
 |
data - sizeof(skb_metadata) will get you there

But if it's the other way around, the program has to know
sizeof(custom metadata) to locate skb_metadata:
| 256-sizeof(skb_metadata) headroom | skb_metadata | custom metadata | data=
 |

Am I missing something here?
