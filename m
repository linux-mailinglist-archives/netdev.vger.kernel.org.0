Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB291E2952
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388767AbgEZRrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgEZRrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 13:47:31 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76177C03E96D;
        Tue, 26 May 2020 10:47:30 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id c185so7392215qke.7;
        Tue, 26 May 2020 10:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=49i00jYU127vVVjkcUG3jGAuS2Gj6vFaNuDKHc8vb5g=;
        b=B2gkg/HtGsn9dNHu7BKpysSH4n5Jy6pfh3aI49UN3AmJLCj3dXuWb1vZK8uGHyYS0L
         edASTl1cllAuDouTKKrv5cZfp9nGLvtdkruy1oMQ6m5hzYLQ5iwoptS26wG4aBapfB0A
         Zuh6KOadh/7sCyfTysCXQDOie2ZmirczhXuTyWCmWdGCZcNDRHmvgKp1yzy85luteUGF
         1QYMEtX5lOL4TB3GoBm1U9SvyWT37t+/LWaQg4W09aaXOZZMpcO9N780G7tJ0ElNhwsS
         7GngpVu/3RZexp6jW2G3ZH2q5iRM5IoTfZAfBPLn4nm2DqL+5cwr65wFevurSwsXkfyb
         OhLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=49i00jYU127vVVjkcUG3jGAuS2Gj6vFaNuDKHc8vb5g=;
        b=NylArhrMwLo5SNpt8hzg7ixMMH8X1XaZ68joghrolRY1epkcwf+Bj1tQRL2wivWz6H
         FPKgF87ihkfRfvyz93eP8hjWDDhEBiWrJ0wOFlzSBZKLi6FKNdBXMp14a4Qt3UzhGg3u
         PNzxBF5DjqvZjmN0Nvaj38N8sDM0ofetnAxmSoNXjz96zAKjLtdyzRNhy0U6+3i4Oddz
         wyfqcJRXVe6p9XbTVBbTMPrlFW/2EWuVwKe97PvCrTIz0nPpeCgprXmbNRlZnzgbkies
         a5VzXo4bMQ5CjyxuFgUI4g3rLbl+370P3vv7arw4S5utks2rK3Wu3mjBukg/ZevJ1wRD
         17gA==
X-Gm-Message-State: AOAM530d4W8ZuMgL1F/EwHg+8Rc8O3js/WO6uZH9HnRPQdzSXhC2KqbH
        ujwUIeu6dFhggzfiYtOroyDcB59cdU3MON+QgQ0=
X-Google-Smtp-Source: ABdhPJyjEzV808YgZSfDUmbZzR6curcUfJ3uJkZd8aXfXl0bZKd+2KFq8NOYbHZJDucOqcFE5cdcpiheZXSZktmKidw=
X-Received: by 2002:a37:a3ca:: with SMTP id m193mr2792890qke.449.1590515249696;
 Tue, 26 May 2020 10:47:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200521191752.3448223-1-kafai@fb.com> <CAEf4BzYQmUCbQ-PB2UR5n=WEiCHU3T3zQcQCnjvqCew6rmjGLg@mail.gmail.com>
 <20200521225939.7nmw7l5dk3wf557r@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZyhT6D6F2A+cN6TKvLFoH5GU5QVEVW7ZkG+KQRgJC-1w@mail.gmail.com> <20200521231618.x3s45pttduqijbjv@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200521231618.x3s45pttduqijbjv@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 26 May 2020 10:47:18 -0700
Message-ID: <CAEf4BzagR04dQYvhCZOGq9Vt7SfGXjJNHhorw9MCNm9pH_xxHg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] bpf: Allow inner map with different max_entries
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 4:16 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, May 21, 2020 at 04:10:36PM -0700, Andrii Nakryiko wrote:
> > > > 4. Then for size check change, again, it's really much simpler and
> > > > cleaner just to have a special case in check in bpf_map_meta_equal for
> > > > cases where map size matters.
> > > It may be simpler but not necessary less fragile for future map type.
> > >
> > > I am OK for removing patch 1 and just check for a specific
> > > type in patch 2 but I think it is fragile for future map
> > > type IMO.
> >
> > Well, if we think that the good default needs to be to check size,
> > then similar to above, explicitly list stuff that *does not* follow
> > the default, i.e., maps that don't want max_elements verification. My
> > point still stands.
>
> I think consoldating map properties in bpf_types.h is much cleaner
> and less error prone.

Consolidation is good, but then we hopefully do it for all aspects of
maps that currently have ad-hoc checks spread across a lot of places.
Just looking at map_lookup_elem in syscall.c makes me wanna cry, for
example :) I'll reply on another thread where Daniel proposed putting
everything into ops, I like that better.

> I'd only like to tweak the macro in patch 1 to avoid explicit ", 0)".
> Can BPF_MAP_TYPE() macro stay as-is and additional macro introduced
> for maps with properties ? BPF_MAP_TYPE_FL() ?
> Or do some macro magic that the same macro can be used with 2 and 3 args?
