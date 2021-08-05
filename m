Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44A93E10D5
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 11:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239185AbhHEJHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 05:07:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51409 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239014AbhHEJHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 05:07:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628154423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KYnPAindt7gqrNcKUm5J79oEdrV+LI995OyYx3zHpCI=;
        b=ZtmXb7aTYAlVyxac1+joBlvD0XkzBAfNtCyne/AnPGXaKB4YjMb7SwRYYuJof97+MshKgT
        XCOCVziZPUHSdtQBj6qzrzBup51n0IwStUbQ2DErRxy6Rjno3rB8LylHVasmMFxWrSym63
        pgshB86UsmzxC0aikiuJplp10uNevCo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-V5g5IEcyP56z7YtowY186g-1; Thu, 05 Aug 2021 05:07:02 -0400
X-MC-Unique: V5g5IEcyP56z7YtowY186g-1
Received: by mail-ej1-f69.google.com with SMTP id e8-20020a1709060808b02904f7606bd58fso1818190ejd.11
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 02:07:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KYnPAindt7gqrNcKUm5J79oEdrV+LI995OyYx3zHpCI=;
        b=D1xM6jkhFd/XY45POqbJfcjx+TwEXp2QsrdZB4N0RivxpG2RJ7Jm5EF+qgZpY0Vxwz
         GqEZq/ZI2IYui7j5aCXSHZMDDJ/vHJCc84jjIByxeLHO4iuxzdcRCy+pcN1+cgAuZ9T1
         gEYgvwn0FTdxoVW82v1oFEv/gqNNkqmEu8ljZQ182/7jYH245dB3xTvq0YjchL+IYZYl
         3ReYaTGAZvxZ2sWXWF7HWT+5zWcxVb6DAcFHZBk5A01aa3clY/gPHUhuL2sX8rxCu1c4
         atAvQA3/+urprllz/1Vd56+BvDlXcYeuxRCl5mcp6xYfB3fSSenr68pYFo17Un/btf8u
         7OFw==
X-Gm-Message-State: AOAM530siHI2wJnJGtg5Hlm06EMZY/ogayTDm6Q4Y0lRU8vBFYPINhDA
        TsdIS9TZPUsFYqEEWCG5aBYbpa5+KRmHjBxXrcKWDzbsSMOJHNp3dQupt1D2FDuzG5+TSPetdJ4
        +QRimKPRAazEHqtwh
X-Received: by 2002:a05:6402:6cb:: with SMTP id n11mr5231282edy.112.1628154420098;
        Thu, 05 Aug 2021 02:07:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAbJ7jQEOwJQWtXjn6en2nBVwYWl56AzaGjrhqay1J4fO2ol2L+YJReWWqxkCDxYEG9cHRUg==
X-Received: by 2002:a05:6402:6cb:: with SMTP id n11mr5231265edy.112.1628154419930;
        Thu, 05 Aug 2021 02:06:59 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id b25sm2018211edv.9.2021.08.05.02.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 02:06:59 -0700 (PDT)
Date:   Thu, 5 Aug 2021 11:06:57 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 0/7] virtio/vsock: introduce MSG_EOR flag for
 SEQPACKET
Message-ID: <20210805090657.y2sz3pzhruuolncq@steredhat>
References: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
 <20210804125737.kbgc6mg2v5lw25wu@steredhat>
 <8e44442c-4cac-dcbc-a88d-17d9878e7d32@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8e44442c-4cac-dcbc-a88d-17d9878e7d32@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 11:33:12AM +0300, Arseny Krasnov wrote:
>
>On 04.08.2021 15:57, Stefano Garzarella wrote:
>> Caution: This is an external email. Be cautious while opening links or attachments.
>>
>>
>>
>> Hi Arseny,
>>
>> On Mon, Jul 26, 2021 at 07:31:33PM +0300, Arseny Krasnov wrote:
>>>       This patchset implements support of MSG_EOR bit for SEQPACKET
>>> AF_VSOCK sockets over virtio transport.
>>>       Idea is to distinguish concepts of 'messages' and 'records'.
>>> Message is result of sending calls: 'write()', 'send()', 'sendmsg()'
>>> etc. It has fixed maximum length, and it bounds are visible using
>>> return from receive calls: 'read()', 'recv()', 'recvmsg()' etc.
>>> Current implementation based on message definition above.
>> Okay, so the implementation we merged is wrong right?
>> Should we disable the feature bit in stable kernels that contain it? Or
>> maybe we can backport the fixes...
>
>Hi,
>
>No, this is correct and it is message boundary based. Idea of this
>patchset is to add extra boundaries marker which i think could be
>useful when we want to send data in seqpacket mode which length
>is bigger than maximum message length(this is limited by transport).
>Of course we can fragment big piece of data too small messages, but 
>this
>requires to carry fragmentation info in data protocol. So In this case
>when we want to maintain boundaries receiver calls recvmsg() until 
>MSG_EOR found.
>But when receiver knows, that data is fit in maximum datagram length,
>it doesn't care about checking MSG_EOR just calling recv() or 
>read()(e.g.
>message based mode).

I'm not sure we should maintain boundaries of multiple send(), from 
POSIX standard [1]:

   SOCK_SEQPACKET
     Provides sequenced, reliable, bidirectional, connection-mode 
     transmission paths for records. A record can be sent using one or 
     more output operations and received using one or more input 
     operations, but a single operation never transfers part of more than 
     one record. Record boundaries are visible to the receiver via the 
     MSG_EOR flag.

 From my understanding a record could be sent with multiple send() and 
received, for example, with a single recvmsg().
The only boundary should be the MSG_EOR flag set by the user on the last 
send() of a record.

 From send() description [2]:

   MSG_EOR
     Terminates a record (if supported by the protocol).

 From recvmsg() description [3]:

   MSG_EOR
     End-of-record was received (if supported by the protocol).

Thanks,
Stefano

[1] 
https://pubs.opengroup.org/onlinepubs/9699919799/functions/socket.html
[2] https://pubs.opengroup.org/onlinepubs/9699919799/functions/send.html
[3] 
https://pubs.opengroup.org/onlinepubs/9699919799/functions/recvmsg.html

