Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120094DB5A8
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 17:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243924AbiCPQK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 12:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348081AbiCPQK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 12:10:28 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF516006F
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 09:09:13 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h13so3351016ede.5
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 09:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sfyn51iMEtZOW1VvGz9/zKro/mJL/U+AGtoyS/q05lk=;
        b=IxJzMGVBQ3dqOjwnT0kNvGBM1q4ToNrQ8MnPmSDiP9yfNiOStXUVcBRVnxaULD6+qQ
         iDehTRiYAMHSCxlwKAHGVWuwY43EtSG7VmF2E+DrfhETaC+kwkg1Zw7nn0Mt77iaYVPS
         eI5jjYFFkS7OLX94NFKpBzVwOSR3Cj742b3BY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sfyn51iMEtZOW1VvGz9/zKro/mJL/U+AGtoyS/q05lk=;
        b=Ri9p0wiNcEvWiBAiPJeWklOgbfzedrcf4P3Y4HVi+Cw67SXvZQF0RUrtTd9Do3HEzs
         1qNCrHwZgCYExiGjSg+RwH+S+Z8UnGzHfgc8nF6lDmm38rwCc1ucr8zVm08fXiJGhtom
         6vmvJhCi4MNdaWWcYHy4phx8UVO8IcZv3x0JAU9DlsnGrApZlgLPQ7K36jE1B/hE5cAN
         wkp+Ed1jXQCE55umO9miLfIX9Ivyxsq9ruOSSyyrzPPY3HSqUrt3DOlvxttlFUsnAixb
         HDrSzoiUPPbAosQdgaY3hEm+/W4vwGleKwK9zaX5kuNXMeyFI9fGSqk3t+rr2ygKrK1F
         73Kw==
X-Gm-Message-State: AOAM5305mqQRvMqHhDYa2vKMj62XKeSjkY7cxAlqwz63OQL5GMnqtUDe
        kcU70xAWjIa33pRENTkT9asqm/IpsBbKnqehXjk=
X-Google-Smtp-Source: ABdhPJwKryTyQwMnjUUs+/GSqUQ/H6JEGGa0gHhX2jaybOU5CsjFqhM0CItWaW4sFik64uJLjFdIiw==
X-Received: by 2002:aa7:ca01:0:b0:415:ece6:b0d9 with SMTP id y1-20020aa7ca01000000b00415ece6b0d9mr163066eds.303.1647446952017;
        Wed, 16 Mar 2022 09:09:12 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id m28-20020a17090672dc00b006df88565a2dsm245517ejl.121.2022.03.16.09.09.11
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 09:09:11 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id dr20so5046288ejc.6
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 09:09:11 -0700 (PDT)
X-Received: by 2002:ac2:4f92:0:b0:448:7eab:c004 with SMTP id
 z18-20020ac24f92000000b004487eabc004mr184326lfs.27.1647446495212; Wed, 16 Mar
 2022 09:01:35 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000009e7a1905b8295829@google.com> <00000000000003887a05da3e872c@google.com>
 <CAHk-=wj4HBk7o8_dbpk=YiTOFxvE9LTiH8Gk=1kgVxOq1jaH7g@mail.gmail.com> <CACT4Y+atgbwmYmiYqhFQT9_oHw5cD5oyp5bNyCJNz34wSaMgmg@mail.gmail.com>
In-Reply-To: <CACT4Y+atgbwmYmiYqhFQT9_oHw5cD5oyp5bNyCJNz34wSaMgmg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 16 Mar 2022 09:01:18 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj270g1sHyvvMz99d5x5A_2BXJExzKGNhF1Ch8Y2Mi0pA@mail.gmail.com>
Message-ID: <CAHk-=wj270g1sHyvvMz99d5x5A_2BXJExzKGNhF1Ch8Y2Mi0pA@mail.gmail.com>
Subject: Re: [syzbot] KASAN: out-of-bounds Read in ath9k_hif_usb_rx_cb (3)
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+3f1ca6a6fec34d601788@syzkaller.appspotmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        ath9k-devel@qca.qualcomm.com, chouhan.shreyansh630@gmail.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:USB GADGET/PERIPHERAL SUBSYSTEM" 
        <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Zekun Shen <bruceshenzk@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 12:45 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> But the bug looks to be fixed by something anyway. git log on the file
> pretty clearly points to:
>
> #syz fix: ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream

Yeah, that commit 6ce708f54cc8 looks a lot more likely to have any
effect on this than my version bump that the syzbot bisection pointed
to.

But kernels containing that commit still have that

  run #0: crashed: KASAN: use-after-free Read in ath9k_hif_usb_rx_cb

so apparently it isn't actually fully fixed. ;(

                 Linus
