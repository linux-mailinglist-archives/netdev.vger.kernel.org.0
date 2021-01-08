Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCDC2EF99C
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 21:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729105AbhAHUzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 15:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbhAHUzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 15:55:12 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A860EC0612EA
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 12:54:31 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id w17so11561125ilj.8
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 12:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7sDo7Ig6dt2HxHSXD1nx4pPbJPS7gh4sWOn7HUm8xWI=;
        b=mPDKeANGgH15/xo29DTlSZ1g1TfSRRAiA1k0ZeNe3QrC75e3zQdbqycUodA1PiYhVc
         hJTv5Ib1bfUQuQC3rbX6dK/SAHGS8alAZz8shYFjF7SlqzKkBEXz0yWrWgqKQ8iIUG7F
         Ffs8RQGEmU0olqPzxQ74zg+gjIV8XA1hrzmjh2gVgn1hH+dME738NYL3a7j67Iyykvzi
         qhnUJwwTtxV5LHWFlGLQ9GJ3GkqOdWX2Xxv4krOwVy9CGZOivWAWbhdFCDZFHoANz7/O
         1W9bkpR6IXX8Y0VKIEvG3bLb+D+DVwTJnXVdgQAlm/hrWylyTkjIxyhnR9qet3vB3782
         EyRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7sDo7Ig6dt2HxHSXD1nx4pPbJPS7gh4sWOn7HUm8xWI=;
        b=nPVQtvDxVTq6sQNtUUPPW75PYufZX5v+2/lEFtIRS+RGIdGbia97NWj64g75iozpg9
         Si4EIMYiwdYmroq2GLinkjc6rLmr38cpxipI4MMmGYnA8VWh6EyBab2OV8t84rd+1GAn
         V/nFMV+bVQApOtaUS7oxT8Pi6eCmtryptmYxF7PYum7Je2Y8yxDTih9Q6NbqSgSUM9Oo
         StZJ+RZisFJ9b0Z8ewyAAentaEP+jtkhplCWJ1EINKsGQElKcw5RkXH0I3+qq4emJpym
         zkW4GtseaZYp7Ahj6GmJGM42YwQJS3WrjlHKRayvMw8Im2PQyfAYG3fa9DcGzLjbju0b
         bR/w==
X-Gm-Message-State: AOAM533bkKcifhTTVadM5GD+WRPn67fxcU17L4OnTqlQx4lhNTergbPd
        JsQpeOsBfVqGSOLgpYANfWY=
X-Google-Smtp-Source: ABdhPJylezPuqPddhKq1qSotHzhfsK4Y+VoLRyotouG7ekXbb0IBcIiKbO68ddOAgVdVm9pJwnatdg==
X-Received: by 2002:a92:77c9:: with SMTP id s192mr5382314ilc.75.1610139270928;
        Fri, 08 Jan 2021 12:54:30 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id z18sm7639133ilb.26.2021.01.08.12.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 12:54:30 -0800 (PST)
Date:   Fri, 8 Jan 2021 13:54:28 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     noloader@gmail.com, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Subject: Re: UBSAN: object-size-mismatch in wg_xmit
Message-ID: <20210108205428.GA2547211@ubuntu-m3-large-x86>
References: <000000000000e13e2905b6e830bb@google.com>
 <CAHmME9qwbB7kbD=1sg_81=82vO07XMV7GyqBcCoC=zwM-v47HQ@mail.gmail.com>
 <CACT4Y+ac8oFk1Sink0a6VLUiCENTOXgzqmkuHgQLcS2HhJeq=g@mail.gmail.com>
 <CAHmME9q0HMz+nERjoT-TQ8_6bcAFUNVHDEeXQAennUrrifKESw@mail.gmail.com>
 <CACT4Y+bKvf5paRS4X1QrcKZWfvtUi6ShP4i3y5NukRpQj0p1+Q@mail.gmail.com>
 <CAHmME9oOeMLARNsxzW0dvNT7Qz-EieeBSJP6Me5BWvjheEVysw@mail.gmail.com>
 <CAH8yC8na1pNcGPBrfuBwyNbfC4JjOOo_xHODAkbjs1j-1h0+2A@mail.gmail.com>
 <CACT4Y+ZRfQkPYoO+cgygsTLFLSbnyPRqHw3mVdVDg6zVAs4s2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZRfQkPYoO+cgygsTLFLSbnyPRqHw3mVdVDg6zVAs4s2A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 10:33:19AM +0100, Dmitry Vyukov wrote:
> On Thu, Jan 7, 2021 at 8:06 PM Jeffrey Walton <noloader@gmail.com> wrote:
> >
> > On Thu, Jan 7, 2021 at 2:03 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > >
> > > On Thu, Jan 7, 2021 at 1:22 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > > >
> > > > On Mon, Dec 21, 2020 at 12:23 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > > > >
> > > > > ...
> > > >
> > > > These UBSAN checks were just enabled recently.
> > > > It's indeed super easy to trigger: 133083 VMs were crashed on this already:
> > > > https://syzkaller.appspot.com/bug?extid=8f90d005ab2d22342b6d
> > > > So it's one of the top crashers by now.
> > >
> > > Ahh, makes sense. So it is easily reproducible after all.
> > >
> > > You're still of the opinion that it's a false positive, right? I
> > > shouldn't spend more cycles on this?
> >
> > You might consider making a test build with -fno-lto in case LTO is
> > mucking things up.
> >
> > Google Posts Patches So The Linux Kernel Can Be LTO-Optimized By
> > Clang, https://www.phoronix.com/scan.php?page=news_item&px=Linux-Kernel-Clang-LTO-Patches
> 
> Hi Jeff,
> 
> Are these patches upstream now?
> syzbot doesn't enable LTO intentionally, nor I see CONFIG_LTO in the
> provided config.

Those patches are not upstream yet and LTO will have to be explicitly
enabled via config.

Cheers,
Nathan
