Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AABF5ECA92
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 19:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbiI0RM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 13:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiI0RMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 13:12:54 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CE51B8CBF
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 10:12:52 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id i17so3450411qkk.12
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 10:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=OiY5rTg7VuhmYymVKAvhy3a2Viv1gv5iq9jVHgcVhoo=;
        b=Cyaj3DXeuxOqDwfDoeKxig+AmOf6rB9Lo+Up8G4NmzjQlDqn9j/oOY405eSYaMVi2+
         Co67QWpVc6W0uq3SFu/ES6dQHBjbIzJkYrHOXgXzuJ6xX7uynNn1QWzTJ1lIiW0Aq5iD
         /+pwfqzghCxnVvLkRV1j7m2pajju9eQVQSL79FpwoZqG+REqh4R44nVtupwyj+eGPpGc
         ofX7+dIr1YHxxr8htDQ9HAji34uJ1vec/p82hYJTIBUwvZZJznIdSifoCeHVYzD68fi8
         GLZGhu8KtuGM7XMYPcKfUZXAKyw7E48FGUFcPEHJPfqSj/WPItlp9/B0uqVwFbmtaWkO
         DM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=OiY5rTg7VuhmYymVKAvhy3a2Viv1gv5iq9jVHgcVhoo=;
        b=FAOC/bkXj5zx/wubgMErGoHPlavsLLoigiz6OYf5bDZyCpHXk4Gz3QWUoD3ywjVAWR
         9J72+FGp1ziDZ9/6oJGzGAjogDmk4OZP6qHZ8GXPbGy9vVWfHYvHbJl7WDHbOIHMgkwC
         re2W+O1bgA7B9F3jdWzzbJkjl9+I4JQVzlKythHMLQH3CARtSKeNosfEHlSE+SuIkIQt
         Yno6iespuF20/tPOuwZUgoAt7Vu4HCvmaKIV8+2xazDhl7gPN0Ik4epl5TaYUcJmQL9C
         S68KK8gmIt5FGQEysiHksr6qp4mCRqEo9bbtOfVBQ9zckDQcW60SMIpi2qjeRcnPwHAc
         e41Q==
X-Gm-Message-State: ACrzQf1mML+yI9mabkKKjqCp+N34ddik7IlzbANaLJwK6w6wDN2Pzn2G
        WtOhKXQE+QGle2dvBXlU1jlE8GyZ07g=
X-Google-Smtp-Source: AMsMyM4Q3AmzsHxbzvRLhJbWXiyH0hr3lFB1i2rOpPRdGBjTdJaKnvZPYIGjJQTGYH74+jUs4UBE5A==
X-Received: by 2002:a05:620a:2683:b0:6cf:3a7e:e006 with SMTP id c3-20020a05620a268300b006cf3a7ee006mr18506389qkp.474.1664298771851;
        Tue, 27 Sep 2022 10:12:51 -0700 (PDT)
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com. [209.85.128.178])
        by smtp.gmail.com with ESMTPSA id ga17-20020a05622a591100b0035d0a021dcasm1126197qtb.63.2022.09.27.10.12.50
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 10:12:51 -0700 (PDT)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-333a4a5d495so106424237b3.10
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 10:12:50 -0700 (PDT)
X-Received: by 2002:a81:de44:0:b0:341:6954:52b2 with SMTP id
 o4-20020a81de44000000b00341695452b2mr25648802ywl.208.1664298770377; Tue, 27
 Sep 2022 10:12:50 -0700 (PDT)
MIME-Version: 1.0
References: <adel.abushaev@gmail.com> <20220817200940.1656747-1-adel.abushaev@gmail.com>
 <CADvbK_fVRVYjtSkn29ec70mko9aEwnwu+kHYx8bAAWm-n25mjA@mail.gmail.com>
 <f479b419-b05d-2cae-4fd0-4e88707b8d8b@gmail.com> <CA+FuTSf_8MjF4jeUjEqDrOwqXzf485jX_GJyVP5kPUDzOFezkg@mail.gmail.com>
 <0c989c58-2aa6-eca6-2bb9-24b1ae71694a@gmail.com>
In-Reply-To: <0c989c58-2aa6-eca6-2bb9-24b1ae71694a@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 27 Sep 2022 13:12:13 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdCmWu5w09KZshCv=TVugf_x5NUY1xjv4X8kgbEQ+WbHQ@mail.gmail.com>
Message-ID: <CA+FuTSdCmWu5w09KZshCv=TVugf_x5NUY1xjv4X8kgbEQ+WbHQ@mail.gmail.com>
Subject: Re: [net-next v2 0/6] net: support QUIC crypto
To:     Adel Abouchaev <adel.abushaev@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, davem <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        David Ahern <dsahern@kernel.org>, shuah@kernel.org,
        imagedong@tencent.com, network dev <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 12:45 PM Adel Abouchaev <adel.abushaev@gmail.com> w=
rote:
>
>
> On 9/25/22 11:04 AM, Willem de Bruijn wrote:
> >>> The patch seems to get the crypto_ctx by doing a connection hash tabl=
e
> >>> lookup in the sendmsg(), which is not good from the performance side.
> >>> One QUIC connection can go over multiple UDP sockets, but I don't
> >>> think one socket can be used by multiple QUIC connections. So why not
> >>> save the ctx in the socket instead?
> >> A single socket could have multiple connections originated from it,
> >> having different destinations, if the socket is not connected. An
> >> optimization could be made for connected sockets to cache the context
> >> and save time on a lookup. The measurement of kernel operations timing
> >> did not reveal a significant amount of time spent in this lookup due t=
o
> >> a relatively small number of connections per socket in general. A shar=
ed
> >> table across multiple sockets might experience a different performance
> >> grading.
> > I'm late to this patch series, sorry. High quality implementation. I
> > have a few design questions similar to Xin.
> >
> > If multiplexing, instead of looking up a connection by { address, port
> > variable length connection ID }, perhaps return a connection table
> > index on setsockopt and use that in sendmsg.
>
>
> It was deliberate to not to return anything other than 0 from
> setsockopt() as defined in the spec for the function. Despite that it
> says "shall", the doc says that 0 is the only value for successful
> operation. This was the reason not to use setsockopt() for any
> bidirectional transfers of data and or status. A more sophisticated
> approach with netlink sockets would be more suitable for it. The second
> reason is the API asymmetry for Tx and Rx which will be introduced - the

I thought the cover letter indicated that due to asymmetry of most
QUIC workloads, only Tx offload is implemented. You do intend to add
Rx later?

> Rx will still need to match on the address, port and cid. The third
> reason is that in current implementations there are no more than a few
> connections per socket,

This is very different from how we do QUIC at Google. There we
definitely multiplex many connections across essentially a socket per
CPU IIRC.

> which does not abuse the rhashtable that does a
> lookup, although it takes time to hash the key into a hash for a seek.
> The performance measurement ran against the runtime and did not flag
> this path as underperforming either, there were other parts that
> substantially add to the runtime, not the key lookup though.
>
>
> >>> The patch is to reduce the copying operations between user space and
> >>> the kernel. I might miss something in your user space code, but the
> >>> msg to send is *already packed* into the Stream Frame in user space,
> >>> what's the difference if you encrypt it in userspace and then
> >>> sendmsg(udp_sk) with zero-copy to the kernel.
> >> It is possible to do it this way. Zero-copy works best with packet siz=
es
> >> starting at 32K and larger.  Anything less than that would consume the
> >> improvements of zero-copy by zero-copy pre/post operations and needs t=
o
> >> align memory.
> > Part of the cost of MSG_ZEROCOPY is in mapping and unmapping user
> > pages. This series re-implements that with its own get_user_pages.
> > That is duplicative non-trivial code. And it will incur the same cost.
> > What this implementation saves is the (indeed non-trivial)
> > asynchronous completion notification over the error queue.
> >
> > The cover letter gives some performance numbers against a userspace
> > implementation that has to copy from user to kernel. It might be more
> > even to compare against an implementation using MSG_ZEROCOPY and
> > UDP_SEGMENT. A userspace crypto implementation may have other benefits
> > compared to a kernel implementation, such as not having to convert to
> > crypto API scatter-gather arrays and back to network structures.
> >
> > A few related points
> >
> > - The implementation support multiplexed connections, but only one
> > crypto sendmsg can be outstanding at any time:
> >
> >    + /**
> >    + * To synchronize concurrent sendmsg() requests through the same so=
cket
> >    + * and protect preallocated per-context memory.
> >    + **/
> >    + struct mutex sendmsg_mux;
> >
> > That is quite limiting for production workloads.
>
> The use case that we have with MVFST library currently runs a single
> worker for a connection and has a single socket attached to it. QUIC
> allows simultaneous use of multiple connection IDs to swap them in
> runtime, and implementation would request only a handful of these. The
> MVFST batches writes into a block of about 8Kb and then uses GSO to send
> them all at once.
>
> > - Crypto operations are also executed synchronously, using
> > crypto_wait_req after each operationn. This limits throughput by using
> > at most one core per UDP socket. And adds sendmsg latency (which may
> > or may not be important to the application). Wireguard shows an
> > example of how to parallelize software crypto across cores.
> >
> > - The implementation avoids dynamic allocation of cipher text pages by
> > using a single ctx->cipher_page. This is protected by sendmsg_mux (see
> > above). Is that safe when packets leave the protocol stack and are
> > then held in a qdisc or when being processed by the NIC?
> > quic_sendmsg_locked will return, but the cipher page is not free to
> > reuse yet.
> There is currently no use case that we have in hands that requires
> parallel transmission of data for the same connection. Multiple
> connections would have no issue running in parallel as each of them will
> have it's own preallocated cipher_page in the context.

This still leaves the point that sendmsg may return and the mutex
released while the cipher_page is still associated with an skb in the
transmit path.

> There is a fragmentation further down the stack with
> ip_generic_getfrag() that eventually does copy_from_iter() and makea a
> copy of the data. This is executed as part of __ip_append_data() called
> from udp_sendmsg() in ipv4/udp.c. The assumption was that this is
> executed synchronously and the queues and NIC will see a mapping of a
> different memory area than the ciphertext in the pre-allocated page.
>
> >
> > - The real benefit of kernel QUIC will come from HW offload. Would it
> > be better to avoid the complexity of an in-kernel software
> > implementation and only focus on HW offload? Basically, pass the
> > plaintext QUIC packets over a standard UDP socket and alongside in a
> > cmsg pass either an index into a HW security association database or
> > the immediate { key, iv } connection_info (for stateless sockets), to
> > be encoded into the descriptor by the device driver.
> Hardware usually targets a single ciphersuite such as AES-GCM-128/256,
> while QUIC also supports Chacha20-Poly1305 and AES-CCM. The generalized
> support for offload prompted implementation of these ciphers in kernel
> code.

All userspace libraries also support all protocols as fall-back. No
need for two fall-backs if HW support is missing?

> The kernel code could also engage if the future hardware has
> capacity caps preventing it from handling all requests in the hardware.
> > - With such a simpler path, could we avoid introducing ULP and just
> > have udp [gs]etsockopt CRYPTO_STATE. Where QUIC is the only defined
> > state type yet.
> >
> > - Small aside: as the series introduces new APIs with non-trivial
> > parsing in the kernel, it's good to run a fuzzer like syzkaller on it
> > (if not having done so yet).
> Agreed.
> >> The other possible obstacle would be that eventual support
> >> of QUIC encryption and decryption in hardware would integrate well wit=
h
> >> this current approach.
> >>> Didn't really understand the "GSO" you mentioned, as I don't see any
> >>> code about kernel GSO, I guess it's just "Fragment size", right?
> >>> BTW, it=E2=80=98s not common to use "//" for the kernel annotation.
> > minor point: fragment has meaning in IPv4. For GSO, prefer gso_size.
> Sure, will change it to gso_size.
> >
> >> Once the payload arrives into the kernel, the GSO on the interface wou=
ld
> >> instruct L3/L4 stack on fragmentation. In this case, the plaintext QUI=
C
> >> packets should be aligned on the GSO marks less the tag size that woul=
d
> >> be added by encryption. For GSO size 1000, the QUIC packets in the bat=
ch
> >> for transmission should all be 984 bytes long, except maybe the last
> >> one. Once the tag is attached, the new size of 1000 will correctly spl=
it
> >> the QUIC packets further down the stack for transmission in individual
> >> IP/UDP packets. The code is also saving processing time by sending all
> >> packets at once to UDP in a single call, when GSO is enabled.
> >>> I'm not sure if it's worth adding a ULP layer over UDP for this QUIC
> >>> TX only. Honestly, I'm more supporting doing a full QUIC stack in the
> >>> kernel independently with socket APIs to use it:
> >>> https://github.com/lxin/tls_hs.
> >>>
> >>> Thanks.
