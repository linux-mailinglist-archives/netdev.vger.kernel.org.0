Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE373BBED3
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 17:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhGEP0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 11:26:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55599 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231544AbhGEP0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 11:26:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625498622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r2imsBDLHS8rC/hkSxHiuEVGdRV9OR2l0LhTihLqoT4=;
        b=Unwb6ET9HOjfTYIqza2Fw9Pi1JhaNNTIA/ORnuPmhnr5PoJJAZ7NnPugZVtjnMrlz9yCQe
        VrZPe1XM7+yx8AmnrBkqgl/EHBGIKZAT4MuuL/jxqgqt5CogRCvS77sM8rEpXvbHWscNJN
        ECvt9HwgAbKQHiec3hZVXgHXWMtGD7o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-0w5_0IipMYOy3vh_xFOg6A-1; Mon, 05 Jul 2021 11:23:41 -0400
X-MC-Unique: 0w5_0IipMYOy3vh_xFOg6A-1
Received: by mail-wm1-f72.google.com with SMTP id m31-20020a05600c3b1fb02902082e9b2132so1943891wms.5
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 08:23:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r2imsBDLHS8rC/hkSxHiuEVGdRV9OR2l0LhTihLqoT4=;
        b=aUwyzu7I0Ab2vVBQ+DNOlyfZiNHynlqWJIEr/Y1nU+IRw32dj80I7y4sdi443VoHvw
         jbDUDAStC7/tWdmIU/mP4EzGAgU69lyTCWHjr8hLSuduQfucftkUa90j1cSDYYfNwBME
         yY+Lfq0wB1EXbPE/nlwlZCfxHHO/FKZdteT0AFMG/lY6C9Ass9smwSYnU7OhU/+fM3Bu
         fJhLKzJhnPIwVhEznDWa7oKfZaphQTnyL+J/1rTXJaffqVhjXBEtK8+cVXu2qjZWCZf7
         DURMmgofe7Oh2rLhWpZN9oDx6XBbU4g5QYEFrKTETlqeGyT+l+niULyn+nUtYMbUdFCK
         WPBw==
X-Gm-Message-State: AOAM531Y60Gq6F+hJmDVfh4OiIZsQrLdxwMs1dngEbVN5A99WNQW6tXK
        AA8LEjBGpizpv9ifQb3TXdRB0Ryil4RYohak8ECV0dg7OO5aUlJ5trMGwr0dnYmvGhFdp6KdBXK
        3xl2zzmyr4/6sh91Z
X-Received: by 2002:a1c:ed08:: with SMTP id l8mr15084304wmh.38.1625498620563;
        Mon, 05 Jul 2021 08:23:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJym7nxOUkrVOSJ373jn1gschu21kFntb7dSjS1xiqNy/Gh/kFjxLb5+nfUyvQAjU0bU2OESJg==
X-Received: by 2002:a1c:ed08:: with SMTP id l8mr15084280wmh.38.1625498620313;
        Mon, 05 Jul 2021 08:23:40 -0700 (PDT)
Received: from steredhat (host-87-7-214-34.retail.telecomitalia.it. [87.7.214.34])
        by smtp.gmail.com with ESMTPSA id y8sm13359781wrr.76.2021.07.05.08.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 08:23:39 -0700 (PDT)
Date:   Mon, 5 Jul 2021 17:23:36 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [MASSMAIL KLMS]Re: [RFC PATCH v2 0/6] Improve SOCK_SEQPACKET
 receive logic
Message-ID: <20210705152336.ibv4ret3d2dyhdpc@steredhat>
References: <20210704080820.88746-1-arseny.krasnov@kaspersky.com>
 <20210704042843-mutt-send-email-mst@kernel.org>
 <b427dee7-5c1b-9686-9004-05fa05d45b28@kaspersky.com>
 <20210704055037-mutt-send-email-mst@kernel.org>
 <c9f0d355-27a1-fb19-eac0-06a5d7648f5d@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c9f0d355-27a1-fb19-eac0-06a5d7648f5d@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 05, 2021 at 01:48:28PM +0300, Arseny Krasnov wrote:
>
>On 04.07.2021 12:54, Michael S. Tsirkin wrote:
>> On Sun, Jul 04, 2021 at 12:23:03PM +0300, Arseny Krasnov wrote:
>>> On 04.07.2021 11:30, Michael S. Tsirkin wrote:
>>>> On Sun, Jul 04, 2021 at 11:08:13AM +0300, Arseny Krasnov wrote:
>>>>> 	This patchset modifies receive logic for SOCK_SEQPACKET.
>>>>> Difference between current implementation and this version is that
>>>>> now reader is woken up when there is at least one RW packet in rx
>>>>> queue of socket and data is copied to user's buffer, while merged
>>>>> approach wake up user only when whole message is received and kept
>>>>> in queue. New implementation has several advantages:
>>>>>  1) There is no limit for message length. Merged approach requires
>>>>>     that length must be smaller than 'peer_buf_alloc', otherwise
>>>>>     transmission will stuck.
>>>>>  2) There is no need to keep whole message in queue, thus no
>>>>>     'kmalloc()' memory will be wasted until EOR is received.
>>>>>
>>>>>     Also new approach has some feature: as fragments of message
>>>>> are copied until EOR is received, it is possible that part of
>>>>> message will be already in user's buffer, while rest of message
>>>>> still not received. And if user will be interrupted by signal or
>>>>> timeout with part of message in buffer, it will exit receive loop,
>>>>> leaving rest of message in queue. To solve this problem special
>>>>> callback was added to transport: it is called when user was forced
>>>>> to leave exit loop and tells transport to drop any packet until
>>>>> EOR met.
>>>> Sorry about commenting late in the game.  I'm a bit lost
>>>>
>>>>
>>>> SOCK_SEQPACKET
>>>> Provides sequenced, reliable, bidirectional, connection-mode transmission paths for records. A record can be sent using one or more output operations and received using one or more input operations, but a single operation never transfers part of more than one record. Record boundaries are visible to the receiver via the MSG_EOR flag.
>>>>
>>>> it's supposed to be reliable - how is it legal to drop packets?
>>> Sorry, seems i need to rephrase description. "Packet" here means fragment of record(message) at transport
>>>
>>> layer. As this is SEQPACKET mode, receiver could get only whole message or error, so if only several fragments
>>>
>>> of message was copied (if signal received for example) we can't return it to user - it breaks SEQPACKET sense. I think,
>>>
>>> in this case we can drop rest of record's fragments legally.
>>>
>>>
>>> Thank You
>> Would not that violate the reliable property? IIUC it's only ok to
>> return an error if socket gets closed. Just like e.g. TCP ...
>>
>Sorry for late answer, yes You're right, seems this is unwanted drop...
>
>Lets wait for Stefano Garzarella feedback

It was the same concern I had with the series that introduced SEQPACKET 
for vsock, which is why I suggested to wait until the message is 
complete, before copying it to the user's buffer.

IIUC, with the current upstream implementation, we don't have this 
problem, right?

I'm not sure how to fix this, other than by keeping all the fragments 
queued until we've successfully copied them to user space, which is what 
we should do without this series applied IIUC.

Stefano

