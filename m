Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DB75446B1
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242865AbiFII4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237726AbiFII4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:56:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 750D047040
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 01:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654764877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tvWtgkYBzt9DbATf2rlAmzgDtHttB4fvGNf4mSgVDKk=;
        b=DolXWM56kIehFrHaLgs76bgGZnaMv8sSSvBg01nrtGtckY6aUZzfdLttAQnIwIKg/9Uoil
        9bk+zR9JGyJe0HAWF8dfsqgfpXp0napFQMQlcGoTEmK5In8/NgaJcEtYgfI6k4CQ3VePqG
        rpSxg7uKi4GxbOwsqB4JulyMQJ1f8yM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-98hpzDJCMqGDOo2J7PzWlA-1; Thu, 09 Jun 2022 04:54:36 -0400
X-MC-Unique: 98hpzDJCMqGDOo2J7PzWlA-1
Received: by mail-wm1-f72.google.com with SMTP id o2-20020a05600c510200b0039747b0216fso15728123wms.0
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 01:54:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tvWtgkYBzt9DbATf2rlAmzgDtHttB4fvGNf4mSgVDKk=;
        b=r3k5O47R6ukKnL/rmfzwN9gTskaItE3/FRilEBhguFYc74N7OiVocxogBcf82+XOw/
         yVB7z92/D0qbpaL+NCCmKdBg+Yl44jTAfx9tFAtDrv+zffloAHFoVqoVnjRr8wHcB5+i
         7J4TirLd7kDgNgAbYiAE+yVJQGOosvy3KQwPjRfjhVAfGKIksygarxjKNbS2OXlerSCF
         znoYacB3PHP7nspsNcG5dJZEPOlLkh5nMq+29fctZ96FzIViwdR3RWViusKvT1ud4rg1
         da/DR98GHKQSa//y22C6blBQaCmHqvKCaT0BZMILIqBRUlr8PwmNgOxn5zjrGfyffOek
         qp4g==
X-Gm-Message-State: AOAM5313DbgXPrX95zkHqe7hHuoPxscTkVGhIM85tEZLuZ90Fh1n3zOQ
        f5bg7e0BRydNjJ24hX45JuPq+vuCkJuKXS56pNnF5IETZIikSDyXK0d27qxD8NL2/ZBA10rbEFY
        DAklGB0SBbWO2Ry5b
X-Received: by 2002:adf:e5d0:0:b0:210:313a:e4dc with SMTP id a16-20020adfe5d0000000b00210313ae4dcmr36674910wrn.152.1654764875098;
        Thu, 09 Jun 2022 01:54:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzR7k/vdtBFj/GYt/MtBX7xF11gJz7ChUoPOTqELw1aa5VvOp+SIRJBSOhp8lJfnJDnuWfn3g==
X-Received: by 2002:adf:e5d0:0:b0:210:313a:e4dc with SMTP id a16-20020adfe5d0000000b00210313ae4dcmr36674875wrn.152.1654764874842;
        Thu, 09 Jun 2022 01:54:34 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-40.retail.telecomitalia.it. [79.46.200.40])
        by smtp.gmail.com with ESMTPSA id s19-20020a1cf213000000b0039c4945c753sm15291073wmc.39.2022.06.09.01.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 01:54:33 -0700 (PDT)
Date:   Thu, 9 Jun 2022 10:54:28 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v2 0/8] virtio/vsock: experimental zerocopy receive
Message-ID: <20220609085428.idi4qzydhdpzszzw@sgarzare-redhat>
References: <e37fdf9b-be80-35e1-ae7b-c9dfeae3e3db@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e37fdf9b-be80-35e1-ae7b-c9dfeae3e3db@sberdevices.ru>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseniy,
I left some comments in the patches, and I'm adding something also here:

On Fri, Jun 03, 2022 at 05:27:56AM +0000, Arseniy Krasnov wrote:
>                              INTRODUCTION
>
>	Hello, this is experimental implementation of virtio vsock zerocopy
>receive. It was inspired by TCP zerocopy receive by Eric Dumazet. This API uses
>same idea: call 'mmap()' on socket's descriptor, then every 'getsockopt()' will
>fill provided vma area with pages of virtio RX buffers. After received data was
>processed by user, pages must be freed by 'madvise()'  call with MADV_DONTNEED
>flag set(if user won't call 'madvise()', next 'getsockopt()' will 
>fail).

If it is not too time-consuming, can we have a table/list to compare this 
and the TCP zerocopy?

>
>                                 DETAILS
>
>	Here is how mapping with mapped pages looks exactly: first page mapping
>contains array of trimmed virtio vsock packet headers (in contains only length
>of data on the corresponding page and 'flags' field):
>
>	struct virtio_vsock_usr_hdr {
>		uint32_t length;
>		uint32_t flags;
>		uint32_t copy_len;
>	};
>
>Field  'length' allows user to know exact size of payload within each sequence
>of pages and 'flags' allows user to handle SOCK_SEQPACKET flags(such as message
>bounds or record bounds). Field 'copy_len' is described below in 'v1->v2' part.
>All other pages are data pages from RX queue.
>
>             Page 0      Page 1      Page N
>
>	[ hdr1 .. hdrN ][ data ] .. [ data ]
>           |        |       ^           ^
>           |        |       |           |
>           |        *-------------------*
>           |                |
>           |                |
>           *----------------*
>
>	Of course, single header could represent array of pages (when packet's
>buffer is bigger than one page).So here is example of detailed mapping layout
>for some set of packages. Lets consider that we have the following sequence  of
>packages: 56 bytes, 4096 bytes and 8200 bytes. All pages: 0,1,2,3,4 and 5 will
>be inserted to user's vma(vma is large enough).

In order to have a "userspace polling-friendly approach" and reduce 
number of syscall, can we allow for example the userspace to mmap at 
least the first header before packets arrive.
Then the userspace can poll a flag or other fields in the header to 
understand that there are new packets.

That would be cool, but in the meantime it would be nice to behave 
similarly to TCP, which is why the comparison table I mentioned earlier 
would be useful.

>
>	Page 0: [[ hdr0 ][ hdr 1 ][ hdr 2 ][ hdr 3 ] ... ]
>	Page 1: [ 56 ]
>	Page 2: [ 4096 ]
>	Page 3: [ 4096 ]
>	Page 4: [ 4096 ]
>	Page 5: [ 8 ]
>
>	Page 0 contains only array of headers:
>	'hdr0' has 56 in length field.
>	'hdr1' has 4096 in length field.
>	'hdr2' has 8200 in length field.
>	'hdr3' has 0 in length field(this is end of data marker).
>
>	Page 1 corresponds to 'hdr0' and has only 56 bytes of data.
>	Page 2 corresponds to 'hdr1' and filled with data.
>	Page 3 corresponds to 'hdr2' and filled with data.
>	Page 4 corresponds to 'hdr2' and filled with data.
>	Page 5 corresponds to 'hdr2' and has only 8 bytes of data.
>
>	This patchset also changes packets allocation way: today implementation
>uses only 'kmalloc()' to create data buffer. Problem happens when we try to map
>such buffers to user's vma - kernel forbids to map slab pages to user's vma(as
>pages of "not large" 'kmalloc()' allocations are marked with PageSlab flag and
>"not large" could be bigger than one page). So to avoid this, data buffers now
>allocated using 'alloc_pages()' call.
>
>                                   TESTS
>
>	This patchset updates 'vsock_test' utility: two tests for new feature
>were added. First test covers invalid cases. Second checks valid transmission
>case.
>
>                                BENCHMARKING
>
>	For benchmakring I've added small utility 'rx_zerocopy'. It works in
>client/server mode. When client connects to server, server starts sending exact
>amount of data to client(amount is set as input argument).Client reads data and
>waits for next portion of it. Client works in two modes: copy and zero-copy. In
>copy mode client uses 'read()' call while in zerocopy mode sequence of 'mmap()'
>/'getsockopt()'/'madvise()' are used. Smaller amount of time for transmission
>is better. For server, we can set size of tx buffer and for client we can set
>size of rx buffer or rx mapping size(in zerocopy mode). Usage of this utility
>is quiet simple:
>
>For client mode:
>
>./rx_zerocopy --mode client [--zerocopy] [--rx]
>
>For server mode:
>
>./rx_zerocopy --mode server [--mb] [--tx]
>
>[--mb] sets number of megabytes to transfer.
>[--rx] sets size of receive buffer/mapping in pages.
>[--tx] sets size of transmit buffer in pages.
>
>I checked for transmission of 4000mb of data. Here are some results:
>
>                           size of rx/tx buffers in pages
>               *---------------------------------------------------*
>               |    8   |    32    |    64   |   256    |   512    |
>*--------------*--------*----------*---------*----------*----------*
>|   zerocopy   |   24   |   10.6   |  12.2   |   23.6   |    21    | secs to
>*--------------*---------------------------------------------------- process
>| non-zerocopy |   13   |   16.4   |  24.7   |   27.2   |   23.9   | 4000 mb
>*--------------*----------------------------------------------------
>
>Result in first column(where non-zerocopy works better than zerocopy) happens
>because time, spent in 'read()' system call is smaller that time in 'getsockopt'
>+ 'madvise'. I've checked that.
>
>I think, that results are not so impressive, but at least it is not worse than
>copy mode and there is no need to allocate memory for processing date.
>
>                                 PROBLEMS
>
>	Updated packet's allocation logic creates some problem: when host gets
>data from guest(in vhost-vsock), it allocates at least one page for each packet
>(even if packet has 1 byte payload). I think this could be resolved in several
>ways:
>	1) Make zerocopy rx mode disabled by default, so if user didn't enable
>it, current 'kmalloc()' way will be used. <<<<<<< (IMPLEMENTED IN V2)

Yep, but I think we should not allow to change it while we are connected 
(see comments in the patches.)

>	2) Use 'kmalloc()' for "small" packets, else call page allocator. But
>in this case, we have mix of packets, allocated in two different ways thus
>during zerocopying to user(e.g. mapping pages to vma), such small packets will
>be handled in some stupid way: we need to allocate one page for user, copy data
>to it and then insert page to user's vma.
>
>v1 -> v2:
> 1) Zerocopy receive mode could be enabled/disabled(disabled by default). I
>    didn't use generic SO_ZEROCOPY flag, because in virtio-vsock case this
>    feature depends on transport support. Instead of SO_ZEROCOPY, AF_VSOCK
>    layer flag was added: SO_VM_SOCKETS_ZEROCOPY, while previous meaning of
>    SO_VM_SOCKETS_ZEROCOPY(insert receive buffers to user's vm area) now
>    renamed to SO_VM_SOCKETS_MAP_RX.
> 2) Packet header which is exported to user now get new field: 'copy_len'.
>    This field handles special case:  user reads data from socket in non
>    zerocopy way(with disabled zerocopy) and then enables zerocopy feature.
>    In this case vhost part will switch data buffer allocation logic from
>    'kmalloc()' to direct calls for buddy allocator. But, there could be
>    some pending 'kmalloc()' allocated packets in socket's rx list, and then
>    user tries to read such packets in zerocopy way, dequeue will fail,
>    because SLAB pages could not be inserted to user's vm area. So when such
>    packet is found during zerocopy dequeue, dequeue loop will break and
>    'copy_len' will show size of such "bad" packet. After user detects this
>    case, it must use 'read()/recv()' calls to dequeue such packet.
> 3) Also may be move this features under config option?

Do you mean a build config like CONFIG_VSOCK_ZERO_COPY?

I'm not sure it's needed.

Thanks,
Stefano

