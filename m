Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103FB3953D4
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 04:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhEaCEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 22:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbhEaCEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 22:04:32 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B468C061574
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 19:02:52 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id m18so9243464wrv.2
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 19:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VOTYKr9ClxWd1s2Ahe0QVirYxLvSTejb/XTAL5/mg1o=;
        b=fFHixn8oFyI7RdOciGF9hhikSupAL3LuJB5Cbt6A2i7QpoShIJ7oCRj8n4Lh7+V4J4
         M8jNG2qIlVQrDEYbb0ktQKUmLZeWDXU/1unh/Z3q01J+WOtbO2Lc7sLPbXdnerG3IxQ8
         yHZyjwiLxTplAaVkamoEIbbW5NTE1Jd3BsUW2/JBRS105xWe7T7Fyh2mZhrq9rO8g5D6
         wavzzYbX/n6agtUW8eTXyu8qGjLFXYZu8aJ/BaiHzLhaNdNPERJPfTp45XiC3kur3oTq
         4t7f/cvX5Ohw8/y/3n072anLnUiHoXTbjLtrzdu6LN4+cURgXNAt3erQZBgRP4t5eveY
         bdcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VOTYKr9ClxWd1s2Ahe0QVirYxLvSTejb/XTAL5/mg1o=;
        b=H26F5LEMTAGMAkvp6Wx7V7J3g0/FuuLPm2gLRi4UxC635tvl6qEg/z37OEefE93HxM
         OJPcOFgFfomjbOvnqByGqVWisI5wrIh9/0EqeCWkUDd0TTUsEytievVaLdjvi9gMignD
         blbkY/QbMXPctNTWXWb2o5oJEPQMXWoIgPwqiEDjrN5XmqQY0yTab+xXTihavg+5v3U9
         KjuWxTx2tHVtFwWOB6uDmAKucScs8RRJWi5KJjLtXxwKec9v5Hct+EIAa7p9u1ctKm9S
         TPxO+2mZii2CKOhCjubETdKG5322PUUvodL4ShxsmlmIMr3qm2/AKBYiqDt+3t7K8AYi
         b9jA==
X-Gm-Message-State: AOAM533dNFp+0keK+rjxnxHxedd+MitpHdHDolKBVztFBUhnblL1yKsl
        KDsTQxZXzxGbiYT0Ypx83nB80wGLSmmX6FlRLGQ=
X-Google-Smtp-Source: ABdhPJzXN1NZySAPIpbVM+/eQB5N1rMZGf5zbepNKKTXQd0Eub1O+KtfsG6jR2uz1gVy2OiyinH+iVvG1gdDTUAF6Wo=
X-Received: by 2002:a05:6000:2cf:: with SMTP id o15mr20028401wry.243.1622426570893;
 Sun, 30 May 2021 19:02:50 -0700 (PDT)
MIME-Version: 1.0
References: <04cb0c7f6884224c99fbf656579250896af82d5b.1622142759.git.lucien.xin@gmail.com>
 <CADvbK_e0PkKBYAUyg6iYyUwUp+owpv1r9_cnS7pbkLSjwX+VWg@mail.gmail.com>
 <20210528153911.4f67a691@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CADvbK_dvj2ywH5nQGcsjAWOKb5hdLfoVnjKNmLsstk3R1j7MyA@mail.gmail.com>
 <54cb4e46-28f9-b6db-85ec-f67df1e6bacf@gmail.com> <CADvbK_endt5VLzyDMumn6ks8oF5WkQ0hbx6XguyRbJZzOf4K5A@mail.gmail.com>
 <cf628b45-c527-3390-4738-de7732268e44@gmail.com>
In-Reply-To: <cf628b45-c527-3390-4738-de7732268e44@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sun, 30 May 2021 22:02:39 -0400
Message-ID: <CADvbK_fQQzH9uuHj_8mSQ=OSGETpwO4qdaZeBc-uE24AyphAWg@mail.gmail.com>
Subject: Re: [PATCH net] udp: fix the len check in udp_lib_getsockopt
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 30, 2021 at 9:31 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 5/29/21 10:47 AM, Xin Long wrote:
> > On Fri, May 28, 2021 at 9:57 PM David Ahern <dsahern@gmail.com> wrote:
> >>
> >> On 5/28/21 7:47 PM, Xin Long wrote:
> >>> The partial byte(or even 0) of the value returned due to passing a wrong
> >>> optlen should be considered as an error. "On error, -1 is returned, and
> >>> errno is set appropriately.". Success returned in that case only confuses
> >>> the user.
> >>
> >> It is feasible that some app could use bool or u8 for options that have
> >> 0 or 1 values and that code has so far worked. This change would break that.
> > Got it.
> > Not sure if it's possible or necessary to also return -EINVAL if optlen == 0
> >
>
> do_tcp_getsockopt for example does not fail on optlen 0; no reason to
> make this one fail.
I was about to say do_tcp_getsockopt has the same issue. :-)
