Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E482FA468
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 16:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405408AbhARPSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:18:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36557 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405105AbhARPS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 10:18:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610983022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=psrfvoG3s6Q5vxt3L2I9TwaBLHc6rZJ8JZ9ILZMQQLQ=;
        b=JuvWhx5oP7Yc3rdL+gESQ/2QsljbZPwx/i7widicX6kLayT2feEe/9tOo1bnUdhnYcfYHF
        lO20Fd17husvOABD7+sQ3GETKJlBbMXfIupM64Lfn2PgOVzzXOaBWUlhfycv/hnMGRbfc0
        /uxhX7Bq4pu11JUfpJJd1ZG/H9NzoNg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-ZPfCy4qyO0u-EixvuDXGfw-1; Mon, 18 Jan 2021 10:17:01 -0500
X-MC-Unique: ZPfCy4qyO0u-EixvuDXGfw-1
Received: by mail-wr1-f69.google.com with SMTP id r11so8413413wrs.23
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 07:17:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=psrfvoG3s6Q5vxt3L2I9TwaBLHc6rZJ8JZ9ILZMQQLQ=;
        b=sfka3YKMF5c6i1VCa3D9+QOIgI0MLZYK7AiyTlbJM43XZ14cIzDvM7XHc2sVwDJszV
         5wwV31MKS2W8SWiOarkav1c1TRFMtBYJ+V/eeHFNgaGSIaQcdZrnD6tAKuMwqiRGNru9
         X+aoWrZAKgomzd8KTp+1w2aWg/S+pGnflY9LS9JA/HzbjvzpvItzD/uyEpYhvGixlIa/
         rO89egwRg+rZ5IkfloyQGlzQLPE+04D8+RP7WKY+LfRZVp/Qj0d86EH4dFXlIKwurl0o
         kO0HP8ytOZHCZgcbDHHPpJtksFCy06pPhIsQeplcO5tIW/sJe+UbT06o1s0UnePd3Ivf
         xOmQ==
X-Gm-Message-State: AOAM533MCtNoqivnbfqoiFd4O/U+QLllmh7b2yfiM358aS1mXUXs0f/v
        Xcpl/odLuBseiOCDypvS+B2pUXJf8vCvjOv7iXqeFQiz6HcbeZqjwH52g5HCOR1IV4JIyDTsPdo
        unhXowued9n2rcTSh
X-Received: by 2002:adf:e54a:: with SMTP id z10mr26882329wrm.1.1610983019797;
        Mon, 18 Jan 2021 07:16:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxXG3dAk6icAdSs8xnG72+nZUruxeveo9BolCI0f5eiHmFFp/RlmpfjavbAYMBXV+ShJ7Tvbw==
X-Received: by 2002:adf:e54a:: with SMTP id z10mr26882310wrm.1.1610983019631;
        Mon, 18 Jan 2021 07:16:59 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id z130sm28028318wmb.33.2021.01.18.07.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 07:16:58 -0800 (PST)
Date:   Mon, 18 Jan 2021 16:16:56 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        stsp <stsp2@yandex.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v2 00/13] virtio/vsock: introduce SOCK_SEQPACKET
 support.
Message-ID: <CAGxU2F4v9_a9frgM61fh7UYTcWeGpNaAEXTUgnj8hvdU81PW5Q@mail.gmail.com>
References: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
 <2fd6fc75-c534-7f70-c116-50b1c804b594@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2fd6fc75-c534-7f70-c116-50b1c804b594@yandex.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 12:59:30PM +0300, stsp wrote:
>15.01.2021 08:35, Arseny Krasnov пишет:
>>      This patchset impelements support of SOCK_SEQPACKET for virtio
>>transport.
>>      As SOCK_SEQPACKET guarantees to save record boundaries, so to
>>do it, new packet operation was added: it marks start of record (with
>>record length in header), such packet doesn't carry any data.  To send
>>record, packet with start marker is sent first, then all data is sent
>>as usual 'RW' packets. On receiver's side, length of record is known
>>from packet with start record marker. Now as  packets of one socket
>>are not reordered neither on vsock nor on vhost transport layers, such
>>marker allows to restore original record on receiver's side. If user's
>>buffer is smaller that
>
>than
>
>
>>  record length, when
>
>then
>
>
>>  v1 -> v2:
>>  - patches reordered: af_vsock.c changes now before virtio vsock
>>  - patches reorganized: more small patches, where +/- are not mixed
>
>If you did this because I asked, then this
>is not what I asked. :)
>You can't just add some static func in a
>separate patch, as it will just produce the
>compilation warning of an unused function.
>I only asked to separate the refactoring from
>the new code. I.e. if you move some code
>block to a separate function, you shouldn't
>split that into 2 patches, one that adds a
>code block and another one that removes it.
>It should be in one patch, so that it is clear
>what was moved, and no new warnings are
>introduced.
>What I asked to separate, is the old code
>moves with the new code additions. Such
>things can definitely go in a separate patches.

Arseny, thanks for the v2.
I appreciated that you moved the af_vsock changes before the transport
and also the test, but I agree with stsp about split patches.

As stsp suggested, you can have some "preparation" patches that touch
the already existing code (e.g. rename vsock_stream_sendmsg in
vsock_connectible_sendmsg() and call it inside the new
vsock_stream_sendmsg, etc.), then a patch that adds seqpacket stuff in
af_vsock.

Also for virtio/vhost transports, you can have some patches that add
support in virtio_transport_common, then a patch that enable it in
virtio_transport and a patch for vhost_vsock, as you rightly did in
patch 12.

So, I'd suggest moving out the code that touches virtio_transport.c
from patch 11.

These changes should simplify the review.

In addition, you can also remove the . from the commit titles.


I left other comments in the single patches.

Thanks,
Stefano

