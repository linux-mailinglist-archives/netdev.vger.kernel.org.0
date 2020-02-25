Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0EBA16EC58
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 18:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730890AbgBYRRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 12:17:32 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34014 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbgBYRRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 12:17:31 -0500
Received: by mail-wm1-f66.google.com with SMTP id i10so1553050wmd.1
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 09:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=enwbul+2wY5IaL2JlcSBQKs2gWt8zyhe/5zh20sr06g=;
        b=l2inbIhkh97XFdP0v95gmdfpL/95QPmjNN2xdqL+NyMIrf6u0tuz5y6TApXILUaERI
         jHVZo1JeZbKMCSYG5pA/cEVrvkQANvgPwB3jROSZ9mRycapVsjLNndk6uJAJCReEzEa/
         rm6QVLJsCQERC85nsfiHGfCUdjaX043lRfeX+x8hblbNUh8yihHg6f0G7y4KDnU0zK6U
         j3N1n74tAECXqoXk9YZ1C0zvYiIM5xrRiKZJAxNf+wRX+3PB3eL9ovft1gkHa492nemP
         N1cvJ11Ib5H0wiwLo7wrWlzZxxHW0bbWYMbxVypXDn8aW5UgvTnVxZ+BIYbtMcsC+eGe
         zhWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=enwbul+2wY5IaL2JlcSBQKs2gWt8zyhe/5zh20sr06g=;
        b=oGg683NFbQUTymsAYW+CgHiHyqnGS28c9F6afJ6Me1B17HL3GEO8g+Ynt1Ze+DJcw1
         p0WlfMWirwMzCUEGOF9RD8JUWpeGL8SCjfNwTR/fhNgt/lrTW37/rwjLlAJJn9Sgwwqq
         5mtVjJjDzTy/ZLCzglJLBDNaYA6fypE4obxg5/5t7xs9TwK8bq1Nk4g34REm3AhY4TYR
         RQLn1MNiSOo+nhoh77WBiimfmOBow8Fxl9Rkmkru5FnjC8utwW5movmd2SsWyV2VESTy
         WTV8mF1Don9Yj0S84L9SrxvYnq8awcZW+CdbqBc4CPpY3KvAFXBlfj9hF8q4VdKJKLSm
         AkMw==
X-Gm-Message-State: APjAAAUEaPf/WhYui4OXvY8lGm0aQq1hyrMiNmuo1UzktUT9CBjukPw+
        p4l60k7i2LX7RE5ZnU9IpgeI2dlGmgxaI21uu83z0g==
X-Google-Smtp-Source: APXvYqwAMj6EObdSsgO/Hs6YMVU6vXPQ6obpY2yFXjj/C9UE/aQOU2z0FBHoCHpJvotcSsaAXkMlxHKCAynbEd/+tCs=
X-Received: by 2002:a05:600c:217:: with SMTP id 23mr285633wmi.124.1582651048921;
 Tue, 25 Feb 2020 09:17:28 -0800 (PST)
MIME-Version: 1.0
References: <20200225060620.76486-1-arjunroy.kdev@gmail.com>
 <CANn89iLrOwvNSHOB2i_+gMmN29O6BpJrnd9RfNERDTayNf7qKA@mail.gmail.com>
 <CAOFY-A35RJOwg_4Vqc1SzeGb83OoWG-LE+dJb1maRPauaLLNwQ@mail.gmail.com> <CAOFY-A0DXFse8=Mm0fx6kxAvsFZ=AzT96_P+WT=ctSESBncNjA@mail.gmail.com>
In-Reply-To: <CAOFY-A0DXFse8=Mm0fx6kxAvsFZ=AzT96_P+WT=ctSESBncNjA@mail.gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Tue, 25 Feb 2020 12:16:52 -0500
Message-ID: <CACSApvac8dxyec08Ac1dpD+TERWp6h94o+8Xg5mW6QLe3mUYNg@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp-zerocopy: Update returned getsockopt() optlen.
To:     Arjun Roy <arjunroy@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 12:04 PM Arjun Roy <arjunroy@google.com> wrote:
>
> On Tue, Feb 25, 2020 at 8:48 AM Arjun Roy <arjunroy@google.com> wrote:
> >
> > On Mon, Feb 24, 2020 at 10:28 PM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Mon, Feb 24, 2020 at 10:06 PM Arjun Roy <arjunroy.kdev@gmail.com> wrote:
> > > >
> > > > From: Arjun Roy <arjunroy@google.com>
> > > >
> > > > TCP receive zerocopy currently does not update the returned optlen for
> > > > getsockopt(). Thus, userspace cannot properly determine if all the
> > > > fields are set in the passed-in struct. This patch sets the optlen
> > > > before return, in keeping with the expected operation of getsockopt().
> > > >
> > > > Signed-off-by: Arjun Roy <arjunroy@google.com>
> > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > > Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > Fixes: c8856c051454 ("tcp-zerocopy: Return inq along with tcp receive
> > > > zerocopy")
> > >
> > >
> > > OK, please note for next time :
> > >
> > > Fixes: tag should not wrap : It should be a single line.
> > > Preferably it should be the first tag (before your Sob)
> > >
> > > Add v2 as in [PATCH v2 net-next]  :  so that reviewers can easily see
> > > which version is the more recent one.
> > >
> > >
> > > >
> > > > +               if (!err) {
> > > > +                       if (put_user(len, optlen))
> > > > +                               return -EFAULT;
> > >
> > > Sorry for not asking this before during our internal review :
> > >
> > > Is the cost of the extra STAC / CLAC (on x86) being high enough that it is worth
> > > trying to call put_user() only if user provided a different length ?
> >
> > I'll have to defer to someone with more understanding of the overheads
> > involved in this case.
> >
>
> Actually, now that I think about it, the (hopefully) common case is
> indeed that the kernel and userspace agree on the size of the struct,
> so I think just having just that one extra branch to check before
> issuing a put_user() would be well worth it compared to all the
> instructions in put_user(). I'll send a v2 patch with the change.

Thank you, Arjun.  Given that most TCP socket options overwrite the
optlen even when returning error, I think we can avoid having the
extra branch by simply moving put_user right after the check for "len
== sizeof(zc)" and before "switch(len)".

Thanks,
Soheil

> Thanks,
> -Arjun
>
> > -Arjun
