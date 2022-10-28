Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8370F611A68
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 20:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiJ1Sq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 14:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJ1Sq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 14:46:27 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B34424473E
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 11:46:26 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id y6so2353627iof.9
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 11:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Hxm7sQTpDKl9UY4520J3/vp5jchfI3eX96wGKNMDOQs=;
        b=B4WcZf/oRIkjQLeSHBKGFOty1f5Cfg44oU823gpumf4Yh08/EL8sbaWf1wWbl4DP4k
         NZq7paMR231hbzbVZi2yMIxsMCH1oJSH42C7n26mGWX1Ggv3Ta6ZhAdzownsUnBDmutE
         EIiiKDgqEchlSBPNrhSs+fGlc16Q+TBKot8du6YYAfd9YzjuCuR/XmKviA3jHebBNBIC
         Yj0bCDYZeVNN9OcCsPTgsjO8Tt1R1WGdla2wTLQ2E53V297AUCatAlC0B51hRUq01H/+
         h09hG8zI/MfH6BRknnTx6iEh/17dQxcU+/UT1dL1ziXYnjPR4kTzJsY3nCDJQwpOkQVY
         mMQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hxm7sQTpDKl9UY4520J3/vp5jchfI3eX96wGKNMDOQs=;
        b=MHTEvgxqylbGqDoMB5jn6bQ0pSO+G/QmVVMV+dhLZxyt3jbPe5RvEY21Le4OxanDHt
         QsLy7k1IC6H2VLlGAtp5YBi+RBMcjMyfvOkobOoLMuKaC2RyWLcBwy16lbx7/wbfhGzw
         7hCSnNpLoYCbJMeHK1brnzpJ0Sdymt3IIbOv5uDG9rQarInM/QPw4AaniAmc2H8LsoK0
         NJkhNSQ+eNCfz/3UFrbCAgLADnLqEby+WheJHbwB9y+lLQ0XiyR8WSN0/WQFL46maRbr
         qO0f7ufqz0qCcebxK+1Rvnhf6AqOrVDui2/jTOiuThtDa8pXNBzCYET86JmsZRxQUWkz
         /A8A==
X-Gm-Message-State: ACrzQf0NYp9XDB5WSuVbIyk6hshvCntqLuq8odcPcT3UT4JnWbEgkYUz
        jjc7vYiFb0KWRP8rtljkRnqrrzfxKUcEaGi9cKIAFw==
X-Google-Smtp-Source: AMsMyM4Om9g03TRpDLXEtZ2L2StTMInxaehwT2GQT1L7utLfww8N9Q+e2e0zkjXrZxj6cPmzj+qsf3EGCKeKa0kA4pg=
X-Received: by 2002:a05:6638:4519:b0:372:c7f1:425b with SMTP id
 bs25-20020a056638451900b00372c7f1425bmr457604jab.106.1666982785511; Fri, 28
 Oct 2022 11:46:25 -0700 (PDT)
MIME-Version: 1.0
References: <20221027200019.4106375-1-sdf@google.com> <20221027200019.4106375-6-sdf@google.com>
 <31f3aa18-d368-9738-8bb5-857cd5f2c5bf@linux.dev> <1885bc0c-1929-53ba-b6f8-ace2393a14df@redhat.com>
In-Reply-To: <1885bc0c-1929-53ba-b6f8-ace2393a14df@redhat.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 28 Oct 2022 11:46:14 -0700
Message-ID: <CAKH8qBt3hNUO0H_C7wYiwBEObGEFPXJCCLfkA=GuGC1CSpn55A@mail.gmail.com>
Subject: Re: [RFC bpf-next 5/5] selftests/bpf: Test rx_timestamp metadata in xskxceiver
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>, brouer@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Oct 28, 2022 at 3:37 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 28/10/2022 08.22, Martin KaFai Lau wrote:
> > On 10/27/22 1:00 PM, Stanislav Fomichev wrote:
> >> Example on how the metadata is prepared from the BPF context
> >> and consumed by AF_XDP:
> >>
> >> - bpf_xdp_metadata_have_rx_timestamp to test whether it's supported;
> >>    if not, I'm assuming verifier will remove this "if (0)" branch
> >> - bpf_xdp_metadata_rx_timestamp returns a _copy_ of metadata;
> >>    the program has to bpf_xdp_adjust_meta+memcpy it;
> >>    maybe returning a pointer is better?
> >> - af_xdp consumer grabs it from data-<expected_metadata_offset> and
> >>    makes sure timestamp is not empty
> >> - when loading the program, we pass BPF_F_XDP_HAS_METADATA+prog_ifindex
> >>
> >> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> >> Cc: Jakub Kicinski <kuba@kernel.org>
> >> Cc: Willem de Bruijn <willemb@google.com>
> >> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> >> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> >> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> >> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> >> Cc: Maryam Tahhan <mtahhan@redhat.com>
> >> Cc: xdp-hints@xdp-project.net
> >> Cc: netdev@vger.kernel.org
> >> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >> ---
> >>   .../testing/selftests/bpf/progs/xskxceiver.c  | 22 ++++++++++++++++++
> >>   tools/testing/selftests/bpf/xskxceiver.c      | 23 ++++++++++++++++++-
> >>   2 files changed, 44 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/tools/testing/selftests/bpf/progs/xskxceiver.c
> >> b/tools/testing/selftests/bpf/progs/xskxceiver.c
> >> index b135daddad3a..83c879aa3581 100644
> >> --- a/tools/testing/selftests/bpf/progs/xskxceiver.c
> >> +++ b/tools/testing/selftests/bpf/progs/xskxceiver.c
> >> @@ -12,9 +12,31 @@ struct {
> >>       __type(value, __u32);
> >>   } xsk SEC(".maps");
> >> +extern int bpf_xdp_metadata_have_rx_timestamp(struct xdp_md *ctx)
> >> __ksym;
> >> +extern __u32 bpf_xdp_metadata_rx_timestamp(struct xdp_md *ctx) __ksym;
> >> +
> >>   SEC("xdp")
> >>   int rx(struct xdp_md *ctx)
> >>   {
> >> +    void *data, *data_meta;
> >> +    __u32 rx_timestamp;
> >> +    int ret;
> >> +
> >> +    if (bpf_xdp_metadata_have_rx_timestamp(ctx)) {
>
> In current veth implementation, bpf_xdp_metadata_have_rx_timestamp()
> will always return true here.
>
> In the case of hardware timestamps, not every packet will contain a
> hardware timestamp.  (See my/Maryam ixgbe patch, where timestamps are
> read via HW device register, which isn't fast, and HW only support this
> for timesync protocols like PTP).
>
> How do you imagine we can extend this?

I'm always returning true for simplicity. In the real world, this
bytecode will look at the descriptors and return true/false depending
on whether the info is there or not.

> >> +        ret = bpf_xdp_adjust_meta(ctx, -(int)sizeof(__u32));
>
> IMHO sizeof() should come from a struct describing data_meta area see:
>
> https://github.com/xdp-project/bpf-examples/blob/master/AF_XDP-interaction/af_xdp_kern.c#L62

I guess I should've used pointers for the return type instead, something like:

extern __u64 *bpf_xdp_metadata_rx_timestamp(struct xdp_md *ctx) __ksym;

{
   ...
    __u64 *rx_timestamp = bpf_xdp_metadata_rx_timestamp(ctx);
    if (rx_timestamp) {
        bpf_xdp_adjust_meta(ctx, -(int)sizeof(*rx_timestamp));
        __builtin_memcpy(data_meta, rx_timestamp, sizeof(*rx_timestamp));
    }
}

Does that look better?

> >> +        if (ret != 0)
> >> +            return XDP_DROP;
> >> +
> >> +        data = (void *)(long)ctx->data;
> >> +        data_meta = (void *)(long)ctx->data_meta;
> >> +
> >> +        if (data_meta + sizeof(__u32) > data)
> >> +            return XDP_DROP;
> >> +
> >> +        rx_timestamp = bpf_xdp_metadata_rx_timestamp(ctx);
> >> +        __builtin_memcpy(data_meta, &rx_timestamp, sizeof(__u32));
>
> So, this approach first stores hints on some other memory location, and
> then need to copy over information into data_meta area. That isn't good
> from a performance perspective.
>
> My idea is to store it in the final data_meta destination immediately.

This approach doesn't have to store the hints in the other memory
location. xdp_buff->priv can point to the real hw descriptor and the
kfunc can have a bytecode that extracts the data from the hw
descriptors. For this particular RFC, we can think that 'skb' is that
hw descriptor for veth driver.

> Do notice that in my approach, the existing ethtool config setting and
> socket options (for timestamps) still apply.  Thus, each individual
> hardware hint are already configurable. Thus we already have a config
> interface. I do acknowledge, that in-case a feature is disabled it still
> takes up space in data_meta areas, but importantly it is NOT stored into
> the area (for performance reasons).

That should be the case with this rfc as well, isn't it? Worst case
scenario, that kfunc bytecode can explicitly check ethtool options and
return false if it's disabled?

> >> +    }
> >
> > Thanks for the patches.  I took a quick look at patch 1 and 2 but
> > haven't had a chance to look at the implementation details (eg.
> > KF_UNROLL...etc), yet.
> >
>
> Yes, thanks for the patches, even-though I don't agree with the
> approach, at-least until my concerns/use-case can be resolved.
> IMHO the best way to convince people is through code. So, thank you for
> the effort.  Hopefully we can use some of these ideas and I can also
> change/adjust my XDP-hints ideas to incorporate some of this :-)

Thank you for the feedback as well, appreciate it!
Definitely, looking forward to a v2 from you with some more clarity on
how those btf ids are handled by the bpf/af_xdp side!

> > Overall (with the example here) looks promising.  There is a lot of
> > flexibility on whether the xdp prog needs any hint at all, which hint it
> > needs, and how to store it.
> >
>
> I do see the advantage that XDP prog only populates metadata it needs.
> But how can we use/access this in __xdp_build_skb_from_frame() ?

I don't think __xdp_build_skb_from_frame is automagically solved by
either proposal?
For this proposal, there has to be some expected kernel metadata
format that bpf programs will prepare and the kernel will understand?
Think of it like xdp_hints_common from your proposal; the program will
have to put together xdp_hints_skb into xdp metadata with the parts
that can be populated into skb by the kernel.

For your btf ids proposal, it seems there has to be some extra kernel
code to parse all possible driver btf_if formats and copy the
metadata?





> >> +
> >>       return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
> >>   }
> >> diff --git a/tools/testing/selftests/bpf/xskxceiver.c
> >> b/tools/testing/selftests/bpf/xskxceiver.c
> >> index 066bd691db13..ce82c89a432e 100644
> >> --- a/tools/testing/selftests/bpf/xskxceiver.c
> >> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> >> @@ -871,7 +871,9 @@ static bool is_offset_correct(struct xsk_umem_info
> >> *umem, struct pkt_stream *pkt
> >>   static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr,
> >> u32 len)
> >>   {
> >>       void *data = xsk_umem__get_data(buffer, addr);
> >> +    void *data_meta = data - sizeof(__u32);
> >>       struct iphdr *iphdr = (struct iphdr *)(data + sizeof(struct
> >> ethhdr));
> >> +    __u32 rx_timestamp = 0;
> >>       if (!pkt) {
> >>           ksft_print_msg("[%s] too many packets received\n", __func__);
> >> @@ -907,6 +909,13 @@ static bool is_pkt_valid(struct pkt *pkt, void
> >> *buffer, u64 addr, u32 len)
> >>           return false;
> >>       }
> >> +    memcpy(&rx_timestamp, data_meta, sizeof(rx_timestamp));
>
> I acknowledge that it is too extensive to add to this patch, but in my
> AF_XDP-interaction example[1], I'm creating a struct xdp_hints_rx_time
> that gets BTF exported[1][2] to the userspace application, and userspace
> decodes the BTF and gets[3] a xsk_btf_member struct for members that
> simply contains a offset+size to read from.
>
> [1]
> https://github.com/xdp-project/bpf-examples/blob/master/AF_XDP-interaction/af_xdp_kern.c#L47-L51
>
> [2]
> https://github.com/xdp-project/bpf-examples/blob/master/AF_XDP-interaction/af_xdp_kern.c#L80
>
> [3]
> https://github.com/xdp-project/bpf-examples/blob/master/AF_XDP-interaction/af_xdp_user.c#L123-L129
>
> >> +    if (rx_timestamp == 0) {
> >> +        ksft_print_msg("Invalid metadata received: ");
> >> +        ksft_print_msg("got %08x, expected != 0\n", rx_timestamp);
> >> +        return false;
> >> +    }
> >> +
> >>       return true;
> >>   }
> >
>
> Looking forward to collaborate :-)
> --Jesper
>
