Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 148501286B0
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 04:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfLUDJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 22:09:23 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:37908 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfLUDJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 22:09:23 -0500
Received: by mail-yb1-f196.google.com with SMTP id f130so4633956ybb.5
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 19:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/MmE0BSfA4eSxzEuFlBz4xmNmzslSl61ay4ol+tnyOA=;
        b=TEx1RffxJNUfO5zCvGXV2kGnvATRM3bxjTmoJszwgn+7ib0f5VheMRk/Mx0lEK0hVJ
         trrqdJlaJnSYnHtH7Pb9rcRCbUj+4L+eLaNYI1HZ1nHRPh8nmEnnxHmlDNelacoldHX1
         CFsj67fEvP6E+A6WNCWlHB3WjkRhVekgHRc+/5tAkZAhlazDoCbYSiu0C2oYGgJOTtYq
         EANAjmMeDWgD+XBZkaM19ohy+n7G9MInEJcn4Tl6vTzsu4ahnlRUyo4ZxXe/pRFNHRnV
         pQwYVrt5O6Prsjup+irgjnbKUvvqvU2qDroFMWhXFXXoR5+IdC8lj2AbsVWAF0RJLS0r
         Bcsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/MmE0BSfA4eSxzEuFlBz4xmNmzslSl61ay4ol+tnyOA=;
        b=oqyo2B6CQiFJ5ByG5ynNbOKTpZZ1uMxVoj6efr9npR3VjsdCjLNHfG2KcKsDYieFDi
         T0yw8njC0gKKpzaZR3jNHeHU5FfmH8oVX+qcssybdP/CKipq6G0Wc5UJ9hwyhamKouke
         Ba2U6JVwgHkeZYSLwwDGPHE8ipLzdWYx+AaB4XxzblrsxeGqPv+VFhFRKpf6m3IxydWr
         1V5lCN9eWTNdAKB5NrBrmQXzPGzatY8aBD3EoxwOJwSLqJyqqlFAl8bGYrZAHCodIA/V
         3bfZGW+AgbLbbsXiW7hVGMaM32IDhEd0Wi3UHZaNHvjswwo4B05q/Dwa8Byh4T46NUeK
         eADQ==
X-Gm-Message-State: APjAAAXciInsrgY+5FVbdgE3WzQzWe99fzJADZAVk5NDKpRLvu9SizxW
        0HkzgSyRld4KOuHTiIBijZQptfPA
X-Google-Smtp-Source: APXvYqzoz5D/HfwffaLEgClvwFGuLF4SDSDI7hgu5UihAzAGE9xKTV4JagrtLKNwGToq6OPvXaF2Ew==
X-Received: by 2002:a25:4b85:: with SMTP id y127mr12924208yba.238.1576897760917;
        Fri, 20 Dec 2019 19:09:20 -0800 (PST)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id 189sm4868910ywc.16.2019.12.20.19.09.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 19:09:19 -0800 (PST)
Received: by mail-yb1-f180.google.com with SMTP id a124so4641827ybg.2
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 19:09:18 -0800 (PST)
X-Received: by 2002:a5b:348:: with SMTP id q8mr13423111ybp.83.1576897758310;
 Fri, 20 Dec 2019 19:09:18 -0800 (PST)
MIME-Version: 1.0
References: <20191220212207.76726-1-adelva@google.com>
In-Reply-To: <20191220212207.76726-1-adelva@google.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 20 Dec 2019 22:08:41 -0500
X-Gmail-Original-Message-ID: <CA+FuTSewMaRTe51jOJtD-VHcp4Ct+c=11-9SxenULHwQuokamw@mail.gmail.com>
Message-ID: <CA+FuTSewMaRTe51jOJtD-VHcp4Ct+c=11-9SxenULHwQuokamw@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: Skip set_features on non-cvq devices
To:     Alistair Delva <adelva@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, kernel-team@android.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 4:22 PM Alistair Delva <adelva@google.com> wrote:
>
> On devices without control virtqueue support, such as the virtio_net
> implementation in crosvm[1], attempting to configure LRO will panic the
> kernel:
>
> kernel BUG at drivers/net/virtio_net.c:1591!
> invalid opcode: 0000 [#1] PREEMPT SMP PTI
> CPU: 1 PID: 483 Comm: Binder:330_1 Not tainted 5.4.5-01326-g19463e9acaac #1
> Hardware name: ChromiumOS crosvm, BIOS 0
> RIP: 0010:virtnet_send_command+0x15d/0x170 [virtio_net]
> Code: d8 00 00 00 80 78 02 00 0f 94 c0 65 48 8b 0c 25 28 00 00 00 48 3b 4c 24 70 75 11 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <0f> 0b e8 ec a4 12 c8 66 90 66 2e 0f 1f 84 00 00 00 00 00 55 48 89
> RSP: 0018:ffffb97940e7bb50 EFLAGS: 00010246
> RAX: ffffffffc0596020 RBX: ffffa0e1fc8ea840 RCX: 0000000000000017
> RDX: ffffffffc0596110 RSI: 0000000000000011 RDI: 000000000000000d
> RBP: ffffb97940e7bbf8 R08: ffffa0e1fc8ea0b0 R09: ffffa0e1fc8ea0b0
> R10: ffffffffffffffff R11: ffffffffc0590940 R12: 0000000000000005
> R13: ffffa0e1ffad2c00 R14: ffffb97940e7bc08 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffffa0e1fd100000(006b) knlGS:00000000e5ef7494
> CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> CR2: 00000000e5eeb82c CR3: 0000000079b06001 CR4: 0000000000360ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  ? preempt_count_add+0x58/0xb0
>  ? _raw_spin_lock_irqsave+0x36/0x70
>  ? _raw_spin_unlock_irqrestore+0x1a/0x40
>  ? __wake_up+0x70/0x190
>  virtnet_set_features+0x90/0xf0 [virtio_net]
>  __netdev_update_features+0x271/0x980
>  ? nlmsg_notify+0x5b/0xa0
>  dev_disable_lro+0x2b/0x190
>  ? inet_netconf_notify_devconf+0xe2/0x120
>  devinet_sysctl_forward+0x176/0x1e0
>  proc_sys_call_handler+0x1f0/0x250
>  proc_sys_write+0xf/0x20
>  __vfs_write+0x3e/0x190
>  ? __sb_start_write+0x6d/0xd0
>  vfs_write+0xd3/0x190
>  ksys_write+0x68/0xd0
>  __ia32_sys_write+0x14/0x20
>  do_fast_syscall_32+0x86/0xe0
>  entry_SYSENTER_compat+0x7c/0x8e
>
> This happens because virtio_set_features() does not check the presence
> of the control virtqueue feature, which is sanity checked by a BUG_ON
> in virtnet_send_command().
>
> Fix this by skipping any feature processing if the control virtqueue is
> missing. This should be OK for any future feature that is added, as
> presumably all of them would require control virtqueue support to notify
> the endpoint that offload etc. should begin.
>
> [1] https://chromium.googlesource.com/chromiumos/platform/crosvm/
>
> Fixes: a02e8964eaf9 ("virtio-net: ethtool configurable LRO")
> Cc: stable@vger.kernel.org [4.20+]
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: kernel-team@android.com
> Cc: virtualization@lists.linux-foundation.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Alistair Delva <adelva@google.com>

Thanks for debugging this, Alistair.

> ---
>  drivers/net/virtio_net.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 4d7d5434cc5d..709bcd34e485 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2560,6 +2560,9 @@ static int virtnet_set_features(struct net_device *dev,
>         u64 offloads;
>         int err;
>
> +       if (!vi->has_cvq)
> +               return 0;
> +

Instead of checking for this in virtnet_set_features, how about we
make configurability contingent on cvq in virtnet_probe:

-       if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
+       if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS) &&
+           virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
                dev->hw_features |= NETIF_F_LRO;

Based on this logic a little below in the same function

        if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
                vi->has_cvq = true;
