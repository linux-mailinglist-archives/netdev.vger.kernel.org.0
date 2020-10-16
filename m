Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431BE28FF36
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 09:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404701AbgJPHfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 03:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404697AbgJPHfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 03:35:55 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F66CC061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 00:35:55 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k21so2577707ioa.9
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 00:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u7qwW5lwtSNOyHDsTGnqiNPRJU2aYDZFjJeR0++aK1s=;
        b=ufPK33+a6DMS19HuUhiP+YaWzOvOCgwd6PHGvMRqSl1NCysvR2wkcUcRN2vF5y6pso
         /Sv/1VfyryYZMviTMiaQzuLoyDd3Tsn0KzJcgNtDVPF/vJ4nTAdQx2y9iNjap2bc64zZ
         04/M4awGLloQ4UGg17kiOXgNyy4QdCbvODnyrzfmw9yp6ZUhEOQXTyXjPMIslF2M12sd
         M4TIodJNsZXF49EFJvLTj2QkFbm/tdl2Cma4rug03wnBJXVy30ui/KDoi6Sp0y9gBhzm
         oH6UaKPDjHr5sv+b+IunkAKrYGF2YB/9K4Z/ajtjI03rYtMLt2ckoPsQ4OPubZ/knFiM
         NV8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u7qwW5lwtSNOyHDsTGnqiNPRJU2aYDZFjJeR0++aK1s=;
        b=nFrMao5+ckz0syOBI6ztO64RuWVgCZk29Li1T26pqYmnqAjWpaN3WerSTn/2NKx1CJ
         SOACvhbc3bm3jrW87/3WfxyA7cZcmzQigsNsFDjz8YMzXvH4py2TCSNC8eHJJWcXjWmE
         glTC0eJyDBSA0G6nCByP7zUB7zAGhxvptAcZTQz22Jx0tf0bwPtaAXC858AwY1lmROIP
         +u8eD0r5LFY8T8xXEXTHd60tiHoG2TUD6LIQMjASvoWVQA8ncHjcNEtTHvz8BPUiBd6P
         O3BKWAqeNVUD0Gq2YpBCzqaSWcMIzu0VsaEqguHQQsWA/hVY3XjNtteNyVk8t5kJjpHG
         f0kg==
X-Gm-Message-State: AOAM530iJpre/4PdWJtdBcGTDPi79pT3kM7iitCFKgroryMZytwqA2b4
        dh7OJkFdc8drTei2zLPO+Cf/ym6WAwUYlO7aze5QkA==
X-Google-Smtp-Source: ABdhPJwcfgXIR+cI+ss38HA116PtIf+68m2rajno9lnuKm4tv4c3BiaOpdylggHq6V68olVkcAGUDwL7+qDs+lB2Mlk=
X-Received: by 2002:a5e:c112:: with SMTP id v18mr1498419iol.195.1602833754271;
 Fri, 16 Oct 2020 00:35:54 -0700 (PDT)
MIME-Version: 1.0
References: <87eelz4abk.fsf@marvin.dmesg.gr> <CADVnQym6OPVRcJ6PdR3hjN5Krcn0pugshdLZsrnzNQe1c52HXA@mail.gmail.com>
 <CAK6E8=fCwjP47DvSj4YQQ6xn25bVBN_1mFtrBwOJPYU6jXVcgQ@mail.gmail.com>
 <87blh33zr7.fsf@marvin.dmesg.gr> <CADVnQym2cJGRP8JnRAdzHfWEeEbZrmXd3eXD-nFP6pRNK7beWw@mail.gmail.com>
In-Reply-To: <CADVnQym2cJGRP8JnRAdzHfWEeEbZrmXd3eXD-nFP6pRNK7beWw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 16 Oct 2020 09:35:42 +0200
Message-ID: <CANn89iJMh6C85oGnTgXEcF6XYFsZFiRq17tMOY_3V=N5vJVWxA@mail.gmail.com>
Subject: Re: TCP sender stuck in persist despite peer advertising non-zero window
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Apollon Oikonomopoulos <apoikos@dmesg.gr>,
        Yuchung Cheng <ycheng@google.com>,
        Netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 12:37 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Thu, Oct 15, 2020 at 6:12 PM Apollon Oikonomopoulos <apoikos@dmesg.gr> wrote:
> >
> > Yuchung Cheng <ycheng@google.com> writes:
> >
> > > On Thu, Oct 15, 2020 at 1:22 PM Neal Cardwell <ncardwell@google.com> wrote:
> > >>
> > >> On Thu, Oct 15, 2020 at 2:31 PM Apollon Oikonomopoulos <apoikos@dmesg.gr> wrote:
> > >> >
> > >> > Hi,
> > >> >
> > >> > I'm trying to debug a (possible) TCP issue we have been encountering
> > >> > sporadically during the past couple of years. Currently we're running
> > >> > 4.9.144, but we've been observing this since at least 3.16.
> > >> >
> > >> > Tl;DR: I believe we are seeing a case where snd_wl1 fails to be properly
> > >> > updated, leading to inability to recover from a TCP persist state and
> > >> > would appreciate some help debugging this.
> > >>
> > >> Thanks for the detailed report and diagnosis. I think we may need a
> > >> fix something like the following patch below.
> >
> > That was fast, thank you!
> >
> > >>
> > >> Eric/Yuchung/Soheil, what do you think?
> > > wow hard to believe how old this bug can be. The patch looks good but
> > > can Apollon verify this patch fix the issue?
> >
> > Sure, I can give it a try and let the systems do their thing for a couple of
> > days, which should be enough to see if it's fixed.
>
> Great, thanks!
>
> > Neal, would it be possible to re-send the patch as an attachment? The
> > inlined version does not apply cleanly due to linewrapping and
> > whitespace changes and, although I can re-type it, I would prefer to test
> > the exact same thing that would be merged.
>
> Sure, I have attached the "git format-patch" format of the commit. It
> does seem to apply cleanly to the v4.9.144 kernel you mentioned you
> are using.
>
> Thanks for testing this!
>
> best,
> neal

Ouch, this is an interesting bug.  Would netperf -t TCP_RR -- -r
2GB,2GB   " be a possible test ?
(I am afraid packetdrill won't be able to test this in a reasonable
amount of time)

Neal, can you include in your changelog the link to Apollon awesome
email, I think it was a very nice
investigation and Apollon deserves more credit than a mere "Reported-by:" tag ;)

Maybe this one :
Link: https://www.spinics.net/lists/netdev/msg692430.html


Thanks !
