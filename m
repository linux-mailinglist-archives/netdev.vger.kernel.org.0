Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4F2598AB5
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343557AbiHRRuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245146AbiHRRux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:50:53 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3814F45064
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:50:52 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id tl27so4628955ejc.1
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=+udMhoflNILtLwMziy9QxbssD2QG4JpM06SxHHpbxCA=;
        b=NIFQwkNUiiLFi8Kjt5lNwduVmw8vZNrnkydVranhuX0VDQLaXP8rdwO6iHupijdwu4
         YXvINWRetkI8m/oPV2ppzNtRa+zS7ekhe735BIHqWol3mnYKxcWl2pHdmtWWZ3JMXWu2
         besgRXCgcXwerlm7kZFSHvID0lfS0iRiD22Ys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=+udMhoflNILtLwMziy9QxbssD2QG4JpM06SxHHpbxCA=;
        b=vWQow//MsCQ/t3WmmFWFFLd6xdaKfm1Lq6vrfzbZvUV4QbpBG2M6hHMW7VB19uNwcq
         bI7dsg0so15+NFZINUTBUP3gzhRTyJGEbOIuUwmwjl6Qt4qSU0LZhGkkNg5ReJs7Dwgh
         7IeA+79YdYJpE22IiAAub8hLA8PuDgtuEdumKbED2xserKbMs6Doh520wr07O4KR2oTI
         iL2AeWGD14Dgsf4+oJ+d9q8qZYGnU548rHaMeq39ts12wk+uYz4UhusjNfkHPMda+wx5
         S+zrJIwNXmm9WX0hF08b5jQZsFm5K7nuOG+J1dQkw5aUiMTHr35GSdGXrryBrbIXQezU
         DniQ==
X-Gm-Message-State: ACgBeo31p/GnMIgIN8wOoRZ+B1Y1tEGxHypJ/KCqvnxC8KZzqM7nzLmk
        TXfNHrUIXilZaG8BjtNAMHKOUIZaKnGdyOxo
X-Google-Smtp-Source: AA6agR6n/Reqf9ey57IKnHfy+uwaaErm+tBADRHa68gG7sSDbNOwG0MDNNWmqQrg2QN/bna3Wv2bcQ==
X-Received: by 2002:a17:907:2e0d:b0:731:7afa:f14f with SMTP id ig13-20020a1709072e0d00b007317afaf14fmr2658785ejc.704.1660845050523;
        Thu, 18 Aug 2022 10:50:50 -0700 (PDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id q3-20020a056402040300b00445e1489313sm1480760edv.94.2022.08.18.10.50.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 10:50:48 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id bd26-20020a05600c1f1a00b003a5e82a6474so1317863wmb.4
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:50:48 -0700 (PDT)
X-Received: by 2002:a05:600c:657:b0:3a5:e4e6:ee24 with SMTP id
 p23-20020a05600c065700b003a5e4e6ee24mr5555143wmm.68.1660845047779; Thu, 18
 Aug 2022 10:50:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220721204404.388396-1-weiwan@google.com> <ca408271-8730-eb2b-f12e-3f66df2e643a@kernel.org>
 <CADVnQymVXMamTRP-eSKhwq1M612zx0ZoNd=rs4MtipJNGm5Wcw@mail.gmail.com>
 <e318ba59-d58a-5826-82c9-6cfc2409cbd4@kernel.org> <f3301080-78c6-a65a-d8b1-59b759a077a4@kernel.org>
 <CADVnQykRMcumBjxND9E4nSxqA-s3exR3AzJ6+Nf0g+s5H6dqeQ@mail.gmail.com>
 <21869cb9-d1af-066a-ba73-b01af60d9d3a@kernel.org> <CADVnQy=AnJY9NZ3w_xNghEG80-DhsXL0r_vEtkr=dmz0ugcoVw@mail.gmail.com>
 <eca0e388-bdd1-7d83-76a8-971de8e3a0ce@kernel.org>
In-Reply-To: <eca0e388-bdd1-7d83-76a8-971de8e3a0ce@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 18 Aug 2022 10:50:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjMKztOKfaqqPeEyM+9eHrfkJfrSrsaWx3EXDrRtyO98Q@mail.gmail.com>
Message-ID: <CAHk-=wjMKztOKfaqqPeEyM+9eHrfkJfrSrsaWx3EXDrRtyO98Q@mail.gmail.com>
Subject: Re: python-eventlet test broken in 5.19 [was: Revert "tcp: change
 pingpong threshold to 3"]
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Neal Cardwell <ncardwell@google.com>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        LemmyHuang <hlm3280@163.com>, stable <stable@vger.kernel.org>,
        temotor@gmail.com, jakub@stasiak.at
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 11:44 PM Jiri Slaby <jirislaby@kernel.org> wrote:
>
> Thanks a lot, Neal! So for the time being, until this is resolved in
> eventlet, I pushed a change to disable the test in openSUSE.

Yes, that is the right approach in this case, since it really does
seem to be purely about timing.

Note that "breaks user space" is not about random test suites. For all
we know, a test suite can exist literally to check for known bugs etc.

No user space breakage is about real loads by real people, ie "I used
to do this, and now that no longer works".

The test suites showing behavioral differences are certainly always a
cause of worry - because the test may exist for a very particular
reason, and may be indicative that yes, there are actual real programs
depending on this behavior - but isn't in itself necessarily a problem
in itself.

            Linus
