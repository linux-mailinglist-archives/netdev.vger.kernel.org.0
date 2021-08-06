Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4048A3E23CE
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 09:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243560AbhHFHRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 03:17:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53298 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241480AbhHFHRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 03:17:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628234209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4h9NXCahpaPwahhaO5hMLHu+0Sj92iJsupdJcdmnrx4=;
        b=QyZvqAEae9RwU2R0wLA6NaPiHcc/a+2+C0owzLknw8Q1Qj1llWV8wkmcsG3Q6SxYK+PszG
        3jPOe19/VP3p5+VzlPJpuFx7MSqGb83bb9gRRf/l05XxtifBphT1M48vnOwc8vmxYGGsk0
        Q7y2O5vUIbBCDMFxyF/Ig1DjUtFf9Q4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-oUbLV41wP-KW2_NfPRte_w-1; Fri, 06 Aug 2021 03:16:47 -0400
X-MC-Unique: oUbLV41wP-KW2_NfPRte_w-1
Received: by mail-ej1-f71.google.com with SMTP id k22-20020a1709061596b02905a370b2f477so2850059ejd.17
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 00:16:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4h9NXCahpaPwahhaO5hMLHu+0Sj92iJsupdJcdmnrx4=;
        b=l83uXM30p+P433TnxCzzQsal2SAu/REnbpWvz0+OlQrmF2ZX0fQegJwZTlJKKSdv19
         F8zX2PKjOjf9jyd5rmUQ3hzJfK0ZNlVhvfK650AtVhnVjPJ4WR6nSeaiymQZVejNmKku
         aloLLSCudWS13c7cl1eRa8S9cFhD1vjNBBme0agLH0O5rE+k0NtPXyL3Ocye+yEWL7Ba
         3W/vBgsg3EIQmS2fFDXtHtoZzH2H3BZWlNhy0NACg0SYVPwDKj1eXkk49323PAI1AOcA
         g1gXHGQaNNoAxzt76CrnHaoQIKalCbtXSE4Hv7Z3Fy5ub5Gj+j2Y1EE/6PXxhPaynrey
         cJ1Q==
X-Gm-Message-State: AOAM532YHcCVYVRJTVqc82H3RL8EdhHhOb4XaJ2oBq9aH5P3rEVbQLgI
        4RFms8YpyyQCbfRoLBp8rWcVzdBmG9P4fYRAv3JKYq9ZkLgRc0jYWpRltaoCjrVLr1qjKcbddJC
        NZktDPg4RIeLuDMAZ
X-Received: by 2002:a05:6402:3552:: with SMTP id f18mr11179145edd.82.1628234206526;
        Fri, 06 Aug 2021 00:16:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYURfrjKTFZrJHZ9Mcw5cT6VZwzIqZ9tPmHg4AX/+74PdKLsXxtkvp1Vnsgy4/vQl/I70njg==
X-Received: by 2002:a05:6402:3552:: with SMTP id f18mr11179120edd.82.1628234206380;
        Fri, 06 Aug 2021 00:16:46 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id gv7sm2535932ejc.5.2021.08.06.00.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 00:16:46 -0700 (PDT)
Date:   Fri, 6 Aug 2021 09:16:43 +0200
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
Subject: Re: [!!Mass Mail KSE][MASSMAIL KLMS] Re: [RFC PATCH v1 0/7]
 virtio/vsock: introduce MSG_EOR flag for SEQPACKET
Message-ID: <20210806071643.byebg4hmm3dtnb2x@steredhat>
References: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
 <20210804125737.kbgc6mg2v5lw25wu@steredhat>
 <8e44442c-4cac-dcbc-a88d-17d9878e7d32@kaspersky.com>
 <20210805090657.y2sz3pzhruuolncq@steredhat>
 <8bd80d3f-3e00-5e31-42a1-300ff29100ae@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8bd80d3f-3e00-5e31-42a1-300ff29100ae@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 12:21:57PM +0300, Arseny Krasnov wrote:
>
>On 05.08.2021 12:06, Stefano Garzarella wrote:
>> Caution: This is an external email. Be cautious while opening links or attachments.
>>
>>
>>
>> On Thu, Aug 05, 2021 at 11:33:12AM +0300, Arseny Krasnov wrote:
>>> On 04.08.2021 15:57, Stefano Garzarella wrote:
>>>> Caution: This is an external email. Be cautious while opening links or attachments.
>>>>
>>>>
>>>>
>>>> Hi Arseny,
>>>>
>>>> On Mon, Jul 26, 2021 at 07:31:33PM +0300, Arseny Krasnov wrote:
>>>>>       This patchset implements support of MSG_EOR bit for SEQPACKET
>>>>> AF_VSOCK sockets over virtio transport.
>>>>>       Idea is to distinguish concepts of 'messages' and 'records'.
>>>>> Message is result of sending calls: 'write()', 'send()', 'sendmsg()'
>>>>> etc. It has fixed maximum length, and it bounds are visible using
>>>>> return from receive calls: 'read()', 'recv()', 'recvmsg()' etc.
>>>>> Current implementation based on message definition above.
>>>> Okay, so the implementation we merged is wrong right?
>>>> Should we disable the feature bit in stable kernels that contain it? Or
>>>> maybe we can backport the fixes...
>>> Hi,
>>>
>>> No, this is correct and it is message boundary based. Idea of this
>>> patchset is to add extra boundaries marker which i think could be
>>> useful when we want to send data in seqpacket mode which length
>>> is bigger than maximum message length(this is limited by transport).
>>> Of course we can fragment big piece of data too small messages, but
>>> this
>>> requires to carry fragmentation info in data protocol. So In this case
>>> when we want to maintain boundaries receiver calls recvmsg() until
>>> MSG_EOR found.
>>> But when receiver knows, that data is fit in maximum datagram length,
>>> it doesn't care about checking MSG_EOR just calling recv() or
>>> read()(e.g.
>>> message based mode).
>> I'm not sure we should maintain boundaries of multiple send(), from
>> POSIX standard [1]:
>
>Yes, but also from POSIX: such calls like send() and sendmsg()
>
>operates with "message" and if we check recvmsg() we will
>
>find the following thing:
>
>
>For message-based sockets, such as SOCK_DGRAM and SOCK_SEQPACKET, the entire
>
>message shall be read in a single operation. If a message is too long to fit in the supplied
>
>buffers, and MSG_PEEK is not set in the flags argument, the excess bytes shall be discarded.
>
>
>I understand this, that send() boundaries also must be maintained.
>
>I've checked SEQPACKET in AF_UNIX and AX_25 - both doesn't support
>
>MSG_EOR, so send() boundaries must be supported.
>
>>
>>    SOCK_SEQPACKET
>>      Provides sequenced, reliable, bidirectional, connection-mode
>>      transmission paths for records. A record can be sent using one or
>>      more output operations and received using one or more input
>>      operations, but a single operation never transfers part of more than
>>      one record. Record boundaries are visible to the receiver via the
>>      MSG_EOR flag.
>>
>>  From my understanding a record could be sent with multiple send() 
>>  and
>> received, for example, with a single recvmsg().
>> The only boundary should be the MSG_EOR flag set by the user on the 
>> last
>> send() of a record.
>You are right, if we talking about "record".
>>
>>  From send() description [2]:
>>
>>    MSG_EOR
>>      Terminates a record (if supported by the protocol).
>>
>>  From recvmsg() description [3]:
>>
>>    MSG_EOR
>>      End-of-record was received (if supported by the protocol).
>>
>> Thanks,
>> Stefano
>>
>> [1]
>> https://pubs.opengroup.org/onlinepubs/9699919799/functions/socket.html
>> [2] 
>> https://pubs.opengroup.org/onlinepubs/9699919799/functions/send.html
>> [3]
>> https://pubs.opengroup.org/onlinepubs/9699919799/functions/recvmsg.html
>
>P.S.: seems SEQPACKET is too exotic thing that everyone implements it 
>in
>
>own manner, because i've tested SCTP seqpacket implementation, and 
>found
>
>that:
>
>1) It doesn't support MSG_EOR bit at send side, but uses MSG_EOR at 
>receiver
>
>side to mark MESSAGE boundary.
>
>2) According POSIX any extra bytes that didn't fit in user's buffer 
>must be dropped,
>
>but SCTP doesn't drop it - you can read rest of datagram in next calls.
>

Thanks for this useful information, now I see the differences and why we 
should support both.

I think is better to include them in the cover letter.

I'm going to review the paches right now :-)

Stefano

