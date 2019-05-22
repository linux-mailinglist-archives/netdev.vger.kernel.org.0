Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 414FF25BD4
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 04:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbfEVB77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 21:59:59 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33604 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfEVB77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 21:59:59 -0400
Received: by mail-qk1-f196.google.com with SMTP id p18so534697qkk.0
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 18:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dHZZ6RAQNWBNs9T3V3H/VBDcHcHicFdtwaSrNqnH0Uo=;
        b=GaZEBVb9Yamu+97wBxSz1bAwDhunSSgI+EAKA+opF3MNdiaw5jNvmQMvVxx5m48Egt
         CuABuTwNBNW3THzj1PO2HNrfGxjBGgQVgefcEjYvAOqhlmGJWR/3tUQMBk31AM8R4J+g
         R8UspKlOy+VwSJiDO2Eq0ZmBFjJb3DW8XNOGSvFVrB0cwpLZ5bSUGvYFRqu8pjjOR4KM
         7Z6vUoYhmC58PagajuLstbSrsFjq1b4KNFqqNiI0aVx8gM/s68vX1RHAnjO5JUWo2P0b
         o9fDv7xLuOWpnjKeGr6Qksvie3c0gT7UsRqFhFOv/qtRmIqg0bZW/KUtJnWCaXeOOTnx
         BTuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dHZZ6RAQNWBNs9T3V3H/VBDcHcHicFdtwaSrNqnH0Uo=;
        b=Nm7ysLEfil/TV96aKEeNgn14rGgjB9bY9TR2rmX5YI5/ru0uuXMX/6S1ZLSG/A6GUr
         6vULllyQ3+7qOt/L26+HABYuP0rqUP8NOKq7aZ2HPYnOUjil0cB+uLsJImeLsRdvbZEI
         8XpaJz+OltEgkE1V1xVSgN9zXCHHblaNACy++eSq4pkEnb/FC3Vk9F/Cou/oBrKvcCW/
         wbCKTEdpv9udm6vNlziq1P6qhxvVU12YTuPD0S6hgI0VY/ra75iDMsdEAndeapT3UxVv
         Zje/d8ZwWd/Yuwqiew2SfDN04wT14GuSc7sCkqXHaF22eGOU3jHzDnBhUqcssKCtTGjk
         ILuA==
X-Gm-Message-State: APjAAAXJ+1D6I7WERij2QyU5UzTgtQqPpaiHGsN1HXfNe4RNRwMBBC/z
        zimGLIrH2OFJp7n2bU3hmethLfh5rSpHumDOjHc=
X-Google-Smtp-Source: APXvYqwsgoDOxC808Luqsg6nGqXvmpgcQGnO/3jUXnS389adlBGniXaAnKskQ9IG5uyVhc/IEXmPHRffmbwqNQDBEwo=
X-Received: by 2002:a37:c401:: with SMTP id d1mr27476171qki.119.1558490398123;
 Tue, 21 May 2019 18:59:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190519090544.26971-1-luke.tw@gmail.com> <bf57f48d5318450b95746f9f91418153@AcuMS.aculab.com>
In-Reply-To: <bf57f48d5318450b95746f9f91418153@AcuMS.aculab.com>
From:   luke <luke.tw@gmail.com>
Date:   Wed, 22 May 2019 09:59:32 +0800
Message-ID: <CAGVycpbBAWUz2xCRG82ZH3EfmSR277kqgRfAznY+3Kq-iumf0Q@mail.gmail.com>
Subject: Re: [PATCH] samples: bpf: fix: change the buffer size for read()
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 11:05 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Chang-Hsien Tsai
> > @@ -678,7 +678,7 @@ void read_trace_pipe(void)
> >               static char buf[4096];
> >               ssize_t sz;
> >
> > -             sz = read(trace_fd, buf, sizeof(buf));
> > +             sz = read(trace_fd, buf, sizeof(buf)-1);
> >               if (sz > 0) {
> >                       buf[sz] = 0;
> >                       puts(buf);
>
> Why not change the puts() to fwrite(buf, sz, 1, stdout) ?
> Then you don't need the '\0' terminator.
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>

Yes.
But, this will be different with the original code.
puts(buf) prints buf and a terminating newline character.

--
Chang-Hsien Tsai
