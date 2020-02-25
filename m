Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD61316EBB4
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 17:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731223AbgBYQsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 11:48:16 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36310 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731178AbgBYQsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 11:48:16 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so3878668wma.1
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 08:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fhCoi3wByJNtIYXPoFi3eu7Go9LSXR7h5YmMk+YRais=;
        b=IYidIy2sRQClcJLV0FE9hwGr2ai486FAEYH8BSXzcu1pKl0aRVFhHrDKap4Iyo1k/k
         psiV1ZKfYPxJkAJaqfBpJf+7vRh9OFIy7uf4+Ilt5nV1wXcYhdBrgaoL7KP2au9ba9CP
         ASBp1W4+k6tNP8Ky6C8+A0bgjKItYxHxd93zwarFnC8dcnJ9oNT0HL8XtQx1sDJWOAJh
         dBSgR1615mppkkuiUgduRkXTPlyFfv7z6uOZ3JRwfjKW4KIzbiZdRjuqVYelK2mM2mCe
         hmvNcAwMh2cLQ9HLwcp+aFw2iXHPzg9sDa50EN0+1rT05dxDRQHabNAgasogKiOw94Af
         19sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fhCoi3wByJNtIYXPoFi3eu7Go9LSXR7h5YmMk+YRais=;
        b=lvfV+jW0BnDQ8oQfmenrg2pau45DwArCvcQLHSPE253Pm+Sa3YFzaXf504mdANii+E
         4Gbl+sWbOV975VAh1HMWJDexnGatdZGglqhrzMLpGugV6z6+tgTjTYk4/2811as7mFJn
         2xTq1CD2rr6eVe4TzAL7FaF43dzM15ZNJfxv66+rPCofHqCKe29ET6ejnIkZgeRKNp+Y
         0iWX8+sUsvZ4kE94YXZtjPMXqb1FX70urKWUqqAyzk4U7StWHM0qgmWx4CNmpR3Ed1re
         YlHz6V569xbuSTG4OAHwruj1p4CDndfZfbsat0PR3YY6KUIF86knZeTsd8mTydm/WWBT
         sMqA==
X-Gm-Message-State: APjAAAXQTo7+f4As26FiFUmKBN+hjVYS+QAxhwkcGIXp11Rx06CJLmgJ
        9uc3KZd6Deej+tZtxiT3LNppW2TXoILes/C4g4NNqw==
X-Google-Smtp-Source: APXvYqzdwyw91+snSHmBhBCl4K3dJNCCgzSAQSTZ7dJHXi/KeufD1wrMMdXi5DM9d6CO+MOHDUN2fogxRStCYVLKoTk=
X-Received: by 2002:a7b:cd92:: with SMTP id y18mr138269wmj.133.1582649293849;
 Tue, 25 Feb 2020 08:48:13 -0800 (PST)
MIME-Version: 1.0
References: <20200225060620.76486-1-arjunroy.kdev@gmail.com> <CANn89iLrOwvNSHOB2i_+gMmN29O6BpJrnd9RfNERDTayNf7qKA@mail.gmail.com>
In-Reply-To: <CANn89iLrOwvNSHOB2i_+gMmN29O6BpJrnd9RfNERDTayNf7qKA@mail.gmail.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Tue, 25 Feb 2020 08:48:02 -0800
Message-ID: <CAOFY-A35RJOwg_4Vqc1SzeGb83OoWG-LE+dJb1maRPauaLLNwQ@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp-zerocopy: Update returned getsockopt() optlen.
To:     Eric Dumazet <edumazet@google.com>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 10:28 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Feb 24, 2020 at 10:06 PM Arjun Roy <arjunroy.kdev@gmail.com> wrote:
> >
> > From: Arjun Roy <arjunroy@google.com>
> >
> > TCP receive zerocopy currently does not update the returned optlen for
> > getsockopt(). Thus, userspace cannot properly determine if all the
> > fields are set in the passed-in struct. This patch sets the optlen
> > before return, in keeping with the expected operation of getsockopt().
> >
> > Signed-off-by: Arjun Roy <arjunroy@google.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > Fixes: c8856c051454 ("tcp-zerocopy: Return inq along with tcp receive
> > zerocopy")
>
>
> OK, please note for next time :
>
> Fixes: tag should not wrap : It should be a single line.
> Preferably it should be the first tag (before your Sob)
>
> Add v2 as in [PATCH v2 net-next]  :  so that reviewers can easily see
> which version is the more recent one.
>
>
> >
> > +               if (!err) {
> > +                       if (put_user(len, optlen))
> > +                               return -EFAULT;
>
> Sorry for not asking this before during our internal review :
>
> Is the cost of the extra STAC / CLAC (on x86) being high enough that it is worth
> trying to call put_user() only if user provided a different length ?

I'll have to defer to someone with more understanding of the overheads
involved in this case.

-Arjun
