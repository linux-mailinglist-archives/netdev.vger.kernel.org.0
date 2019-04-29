Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF1CE3B8
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 15:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbfD2N13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 09:27:29 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34198 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfD2N13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 09:27:29 -0400
Received: by mail-ed1-f65.google.com with SMTP id a6so9153160edv.1
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 06:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=shYkIO9bAN3z3pFDjcybu/SSUaUrnVfOtbLRwTrvQE8=;
        b=uv7haMwiRUCb4gvNjdU/L+FKa303X6Uf7eOErDaG/LQbxGnIl7nueBk+BdiCRt9vRn
         t4sfsT/uTGyLhgGrppbgjXr8Co39bR/iK14bRWv5kFF1KtTqPeLe+P2Dx/RR8IUtfXZu
         wz2KTuz79bhA9EZcNs7IxLDclEQsQQj9VHLDSKd5+ToygVaAbOA/W07wrmiibjLywol0
         XQTwrjKvCEFS6cr2f93T5OIVDT5iQAwniwZgAxFQuO/Itn0PwiElji4i54BfIj8zCziR
         jGrSxSxbHxK+EiYm+ItsRsGMmh+6DXiu3Z/ogBhEcIdbsctsSGgWRN8349KizOxCXL5P
         3gmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=shYkIO9bAN3z3pFDjcybu/SSUaUrnVfOtbLRwTrvQE8=;
        b=dC1Dh5tBH5KaQ81HnOrDM32LZNQCCWfwW/rG6PnCtUwgnLaI6EadQKRmm7dPTzzbsx
         Wq7iTU8vzEwbbAhQHMy0TGRsEV/4cIXpomB52oAo8PXjzWuyR1Be+OJGRAIdQvZOrgwV
         01nKO8U0sGf9m6bvKCBbsDdzSbHZM91Z2KAQagJ5mti/I73tGmIgOLgYQDm61BQRKvgA
         frnED3HLTjT8QRu3HGENyxJCkQvDDWSBi23BmLAgCQCA2fDg1fCCOj7EnrBE8ahnwogc
         l2HA7dErYbbky+vMqGoj1BY26OaPsIMNO9w0GnqJ1KXtP6ZVTvbbDs5gjIhXxWRrDuAV
         FX7g==
X-Gm-Message-State: APjAAAX+I+LLHWvqQ4gSiltYAcfkOhFyZCQnpF2wpDKoTiJc7WkJHZoT
        XRN3UqStkHN5ocmkdnRTCtFb6r6cZdJQ70lVRoE=
X-Google-Smtp-Source: APXvYqxLhMQsHMI32p4fTGdGMv/lv7BvpbdY7g2wuucf2ZYQneumDcshw63MTBOKkZHf3ajRjQkj9Bo3j/2ksBXYxik=
X-Received: by 2002:a17:906:580e:: with SMTP id m14mr189192ejq.287.1556544441759;
 Mon, 29 Apr 2019 06:27:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190426192954.146301-1-willemdebruijn.kernel@gmail.com>
 <d57c87e402354163a7ed311d6d27aa4f@AcuMS.aculab.com> <CAF=yD-+omQXQO7ue=BkwjVahAFP6YuU5AMTKbC9fBG6qPu6rSw@mail.gmail.com>
 <e559e87385254ad1a0fdc5f36bdde44a@AcuMS.aculab.com>
In-Reply-To: <e559e87385254ad1a0fdc5f36bdde44a@AcuMS.aculab.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 29 Apr 2019 09:26:45 -0400
Message-ID: <CAF=yD-Ji+=AJPCscPdy0wdt1YMr3scwm0skx2V=jk7U6QtRQYw@mail.gmail.com>
Subject: Re: [PATCH net] packet: in recvmsg msg_name return at least sockaddr_ll
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 9:19 AM David Laight <David.Laight@aculab.com> wrote:
>
> > Can then also change memset to zero only two bytes in the Ethernet case.
> >
> > +                       if (msg->msg_namelen < sizeof(struct sockaddr_ll)) {
> > +                               msg->msg_namelen = sizeof(struct sockaddr_ll);
> > +                               memset(msg->msg_name + copy_len, 0,
> > +                                      msg->namelen - copy_len);
>
> copy_len not defined ....

Was a quick sketch of an iteration on the above, sorry if unclear.
Intended to be defined before the branch.

>
> > +                       }
>
> Except that has to be a real memset() not an inlined direct
> write of an 8byte register (or 2 writes on a 32bit systems).

I wasn't sure whether a 2 byte store would be optimized in a similar
manner. That might even be architecture dependent, I imagine? Will
leave as is.

Thanks for the quick response!



>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
