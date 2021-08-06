Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AECB3E265A
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 10:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243678AbhHFIsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 04:48:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24950 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243610AbhHFIsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 04:48:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628239677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uIBiZswclAmZAKEwOl2WxxnVqDtJu5o7jYDul8dvWmY=;
        b=MYbKyuMBYOp1zrhYcod/BvIYXXLLnXEdP/YZISXm07ci1tMy2ycl3k00OUZcw8BGciAuV1
        LZKSoBtNC/4YZgnQBj5v1NWxoNM1+vgIvravNrRZY0F05m1R4IF9FkS4jn2+VC72QPiN2W
        3P3I2eqWpnzqWIU8Xsxg/nkKhamYRIY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-UnXMmSgZOri2cHHO13-wtg-1; Fri, 06 Aug 2021 04:47:56 -0400
X-MC-Unique: UnXMmSgZOri2cHHO13-wtg-1
Received: by mail-ej1-f71.google.com with SMTP id zp23-20020a17090684f7b02905a13980d522so2931841ejb.2
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 01:47:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uIBiZswclAmZAKEwOl2WxxnVqDtJu5o7jYDul8dvWmY=;
        b=hu1yNn5UpF8NPWRBjSDpnM2e9E2xmlE76NwDepJz0lRySWtP6Z32l8AYGkhe1fFrjy
         5nsTYkGvtf/wOGLA0Evg9R+7KJTZ/UjoUpfcX5m3oJ3qLQ1DNk8WmZOmHeXMgShEeuM9
         3fuRFrEiyUfLy8R80b2K12QX9n4Bu0xNIrsVu5fAKJraE+b+P/nZ+JeoBz38jzQo5VVT
         B09bi98wJsyTe1HysIi7p7uIbuGxwvfIyR4LRtj+x0e6GFe0RgoBJvo9XV3btMVCzfJY
         yd8b1D6XLDu3nqepcSXEtxVXlJe/tFxfpGCyDTmKG64mXeWqjZVWX0/8zUumHFxL2Tx3
         zbRg==
X-Gm-Message-State: AOAM531TZbZASByRVtDZuc2SSfkMLWeXrKV9VuoMWPgjnLxfuab6RzqI
        p9qBsCjYXjbvlk22rgMTsaHCJzCzc03sj8UTQ/GysR1EI3cXvxLRVzYaGje/YjYvGTJrR0tCPZr
        4z6/Nu3dcXZsGLsXi
X-Received: by 2002:a05:6402:18c1:: with SMTP id x1mr11474518edy.145.1628239675035;
        Fri, 06 Aug 2021 01:47:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTd0o4WvYl5mo4LnOpxaZnn897ViX2mbmfnK91Gcgr5jxHNl8+wZOELsM+8EHXJ3B1tc7yGA==
X-Received: by 2002:a05:6402:18c1:: with SMTP id x1mr11474504edy.145.1628239674906;
        Fri, 06 Aug 2021 01:47:54 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id w13sm3610023ede.24.2021.08.06.01.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 01:47:54 -0700 (PDT)
Date:   Fri, 6 Aug 2021 10:47:52 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 3/7] vhost/vsock: support MSG_EOR bit processing
Message-ID: <20210806084752.vzzucocjg3wvpukr@steredhat>
References: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
 <20210726163341.2589759-1-arseny.krasnov@kaspersky.com>
 <20210806072849.4by3wbdkg2bsierm@steredhat>
 <40a1d508-c841-23b7-58d5-f539b2d98ae1@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <40a1d508-c841-23b7-58d5-f539b2d98ae1@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 06, 2021 at 11:40:38AM +0300, Arseny Krasnov wrote:
>
>On 06.08.2021 10:28, Stefano Garzarella wrote:
>> Caution: This is an external email. Be cautious while opening links or attachments.
>>
>>
>>
>> On Mon, Jul 26, 2021 at 07:33:38PM +0300, Arseny Krasnov wrote:
>>> It works in the same way as 'end-of-message' bit: if packet has
>>> 'EOM' bit, also check for 'EOR' bit.
>>>
>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>> ---
>>> drivers/vhost/vsock.c | 12 +++++++++++-
>>> 1 file changed, 11 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>>> index 3b55de70ac77..3e2b150f9c6f 100644
>>> --- a/drivers/vhost/vsock.c
>>> +++ b/drivers/vhost/vsock.c
>>> @@ -115,6 +115,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>>               size_t iov_len, payload_len;
>>>               int head;
>>>               bool restore_msg_eom_flag = false;
>>> +              bool restore_msg_eor_flag = false;
>> Since we now have 2 flags to potentially restore, we could use a single
>> variable (e.g. uint32_t flags_to_restore), initialized to 0.
>>
>> We can set all the flags we need to restore and then simply put it
>> in or with the `pkt->hdr.flags` field.
>>
>>>               spin_lock_bh(&vsock->send_pkt_list_lock);
>>>               if (list_empty(&vsock->send_pkt_list)) {
>>> @@ -188,6 +189,11 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>>                       if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
>>>                               pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>>>                               restore_msg_eom_flag = true;
>>> +
>>> +                              if (le32_to_cpu(pkt->hdr.flags & VIRTIO_VSOCK_SEQ_EOR)) {
>>                                                                 ^
>> Here it should be `le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR`
>>
>>> +                                      pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>>> +                                      restore_msg_eor_flag = true;
>>> +                              }
>>>                       }
>>>               }
>>>
>>> @@ -224,9 +230,13 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>>                * to send it with the next available buffer.
>>>                */
>>>               if (pkt->off < pkt->len) {
>>> -                      if (restore_msg_eom_flag)
>>> +                      if (restore_msg_eom_flag) {
>>>                               pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>>>
>>> +                              if (restore_msg_eor_flag)
>>> +                                      pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>>> +                      }
>>> +
>> If we use a single variable, here we can simply do:
>>
>>                         pkt->hdr.flags |= cpu_to_le32(flags_to_restore);
>>
>> Stefano
>
>Thanks, i'll prepare v2 both with spec patch. About spec: i've already sent
>
>patch for SEQPACKET, can i prepare spec patch updating current reviewed
>
>SEQPACKET? E.g. i'll include both EOM and EOR in one patch.

Yep, since spec is not yet merged, I think make sense to have all 
seqpacket stuff in a single patch.

Thanks,
Stefano

