Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E56891988EE
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 02:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgCaAc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 20:32:29 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38087 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729299AbgCaAc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 20:32:29 -0400
Received: by mail-pg1-f194.google.com with SMTP id x7so9514620pgh.5;
        Mon, 30 Mar 2020 17:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GtTHJgTzECMalINGrq/NBUKsYjonRoi5OsV0wz8YV8w=;
        b=Fcw8/9W74TNVGs5R9Ru/99b4VBsoxVXdxWAZ3uATIGja1f2fQ7TZfzmcFyESxMy+PK
         9myV7qNWA1nPHfCEJy2gZbzHgj9EPLnTovB1dzz/J1jOQPTgkC7R972C+XX0NPxZ4DVR
         8+LJCZf9GZTG1PLVtfR3yB8tt6W5/YG1E8/J495kKE8f/cdzkFUU207aaPuEp0RbkHxv
         T3CX2dNRWvBThZm2BYAYgFmgfAxa7e9EhdShch8QaSa8gH+vk9bEiC06T6DT4Mm0LsG7
         Sazxcak7+Zb2J/+xZC+/I/cyD5x0iOuLsR0NAEUClxs7xAE3NQTJpn00aY3jjgAQYdh1
         r3og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GtTHJgTzECMalINGrq/NBUKsYjonRoi5OsV0wz8YV8w=;
        b=hV0+F/5Vx6ypl/WkWdRSlNQachuLjlbbxLMtA9L+z9720wfq6qWQcuZZWcw9QfhP9d
         XOMxk2PtwjlOjE866I7eWM1jn/zdaKerRIqAjzkxxSPYOxcq/j9OS0aCOgPj1LE4KEZU
         nt4tzdM66J9mufBkTKyAJPswE1vKLz5EpJBNxNFmvhq6q2yCMEIu+b5ulx7wst92aiMt
         FAGGBPoA0qSBxSTzyVskro0JYmu52DR6sx2lAx6F8isulJG1R+22ECUnnF0xRyNGjbof
         9MIyy0fD54N9a3KEPfAuXqnbAmOtY5AfxERFvJXL0SoUnfGCV/DNRV8g0XE+LnosnnIX
         eXlw==
X-Gm-Message-State: ANhLgQ0GbeE1kgUQDWgNdvbgeWoDoXjI/aRC17Jy1YsQpt3l7u3CWMlz
        l0mGPrEC13gDKq9yViXQDCs=
X-Google-Smtp-Source: ADFU+vtFHXlxoJMjrQMZy2KiD7r45zouA+Ym968AdckAXnMH9PrYXy8BcDEplzvNCVksbesoEq0weg==
X-Received: by 2002:a62:fcc7:: with SMTP id e190mr15670557pfh.285.1585614746670;
        Mon, 30 Mar 2020 17:32:26 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:3558])
        by smtp.gmail.com with ESMTPSA id w9sm11152303pfd.94.2020.03.30.17.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 17:32:25 -0700 (PDT)
Date:   Mon, 30 Mar 2020 17:32:22 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
Message-ID: <20200331003222.gdc2qb5rmopphdxl@ast-mbp>
References: <20200330030001.2312810-1-andriin@fb.com>
 <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
 <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com>
 <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com>
 <CAADnVQK8oMZehQVt34=5zgN12VBc2940AWJJK2Ft0cbOi1jDhQ@mail.gmail.com>
 <cdd576be-8075-13a7-98ee-9bc9355a2437@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdd576be-8075-13a7-98ee-9bc9355a2437@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 05:43:52PM -0600, David Ahern wrote:
> On 3/30/20 4:50 PM, Alexei Starovoitov wrote:
> > On Mon, Mar 30, 2020 at 1:46 PM David Ahern <dsahern@gmail.com> wrote:
> >> release. As it stands it is a half-baked feature.
> > 
> > speaking of half-baked.
> > I think as it stands (even without link_query) it's already extremely
> > useful addition and doesn't take anything away from existing cgroup-bpf
> > and doesn't hinder observability. 'bpftool cgroup' works just fine.
> > So I've applied the set.
> > 
> > Even if it was half-baked it would still be applie-able.
> > Many features are developed over the course of multiple
> > kernel releases. Example: your nexthops, mptcp, bpf-lsm.
> > 
> 
> nexthops were not - refactoring in 1 release and the entire feature went
> in to 5.4. Large features / patch sets often must be spread across
> kernel versions because it is not humanly possible to send and review
> the patches.
> 
> This is not a large feature, and there is no reason for CREATE/UPDATE -
> a mere 4 patch set - to go in without something as essential as the
> QUERY for observability.

As I said 'bpftool cgroup' covers it. Observability is not reduced in any way.
Also there is Documentation/bpf/drgn.rst
Kernel is an open book. Just learn this simple tool and everything will
be observable. Not only bpf objects, but the rest of the kernel too.
imo the use case for LINK_QUERY makes sense for xdp only.
There is one program there and it's a dispatcher program that libdispatcher
will be iteratively updating via freplace. For cgroup bpf_links I cannot
think of a reason why apps would need to query it.
