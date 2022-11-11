Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDDE625CC0
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 15:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbiKKORs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 09:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234802AbiKKOR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 09:17:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0770F77E65
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 06:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668175630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/1kqvx/TCJioVJv3sqoz1vDOCznyEOs7iv66tfLat94=;
        b=KhWORnNwyzSLXbFTgx0nagQXOA9fXF6oG7v2HWluhcCDawDOqD9gO2RpYkW2pycUSd40f0
        s9ZFPrJ/n1A6lT5xTJn8znpu/tvW2y++Fvh1BiIzBzHpjev8wp0VoWWxao2evlJoTx3jRn
        73DQEw2Thf38GqlaEyu2gnX0mhkWsy0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-473-YhwCchsgN9a7rwmYToByNw-1; Fri, 11 Nov 2022 09:07:06 -0500
X-MC-Unique: YhwCchsgN9a7rwmYToByNw-1
Received: by mail-ej1-f72.google.com with SMTP id gt15-20020a1709072d8f00b007aaac7973fbso3106080ejc.23
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 06:07:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/1kqvx/TCJioVJv3sqoz1vDOCznyEOs7iv66tfLat94=;
        b=Na6NHKEeKceDi56R97gYU6NHGNIHLBVkl+rKDkJgSfH7sQ0sF/Kz+fuccendmsOzf+
         uiATIJUPJUU3EPI03IjKQ8EFD7rMgy/2NzqP8faLewgOwhXaS1IgQUZRkmLAGf0AyX1e
         a1sbzpAA4+cX+7UJSR5HYCXK3ZDToBIawwL732EANleuK9b4sh2AD6+RLSwknAleT+aB
         7s/FrxnxMo8yLqmu6KtJSvpUGRZ+KGWwvFCH+HLF+CRuCv4RhJYIHWAuTXWl6rG1VGy2
         1WYW5NSasWkxlVEuEK4wzPCkUFdUmaZOD+BqRj9nXzSDeMjxElv5EXX6GWOJYzqOs4Xl
         8hFA==
X-Gm-Message-State: ANoB5pkTKJ1VPDVhfsXPUjaj4DD79SshM4YweZiGX8ZSRgi1YcdkGKum
        tSsmjGRugmhKbQckIWs8iw1g+K1R7Y1C2hPoA3fYPzvnCybDQq00+Gi7c8AlvzfjNVL6b61TFxt
        /NV/4W2ka0zQuhT+thS1Us1PJ+4ykJbPa
X-Received: by 2002:a17:906:a86:b0:78a:d0a4:176 with SMTP id y6-20020a1709060a8600b0078ad0a40176mr1934315ejf.720.1668175625556;
        Fri, 11 Nov 2022 06:07:05 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7RpcvGYoOkq2SlOsaZnbim58u/OIo21A+1PAPSetB58Xu4eu/3o4sh4HMYEKwicBvWo0DQsr9q/Bv/THiiuac=
X-Received: by 2002:a17:906:a86:b0:78a:d0a4:176 with SMTP id
 y6-20020a1709060a8600b0078ad0a40176mr1934284ejf.720.1668175625164; Fri, 11
 Nov 2022 06:07:05 -0800 (PST)
MIME-Version: 1.0
References: <f60d7e94-795d-06fd-0321-6972533700c5@sberdevices.ru> <20221111134715.qxgu7t4c7jse24hp@sgarzare-redhat>
In-Reply-To: <20221111134715.qxgu7t4c7jse24hp@sgarzare-redhat>
From:   Stefano Garzarella <sgarzare@redhat.com>
Date:   Fri, 11 Nov 2022 15:06:42 +0100
Message-ID: <CAGxU2F4-gN5gnH8B1eX23OFYLHiUh_eLWx8NH8Vaxb=j7=h8oA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 00/11] virtio/vsock: experimental zerocopy receive
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 2:47 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> Hi Arseniy,
> maybe we should start rebasing this series on the new support for
> skbuff:
> https://lore.kernel.org/lkml/20221110171723.24263-1-bobby.eshleman@bytedance.com/
>
> CCing Bobby to see if it's easy to integrate since you're both changing
> the packet allocation.
>
>
> On Sun, Nov 06, 2022 at 07:33:41PM +0000, Arseniy Krasnov wrote:
> >
> >
> >                              INTRODUCTION
> >
> >Hello,
> >
> >       This is experimental patchset for virtio vsock zerocopy receive.
> >It was inspired by TCP zerocopy receive by Eric Dumazet. This API  uses
> >same idea:call 'mmap()' on socket's descriptor,then call 'getsockopt()'
> >to fill provided vma area with pages of virtio receive buffers.   After
> >received data was processed by user, pages must be freed by 'madvise()'
> >call with MADV_DONTNEED flag set(but if user will not call 'madvise()',
> >next 'getsockopt()' will fail).
> >
> >                                 DETAILS
> >
> >       Here is how mapping with mapped pages looks exactly: first page
> >contains information about mapped data buffers. At zero offset mapping
> >contains special data structure:
> >
> >       struct virtio_vsock_usr_hdr_pref {
> >              u32 poll_value;
> >              u32 hdr_num;
> >       };
> >
> >This structure contains two fields:
> >'poll_value' - shows that current socket has data to read.When socket's
> >intput queue is empty,  'poll_value' is set to 0 by kernel.  When input
> >queue has some data, 'poll_value' is set to 1 by kernel. When socket is
> >closed for data receive, 'poll_value' is ~0.This tells user that "there
> >will be no more data,continue to call 'getsockopt()' until you'll  find
> >'hdr_num' == 0".User spins on it in userspace, without calling 'poll()'
> >system call(of course, 'poll()' is still working).
> >'hdr_num' - shows number of mapped pages with data which starts from
> >second page of this mappined.
> >
> >NOTE:
> >   This version has two limitations:
> >
> >   1) One mapping per socket is supported.  It is implemented by adding
> >      'struct page*' pointer to  'struct virtio_vsock' structure (first
> >      page of mapping, which contains 'virtio_vsock_usr_hdr_pref').But,
> >      I think, support for multiple pages could be implemented by using
> >      something like hash table of such pages, or more simple, just use
> >      first page of mapping as headers page by default. Also I think,
> >      number of such pages may be controlled by 'setsockop()'.
> >
> >   2) After 'mmap()' call,it is impossible to call 'mmap()' again, even
> >      after calling 'madvise()'/'munmap()' on the whole mapping.This is
> >      because socket can't handle 'munmap()' calls(as there is no such
> >      callback in 'proto_ops'),thus polling page exists until socket is
> >      opened.
> >
> >After 'virtio_vsock_usr_hdr_pref' object,  first page contains array of
> >trimmed virtio vsock packet headers (in contains only length of data on
> >the corresponding page and 'flags' field):
> >
> >       struct virtio_vsock_usr_hdr {
> >               uint32_t length;
> >               uint32_t flags;
> >       };
> >
> >Field  'length'  allows user to know  exact size of payload within each
> >sequence of pages and field 'flags' allows  to  process SOCK_SEQPACKET
> >flags(such as message bounds or record bounds).All other pages are data
> >pages from virtio queue.
> >
> >                Page 0        Page 1      Page N
> >
> >       [ pref hdr0 .. hdrN ][ data ] .. [ data ]
> >                |        |       ^           ^
> >                |        |       |           |
> >                |        *-------|-----------*
> >                |                |
> >                *----------------*
> >
> >       Of course, single header could represent array of pages (when
> >packet's buffer is bigger than one page).So here is example of detailed
> >mapping layout for some set of packages. Lets consider that we have the
> >following sequence of packages:56 bytes, 4096 bytes and 8200 bytes. All
> >pages: 0,1,2,3,4 and 5 will be inserted to user's vma.
> >
> >       Page 0: [[ pref ][ hdr0 ][ hdr 1 ][ hdr 2 ][ hdr 3 ] ... ]
> >       Page 1: [ 56 ]
> >       Page 2: [ 4096 ]
> >       Page 3: [ 4096 ]
> >       Page 4: [ 4096 ]
> >       Page 5: [ 8 ]
> >
> >       Page 0 contains only array of headers:
> >       'pref' is 'struct virtio_vsock_usr_hdr_pref'.
> >       'hdr0' has 56 in length field.
> >       'hdr1' has 4096 in length field.
> >       'hdr2' has 8200 in length field.
> >       'hdr3' has 0 in length field(this is end of data marker).
> >
> >       Page 1 corresponds to 'hdr0' and has only 56 bytes of data.
> >       Page 2 corresponds to 'hdr1' and filled with data.
> >       Page 3 corresponds to 'hdr2' and filled with data.
> >       Page 4 corresponds to 'hdr2' and filled with data.
> >       Page 5 corresponds to 'hdr2' and has only 8 bytes of data.
> >
> >        pref will be the following: poll_value = 1, hdr_num = 5
> >
> >       This patchset also changes packets allocation way: current uses
> >only 'kmalloc()' to create data buffer.  Problem happens when we try to
> >map such buffers  to user's vma - kernel  restricts to map  slab pages
> >to user's vma(as pages of "not large" 'kmalloc()' allocations have flag
> >PageSlab set and "not large" could be bigger than one page).So to avoid
> >this, data buffers now allocated using 'alloc_pages()' call.
> >
> >                             DIFFERENCE WITH TCP
> >
> >       As this feature uses same approach as for TCP protocol,here are
> >some difference between both version(from user's POV):
> >
> >1) For 'getsockopt()':
> >   - This version passes only address of mapping.
> >   - TCP passes special structure to 'getsockopt()'. In addition to the
> >     address of mapping in contains 'length' and 'recv_skip_hint'.First
> >     means size of data inside mapping(out param, set by kernel).Second
> >     has bool type, if it is true, then user must dequeue rest of  data
> >     using 'read()' syscall(e.g. it is out parameter also).
> >2) Mapping structure:
> >   - This version uses first page of mapping for meta data and rest of
> >     pages for data.
> >   - TCP version uses whole mapping for data only.
> >3) Data layout:
> >   - This version inserts virtio buffers to mapping, so each buffer may
> >     be filled partially. To get size of payload in every buffer, first
> >     mapping's page must be used(see 2).
> >   - TCP version inserts pages of single skb.
> >
> >*Please, correct me if I made some mistake in TCP zerocopy description.
>
>
> Thank you for the description. Do you think it would be possible to try
> to do the same as TCP?
> Especially now that we should support skbuff.
>
> >
> >                                TESTS
> >
> >       This patchset updates 'vsock_test' utility: two tests for new
> >feature were added. First test covers invalid cases.Second checks valid
> >transmission case.
>
> Thank you, I really appreciate you adding new tests each time! Great
> job!
>
> >
> >                            BENCHMARKING
> >
> >       For benchmakring I've created small test utility 'vsock_rx_perf'.
> >It works in client/server mode.  When client connects to server, server
> >starts sending specified amount of data to client(size is set as input
> >argument). Client reads data and waits for next portion of it. In client
> >mode, dequeue logic works in three modes: copy, zerocopy and zerocopy
> >with user polling.
>
> Cool, thanks for adding it in this series.
>
> >
> >1) In copy mode client uses 'read()' system call.
> >2) In zerocopy mode client uses 'mmap()'/'getsockopt()' to dequeue data
> >   and 'poll()' to wait data.
> >3) In zerocopy mode + user polling client uses 'mmap()'/'getsockopt()',
> >   but to wait data it polls shared page(e.g. busyloop).
> >
> >Here is usage:
> >-c <cid>       Peer CID to connect to(if run in client mode).
> >-m <megabytes> Number of megabytes to send.
> >-b <bytes>     Size of RX/TX buffer(or mapping) in pages.
> >-r <bytes>     SO_RCVLOWAT value in bytes(if run in client mode).
> >-v <bytes>     peer credit.
> >-s             Run as server.
> >-z [n|y|u]     Dequeue mode.
> >               n - copy mode. 1) above.
> >               y - zero copy mode. 2) above.
> >               u - zero copy mode + user poll. 3) above.
> >
> >Utility produces the following output:
> >1) In server mode it prints number of sec spent for whole tx loop.
> >2) In client mode it prints several values:
> >   * Number of sec, spent for whole rx loop(including 'poll()').
> >   * Number of sec, spend in dequeue system calls:
> >     In case of '-z n' it will be time in 'read()'.
> >     In case of '-z y|u' it will be time in 'getsockopt()' + 'madvise()'.
> >   * Number of wake ups with POLLIN flag set(except '-z u' mode).
> >   * Average time(ns) in single dequeue iteration(e.g. divide second
> >     value by third).
> >
> >Idea of test is to compare zerocopy approach and classic copy, as it is
> >clear, that to dequeue some "small" amount of data, copy must be better,
> >because syscall with 'memcpy()' for 1 byte(for example) is just nothing
> >against two system calls, where first must map at least one page, while
> >second will unmap it.
> >
> >Test was performed with the following settings:
> >1) Total size of data to send is 2G(-m argument).
> >
> >2) Peer's buffer size is changed to 2G(-v argument) - this is needed to
> >   avoid stalls of sender to wait for enough credit.
> >
> >3) Both buffer size(-b) and SO_RCVLOWAT(-r) are used to control number
> >   of bytes to dequeue in single loop iteration. Buffer size limits max
> >   number of bytes to read, while SO_RCVLOWAT won't allow user to get
> >   too small number of bytes.
> >
> >4) For sender, tx buffer(which is passed to 'write()') size is 16Mb. Of
> >   course we can set it to peer's buffer size and as we are in STREAM
> >   mode it leads to 'write()' will be called once.
> >
> >Deignations here and below:
> >H2G - host to guest transmission. Server is host, client is guest.
> >G2H - guest to host transmission. Server is guest, client is host.
> >C   - copy mode.
> >ZC  - zerocopy mode.
> >ZU  - zerocopy with user poll mode. This mode is removed from test at
> >      this moment, because I need to support SO_RCVLOWAT logic in it.
> >
> >So, rows corresponds to dequeue mode, while columns show number of
>
> Maybe it would be better to label the rows, I guess the first one is C
> and the second one ZC?
>
> Maybe it would be better to report Gbps so if we change the amount of
> data exchanged, we always have a way to compare.
>
> >bytes
> >to dequeue in each mode. Each cell contains several values in the next
> >format:
> >*------------*
> >|   A / B    |
> >|     C      |
> >|     D      |
> >*------------*
> >
> >A - number of seconds which server spent in tx loop.
> >B - number of seconds which client spent in rx loop.
> >C - number of seconds which client spent in rx loop, but except 'poll()'
> >    system call(e.g. only in dequeue system calls).
> >D - Average number of ns for each POLLIN wake up(in other words
> >    it is average value for C).
>
> I see only 3 values in the cells, I missed which one is C and which one
> is D.
>
> >
> >G2H:
> >
> >            #0        #1        #2        #3        #4        #5
> >  *----*---------*---------*---------*---------*---------*---------*
> >  |    |         |         |         |         |         |         |
> >  |    |   4Kb   |   16Kb  |   64Kb  |  128Kb  |  256Kb  |  512Kb  |
> >  |    |         |         |         |         |         |         |
> >  *----*---------*---------*---------*---------*---------*---------*
> >  |    | 2.3/2.4 |2.48/2.53|2.34/2.38|2.73/2.76|2.65/2.68|3.26/3.35|
> >  |    |  7039   |  15074  |  34975  |  89938  |  162384 |  438278 |
> >  *----*---------*---------*---------*---------*---------*---------*
> >  |    |2.37/2.42|2.36/1.96|2.36/2.42|2.43/2.43|2.42/2.47|2.42/2.46|
> >  |    |  13598  |  15821  |  29574  |  43265  |  71771  |  150927 |
> >  *----*---------*---------*---------*---------*---------*---------*
> >
> >H2G:
> >
> >            #0        #1        #2        #3        #4        #5
> >  *----*---------*---------*---------*---------*---------*---------*
> >  |    |         |         |         |         |         |         |
> >  |    |   4Kb   |   16Kb  |   64Kb  |  128Kb  |  256Kb  |  512Kb  |
> >  |    |         |         |         |         |         |         |
> >  *----*---------*---------*---------*---------*---------*---------*
> >  |    | 1.5/5.3 |1.55/5.00|1.60/5.00|1.65/5.00|1.65/5.00|1.74/5.00|
> >  |    |  17145  |  24172  |  72650  |  143496 |  295960 |  674146 |
> >  *----*---------*---------*---------*---------*---------*---------*
> >  |    |1.10/6.21|1.10/6.00|1.10/5.48|1.10/5.38|1.10/5.35|1.10/5.35|
> >  |    |  41855  |  46339  |  71988  |  106000 |  153064 |  242036 |
> >  *----*---------*---------*---------*---------*---------*---------*
> >
> >Here are my thoughts about these numbers(most obvious):
> >
> >1) Let's check C and D values. We see, that zerocopy dequeue is faster
> >   on big buffers(in G2H it starts from 64Kb, in H2g - from 128Kb). I
> >   think this is main result of this test(at this moment), that shows
> >   performance difference between copy and zerocopy).
>
> Yes, I think this is expected.
>
> >
> >2) In G2H mode both server and client spend almost same time in rx/tx
> >   loops(see A / B in G2H table) - it looks good. In H2G mode, there is
> >   significant difference between server and client. I think  there are
> >   some side effects which produces such effect(continue to analyze).
>
> Perhaps a different cost to notify the receiver? I think it's better to
> talk about transmitter and receiver, instead of server and client, I
> think it's confusing.
>
> >
> >3) Let's check C value. We can see, that G2H is always faster that H2G.
> >   In both copy and zerocopy mode.
>
> This is expected because the guest queues buffers up to 64K entirely,
> while the host has to split packets into the guest's preallocated
> buffers, which are 4K.
>
> >
> >4) Another interesting thing could be seen for example in H2G table,
> >   row #0, col #4 (case for 256Kb). Number of seconds in zerocopy mode
> >   is smaller than in copy mode(1.25 vs 2.42), but whole rx loop was
>
> I see 1.65 vs 1.10, are these the same data, or am I looking at it
> wrong?
>
> >   faster in copy mode(5 seconds vs 5.35 seconds). E.g. if we account
> >   time spent in 'poll()', copy mode looks faster(even it spends more
> >   time in 'read()' than zerocopy loop in 'getsockopt()' + 'madvise()').
> >   I think, it is also not obvious effect.
> >
> >So, according 1), it is better to use zerocopy, if You need to process
> >big buffers, with small rx waitings(for example it nay be video stream).
> >In other cases - it is better to use classic copy way, as it will be
> >more lightweight.
> >
> >All tests were performed on x86 board with 4-core Celeron N2930 CPU(of
> >course it is, not a mainframe, but better than test with nested guest)
> >and 8Gb of RAM.
> >
> >Anyway, this is not final version, and I will continue to improve both
> >kernel logic and performance tests.
>
> Great work so far!
>
> Maybe to avoid having to rebase everything later, it's already
> worthwhile to start using Bobby's patch with skbuff.
>
> >
> >                           SUGGESTIONS
> >
> >1) I'm also working on MSG_ZEROCOPY support for virtio/vsock. May be I
> >   can merge both patches into single one?
>
> This is already very big, so I don't know if it's worth breaking into a
> preparation series and then a series that adds both.

For example, some test patches not related to zerocopy could go
separately. Maybe even vsock_rx_perf without the zerocopy part that is
not definitive for now.

Too big a set is always scary, even if this one is divided well, but
some patches as mentioned could go separately.

I left some comments, but as said I prefer to review it after the
rebase with skbuff, because I think it changes enough. I'm sorry about
that, but having the skbuffs I think is very important.

Thanks,
Stefano

