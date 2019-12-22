Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68971128EC5
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 16:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbfLVPzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 10:55:04 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:43746 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbfLVPzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 10:55:04 -0500
Received: by mail-yw1-f68.google.com with SMTP id v126so6202771ywc.10
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 07:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lAVicwNWaDkMag3xmq3Dz6+zXkkUHKTRx2/quvHKtCQ=;
        b=eUiuLpb48u5geqeZKhmXtXQw/MZxjPsB+J02ZrNeBn2iERhvThqjw4H7A7GXNonEMw
         eiyEYElCkysnzhyVmRKGeOZjZLVkclq3htf99rskR4Y3Jj+JzDYDBEfnlrNskKWKrX7S
         RI+LKtgp7NjeB5gwUEBny35lX6+QqwVJlPf8+8StkKpTv1arkZoBorZNorF9NB9xuJny
         wARQIIlLwzunkm/a6Ge5EAaCNnYQtyDQOjqyxQUxeRB63pisvZEAfRvM8yx0LhQtWT1K
         /XYGB7nc+knQw4dtgBRFsDJx4gCBUW0v/HrILqjGDpZcVzIoxjf4jAmG6rCuVuDpCEBB
         UV5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lAVicwNWaDkMag3xmq3Dz6+zXkkUHKTRx2/quvHKtCQ=;
        b=E6Mern7ZiKK6QnKJO12M+1YFBDlNK7/QUsZ1LbNExnIe8M6dCh7DiyAJZukWCpgCDV
         BcsRxrBTpKFZYenzBz3f/6OjlmAvcPWA1QheCoj6/dca4Cs+N1OQW9ZEF4ZlVM6iGvqN
         hdvHpyNFLAWqAnUfpRZd6Cl9VbA1Q8MMxCIfWzui9dkTM2ddR5/NgmQOB8SBTlkFjtvY
         9CCrtQAqoEZYm1ZRyuj7yIsm0KXp5z2T50ZmfWnQtiNIYQju0KAYOS53BEKAfz9ILAD1
         9lYsmUxQoH1+LYkMTeGuZIi5PPgQi3UboKptO6iHnyOdTHcEEtDHtNeoNTYj8sA62ZY1
         WuZQ==
X-Gm-Message-State: APjAAAV4nV4jHouR28lRW5V41FMEN3dPvRjdSz3Axj/9zF+H/IY9PsYe
        N8m3Tl8NxU5i7/FX1DycFx1cTcsH
X-Google-Smtp-Source: APXvYqwg3ZQOjABV46VNmX/62p65EDkPJr5cSdIz13eqQwTLQAwT0PurxmUXKu5B720cfc0XSjNQxw==
X-Received: by 2002:a81:8393:: with SMTP id t141mr18846532ywf.196.1577030102442;
        Sun, 22 Dec 2019 07:55:02 -0800 (PST)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id d9sm6786687ywh.55.2019.12.22.07.55.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Dec 2019 07:55:01 -0800 (PST)
Received: by mail-yb1-f171.google.com with SMTP id k17so1617726ybp.1
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 07:55:01 -0800 (PST)
X-Received: by 2002:a25:c444:: with SMTP id u65mr18090159ybf.443.1577030100686;
 Sun, 22 Dec 2019 07:55:00 -0800 (PST)
MIME-Version: 1.0
References: <20191220212207.76726-1-adelva@google.com> <CA+FuTSewMaRTe51jOJtD-VHcp4Ct+c=11-9SxenULHwQuokamw@mail.gmail.com>
 <20191222080754-mutt-send-email-mst@kernel.org> <CA+FuTSd4vd9wS0sHmAk=Ys2-OwZarAHT3TNFzg7c7+2Dsott=g@mail.gmail.com>
 <20191222095141-mutt-send-email-mst@kernel.org>
In-Reply-To: <20191222095141-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 22 Dec 2019 10:54:23 -0500
X-Gmail-Original-Message-ID: <CA+FuTScTcMqU4dKXNKCbjYJ8A-eVGp5eDNihAkq106YKTvTqDw@mail.gmail.com>
Message-ID: <CA+FuTScTcMqU4dKXNKCbjYJ8A-eVGp5eDNihAkq106YKTvTqDw@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: Skip set_features on non-cvq devices
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Alistair Delva <adelva@google.com>,
        Network Development <netdev@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, kernel-team@android.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 22, 2019 at 9:57 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Sun, Dec 22, 2019 at 09:21:43AM -0500, Willem de Bruijn wrote:
> > On Sun, Dec 22, 2019 at 8:11 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Fri, Dec 20, 2019 at 10:08:41PM -0500, Willem de Bruijn wrote:
> > > > On Fri, Dec 20, 2019 at 4:22 PM Alistair Delva <adelva@google.com> wrote:
> > > > >
> > > > > On devices without control virtqueue support, such as the virtio_net
> > > > > implementation in crosvm[1], attempting to configure LRO will panic the
> > > > > kernel:
> > > > >
> > > > > kernel BUG at drivers/net/virtio_net.c:1591!
> > > > > invalid opcode: 0000 [#1] PREEMPT SMP PTI
> > > > > CPU: 1 PID: 483 Comm: Binder:330_1 Not tainted 5.4.5-01326-g19463e9acaac #1
> > > > > Hardware name: ChromiumOS crosvm, BIOS 0
> > > > > RIP: 0010:virtnet_send_command+0x15d/0x170 [virtio_net]
> > > > > Code: d8 00 00 00 80 78 02 00 0f 94 c0 65 48 8b 0c 25 28 00 00 00 48 3b 4c 24 70 75 11 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <0f> 0b e8 ec a4 12 c8 66 90 66 2e 0f 1f 84 00 00 00 00 00 55 48 89
> > > > > RSP: 0018:ffffb97940e7bb50 EFLAGS: 00010246
> > > > > RAX: ffffffffc0596020 RBX: ffffa0e1fc8ea840 RCX: 0000000000000017
> > > > > RDX: ffffffffc0596110 RSI: 0000000000000011 RDI: 000000000000000d
> > > > > RBP: ffffb97940e7bbf8 R08: ffffa0e1fc8ea0b0 R09: ffffa0e1fc8ea0b0
> > > > > R10: ffffffffffffffff R11: ffffffffc0590940 R12: 0000000000000005
> > > > > R13: ffffa0e1ffad2c00 R14: ffffb97940e7bc08 R15: 0000000000000000
> > > > > FS:  0000000000000000(0000) GS:ffffa0e1fd100000(006b) knlGS:00000000e5ef7494
> > > > > CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> > > > > CR2: 00000000e5eeb82c CR3: 0000000079b06001 CR4: 0000000000360ee0
> > > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > > > Call Trace:
> > > > >  ? preempt_count_add+0x58/0xb0
> > > > >  ? _raw_spin_lock_irqsave+0x36/0x70
> > > > >  ? _raw_spin_unlock_irqrestore+0x1a/0x40
> > > > >  ? __wake_up+0x70/0x190
> > > > >  virtnet_set_features+0x90/0xf0 [virtio_net]
> > > > >  __netdev_update_features+0x271/0x980
> > > > >  ? nlmsg_notify+0x5b/0xa0
> > > > >  dev_disable_lro+0x2b/0x190
> > > > >  ? inet_netconf_notify_devconf+0xe2/0x120
> > > > >  devinet_sysctl_forward+0x176/0x1e0
> > > > >  proc_sys_call_handler+0x1f0/0x250
> > > > >  proc_sys_write+0xf/0x20
> > > > >  __vfs_write+0x3e/0x190
> > > > >  ? __sb_start_write+0x6d/0xd0
> > > > >  vfs_write+0xd3/0x190
> > > > >  ksys_write+0x68/0xd0
> > > > >  __ia32_sys_write+0x14/0x20
> > > > >  do_fast_syscall_32+0x86/0xe0
> > > > >  entry_SYSENTER_compat+0x7c/0x8e
> > > > >
> > > > > This happens because virtio_set_features() does not check the presence
> > > > > of the control virtqueue feature, which is sanity checked by a BUG_ON
> > > > > in virtnet_send_command().
> > > > >
> > > > > Fix this by skipping any feature processing if the control virtqueue is
> > > > > missing. This should be OK for any future feature that is added, as
> > > > > presumably all of them would require control virtqueue support to notify
> > > > > the endpoint that offload etc. should begin.
> > > > >
> > > > > [1] https://chromium.googlesource.com/chromiumos/platform/crosvm/
> > > > >
> > > > > Fixes: a02e8964eaf9 ("virtio-net: ethtool configurable LRO")
> > > > > Cc: stable@vger.kernel.org [4.20+]
> > > > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > > > Cc: Jason Wang <jasowang@redhat.com>
> > > > > Cc: David S. Miller <davem@davemloft.net>
> > > > > Cc: kernel-team@android.com
> > > > > Cc: virtualization@lists.linux-foundation.org
> > > > > Cc: linux-kernel@vger.kernel.org
> > > > > Signed-off-by: Alistair Delva <adelva@google.com>
> > > >
> > > > Thanks for debugging this, Alistair.
> > > >
> > > > > ---
> > > > >  drivers/net/virtio_net.c | 3 +++
> > > > >  1 file changed, 3 insertions(+)
> > > > >
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index 4d7d5434cc5d..709bcd34e485 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -2560,6 +2560,9 @@ static int virtnet_set_features(struct net_device *dev,
> > > > >         u64 offloads;
> > > > >         int err;
> > > > >
> > > > > +       if (!vi->has_cvq)
> > > > > +               return 0;
> > > > > +
> > > >
> > > > Instead of checking for this in virtnet_set_features, how about we
> > > > make configurability contingent on cvq in virtnet_probe:
> > > >
> > > > -       if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> > > > +       if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS) &&
> > > > +           virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
> > > >                 dev->hw_features |= NETIF_F_LRO;
> > > >
> > > > Based on this logic a little below in the same function
> > > >
> > > >         if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
> > > >                 vi->has_cvq = true;
> > >
> > >
> > > This would be a regression on old hypervisors which didn't have
> > > CTL VQ - suddenly they will lose offloads.
> >
> > dev->features still correctly displays whether offloads are enabled.
> > Removing it from dev->hw_features just renders it non-configurable.
>
> Oh you are right. I confused it with dev->features.
>
> > Note that before the patch that is being fixed the offloads were
> > enabled, but ethtool would show them as off.
>
> So the bug is in spec, it should have said
> VIRTIO_NET_F_CTRL_GUEST_OFFLOADS depends on VIRTIO_NET_F_CTRL_VQ, but we
> missed that part. We can and I guess should add this as a recommendation
> but it's too late to make it a MUST.
>
> Meanwhile I would say it's cleanest to work around
> this in virtnet_validate by clearing VIRTIO_NET_F_CTRL_GUEST_OFFLOADS
> if VIRTIO_NET_F_CTRL_VQ is off, with a big comment explaining
> it's a spec bug.

Wouldn't that cause precisely the regression you were concerned about?

Workloads may now depend on LRO for cycle efficiency. Reverting to
behavior before this patch (though now displaying the offload state
correctly) is more conservative in that regard.
