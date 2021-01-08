Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F8F2EF0BB
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 11:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbhAHKf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 05:35:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34544 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727090AbhAHKf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 05:35:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610102042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9jaCobpp/gjZ1BrAW63KVqKbg+WZam2J/wlrqVXlE/U=;
        b=GjZRGu/5tFOLIAoaDM2OL0XDemAkaNO9u+E19hViCIt2GCEh0rp7rH98IZ8QGhM057bjC6
        KxdNtWFuyOLd4BwqbhP0i9BLFU5JMTpqtuZK0py/d3C6YXNfxe1vr/hsQFGMR5l3MD0/JJ
        bJmFOCT5ZdQBFE3/VUr0tf3zA8P39J0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-URWed_8mMIuGNgQ4cl6yQQ-1; Fri, 08 Jan 2021 05:34:00 -0500
X-MC-Unique: URWed_8mMIuGNgQ4cl6yQQ-1
Received: by mail-wr1-f70.google.com with SMTP id v7so3928213wra.3
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 02:34:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9jaCobpp/gjZ1BrAW63KVqKbg+WZam2J/wlrqVXlE/U=;
        b=hwVw08z8RDv3Zh92nplZDLJHEnf7u4GA2PVLJQWtLvqtqtqjO5tEsU1JBmWdWi3pvX
         mwBkeYk1KWH7Fsr3E8im5PtKoNIK7oqgdpR/X7ao8qGlV9RjN/zSrCsMCG4r57A2j7bU
         cp4rnZWngHxoKqpJwcGQbNThpjlVlO2woIhs7VSMYPNXrXmY2iAwdL513wMhF7L/xG1a
         eXYrM8rkQork/h7lhdmfEisz4JkanUIIMTUeqJZAl4TWL9y9Td+9VSeuKLnVaoJVZvir
         a+ezGKpmuQ/muZQSnO8L3rKyMwZ34pjzWZqAUk52kSiMc0BAfn3bZT2ZSqWwvVP1VeVO
         5e5A==
X-Gm-Message-State: AOAM533g/mhzV9jhtNFZSooY4XsFgmeSe7W5KCy/mJB6k5NEiyoU2OZO
        WfaI5M9PnT1q+npO4Bdpebr6p/X3kMx59pdAtn/eB/f77k1mghbcuwqwzRCnOmzHN+66kAspF/V
        xTs1zx+toR0Emz9os
X-Received: by 2002:a5d:4f8a:: with SMTP id d10mr2905573wru.219.1610102039579;
        Fri, 08 Jan 2021 02:33:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx/cYGRiEYoK1vucKO1euIdsck18nMG94piouLVJf/5RHsxZEuyqqUoFQjJC0gMXLBgDrQOUQ==
X-Received: by 2002:a5d:4f8a:: with SMTP id d10mr2905551wru.219.1610102039359;
        Fri, 08 Jan 2021 02:33:59 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id s25sm13327280wrs.49.2021.01.08.02.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 02:33:58 -0800 (PST)
Date:   Fri, 8 Jan 2021 11:33:35 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Arseniy Krasnov <oxffffaa@gmail.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru
Subject: Re: [PATCH 0/5] virtio/vsock: introduce SOCK_SEQPACKET support.
Message-ID: <20210108103335.iabhzk4r6fpsiopt@steredhat>
References: <20210103195454.1954169-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210103195454.1954169-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseny,

On Sun, Jan 03, 2021 at 10:54:52PM +0300, Arseny Krasnov wrote:
>	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>do it, new packet operation was added: it marks start of record (with
>record length in header). To send record, packet with start marker is
>sent first, then all data is transmitted as 'RW' packets. On receiver's
>side, length of record is known from packet with start record marker.
>Now as  packets of one socket are not reordered neither on vsock nor on
>vhost transport layers, these marker allows to restore original record
>on receiver's side. When each 'RW' packet is inserted to rx queue of
>receiver, user is woken up, data is copied to user's buffer and credit
>update message is sent. If there is no user waiting for data, credit
>won't be updated and sender will wait. Also,  if user's buffer is full,
>and record is bigger, all unneeded data will be dropped (with sending of
>credit update message).
>	'MSG_EOR' flag is implemented with special value of 'flags' field
>in packet header. When record is received with such flags, 'MSG_EOR' is
>set in 'recvmsg()' flags. 'MSG_TRUNC' flag is also supported.
>	In this implementation maximum length of datagram is not limited
>as in stream socket.

I did a a quick review. I like the idea of adding SOCK_SEQPACKET, but 
the series needs more work.
Some patches miss the SoB, the commit messages are very minimal.
Anyway I like that you shared your patches, but please use RFC tag if 
they are not ready to be merged.

Another suggestion is to move the patches that modify the core 
(af_vsock.c) before the transport modifications to make the review 
easier.

I'd also like to see new tests in tools/testing/vsock/vsock_test.c

Thanks,
Stefano

