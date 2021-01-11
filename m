Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A8D2F1AE1
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 17:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731908AbhAKQ1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 11:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728344AbhAKQ1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 11:27:02 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6D6C061786;
        Mon, 11 Jan 2021 08:26:22 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id p187so173793iod.4;
        Mon, 11 Jan 2021 08:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3UumeRBfYlG0g5B7V4mOQZEMgtprEhalqGr6wGtldmE=;
        b=ssjyiJEQT3GVVjXhxG2SqKu1Ncd0hOZFYegMyYLx/ZZ7LP3XwciyyPFCt6SANn6Jzx
         ilW7LkgU7UNQQCvo69yuT9HwizechAbbGfveDfbXGSZthByMPO41gqvmVAcQDYu3qdWP
         wQgHt2MUX/KPdAlp6RYme4g9ShkkNNWUTjSHpcMv/tRNDNr31SO72mQAGjZDSfFv2dAB
         85by77od/1NWqokBcLydgACVlNHuNDCMn7jEMDLY0Xam2cGXRTTapwpH/PR9pXM3tMBJ
         /qBHwLFnkJthoBQS2bb6Ck3eexBTfCRv4SBY2IsjpFEs89EW1FKvu1xImY9undZM81M/
         QD1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3UumeRBfYlG0g5B7V4mOQZEMgtprEhalqGr6wGtldmE=;
        b=Z9euu0klChFt4se08tXdyrNKqcbYy49QpGkwQb18l0E7/yCMIhJfOoGcBFJXrf3W/7
         qmJAo5ySlNWiaeifbbQfR92Gz7u+QhOgO9KuwIVH+TXTRWp1/fgebpzR7EW38pezWRtV
         i11VykfPlhLdRzFT/7vQUhxfV6BfRNHrNN+HnK+LLKzkhP/+aYyZHOSTuQ29RRrs/Znx
         lORV6zW9HhMx/A8mUjZFr2fhJsc1/20MkRMZQ865F6pFyYgi1A0SE3Wzp8bJ+XQEoz7V
         83VMPY2vAUc8x4s+UlFQKVNx6DQZdhQljhM9cTncnz4BmdTjo9t/j6hTALlRhgOn3dQO
         qpIg==
X-Gm-Message-State: AOAM531WRhURYFTfhDBnTXL6oLZ7zxOk29JlXxKsJbhYaXeIFFsS5U+p
        MBTTD+/ePWvxxkslBNFHfBt8j+f0HPK7RjeqvSs=
X-Google-Smtp-Source: ABdhPJzfrRT3EsC/xadcfR+VMDs/ukbLNc4akxqch/I1toihnBxlcvN3Qr38AwVLpaHFWoaJgBouBYG3OJG/y4ZVKMM=
X-Received: by 2002:a02:969a:: with SMTP id w26mr494354jai.96.1610382381395;
 Mon, 11 Jan 2021 08:26:21 -0800 (PST)
MIME-Version: 1.0
References: <cover.1610368918.git.lucien.xin@gmail.com> <a34a8dcde6a158c64b0478c7098da757a6690f0b.1610368918.git.lucien.xin@gmail.com>
In-Reply-To: <a34a8dcde6a158c64b0478c7098da757a6690f0b.1610368918.git.lucien.xin@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 11 Jan 2021 08:26:09 -0800
Message-ID: <CAKgT0UdgL-aYGUfeYVRoqLpDFhPzko26z7mxvi2HyTdrLpCF5A@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: move the hsize check to the else block
 in skb_segment
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 4:45 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> After commit 89319d3801d1 ("net: Add frag_list support to skb_segment"),
> it goes to process frag_list when !hsize in skb_segment(). However, when
> using skb frag_list, sg normally should not be set. In this case, hsize
> will be set with len right before !hsize check, then it won't go to
> frag_list processing code.
>
> So the right thing to do is move the hsize check to the else block, so
> that it won't affect the !hsize check for frag_list processing.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/core/skbuff.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 7626a33..ea79359 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3855,8 +3855,6 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>                 hsize = skb_headlen(head_skb) - offset;
>                 if (hsize < 0)
>                         hsize = 0;
> -               if (hsize > len || !sg)
> -                       hsize = len;
>
>                 if (!hsize && i >= nfrags && skb_headlen(list_skb) &&
>                     (skb_headlen(list_skb) == len || sg)) {

So looking at the function it seems like the only spot where the
standard path actually reads the hsize value is right here, and it is
overwritten before we exit the non-error portion of the if statement.
I wonder if we couldn't save ourselves a few cycles and avoid an
unnecessary assignment by replacing the "!hsize" with a check for
"hsize <= 0" and just move the entire set of checks above down into
the lower block.

> @@ -3901,6 +3899,9 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>                         skb_release_head_state(nskb);
>                         __skb_push(nskb, doffset);
>                 } else {
> +                       if (hsize > len || !sg)
> +                               hsize = len;
> +

Then you could essentially just add the "if (hsize < 0)" piece here as
an "else if" check and avoid the check if it isn't needed.

>                         nskb = __alloc_skb(hsize + doffset + headroom,
>                                            GFP_ATOMIC, skb_alloc_rx_flag(head_skb),
>                                            NUMA_NO_NODE);
> --
> 2.1.0
>
