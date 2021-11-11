Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AF644DD31
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 22:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbhKKVlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 16:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbhKKVlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 16:41:39 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DC2C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 13:38:49 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id l8so6656767qtk.6
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 13:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PxwVJThHJAypRrQZRCH+RaU8Jxawa/0/CzC1MrNvdNk=;
        b=Rhk8DulPQRbyf7GUFOo5B9sFqsH2/6LF8kqn5/6pVAnkZEVCNOiCifQxSFL420V9d6
         P0eyAsQkOdFTX/ThIvldfdZNDJsoM6onhZ3IzqvrxU6gG7O8UomC/0PHLBWAAD0OxuQA
         2OaPfh/waUEd4clUk+N1fjJcIDVx1pUXR2FpB+Z5XNNUUuNknOfDKTQsCj0eZDFN3Xud
         bSGS01cXX55hQA9MFITidHXS4LY0mwp9qjG5f2qukcCDaB5i97GAlIBEIDJzSIxp3fl0
         VhiGvR865sreCTMf8zu4YCu7nNl1jCXcnbpmZposaoJ7J823wHBGr6w+9Y8vx9IShH1p
         swjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PxwVJThHJAypRrQZRCH+RaU8Jxawa/0/CzC1MrNvdNk=;
        b=JUVZk6vPdgb4jY9q5Y6CBZIVhVdbqOBv3QQ1mmUjg8zt1HNPpB+HM/YWT3ano2KTXL
         QPJH5SHfaAAE8cXT9AdyohqSaSJ3mQRQALl2KDz7z+3XJsEsFxSJ4U0ovbFV8t6IEVmi
         X02N7exfX7DXjt/oatsYbvxxRinyKtCd3UNNixnp//Wc17IW2K/vIwX0yehIB9QtYolC
         apIaF5GPbQtxvZufKLzAjItJaKkqQpIdMOaZ+n/D5USreDAqUkXPfpb7CGfyajO/kze4
         mLC7JlUqj0oKaIUBwLc1dd6uA8qcrNaY+91GcJB2Zv1YlvgbjbvKZ9GMUBalWNll4R8D
         G4iQ==
X-Gm-Message-State: AOAM533qq63TGY/HGS8S+731hpdVx5eKklvMMijygYFCjAz7ZcHAbFvL
        PUwbvpeHiQ5o4r0c4EaP076JbRzSugTRa6SR3pROyg==
X-Google-Smtp-Source: ABdhPJwACpFQXm9HUxlPtmIeP8qujbApF90FdRPuTR6VDMKH/kRrX953/Q3bW2Z3t+ISQDvCyRWNepBwq8M3F3IMRjw=
X-Received: by 2002:a05:622a:4cd:: with SMTP id q13mr11021449qtx.180.1636666728606;
 Thu, 11 Nov 2021 13:38:48 -0800 (PST)
MIME-Version: 1.0
References: <20211110192324.920934-1-sdf@google.com> <CAEf4BzYbvKjOmvgWvNWSK6ra0X5mM_=igi8DVwdojtZodz5pbQ@mail.gmail.com>
 <CACdoK4JzQ2_v+TtLY=61rkv4VPYHBQRgjW-ikMi6KSiBjK7CBg@mail.gmail.com>
In-Reply-To: <CACdoK4JzQ2_v+TtLY=61rkv4VPYHBQRgjW-ikMi6KSiBjK7CBg@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 11 Nov 2021 13:38:37 -0800
Message-ID: <CAKH8qBs_4Wk7xM7e__y6FCxZSM8nmqpWXwrpYfxE7Cj5PbPSfA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpftool: enable libbpf's strict mode by default
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 1:07 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On Thu, 11 Nov 2021 at 18:19, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Nov 10, 2021 at 11:23 AM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > Otherwise, attaching with bpftool doesn't work with strict section names.
> > >
> > > Also:
> > >
> > > - add --legacy option to switch back to pre-1.0 behavior
> > > - print a warning when program fails to load in strict mode to point
> > >   to --legacy flag
> > > - by default, don't append / to the section name; in strict
> > >   mode it's relevant only for a small subset of prog types
> > >
> >
> > LGTM. I'll wait for Quenting's ack before applying. Thanks!
>
> Looks good as well, thanks Stanislav!
>
> Reviewed-by: Quentin Monnet <quentin@isovalent.com>
>
> I wonder if we should display some indication ("libbpf_strict"?) in
> the output of "bpftool version", alongside "libbfd" and "skeleton"?
> It's not strictly a feature (and would always be present for newer
> versions), but it could help to check how a bpftool binary will
> behave? (I don't mind taking it as a follow-up.)

Sure, makes sense, I can follow up on that.
