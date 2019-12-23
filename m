Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9D6129A9F
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 20:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfLWT50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 14:57:26 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:33090 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbfLWT50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 14:57:26 -0500
Received: by mail-yb1-f194.google.com with SMTP id n66so7469302ybg.0
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 11:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bb0+CNEtJ6KzyS3XvioZczGP2IemYKNu32wQAAEeIB8=;
        b=Yl084XD682EiZs1AIWmB7fpotrIpfWyb7NpNE13yI5PFnb6G9qiBMQnkvnnH9x60pn
         /4pB4HLcZ4d4nXqAs1Ln570UVdpINIwDpJllGfkvgbjKOIFf+gH0LQn7m/r6QKgg3tLe
         thKS93BdFAkhh8yrejEu0K4eIkb6wW3XiiVUpx1oq1JA3fhRwHgATHTrqdUKLbW2i+F3
         e54zL1rdaOl7Mf8m3jqLcqnpx03vch9VBhKB7bYfeX4qIsoQlGK0zHIoH90Eole8B2sz
         JXC4jRWnxQhG1QO6Sup1fSYaGzVSQpLknqZSWct0a8yWswXmvV8wA/BSiVKsFBFLLgGU
         akNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bb0+CNEtJ6KzyS3XvioZczGP2IemYKNu32wQAAEeIB8=;
        b=LhYn4Rs4BbWIk64ufhUAf2KVQNr01LnXVQJC6apo5W4DkW2gDC1vjdYGXXN7kcFuHV
         ze99xcFd/grLVx2oNbsJoec4+4/4OesB27h11k0limtbzHlu71NccqyeDa84sGRoFUI6
         age8tSYIhL5rwiNZD8P2pGVICNIyFMZcZPKVAKGYsRJV3DF9CjAz0c1zy/Of963hmyy7
         bXuphiak1gsdK5tf9bFQ2FaGWJgWzBLXz1t/LSgFtmoWwzsq4ZVEENedVI17KKj8Mjfe
         l9lUk/lS7evPy5cKkqb0jgU3gjdO7Kzfl0gEmxv69b4BlX7B6s5/Hyo4JbB0LmknFRNG
         N2vw==
X-Gm-Message-State: APjAAAWfTH/IBhQ0YwrHNo25F5Oj2emudpdn5ik1eQKdWidghcvE+WbN
        S4d1x/XPXB/PEqNRyHI9WorVhBm/
X-Google-Smtp-Source: APXvYqxrupPHJkEPM01BDxMSlvP8kLfbFBvwS6FQZmaH62EMckqbQtHlreX3f/HpIw9wxfcjzLxo1A==
X-Received: by 2002:a5b:38e:: with SMTP id k14mr21514630ybp.522.1577131044776;
        Mon, 23 Dec 2019 11:57:24 -0800 (PST)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id p1sm8989884ywh.74.2019.12.23.11.57.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2019 11:57:24 -0800 (PST)
Received: by mail-yb1-f181.google.com with SMTP id k17so2905914ybp.1
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 11:57:23 -0800 (PST)
X-Received: by 2002:a25:d117:: with SMTP id i23mr16560523ybg.139.1577131043349;
 Mon, 23 Dec 2019 11:57:23 -0800 (PST)
MIME-Version: 1.0
References: <20191223140322.20013-1-mst@redhat.com> <CANDihLHPk5khpv-f-M+qhkzgTkygAts38GGb-HChg-VL2bo+Uw@mail.gmail.com>
In-Reply-To: <CANDihLHPk5khpv-f-M+qhkzgTkygAts38GGb-HChg-VL2bo+Uw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 23 Dec 2019 14:56:47 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfq5v3-0VYmTG7YFFUqT8uG53eXXhqc8WvVvMbp3s0nvA@mail.gmail.com>
Message-ID: <CA+FuTSfq5v3-0VYmTG7YFFUqT8uG53eXXhqc8WvVvMbp3s0nvA@mail.gmail.com>
Subject: Re: [PATCH net] virtio_net: CTRL_GUEST_OFFLOADS depends on CTRL_VQ
To:     Alistair Delva <adelva@google.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

00fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  ? preempt_count_add+0x58/0xb0
> >  ? _raw_spin_lock_irqsave+0x36/0x70
> >  ? _raw_spin_unlock_irqrestore+0x1a/0x40
> >  ? __wake_up+0x70/0x190
> >  virtnet_set_features+0x90/0xf0 [virtio_net]
> >  __netdev_update_features+0x271/0x980
> >  ? nlmsg_notify+0x5b/0xa0
> >  dev_disable_lro+0x2b/0x190
> >  ? inet_netconf_notify_devconf+0xe2/0x120
> >  devinet_sysctl_forward+0x176/0x1e0
> >  proc_sys_call_handler+0x1f0/0x250
> >  proc_sys_write+0xf/0x20
> >  __vfs_write+0x3e/0x190
> >  ? __sb_start_write+0x6d/0xd0
> >  vfs_write+0xd3/0x190
> >  ksys_write+0x68/0xd0
> >  __ia32_sys_write+0x14/0x20
> >  do_fast_syscall_32+0x86/0xe0
> >  entry_SYSENTER_compat+0x7c/0x8e
> >
> > A similar crash will likely trigger when enabling XDP.
> >
> > Reported-by: Alistair Delva <adelva@google.com>
> > Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > Fixes: 3f93522ffab2 ("virtio-net: switch off offloads on demand if possible on XDP set")
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >
> > Lightly tested.
> >
> > Alistair, could you please test and confirm that this resolves the
> > crash for you?
>
> This patch doesn't work. The reason is that NETIF_F_LRO is also turned
> on by TSO4/TSO6, which your patch didn't check for. So it ends up
> going through the same path and crashing in the same way.
>
>         if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
>             virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
>                 dev->features |= NETIF_F_LRO;
>
> It sounds like this patch is fixing something slightly differently to
> my patch fixed. virtnet_set_features() doesn't care about
> GUEST_OFFLOADS, it only tests against NETIF_F_LRO. Even if "offloads"
> is zero, it will call virtnet_set_guest_offloads(), which triggers the
> crash.


Interesting. It's surprising that it is trying to configure a flag
that is not configurable, i.e., absent from dev->hw_features
after Michael's change.

> So either we need to ensure NETIF_F_LRO is never set, or

LRO might be available, just not configurable. Indeed this was what I
observed in the past.
