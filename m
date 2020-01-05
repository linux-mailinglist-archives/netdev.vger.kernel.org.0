Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8406E13082A
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 14:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgAENLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 08:11:55 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39031 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726260AbgAENLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 08:11:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578229913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iyYUzIHEBzvMmT9xAB0gUkIWrPMEuu7IviISm1YnXRw=;
        b=Jrg5AMR7AhXgI3YS4Ge3ezsBy1bf/uMcdRXaQ9U1K3A7FAR8edhaaFhdpVjMeZuyGqun/v
        kth+s57WEujP3a54Bfu+n1/nN6ZBV8bfLDU5cIEYnEdQo7wDwqDvXDwdG69sZzmvaN5o1X
        S+Poi2/eUTwcMftWPiroJ8C6rXBdxB4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-Ln-Pp-YVMkO9gO97-WRHjg-1; Sun, 05 Jan 2020 08:11:51 -0500
X-MC-Unique: Ln-Pp-YVMkO9gO97-WRHjg-1
Received: by mail-qt1-f198.google.com with SMTP id r9so8065927qtc.4
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 05:11:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iyYUzIHEBzvMmT9xAB0gUkIWrPMEuu7IviISm1YnXRw=;
        b=PuDqDJ6YybDrxfaVSnCXzmiOC/qbuOQH8xDRoWfp+Gqkzv7/BocvcoJmD1oGv+RBRZ
         YTLrT272fEgvIE+M4+3JPWn78zzUpdyku16VLGDNoUmOYE5s5JDugxPsKFUmvw3Fnt90
         GOnltPvA/P5DHLXGE/VSR2CjpNFCPzMIhuWMrJNjMtDiMgSZGOUQo8674h/IWQENxZPz
         PRLMG841OBr/k0NoIodaHZAnTbaonL/3os/dktLJmyso6V02ebDwQ2feHddlYoIBSoCd
         MDUWNnWqyJ7/YMRkIhQUYHRJ0lAe/06D/096FypuNUTuaAD0tfpuf/M361Y8a85D89t+
         wc7g==
X-Gm-Message-State: APjAAAWgq0PxsZNBYoNBnXgsyXuLGV5fyy4UKTYJsozC4WY6MIeJnz2H
        W2N6QQ7XDQFrmgeJ6C2aDgVp5Bh1GlrJwTup2e78e8oUPFmHy/+tTgcBVqTuIEqZ/SMLhxLh9q8
        a3nqxGXQC6VgJn4AI
X-Received: by 2002:a37:4b8b:: with SMTP id y133mr78104278qka.210.1578229909728;
        Sun, 05 Jan 2020 05:11:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqwrCL6RBFjmX9xJsJ45MZDzlT2zeFXkFnFsnHGjIbM3E+IYUvdGdsKolBDECkX6lm0VqOHfQQ==
X-Received: by 2002:a37:4b8b:: with SMTP id y133mr78104255qka.210.1578229909431;
        Sun, 05 Jan 2020 05:11:49 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id v4sm21599657qtd.24.2020.01.05.05.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2020 05:11:48 -0800 (PST)
Date:   Sun, 5 Jan 2020 08:11:43 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alistair Delva <adelva@google.com>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, kernel-team@android.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] virtio-net: Skip set_features on non-cvq devices
Message-ID: <20200105081111-mutt-send-email-mst@kernel.org>
References: <20191220212207.76726-1-adelva@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220212207.76726-1-adelva@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 01:22:07PM -0800, Alistair Delva wrote:
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
> ---
>  drivers/net/virtio_net.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 4d7d5434cc5d..709bcd34e485 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2560,6 +2560,9 @@ static int virtnet_set_features(struct net_device *dev,
>  	u64 offloads;
>  	int err;
>  
> +	if (!vi->has_cvq)
> +		return 0;
> +

So should this return an error then?

>  	if ((dev->features ^ features) & NETIF_F_LRO) {
>  		if (vi->xdp_queue_pairs)
>  			return -EBUSY;
> -- 
> 2.24.1.735.g03f4e72817-goog

