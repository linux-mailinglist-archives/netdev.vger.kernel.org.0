Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244034032AE
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 04:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347292AbhIHCio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 22:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235776AbhIHCim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 22:38:42 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F9AC061575;
        Tue,  7 Sep 2021 19:37:35 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id p2so1214095oif.1;
        Tue, 07 Sep 2021 19:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NsguYS5uzhUdOW9e+Rb/jXTsKu2P16e41K7Xn3TVElc=;
        b=RD9A11fS82i4pPHhfJ4rPe+2GBzVeARMaTw/0Z5DdqMYOzLXac3rETP/HSOkOtpPPD
         FCF8S3gcdLcGh1DcypolHAXjV9g4BlS3NeWLrnMOUUpOW0qxs7INp+i4ycfpLg8xZGaJ
         eP8/PyPANSB+P024rB2xBjFmOEhDhQet7yvLkSuDgtCBuK53W1z8I25zeodFTYbOkTN9
         x1SF9Y+GmZnbk+gnc91dIoKbCRcJQDjAwO4gyepYvJ9tY0e4uJHv4T7xWSo1KWPWkbpQ
         Gw/hm9NyKI+1NGPOSM/VHkGn2ElpzGrbigGObgGc0SioIJ60pXdmD9QdDX930G8XpXjl
         lIvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NsguYS5uzhUdOW9e+Rb/jXTsKu2P16e41K7Xn3TVElc=;
        b=UD9HsuTyK6W6bCO7otFdaIdNlRho6knpGH9AKqPq2TBwOLHQk+AFJn5adZQWtSFVuL
         lsFQxgAeljUIMtdssa4bhxJsQ96DKhDpFE0TBGdbkCCsJpE/yxCCKgGg7YeIzzVS9glD
         ulzvDUUW0U40NMWh3udIGi1V7iGyQrOL++zmvbAKUDpBSQmO6tg71ncL9m/enOzoMLME
         UBP0qrJ+/THaTdikSDUQmNm4Q0sZHiR0N17wx1Q9Ls56VuntH/kjGK3e1FAsjoY9C3G9
         e5381NpS71P4vvHWo4GZZIzuwndgjjIbVm41N+jFDxM6nfHTOjqSPtucxfsBxnnWXWN3
         4zYg==
X-Gm-Message-State: AOAM530ZObdg0KBV6abhaKcsdPJzkCeZN8JY9PTcxAgw0MlEBd4gKMBm
        JS//KOdFsBm3jslNnQP3TSuiEmztcXARbv9Mb+gN3iTD3YxNm4Bd
X-Google-Smtp-Source: ABdhPJx9aRvD4JgKPvHZBe4rjkEZuRHyEwlKic8GY7NVRY4Hdyl8qIZI9FPwsxYNTI8wiUVaXlKnJEHrY90e9HjYs0g=
X-Received: by 2002:a05:6808:319:: with SMTP id i25mr789546oie.141.1631068654661;
 Tue, 07 Sep 2021 19:37:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210903064013.9842-1-zhoufeng.zf@bytedance.com>
 <2ee172ab-836c-d464-be59-935030d01f4b@molgen.mpg.de> <8ce8de1c-14bf-20ad-00c0-9e0d8ff34b91@bytedance.com>
 <318e7f75-287e-148a-cdb0-648b7c36e0a9@redhat.com>
In-Reply-To: <318e7f75-287e-148a-cdb0-648b7c36e0a9@redhat.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 8 Sep 2021 10:36:58 +0800
Message-ID: <CAL+tcoANwm41McdufaB0UggcUN3cXsPL6Vta99BPodYKwLyBGw@mail.gmail.com>
Subject: Re: [External] Re: [Intel-wired-lan] [PATCH v2] ixgbe: Fix NULL
 pointer dereference in ixgbe_xdp_setup
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Feng Zhou <zhoufeng.zf@bytedance.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Jason Xing <xingwanli@kuaishou.com>, brouer@redhat.com,
        duanxiongchun@bytedance.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, zhengqi.arch@bytedance.com,
        chenying.kernel@bytedance.com, intel-wired-lan@lists.osuosl.org,
        songmuchun@bytedance.com, bpf@vger.kernel.org,
        wangdongdong.6@bytedance.com, zhouchengming@bytedance.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, jeffrey.t.kirsher@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 6, 2021 at 7:32 PM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
> Hi Feng and Jason,
>
> Please notice that you are both developing patches that change the ixgbe
> driver in related areas.

Thanks for noticing. We're doing different things as they are both
related to XDP on ixgbe actually.

Jason

>
> Jason's patch:
>   Subject: [PATCH v7] ixgbe: let the xdpdrv work with more than 64 cpus
>
> https://lore.kernel.org/all/20210901101206.50274-1-kerneljasonxing@gmail.=
com/
>
> We might need both as this patch looks like a fix to a panic, and
> Jason's patch allows XDP on ixgbe to work on machines with more than 64
> CPUs.
>
> -Jesper
>
> On 06/09/2021 09.49, Feng Zhou wrote:
> >
> > =E5=9C=A8 2021/9/6 =E4=B8=8B=E5=8D=882:37, Paul Menzel =E5=86=99=E9=81=
=93:
> >> Dear Feng,
> >>
> >>
> >> Am 03.09.21 um 08:40 schrieb Feng zhou:
> >>
> >> (If you care, in your email client, your last name does not start with
> >> a capital letter.)
> >>
> >>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> >>>
> >>> The ixgbe driver currently generates a NULL pointer dereference with
> >>> some machine (online cpus < 63). This is due to the fact that the
> >>> maximum value of num_xdp_queues is nr_cpu_ids. Code is in
> >>> "ixgbe_set_rss_queues"".
> >>>
> >>> Here's how the problem repeats itself:
> >>> Some machine (online cpus < 63), And user set num_queues to 63 throug=
h
> >>> ethtool. Code is in the "ixgbe_set_channels",
> >>> adapter->ring_feature[RING_F_FDIR].limit =3D count;
> >>
> >> For better legibility, you might want to indent code (blocks) by four
> >> spaces and add blank lines around it (also below).
> >>
> >>> It becames 63.
> >>
> >> becomes
> >>
> >>> When user use xdp, "ixgbe_set_rss_queues" will set queues num.
> >>> adapter->num_rx_queues =3D rss_i;
> >>> adapter->num_tx_queues =3D rss_i;
> >>> adapter->num_xdp_queues =3D ixgbe_xdp_queues(adapter);
> >>> And rss_i's value is from
> >>> f =3D &adapter->ring_feature[RING_F_FDIR];
> >>> rss_i =3D f->indices =3D f->limit;
> >>> So "num_rx_queues" > "num_xdp_queues", when run to "ixgbe_xdp_setup",
> >>> for (i =3D 0; i < adapter->num_rx_queues; i++)
> >>>     if (adapter->xdp_ring[i]->xsk_umem)
> >>> lead to panic.
> >>
> >> lead*s*?
> >>
> >>> Call trace:
> >>> [exception RIP: ixgbe_xdp+368]
> >>> RIP: ffffffffc02a76a0  RSP: ffff9fe16202f8d0  RFLAGS: 00010297
> >>> RAX: 0000000000000000  RBX: 0000000000000020  RCX: 0000000000000000
> >>> RDX: 0000000000000000  RSI: 000000000000001c  RDI: ffffffffa94ead90
> >>> RBP: ffff92f8f24c0c18   R8: 0000000000000000   R9: 0000000000000000
> >>> R10: ffff9fe16202f830  R11: 0000000000000000  R12: ffff92f8f24c0000
> >>> R13: ffff9fe16202fc01  R14: 000000000000000a  R15: ffffffffc02a7530
> >>> ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> >>>   7 [ffff9fe16202f8f0] dev_xdp_install at ffffffffa89fbbcc
> >>>   8 [ffff9fe16202f920] dev_change_xdp_fd at ffffffffa8a08808
> >>>   9 [ffff9fe16202f960] do_setlink at ffffffffa8a20235
> >>> 10 [ffff9fe16202fa88] rtnl_setlink at ffffffffa8a20384
> >>> 11 [ffff9fe16202fc78] rtnetlink_rcv_msg at ffffffffa8a1a8dd
> >>> 12 [ffff9fe16202fcf0] netlink_rcv_skb at ffffffffa8a717eb
> >>> 13 [ffff9fe16202fd40] netlink_unicast at ffffffffa8a70f88
> >>> 14 [ffff9fe16202fd80] netlink_sendmsg at ffffffffa8a71319
> >>> 15 [ffff9fe16202fdf0] sock_sendmsg at ffffffffa89df290
> >>> 16 [ffff9fe16202fe08] __sys_sendto at ffffffffa89e19c8
> >>> 17 [ffff9fe16202ff30] __x64_sys_sendto at ffffffffa89e1a64
> >>> 18 [ffff9fe16202ff38] do_syscall_64 at ffffffffa84042b9
> >>> 19 [ffff9fe16202ff50] entry_SYSCALL_64_after_hwframe at ffffffffa8c00=
08c
> >>
> >> Please describe the fix in the commit message.
> >>
> >>> Fixes: 4a9b32f30f80 ("ixgbe: fix potential RX buffer starvation for
> >>> AF_XDP")
> >>> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> >>> ---
> >>> Updates since v1:
> >>> - Fix "ixgbe_max_channels" callback so that it will not allow a
> >>> setting of
> >>> queues to be higher than the num_online_cpus().
> >>> more details can be seen from here:
> >>> https://patchwork.ozlabs.org/project/intel-wired-lan/patch/2021081707=
5407.11961-1-zhoufeng.zf@bytedance.com/
> >>>
> >>> Thanks to Maciej Fijalkowski for your advice.
> >>>
> >>>   drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 2 +-
> >>>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    | 8 ++++++--
> >>>   2 files changed, 7 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> >>> b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> >>> index 4ceaca0f6ce3..21321d164708 100644
> >>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> >>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> >>> @@ -3204,7 +3204,7 @@ static unsigned int ixgbe_max_channels(struct
> >>> ixgbe_adapter *adapter)
> >>>           max_combined =3D ixgbe_max_rss_indices(adapter);
> >>>       }
> >>>   -    return max_combined;
> >>> +    return min_t(int, max_combined, num_online_cpus());
> >>>   }
> >>>     static void ixgbe_get_channels(struct net_device *dev,
> >>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> >>> b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> >>> index 14aea40da50f..5db496cc5070 100644
> >>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> >>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> >>> @@ -10112,6 +10112,7 @@ static int ixgbe_xdp_setup(struct net_device
> >>> *dev, struct bpf_prog *prog)
> >>>       struct ixgbe_adapter *adapter =3D netdev_priv(dev);
> >>>       struct bpf_prog *old_prog;
> >>>       bool need_reset;
> >>> +    int num_queues;
> >>>         if (adapter->flags & IXGBE_FLAG_SRIOV_ENABLED)
> >>>           return -EINVAL;
> >>> @@ -10161,11 +10162,14 @@ static int ixgbe_xdp_setup(struct
> >>> net_device *dev, struct bpf_prog *prog)
> >>>       /* Kick start the NAPI context if there is an AF_XDP socket ope=
n
> >>>        * on that queue id. This so that receiving will start.
> >>>        */
> >>> -    if (need_reset && prog)
> >>> -        for (i =3D 0; i < adapter->num_rx_queues; i++)
> >>> +    if (need_reset && prog) {
> >>> +        num_queues =3D min_t(int, adapter->num_rx_queues,
> >>> +            adapter->num_xdp_queues);
> >>> +        for (i =3D 0; i < num_queues; i++)
> >>>               if (adapter->xdp_ring[i]->xsk_pool)
> >>>                   (void)ixgbe_xsk_wakeup(adapter->netdev, i,
> >>>                                  XDP_WAKEUP_RX);
> >>> +    }
> >>>         return 0;
> >>>   }
> >>>
> > Thanks for your advice. I will modify the commit message in v3
> >
>
