Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB57294E60
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 16:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442795AbgJUOTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 10:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442694AbgJUOTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 10:19:00 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58ECAC0613CE
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 07:19:00 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id m3so522889vki.12
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 07:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OjMv92+4oU1Jh0KOe7rYhLDxGnwEq0TYxE8gqZwye8I=;
        b=pxtUeUD4lPmCkWzUTrMWaieU/qLdb3ndVcshp+AGw5M9jgNmSgKxhTFShTFQ1NBM1E
         mW2V9Oog1rFYQY0RRuhaC8xfiT7rs8M3ACbx8yAp48YvwF8ODRMa2+mSJNSVH3qVCd1n
         +cVB8OedpHsz7td37fQtX2cWO4EDasdM0rZ5bwWe3MRzPXMFyMwSwZ0FBZE0I5qlPVpN
         /tVvPOMxO8V9+rzZvpa3Ual6RWdmY3WtWJrj7iBQtho2+5Lg1PKjKq4d+ECi28g8patC
         jZzy/Xi1BL49TqewVix6QCHI///WBFCPUZh7s2ZRE/O3dNizAx77SYzjK9N7gOq5WQKl
         SLbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OjMv92+4oU1Jh0KOe7rYhLDxGnwEq0TYxE8gqZwye8I=;
        b=oAHmkbov1SSGOWnkLjmzCCasDZLty/yymjnKzHGuJvL6EX8alxZA5CKH7kIfu0+tUE
         eHsh/vbIv8FlMoD15e14liGJl1oTkstwdqjnpqW+BMoDYwYNhjyG3JVc2TPhzyOjVBxU
         SoGoWKhpoJFLpqDB9soLpNEFXOuA5Z1nFDH8/1RSLOni7NwW6soFIpIBHxofjto1UFSP
         c2hxCMuEpBZ7cFxpt5Ew62SsZmcCF997Da4gNnO+OZjN7HIKsb0RC2DNPztVO8dQytpM
         7xK5hN1W51fUAu2fF5TcelkK8U7Lcxe5Y8oDGnV04INNbgApNe4xa3sqP46qmGAHWLwG
         goPg==
X-Gm-Message-State: AOAM530NVzf2ER5vXDp1P1B7w1k4SxJT9uFai6w1kLqGEhzLswLRS733
        J1QbnWtXZvEGR75XKl+o+fl1zNyAHg0=
X-Google-Smtp-Source: ABdhPJwlHmnM8BaAf4woIOVqm736Ok7jndqxwn7s/OkroNoTU/Y8EXdG1+qq8yFVPllSNHbpDu85JQ==
X-Received: by 2002:a1f:36cb:: with SMTP id d194mr1998815vka.5.1603289938614;
        Wed, 21 Oct 2020 07:18:58 -0700 (PDT)
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com. [209.85.217.50])
        by smtp.gmail.com with ESMTPSA id o22sm278925vsr.12.2020.10.21.07.18.57
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2020 07:18:57 -0700 (PDT)
Received: by mail-vs1-f50.google.com with SMTP id n18so949923vsl.2
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 07:18:57 -0700 (PDT)
X-Received: by 2002:a05:6102:398:: with SMTP id m24mr2117226vsq.14.1603289936531;
 Wed, 21 Oct 2020 07:18:56 -0700 (PDT)
MIME-Version: 1.0
References: <20201021115915.8286-1-mst@redhat.com>
In-Reply-To: <20201021115915.8286-1-mst@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 21 Oct 2020 10:18:20 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdorOgOUAAepP+q7MzU0GPi0OQ0sMVpaYu18GsE9TqxiA@mail.gmail.com>
Message-ID: <CA+FuTSdorOgOUAAepP+q7MzU0GPi0OQ0sMVpaYu18GsE9TqxiA@mail.gmail.com>
Subject: Re: [PATCH v3] Revert "virtio-net: ethtool configurable RXCSUM"
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 8:00 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> This reverts commit 3618ad2a7c0e78e4258386394d5d5f92a3dbccf8.
>
> When control vq is not negotiated, that commit causes a crash:
>
> [   72.229171] kernel BUG at drivers/net/virtio_net.c:1667!
> [   72.230266] invalid opcode: 0000 [#1] PREEMPT SMP
> [   72.231172] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.9.0-rc8-02934-g3618ad2a7c0e7 #1
> [   72.231172] EIP: virtnet_send_command+0x120/0x140
> [   72.231172] Code: 00 0f 94 c0 8b 7d f0 65 33 3d 14 00 00 00 75 1c 8d 65 f4 5b 5e 5f 5d c3 66 90 be 01 00 00 00 e9 6e ff ff ff 8d b6 00
> +00 00 00 <0f> 0b e8 d9 bb 82 00 eb 17 8d b4 26 00 00 00 00 8d b4 26 00 00 00
> [   72.231172] EAX: 0000000d EBX: f72895c0 ECX: 00000017 EDX: 00000011
> [   72.231172] ESI: f7197800 EDI: ed69bd00 EBP: ed69bcf4 ESP: ed69bc98
> [   72.231172] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010246
> [   72.231172] CR0: 80050033 CR2: 00000000 CR3: 02c84000 CR4: 000406f0
> [   72.231172] Call Trace:
> [   72.231172]  ? __virt_addr_valid+0x45/0x60
> [   72.231172]  ? ___cache_free+0x51f/0x760
> [   72.231172]  ? kobject_uevent_env+0xf4/0x560
> [   72.231172]  virtnet_set_guest_offloads+0x4d/0x80
> [   72.231172]  virtnet_set_features+0x85/0x120
> [   72.231172]  ? virtnet_set_guest_offloads+0x80/0x80
> [   72.231172]  __netdev_update_features+0x27a/0x8e0
> [   72.231172]  ? kobject_uevent+0xa/0x20
> [   72.231172]  ? netdev_register_kobject+0x12c/0x160
> [   72.231172]  register_netdevice+0x4fe/0x740
> [   72.231172]  register_netdev+0x1c/0x40
> [   72.231172]  virtnet_probe+0x728/0xb60
> [   72.231172]  ? _raw_spin_unlock+0x1d/0x40
> [   72.231172]  ? virtio_vdpa_get_status+0x1c/0x20
> [   72.231172]  virtio_dev_probe+0x1c6/0x271
> [   72.231172]  really_probe+0x195/0x2e0
> [   72.231172]  driver_probe_device+0x26/0x60
> [   72.231172]  device_driver_attach+0x49/0x60
> [   72.231172]  __driver_attach+0x46/0xc0
> [   72.231172]  ? device_driver_attach+0x60/0x60
> [   72.231172]  bus_add_driver+0x197/0x1c0
> [   72.231172]  driver_register+0x66/0xc0
> [   72.231172]  register_virtio_driver+0x1b/0x40
> [   72.231172]  virtio_net_driver_init+0x61/0x86
> [   72.231172]  ? veth_init+0x14/0x14
> [   72.231172]  do_one_initcall+0x76/0x2e4
> [   72.231172]  ? rdinit_setup+0x2a/0x2a
> [   72.231172]  do_initcalls+0xb2/0xd5
> [   72.231172]  kernel_init_freeable+0x14f/0x179
> [   72.231172]  ? rest_init+0x100/0x100
> [   72.231172]  kernel_init+0xd/0xe0
> [   72.231172]  ret_from_fork+0x1c/0x30
> [   72.231172] Modules linked in:
> [   72.269563] ---[ end trace a6ebc4afea0e6cb1 ]---
>
> The reason is that virtnet_set_features now calls virtnet_set_guest_offloads
> unconditionally, it used to only call it when there is something
> to configure.

Right. The fix might be to make the call to virtnet_set_guest_offloads
conditional again

-       err = virtnet_set_guest_offloads(vi, offloads);
-       if (err)
-               return err;
+       if (offloads ^ vi->guest_offloads) {
+               err = virtnet_set_guest_offloads(vi, offloads);
+               if (err)
+                       return err;
+       }

Whether the two features in virtnet_set_features are configurable at
all depends on whether they are part of dev->hw_features, which is
conditional on guest offload support:

        if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)) {
                dev->hw_features |= NETIF_F_RXCSUM;
                dev->hw_features |= NETIF_F_LRO;
        }

so I had not expected virtnet_set_features to get called at all unless
this was enabled. Clearly an incorrect assumption.

The conservative solution is a  full revert and resubmitting a correct
new patch for net-next. Thanks for preparing the revert, sorry for the
breakage. Are you sending it for a third time because of the patchwork
quirk?

> If device does not have a control vq, everything breaks.
>
> Looking at this some more, I noticed that it's not really checking the
> hardware too much. E.g.
>
>         if ((dev->features ^ features) & NETIF_F_LRO) {
>                 if (features & NETIF_F_LRO)
>                         offloads |= GUEST_OFFLOAD_LRO_MASK &
>                                     vi->guest_offloads_capable;
>                 else
>                         offloads &= ~GUEST_OFFLOAD_LRO_MASK;
>         }
>
> and
>
>                                 (1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
>                                 (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
>                                 (1ULL << VIRTIO_NET_F_GUEST_UFO))
>
> But there's no guarantee that e.g. VIRTIO_NET_F_GUEST_TSO6 is set.
>
> If it isn't command should not send it.

It only toggles the subset of this mask that is agreed on at probe and
at that time stored in guest_offloads_capable. As Jason also
mentioned. I think this comment is obsolete.

        for (i = 0; i < ARRAY_SIZE(guest_offloads); i++)
                if (virtio_has_feature(vi->vdev, guest_offloads[i]))
                        set_bit(guest_offloads[i], &vi->guest_offloads);
        vi->guest_offloads_capable = vi->guest_offloads;
