Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE51C2EEFBF
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbhAHJeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727396AbhAHJeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 04:34:12 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60F8C0612F5
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 01:33:31 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id b64so7886851qkc.12
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 01:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PnLbusFPw0NqkYaHXS7jwwZf+CC6BlEDfblZZAjXZmc=;
        b=EiBwMyvADldbeeFFxd7qdO/JeI9YJxmiB/3XltO54PGT472GgYmaCBo7qmcebT4h1n
         bDBFVu0K/N7UpktoNxNwYewCXwYV+Fu3MNtmafhcCjapYKDrlK5SaYOE1wU7CNG5L3XG
         /w4MdA5Jm2jHUIbk3py1Q1rNJbPYQTEzUNVTrwLj1mPOdd1QctK+P7SmlRGX3kdFEfz2
         VdAj9ZD1Y9W2VfMxbekDvMu76cF1bG9l2KqGypVYuCk/0Ca3LD6eTol2/zIz8ZEq3XB9
         CGip9DcjXHs3p7qJN4WWrPDon/HJYCLrPyR6vVErKNAOqOH3aWR2lg9hMGAEmGGHs28c
         ksOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PnLbusFPw0NqkYaHXS7jwwZf+CC6BlEDfblZZAjXZmc=;
        b=fDYCNKVDyb2A/xxpIv4aHhvUbAfNChRvYR4lz69D6pFa3z+anwvuZJ6Yk2nPrQmS0T
         0Be91ZCKauNevLYZop4fSGdN2CGz8x3OvpSs6Qrf6yzsuXXI6SWdfwOOZnLZLVZ90QHt
         bQ5AQ2aiOK9la+em+fr707Rh9sB4Ogn8DL6uTMJtpnja4l3LGm6sV6q3Sl39JHhBzHup
         EKte7HnYs/VhvLecwR1LuNnyf0OsIJBvB4l7uCcD8AFRaTFnz2FmOYJa0Brs9PbHDEDt
         8WkeMacPxC4sjmwGLvTXlfYDCvu6hbYSGk/3CXw1PO3NdfIehY2XAWQ68YKzfkgwDlf4
         0I0w==
X-Gm-Message-State: AOAM5304zyLyuvBrxPfFom5UQNJWl86HbFZzyfLHwxQIiXki557wbJ2N
        N8IrAPOO0OfleYyd2S7JKca8AvA8fNRgdNiocjDunA==
X-Google-Smtp-Source: ABdhPJwoR7gUITNVyUOAEyZRNWl7p5el7UTrmj/K02apfnRIgeVk0q5jElVkY1Q+z4CE+Pb2RUb0XwiJc695IHluFnw=
X-Received: by 2002:a05:620a:983:: with SMTP id x3mr3074511qkx.231.1610098410717;
 Fri, 08 Jan 2021 01:33:30 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e13e2905b6e830bb@google.com> <CAHmME9qwbB7kbD=1sg_81=82vO07XMV7GyqBcCoC=zwM-v47HQ@mail.gmail.com>
 <CACT4Y+ac8oFk1Sink0a6VLUiCENTOXgzqmkuHgQLcS2HhJeq=g@mail.gmail.com>
 <CAHmME9q0HMz+nERjoT-TQ8_6bcAFUNVHDEeXQAennUrrifKESw@mail.gmail.com>
 <CACT4Y+bKvf5paRS4X1QrcKZWfvtUi6ShP4i3y5NukRpQj0p1+Q@mail.gmail.com>
 <CAHmME9oOeMLARNsxzW0dvNT7Qz-EieeBSJP6Me5BWvjheEVysw@mail.gmail.com> <CAH8yC8na1pNcGPBrfuBwyNbfC4JjOOo_xHODAkbjs1j-1h0+2A@mail.gmail.com>
In-Reply-To: <CAH8yC8na1pNcGPBrfuBwyNbfC4JjOOo_xHODAkbjs1j-1h0+2A@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 8 Jan 2021 10:33:19 +0100
Message-ID: <CACT4Y+ZRfQkPYoO+cgygsTLFLSbnyPRqHw3mVdVDg6zVAs4s2A@mail.gmail.com>
Subject: Re: UBSAN: object-size-mismatch in wg_xmit
To:     noloader@gmail.com
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 7, 2021 at 8:06 PM Jeffrey Walton <noloader@gmail.com> wrote:
>
> On Thu, Jan 7, 2021 at 2:03 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > On Thu, Jan 7, 2021 at 1:22 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > >
> > > On Mon, Dec 21, 2020 at 12:23 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > > >
> > > > ...
> > >
> > > These UBSAN checks were just enabled recently.
> > > It's indeed super easy to trigger: 133083 VMs were crashed on this already:
> > > https://syzkaller.appspot.com/bug?extid=8f90d005ab2d22342b6d
> > > So it's one of the top crashers by now.
> >
> > Ahh, makes sense. So it is easily reproducible after all.
> >
> > You're still of the opinion that it's a false positive, right? I
> > shouldn't spend more cycles on this?
>
> You might consider making a test build with -fno-lto in case LTO is
> mucking things up.
>
> Google Posts Patches So The Linux Kernel Can Be LTO-Optimized By
> Clang, https://www.phoronix.com/scan.php?page=news_item&px=Linux-Kernel-Clang-LTO-Patches

Hi Jeff,

Are these patches upstream now?
syzbot doesn't enable LTO intentionally, nor I see CONFIG_LTO in the
provided config.
