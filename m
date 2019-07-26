Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C28576193
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 11:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbfGZJMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 05:12:06 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52435 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfGZJMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 05:12:06 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so47336619wms.2;
        Fri, 26 Jul 2019 02:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QpKHz7BEf0ponRedCEEQd2p3m3pUpnfbiOwDT9snicg=;
        b=OdwtKJaypZpMrqguCkOLsHvKhXNkBTLszh0oVYuJRB9yAOkWDPfFk6XIoLZNY2BPqv
         oVLzApkS1z4Hr4g/0Liy45YpxXK9qBr1FC3cqRN745Lvywu7Ofdsu7BK9ir9l2rmRz9a
         svDxVkvZu6QOEjihoaIXVS9J2UG2ChPwedV9U/nilrUiARSwz1/H7GTzp6K7w2gmkxgE
         tv1hQGu+7OJdq/s6zcdmltv9Iw/0jOei3QIHcRcGpNW7xVy1LTX9l+QNdTbdT0wOgeaY
         3dgnzdXqgjavFZ4coBznSEhPt+RQxqnspnx3UgX+Xg8R5RB8Lg7q539dp+IatMg/s+Z+
         C6Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QpKHz7BEf0ponRedCEEQd2p3m3pUpnfbiOwDT9snicg=;
        b=iqFD/82gG+P5zUCap9HcJrHKI9TnVDdkEa48Y5ok5xJEvIRQqQdyS8tc6LzgLH94IU
         cqkCozUKaReYOBviLUy6euwb1rigFx20qGlNwJsfAKngM5HUa5J/VATN1geIXfwI/xQT
         kpFtDqUEgpMF+WBd75L94LygNZX7pbcEmemQMl24WD56eZm6tRHrW0isjRJEWaejWGni
         IOwyt/dDUBMmhbupu7DtLUesaxOeCDEwmLMNiYL2ns3NGBSLIgTAciRtk7GUBeVO9hXf
         awvtJEK+2DLDi1x47RMMlQSueg0qau8AuvQE7r3BVZOUCdW5+sNREx12PS+lAvJj25cV
         bdVQ==
X-Gm-Message-State: APjAAAVgmS//Gu0sIscjqeqJ8BRUpav6N9dRN1p6XGQIlQJOsSYcaAy5
        bWvD9vQ9mJJ86dcO6xvR+BWWzYdVupmAq+KJsts=
X-Google-Smtp-Source: APXvYqzkc4w6MFxghPLmJZu3La0cLH8z0tVkVplHGistH3GlQFVQb0yQfHNy0IdXFIllTYJ9yKt1KXkTETZAO1vWClg=
X-Received: by 2002:a1c:a6c8:: with SMTP id p191mr79677418wme.99.1564132322712;
 Fri, 26 Jul 2019 02:12:02 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1563817029.git.lucien.xin@gmail.com> <c875aa0a5b2965636dc3da83398856627310b280.1563817029.git.lucien.xin@gmail.com>
 <20190723152449.GB8419@localhost.localdomain> <CADvbK_eiS26aMZcPrj2oNvZh_42phWiY71M7=UNvjEeB-B9bDQ@mail.gmail.com>
 <20190724112235.GA7212@hmswarspite.think-freely.org> <20190724123650.GD6204@localhost.localdomain>
 <20190724124907.GA8640@localhost.localdomain> <20190724184456.GC7212@hmswarspite.think-freely.org>
 <20190724190543.GH6204@localhost.localdomain> <20190724191243.GA4063@localhost.localdomain>
 <20190724204332.GF7212@hmswarspite.think-freely.org>
In-Reply-To: <20190724204332.GF7212@hmswarspite.think-freely.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 26 Jul 2019 17:11:50 +0800
Message-ID: <CADvbK_c6+BYzgXJGM069TF1AnA476swEJ60LQZiF5SQAKUN6GQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] sctp: check addr_size with sa_family_t size
 in __sctp_setsockopt_connectx
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, davem <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 4:44 AM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Wed, Jul 24, 2019 at 04:12:43PM -0300, Marcelo Ricardo Leitner wrote:
> > On Wed, Jul 24, 2019 at 04:05:43PM -0300, Marcelo Ricardo Leitner wrote:
> > > On Wed, Jul 24, 2019 at 02:44:56PM -0400, Neil Horman wrote:
> > > > On Wed, Jul 24, 2019 at 09:49:07AM -0300, Marcelo Ricardo Leitner wrote:
> > > > > On Wed, Jul 24, 2019 at 09:36:50AM -0300, Marcelo Ricardo Leitner wrote:
> > > > > > On Wed, Jul 24, 2019 at 07:22:35AM -0400, Neil Horman wrote:
> > > > > > > On Wed, Jul 24, 2019 at 03:21:12PM +0800, Xin Long wrote:
> > > > > > > > On Tue, Jul 23, 2019 at 11:25 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> > > > > > > > >
> > > > > > > > > On Tue, Jul 23, 2019 at 01:37:57AM +0800, Xin Long wrote:
> > > > > > > > > > Now __sctp_connect() is called by __sctp_setsockopt_connectx() and
> > > > > > > > > > sctp_inet_connect(), the latter has done addr_size check with size
> > > > > > > > > > of sa_family_t.
> > > > > > > > > >
> > > > > > > > > > In the next patch to clean up __sctp_connect(), we will remove
> > > > > > > > > > addr_size check with size of sa_family_t from __sctp_connect()
> > > > > > > > > > for the 1st address.
> > > > > > > > > >
> > > > > > > > > > So before doing that, __sctp_setsockopt_connectx() should do
> > > > > > > > > > this check first, as sctp_inet_connect() does.
> > > > > > > > > >
> > > > > > > > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > > > > > > > ---
> > > > > > > > > >  net/sctp/socket.c | 2 +-
> > > > > > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > > > > >
> > > > > > > > > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > > > > > > > > index aa80cda..5f92e4a 100644
> > > > > > > > > > --- a/net/sctp/socket.c
> > > > > > > > > > +++ b/net/sctp/socket.c
> > > > > > > > > > @@ -1311,7 +1311,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
> > > > > > > > > >       pr_debug("%s: sk:%p addrs:%p addrs_size:%d\n",
> > > > > > > > > >                __func__, sk, addrs, addrs_size);
> > > > > > > > > >
> > > > > > > > > > -     if (unlikely(addrs_size <= 0))
> > > > > > > > > > +     if (unlikely(addrs_size < sizeof(sa_family_t)))
> > > > > > > > > I don't think this is what you want to check for here.  sa_family_t is
> > > > > > > > > an unsigned short, and addrs_size is the number of bytes in the addrs
> > > > > > > > > array.  The addrs array should be at least the size of one struct
> > > > > > > > > sockaddr (16 bytes iirc), and, if larger, should be a multiple of
> > > > > > > > > sizeof(struct sockaddr)
> > > > > > > > sizeof(struct sockaddr) is not the right value to check either.
> > > > > > > >
> > > > > > > > The proper check will be done later in __sctp_connect():
> > > > > > > >
> > > > > > > >         af = sctp_get_af_specific(daddr->sa.sa_family);
> > > > > > > >         if (!af || af->sockaddr_len > addrs_size)
> > > > > > > >                 return -EINVAL;
> > > > > > > >
> > > > > > > > So the check 'addrs_size < sizeof(sa_family_t)' in this patch is
> > > > > > > > just to make sure daddr->sa.sa_family is accessible. the same
> > > > > > > > check is also done in sctp_inet_connect().
> > > > > > > >
> > > > > > > That doesn't make much sense, if the proper check is done in __sctp_connect with
> > > > > > > the size of the families sockaddr_len, then we don't need this check at all, we
> > > > > > > can just let memdup_user take the fault on copy_to_user and return -EFAULT.  If
> > > > > > > we get that from memdup_user, we know its not accessible, and can bail out.
> > > > > > >
> > > > > > > About the only thing we need to check for here is that addr_len isn't some
> > > > > > > absurdly high value (i.e. a negative value), so that we avoid trying to kmalloc
> > > > > > > upwards of 2G in memdup_user.  Your change does that just fine, but its no
> > > > > > > better or worse than checking for <=0
> > > > > >
> > > > > > One can argue that such check against absurdly high values is random
> > > > > > and not effective, as 2G can be somewhat reasonable on 8GB systems but
> > > > > > certainly isn't on 512MB ones. On that, kmemdup_user() will also fail
> > > > > > gracefully as it uses GFP_USER and __GFP_NOWARN.
> > > > > >
> > > > > > The original check is more for protecting for sane usage of the
> > > > > > variable, which is an int, and a negative value is questionable. We
> > > > > > could cast, yes, but.. was that really the intent of the application?
> > > > > > Probably not.
> > > > >
> > > > > Though that said, I'm okay with the new check here: a quick sanity
> > > > > check that can avoid expensive calls to kmalloc(), while more refined
> > > > > check is done later on.
> > > > >
> > > > I agree a sanity check makes sense, just to avoid allocating a huge value
> > > > (even 2G is absurd on many systems), however, I'm not super comfortable with
> > > > checking for the value being less than 16 (sizeof(sa_family_t)).  The zero check
> > >
> > > 16 bits you mean then, per
> > > include/uapi/linux/socket.h
> > > typedef unsigned short __kernel_sa_family_t;
> > > include/linux/socket.h
> > > typedef __kernel_sa_family_t    sa_family_t;
> > >
> > > > is fairly obvious given the signed nature of the lengh field, this check makes
> > > > me wonder what exactly we are checking for.
> > >
> > > A minimum viable buffer without doing more extensive tests. Beyond
> > > sa_family, we need to parse sa_family and then that's left for later.
> > > Perhaps a comment helps, something like
> > >     /* Check if we have at least the family type in there */
> > > ?
> >
> > Hm, then this could be
> > -     if (unlikely(addrs_size <= 0))
> > +     if (unlikely(addrs_size < sizeof(struct sockaddr_in)))
> > (ipv4)
> > As it can't be smaller than that, always.
> >
> True, but I think perhaps just the family type size check is more correct, as
> thats the minimal information we need to get the proper sockaddr_len out of
> sctp_get_af_specific.
Okay, I will keep the check "addrs_size < sizeof(sa_family_t)" in this
patch and remove the useless variables in patch 2/4 when sending v2.

Thanks.

>
> Neil
>
> > >
> > >   Marcelo
> > >
> > > >
> > > > Neil
> > > >
> > > > > >
> > > > > > >
> > > > > > > Neil
> > > > > > >
> > > > > > > > >
> > > > > > > > > Neil
> > > > > > > > >
> > > > > > > > > >               return -EINVAL;
> > > > > > > > > >
> > > > > > > > > >       kaddrs = memdup_user(addrs, addrs_size);
> > > > > > > > > > --
> > > > > > > > > > 2.1.0
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > >
> > > > >
> > >
> >
