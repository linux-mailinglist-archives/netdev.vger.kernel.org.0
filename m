Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87B5233A61
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 23:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730571AbgG3VPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 17:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730292AbgG3VO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 17:14:59 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A69C061756;
        Thu, 30 Jul 2020 14:14:59 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id u43so1910666ybi.11;
        Thu, 30 Jul 2020 14:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jlenySqGYjDqfgNiiv2qRJyOq42o/NrQ/u5+/K+NrKg=;
        b=fq58dfN8BGW9HrLIbH+z7cjupbPKELa5W/5uvXWsZxzTkpNtP0OdjOlCIkcZp7p1OF
         /onazCOtFM6MHQ6BB3EGysRQW9Hc352+mt5Kz7cCs/Ml+1J/hS2jPiGkxD5jsqzy+lVr
         O8IkPC7ypUt1MyI2MQ7XRDBQHnA/dmc/tbrazzCZcfGgJLgYzSDvD0RMz9MWQSokFmyL
         xHV0uC7scCbqkDYTZTxG7xsAMNVMzdTL3cBtNVJpRakuQuv71ffwqIaWGNeieaQ0cZZq
         /FX6W2dyQkQGp9uJfG/5CvJzxO2hys2LmZR4UQgUJehTBdJhU9LI9ntjYYYqoVoBLvpP
         YnFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jlenySqGYjDqfgNiiv2qRJyOq42o/NrQ/u5+/K+NrKg=;
        b=VL9HZhSr40wQ8CH9CjbVTadyWDKIZ9j8oQJHFKmP6wGbO9F/Jf/zyaYNAGrWZ6x9iI
         MpzAvLBniXpZ6/J3Cjp6CagDEAD3bbfWX19x3bAfRcbkfeP6jfyaPK3sJRw5InbSqFQj
         lTqScXCcCqqJBVSil9CT4wPzAOYiJUH+Wi9VQEWdNCsQl1J4EPQ/xw1EqPEyb/rzHuHg
         tC90T5qZVaHIyifgJPOrc3dxZmtT1+XN5xoS02aLHJLbhmp3U4Yz7fwYstoTWtHbZNie
         JJXjZW3M292M9ZwuD1c5rB21zg5kmPUdNQ+dYIQdjvqXj5dayJioYgwuY48yeueD4jiF
         Vmbw==
X-Gm-Message-State: AOAM531nf2qOuAOqN0KxFhlD2ulKA8mwdkUEpYJocCy76yQ29DxdR0Mk
        gML+0NohVkWkS3hJErm8DrxRH0BQ0lbVj2B0smU=
X-Google-Smtp-Source: ABdhPJzu5Z5nworiX7vwXwiT9YwDw1Hi2G0vXpvGyxCyUtoIZGycf0pZlnp742nZ/4P30oss75+Xq8sfZZeVRNk445s=
X-Received: by 2002:a25:ba0f:: with SMTP id t15mr1244225ybg.459.1596143698591;
 Thu, 30 Jul 2020 14:14:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200729230520.693207-1-andriin@fb.com> <20200729230520.693207-5-andriin@fb.com>
 <A6F4E1BE-ECFD-4382-9C67-5345431DD90E@fb.com>
In-Reply-To: <A6F4E1BE-ECFD-4382-9C67-5345431DD90E@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 30 Jul 2020 14:14:46 -0700
Message-ID: <CAEf4BzbTtP8_EvOq7HPpXCi604Je82r88L8YusGr8LogoOfk4A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/5] tools/bpftool: add `link detach` subcommand
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 2:02 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jul 29, 2020, at 4:05 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Add ability to force-detach BPF link. Also add missing error message, if
> > specified link ID is wrong.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> With two nitpicks below.
>
> [...]
>
> > static int link_parse_fd(int *argc, char ***argv)
> > {
> > +     int fd;
> > +
> >       if (is_prefix(**argv, "id")) {
> >               unsigned int id;
> >               char *endptr;
> > @@ -35,7 +37,10 @@ static int link_parse_fd(int *argc, char ***argv)
> >               }
> >               NEXT_ARGP();
> >
> > -             return bpf_link_get_fd_by_id(id);
> > +             fd = bpf_link_get_fd_by_id(id);
> > +             if (fd < 0)
> > +                     p_err("failed to get link with ID %d: %d", id, -errno);
>
> How about we print strerror(errno) to match the rest of link.c?

sure, will do, was lazy :)

>
> [...]
>
> > +static int do_detach(int argc, char **argv)
> > +{
> > +     int err, fd;
> > +
> > +     if (argc != 2)
> > +             return BAD_ARG();
> > +
> > +     fd = link_parse_fd(&argc, &argv);
> > +     if (fd < 0)
> > +             return 1;
> > +
> > +     err = bpf_link_detach(fd);
> > +     if (err)
> > +             err = -errno;
> > +     close(fd);
> > +     if (err) {
> > +             p_err("failed link detach: %d", err);
>
> And strerror(err) here.
>
>
