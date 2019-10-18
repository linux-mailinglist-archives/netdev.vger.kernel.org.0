Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 039A7DC79A
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 16:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410323AbfJROkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 10:40:45 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36879 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405743AbfJROkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 10:40:45 -0400
Received: by mail-oi1-f195.google.com with SMTP id i16so5411444oie.4
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 07:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mtLlVAPgNcP/pu360Q9fx5qOSTZTD6zW/EEPtvw7TMc=;
        b=VifYIvVOAu4VO7pp7AxwFN8dcaJx6cmHP4N/rx1dmjN0Cm4SAyeGkVz+MvEdozI0WY
         SyidyCckmbA0wuguVWwuR8hiofg6vyiuylZBgMnMHl2DRHS5GpOlzeWm8O06/Nopboao
         jLtPQIGhyZKWAzVT/Gk1KwgBFGVLcv4yCwZmA9E00vy9GPskRCvtrFLvklcGVAZ0obdH
         8/CvnRbkD7ABY42mUBPT0jpLkTTyMXM//WUBixGZC9DQa/LGRQnicV+IUY11zFITAW06
         v68MNDrQtGKfcsMUnWBKaE5cL3lAcM+hJVMxXEbS9Zp0AkDVV4OufGcymfJ5EwSf7E7k
         TSxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mtLlVAPgNcP/pu360Q9fx5qOSTZTD6zW/EEPtvw7TMc=;
        b=Gf/rZkK3XhWUKvD2Xo54EJLrO80RndztaLUmuT0kSNyZOUF/lZevG8mWzekgYYcyQv
         nYlJee6w54+OGWEvJC4Irl20p1GUFF8bvuHAoBhJzNL4zetIpYvbBUfiGcaDClwUuPUc
         JNEo88i4H1ZAyCtsAM6JfPxMuOIBaZJe2PSPt0RFiowpYBeznf8ousRqrnyh6l7wn2+t
         GDJnV97moWPAetGU1qsM5duNObm2YHL0aBGfRE+Y/+huH5i75Ey4UoS0M+7kMF3UoLHb
         IGpz7KXBZ89JmhrruoIWtho7sSHURv4wzwIQlU3PTIWo7YjOavQIAN3KRS4jJgZlSWrU
         ip1A==
X-Gm-Message-State: APjAAAXmfR4X9fznBle/7vXSpnhZWRxPNjNBLl0jxoWjgCPKSs5YAjRl
        hgAa7Zg7mOmB5Yn0cvVP2q+GAIoOmRzXD0Qg7SKxtg==
X-Google-Smtp-Source: APXvYqxBQKEqWjtAQPq9kbc+1AeiN6ubDEHEQhhKKfkXXGAYjALjDz/xZr5TwpJ1iSKrJ8ZrWJwvxhshF8yyf2iklSA=
X-Received: by 2002:aca:da41:: with SMTP id r62mr7974009oig.47.1571409643882;
 Fri, 18 Oct 2019 07:40:43 -0700 (PDT)
MIME-Version: 1.0
References: <20191017212858.13230-1-axboe@kernel.dk> <20191017212858.13230-2-axboe@kernel.dk>
 <CAG48ez0G2y0JS9=S2KmePO3xq-5DuzgovrLFiX4TJL-G897LCA@mail.gmail.com>
 <0fb9d9a0-6251-c4bd-71b0-6e34c6a1aab8@kernel.dk> <CAG48ez181=JoYudXee0KbU0vDZ=EbxmgB7q0mmjaA0gyp6MFBQ@mail.gmail.com>
 <a54329d5-a128-3ccd-7a12-f6cadaa20dbf@kernel.dk>
In-Reply-To: <a54329d5-a128-3ccd-7a12-f6cadaa20dbf@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 18 Oct 2019 16:40:17 +0200
Message-ID: <CAG48ez1SDQNHjgFku4ft4qw9hdv1g6-sf7-dxuU_tJSx+ofV-w@mail.gmail.com>
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

On Fri, Oct 18, 2019 at 4:37 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 10/18/19 8:34 AM, Jann Horn wrote:
> > On Fri, Oct 18, 2019 at 4:01 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 10/17/19 8:41 PM, Jann Horn wrote:
> >>> On Fri, Oct 18, 2019 at 4:01 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>>> This is in preparation for adding opcodes that need to modify files
> >>>> in a process file table, either adding new ones or closing old ones.
> > [...]
> >> Updated patch1:
> >>
> >> http://git.kernel.dk/cgit/linux-block/commit/?h=for-5.5/io_uring-test&id=df6caac708dae8ee9a74c9016e479b02ad78d436
> >
> > I don't understand what you're doing with old_files in there. In the
> > "s->files && !old_files" branch, "current->files = s->files" happens
> > without holding task_lock(), but current->files and s->files are also
> > the same already at that point anyway. And what's the intent behind
> > assigning stuff to old_files inside the loop? Isn't that going to
> > cause the workqueue to keep a modified current->files beyond the
> > runtime of the work?
>
> I simply forgot to remove the old block, it should only have this one:
>
> if (s->files && s->files != cur_files) {
>         task_lock(current);
>         current->files = s->files;
>         task_unlock(current);
>         if (cur_files)
>                 put_files_struct(cur_files);
>         cur_files = s->files;
> }

Don't you still need a put_files_struct() in the case where "s->files
== cur_files"?
