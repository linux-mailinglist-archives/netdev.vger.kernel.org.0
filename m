Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A54D418EC09
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 20:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgCVTyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 15:54:05 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41943 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgCVTyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 15:54:04 -0400
Received: by mail-ed1-f68.google.com with SMTP id v6so13921219edw.8
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 12:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M56HRF7yj/zQ5PGc20FmyrfbsQ5EgKKx23a3WTtVBJQ=;
        b=XcmGVj1hrdeLjEKSi5tQOUnu7ERBEz+ZF6JdVlt4uRHYtwyferdXLe66o5dGOHHDep
         eyecV7GiWp9JvL82R8AHqwrhdu0yjeQOrVMatDskha/rVKoIGyHsanNi5n/C5CGclEJb
         FouOB+HIoYUAuW+akQdJ0YDP6kTRjoX1U/BpzlWhtL8GTIeP/OOHxsR87RXI0aMNpVaC
         h3MGruOIwZg8aUI1TSNCy57x6QqSBPmHf3HNFboT4xu5ht0dY1DsSpD9jofUrEeL6K3s
         OqWVioVGM8anUn3iejw1mbpfy9VRuP7lYc+4xEnVEOTIcaGFg/yrZbSAmIl3wfeQsjbx
         Wp9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M56HRF7yj/zQ5PGc20FmyrfbsQ5EgKKx23a3WTtVBJQ=;
        b=GjtDRExtabNbIAtJO+75VJ4leD1OA/IwOMTAR5Z0sqd+Ed7PyXeJM0Ys4n/sZ/WZ3D
         c/nff9UkQrxVCraHRW5Efem+oLn3qDDSMJmiZh5njMw8b/pMLMSRVUA9b9r0cu0ilmLp
         n2Rd5TkedbPykD3RE61+9w5gkvzUVY5EGp5qHOMjukZQahecrSyFhz0D8hyAtJUQ9Mx6
         sKNWoTQvenMiZlPSPOwsuNI3HMTDTdLiz9/aLhb6PUEEEQgOWY9m5YF6u0nMCDctdIQo
         nLqwlgBFZaOECBw/OZGLekHvL3kC4bPSfqtATcAFrwRu/vUIWwe7EBIkck5+9W74AgS4
         6MDQ==
X-Gm-Message-State: ANhLgQ1aIJgnprrPQH+NkCTPQLVIZyHDNCy+9J0bcExZq0H5E0HeAodq
        L67ZffjznihPPmNhjJmuik6cyZPZRMTud9qru8xuLzIYp2o=
X-Google-Smtp-Source: ADFU+vt0zBK4ShOMlyQXa7bRCXWxpXFFTK3Dg8a3Jxf0CA/rX4o0oGGXp3bi7QC1H9DdbJO8Ims9vEB2TwGXaxT+wqA=
X-Received: by 2002:a05:6402:1a27:: with SMTP id be7mr2029437edb.241.1584906842303;
 Sun, 22 Mar 2020 12:54:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200228.120150.302053489768447737.davem@davemloft.net>
 <1583131910-29260-1-git-send-email-kyk.segfault@gmail.com>
 <CABGOaVRdsw=4nqBMR0h8JPEiunOEpHR+02H=HRbgt_TxhVviiA@mail.gmail.com>
 <945f6cafc86b4f1bb18fa40e60d5c113@AcuMS.aculab.com> <CABGOaVQMq-AxwQOJ5DdDY6yLBOXqBg6G7qC_MdOYj_z4y-QQiw@mail.gmail.com>
 <de1012794ec54314b6fe790c01dee60b@AcuMS.aculab.com> <CABGOaVSddVL-T-Sz_GPuRoZbKM_HsZND84rJUm2G9RRw6cUwCQ@mail.gmail.com>
 <CA+FuTSc5QVF_kv8FNs03obXGbf6axrG5umCipE=LXvqQ_-hDAA@mail.gmail.com>
 <817a6418ac8742e6bb872992711beb47@AcuMS.aculab.com> <91fafe40-7856-8b22-c279-55df5d06ca39@gmail.com>
 <e8b84bcaee634b53bee797aa041824a4@AcuMS.aculab.com>
In-Reply-To: <e8b84bcaee634b53bee797aa041824a4@AcuMS.aculab.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Sun, 22 Mar 2020 12:53:50 -0700
Message-ID: <CALx6S342XSFnZqFJ_jMKuAshSg0g-gcj3eSerADvWi14t+gCiw@mail.gmail.com>
Subject: Re: [PATCH v2] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
To:     David Laight <David.Laight@aculab.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 6, 2020 at 9:12 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Eric Dumazet
> > Sent: 05 March 2020 17:20
> >
> > On 3/5/20 9:00 AM, David Laight wrote:
> > > From: Willem de Bruijn
> > >> Sent: 05 March 2020 16:07
> > > ..
> > >> It seems do_csum is called because csum_partial_copy executes the
> > >> two operations independently:
> > >>
> > >> __wsum
> > >> csum_partial_copy(const void *src, void *dst, int len, __wsum sum)
> > >> {
> > >>         memcpy(dst, src, len);
> > >>         return csum_partial(dst, len, sum);
> > >> }
> > >
> > > And do_csum() is superbly horrid.
> > > Not the least because it is 32bit on 64bit systems.
> >
> > There are many versions, which one is discussed here ?
> >
> > At least the current one seems to be 64bit optimized.
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5777eaed566a1d63e344d3dd
> > 8f2b5e33be20643e
>
> I was looking at the generic one in $(SRC)/lib/checksum.c.
>
> FWIW I suspect the fastest code on pre sandy bridge 64bit intel cpus
> (where adc is 2 clocks) is to do a normal 'add', shift the carries
> into a 64bit register and do a software 'popcnt' every 512 bytes.
> That may run at 8 bytes/clock + the popcnt.

A while back, I had proposed an optimized x86 checksum function using
unrolled addq a while back https://lwn.net/Articles/679137/. Also,
this tries to optimize from small checksum like over header when doing
skb_postpull_rcsum.

Tom

>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
