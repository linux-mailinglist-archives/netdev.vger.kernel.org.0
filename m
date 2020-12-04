Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3636E2CF6EF
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 23:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387703AbgLDWiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 17:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387527AbgLDWiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 17:38:21 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00D8C0613D1
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 14:37:40 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id v3so3922310plz.13
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 14:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c6hMk7kVGMlcW1AbN/CVtuIM7fjslmb1EFlV3rI/eb8=;
        b=hk69Ub0xM750SeXGscbw90RJlwMEb/XPhbuYtYsVy8DQaVyvQMM1WYlD7NR7AInvHn
         IUIYVr+JAE636J3fp+P8yigD/0yYPiuyMkPf5MA+Lo/BHGexgCjVYx4R4yd5Z6vX2dEF
         w5jsIfEG7EvlEamVktsmEzbabUPWn62zKJczm4Wsz8xSExBbjw48QDBvbk9Qg67l1a2j
         Jr8Qs/89FYdtuXAIZS9GQ02VUuO02bRKMl2LYhS6awcSVVXwFWyJG5XldvxojR1AoGW8
         QazEMxJDOE49UHLDQZzMQSZt/x+EkbdAoA25zisbHw1AtZkuDvo1nWbYVaJ9C0MjOp5O
         VogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c6hMk7kVGMlcW1AbN/CVtuIM7fjslmb1EFlV3rI/eb8=;
        b=iwh/MRW5DXTRpH0f/6mm1dX7YEiCe8Oxbvna96d4ESyYO3XKxFypetkAApUa1gBkK8
         4FiCw+TMkwIqk7HFTNI01GHQlWMhoEKAJR1EXPfnrQ8bJih9Nxr9FU19hNHloIiYL1gh
         ljL4OwWtaHHQscensh+INnIBDA4XO6Ns6wZk7fvYA+pKrAd8hTnFz6cS7wjWFNqavWWQ
         Z+fbosQ1qgW+hSEvYbphAWhp9Mjx1JEmWIPCOBIt16TZDfovpAHWO8vl6IclVvv7yqyv
         9EU0ipB+tsaN5Nn4V/J6TYwE49RriSFnmWO/LBL+lRxrb7NIEz5fHZv4lyy27jyprWFO
         Hm5w==
X-Gm-Message-State: AOAM532x/ohuHYstOP+/Nq5pppEM5unX7rruGVd8d/IfdMJuhwkuilho
        aj3tx6iUKbD+72Md0ScmQ79lj52wcbh4dB5Y4oo4a4npn80=
X-Google-Smtp-Source: ABdhPJymuHlJRt+Zb7gA0ggjAOCbejE5mJZdEt39RSgcUvMI00VTL9nyRCFWtwa1AMfvmrMCg7DvKKbD1OZNRBBff2M=
X-Received: by 2002:a17:90a:d494:: with SMTP id s20mr6112136pju.178.1607121460093;
 Fri, 04 Dec 2020 14:37:40 -0800 (PST)
MIME-Version: 1.0
References: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
 <20201202220945.911116-2-arjunroy.kdev@gmail.com> <20201202161527.51fcdcd7@hermes.local>
 <384c6be35cc044eeb1bbcf5dcc6d819f@AcuMS.aculab.com> <CAOFY-A07C=TEfob3S3-Dqm8tFTavFfEGqQwbisnNd+yKgDEGFA@mail.gmail.com>
 <CAOFY-A2vTwyA_45oUQR-91CMZya5i1y-4yzDboL+CnKceLzXPw@mail.gmail.com> <99eb2611ce8a47289a6c6360f29acdd7@AcuMS.aculab.com>
In-Reply-To: <99eb2611ce8a47289a6c6360f29acdd7@AcuMS.aculab.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Fri, 4 Dec 2020 14:37:29 -0800
Message-ID: <CAOFY-A060UoG_aFM1nK_++-mGnUxXQKeyso9L_z0Du4WJVumUg@mail.gmail.com>
Subject: Re: [net-next v2 1/8] net-zerocopy: Copy straggler unaligned data for
 TCP Rx. zerocopy.
To:     David Laight <David.Laight@aculab.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "soheil@google.com" <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 4, 2020 at 1:03 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Arjun Roy
> > Sent: 03 December 2020 23:25
> ...
> > > > You also have to allow for old (working) applications being recompiled
> > > > with the new headers.
> > > > So you cannot rely on the fields being zero even if you are passed
> > > > the size of the structure.
> > > >
> > >
> > > I think this should already be taken care of in the current code; the
> > > full-sized struct with new fields is being zero-initialized, then
> > > we're getting the user-provided optlen, then copying from userspace
> > > only that much data. So the newer fields would be zero in that case,
> > > so this should handle the case of new kernels but old applications.
> > > Does this address the concern, or am I misunderstanding?
> > >
> >
> > Actually, on closer read, perhaps the following is what you have in
> > mind for the old application?
> >
> > struct zerocopy_args args;
> > args.address = ...;
> > args.length = ...;
> > args.recv_skip_hint = ...;
> > args.inq = ...;
> > args.err = ...;
> > getsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, &args, sizeof(args));
> > // sizeof(args) is now bigger when recompiled with new headers, but we
> > did not explicitly set the new fields to 0, therefore issues
>
> That's the one...
>

I'll defer in this case to Eric's previous response in this thread
(paraphrased: that there is precedent for this in tcp_mmap.c).

-Arjun

>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
