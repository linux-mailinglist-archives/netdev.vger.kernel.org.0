Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414CA3D70B4
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 09:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbhG0H7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 03:59:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43233 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235629AbhG0H7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 03:59:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627372793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/EIq4hrAP0Ac0pX1HeyNfiwT/0BIOEO0auXFwtqoKwk=;
        b=RzWYwwJW0HI5LovkIL/n3eKTaJxruFQFZsnR+6nAOLc2j7Rglx9g3B3OO8/iwDMO3JJluO
        bF9JqQ1V+P0JXy/QYLC698r4I7KJ8h8D419mWyLo6CPGB4Ma8XiPupjqQ/cqL7TbSRhrfT
        0m1snXyA+r3o2E6pOolbXbCf7ywX2q0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-8a9cP3HBP_SJ2zaWxxCGmA-1; Tue, 27 Jul 2021 03:59:52 -0400
X-MC-Unique: 8a9cP3HBP_SJ2zaWxxCGmA-1
Received: by mail-ej1-f70.google.com with SMTP id n9-20020a1709063789b02905854bda39fcso1182351ejc.1
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 00:59:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/EIq4hrAP0Ac0pX1HeyNfiwT/0BIOEO0auXFwtqoKwk=;
        b=l6bLJQO3LXYh3MkK94swT3iUBMlXQmL2fjw5HV021jzptXgpMRjFFAgFAaFjNBm3GS
         +yKMEfbgoJGzm6JCM6fVqgX5ZXyLhE3aQGsSWBWwyB4JdfE8Rd2j/ystsunrjdDmd0SI
         UldL/xQytx5+3CyciSMuxei7ZEZD+Zb7W4PSZ4PgKbxFhkYfC34BEAsIMOU+pmhBrC+D
         xNEPGc9vqHEJ8JZ7sSPDVmUCMgaXN3EjkVwthAfAEr3tmCEfAw6rVUzMXxszBLkUYUg7
         PfdA8eRiq1VHxqxwciv64N0cvKFx0uaY6HO1kkmR729D084wX74pgFAWYL745M3iqhDF
         Q4Iw==
X-Gm-Message-State: AOAM531BwaGH6Ke3ZLsU/jDwdehqtJ8qWVvTZcn47RWZtgeHjmgLI4L7
        oXSIRLVXWvlTMoFy+KTX5/l1oawQSPYkAb2ygCeYlcbXPQ7I6xotRqj30C5BT3dEiGUGYEfD1RG
        9/QOes/S9dQiWQdvO
X-Received: by 2002:a05:6402:12c3:: with SMTP id k3mr11211301edx.11.1627372791441;
        Tue, 27 Jul 2021 00:59:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlCvS56tYgLWOzqJ8Wh70Fht2s02iJ7M5DydMmq9uVJaSBBqYQBS2qw7251aRYo+dt+iun8A==
X-Received: by 2002:a05:6402:12c3:: with SMTP id k3mr11211285edx.11.1627372791319;
        Tue, 27 Jul 2021 00:59:51 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id i14sm613214eja.91.2021.07.27.00.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 00:59:50 -0700 (PDT)
Date:   Tue, 27 Jul 2021 09:59:48 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1 0/7] virtio/vsock: introduce MSG_EOR flag for
 SEQPACKET
Message-ID: <20210727075948.yl4w3foqa6rp4obg@steredhat>
References: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 07:31:33PM +0300, Arseny Krasnov wrote:
>	This patchset implements support of MSG_EOR bit for SEQPACKET
>AF_VSOCK sockets over virtio transport.
>	Idea is to distinguish concepts of 'messages' and 'records'.
>Message is result of sending calls: 'write()', 'send()', 'sendmsg()'
>etc. It has fixed maximum length, and it bounds are visible using
>return from receive calls: 'read()', 'recv()', 'recvmsg()' etc.
>Current implementation based on message definition above.
>	Record has unlimited length, it consists of multiple message,
>and bounds of record are visible via MSG_EOR flag returned from
>'recvmsg()' call. Sender passes MSG_EOR to sending system call and
>receiver will see MSG_EOR when corresponding message will be processed.
>	To support MSG_EOR new bit was added along with existing
>'VIRTIO_VSOCK_SEQ_EOR': 'VIRTIO_VSOCK_SEQ_EOM'(end-of-message) - now it
>works in the same way as 'VIRTIO_VSOCK_SEQ_EOR'. But 'VIRTIO_VSOCK_SEQ_EOR'
>is used to mark 'MSG_EOR' bit passed from userspace.

At this point it's probably better to rename the old flag, so we stay 
compatible.

What happens if one of the two peers does not support MSG_EOR handling, 
while the other does?

I'll do a closer review in the next few days.

Thanks,
Stefano

