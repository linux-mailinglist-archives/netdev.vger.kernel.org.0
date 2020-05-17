Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC03F1D657E
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 06:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgEQECP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 00:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgEQECP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 00:02:15 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC2FC061A0C;
        Sat, 16 May 2020 21:02:15 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id w10so6292739ljo.0;
        Sat, 16 May 2020 21:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jjboTDhguDD2ijn2C2vB2yalYOojB2737UbMVNJBmiA=;
        b=mawK+hAGONx2CxYZVz+/HHLwZQE8b2Ilzgi0BD+nzUB6/AXrUO5FJuOrJyvy31vLlK
         jK1NYPZzmysvtAgwTkhNst2AiYmEk1hNxySqVRFx2oNCFyZqyapf6hF5l503rJpcaqmx
         /DHo8bMjbdd08aSvr3UEa6gSTUiXku1PPFfIkx/dFsN7IUNhpYwHCgbSjWHy1g6Q6zV0
         kpNN2IbDlruUa4ADjahSbpFLpzTK6mbBSCXWn0m6zeZIpjB+Hu+T0LKGxb93VwV8ky42
         5YnPN2ia+32EkEiUGjuJDeOshNTltrrQ6On29XGgvjvjpFm4lYQtGJ3c4OIs4JNqnPrF
         ZrGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jjboTDhguDD2ijn2C2vB2yalYOojB2737UbMVNJBmiA=;
        b=DKFNBfoPCR8DmB050K+qFWtbO0OhzQIrb0ziibB3tbZG3kXRn/prUXivnQwxBSqoQn
         WgWcWHVWqDvHTxEwDQRID1H/AhDgn28MGDCQci9pQJwQOMFeYGlytvNgvDN4R5nAdXik
         EVAYP3t+V/glNB4CqPJx16iVp4C+YjD8aN8AkmLbvfKx4Gg1ez+ykfM0+MLyjZFVU+r/
         skkLkREKZIoRzbcvCfVfChX8/ITPGjbZHJkrcnV3+eosWh6puQLhANYjqG3fs5bRZwmP
         V63L3hGN4w8ou6D/ActGP/opjq54TDtpu6m617Xu5P0EDETIAauKtTIqLHYcgEYPTaiQ
         TECg==
X-Gm-Message-State: AOAM531D8pKtB8akyZogXwVuRNsoRUNEQDUQck5/fToLvwFss3oCcS95
        peEapDxf2RMgjQmm5ZRIQjegtVHPkYtRDYLSlOM=
X-Google-Smtp-Source: ABdhPJzDMvh+Gk821b8lzARA/hzR0Rbd5aacsMZHoKrEGA+Xb4hzv2qZmw5Xg3YMyimnwlTNdClc5FIqQ4RyUaEqNiU=
X-Received: by 2002:a2e:b5cf:: with SMTP id g15mr3179376ljn.212.1589688133267;
 Sat, 16 May 2020 21:02:13 -0700 (PDT)
MIME-Version: 1.0
References: <158945314698.97035.5286827951225578467.stgit@firesoul> <158945349549.97035.15316291762482444006.stgit@firesoul>
In-Reply-To: <158945349549.97035.15316291762482444006.stgit@firesoul>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 16 May 2020 21:02:01 -0700
Message-ID: <CAADnVQLtJotzY==OfOHmA-KdTb6bF7uqKVYGhnPj-oyzSZ8C_g@mail.gmail.com>
Subject: unstable xdp tests. Was: [PATCH net-next v4 31/33] bpf: add
 xdp.frame_sz in bpf_prog_test_run_xdp().
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 3:51 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> Update the memory requirements, when adding xdp.frame_sz in BPF test_run
> function bpf_prog_test_run_xdp() which e.g. is used by XDP selftests.
>
> Specifically add the expected reserved tailroom, but also allocated a
> larger memory area to reflect that XDP frames usually comes in this
> format. Limit the provided packet data size to 4096 minus headroom +
> tailroom, as this also reflect a common 3520 bytes MTU limit with XDP.
>
> Note that bpf_test_init already use a memory allocation method that clears
> memory.  Thus, this already guards against leaking uninit kernel memory.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  net/bpf/test_run.c |   16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 29dbdd4c29f6..30ba7d38941d 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -470,25 +470,34 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>  int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
>                           union bpf_attr __user *uattr)
>  {
> +       u32 tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +       u32 headroom = XDP_PACKET_HEADROOM;
>         u32 size = kattr->test.data_size_in;
>         u32 repeat = kattr->test.repeat;
>         struct netdev_rx_queue *rxqueue;
>         struct xdp_buff xdp = {};
>         u32 retval, duration;
> +       u32 max_data_sz;
>         void *data;
>         int ret;
>
>         if (kattr->test.ctx_in || kattr->test.ctx_out)
>                 return -EINVAL;
>
> -       data = bpf_test_init(kattr, size, XDP_PACKET_HEADROOM + NET_IP_ALIGN, 0);
> +       /* XDP have extra tailroom as (most) drivers use full page */
> +       max_data_sz = 4096 - headroom - tailroom;
> +       if (size > max_data_sz)
> +               return -EINVAL;
> +
> +       data = bpf_test_init(kattr, max_data_sz, headroom, tailroom);

Hi Jesper,

above is buggy.
max_data_sz is way more than what user space has.
That causes xdp unit tests to fail sporadically with EFAULT.
Like:
./test_progs -t xdp_perf
test_xdp_perf:FAIL:xdp-perf err -1 errno 14 retval 0 size 0
#89 xdp_perf:FAIL

For that test max_data_sz will be 3520 while user space prepared only 128 bytes
and copy_from_user will fault.
