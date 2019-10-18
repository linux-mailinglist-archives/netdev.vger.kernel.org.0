Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F7CDCEB5
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 20:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439762AbfJRSul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 14:50:41 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38540 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730816AbfJRSul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 14:50:41 -0400
Received: by mail-ot1-f65.google.com with SMTP id e11so5827174otl.5
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 11:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7EnrByqqmIEOE49ABywAAVgG26tp5mIBrzx9j+J3oos=;
        b=u0UUcQvpz+1gbP+h4cldoESnznhOX0XqEqXtrcUKWnyuaM+2dg4F/retf8PVcJg1PQ
         DrBELOX855otVJzL7wbThV05XeXJWbdEB6T1f6r/Ne4TRKPzzZsgijxKaKRmyQPyjIkQ
         iry7kcvdl5NHFM+yUcQZIljHRQxO8+eS8Nqwmuvv+NLue2T9pVq0N/NvKwiX/ldELeUi
         sdoM3+KtsnGzdi+broftz4GwymOj4wMaFU3aaAQamK24+eo6mF3tmnk8AtntnbLzF5+V
         /BmfWgCc2BLw9nN+No5hOy6VsI2nt40HdouCXrGRLRdXwAPh1Gk3Yi+/gowZYbsdhfa6
         SIlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7EnrByqqmIEOE49ABywAAVgG26tp5mIBrzx9j+J3oos=;
        b=YE8F4TPscLJxAh5ryffnQ+gWIOWQS3XGKiGj6qZ6wx7laR1uuB13Dgx3eTjM7PuPPT
         AbJoCsq1IC0LTUAHkovEZcDclWoU1PiLUakX+Op9v0brtPa3MEWD6ouMR4mficEG2W2E
         7746SbiSBYKuW3Pf9KNRrCAl1hLlTZ2blMC7vwQU3H7eJ72a0zV1dU/Rspwh0BbQgXLw
         EZnTmcFqFWsBy7TiN87V+7PuFvSxDf/5qWnaV62G+AW7m29P+qbgrY6LWOauePNRQd0Q
         YsZhtfWZsx01FS0ZlErUMKf+dTGyRi+847fyeDGW2eYlGGO2BVfb2eFm8HyflVxTnbTt
         4dgw==
X-Gm-Message-State: APjAAAWEXAJ5Ev5fjpTvHOvZYwieHbGhldaAi9eG6XK6DiZyq8D6e4UE
        tYTRp16FDJYbelf2URbYwJm25ZOhn3yfJ1QcRc9dQg==
X-Google-Smtp-Source: APXvYqxxb9IdW237LWetjO5OJn473qUaKFx1pSxkH15+mKxJDSS5qABWBzt0RrNFmzsyyQ1uuySl6R50BT7+O3n7uvk=
X-Received: by 2002:a9d:19ee:: with SMTP id k101mr9069469otk.183.1571424639674;
 Fri, 18 Oct 2019 11:50:39 -0700 (PDT)
MIME-Version: 1.0
References: <20191017212858.13230-1-axboe@kernel.dk> <20191017212858.13230-2-axboe@kernel.dk>
 <CAG48ez0G2y0JS9=S2KmePO3xq-5DuzgovrLFiX4TJL-G897LCA@mail.gmail.com>
 <0fb9d9a0-6251-c4bd-71b0-6e34c6a1aab8@kernel.dk> <CAG48ez181=JoYudXee0KbU0vDZ=EbxmgB7q0mmjaA0gyp6MFBQ@mail.gmail.com>
 <a54329d5-a128-3ccd-7a12-f6cadaa20dbf@kernel.dk> <CAG48ez1SDQNHjgFku4ft4qw9hdv1g6-sf7-dxuU_tJSx+ofV-w@mail.gmail.com>
 <dbcf874d-8484-9c27-157a-c2752181acb5@kernel.dk> <CAG48ez3KwaQ3DVH1VoWxFWTG2ZfCQ6M0oyv5vZqkLgY0QDEdiw@mail.gmail.com>
 <a8fb7a1f-69c7-bf2a-b3dd-7886077d234b@kernel.dk> <572f40fb-201c-99ce-b3f5-05ff9369b895@kernel.dk>
 <CAG48ez12pteHyZasU8Smup-0Mn3BWNMCVjybd1jvXsPrJ7OmYg@mail.gmail.com>
 <20b44cc0-87b1-7bf8-d20e-f6131da9d130@kernel.dk> <2d208fc8-7c24-bca5-3d4a-796a5a8267eb@kernel.dk>
 <CAG48ez2ZQBVEe8yYRwWX2=TMYWsJ=tK44NM+wqiLW2AmfYEcHw@mail.gmail.com> <0a3de9b2-3d3a-07b5-0e1c-515f610fbf75@kernel.dk>
In-Reply-To: <0a3de9b2-3d3a-07b5-0e1c-515f610fbf75@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 18 Oct 2019 20:50:12 +0200
Message-ID: <CAG48ez1akvnVpK3dMH4H=C2CsNGDZkDaxZEF2stGAPCnUcaa+g@mail.gmail.com>
Subject: Re: [PATCH 1/3] io_uring: add support for async work inheriting files table
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 8:16 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 10/18/19 12:06 PM, Jann Horn wrote:
> > But actually, by the way: Is this whole files_struct thing creating a
> > reference loop? The files_struct has a reference to the uring file,
> > and the uring file has ACCEPT work that has a reference to the
> > files_struct. If the task gets killed and the accept work blocks, the
> > entire files_struct will stay alive, right?
>
> Yes, for the lifetime of the request, it does create a loop. So if the
> application goes away, I think you're right, the files_struct will stay.
> And so will the io_uring, for that matter, as we depend on the closing
> of the files to do the final reap.
>
> Hmm, not sure how best to handle that, to be honest. We need some way to
> break the loop, if the request never finishes.

A wacky and dubious approach would be to, instead of taking a
reference to the files_struct, abuse f_op->flush() to synchronously
flush out pending requests with references to the files_struct... But
it's probably a bad idea, given that in f_op->flush(), you can't
easily tell which files_struct the close is coming from. I suppose you
could keep a list of (fdtable, fd) pairs through which ACCEPT requests
have come in and then let f_op->flush() probe whether the file
pointers are gone from them...
