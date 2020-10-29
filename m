Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37E829E295
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391067AbgJ2C2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732825AbgJ2C1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 22:27:32 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713C8C0613D1;
        Wed, 28 Oct 2020 19:27:32 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id i186so894698ybc.11;
        Wed, 28 Oct 2020 19:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b9BOAnMXMoVPK4YONayTBt7vqZItsUD5u5uhV9sIfiI=;
        b=FlGEB0LTTPM4gZS86lNMm1Fc30sNdacUX6shfO+qwnZA0Jz+Zh3WXZmKY2cxSG7XpP
         A2NNzYYmRjXM5LcQypfBzYgzTSDGWLwSsUU3Jy6hpYCrzTUIGHffr6nqDwdqB6n98G1W
         NSp7IxpPD6BitsmDe7y+BN90LFBgXCNANNnaxA8fhyyoltN24+jjd/IbPJr2zY1xbUB/
         Uw4EgyZmxUViFlQTaKptVdWw+ZNPBv+Gy7SWX2NPlCdvwyGS9LK2LLRYewN2BfM2XWwf
         sqnaBteTpBkeBl4liyyq6T8MdtMihgLYKPxCU5S6lK6Vc52haHktdgjQsPTzNuXlu+Xi
         pmSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b9BOAnMXMoVPK4YONayTBt7vqZItsUD5u5uhV9sIfiI=;
        b=HWV9q0CmFxIQTc97B053vZ6SMDGGzvjeM2Db5r/IHarEAEvKErpib48NQ9F89Ug+RE
         8ZdaG+CWG2ir3BlJgGD6WU+E4PGiy4efVQOaHmpdwUQqTOzbZOsKFR3u4Ju+VTJX5KWn
         3e05BsBMzfjvJcZXrqLQwffEWpZH1QY9p7GETNfo0U6bu/LMkDuHlVSjqZu3+wqr+AGD
         aqA5kKkknkWPQBQec42NgGZBVTL3vnJbWP8TYCb7mzMtMMU+lyf6FCM0GrGH/tNNJ/YI
         dZl2BYWz1RloAbxHP2D6x9SgLM5Wpjo+9iTv9KZYSgAMFm/YpVKleHmlQOX8yDylS9Bp
         T2XA==
X-Gm-Message-State: AOAM530f/k/F8+AhMxZYbbp61VuQlDsO7q1EbC0rV0ZOcKiXYtwb0l11
        +9oFixOu0BJcORr/9C1Ab4J7oeumZCQJS1pEZ9I=
X-Google-Smtp-Source: ABdhPJxhGtV3S29KlyIGapKNKUXB3jYo/wYK3U/CETHFe/x6wevLSF4vrBGS4iZg9auYULOohzrgtng+0q+/g+YnEeI=
X-Received: by 2002:a25:c001:: with SMTP id c1mr2879701ybf.27.1603938451449;
 Wed, 28 Oct 2020 19:27:31 -0700 (PDT)
MIME-Version: 1.0
References: <20201023033855.3894509-1-haliu@redhat.com> <20201028132529.3763875-1-haliu@redhat.com>
 <7babcccb-2b31-f9bf-16ea-6312e449b928@gmail.com> <20201029020637.GM2408@dhcp-12-153.nay.redhat.com>
In-Reply-To: <20201029020637.GM2408@dhcp-12-153.nay.redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 28 Oct 2020 19:27:20 -0700
Message-ID: <CAEf4BzZR4MqQJCD4kzFsbhpfmp4RB7SHcP5AbAiqzqK7to2u+g@mail.gmail.com>
Subject: Re: [PATCHv2 iproute2-next 0/5] iproute2: add libbpf support
To:     Hangbin Liu <haliu@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 7:06 PM Hangbin Liu <haliu@redhat.com> wrote:
>
> On Wed, Oct 28, 2020 at 05:02:34PM -0600, David Ahern wrote:
> > fails to compile on Ubuntu 20.10:
> >
> > root@u2010-sfo3:~/iproute2.git# ./configure
> > TC schedulers
> >  ATM  yes
> >  IPT  using xtables
> >  IPSET  yes
> >
> > iptables modules directory: /usr/lib/x86_64-linux-gnu/xtables
> > libc has setns: yes
> > SELinux support: yes
> > libbpf support: yes
> > ELF support: yes
> > libmnl support: yes
> > Berkeley DB: no
> > need for strlcpy: yes
> > libcap support: yes
> >
> > root@u2010-sfo3:~/iproute2.git# make clean
> >
> > root@u2010-sfo3:~/iproute2.git# make -j 4
> > ...
> > /usr/bin/ld: ../lib/libutil.a(bpf_libbpf.o): in function `load_bpf_object':
> > bpf_libbpf.c:(.text+0x3cb): undefined reference to
> > `bpf_program__section_name'
> > /usr/bin/ld: bpf_libbpf.c:(.text+0x438): undefined reference to
> > `bpf_program__section_name'
> > /usr/bin/ld: bpf_libbpf.c:(.text+0x716): undefined reference to
> > `bpf_program__section_name'
> > collect2: error: ld returned 1 exit status
> > make[1]: *** [Makefile:27: ip] Error 1
> > make[1]: *** Waiting for unfinished jobs....
> > make: *** [Makefile:64: all] Error 2
>
> You need to update libbpf to latest version.

Why not using libbpf from submodule?

>
> But this also remind me that I need to add bpf_program__section_name() to
> configure checking. I will see if I missed other functions' checking.
>
> Thanks
> Hangbin
>
