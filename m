Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C2E6E63F6
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 14:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjDRMo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 08:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbjDRMoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 08:44:55 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7D3118C9;
        Tue, 18 Apr 2023 05:44:54 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id fv6so15762624qtb.9;
        Tue, 18 Apr 2023 05:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681821893; x=1684413893;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u//LQYDS+VuadTIFmR9meMJEyMLjxtTKHqVLJAzFJgU=;
        b=VWF3Tf0XTZfvl1p3++okKWX1rLhVtRTh3SCN8uzr1fPWJ4PUH7dHHVg3U3ufYAXlIL
         XjbqV71V4DYq1ryD7OyuVutZOq/BjHA4BMpkqB+LyCFw/cMGyB05HHOBzXWto0xZdCL5
         SopaT/QUuCemcSOqTqSbhTyqippTmmb5TseHUmr9SPu+BuGGej7ISXhrdRPENEZlBFpK
         Fg6LiFkhJP8Kq1Nf6SQBIt0apJpUDLdESDsULPrV/JVpv5TVhAjQXj7WNNix8HZClTE9
         6Njh0UTdTDQ04BN6XE9Om3zVy1lYayq7ja3kVGezkLorhzpFZlUjTGV+FlMMN18r0ZO9
         vTRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681821893; x=1684413893;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u//LQYDS+VuadTIFmR9meMJEyMLjxtTKHqVLJAzFJgU=;
        b=XT5sCNJaT1DfnJlucucXiKT0xUeEHFJeMVSNE78eLakyWMW0wE13e2wIWXRUEPr/Ge
         osgIeQFZI1EmF22LTFln5i6LaEuHhnutVUpcLJF3JSstqlXPd/7yA8QEN0gbvWLCfZZ4
         K/6aVGGHb1t9/JPe17Rp6UGVym4xhgQ5ZSiwZwPLiL5wfXQt3xQmPb15j1FCCfQWWqrN
         e2QHIA1Xwe18PhOmxRKPzMFglRe299TrIwNp9jAv2t2mGTAvcKCk6OgwlnmX7wM1E6C0
         OD9Uo1DKZ7g/H0dWl1Ttcn56GSiMjUHnN4jwWV5hsF4L/jnjgdv1EJxNjj19ysBb3YKh
         aeSg==
X-Gm-Message-State: AAQBX9c9qZw5+TwSj/p8vp6T/DvMh3tQki66KCB0mxyKuFIiYi5ZJxeV
        jj4M/2NJq6VYy9ldATr2eP4=
X-Google-Smtp-Source: AKy350b7eHdH8LO3jawP225cJsvVlppKbI8nuylOLCQ6r3Ey9pjFblJuDWAPx26RZAELOUqW7ZOeqw==
X-Received: by 2002:ac8:7f88:0:b0:3e4:e4e4:ec1 with SMTP id z8-20020ac87f88000000b003e4e4e40ec1mr25343892qtj.64.1681821893616;
        Tue, 18 Apr 2023 05:44:53 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id g24-20020ac84b78000000b003ee4b5a2dd3sm2165795qts.21.2023.04.18.05.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 05:44:53 -0700 (PDT)
Date:   Tue, 18 Apr 2023 08:44:52 -0400
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
Message-ID: <643e90c4c7d0b_327ccc294a8@willemb.c.googlers.com.notmuch>
In-Reply-To: <0f1d25fa-0704-f3b0-cc33-d89a5f87daac@huawei.com>
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
 <643aab0f2f39c_1afa5d2943f@willemb.c.googlers.com.notmuch>
 <0f1d25fa-0704-f3b0-cc33-d89a5f87daac@huawei.com>
Subject: =?UTF-8?Q?Re:_=E7=AD=94=E5=A4=8D:_[PATCH_net]_net:_Add_check_for?=
 =?UTF-8?Q?_csum=5Fstart_in_skb=5Fpartial=5Fcsum=5Fset=28=29?=
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

luwei (O) wrote:
> =

> =E5=9C=A8 2023/4/15 9:47 PM, Willem de Bruijn =E5=86=99=E9=81=93:
> > luwei (O) wrote:
> >> =E5=9C=A8 2023/4/15 1:20 AM, Willem de Bruijn =E5=86=99=E9=81=93:
> >>> Willem de Bruijn wrote:
> >>>> luwei (O) wrote:
> >>>>> yes, here is the vnet_hdr:
> >>>>>
> >>>>>       flags: 3
> >>>>>       gso_type: 3
> >>>>>       hdr_len: 23
> >>>>>       gso_size: 58452
> >>>>>       csum_start: 5
> >>>>>       csum_offset: 16
> >>>>>
> >>>>> and the packet:
> >>>>>
> >>>>> | vnet_hdr | mac header | network header | data ... |
> >>>>>
> >>>>>     memcpy((void*)0x20000200,
> >>>>>            "\x03\x03\x02\x00\x54\xe4\x05\x00\x10\x00\x80\x00\x00\=
x53\xcc\x9c\x2b"
> >>>>>            "\x19\x3b\x00\x00\x00\x89\x4f\x08\x03\x83\x81\x04",
> >>>>>            29);
> >>>>>     *(uint16_t*)0x200000c0 =3D 0x11;
> >>>>>     *(uint16_t*)0x200000c2 =3D htobe16(0);
> >>>>>     *(uint32_t*)0x200000c4 =3D r[3];
> >>>>>     *(uint16_t*)0x200000c8 =3D 1;
> >>>>>     *(uint8_t*)0x200000ca =3D 0;
> >>>>>     *(uint8_t*)0x200000cb =3D 6;
> >>>>>     memset((void*)0x200000cc, 170, 5);
> >>>>>     *(uint8_t*)0x200000d1 =3D 0;
> >>>>>     memset((void*)0x200000d2, 0, 2);
> >>>>>     syscall(__NR_sendto, r[1], 0x20000200ul, 0xe45ful, 0ul, 0x200=
000c0ul, 0x14ul);
> >>>> Thanks. So this can happen whenever a packet is injected into the =
tx
> >>>> path with a virtio_net_hdr.
> >>>>
> >>>> Even if we add bounds checking for the link layer header in pf_pac=
ket,
> >>>> it can still point to the network header.
> >>>>
> >>>> If packets are looped to the tx path, skb_pull is common if a pack=
et
> >>>> traverses tunnel devices. But csum_start does not directly matter =
in
> >>>> the rx path (CHECKSUM_PARTIAL is just seen as CHECKSUM_UNNECESSARY=
).
> >>>> Until it is forwarded again to the tx path.
> >>>>
> >>>> So the question is which code calls skb_checksum_start_offset on t=
he
> >>>> tx path. Clearly, skb_checksum_help. Also a lot of drivers. Which
> >>>> may cast the signed int return value to an unsigned. Even an u8 in=

> >>>> the first driver I spotted (alx).
> >>>>
> >>>> skb_postpull_rcsum anticipates a negative return value, as do othe=
r
> >>>> core functions. So it clearly allowed in certain cases. We cannot
> >>>> just bound it.
> >>>>
> >>>> Summary after a long story: an initial investigation, but I don't =
have
> >>>> a good solution so far. Maybe others have a good suggestiong based=
 on
> >>>> this added context.
> >>> Specific to skb_checksum_help, it appears that skb_checksum will
> >>> work with negative offset just fine.
> >>   =C2=A0=C2=A0=C2=A0 =C2=A0 In this case maybe not, since it checksu=
ms from within the mac
> >> header, and the mac header
> >>
> >>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 will be stripped when the rx =
path checks the checksum.
> > The header is pulled, but still present. Obviously something bogus ge=
ts
> > written if the virtio_net_hdr configures csum offload with a bogus
> > offset. But as long as the offset is zero or positive from skb->head,=

> > the checksum helper works as intended.
> =

>  =C2=A0=C2=A0 OK, Thanks for your reply

We still should address the unnecessary warning triggerable by syzbot.

If I'm correct that any offset programmable through virtio_net_hdr ends
up in the skb linear section and skb_checksum_help will compute it fine,
then the WARN_ON_ONCE just needs an explicit cast to signed.

I have only skimmed, so not 100% sure yet. But that's the short take.
 =

> >   =

> >>> Perhaps the only issue is that the WARN_ON_ONCE compares signed to
> >>> unsigned, and thus incorrectly interprets a negative offset as
> >>>    >=3D skb_headlen(skb)
> > .
> =

> -- =

> Best Regards,
> Lu Wei
> =



