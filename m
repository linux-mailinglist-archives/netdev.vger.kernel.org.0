Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63079FF807
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 06:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbfKQF57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 00:57:59 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38943 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfKQF56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 00:57:58 -0500
Received: by mail-qt1-f193.google.com with SMTP id t8so16179602qtc.6;
        Sat, 16 Nov 2019 21:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pm5y2zcDTCYoHgmwyHgBv33gyStPy1J5HfZ50jCparM=;
        b=KFRwYTMEfpdaDFxVVRCLGDF+9rgwW46LYz8u2HKVQa1xrBBdvYijCI7fA9Ox+8kX0T
         o0MFmzcbKLneLKXpI0mijaMUGKQPnALP/um3MxdYPvVz3NwPVYAnoX1D6OSv9BWnPpJb
         54+XZpWvgiDJJgdmxKng5Nwc8QDbx/sYgOffFAlz1mFKSRJSAIC3TeAeKDbLzAvDgvAn
         mfKz/CKt6DBscBaAbQKRgBkbFy86ebw4MtYXDrvwcZ3KYniweRxAWUH5RAeSCXbC0Acx
         deYUVdwio9ezWoweTN4+H81aVQT1slOeQXMaxzQIu0s48vQ/JevhxU7BwJ+xTm05mnEI
         W5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pm5y2zcDTCYoHgmwyHgBv33gyStPy1J5HfZ50jCparM=;
        b=ZvOHGzarhbaAcFT2SjDCiH25y4lge1zhCI4iPeV8xPfMK2SvYKovfXq7TKDbnvo7Vt
         lHS+aG4POJ0c3P6iqBAvjdUTq62nGsM76V8g2eN21IIewdAV8rIaKMfNWd16IhX7MXuC
         Hk1gkh7XB1KxOdmPJgBhOl1n8NMKUh2P4jQHQDIAbSjWK0oPpm7awAFqjbqbHBhY+EJT
         g6BWOH32J5YDIuY4P7e/MTvccRc3bfBEzgmPXKRmyvbp4bwGVsxRKdXLb7A2Vu4oVwji
         RSmVJ3Xp/fIlHEbvfJQIhx6HJVIsDIIqkkN/ex1ae5/9+FDOVB4CJXKcDLly2V1QWyM/
         NmMA==
X-Gm-Message-State: APjAAAWDTJnT10aJ/NyvfJHICGwf53SuQFg1IEYZs7jfu2n5+XJnm2za
        pjXjOAOl6XIfNjvtdzbpn2WrQ4Fr38k3pq87XBnB9A==
X-Google-Smtp-Source: APXvYqxrItoYxd62tM2WEeb1lCk2cEOO3fVDnSsWiGjstJBPM4vYBdPyBNzdb/nK3Fj1b4ctQsXp+iNTO72y2g29sTY=
X-Received: by 2002:ac8:6613:: with SMTP id c19mr22135935qtp.117.1573970276291;
 Sat, 16 Nov 2019 21:57:56 -0800 (PST)
MIME-Version: 1.0
References: <20191115040225.2147245-1-andriin@fb.com> <20191115040225.2147245-3-andriin@fb.com>
 <888858f7-97fb-4434-4440-a5c0ec5cbac8@iogearbox.net> <293bb2fe-7599-3825-1bfe-d52224e5c357@fb.com>
 <3287b984-6335-cacb-da28-3d374afb7f77@iogearbox.net> <fe46c471-e345-b7e4-ab91-8ef044fd58ae@fb.com>
 <c79ca69f-84fd-bfc2-71fd-439bc3b94c81@iogearbox.net> <3eca5e22-f3ec-f05f-0776-4635b14c2a4e@fb.com>
In-Reply-To: <3eca5e22-f3ec-f05f-0776-4635b14c2a4e@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 16 Nov 2019 21:57:45 -0800
Message-ID: <CAEf4BzZHT=Gwor_VA38Yoy6Lo7zeeiVeQK+KQpZUHRpnV6=fuA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: add mmap() support for BPF_MAP_TYPE_ARRAY
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@surriel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 5:18 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 11/15/19 4:13 PM, Daniel Borkmann wrote:
> >>> Yeah, only for fd array currently. Question is, if we ever reuse that
> >>> map_release_uref
> >>> callback in future for something else, will we remember that we earlier
> >>> missed to add
> >>> it here? :/
> >>
> >> What do you mean 'missed to add' ?
> >
> > Was saying missed to add the inc/put for the uref counter.
> >
> >> This is mmap path. Anything that needs releasing (like FDs for
> >> prog_array or progs for sockmap) cannot be mmap-able.
> >
> > Right, I meant if in future we ever have another use case outside of it
> > for some reason (unrelated to those maps you mention above). Can we
> > guarantee this is never going to happen? Seemed less fragile at least to
> > maintain proper count here.

I don't think we'll ever going to allow mmaping anything that contains
not just pure data. E.g., we disallow mmaping array that contains spin
lock for that reason. So I think it's safe to assume that this is not
going to happen even for future maps. At least not without some
serious considerations before that. So I'm going to keep it as just
plain bpf_map_inc for now.

I'm going to convert bpf_prog_add/bpf_prog_inc, though, and will do it
as a separate patch, on top of bpf_map_inc refactor. It touches quite
a lot drivers, so would benefit from having being separate.

>
> I'm struggling to understand the concern.
> map-in-map, xskmap, socket local storage are doing bpf_map_inc(, false)
> when they need to hold the map. Why this case is any different?
