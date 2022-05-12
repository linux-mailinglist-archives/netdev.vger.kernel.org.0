Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C190752536A
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 19:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356958AbiELRTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 13:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356945AbiELRTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 13:19:47 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B4B26AD8C
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 10:19:46 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w24so7082068edx.3
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 10:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jDHOqKOOly/u6UGesDlSvrOYIRtvk+Gi75eJQoAcvU8=;
        b=ajie93GkyM3bMzgPSyr9+zDuLO8qmNsBGOmDLDAYe2chL7Y1Dex40FgP7wpA+YsFVS
         PbCwBPFRrhD1wKMyrktSA2hu4sY+A8Snezdkh2Pl31GtbbWKUVs17izWFz1kX+D2q2GT
         3Kh1nj3RjFExJpH9SEac2MgWbeFHQCaqrxqgg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jDHOqKOOly/u6UGesDlSvrOYIRtvk+Gi75eJQoAcvU8=;
        b=xChv8InDcxLnvIstOcqYGHKBVQGBJa7f6xbA+B9XRgagY7k/1S3nmVMjYOT+cJ++z2
         sn8L1NgBpTgDKvta4jUDk4gDSp3T6GV3vr1v2uAzVKP+Qtu+7f6a0Gn0Xcn11JloMSC5
         1nAfY322oZEzFRLait/Boyl/RBr7e/axwhs6oP7bMPkVDdgSBokxOuoPhZMXtrMbjCh5
         mQzV71LrzvyuNWcnVVmtpsGWSYOkFFdtf2CTYrwMt8qAften+SxZMfYgkXE1YGK/DeuG
         cN5U/AF5XJvTtecM0wGcOsTFXGmbAt7KvVmb2f1TwNiG0D3zjX9q+p3OjlC7XuKHRT8x
         V87Q==
X-Gm-Message-State: AOAM532gJVO/p4M8XpJ+KN+eET+GYSW5Fp/wCclf+j/j/MTp//VOA+LK
        brzLmN6lfbY+2mX1MK4y0RZ/4fWnoSqSVyahp4w=
X-Google-Smtp-Source: ABdhPJycAjODf+Asp4SXkq/HSraZcqSxYiEo6OOnjITHEyuccGr4g68m4YMDVZIsXLysZkwA+Eooaw==
X-Received: by 2002:a05:6402:28b1:b0:425:c39e:b773 with SMTP id eg49-20020a05640228b100b00425c39eb773mr35542555edb.237.1652375984307;
        Thu, 12 May 2022 10:19:44 -0700 (PDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id rk6-20020a170907214600b006f3ef214dd9sm2255908ejb.63.2022.05.12.10.19.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 10:19:41 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id b19so8166125wrh.11
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 10:19:41 -0700 (PDT)
X-Received: by 2002:a5d:6dad:0:b0:20c:4dc1:e247 with SMTP id
 u13-20020a5d6dad000000b0020c4dc1e247mr629061wrs.274.1652375980629; Thu, 12
 May 2022 10:19:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220510082351-mutt-send-email-mst@kernel.org>
 <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
 <87czgk8jjo.fsf@mpe.ellerman.id.au> <CAHk-=wj9zKJGA_6SJOMPiQEoYke6cKX-FV3X_5zNXOcFJX1kOQ@mail.gmail.com>
 <87mtfm7uag.fsf@mpe.ellerman.id.au> <CAHk-=wgnYGY=10sRDzXCC2bmappjBTRNNbr8owvGLEW-xuV7Vw@mail.gmail.com>
In-Reply-To: <CAHk-=wgnYGY=10sRDzXCC2bmappjBTRNNbr8owvGLEW-xuV7Vw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 12 May 2022 10:19:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg=jfhgTkYBtY3LPPcUP=8A2bqH_iFezwOCDivuovE41w@mail.gmail.com>
Message-ID: <CAHk-=wg=jfhgTkYBtY3LPPcUP=8A2bqH_iFezwOCDivuovE41w@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: last minute fixup
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
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

On Thu, May 12, 2022 at 10:10 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And most definitely not just random data that can be trivially
> auto-generated after-the-fact.

Put another way: when people asked for change ID's and I said "we have
links", I by no means meant that "you can just add random worthless
links to commits".

For example, if you have a (public-facing) Gerrit system that tracks a
patch before it gets committed, BY ALL MEANS add a link to that as the
"change ID" that you tracked in Gerrit.

That's a Link: that actually adds *information*. It shows some real
history to the commit, and shows who approved it and when, and gives
you all the Gerrit background.

But a link to the email on lkml that just contains the patch and the
same commentary that was introduced into the commit? Useless garbage.
It adds no actual information.

THAT is my argument. Why do people think I'm arguing against the Link:
tag? No. I'm arguing against adding links with no relevant new
information behind them.

I don't argue against links to lore. Not at all. If those links are
about the background that caused the patch, they are great. Maybe they
are to a long thread about the original problem and how to solve it.
Thats WONDERFUL.

But here's the deal: when I look at a commit that I wonder "why is it
doing this, it seems wrong" (possibly after there's been a bug report
about it, but possibly just because I'm reviewing it as part of doing
the pull), and I see a "Link:" tag, and it just points back to the
SAME DAMN DATA that I already have in the commit, then that Link: tag
not only wasn't helpful, it was ACTIVELY DETRIMENTAL and made me waste
time and just get irritated.

And if you waste my time with useless links, why would you expect me
to be supportive of that behavior?

                      Linus
