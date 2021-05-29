Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD823949E3
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 03:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhE2Bs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 21:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhE2Bsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 21:48:55 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D91C061574
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 18:47:18 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id o127so3007257wmo.4
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 18:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2vUGk2gUuzScAZTXp1K3m8DxxDRc+mrrlrOjArLn540=;
        b=kJMSubWwLi09jyV+DP21P9utmnN8b0wg69lEqVlXYWUadH7xUweF/xTzhNGqZj4jpG
         egkG+h4D+XI76oCFfVofFWLM+zA36RzuRYZckLyRKZg0uflex5tWi/bAfwHjY0F2Jk9I
         /dViwieC2VUOSrNiMAHu32JlyYxwt64gWOvNTVwhVSmhBjswQmX09+Vr8qwYL7+uOGxT
         E5s/Qs3jrKcfq5AdwXDXK67qcUNyQyjRbIedYNSfRmc+ZfSVM4265at2dWkki2LSPwaf
         5Lewrja9dlUuIpTPamhy1HZEOkxnqiuLizQ4Yor5z5Gp7ba2mvK/oPYAGtBSuRPFRasT
         yrmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2vUGk2gUuzScAZTXp1K3m8DxxDRc+mrrlrOjArLn540=;
        b=K9lghytBLPlduZx8c3eV2boCkASSJkCdCEwb9VOBkYCkxvCDqQ7Sndu7IaEOFEu0Vy
         Gqf2i9tw4fjA8E54drS1pJQuYJ2cRxsOYDgKDpc9iw5p+mdmwdfEfDHunpmAngSLrt5J
         6XaofW/hcggyR37lEjLNv6vbascMLsRXmyP80+y8HW98Mbb3ePZE4A9qjhjXGMK6WUNZ
         udxMdrpZ6Lu9DTj3/zjs4lhGjzpX65yZ2pl25fHab9/4YBM4wp5C0itibxPu6qZN4sfk
         ziXXn5oPAIXMTuGmXRIorhMUK2vzwFKAs04NXIVjU3Bx0ZKiZPHOTf4//WyKRbtyYHMI
         sVpg==
X-Gm-Message-State: AOAM531HtrFPF8Vq3o/qBftp3BJjGQPt4RbADI2LS9pDvuYul8MbYdyt
        ExI8MTPLrTN9diP1X1nA9u1NZ6tRQZaZgp0h6os3UsApEVJVDQ==
X-Google-Smtp-Source: ABdhPJwcA4gGBPxeMnq71imeSlv4iQIEti4fMDR+ktL31/m3C1sdR5aJfJsaG50Pce7XRpg5tbNsTAuf52j344bVSIc=
X-Received: by 2002:a05:600c:4fca:: with SMTP id o10mr11581005wmq.175.1622252837249;
 Fri, 28 May 2021 18:47:17 -0700 (PDT)
MIME-Version: 1.0
References: <04cb0c7f6884224c99fbf656579250896af82d5b.1622142759.git.lucien.xin@gmail.com>
 <CADvbK_e0PkKBYAUyg6iYyUwUp+owpv1r9_cnS7pbkLSjwX+VWg@mail.gmail.com> <20210528153911.4f67a691@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210528153911.4f67a691@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 28 May 2021 21:47:06 -0400
Message-ID: <CADvbK_dvj2ywH5nQGcsjAWOKb5hdLfoVnjKNmLsstk3R1j7MyA@mail.gmail.com>
Subject: Re: [PATCH net] udp: fix the len check in udp_lib_getsockopt
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 6:39 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 27 May 2021 15:13:32 -0400 Xin Long wrote:
> > On Thu, May 27, 2021 at 3:12 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > Currently, when calling UDP's getsockopt, it only makes sure 'len'
> > > is not less than 0, then copys 'len' bytes back to usespace while
> > > all data is 'int' type there.
> > >
> > > If userspace sets 'len' with a value N (N < sizeof(int)), it will
> > > only copy N bytes of the data to userspace with no error returned,
> > > which doesn't seem right.
>
> I'm not so sure of that. In cases where the value returned may grow
> with newer kernel releases truncating the output to the size of buffer
> user space provided is pretty normal. I think this code is working as
> intended.
Hard to say, I saw this kind of checks from 1da177e4c3f4 ("Linux-2.6.12-rc2"),
the new codes are using 'len < sizeof(x)'. Comparing to growing 'int', other
structures are more likely to grow.

>
> > > Like in Chen Yi's case where N is 0, it
> > > called getsockopt and got an incorrect value but with no error
> > > returned.
> > >
> > > The patch is to fix the len check and make sure it's not less than
> > > sizeof(int). Otherwise, '-EINVAL' is returned, as it does in other
> > > protocols like SCTP/TIPC.
> > >
> > > Reported-by: Chen Yi <yiche@redhat.com>
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > ---
> > >  net/ipv4/udp.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > > index 15f5504adf5b..90de2ac70ea9 100644
> > > --- a/net/ipv4/udp.c
> > > +++ b/net/ipv4/udp.c
> > > @@ -2762,11 +2762,11 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
> > >         if (get_user(len, optlen))
> > >                 return -EFAULT;
> > >
> > > -       len = min_t(unsigned int, len, sizeof(int));
> > > -
> > > -       if (len < 0)
> > > +       if (len < sizeof(int))
> > >                 return -EINVAL;
> > >
> > > +       len = sizeof(int);
> > > +
> > >         switch (optname) {
> > >         case UDP_CORK:
> > >                 val = up->corkflag;
> >
> > Note I'm not sure if this fix may break any APP, but the current
> > behavior definitely is not correct and doesn't match the man doc
> > of getsockopt, so please review.
>
> Can you quote the part of man getsockopt you're referring to?
The partial byte(or even 0) of the value returned due to passing a wrong
optlen should be considered as an error. "On error, -1 is returned, and
errno is set appropriately.". Success returned in that case only confuses
the user.
