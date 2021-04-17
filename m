Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C49362DD4
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 07:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhDQFCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 01:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhDQFCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 01:02:22 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C647BC061574;
        Fri, 16 Apr 2021 22:01:56 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id j18so48013293lfg.5;
        Fri, 16 Apr 2021 22:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JS5ToxDYDEg+E8RwSyqs2bCJvCy+zGOhHKQvlmMv9O8=;
        b=nHUsfVFx1zCWs+niphx3RfnQ8oE4aMInQpEJwPGKuhvlgRv/xajSccq7IrCWza/nEU
         s1uF9Xy5U6HERGzLc61hTHdROlDAwNhCLVxPAZ0ihm/93AlZYquhLacDtPFacwLOy4fD
         I/m5AJ/BxUoQUW7s2TaLhAfNQzsvmGM/fiKeyuCskPPDmUnHz6bSGkJnA5ay6N+s4yrZ
         SsTUZSdsmFpVyZf9J8AUoQdqkUV9xSkDoD1Yw3wIVTy3hTJfWb/d4nXm/GENh8WYYd6V
         XQWFI4JDCAw409lUzsZJQmMxWwPh7Pa2Fld1Jhv41VRgZcKr0MMNt6PPHHp7Ar9Lrc0K
         mL4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JS5ToxDYDEg+E8RwSyqs2bCJvCy+zGOhHKQvlmMv9O8=;
        b=jVklfZYO58Zn20xrDzzih373Y0usPDq7gAk6HCeUgfwDJsxYT/iN8lWFnZepxykpqK
         DZe4JEZ5AzeY9GmVcRsNkt05cHVRwHyYUDinmxnGVxBJetuOtBhhw+Qf0K/OzmetZzac
         0P9c5LW+e86sqMx5ZXzj4k8SLokcnXrROVqG6gxnlod0mUqoZ9+YfK89lAflKjYnMIXm
         MbpwqWw7T1+dfH8gi/YJlz8lMn6BmEdduuGV2wEEdUnqZx7nkmL3Qxyzykb0NNGbvLEh
         0sGmAugzJIXlGL42jiEBRMeMs7d1Uv+8D5quScjP6zJ8CUFaZwhn+lUbugNW+9wSNP2S
         wqIA==
X-Gm-Message-State: AOAM531afXERcTVYS5D2QQj8u1g9qa145BXpwkizTgOTra0VVuJ0Pl47
        RY9VEHYM5pqMLfqX4n0V+VYkVLlTgzT46Jh+NGi69VIC
X-Google-Smtp-Source: ABdhPJxcMTZXG0F1BOJAHysoyWx3MRoSkHObFdVFWelI6IRMHRjvQsLWAbn7sajMpHOqVLF1UjK7+r6giKvSvWUtHlA=
X-Received: by 2002:a05:6512:2026:: with SMTP id s6mr5368136lfs.214.1618635715172;
 Fri, 16 Apr 2021 22:01:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
 <20210417033224.8063-12-alexei.starovoitov@gmail.com> <YHpZGeOcermVlQVF@zeniv-ca.linux.org.uk>
 <CAADnVQL9tmHtRCue5Og0kBz=dAsUoFyMoOF61JM7yJhPAH8V8Q@mail.gmail.com> <YHpeTKV2Y+sjuzbD@zeniv-ca.linux.org.uk>
In-Reply-To: <YHpeTKV2Y+sjuzbD@zeniv-ca.linux.org.uk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 16 Apr 2021 22:01:43 -0700
Message-ID: <CAADnVQLOZ7QL61_XPCSmxDfZ0OHX_pBOmpEWLjSUwqhLm_10Jw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 11/15] bpf: Add bpf_sys_close() helper.
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 9:04 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Fri, Apr 16, 2021 at 08:46:05PM -0700, Alexei Starovoitov wrote:
> > On Fri, Apr 16, 2021 at 8:42 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > On Fri, Apr 16, 2021 at 08:32:20PM -0700, Alexei Starovoitov wrote:
> > > > From: Alexei Starovoitov <ast@kernel.org>
> > > >
> > > > Add bpf_sys_close() helper to be used by the syscall/loader program to close
> > > > intermediate FDs and other cleanup.
> > >
> > > Conditional NAK.  In a lot of contexts close_fd() is very much unsafe.
> > > In particular, anything that might call it between fdget() and fdput()
> > > is Right Fucking Out(tm).
> > > In which contexts can that thing be executed?
> >
> > user context only.
> > It's not for all of bpf _obviously_.
>
> Let me restate the question: what call chains could lead to bpf_sys_close()?

Already answered. User context only. It's all safe.
