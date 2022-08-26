Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 345105A2347
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 10:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245401AbiHZIkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 04:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245436AbiHZIkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 04:40:01 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A24D6339
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:39:08 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-334dc616f86so18985267b3.8
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=Gbnh/nnDbuL5T5BvLNj3zwAmlE8d4k5PawHmbvFEFbk=;
        b=MNjXddBAOd+w9wkV5muswSppV6x5Jv+YS9ecOjXsUWJBVbPQURDBrSTe3Rss2i0p/r
         Jhmif2aOct4FrfcfpD9SRO9RHxr4LmccGOUui2+rtO1i6NUewZYaWAF1Uj3qq59pfr91
         VjwTW2OAdfNyC5ON+2WWx86GER7zk9LtKCZGNCcc/bhubscXBSXf0GihTtUlUsBLA3Xn
         vuWQ47vl8nc81EKOuzXoehfRScxfeaXU9CceWTlAIRodc4v7g6LuKc+2uSzDQqYIngTy
         F8vTYNtLOiuY3iezgI6TMtgUOBkC4/bd55SIlfcNGNOfJt1siO9gbTktwflBScPg/B+A
         IwQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=Gbnh/nnDbuL5T5BvLNj3zwAmlE8d4k5PawHmbvFEFbk=;
        b=ONXFBKd1DTiARl03uBoaqCMGc4iO7F0tRai7gMvwEDPy53BJL9UDT5HfSKbs+q/vOY
         NI9hXw9MBr1c5tOwevZ0iVZqhJ5Hi6tO/+fxxquaqAFTDjOAioJb9lZ3lNw6PJp/g4Tw
         5RAi6ZN5SzZDyfeAoLlrJu/b+Ih2+MJ9E2G1aU61fjhgoWt2IADMwL/qtyqJFJV5OpMH
         tBgNIm3UX8R2AyutiFmhBNyxWT171okBczFuxeNuVMEo1ClaMUbeKieu+LHU4GhKZmPc
         a0uvXBgcRi6Xsf0Re4sAf6ppBFu/5Dz2KQFVQU3qG6nZYhO9AoYQshHE8/XgsFrxFzoa
         u6Pg==
X-Gm-Message-State: ACgBeo1lHbGzxrxNkVadIlSFXMYgQo46OPscEkYIIM7d2e3G79HkS2a2
        iFjyKQQmxm+0mXnb9sW11vrplA985s1HTKpXawGcxQ==
X-Google-Smtp-Source: AA6agR7kYKsB2aFgL4J8UVJXiRDCFz4t/tXSI4PkJwjvI/Lg1d/SZ2cRrdBUXdzofU6od8Ey4X/QYzkYrxgTJmY4jhk=
X-Received: by 2002:a81:10a:0:b0:333:618e:190b with SMTP id
 10-20020a81010a000000b00333618e190bmr7063483ywb.10.1661503147204; Fri, 26 Aug
 2022 01:39:07 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c98a7f05ac744f53@google.com> <000000000000734fe705acb9f3a2@google.com>
 <a142d63c-7810-40ff-9c24-7160c63bafebn@googlegroups.com> <CAG_fn=U=Vfv3ymNM6W++sbivieQoUuXfAxsC9SsmdtQiTjSi8g@mail.gmail.com>
 <1a0b4d24-6903-464f-7af0-65c9788545af@I-love.SAKURA.ne.jp>
 <CAG_fn=Wq51FMbty4c_RwjBSFWS1oceL1rOAUzCyRnGEzajQRAg@mail.gmail.com> <46fee955-a5fa-fbd6-bcc4-d9344e6801d9@I-love.SAKURA.ne.jp>
In-Reply-To: <46fee955-a5fa-fbd6-bcc4-d9344e6801d9@I-love.SAKURA.ne.jp>
From:   Alexander Potapenko <glider@google.com>
Date:   Fri, 26 Aug 2022 10:38:30 +0200
Message-ID: <CAG_fn=X5a=2vhDR6Lt_6wEUZCmDqhy0dTW62FphATNgpuDbqNg@mail.gmail.com>
Subject: Re: KMSAN: uninit-value in ath9k_htc_rx_msg
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     ath9k-devel@qca.qualcomm.com, phil@philpotter.co.uk,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 3:35 AM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> On 2022/08/26 0:09, Alexander Potapenko wrote:
> > On Thu, Aug 25, 2022 at 4:34 PM Tetsuo Handa
> > <penguin-kernel@i-love.sakura.ne.jp> wrote:
> >>
> >> Hello.
> > Hi Tetsuo,
> >
> >> I found that your patch was applied. But since the reproducer tested o=
nly 0 byte
> >> case, I think that rejecting only less than sizeof(struct htc_frame_hd=
r) bytes
> >> is not sufficient.
> >>
> >> More complete patch with Ack from Toke is waiting at
> >> https://lkml.kernel.org/r/7acfa1be-4b5c-b2ce-de43-95b0593fb3e5@I-love.=
SAKURA.ne.jp .
> >
> > Thanks for letting me know! I just checked that your patch indeed
> > fixes the issue I am facing.
> > If it is more complete, I think we'd indeed better use yours.
>
> I recognized that "ath9k: fix an uninit value use in ath9k_htc_rx_msg()" =
is
> local to KMSAN tree.
> https://github.com/google/kmsan/commit/d891e35583bf2e81ccc7a2ea548bf7cf47=
329f40
I actually did a rebase of KMSAN tree to v6.0-rc2 yesterday and
dropped that patch (picked yours instead).
Thanks for the heads-up!

--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
