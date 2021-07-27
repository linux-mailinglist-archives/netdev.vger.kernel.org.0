Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7102C3D7274
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 11:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236155AbhG0J6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 05:58:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236061AbhG0J6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 05:58:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627379889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T2rQBG2yVNE7y1+uB+3b6lsmKXViZKQecoiM/1czVBA=;
        b=Mg426BPKHiEYYUn6qqnuG/nyDQOJYDyb/m0yJ9SCdyQyFrbVZWvK4O6C/8bSJhPF8gZO/G
        nHTn3GoCk0wG5MwAUysIh/DFJIaZ8gCsE5dqdeDmNjZZCdFR3ji7i6ztzV/5lJqDNCOs8v
        zS+PIf3+QKLIzPjTx95po+Z97nyJyb8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-o5ngx6oqOlGnnMbUlSWK0w-1; Tue, 27 Jul 2021 05:58:07 -0400
X-MC-Unique: o5ngx6oqOlGnnMbUlSWK0w-1
Received: by mail-ej1-f69.google.com with SMTP id lu19-20020a170906fad3b029058768348f55so1000654ejb.12
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 02:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T2rQBG2yVNE7y1+uB+3b6lsmKXViZKQecoiM/1czVBA=;
        b=MwM1PDmbJhacHRluxzAfgYtiBvKMqFVnk4yV7CDGEB+rOWjtYbLcCKlVmcxOuBaSoK
         bUzSA6p+1hfNg9V7gRFpITk3S/Y+W+d3mGkAtkjv0W7RA+A+Ups2sfJn38oMNOh8+E5T
         UvxXLgFhSm/NfwcznUiAZCVC/UMiEAdh8uoLlPrm8osC3sw1IXoDXGIxksl7o2q6lnsY
         Kpmbqclx3nbiRMcuWLPRgFdew15HZ1jMFDkM6BICgfzRnMWB2z6Wdyhlj5/zPL5JsTop
         311tJbUbk8zuyZniCNKlB0fh3DRfnX2nR/nvKLy+j9pBMYt4DRjNypmq76AAaFDxYvMn
         pL3g==
X-Gm-Message-State: AOAM533tq+EgIGwuNVdKSO9MOQHdFXS2Jj8ILkV6Cd43FHg2SgtKYrXG
        ANc9ftzX0jg87YsZ7wtNiVRMDfX8Gs3f0AFSaH0jejXx7V10D6KpxCabs+syWT1BQ0+yZK9QTZr
        PBj8JZruFOiqiKuuG
X-Received: by 2002:a17:906:ce47:: with SMTP id se7mr3742430ejb.240.1627379886418;
        Tue, 27 Jul 2021 02:58:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8eyrbNlN1DVbEoRIS2U/HCt0SR/iGRuCNgiSKmvCYAIQaFF1wZB5TRpL7dxgdXFiMYR9Wkg==
X-Received: by 2002:a17:906:ce47:: with SMTP id se7mr3742409ejb.240.1627379886242;
        Tue, 27 Jul 2021 02:58:06 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id f18sm726664ejx.23.2021.07.27.02.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 02:58:05 -0700 (PDT)
Date:   Tue, 27 Jul 2021 11:58:03 +0200
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
Subject: Re: [MASSMAIL KLMS] Re: [RFC PATCH v1 0/7] virtio/vsock: introduce
 MSG_EOR flag for SEQPACKET
Message-ID: <20210727095803.s26subp3pgclqzvi@steredhat>
References: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
 <20210727075948.yl4w3foqa6rp4obg@steredhat>
 <2df68589-96b9-abd4-ad1c-e25918b908a9@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2df68589-96b9-abd4-ad1c-e25918b908a9@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 12:34:36PM +0300, Arseny Krasnov wrote:
>
>On 27.07.2021 10:59, Stefano Garzarella wrote:
>> Caution: This is an external email. Be cautious while opening links or attachments.
>>
>>
>>
>> On Mon, Jul 26, 2021 at 07:31:33PM +0300, Arseny Krasnov wrote:
>>>       This patchset implements support of MSG_EOR bit for SEQPACKET
>>> AF_VSOCK sockets over virtio transport.
>>>       Idea is to distinguish concepts of 'messages' and 'records'.
>>> Message is result of sending calls: 'write()', 'send()', 'sendmsg()'
>>> etc. It has fixed maximum length, and it bounds are visible using
>>> return from receive calls: 'read()', 'recv()', 'recvmsg()' etc.
>>> Current implementation based on message definition above.
>>>       Record has unlimited length, it consists of multiple message,
>>> and bounds of record are visible via MSG_EOR flag returned from
>>> 'recvmsg()' call. Sender passes MSG_EOR to sending system call and
>>> receiver will see MSG_EOR when corresponding message will be processed.
>>>       To support MSG_EOR new bit was added along with existing
>>> 'VIRTIO_VSOCK_SEQ_EOR': 'VIRTIO_VSOCK_SEQ_EOM'(end-of-message) - now it
>>> works in the same way as 'VIRTIO_VSOCK_SEQ_EOR'. But 'VIRTIO_VSOCK_SEQ_EOR'
>>> is used to mark 'MSG_EOR' bit passed from userspace.
>> At this point it's probably better to rename the old flag, so we stay
>> compatible.
>>
>> What happens if one of the two peers does not support MSG_EOR handling,
>> while the other does?
>>
>> I'll do a closer review in the next few days.
>Thank You, also i think MSG_EOR support must be described in spec

Yep, sure!

What do you think about the concerns above?

Stefano

