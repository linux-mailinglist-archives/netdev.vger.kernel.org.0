Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66DA5A024F
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 21:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239116AbiHXTwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 15:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbiHXTwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 15:52:15 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981B07A519;
        Wed, 24 Aug 2022 12:52:14 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id c16-20020a17090aa61000b001fb3286d9f7so4022530pjq.1;
        Wed, 24 Aug 2022 12:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc;
        bh=1nu8oahj75UTgypLcyNOx3EXwxh8DT56p0t7+dOXmX0=;
        b=LTAmQ+2FW4tG9keAelAGoujtNrW/xeh1XYCdsa2ntMUeslU2BQdgTn02mseiYA0WX+
         umKXJrnOTD1HK5vVLAAvOgn5HGFeOsraSLOjMXob07JFBIioS4OlU9RP1+QL6eKgivfl
         NSy0PrXs0WcAd6cw4iA7qgG/Ff2fzhn2JaUYjxIYppX+1LsKJ+e9cC8gtdFDys/aByoA
         xj18Sk2IiqvDGrW93tuGkwa8Ocqd+QxOJS8NVU4ijSdHBga6iu7NCxDr+5wGTxzAk1Gi
         n9rbTrsOpg/kiB0vLRNRLbn46KXFA5cUfMDbhGdHTOwsb+kdAf3/6a5EeICVoORsUTQn
         Ccbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc;
        bh=1nu8oahj75UTgypLcyNOx3EXwxh8DT56p0t7+dOXmX0=;
        b=w5PYvOQzJl93NNbTbL2tPgkr7e75MGr19VEZtQSg+1sifUHlK+HmYZkfyHOU59FTPk
         h5h2s3LFjVyHqv1RQiTQQU40BXLcqct/4wB99j8mStLI7ZbFR6o1R+FQquD+dOn0IZCM
         L3ZXHPwn1b0Bk7VIv0g/q5Xd1MpYeDNmHUuZrbSqGWq4UMcRMLwIj47RU420Ivobxagn
         O8nuLnWR0yk1pP/esh0EK7o/VcjfxdFe7DdpmkGsnsiShZK1qJzvfHUqEWVmbLzR0p0W
         qaZXSMKADQ6D+ivvJyFuCQA2XRprma9Q1SDoecoyzW22iIGCEQwQx0l6Rxk7fzpRdB43
         ZCeQ==
X-Gm-Message-State: ACgBeo2YrUyKUKDOJEeiiEtupeM0NiT10pzOTKcb7PAcuH5ZskXB3EI8
        NboVzPTf+JhONUCHyf4foLA=
X-Google-Smtp-Source: AA6agR51+VkdG4JOSWswyaY4Yap2VcDTy5LbH54K1soERUDw0c9lzTefQs+jzkUxK/735D8rvvHlXg==
X-Received: by 2002:a17:90b:1a88:b0:1f7:3daa:f2f6 with SMTP id ng8-20020a17090b1a8800b001f73daaf2f6mr9996426pjb.245.1661370734096;
        Wed, 24 Aug 2022 12:52:14 -0700 (PDT)
Received: from smtpclient.apple ([216.160.66.82])
        by smtp.gmail.com with ESMTPSA id f26-20020aa79d9a000000b0053602e1d6fcsm6768973pfq.105.2022.08.24.12.52.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Aug 2022 12:52:13 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [net-next v2 0/6] net: support QUIC crypto
From:   Matt Joras <matt.joras@gmail.com>
In-Reply-To: <CADvbK_fVRVYjtSkn29ec70mko9aEwnwu+kHYx8bAAWm-n25mjA@mail.gmail.com>
Date:   Wed, 24 Aug 2022 12:52:12 -0700
Cc:     Adel Abouchaev <adel.abushaev@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, davem <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        David Ahern <dsahern@kernel.org>, shuah@kernel.org,
        imagedong@tencent.com, network dev <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6BC43AA9-19A5-4FE3-B521-DD862853057E@gmail.com>
References: <adel.abushaev@gmail.com>
 <20220817200940.1656747-1-adel.abushaev@gmail.com>
 <CADvbK_fVRVYjtSkn29ec70mko9aEwnwu+kHYx8bAAWm-n25mjA@mail.gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Aug 24, 2022, at 11:29 AM, Xin Long <lucien.xin@gmail.com> wrote:
>=20
> On Wed, Aug 17, 2022 at 4:11 PM Adel Abouchaev =
<adel.abushaev@gmail.com> wrote:
>>=20
>> QUIC requires end to end encryption of the data. The application =
usually
>> prepares the data in clear text, encrypts and calls send() which =
implies
>> multiple copies of the data before the packets hit the networking =
stack.
>> Similar to kTLS, QUIC kernel offload of cryptography reduces the =
memory
>> pressure by reducing the number of copies.
>>=20
>> The scope of kernel support is limited to the symmetric cryptography,
>> leaving the handshake to the user space library. For QUIC in =
particular,
>> the application packets that require symmetric cryptography are the =
1RTT
>> packets with short headers. Kernel will encrypt the application =
packets
>> on transmission and decrypt on receive. This series implements Tx =
only,
>> because in QUIC server applications Tx outweighs Rx by orders of
>> magnitude.
>>=20
>> Supporting the combination of QUIC and GSO requires the application =
to
>> correctly place the data and the kernel to correctly slice it. The
>> encryption process appends an arbitrary number of bytes (tag) to the =
end
>> of the message to authenticate it. The GSO value should include this
>> overhead, the offload would then subtract the tag size to parse the
>> input on Tx before chunking and encrypting it.
>>=20
>> With the kernel cryptography, the buffer copy operation is conjoined
>> with the encryption operation. The memory bandwidth is reduced by =
5-8%.
>> When devices supporting QUIC encryption in hardware come to the =
market,
>> we will be able to free further 7% of CPU utilization which is used
>> today for crypto operations.
>>=20
>> Adel Abouchaev (6):
>>  Documentation on QUIC kernel Tx crypto.
>>  Define QUIC specific constants, control and data plane structures
>>  Add UDP ULP operations, initialization and handling prototype
>>    functions.
>>  Implement QUIC offload functions
>>  Add flow counters and Tx processing error counter
>>  Add self tests for ULP operations, flow setup and crypto tests
>>=20
>> Documentation/networking/index.rst     |    1 +
>> Documentation/networking/quic.rst      |  185 ++++
>> include/net/inet_sock.h                |    2 +
>> include/net/netns/mib.h                |    3 +
>> include/net/quic.h                     |   63 ++
>> include/net/snmp.h                     |    6 +
>> include/net/udp.h                      |   33 +
>> include/uapi/linux/quic.h              |   60 +
>> include/uapi/linux/snmp.h              |    9 +
>> include/uapi/linux/udp.h               |    4 +
>> net/Kconfig                            |    1 +
>> net/Makefile                           |    1 +
>> net/ipv4/Makefile                      |    3 +-
>> net/ipv4/udp.c                         |   15 +
>> net/ipv4/udp_ulp.c                     |  192 ++++
>> net/quic/Kconfig                       |   16 +
>> net/quic/Makefile                      |    8 +
>> net/quic/quic_main.c                   | 1417 =
++++++++++++++++++++++++
>> net/quic/quic_proc.c                   |   45 +
>> tools/testing/selftests/net/.gitignore |    4 +-
>> tools/testing/selftests/net/Makefile   |    3 +-
>> tools/testing/selftests/net/quic.c     | 1153 +++++++++++++++++++
>> tools/testing/selftests/net/quic.sh    |   46 +
>> 23 files changed, 3267 insertions(+), 3 deletions(-)
>> create mode 100644 Documentation/networking/quic.rst
>> create mode 100644 include/net/quic.h
>> create mode 100644 include/uapi/linux/quic.h
>> create mode 100644 net/ipv4/udp_ulp.c
>> create mode 100644 net/quic/Kconfig
>> create mode 100644 net/quic/Makefile
>> create mode 100644 net/quic/quic_main.c
>> create mode 100644 net/quic/quic_proc.c
>> create mode 100644 tools/testing/selftests/net/quic.c
>> create mode 100755 tools/testing/selftests/net/quic.sh
>>=20
>>=20
>> base-commit: fd78d07c7c35de260eb89f1be4a1e7487b8092ad
>> --
>> 2.30.2
>>=20
> Hi, Adel,
>=20
> I don't see how the key update(rfc9001#section-6) is handled on the TX
> path, which is not using TLS Key update, and "Key Phase" indicates
> which key will be used after rekeying. Also, I think it is almost
> impossible to handle the peer rekeying on the RX path either based on
> your current model in the future.
Key updates are not something that needs to be handled by the kernel in =
this
model. I.e. a key update will be processed as normal by the userspace =
QUIC code and
the sockets will have to be re-associated with the new keying material.
>=20
> The patch seems to get the crypto_ctx by doing a connection hash table
> lookup in the sendmsg(), which is not good from the performance side.
> One QUIC connection can go over multiple UDP sockets, but I don't
> think one socket can be used by multiple QUIC connections. So why not
> save the ctx in the socket instead?
There=E2=80=99s nothing preventing a single socket or UDP/IP tuple from =
being used
by multiple QUIC connections. This is achievable due to both endpoints =
having
CIDs. Note that it is not uncommon for QUIC deployments to use a single =
socket for
all connections, rather than the TCP listen/accept model. That being =
said, it
would be nice to be able to avoid the lookup cost when using a connected =
socket.

>=20
> The patch is to reduce the copying operations between user space and
> the kernel. I might miss something in your user space code, but the
> msg to send is *already packed* into the Stream Frame in user space,
> what's the difference if you encrypt it in userspace and then
> sendmsg(udp_sk) with zero-copy to the kernel.
I would not say that reducing copy operations is the primary goal of =
this
work. There are already ways to achieve minimal copy operations for UDP =
from
userspace.=20
>=20
> Didn't really understand the "GSO" you mentioned, as I don't see any
> code about kernel GSO, I guess it's just "Fragment size", right?
> BTW, it=E2=80=98s not common to use "//" for the kernel annotation.
>=20
> I'm not sure if it's worth adding a ULP layer over UDP for this QUIC
> TX only. Honestly, I'm more supporting doing a full QUIC stack in the
> kernel independently with socket APIs to use it:
> https://github.com/lxin/tls_hs.
A full QUIC stack in the kernel with associated socket APIs is solving a
different problem than this work. Having an API to offload crypto =
operations of QUIC
allows for the choice of many different QUIC implementations in =
userspace while
potentially taking advantage of offloading the main CPU cost of an =
encrypted protocol.
>=20
> Thanks.
>=20

Best,
Matt Joras=
