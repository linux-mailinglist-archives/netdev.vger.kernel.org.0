Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFCF2662BC
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgIKP7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgIKP5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:57:49 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807ADC0613ED
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 08:57:49 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id cv8so5412499qvb.12
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 08:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7EL5QIMCol+nNuuhHrYx3NpBAz3xMq+uHFMPEPZUHdY=;
        b=rLp1NySzNWm5L4jWo+hY0vSfl0/xqBuHjKQVwf1WDpdwjdJGu9skxJVSHfNRONDd93
         L5E5R/usjyvzxijBipEXLFNLPt3qmHFasqjd3+Xsn+NIggx/Et6Z1oGCA/hbhTO9YVeL
         +VS0Nv8c5s69q4OTqKMh+hYiQQFY5RkcvplUV5xeL6SlCupRhLqqc+cT/s6U/MLlbLoO
         XbxbDzDGDwiLlOse0Y2lryfCcNSXigxKe3q/bG+tJ7o4fddNC2pV1FMf++YPCGyBywuy
         eTfxn81+HM1asfkTRTxjn2wmjAQrGpJH6KXtFXYjb7k+etQ7fotosxILtlgQwX3ybBcv
         qCow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7EL5QIMCol+nNuuhHrYx3NpBAz3xMq+uHFMPEPZUHdY=;
        b=CNoMF5/Z8feNgy/WRLqn117l0g2j2u+g+6X/U8Y4Cc2uXd6ADIbdFq2Y4vwA3uAcCd
         p1W8twp2ul730oAkPNhNRFGl+Odwr874gy1RvzUrzUQRRALlzdSjjxGBlHWb28eDsEbG
         5sOPdjA1OLqWvXMG3y4MWyv3i4+P1tbab1RiYIogYChUOsBMMkqmY7wJLAewqy+qCbZN
         G7uNJfvn+6q/lg8HlLRVy+x2mKK0HjQ7F1aCPT9J2yRowh8GoTkLjH7naKufPeW46WQQ
         f3UOuU0drNCe3BhJ6YP4iQFXYPjpIbl+C3lfJa4EVq2/2pu2ZzIHD6uKdAyN07hqCqid
         8qrw==
X-Gm-Message-State: AOAM533zmjhAUV4wtwrb1f25aZ0ReXshEbDATG2zcTaz4Kmfge++AKvv
        KuFSL5149ug6/SMgO+lubM/XH/WV6Oh7f0RC4yFalQ==
X-Google-Smtp-Source: ABdhPJwzpIi715JRPFgu5PGIdnTrR5aO+y3zA2nI0tnr33CzB4RLydg7fngEbyQDu3GTloB40l4orxrYchhLrB3iztA=
X-Received: by 2002:a0c:f48e:: with SMTP id i14mr2598321qvm.5.1599839868533;
 Fri, 11 Sep 2020 08:57:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200909182406.3147878-1-sdf@google.com> <20200909182406.3147878-6-sdf@google.com>
 <CAEf4BzY7Ca9ZpL3x_EkjxM4tZXtNJV5kV=MPGTbibkv_bSFB9w@mail.gmail.com>
In-Reply-To: <CAEf4BzY7Ca9ZpL3x_EkjxM4tZXtNJV5kV=MPGTbibkv_bSFB9w@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 11 Sep 2020 08:57:37 -0700
Message-ID: <CAKH8qBvikNYe31NdGin=QYEVt=0LhRg6cDX725mL3D0E_3Jt0Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 5/5] selftests/bpf: Test load and dump
 metadata with btftool and skel
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 12:59 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Sep 9, 2020 at 11:25 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > From: YiFei Zhu <zhuyifei@google.com>
> >
> > This is a simple test to check that loading and dumping metadata
> > in btftool works, whether or not metadata contents are used by the
> > program.
> >
> > A C test is also added to make sure the skeleton code can read the
> > metadata values.
> >
> > Cc: YiFei Zhu <zhuyifei1999@gmail.com>
> > Signed-off-by: YiFei Zhu <zhuyifei@google.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
>
> It would be good to test that libbpf does bind .rodata even if BPF
> program doesn't use it. So for metadata_unused you can get
> bpf_prog_info and check that it does contain the id of .rodata?
Good idea, will add that.

> > +const char bpf_metadata_a[] SEC(".rodata") = "foo";
> > +const int bpf_metadata_b SEC(".rodata") = 1;
>
> please add volatile to ensure these are not optimized away
Ack, ty!
