Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846115FF21A
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 18:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiJNQQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 12:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJNQQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 12:16:15 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D85F1CFF20;
        Fri, 14 Oct 2022 09:16:13 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id d187so5383140vsd.6;
        Fri, 14 Oct 2022 09:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m6c6o3U74O8R1F/6os/hJFkTL6GUlIrhNrBHLOkzRho=;
        b=a1Xom2666YZzwvYjRzZQ+kEK+YDG0h0s9soYrxe7wBsMNxv/0NtJKHsL/LNQOQAor1
         3geUZZj4zV1XCiWCo5qHG59cer4+VhWCcrS+MnMn6pH2MsK6Zx3ZU6mLVNZbSWWBRhQO
         kSR4uHCWLJ+6NNy7nQxmofK0ZXB0FemeV3mDu5WdYXh99XxE8T3KvLn/h1OujuViL3P9
         cS2sD0fn4ikRkuDGP3WyWGnUAl192XdK2mzRPGnzbyflJZHCEKI0yyUA0tsVPrlVMbXe
         gO11GF8013mAxYCmrLx/yg1iWc6r6kp4LaX8V+NXMr1Dcw+hb1qLGLMEIDTdHT2aUTaK
         xr1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m6c6o3U74O8R1F/6os/hJFkTL6GUlIrhNrBHLOkzRho=;
        b=7L58M9CDUhSDVdvabkmINcx4PjkYSlGiXY3tieguixEAy7fVwsS7pwQAMjPcpN1e0+
         rakYTOVXcX/1dW4+zAV6FOOgLQsEPoaRqVLd73lk6uLFab6DSJ5NkugmQCCrjvS6icPS
         0KbEX5ZcqPHY6a5lHZBKsaq2YDsqHr9ZI+uPsRy1WMI7SmbD6e7uMKcC2i8je1AySNTl
         DtbqrB7Y/BNCL3aBwi969HzRtXg5g23XO2H+IS93ZE059T9FJ0mNf8NuESoVpp7yY7TD
         cfhNN1wq+/xi8Pib9D6/htlq0lA8iSqdsucZe2Us0izMJdjDUZG9myHgMUynJr0wy5TR
         d8NA==
X-Gm-Message-State: ACrzQf0hO0zU4AUqF+Ok2+pAIOQEKYs081egde7fPp3kRschNaLGzbNQ
        YE7+u1HlcyjNd8rKHiJFSR3u79Eo2ILLHHDWeC4=
X-Google-Smtp-Source: AMsMyM5hEA7tW9pMEtbRo5bhn4Xm3tML2GQzMEVHCvBZ5LyqmeuhjpOc7breuy8Y/4NjTe//zzTRWCkal8B75MK7BRk=
X-Received: by 2002:a05:6102:31b6:b0:3a6:eeec:a566 with SMTP id
 d22-20020a05610231b600b003a6eeeca566mr3501741vsh.28.1665764172140; Fri, 14
 Oct 2022 09:16:12 -0700 (PDT)
MIME-Version: 1.0
References: <20221014030459.3272206-1-guoren@kernel.org> <20221014030459.3272206-2-guoren@kernel.org>
 <20221013203544.110a143c@kernel.org> <20221013203911.2705eccc@kernel.org>
 <Y0jowX4zIZMMVc0H@yury-laptop> <20221014090311.392e0546@kernel.org>
In-Reply-To: <20221014090311.392e0546@kernel.org>
From:   Yury Norov <yury.norov@gmail.com>
Date:   Fri, 14 Oct 2022 09:16:01 -0700
Message-ID: <CAAH8bW_6uT7M_y7GEZSrzo1WJZfZ2j=UeZreXX9yHCEFqXNJzQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] net: Fixup netif_attrmask_next_and warning
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     guoren@kernel.org, andriy.shevchenko@linux.intel.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        linux@rasmusvillemoes.dk, caraitto@google.com, willemb@google.com,
        jonolson@google.com, amritha.nambiar@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Oct 14, 2022 at 9:03 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 13 Oct 2022 21:42:41 -0700 Yury Norov wrote:
> > > Oh, it was reposted today:
> > >
> > > https://lore.kernel.org/all/20221013234349.1165689-2-yury.norov@gmail=
.com/
> > >
> > > But we need a revert of 854701ba4c as well to cover the issue back up
> > > for 6.1, AFAIU.
> >
> > The patch 854701ba4c is technically correct. I fixed most of warnings i=
n
> > advance, but nobody can foresee everything, right? I expected some nois=
e,
> > and now we have just a few things to fix.
>
> I got 6 warnings booting my machine after pulling back from Linus
> (which included your patches in net for the first time).
> And that's not including the XPS and the virtio warning.
>
> > This is what for -rc releases exist, didn't they?
> >
> > I suggest to keep the patch, because this is the only way to make
> > cpumask_check()-related issues visible to people. If things will go as
> > they go now, I expect that -rc3 will be clean from cpumask_check()
> > warnings.
>
> This sounds too close to saying that "it's okay for -rc1 to be broken".
> Why were your changes not in linux-next for a month before the merge
> window? :(

They spent about a month in -next. Nobody cared.

> We will not be merging a refactoring series into net to silence an
> arguably over-eager warning. We need a minimal fix, Guo Ren's patches
> seem to miss the mark so I reckon the best use of everyone's time is
> to just drop the exposing patch and retry in -next =F0=9F=A4=B7

If you prefer treating symptoms rather than the disease - I have nothing
to add.
