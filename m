Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D9762FC60
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 19:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242632AbiKRSTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 13:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242628AbiKRSTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 13:19:04 -0500
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F15C93728
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 10:18:57 -0800 (PST)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-13ae8117023so6846671fac.9
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 10:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fNnwGanczIlOEoVy4OEmoR/dSYWkyWUH5BAq5Ob+Kiw=;
        b=gJBrl3WZ97qVM3NI2LxOAIkcLzX+1KjC9HfQrZhs+yxO7EeHBYC0NOA8ndwqQIu9m9
         MzsuBWsITSp9sLNXnWnwi8naaGOehc9PKEomLULvmyYR0LVTjOgvfoBOwExTadH5bycM
         ED6yT1CxxGG5yT8Ihb9SmELwyOHU0P7PHFfQpSsH0rSJchYYT5rYPa/qoe7Eg6uKlboE
         z1T6s7Qdp/DJm3NBAt4hXF16NjB7CW8aAB2kXkctLW1w+x96U0STNaBaAvjnai3NxfiS
         gIIwlMz9ItIe8AN7iPP/Oa2bPTelXB6lihZ6sqBdThz6xN+JiEbNfe02mmxZjyp8+sBW
         f0dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fNnwGanczIlOEoVy4OEmoR/dSYWkyWUH5BAq5Ob+Kiw=;
        b=astsDPi5KQ3Y9kcWo364Ia+5qMtXvw5vR/0bvWixNiwISXqf6/JLPWofV17zJaa1Ej
         V+ndPcQgzY74QHus9sL501MirQ/W2AfO7uMe7EkLdQolD2UrgO9O08BS+5Dqh/H4gfLu
         H2vVp0qd7qH1H/kZCQ1oA8J18vFWKT6E+U2aRsEmfMqQ5/LH0+1jqH0MBcOhBUFnO+PB
         aFDuubFk0IMFc0cQ1jZVgh1NImWbqNMGcrS7HfZ4AqblBZ2V4yY11ITIqvJJ+G2zkR7X
         KTRVkLlVQHNjHpnQc7/FxPKz/Byy0zo7L9lU8Ep4EThlvXMTIFhgZEOXVndT5XVt4oNo
         x1bg==
X-Gm-Message-State: ANoB5plMoOMir+Ngkj/i/mU2xOO88rUXqhiD6QNjswTuDfG4jScjj4CA
        b5XBJjnUaaPT4FO9BHA7M5k9ofR4h+gAEijLHjJoOg==
X-Google-Smtp-Source: AA0mqf5Ar+kY1e8eGdghMnj0xIaR0R7Fv+/GgQjxHkmHfBRbquNZ+pOSQ6UBsy2yKGR7QhNo6JqfeLia+RddEIiT4II=
X-Received: by 2002:a05:6870:9d95:b0:13b:a163:ca6 with SMTP id
 pv21-20020a0568709d9500b0013ba1630ca6mr8143380oab.125.1668795535941; Fri, 18
 Nov 2022 10:18:55 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <20221115030210.3159213-7-sdf@google.com>
 <e26f75dd-f52f-a69b-6754-54e1fe044a42@redhat.com>
In-Reply-To: <e26f75dd-f52f-a69b-6754-54e1fe044a42@redhat.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 18 Nov 2022 10:18:44 -0800
Message-ID: <CAKH8qBv8UtHZrgSGzVn3ZJSfkdv1H3kXGbakp9rCFdOABL=3BQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 06/11] xdp: Carry over xdp metadata into skb context
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     bpf@vger.kernel.org, brouer@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Nov 18, 2022 at 6:05 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 15/11/2022 04.02, Stanislav Fomichev wrote:
> > Implement new bpf_xdp_metadata_export_to_skb kfunc which
> > prepares compatible xdp metadata for kernel consumption.
> > This kfunc should be called prior to bpf_redirect
> > or when XDP_PASS'ing the frame into the kernel (note, the drivers
> > have to be updated to enable consuming XDP_PASS'ed metadata).
> >
> > veth driver is amended to consume this metadata when converting to skb.
> >
> > Internally, XDP_FLAGS_HAS_SKB_METADATA flag is used to indicate
> > whether the frame has skb metadata. The metadata is currently
> > stored prior to xdp->data_meta. bpf_xdp_adjust_meta refuses
> > to work after a call to bpf_xdp_metadata_export_to_skb (can lift
> > this requirement later on if needed, we'd have to memmove
> > xdp_skb_metadata).
> >
>
> I think it is wrong to refuses using metadata area (bpf_xdp_adjust_meta)
> when the function bpf_xdp_metadata_export_to_skb() have been called.
> In my design they were suppose to co-exist, and BPF-prog was expected to
> access this directly themselves.
>
> With this current design, I think it is better to place the struct
> xdp_skb_metadata (maybe call it xdp_skb_hints) after xdp_frame (in the
> top of the frame).  This way we don't conflict with metadata and
> headroom use-cases.  Plus, verifier will keep BPF-prog from accessing
> this area directly (which seems to be one of the new design goals).
>
> By placing it after xdp_frame, I think it would be possible to let veth
> unroll functions seamlessly access this info for XDP_REDIRECT'ed
> xdp_frame's.
>
> WDYT?

Not everyone seems to be happy with exposing this xdp_skb_metadata via
uapi though :-(
So I'll drop this part in the v2 for now. But let's definitely keep
talking about the future approach.

Putting it after xdp_frame SGTM; with this we seem to avoid the need
to memmove it on adjust_{head,meta}.

But going back to the uapi part, what if we add separate kfunc
accessors for skb exported metadata?

To export:
bpf_xdp_metadata_export_rx_timestamp_to_skb(ctx, rx_timestamp)
bpf_xdp_metadata_export_rx_hash_to_skb(ctx, rx_hash)
// ^^ these prepare xdp_skb_metadata after xdp_frame, but not expose
it via uapi/af_xdp/etc

Then bpf_xdp_metadata_export_to_skb can be 'static inline' define in
the headers:

void bpf_xdp_metadata_export_to_skb(ctx)
{
  if (bpf_xdp_metadata_rx_timestamp_supported(ctx))
    bpf_xdp_metadata_export_rx_timestamp_to_skb(ctx,
bpf_xdp_metadata_rx_timestamp(ctx));
  if (bpf_xdp_metadata_rx_hash_supported(ctx))
    bpf_xdp_metadata_export_rx_hash_to_skb(ctx, bpf_xdp_metadata_rx_hash(ctx));
}

We can also do the accessors:
u64 bpf_xdp_metadata_skb_rx_timestamp(ctx)
u32 bpf_xdp_metadata_skb_rx_hash(ctx)

Hopefully we can unroll at least these, since they are not part of the
drivers, it should be easier to argue...

The only issue, it seems, is that if the final bpf program would like
to export this metadata to af_xdp, it has to manually adj_meta and use
bpf_xdp_metadata_skb_rx_xxx to prepare a custom layout. Not sure
whether performance would suffer with this extra copy; but we can at
least try and see..
