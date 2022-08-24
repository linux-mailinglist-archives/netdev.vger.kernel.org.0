Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEA55A015D
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 20:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238988AbiHXS3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 14:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiHXS3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 14:29:52 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE03BC01;
        Wed, 24 Aug 2022 11:29:51 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-11c5ee9bf43so21900027fac.5;
        Wed, 24 Aug 2022 11:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=3PBLwj73GQcNbfJuvhMRVxprdNdH6ePGfPg7tsCuPPk=;
        b=l81I12x+dk8BfD+tCMqXPTv9+9QO/1LZ+BA9aQV3Fqy/FMsoRm7Vjh4VUK71OLX7OU
         2WnR49laYLTk2NA0H9k+PeklpZ4t1S3eoD7BL7/Uq+6Zo6MWPmoT3ImIdvrlMs0/CPMU
         sFiAh6b4ZGr84B589B/iYY2qc58eZppGmOLYN7isObUZ9AToTxdShOYOFzHdWvAeF7Wb
         RMBUqwyOswuMkB3pjcbJpt7ZFlMjC1Q3cjraM/K5UvqYk/1nI9Xm/S1bRkVzT8r+KptH
         GtWZqilQne98Q+fFSjAqoCn8IbNCUUJswBtEut7ZXYh1BFIUvY5L0XmLTpGwtU9kJoqb
         SllQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=3PBLwj73GQcNbfJuvhMRVxprdNdH6ePGfPg7tsCuPPk=;
        b=fGJ9/9leIq1DpwsUuHkt95UQAeeoQyrqXOusxR1yx2jK/htuR3UA9su1khqwcMHRPl
         VuBVVXhbLmLWIXeqoHlDRjdxvhivi+6pgRRPWo3gpnhVx6PT9C555X6Mv3OReewgmx4j
         8imEhHjgRPS/jnC8Zp7Fwu2Wr/ZAh3WM2eNs3g35wEpAoysrTsLRokA7h7e5G+XuU5jo
         ipGjE7097ZoGGI7z5qSqPkz3wtjvDwOk3rJ7NiqyqJ76LKz+eaay1YUgR/4QRVvA0ovX
         3a2lQHP9R3vg1gHRR7fPdc87LB1kfEubHTdvwv+c+aD3F9tOZiYPtAPe5rUgS276mq4g
         RhAQ==
X-Gm-Message-State: ACgBeo1XNvnlU3k0I/svqjxVyz3pGJ0c3rCKKUjr1IA7uKyMSd3wGjSI
        1+ltn8HcmwtsVHCG6zizFYesfzZ5X0pfC3CGmw0=
X-Google-Smtp-Source: AA6agR5ehM5tr/msXoBWAX3aSxjiMFJSixN386od7UPqVsiCr+AhoBDpyXJHLOeS3lr8ay8uaukUPRiw4llv+DmDFYA=
X-Received: by 2002:a05:6870:9614:b0:11d:3906:18fc with SMTP id
 d20-20020a056870961400b0011d390618fcmr4288026oaq.190.1661365790543; Wed, 24
 Aug 2022 11:29:50 -0700 (PDT)
MIME-Version: 1.0
References: <adel.abushaev@gmail.com> <20220817200940.1656747-1-adel.abushaev@gmail.com>
In-Reply-To: <20220817200940.1656747-1-adel.abushaev@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 24 Aug 2022 14:29:34 -0400
Message-ID: <CADvbK_fVRVYjtSkn29ec70mko9aEwnwu+kHYx8bAAWm-n25mjA@mail.gmail.com>
Subject: Re: [net-next v2 0/6] net: support QUIC crypto
To:     Adel Abouchaev <adel.abushaev@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem <davem@davemloft.net>,
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 4:11 PM Adel Abouchaev <adel.abushaev@gmail.com> wr=
ote:
>
> QUIC requires end to end encryption of the data. The application usually
> prepares the data in clear text, encrypts and calls send() which implies
> multiple copies of the data before the packets hit the networking stack.
> Similar to kTLS, QUIC kernel offload of cryptography reduces the memory
> pressure by reducing the number of copies.
>
> The scope of kernel support is limited to the symmetric cryptography,
> leaving the handshake to the user space library. For QUIC in particular,
> the application packets that require symmetric cryptography are the 1RTT
> packets with short headers. Kernel will encrypt the application packets
> on transmission and decrypt on receive. This series implements Tx only,
> because in QUIC server applications Tx outweighs Rx by orders of
> magnitude.
>
> Supporting the combination of QUIC and GSO requires the application to
> correctly place the data and the kernel to correctly slice it. The
> encryption process appends an arbitrary number of bytes (tag) to the end
> of the message to authenticate it. The GSO value should include this
> overhead, the offload would then subtract the tag size to parse the
> input on Tx before chunking and encrypting it.
>
> With the kernel cryptography, the buffer copy operation is conjoined
> with the encryption operation. The memory bandwidth is reduced by 5-8%.
> When devices supporting QUIC encryption in hardware come to the market,
> we will be able to free further 7% of CPU utilization which is used
> today for crypto operations.
>
> Adel Abouchaev (6):
>   Documentation on QUIC kernel Tx crypto.
>   Define QUIC specific constants, control and data plane structures
>   Add UDP ULP operations, initialization and handling prototype
>     functions.
>   Implement QUIC offload functions
>   Add flow counters and Tx processing error counter
>   Add self tests for ULP operations, flow setup and crypto tests
>
>  Documentation/networking/index.rst     |    1 +
>  Documentation/networking/quic.rst      |  185 ++++
>  include/net/inet_sock.h                |    2 +
>  include/net/netns/mib.h                |    3 +
>  include/net/quic.h                     |   63 ++
>  include/net/snmp.h                     |    6 +
>  include/net/udp.h                      |   33 +
>  include/uapi/linux/quic.h              |   60 +
>  include/uapi/linux/snmp.h              |    9 +
>  include/uapi/linux/udp.h               |    4 +
>  net/Kconfig                            |    1 +
>  net/Makefile                           |    1 +
>  net/ipv4/Makefile                      |    3 +-
>  net/ipv4/udp.c                         |   15 +
>  net/ipv4/udp_ulp.c                     |  192 ++++
>  net/quic/Kconfig                       |   16 +
>  net/quic/Makefile                      |    8 +
>  net/quic/quic_main.c                   | 1417 ++++++++++++++++++++++++
>  net/quic/quic_proc.c                   |   45 +
>  tools/testing/selftests/net/.gitignore |    4 +-
>  tools/testing/selftests/net/Makefile   |    3 +-
>  tools/testing/selftests/net/quic.c     | 1153 +++++++++++++++++++
>  tools/testing/selftests/net/quic.sh    |   46 +
>  23 files changed, 3267 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/networking/quic.rst
>  create mode 100644 include/net/quic.h
>  create mode 100644 include/uapi/linux/quic.h
>  create mode 100644 net/ipv4/udp_ulp.c
>  create mode 100644 net/quic/Kconfig
>  create mode 100644 net/quic/Makefile
>  create mode 100644 net/quic/quic_main.c
>  create mode 100644 net/quic/quic_proc.c
>  create mode 100644 tools/testing/selftests/net/quic.c
>  create mode 100755 tools/testing/selftests/net/quic.sh
>
>
> base-commit: fd78d07c7c35de260eb89f1be4a1e7487b8092ad
> --
> 2.30.2
>
Hi, Adel,

I don't see how the key update(rfc9001#section-6) is handled on the TX
path, which is not using TLS Key update, and "Key Phase" indicates
which key will be used after rekeying. Also, I think it is almost
impossible to handle the peer rekeying on the RX path either based on
your current model in the future.

The patch seems to get the crypto_ctx by doing a connection hash table
lookup in the sendmsg(), which is not good from the performance side.
One QUIC connection can go over multiple UDP sockets, but I don't
think one socket can be used by multiple QUIC connections. So why not
save the ctx in the socket instead?

The patch is to reduce the copying operations between user space and
the kernel. I might miss something in your user space code, but the
msg to send is *already packed* into the Stream Frame in user space,
what's the difference if you encrypt it in userspace and then
sendmsg(udp_sk) with zero-copy to the kernel.

Didn't really understand the "GSO" you mentioned, as I don't see any
code about kernel GSO, I guess it's just "Fragment size", right?
BTW, it=E2=80=98s not common to use "//" for the kernel annotation.

I'm not sure if it's worth adding a ULP layer over UDP for this QUIC
TX only. Honestly, I'm more supporting doing a full QUIC stack in the
kernel independently with socket APIs to use it:
https://github.com/lxin/tls_hs.

Thanks.
