Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315E76B111F
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 19:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjCHSe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 13:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjCHSet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 13:34:49 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207A85F21E
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 10:34:48 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id s1so16234259vsk.5
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 10:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678300487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C9F1enZvKSGIFHS4e3aiA1VRNnNfG61Asy+3o9z9VzE=;
        b=NvRD0HN9B8mPDstls48UkQEqfFQepTv7OuwyqlcYIXukeIQ3JJmoj3B+k3oi8AZMyH
         dFpmakTIeIlJrPcIGPppO0Czi2givmZ7rX8DUBWdVzl3CSBKhTOKG3TgLVzokH9BDEMg
         0Ae/tCc7M/scZ6mXoNEywGGKMyXuAp16lwA3s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678300487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C9F1enZvKSGIFHS4e3aiA1VRNnNfG61Asy+3o9z9VzE=;
        b=Ta+MEVaLayxgqpwZnQUIx0rD4TP0fGrTYOkre+wlOaFXhLcS+WPZ3frex9m8AlLZEy
         KK8GesRZ8SoOUF48XSaVI5qvSDPeXOuAW7a+2NpabQofYYGzWsvlN6NyMLH5b1+okyNU
         rMpiIpQrpjTHOd3rFXZL0MswMV3S866AK7rZ4+hRGq7/jVSIXVTcBlURfIYliuGngG58
         MoBepg8UUSDUhJi5vXOQY/9zjIyUZdUG/H6PksLQNJ842Dd/5avlp9s43ngoG6SatwRh
         Wabmtz0NSeC+KnK/MjWg/YZTOI5Fsd9EnFVFZx0Ysllou52anHfvjMJi9nZlBiKOgbpr
         ngBQ==
X-Gm-Message-State: AO0yUKVPrimTLtyxSCxkarhnuXwya4Xq8d4dwXWijYv6cIUKoyH7V20D
        LXApWvb7Nh8/mbwd8sEWc8KCgNmzX00Z0q0y2r//OQ==
X-Google-Smtp-Source: AK7set+8cPhuQAdLM3zB+PW2jfEvoEE/c3Gz044eevRZImhbZFwUCa9TW4KgyrSGIMQq31kIarVT1Pg4wy4Z5TqN2Rk=
X-Received: by 2002:a67:f9d9:0:b0:420:10e:14e8 with SMTP id
 c25-20020a67f9d9000000b00420010e14e8mr12386454vsq.1.1678300487055; Wed, 08
 Mar 2023 10:34:47 -0800 (PST)
MIME-Version: 1.0
References: <20230307200502.2263655-1-grundler@chromium.org> <20230307164736.37ecb2f9@kernel.org>
In-Reply-To: <20230307164736.37ecb2f9@kernel.org>
From:   Grant Grundler <grundler@chromium.org>
Date:   Wed, 8 Mar 2023 10:34:35 -0800
Message-ID: <CANEJEGuMuA=Hvu4DO7Hj8kZLwEuNmuzesY3QbVDpECanaC4hpA@mail.gmail.com>
Subject: Re: [PATCHv2 1/2] TEST:net: asix: fix modprobe "sysfs: cannot create
 duplicate filename"
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Grant Grundler <grundler@chromium.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Eizan Miyamoto <eizan@chromium.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Anton Lundin <glance@acc.umu.se>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 7, 2023 at 4:47=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Tue,  7 Mar 2023 12:05:01 -0800 Grant Grundler wrote:
> > Subject: [PATCHv2 1/2] TEST:net: asix: fix modprobe "sysfs: cannot crea=
te duplicate filename"
>
> Why the "TEST:" prefix?

Sorry - that's left over from how I mark the change for testing with
chromeos-5.15 kernel branch:
   https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel=
/+/4313619

I should have removed that.  I upload the change to gerrit so partners
can easily test the same code  (e.g. coworker Eizan who is in
Australia).

If you follow the link above, you can see I'm testing a bunch of
additional backports as well and have additional fields in the commit
message required by chromium.org.

> The patch doesn't apply cleanly, it needs to go via this tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/
> so rebase it onto that, please, and put [PATCH net] in the subject
> rather than just [PATCH].

Ok - thanks! Wil repost v3 against netdev/net.git/ shortly. No problem.

> Keep patch 2 locally for about a week (we merge fixes and cleanup
> branches once a week around Thu, and the two patches depend on each
> other).

Awesome! Sounds good.

> Please look thru at least the tl;dr of our doc:
> https://www.kernel.org/doc/html/next/process/maintainer-netdev.html

Thanks!

Because I've been "randomly" contributing to netdev for 20+ years,
I've not looked for documentation (beyond SubmittingPatches). But I am
quite willing to read and follow it - makes life easier for everyone.

cheers,
grant
