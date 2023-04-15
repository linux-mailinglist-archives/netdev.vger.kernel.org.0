Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65506E31A5
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 15:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjDONsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 09:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjDONsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 09:48:02 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5363C27;
        Sat, 15 Apr 2023 06:48:01 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id gb12so19054246qtb.6;
        Sat, 15 Apr 2023 06:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681566480; x=1684158480;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8vePHPeVn8UTne29RvC+M+dkFJak8SL9HV2l9DJcANU=;
        b=cDDYj3R4xhp66ymGJ7dITZOKfV0i1JgiEEFrIUSBVbGGH5WRsaqvmCZRARj1tLX/8Z
         mNOQ37eI+L1PtWrOfCaaIZrAw0JLaIfAHoACoTrIlYFY6ts/urNImZAW7g3z2xou243P
         nnfRHONKKf41TCGpyMftVD3o1V6HNWs5OYGNVSiyw15hyHDZ6Ux729M4YBo91dISGQIO
         RXlzoDLjndYXZ75XHGmq5J4IZVvI1jGudAC0UsRg5OLPcRgYcJbg8rFtre4TbgaV2fVY
         e/BF5605cPtx/VmdNxOqxuNmPfaAL2cX0CGsdR2L/FxJJdLiHn3S+VDIrTjNvoMF72Kb
         /bdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681566480; x=1684158480;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8vePHPeVn8UTne29RvC+M+dkFJak8SL9HV2l9DJcANU=;
        b=g42bdTy1koYDeuVZejfnk64QI05HwxDVzLoa6DIfz4mH1oWqvjVbHlXd0sIVbh3zjo
         PceNRo4V0zH+vkpfNpVa+U6joSgBHbqUF6tAn7luVew/CWt6BpBuBveC1HTFg5i0BAZz
         AvBQg4OuvMUwPSBD0c6U+DJUlwrBmD1Qf0umbRmCRzA67sWp/p4QDj2cZWAPCKA6ZtUu
         nEh9MA86876t3mKU1yy2oSByWxTzKRPV7A8NTlDPUPEsjEhCajg+c1DelSEaV+//sZxn
         WhcX5poT5oqQEDyxchyYkLgv5bt5if1iw5ak686s7rIKD9Lx0IGCdEj12U7Jut+RfoUQ
         U7IQ==
X-Gm-Message-State: AAQBX9d6OwrakWNpq3ecamEJocsu+0PttgN+OhRR079B984/5QW0ujJZ
        j61YPfn51oX2H2G6AkwGVjQ=
X-Google-Smtp-Source: AKy350ZDBwMb1R6upBJ3G3Qt9g9me4ZeZ7bWMBi1ekiFUcy/4JztpvLijOKOgdlykFXLYKg+srJdPA==
X-Received: by 2002:ac8:5f0c:0:b0:3db:f58b:400 with SMTP id x12-20020ac85f0c000000b003dbf58b0400mr14994410qta.1.1681566480313;
        Sat, 15 Apr 2023 06:48:00 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id t12-20020a05622a148c00b003eddd355c37sm159644qtx.34.2023.04.15.06.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 06:47:59 -0700 (PDT)
Date:   Sat, 15 Apr 2023 09:47:59 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     "luwei (O)" <luwei32@huawei.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "imagedong@tencent.com" <imagedong@tencent.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "jbenc@redhat.com" <jbenc@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <643aab0f2f39c_1afa5d2943f@willemb.c.googlers.com.notmuch>
In-Reply-To: <47fca2c7-db7c-0265-d724-38dffc62debe@huawei.com>
References: <20230410022152.4049060-1-luwei32@huawei.com>
 <CANn89iKFLREJV_cfHEk6wz6xXVv_jSrZ_UyXAB8VpH7gMXacxQ@mail.gmail.com>
 <643447ba5224a_83e69294b6@willemb.c.googlers.com.notmuch>
 <450994d7-4a77-99df-6317-b535ea73e01d@huawei.com>
 <CANn89iLOcvDRMi9kVr86xNp5=h4JWpx9yYWicVxCwSMgAJGf_g@mail.gmail.com>
 <c90abe8c-ffa0-f986-11eb-bde65c84d18b@huawei.com>
 <6436b5ba5c005_41e2294dd@willemb.c.googlers.com.notmuch>
 <a30a8ffaa8dd4cb6a84103eecf0c3338@huawei.com>
 <643983f69b440_17854f2948c@willemb.c.googlers.com.notmuch>
 <64398b4c4585f_17abe429442@willemb.c.googlers.com.notmuch>
 <47fca2c7-db7c-0265-d724-38dffc62debe@huawei.com>
Subject: =?UTF-8?Q?Re:_=E7=AD=94=E5=A4=8D:_[PATCH_net]_net:_Add_check_for?=
 =?UTF-8?Q?_csum=5Fstart_in_skb=5Fpartial=5Fcsum=5Fset=28=29?=
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

luwei (O) wrote:
> =

> =E5=9C=A8 2023/4/15 1:20 AM, Willem de Bruijn =E5=86=99=E9=81=93:
> > Willem de Bruijn wrote:
> >> luwei (O) wrote:
> >>> yes, here is the vnet_hdr:
> >>>
> >>>      flags: 3
> >>>      gso_type: 3
> >>>      hdr_len: 23
> >>>      gso_size: 58452
> >>>      csum_start: 5
> >>>      csum_offset: 16
> >>>
> >>> and the packet:
> >>>
> >>> | vnet_hdr | mac header | network header | data ... |
> >>>
> >>>    memcpy((void*)0x20000200,
> >>>           "\x03\x03\x02\x00\x54\xe4\x05\x00\x10\x00\x80\x00\x00\x53=
\xcc\x9c\x2b"
> >>>           "\x19\x3b\x00\x00\x00\x89\x4f\x08\x03\x83\x81\x04",
> >>>           29);
> >>>    *(uint16_t*)0x200000c0 =3D 0x11;
> >>>    *(uint16_t*)0x200000c2 =3D htobe16(0);
> >>>    *(uint32_t*)0x200000c4 =3D r[3];
> >>>    *(uint16_t*)0x200000c8 =3D 1;
> >>>    *(uint8_t*)0x200000ca =3D 0;
> >>>    *(uint8_t*)0x200000cb =3D 6;
> >>>    memset((void*)0x200000cc, 170, 5);
> >>>    *(uint8_t*)0x200000d1 =3D 0;
> >>>    memset((void*)0x200000d2, 0, 2);
> >>>    syscall(__NR_sendto, r[1], 0x20000200ul, 0xe45ful, 0ul, 0x200000=
c0ul, 0x14ul);
> >> Thanks. So this can happen whenever a packet is injected into the tx=

> >> path with a virtio_net_hdr.
> >>
> >> Even if we add bounds checking for the link layer header in pf_packe=
t,
> >> it can still point to the network header.
> >>
> >> If packets are looped to the tx path, skb_pull is common if a packet=

> >> traverses tunnel devices. But csum_start does not directly matter in=

> >> the rx path (CHECKSUM_PARTIAL is just seen as CHECKSUM_UNNECESSARY).=

> >> Until it is forwarded again to the tx path.
> >>
> >> So the question is which code calls skb_checksum_start_offset on the=

> >> tx path. Clearly, skb_checksum_help. Also a lot of drivers. Which
> >> may cast the signed int return value to an unsigned. Even an u8 in
> >> the first driver I spotted (alx).
> >>
> >> skb_postpull_rcsum anticipates a negative return value, as do other
> >> core functions. So it clearly allowed in certain cases. We cannot
> >> just bound it.
> >>
> >> Summary after a long story: an initial investigation, but I don't ha=
ve
> >> a good solution so far. Maybe others have a good suggestiong based o=
n
> >> this added context.
> > Specific to skb_checksum_help, it appears that skb_checksum will
> > work with negative offset just fine.
> =

>  =C2=A0=C2=A0=C2=A0 =C2=A0 In this case maybe not, since it checksums f=
rom within the mac =

> header, and the mac header
> =

>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 will be stripped when the rx path=
 checks the checksum.

The header is pulled, but still present. Obviously something bogus gets
written if the virtio_net_hdr configures csum offload with a bogus
offset. But as long as the offset is zero or positive from skb->head,
the checksum helper works as intended.
 =

> >
> > Perhaps the only issue is that the WARN_ON_ONCE compares signed to
> > unsigned, and thus incorrectly interprets a negative offset as
> >   >=3D skb_headlen(skb)

