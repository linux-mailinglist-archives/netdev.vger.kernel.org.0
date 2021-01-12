Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A962F3A37
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393008AbhALTYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:24:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392984AbhALTYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 14:24:25 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338DEC061786;
        Tue, 12 Jan 2021 11:23:45 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id r63so3205919ybf.5;
        Tue, 12 Jan 2021 11:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gWw4Dda5GiSp13AvM2vk3l+3hQNYmIhj9JeG1aKw79Y=;
        b=aln0JArqpb7Be8nuLbKkpfI5c/0TUU4Da7OvHFHlkAL06EuOuUS2dV2WuMGxX33IQi
         a3LRYDDmgnPjFrI7c1HmrRP2KV0TEWbJ0Kj87zZJOtjHEJuxSgHT39ruR0eU69cP5/g5
         O1JKu4r/yhY0AkK0IjbGGupzNTz8W5xrJjyXyQ/y69hFlFx1Wz4Wgz3u6MwjSXxIE/xC
         iijZkvo3RBLJZf//I01AoJ3pwxpXA24ioLaDMvt5uydh+ncIyHsaJKMOHVwJ7bfJIiMb
         UpDRFJGoX2MLE6Z+2Iwv997Ja0rlgpMFs076pBBV2Hr1OYYpVYj5xehUZpj2Pz4e2w4j
         j0rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gWw4Dda5GiSp13AvM2vk3l+3hQNYmIhj9JeG1aKw79Y=;
        b=mYWvMtjPGuooYITp9Q37y5PmbCLBGAFyAJqFN43nTo4V8vif3xLj52LyqimYgRemE7
         RU286HFabQiMUzZ4KEnOb3YRsIO4tdnCNw/WxdpytkWnyLtQUecu8VkSRdEU1UGzexGH
         TJeb9TulsocC27wvydZRYRTodYEaqkoihyMN83/fg/TiJQbdy00Gw5SnL7gO36Zu0cwD
         Abw/r3MMLqDebejUo0xVHq0LpG1la07cmG+rhlbDX0fQ2CynS65lXRkfcyz8DDRik9Zl
         IbkOF2Q+qyhZdeRTbCJQ6UQvh2CoWwRfhWjsSEBmNJbtLWRq4AcN+LyUaucjbJ5oeQna
         TWgA==
X-Gm-Message-State: AOAM533NGtuJhKI09zN1ORO1LHk8hXGDv4Z8qk0NF/e4X0P7mCxM4YaB
        1eoRWtVtwXYJ78d1dMX+m463cOm7XKH8yfK046I=
X-Google-Smtp-Source: ABdhPJwH6Q/HsjT7/TKnk7Vzr6JskyrBhP82FYuc2i9rCCnHBmGAZjWGeji8hlqUPbjwxq3c/Bdn4RjNltTWPlkqIvk=
X-Received: by 2002:a25:48c7:: with SMTP id v190mr1396610yba.260.1610479424515;
 Tue, 12 Jan 2021 11:23:44 -0800 (PST)
MIME-Version: 1.0
References: <161047346644.4003084.2653117664787086168.stgit@firesoul> <161047352084.4003084.16468571234023057969.stgit@firesoul>
In-Reply-To: <161047352084.4003084.16468571234023057969.stgit@firesoul>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 Jan 2021 11:23:33 -0800
Message-ID: <CAEf4Bzb0Z+qeuDTtfz6Ae3ab5hz_iG0vt8ALiry2zYWkgRh2Fw@mail.gmail.com>
Subject: Re: [PATCH bpf-next V11 4/7] bpf: add BPF-helper for MTU checking
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 9:49 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> This BPF-helper bpf_check_mtu() works for both XDP and TC-BPF programs.
>
> The SKB object is complex and the skb->len value (accessible from
> BPF-prog) also include the length of any extra GRO/GSO segments, but
> without taking into account that these GRO/GSO segments get added
> transport (L4) and network (L3) headers before being transmitted. Thus,
> this BPF-helper is created such that the BPF-programmer don't need to
> handle these details in the BPF-prog.
>
> The API is designed to help the BPF-programmer, that want to do packet
> context size changes, which involves other helpers. These other helpers
> usually does a delta size adjustment. This helper also support a delta
> size (len_diff), which allow BPF-programmer to reuse arguments needed by
> these other helpers, and perform the MTU check prior to doing any actual
> size adjustment of the packet context.
>
> It is on purpose, that we allow the len adjustment to become a negative
> result, that will pass the MTU check. This might seem weird, but it's not
> this helpers responsibility to "catch" wrong len_diff adjustments. Other
> helpers will take care of these checks, if BPF-programmer chooses to do
> actual size adjustment.
>
> V9:
> - Use dev->hard_header_len (instead of ETH_HLEN)
> - Annotate with unlikely req from Daniel
> - Fix logic error using skb_gso_validate_network_len from Daniel
>
> V6:
> - Took John's advice and dropped BPF_MTU_CHK_RELAX
> - Returned MTU is kept at L3-level (like fib_lookup)
>
> V4: Lot of changes
>  - ifindex 0 now use current netdev for MTU lookup
>  - rename helper from bpf_mtu_check to bpf_check_mtu
>  - fix bug for GSO pkt length (as skb->len is total len)
>  - remove __bpf_len_adj_positive, simply allow negative len adj
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  include/uapi/linux/bpf.h       |   67 ++++++++++++++++++++++
>  net/core/filter.c              |  122 ++++++++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |   67 ++++++++++++++++++++++
>  3 files changed, 256 insertions(+)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 649586d656b6..fa2e99351758 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3833,6 +3833,61 @@ union bpf_attr {
>   *     Return
>   *             A pointer to a struct socket on success or NULL if the file is
>   *             not a socket.
> + *
> + * int bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)

should return long, same as most other helpers

> + *     Description
> + *             Check ctx packet size against MTU of net device (based on
> + *             *ifindex*).  This helper will likely be used in combination with
> + *             helpers that adjust/change the packet size.  The argument
> + *             *len_diff* can be used for querying with a planned size
> + *             change. This allows to check MTU prior to changing packet ctx.
> + *

[...]
