Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4802B6A987F
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 14:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjCCNfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 08:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjCCNfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 08:35:30 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8455A11EBE;
        Fri,  3 Mar 2023 05:35:06 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id op8so1691181qvb.11;
        Fri, 03 Mar 2023 05:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677850505;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BbXs2fZaKoFkmjOodJTnYZc2+KCsXlSJCimzVT2u6S4=;
        b=bvq7SEl2D6im3baHpRlR+E+4GPJ70ejdpQegc97pfTMcELCZSvPK0m4s/qeQh45xOk
         0rarSn3mjXrNbKmOnzl1OV6cWui8Ls41TPg+RBksGBtoABzamlcri7YiAqUGjG9ZZBRx
         1OiUWB6X2+PFdT7DKWNO1vw+Q1kqFCEoxGIKNLD8Ne8Q67A9cFT93yTcM6kqmiLoGKlK
         3QMAdjul7RTf3Gn2lgEv0hvW8R58gPZTtzqboIVWP4t/5lIj+lraIXgTcZSFXK9/Fk6Q
         6Rp0rmSK1m2m9yQgAJJHLrq+3fBRqJYjBHDXVVZ23U7gqqbISVePmzuPNNuRksbp51uP
         kYRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677850505;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BbXs2fZaKoFkmjOodJTnYZc2+KCsXlSJCimzVT2u6S4=;
        b=mETNkHPFWdoBhsW/s4OieLK/+iIep+l+QNXPo8p6ROeHT6hA9bNImRXr0ZJLoo/P+q
         MZnMFlRxhlBiyFlJ5QPIToBheMSf8pE2YRoeDIzT+1rVxDvDOSICanhcobJgvxphm1c+
         5smRLCqKzHWHB1+vOsf8FLqv2rncbr6NjfxAQT/ONqeVbzqANFn7xh6mBIZ9B/6P7x/H
         Y3qV4zdMAUX+ZKVW1XbXPj4w52fiw0niLOhhzfHz7eMwFeSAAOUc3J0H7dvw0sFxVkoX
         ZNhUVWJdxK/Xyja+3W5+1APCYMgiYtdPB4sgBNbJW0LQ+Jj5z4orRRoatnZddLmLwY0F
         YNbw==
X-Gm-Message-State: AO0yUKV7EkCS7WC1Hy6fINIuUdFfARYzeR2Ikjl5imDqqoKlbqBC9/mT
        7tiBpSWJQHEZZ+ToAVv22Us=
X-Google-Smtp-Source: AK7set8wZw4wyYSi99cpQrM7MGeiYJDE5bxRIgW5ZI+mg/+AH1NYAye2Pwf2iCNx81sMyc/PZ/plzQ==
X-Received: by 2002:ad4:5de8:0:b0:571:d69:da8c with SMTP id jn8-20020ad45de8000000b005710d69da8cmr2660804qvb.19.1677850505572;
        Fri, 03 Mar 2023 05:35:05 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id o5-20020a374105000000b007429ee9482dsm1630833qka.134.2023.03.03.05.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 05:35:04 -0800 (PST)
Date:   Fri, 03 Mar 2023 08:35:04 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Eric Dumazet <edumazet@google.com>, yang.yang29@zte.com.cn
Cc:     willemdebruijn.kernel@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhang.yunkai@zte.com.cn,
        xu.xin16@zte.com.cn, jiang.xuexin@zte.com.cn
Message-ID: <6401f7889e959_3f6dc82084b@willemb.c.googlers.com.notmuch>
In-Reply-To: <CANn89iK3frwxddhSbbi5cvmuSjr2TqPbD_mTgBa3k4ESDQnrHA@mail.gmail.com>
References: <6400bd699f568_20743e2082b@willemb.c.googlers.com.notmuch>
 <202303031900454292466@zte.com.cn>
 <CANn89iK3frwxddhSbbi5cvmuSjr2TqPbD_mTgBa3k4ESDQnrHA@mail.gmail.com>
Subject: Re: [PATCH linux-next v2] selftests: net: udpgso_bench_tx: Add test
 for IP fragmentation of UDP packets
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

Eric Dumazet wrote:
> On Fri, Mar 3, 2023 at 12:03=E2=80=AFPM <yang.yang29@zte.com.cn> wrote:=

> >
> > > Did you actually observe a difference in behavior with this change?=

> >
> > The test of UDP only cares about sending, and does not much need to
> > consider the problem of PMTU, we configure it to IP_PMTUDISC_DONT.
> >     IP_PMTUDISC_DONT: turn off pmtu detection.
> >     IP_PMTUDISC_OMIT: the same as DONT, but in some scenarios, DF wil=
l
> > be ignored. I did not construct such a scene, presumably when forward=
ing.
> > Any way, in this test, is the same as DONT.

My points was not to compare IP_PMTUDISC_OMIT to .._DONT but to .._DO,
which is what the existing UDP GSO test is setting.

USO should generate segments that meet MTU rules. The test forces
the DF bit (IP_PMTUDISC_DO).

UFO instead requires local fragmentation, must enter the path for this
in ip_output.c. It should fail if IP_PMTUDISC_DO is set:

        /* Unless user demanded real pmtu discovery (IP_PMTUDISC_DO), we =
allow
         * to fragment the frame generated here. No matter, what transfor=
ms
         * how transforms change size of the packet, it will come out.
         */
        skb->ignore_df =3D ip_sk_ignore_df(sk);

        /* DF bit is set when we want to see DF on outgoing frames.
         * If ignore_df is set too, we still allow to fragment this frame=

         * locally. */
        if (inet->pmtudisc =3D=3D IP_PMTUDISC_DO ||
            inet->pmtudisc =3D=3D IP_PMTUDISC_PROBE ||
            (skb->len <=3D dst_mtu(&rt->dst) &&
             ip_dont_fragment(sk, &rt->dst)))
                df =3D htons(IP_DF);
 =

> >
> > We have a question, what is the point of this test if it is not compa=
red to
> > UDP GSO and IP fragmentation. No user or tool will segment in user mo=
de,

Are you saying no process will use UDP_SEGMENT?

The local protocol stack removed UFO in series d9d30adf5677.
USO can be offloaded to hardware by quite a few devices (NETIF_F_GSO_UDP_=
L4).
> > UDP GSO should compare performance with IP fragmentation.
> =

> I think it is misleading to think the cost of IP fragmentation matters
> at the sender side.
> =

> Major issue is the receiving side, with many implications of memory
> and cpu costs,
> not counting amplifications of potential packet losses.
> =

> So your patch would make sense if you also change
> tools/testing/selftests/net/udpgso_bench_rx.c accordingly.
> =

> If you send UDP packets to a receiver, then you should not receive
> ICMP errors, unless a reassembly error occured.
> =

> About ICMP packets being disruptive, you can always ignore errors at
> sendmsg() time and retry the syscall.


