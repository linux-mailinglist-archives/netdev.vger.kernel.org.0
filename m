Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D16E2ED738
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 20:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbhAGTHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 14:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbhAGTHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 14:07:39 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580EEC0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 11:06:58 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id r9so7203259ioo.7
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 11:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=corjf3KyOH0H4DhYt4w4crTghb0GmphbSRrLqyirvV0=;
        b=IBpo3R63XB37DuR2koRK8HAIlEx7Ghma/mHckO6c4DOgvBi+cFTLPPYt64nl6XaCgz
         6JWF1JZYEM+SqnDbIcuIozquxakbETZmGfStwnpVyFHQWW+2P5NRm+oY636ctU81JPJk
         oPUDYPPCM14aLmd1P4iJiGl9rOaXajO4XgixdXU0yw61lpn0Wo9G5qgDXCqArxbqGAxv
         b+iPV53RtkPqGv+ReP6b+Tu9CnL9qfsWpHSlA/eEaH3VerIOFEXnT6dR4S85GinV3E1Z
         hQffPvnojZtxyoSxSTnVxW/2pFNrsESNGpZTyomyOpM4TmAOrUOaU/s0R9tdKiEqr2N0
         cHdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=corjf3KyOH0H4DhYt4w4crTghb0GmphbSRrLqyirvV0=;
        b=f/WHET+RpHRHcsZ0PpOZNoat8894Cc8WrDB12WebwCGNqe/5XA/v9y+fMWWyACijia
         Ls1184cNfbEv4ypOqP9kQuwUwR51EWwKycMTw/E8CS01dwfVvrlTZt8sAlIdF0v76/0g
         mk0p69dn6EoTVxvezhY2U4L+wetFPOLH95gX5nK2MyzXyKk1UjRqisFfJuRNPUOdrWG3
         ZOWfePopUMJ763lCPz8ZU+RsLB35fqBQ+bB+51kZABiQ20iXanMa8IkPaDEo1c1HisZz
         OXDPXprXBcULZnv09AmUpULfidxAKImS5fp+C818kp8Q7Ad8DO3gGYjpn+UHFxi8tKdu
         dlRQ==
X-Gm-Message-State: AOAM531Jt7L5VuPfXtG2T8ys894o6vAfj0s9jLUJQI8MKiT3uAwr6LZU
        fy2/DTqNNYKbuH6Y2Dav+Jh+WovO8uYS0M365F4=
X-Google-Smtp-Source: ABdhPJzaLi3Zpw+BSKeksQ4L7oOZoLWSgaZJMuSMy9fPzZdZ9nP+8yHHGhbonuVWlDKJgEwefb2n1iMVFYG26mz7Oq8=
X-Received: by 2002:a05:6638:c8:: with SMTP id w8mr9222254jao.75.1610046417764;
 Thu, 07 Jan 2021 11:06:57 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e13e2905b6e830bb@google.com> <CAHmME9qwbB7kbD=1sg_81=82vO07XMV7GyqBcCoC=zwM-v47HQ@mail.gmail.com>
 <CACT4Y+ac8oFk1Sink0a6VLUiCENTOXgzqmkuHgQLcS2HhJeq=g@mail.gmail.com>
 <CAHmME9q0HMz+nERjoT-TQ8_6bcAFUNVHDEeXQAennUrrifKESw@mail.gmail.com>
 <CACT4Y+bKvf5paRS4X1QrcKZWfvtUi6ShP4i3y5NukRpQj0p1+Q@mail.gmail.com> <CAHmME9oOeMLARNsxzW0dvNT7Qz-EieeBSJP6Me5BWvjheEVysw@mail.gmail.com>
In-Reply-To: <CAHmME9oOeMLARNsxzW0dvNT7Qz-EieeBSJP6Me5BWvjheEVysw@mail.gmail.com>
Reply-To: noloader@gmail.com
From:   Jeffrey Walton <noloader@gmail.com>
Date:   Thu, 7 Jan 2021 14:06:42 -0500
Message-ID: <CAH8yC8na1pNcGPBrfuBwyNbfC4JjOOo_xHODAkbjs1j-1h0+2A@mail.gmail.com>
Subject: Re: UBSAN: object-size-mismatch in wg_xmit
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 7, 2021 at 2:03 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Thu, Jan 7, 2021 at 1:22 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> >
> > On Mon, Dec 21, 2020 at 12:23 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > >
> > > ...
> >
> > These UBSAN checks were just enabled recently.
> > It's indeed super easy to trigger: 133083 VMs were crashed on this already:
> > https://syzkaller.appspot.com/bug?extid=8f90d005ab2d22342b6d
> > So it's one of the top crashers by now.
>
> Ahh, makes sense. So it is easily reproducible after all.
>
> You're still of the opinion that it's a false positive, right? I
> shouldn't spend more cycles on this?

You might consider making a test build with -fno-lto in case LTO is
mucking things up.

Google Posts Patches So The Linux Kernel Can Be LTO-Optimized By
Clang, https://www.phoronix.com/scan.php?page=news_item&px=Linux-Kernel-Clang-LTO-Patches

Jeff
