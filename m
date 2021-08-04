Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87753E017B
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 14:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238215AbhHDM6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 08:58:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40599 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236732AbhHDM57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 08:57:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628081866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0/bO+MgPDOUvO02RQ1/ITQ19fPYuZ/wXOCdSbbV0LTs=;
        b=Sjgg8Ao0Trwp81RWAEPO0dUa7lOoKtZ5BPnl5k5yKQcH8T+vSPrBkFoHqrXRBlkpK1rc/W
        LgdrACJHyhl/AzIWpOknBraAU0v3e4HYCR6tqi51v5JlorUmzctOpmAv7X+iY8WjSpOO4k
        ntoLJOAP/OhitVXgn7Vgcenpi4P5KR4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-HFs6mxSZPjmqFINjIU8n-w-1; Wed, 04 Aug 2021 08:57:45 -0400
X-MC-Unique: HFs6mxSZPjmqFINjIU8n-w-1
Received: by mail-ed1-f72.google.com with SMTP id y19-20020a0564021713b02903bbfec89ebcso1390601edu.16
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 05:57:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0/bO+MgPDOUvO02RQ1/ITQ19fPYuZ/wXOCdSbbV0LTs=;
        b=p5+6VcYqEYt6Ul1ec1KF6gjK5LLIgrfpN9lsN5l2yTTfA/UQNEgPKWYxycq3/jwmn8
         BZAtq34UPFEhGE8442LQtI+VvKiNPH6FDomUsMUt3oT8R/UMTUaf2tbQq+b9VwPcBtLU
         7z7Vrlw7AS7og8H9lk3fcjw+3+yoQtaAfb0JGupzvuhb1oa8xrWJc9oP0xiNhW9Ft6Tn
         UyDzaRjf5bbEWd5VZEwC3fyYykkxo3iXEIrQ0qaX7rVw1XdDgNBafL3aNwkUvrZbmL0x
         qETlcNGGTsAyXu3Xp5n/N20+nSnhY3rtsEdOr9lVLlSqEdsy14gKF1Lrb80AxLeViDeJ
         X+fA==
X-Gm-Message-State: AOAM530n/zzpsnZYfSmlirMi30uhw+T+sdo0QnZD2rgRsdZB95oG2u8A
        PyK6fY3GjzY8S0xfUONR0IeZwFTJF0T9aUuO/H05ZBrBr0R49dulxgVL66pO7efjSrW24cUCRXw
        ppDHKwM/WBWB2cSgb
X-Received: by 2002:a17:906:c085:: with SMTP id f5mr26109121ejz.250.1628081864048;
        Wed, 04 Aug 2021 05:57:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiZNmhNR8yr3j+9pHq54LbMN6zvfVQtndDuehBDERZ/x4tZYc2Uu210Q95TZ8Abyb0Xl5IzQ==
X-Received: by 2002:a17:906:c085:: with SMTP id f5mr26109096ejz.250.1628081863868;
        Wed, 04 Aug 2021 05:57:43 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id n11sm666345ejg.111.2021.08.04.05.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 05:57:43 -0700 (PDT)
Date:   Wed, 4 Aug 2021 14:57:37 +0200
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
Message-ID: <20210804125737.kbgc6mg2v5lw25wu@steredhat>
References: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseny,

On Mon, Jul 26, 2021 at 07:31:33PM +0300, Arseny Krasnov wrote:
>	This patchset implements support of MSG_EOR bit for SEQPACKET
>AF_VSOCK sockets over virtio transport.
>	Idea is to distinguish concepts of 'messages' and 'records'.
>Message is result of sending calls: 'write()', 'send()', 'sendmsg()'
>etc. It has fixed maximum length, and it bounds are visible using
>return from receive calls: 'read()', 'recv()', 'recvmsg()' etc.
>Current implementation based on message definition above.

Okay, so the implementation we merged is wrong right?
Should we disable the feature bit in stable kernels that contain it? Or 
maybe we can backport the fixes...

>	Record has unlimited length, it consists of multiple message,
>and bounds of record are visible via MSG_EOR flag returned from
>'recvmsg()' call. Sender passes MSG_EOR to sending system call and
>receiver will see MSG_EOR when corresponding message will be processed.
>	To support MSG_EOR new bit was added along with existing
>'VIRTIO_VSOCK_SEQ_EOR': 'VIRTIO_VSOCK_SEQ_EOM'(end-of-message) - now it
>works in the same way as 'VIRTIO_VSOCK_SEQ_EOR'. But 'VIRTIO_VSOCK_SEQ_EOR'
>is used to mark 'MSG_EOR' bit passed from userspace.

I understand that it makes sense to remap VIRTIO_VSOCK_SEQ_EOR to 
MSG_EOR to make the user understand the boundaries, but why do we need 
EOM as well?

Why do we care about the boundaries of a message within a record?
I mean, if the sender makes 3 calls:
     send(A1,0)
     send(A2,0)
     send(A3, MSG_EOR);

IIUC it should be fine if the receiver for example receives all in one 
single recv() calll with MSG_EOR set, so why do we need EOM?

Thanks,
Stefano

