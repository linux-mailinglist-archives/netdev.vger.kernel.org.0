Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0EE9632B82
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 18:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiKURxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 12:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiKURxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 12:53:15 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7CB5D686
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:53:14 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id t15-20020a4a96cf000000b0049f7e18db0dso1895020ooi.10
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kKussxXA0xHyt0wd05Y/dCnd3wAULT9VK1/tbmvOlBw=;
        b=WubRDBgyvSTEuwPcgQvtgtufuH/ZZ5QWD6Ko/UFRlF4IdloRgvH2tkCMi81FEMSlbq
         pcCdNienCWyF9tbMH8yRKFv7bFYGptDZL6s16LqhUQtrpxX50MVuhGdgpC0B5avW+Q3/
         1+mdUFuAIc2T5waB4dOKNt2zKfI3WO58xXO2mo8UVgNUc7ty/q4GCH0CEu2LK8/1NY/g
         tVaJlFdAzMOiUci/C85ma/cqKerCQOZv4yyeZB0nCDwoWdnPehCTiZwnHQK+39LERgeA
         jGx8XB4i5AcWUGicKK1QQBDWE4NVjUKkNboPaKbD6+aavr2gqDg5YPdLIB6YW9AxGui/
         7wDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kKussxXA0xHyt0wd05Y/dCnd3wAULT9VK1/tbmvOlBw=;
        b=paVZGaMZGtCwfs0Z98CmoCP50jWAfSCEzcNXS4548NBNAu1pKc7ZyHfBpsOxHOA5c/
         rc+Mv6PXPLb1pHi6mF6cW/AXhuauvFzm3yqY4bKMdwg3HbSr3S7FPolY84dHez8K+Fxg
         EjtWSPMbLAwOyA243FJhA2FgZc0bfCsL2ib5RMo2r0iy/Lo+lZB2iZPyjTuFEhc8jpvn
         HcEdSSyiFz+RfTJmnCTns3WOJ8dA5eWgUSRyIE3Rvxu83YKJm0Dvf6g+CdTLnJeWEUk+
         v08TmuZ+KyrcUR/XzvYoHmufBm8t8vakDLykyI5X9AfUrjZHLI1xLvkIChDsJWIEbXFO
         q/9w==
X-Gm-Message-State: ANoB5pmXMsGB/TtSvxx1ZfrjsXmuYoeoFCn1o9lb3p16xj/aqfEZB48f
        fizZbw4SVH8CmO5nGo8SZqi41bCCfKXiBSiPQGbH4w==
X-Google-Smtp-Source: AA0mqf6Dso4yq3NE3jnJnIyQHo/5Q4OZ9sa4+uB1Wbzr+CCn8rtqWNP8mC0880p90fdR4ha5dS0p6hz4zM4whEORsKU=
X-Received: by 2002:a05:6820:1524:b0:49f:b32b:b0af with SMTP id
 ay36-20020a056820152400b0049fb32bb0afmr9016090oob.16.1669053193448; Mon, 21
 Nov 2022 09:53:13 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <20221115030210.3159213-7-sdf@google.com>
 <e26f75dd-f52f-a69b-6754-54e1fe044a42@redhat.com> <CAKH8qBv8UtHZrgSGzVn3ZJSfkdv1H3kXGbakp9rCFdOABL=3BQ@mail.gmail.com>
 <871qpzxh0n.fsf@toke.dk>
In-Reply-To: <871qpzxh0n.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 21 Nov 2022 09:53:02 -0800
Message-ID: <CAKH8qBtDZo8Mmp=o_fomz97cXNGY6NgOOW8YbJCXx_+_dVf7uw@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 06/11] xdp: Carry over xdp
 metadata into skb context
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>, bpf@vger.kernel.org,
        brouer@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 19, 2022 at 4:31 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > On Fri, Nov 18, 2022 at 6:05 AM Jesper Dangaard Brouer
> > <jbrouer@redhat.com> wrote:
> >>
> >>
> >> On 15/11/2022 04.02, Stanislav Fomichev wrote:
> >> > Implement new bpf_xdp_metadata_export_to_skb kfunc which
> >> > prepares compatible xdp metadata for kernel consumption.
> >> > This kfunc should be called prior to bpf_redirect
> >> > or when XDP_PASS'ing the frame into the kernel (note, the drivers
> >> > have to be updated to enable consuming XDP_PASS'ed metadata).
> >> >
> >> > veth driver is amended to consume this metadata when converting to s=
kb.
> >> >
> >> > Internally, XDP_FLAGS_HAS_SKB_METADATA flag is used to indicate
> >> > whether the frame has skb metadata. The metadata is currently
> >> > stored prior to xdp->data_meta. bpf_xdp_adjust_meta refuses
> >> > to work after a call to bpf_xdp_metadata_export_to_skb (can lift
> >> > this requirement later on if needed, we'd have to memmove
> >> > xdp_skb_metadata).
> >> >
> >>
> >> I think it is wrong to refuses using metadata area (bpf_xdp_adjust_met=
a)
> >> when the function bpf_xdp_metadata_export_to_skb() have been called.
> >> In my design they were suppose to co-exist, and BPF-prog was expected =
to
> >> access this directly themselves.
> >>
> >> With this current design, I think it is better to place the struct
> >> xdp_skb_metadata (maybe call it xdp_skb_hints) after xdp_frame (in the
> >> top of the frame).  This way we don't conflict with metadata and
> >> headroom use-cases.  Plus, verifier will keep BPF-prog from accessing
> >> this area directly (which seems to be one of the new design goals).
> >>
> >> By placing it after xdp_frame, I think it would be possible to let vet=
h
> >> unroll functions seamlessly access this info for XDP_REDIRECT'ed
> >> xdp_frame's.
> >>
> >> WDYT?
> >
> > Not everyone seems to be happy with exposing this xdp_skb_metadata via
> > uapi though :-(
> > So I'll drop this part in the v2 for now. But let's definitely keep
> > talking about the future approach.
>
> Jakub was objecting to putting it in the UAPI header, but didn't we
> already agree that this wasn't necessary?
>
> I.e., if we just define
>
> struct xdp_skb_metadata *bpf_xdp_metadata_export_to_skb()
>
> as a kfunc, the xdp_skb_metadata struct won't appear in any UAPI headers
> and will only be accessible via BTF? And we can put the actual data
> wherever we choose, since that bit is nicely hidden behind the kfunc,
> while the returned pointer still allows programs to access it.
>
> We could even make that kfunc smart enough that it checks if the field
> is already populated and just return the pointer to the existing data
> instead of re-populating it int his case (with a flag to override,
> maybe?).

Even if we only expose it via btf, I think the fact that we still
expose a somewhat fixed layout is the problem?
I'm not sure the fact that we're not technically putting in the uapi
header is the issue here, but maybe I'm wrong?
Jakub?

> > Putting it after xdp_frame SGTM; with this we seem to avoid the need
> > to memmove it on adjust_{head,meta}.
> >
> > But going back to the uapi part, what if we add separate kfunc
> > accessors for skb exported metadata?
> >
> > To export:
> > bpf_xdp_metadata_export_rx_timestamp_to_skb(ctx, rx_timestamp)
> > bpf_xdp_metadata_export_rx_hash_to_skb(ctx, rx_hash)
> > // ^^ these prepare xdp_skb_metadata after xdp_frame, but not expose
> > it via uapi/af_xdp/etc
> >
> > Then bpf_xdp_metadata_export_to_skb can be 'static inline' define in
> > the headers:
> >
> > void bpf_xdp_metadata_export_to_skb(ctx)
> > {
> >   if (bpf_xdp_metadata_rx_timestamp_supported(ctx))
> >     bpf_xdp_metadata_export_rx_timestamp_to_skb(ctx,
> > bpf_xdp_metadata_rx_timestamp(ctx));
> >   if (bpf_xdp_metadata_rx_hash_supported(ctx))
> >     bpf_xdp_metadata_export_rx_hash_to_skb(ctx, bpf_xdp_metadata_rx_has=
h(ctx));
> > }
>
> The problem with this is that the BPF programs then have to keep up with
> the kernel. I.e., if the kernel later adds support for a new field that
> is used in the SKB, old XDP programs won't be populating it, which seems
> suboptimal. I think rather the kernel should be in control of the SKB
> metadata, and just allow XDP to consume it (and change individual fields
> as needed).

Good point. Although doesn't sound like a huge drawback to me? If that
bpf_xdp_metadata_export_to_skb is a part of libbpf/libxdp, the new
fields will get populated after a library update..

> > The only issue, it seems, is that if the final bpf program would like
> > to export this metadata to af_xdp, it has to manually adj_meta and use
> > bpf_xdp_metadata_skb_rx_xxx to prepare a custom layout. Not sure
> > whether performance would suffer with this extra copy; but we can at
> > least try and see..
>
> If we write the metadata after the packet data, that could still be
> transferred to AF_XDP, couldn't it? Userspace would just have to know
> how to find and read it, like it would  if it's before the metadata.

Right, but here we again bump into the fact that we need to somehow
communicate that layout to the userspace (via btf ids) which doesn't
make everybody excited :-)
