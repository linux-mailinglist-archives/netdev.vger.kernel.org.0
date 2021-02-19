Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDC231F3CB
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 03:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhBSCE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 21:04:28 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:45828 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhBSCE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 21:04:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1613700221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lqC+ymbE1tWNnzxMhR6ovKmuDLm0GugnZMbOy3UPaZI=;
        b=Z6WUxOzUIXu6jxtSfTimoKlSP51CD4Z/ELCVaO/5xpmpl1xkmGyM4+yX+ezqBhYhZjTlWA
        542//xv73I3+6y9wbbRyuMm9d5epf9xVb06XFP4anigE6VM/fkJeJ1kJDOp3WtFyWjDZ6N
        D+o8R/A2MAqwb3F8byB8AJqnZycEHD8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 61f82f38 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Fri, 19 Feb 2021 02:03:41 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id b10so4154979ybn.3
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 18:03:41 -0800 (PST)
X-Gm-Message-State: AOAM531F9zUavfEacwKM1nslrZ5EdP+nsUxXioAsJEpP1sNaT0rqsFtp
        dUwbVXtt2ExXHjQB8A4dTUOFcxSB+BDLbE23avg=
X-Google-Smtp-Source: ABdhPJwSJwojHcR2RNUPvITmYGu9JW1rhKyjI9+4JZaQCTk+RSFPgwW+rf3AtAegA6n1lfyvr9BHM/L5KDpwfOFJozw=
X-Received: by 2002:a25:7693:: with SMTP id r141mr10101827ybc.49.1613700220907;
 Thu, 18 Feb 2021 18:03:40 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9oyv+nWk2r3mcVrfdXW_aiex67nSvGiiqLmPOv=RHnhfQ@mail.gmail.com>
 <20210218203404.2429186-1-Jason@zx2c4.com> <CAF=yD-K-8Gacsnch-1nTh11QFaXkfCj4TTj=Or6PF+6PyhbKiQ@mail.gmail.com>
In-Reply-To: <CAF=yD-K-8Gacsnch-1nTh11QFaXkfCj4TTj=Or6PF+6PyhbKiQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 19 Feb 2021 03:03:30 +0100
X-Gmail-Original-Message-ID: <CAHmME9r11eViwmghiuQsBf9k04gnWvNg8k8UPG2W4OJU3-TMnA@mail.gmail.com>
Message-ID: <CAHmME9r11eViwmghiuQsBf9k04gnWvNg8k8UPG2W4OJU3-TMnA@mail.gmail.com>
Subject: Re: [PATCH net v3] net: icmp: pass zeroed opts from
 icmp{,v6}_ndo_send before sending
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        SinYu <liuxyon@gmail.com>, Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 11:06 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Feb 18, 2021 at 3:39 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > The icmp{,v6}_send functions make all sorts of use of skb->cb, casting
>
> Again, if respinning, please briefly describe the specific buggy code
> path. I think it's informative and cannot be gleaned from the fix.

Ack.

> > -               send(skb, type, code, info, NULL);
> > +               send(skb, type, code, info, NULL, IP6CB(skb));
>
> This should be parm.

Nice catch, thanks.

v4 coming up.
