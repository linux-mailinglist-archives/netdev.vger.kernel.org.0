Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F07532B5F
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 15:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237876AbiEXNd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 09:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237872AbiEXNdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 09:33:55 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC53939B5
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 06:33:54 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id b200so6037507qkc.7
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 06:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7p2U0ToaQGK8ydTaA8am+2nfDgACRmmoUvxmzOpA12U=;
        b=oLZdKW61LnQtETJC2I7xGHN7izyYt40WB0UUMDSq57yoHw9xsPhU3LqMld8FjqxuyJ
         ah7VSZH9XHPdSWTJ3SuynV+h95M3rlw7P4TviVUS4xxhSz7t40bX/5ohYsXP9NI4eMr4
         eihJIdjwSOyDL2p42O8bD1S0BZnxelmy3RGNuUPL+7fPixrJqXCsUnDWfWDA40H5M7rc
         lT/kXfKoZbidj/h+bUyyKaaO89xche6e34cEJ8ZKj2vhjkz37edFeRiJsmXTC6IPhaNL
         qubsfy7QbIJeDFoOhOkPppAoYSOUAKUHxlusenSYJjVlIjOqMtgJ+LPQ4neFg1l2zNzJ
         T4rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7p2U0ToaQGK8ydTaA8am+2nfDgACRmmoUvxmzOpA12U=;
        b=A/McsDe4jB1dcJ/adSZHFCFc5ruwP7SQU78kmRhInLH1aQk9Ri/plnv3YvDPM5917L
         FrL4SAm2CO/rLwN+g4NJpPzuCtB1MlE6WLvB12aZMszP6r6Nnbasb6O3VjisZi4KOHKs
         PJdG+cIWmepfk/zY+hkK9dr4lKnFRYo93Jnt7KJbj9fq7MqRtPTKJ4t3+HNuNK1hVZxr
         R0MZ50zF8KdoZ/hGLO2C3/UDGO1oZNf8xoJsQ21G3D83YUeD2yO86EnGQRcmDc6NG/Am
         cRmjhy13ZVR7qVzPidQGZ6Mtd2B5GTtnRR/bsAIzCG9I8Pmmf5/QNfOTab5TDPVfOCHw
         6LLw==
X-Gm-Message-State: AOAM533vYTtvyn0m82SKUC5ou3EdSRFjF31aVCQMPi5E2cZtzsI7Ejpz
        cy4yww0wON+Lps+ncoH3qbfuqWwj88Q=
X-Google-Smtp-Source: ABdhPJyY1zTfE5lroqSChxStE8CjvEWTvJRG6/AfluLs3EIYBKJ95bLnvxCh69w0tHpUY7U5GbsZWw==
X-Received: by 2002:a37:d243:0:b0:6a3:2a87:e2e5 with SMTP id f64-20020a37d243000000b006a32a87e2e5mr17385778qkj.97.1653399233306;
        Tue, 24 May 2022 06:33:53 -0700 (PDT)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com. [209.85.128.182])
        by smtp.gmail.com with ESMTPSA id o18-20020ae9f512000000b006a38debe62csm3508383qkg.89.2022.05.24.06.33.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 06:33:52 -0700 (PDT)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-30007f11f88so50181437b3.7
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 06:33:51 -0700 (PDT)
X-Received: by 2002:a81:134f:0:b0:2ff:59d9:aa98 with SMTP id
 76-20020a81134f000000b002ff59d9aa98mr27987057ywt.348.1653399231392; Tue, 24
 May 2022 06:33:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220520063835.866445-1-luyun_611@163.com> <CA+FuTSdoZeAncRVAYrb66Kp6bEueWrgyy7A8qP0kmr9pxfHMoA@mail.gmail.com>
 <3f494c7a-6648-a696-b215-f597e680c5d9@163.com> <CA+FuTSdHCszjFtkZj37KE-1rfSfzYEd5oXLyKS6Kz9pdi05ReA@mail.gmail.com>
 <754c0cd5-2289-3887-e7d2-71ff87e59afd@163.com>
In-Reply-To: <754c0cd5-2289-3887-e7d2-71ff87e59afd@163.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 24 May 2022 09:33:15 -0400
X-Gmail-Original-Message-ID: <CA+FuTScW3TekvnLnm=R9JvibOfPXRBP0O_3AuCmo4z=d3fP3fA@mail.gmail.com>
Message-ID: <CA+FuTScW3TekvnLnm=R9JvibOfPXRBP0O_3AuCmo4z=d3fP3fA@mail.gmail.com>
Subject: Re: [PATCH] selftests/net: enable lo.accept_local in psock_snd test
To:     Yun Lu <luyun_611@163.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        davem@davemloft.net, edumazet@google.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 6:04 AM Yun Lu <luyun_611@163.com> wrote:
>
> On 2022/5/23 =E4=B8=8B=E5=8D=889:32, Willem de Bruijn wrote:
>
> > On Mon, May 23, 2022 at 5:25 AM Yun Lu <luyun_611@163.com> wrote:
> >> On 2022/5/20 =E4=B8=8B=E5=8D=889:52, Willem de Bruijn wrote:
> >>
> >>> On Fri, May 20, 2022 at 2:40 AM Yun Lu <luyun_611@163.com> wrote:
> >>>> From: luyun <luyun@kylinos.cn>
> >>>>
> >>>> The psock_snd test sends and recievs packets over loopback, but the
> >>>> parameter lo.accept_local is disabled by default, this test will
> >>>> fail with Resource temporarily unavailable:
> >>>> sudo ./psock_snd.sh
> >>>> dgram
> >>>> tx: 128
> >>>> rx: 142
> >>>> ./psock_snd: recv: Resource temporarily unavailable
> >>> I cannot reproduce this failure.
> >>>
> >>> Passes on a machine with accept_local 0.
> >>>
> >>> accept_local is defined as
> >>>
> >>> "
> >>> accept_local - BOOLEAN
> >>>       Accept packets with local source addresses. In combination
> >>>       with suitable routing, this can be used to direct packets
> >>>       between two local interfaces over the wire and have them
> >>>       accepted properly.
> >>> "
> >> I did this test on my system(Centos 8.3 X86_64):
> >>
> >> [root@localhost net]# sysctl net.ipv4.conf.lo.accept_local
> >> net.ipv4.conf.lo.accept_local =3D 0
> >> [root@localhost net]# ./psock_snd -d
> >> tx: 128
> >> rx: 142
> >> ./psock_snd: recv: Resource temporarily unavailable
> >> [root@localhost net]# sysctl -w net.ipv4.conf.lo.accept_local=3D1
> >> net.ipv4.conf.lo.accept_local =3D 1
> >> [root@localhost net]# ./psock_snd -d
> >> tx: 128
> >> rx: 142
> >> rx: 100
> >> OK
> >>
> >> This failure does seem to be related to accept_local.
> >>
> >> Also, it's reported on Ubuntu:
> >> https://bugs.launchpad.net/ubuntu-kernel-tests/+bug/1812618
> > That is an old kernel, 4.18 derived.
> >
> > I simply am unable to reproduce this on an upstream v4.18 or v5.18.
> > Likely something with either the distro kernel release, or another
> > distro feature that interacts with this. Can you try v5.18 or another
> > clean upstream kernel?
> >
> > Else it requires instrumenting IN_DEV_ACCEPT_LOCAL tests to understand
> > where this sysctl makes a meaningful change for you when running this
> > test.
>
> I found another parameter rp_filter which interacts with this test:
>
> Set rp_filter =3D 0, the psock_snd test OK.
>
> Or set rp_filter =3D 1 and accept_local=3D1, the psock_snd test OK.
>
> I get the same test results on kernel v5.10 or v5.15.  Analysis from
> source code,  this two parameters
>
> will change the result of fib_validate_source when running this test.
> For most distro kernel releases,
>
> rp_filter is enabled by default, so this test will fail when
> accept_local is kept to be zero.

That explains.

Since this test runs inside a netns, changing a sysctl is fine.

Can you resubmit with a more detailed description now that the exact
check is more clear, as well as interplay with rp_filter, and the
default config of these two parameters configured by distros? Thanks.
Please double check typos (s/recievs/receives).
