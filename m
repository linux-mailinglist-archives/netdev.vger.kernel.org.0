Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D99E129CE8
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 03:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfLXCt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 21:49:28 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26894 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726747AbfLXCt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 21:49:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577155766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wtq5rKsoH6y7TIQT6lpoljI1w2wwhhEx65ky24Nv240=;
        b=VRmWxe3FstFewDNjfTpD2qSypDHSmqWkQU51NCx8ClvHn8sSx1XJrGBLha7F3n7+1Fk8IF
        /u2QU5xNvsx7R8T9QlB+yXzgYaSgA+OCrL0cfteQuhgKzQxMOVUMqpuUXSn+QDBhDmvZqz
        DkZ81XBSfGdUWC4EqffwljVhvcL9hvo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-ypBO3qiaOsquqvPziG1gxQ-1; Mon, 23 Dec 2019 21:49:22 -0500
X-MC-Unique: ypBO3qiaOsquqvPziG1gxQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97339477;
        Tue, 24 Dec 2019 02:49:21 +0000 (UTC)
Received: from [10.72.12.236] (ovpn-12-236.pek2.redhat.com [10.72.12.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FD6860BA0;
        Tue, 24 Dec 2019 02:49:15 +0000 (UTC)
Subject: Re: [PATCH net] virtio_net: CTRL_GUEST_OFFLOADS depends on CTRL_VQ
To:     Alistair Delva <adelva@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
References: <20191223140322.20013-1-mst@redhat.com>
 <CANDihLHPk5khpv-f-M+qhkzgTkygAts38GGb-HChg-VL2bo+Uw@mail.gmail.com>
 <CA+FuTSfq5v3-0VYmTG7YFFUqT8uG53eXXhqc8WvVvMbp3s0nvA@mail.gmail.com>
 <CA+FuTScwwajN2ny2w8EBkBQd191Eb1ZsrRhbh3=5eQervArnEA@mail.gmail.com>
 <CANDihLFv+DJYOD1m_Z3CKuxoXG-z4zPy_Tc2eoggq1KRo+GeWw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ea5131fc-cda6-c773-73fc-c862be6ecb7b@redhat.com>
Date:   Tue, 24 Dec 2019 10:49:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CANDihLFv+DJYOD1m_Z3CKuxoXG-z4zPy_Tc2eoggq1KRo+GeWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/12/24 =E4=B8=8A=E5=8D=884:21, Alistair Delva wrote:
> On Mon, Dec 23, 2019 at 12:12 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
>> On Mon, Dec 23, 2019 at 2:56 PM Willem de Bruijn
>> <willemdebruijn.kernel@gmail.com> wrote:
>>> 00fffe0ff0 DR7: 0000000000000400
>>>>> Call Trace:
>>>>>   ? preempt_count_add+0x58/0xb0
>>>>>   ? _raw_spin_lock_irqsave+0x36/0x70
>>>>>   ? _raw_spin_unlock_irqrestore+0x1a/0x40
>>>>>   ? __wake_up+0x70/0x190
>>>>>   virtnet_set_features+0x90/0xf0 [virtio_net]
>>>>>   __netdev_update_features+0x271/0x980
>>>>>   ? nlmsg_notify+0x5b/0xa0
>>>>>   dev_disable_lro+0x2b/0x190
>>>>>   ? inet_netconf_notify_devconf+0xe2/0x120
>>>>>   devinet_sysctl_forward+0x176/0x1e0
>>>>>   proc_sys_call_handler+0x1f0/0x250
>>>>>   proc_sys_write+0xf/0x20
>>>>>   __vfs_write+0x3e/0x190
>>>>>   ? __sb_start_write+0x6d/0xd0
>>>>>   vfs_write+0xd3/0x190
>>>>>   ksys_write+0x68/0xd0
>>>>>   __ia32_sys_write+0x14/0x20
>>>>>   do_fast_syscall_32+0x86/0xe0
>>>>>   entry_SYSENTER_compat+0x7c/0x8e
>>>>>
>>>>> A similar crash will likely trigger when enabling XDP.
>>>>>
>>>>> Reported-by: Alistair Delva <adelva@google.com>
>>>>> Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
>>>>> Fixes: 3f93522ffab2 ("virtio-net: switch off offloads on demand if =
possible on XDP set")
>>>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>>>> ---
>>>>>
>>>>> Lightly tested.
>>>>>
>>>>> Alistair, could you please test and confirm that this resolves the
>>>>> crash for you?
>>>> This patch doesn't work. The reason is that NETIF_F_LRO is also turn=
ed
>>>> on by TSO4/TSO6, which your patch didn't check for. So it ends up
>>>> going through the same path and crashing in the same way.
>>>>
>>>>          if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
>>>>              virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
>>>>                  dev->features |=3D NETIF_F_LRO;
>>>>
>>>> It sounds like this patch is fixing something slightly differently t=
o
>>>> my patch fixed. virtnet_set_features() doesn't care about
>>>> GUEST_OFFLOADS, it only tests against NETIF_F_LRO. Even if "offloads=
"
>>>> is zero, it will call virtnet_set_guest_offloads(), which triggers t=
he
>>>> crash.
>>>
>>> Interesting. It's surprising that it is trying to configure a flag
>>> that is not configurable, i.e., absent from dev->hw_features
>>> after Michael's change.
>>>
>>>> So either we need to ensure NETIF_F_LRO is never set, or
>>> LRO might be available, just not configurable. Indeed this was what I
>>> observed in the past.
>> dev_disable_lro expects that NETIF_F_LRO is always configurable. Which
>> I guess is a reasonable assumption, just not necessarily the case in
>> virtio_net.
>>
>> So I think we need both patches. Correctly mark the feature as fixed
>> by removing from dev->hw_features and also ignore the request from
>> dev_disable_lro, which does not check for this.
> Something like this maybe:
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 4d7d5434cc5d..0556f42b0fb5 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2560,6 +2560,9 @@ static int virtnet_set_features(struct net_device=
 *dev,
>          u64 offloads;
>          int err;
>
> +       if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLO=
ADS))
> +               return 0;
> +
>          if ((dev->features ^ features) & NETIF_F_LRO) {
>                  if (vi->xdp_queue_pairs)
>                          return -EBUSY;
> @@ -2971,6 +2974,15 @@ static int virtnet_validate(struct virtio_device=
 *vdev)
>          if (!virtnet_validate_features(vdev))
>                  return -EINVAL;
>
> +       /* VIRTIO_NET_F_CTRL_GUEST_OFFLOADS does not work without
> +        * VIRTIO_NET_F_CTRL_VQ. However the virtio spec does not
> +        * specify that VIRTIO_NET_F_CTRL_GUEST_OFFLOADS depends
> +        * on VIRTIO_NET_F_CTRL_VQ so devices can set the later but
> +        * not the former.
> +        */
> +       if (!virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
> +               __virtio_clear_bit(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOA=
DS);
> +
>          if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
>                  int mtu =3D virtio_cread16(vdev,
>                                           offsetof(struct virtio_net_co=
nfig,
>

We check feature dependency and fail the probe in=20
virtnet_validate_features().

Is it more straightforward to fail the probe there when=20
CTRL_GUEST_OFFLOADS was set but CTRL_VQ wasn't?

Thanks

