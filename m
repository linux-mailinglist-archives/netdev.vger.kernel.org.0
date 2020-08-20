Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2754D24C05A
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgHTOOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgHTOO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 10:14:26 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AF3C061385;
        Thu, 20 Aug 2020 07:14:26 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b79so1601482qkg.9;
        Thu, 20 Aug 2020 07:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MbyEv8DIUXpuUpb2BRbOL6BERGEvF0v2TeCqsuSGqbA=;
        b=PHul54+ivQAGumKBZSINu8ZrWdyARLylFkl2mP2bSCMA8na2Vha7+6xjBxobbJCTgf
         V1a5CUUv3MrJpyMWRUoyrAkzHC0sWkqZQElwD1HhM6uo1275o0kFFhpf7Dbwk3OGdrbI
         ZgPXwSx0kzYOfC0Hr4z45RiZX1fy3HC5GLijw67Q+VgGFVMZJKn/YxIeMud1Cc8M7oc1
         AZZ+RHIjsmZMRjhPXyaEAw9sbTLHT723vlrl7dgnkWQzbNgrwbHKDSDbCz5eskgzrBCU
         cxzWEeorXvdPmbu+sknSIJbxH7tWCwizbkp4WX1QJ2mSorj21ndJAIVeYdOfcvWve3GS
         yCLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MbyEv8DIUXpuUpb2BRbOL6BERGEvF0v2TeCqsuSGqbA=;
        b=T0GNApI6dfhWYtDJkTM/6J0otfxB3AAK/fcXbvHeT2Q1zD60IXYS88Q3M0Km670aBS
         vxOq9JjfHOauLgtI5xA1weaI8dckOANio24fkqh80q90D89bxsPs41mPzjgtWIvsLB+n
         JSLyZUab+Vk+T9KknhJuZGCS1XHp1TgS7Lp6BB/7kgF3s75ZUDH8sBsuICaejuWnVGcZ
         p7uBeRALGc3StXtcsdkhZgm7oqPfzekGmKUJUvCrpBoVuHC2dGX5Ag+AcDm0cmMVBd61
         FYb96ZMRPx0xpwFPzVrlPoaHVnpZaPlZeFReZupmR4WBOEahG1P8+Fa85fV/GbrQcJ6M
         06NA==
X-Gm-Message-State: AOAM532EHElAmQcQ0XFZ8If+VkroVcRyC1zTMDMiekM8Cw7KtZfVqqja
        TXEwzS3yedelryIG/ikiCjU=
X-Google-Smtp-Source: ABdhPJw5AqH+AVnPf5GAbdfcZp04qpgaGMY9zeipsYlLu/fhWSP1ILdrkgh8kFVW6bBL5psJH0BGdg==
X-Received: by 2002:a05:620a:1a:: with SMTP id j26mr2786184qki.183.1597932865468;
        Thu, 20 Aug 2020 07:14:25 -0700 (PDT)
Received: from bpf-dev (pc-199-79-45-190.cm.vtr.net. [190.45.79.199])
        by smtp.gmail.com with ESMTPSA id n128sm2244447qke.8.2020.08.20.07.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 07:14:24 -0700 (PDT)
Date:   Thu, 20 Aug 2020 10:14:20 -0400
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v5] bpf/selftests: fold test_current_pid_tgid_new_ns into
 test_progs.
Message-ID: <20200820141419.GA45373@bpf-dev>
References: <20200818204325.26228-1-cneirabustos@gmail.com>
 <CAEf4Bzbd32RLcPThiXnmPYfBkN+eghWqAgHG5YfA6ovO88u7aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzbd32RLcPThiXnmPYfBkN+eghWqAgHG5YfA6ovO88u7aQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 05:41:57PM -0700, Andrii Nakryiko wrote:
> On Tue, Aug 18, 2020 at 1:44 PM Carlos Neira <cneirabustos@gmail.com> wrote:
> >
> > Currently tests for bpf_get_ns_current_pid_tgid() are outside test_progs.
> > This change folds a test case into test_progs.
> >
> > Changes from V4:
> >  - Added accidentally removed blank space in Makefile.
> >  - Added () around bit-shift operations.
> >  - Fixed not valid C89 standard-compliant code.
> >
> > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/testing/selftests/bpf/.gitignore        |   2 +-
> >  tools/testing/selftests/bpf/Makefile          |   2 +-
> >  .../bpf/prog_tests/ns_current_pid_tgid.c      |  85 ----------
> >  .../bpf/prog_tests/ns_current_pidtgid.c       |  55 ++++++
> >  .../bpf/progs/test_ns_current_pid_tgid.c      |  37 ----
> >  .../bpf/progs/test_ns_current_pidtgid.c       |  25 +++
> >  .../bpf/test_current_pid_tgid_new_ns.c        | 159 ------------------
> >  .../bpf/test_ns_current_pidtgid_newns.c       |  91 ++++++++++
> >  8 files changed, 173 insertions(+), 283 deletions(-)
> >  delete mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c
> >  delete mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
> >  delete mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
> >  create mode 100644 tools/testing/selftests/bpf/test_ns_current_pidtgid_newns.c
> >
> > diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
> > index 1bb204cee853..022055f23592 100644
> > --- a/tools/testing/selftests/bpf/.gitignore
> > +++ b/tools/testing/selftests/bpf/.gitignore
> > @@ -30,8 +30,8 @@ test_tcpnotify_user
> >  test_libbpf
> >  test_tcp_check_syncookie_user
> >  test_sysctl
> > -test_current_pid_tgid_new_ns
> >  xdping
> > +test_ns_current_pidtgid_newns
> >  test_cpp
> >  *.skel.h
> >  /no_alu32
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index e7a8cf83ba48..e308cc7c8598 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -37,7 +37,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
> >         test_cgroup_storage \
> >         test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
> >         test_progs-no_alu32 \
> > -       test_current_pid_tgid_new_ns
> > +       test_ns_current_pidtgid_newns
> 
> Have you tried doing a parallel build with make -j$(nproc) or
> something like that? It fails for me:
> 
> test_ns_current_pidtgid_newns.c:6:10: fatal error:
> test_ns_current_pidtgid.skel.h: No such file or directory
> 
>  #include "test_ns_current_pidtgid.skel.h"
> 
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> The problem seems to be that you haven't recorded dependency on the
> skeleton file for this new test_ns_current_pidtgid_newns.
> 
> But rather than fixing it, let's just fold
> test_ns_current_pidtgid_newns into test_progs as well? Then all such
> issues will be handled automatically and this test will be executed
> regularly.
> 
> >
> >  # Also test bpf-gcc, if present
> >  ifneq ($(BPF_GCC),)
> 
> [...]

Hi Andrii,

You are right, really all tests should be folded into test_progs.
I'll fold both tests into test_progs in my next version.
Thank you for your feedback.

Bests
