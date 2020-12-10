Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1892D59D8
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 12:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgLJL5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 06:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728740AbgLJL44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 06:56:56 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FC6C0613D6;
        Thu, 10 Dec 2020 03:56:16 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id x2so4428682ybt.11;
        Thu, 10 Dec 2020 03:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EVOwB0q6/0FJtlA5FxzsP/l25lLPTS7Bl7vepfUdQJ8=;
        b=CodRu1FpbaLNvL8+Ga8xXaoICmMw0ChPFDaczzN6U4WA+xnlYnizg05aOcYcI6HOcD
         mVUkfT6ODz9A0na8P394nF0IaxqCAv99li/LfgdB/QPVN50dhgDALrqViBqAjoYdahur
         WYx1WMyB5Ar0sXlh70aMhQ4flEeFWfwxbIYF/B6KJQBX9BZSq2FT+i2546yw465DeCs6
         vPZwtchvX3L0Ke4Dl6dgxrg2o7wxdPDVz5nc66Ecg8i5FAaI7zH9qBMNC6wK61BvWDvd
         Z34IxHx7GgluT3kj9umkkYxnzmN4390ZgtAokYF+a20aRSEzUAeRximsxd6S8dTB9bIB
         AxIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EVOwB0q6/0FJtlA5FxzsP/l25lLPTS7Bl7vepfUdQJ8=;
        b=TS/JLEgH6YET5phSSDmYbWrjnPTQ2RAPvOpW6rZGLt1C0OxLGft3PLFOHnoPInU8Qu
         aDfvA5gb8TLilRHhDcSvLHdufY1QUk6gU8ij543c7wtLsXOJIn6vNoNd1hUH3MF6U1SF
         xTof0DMwMCVAEkBolITAqXQU0D3d4QEDV163cFao70pINkDnV9gbasyBqPI77PTHYuIs
         lv8Wq2O94kijUEaB+okT2knWipEL9ncjCCF/WPodTX/JRqRjxCb49ua0mw8N88wqPfT8
         eTXvP3vuCp10L4uTgYo4vdHvWRVu1xtl89uoQigAbnkk9OSpPL/d34dWU81Nh6mMsVK/
         gykQ==
X-Gm-Message-State: AOAM532MDnWmpgyXJ3LQ6/ZB6Fv1WKH1EwQr4JFSOh2oPMX2fD3QzbQA
        dVAqjoeyiQ9q9mYqx2++t/1pslbn+QUIeYLj5Cw=
X-Google-Smtp-Source: ABdhPJyQM5SkpwSD0pKYYsMVyG93G+4v4pSRI+d2d+NljvTD/SbpdWIbh2U4vv1HzTWjSh8LiI5ZLd+zk/M8tAl1+0s=
X-Received: by 2002:a25:ab31:: with SMTP id u46mr10200287ybi.179.1607601375345;
 Thu, 10 Dec 2020 03:56:15 -0800 (PST)
MIME-Version: 1.0
References: <20201207215333.11586-1-weqaar.a.janjua@intel.com>
 <20201207215333.11586-3-weqaar.a.janjua@intel.com> <760489c0-f935-437d-6213-6e8775693bbc@fb.com>
In-Reply-To: <760489c0-f935-437d-6213-6e8775693bbc@fb.com>
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
Date:   Thu, 10 Dec 2020 11:55:49 +0000
Message-ID: <CAPLEeBbLhGATeSbA46SxEpgVXKXm__OcgjPhNKcvzoCnSk7sdA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/5] selftests/bpf: xsk selftests - SKB POLL, NOPOLL
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Dec 2020 at 18:29, Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 12/7/20 1:53 PM, Weqaar Janjua wrote:
> > Adds following tests:
> >
> > 1. AF_XDP SKB mode
> >     Generic mode XDP is driver independent, used when the driver does
> >     not have support for XDP. Works on any netdevice using sockets and
> >     generic XDP path. XDP hook from netif_receive_skb().
> >     a. nopoll - soft-irq processing
> >     b. poll - using poll() syscall
> >
> > Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
> > ---
> >   tools/testing/selftests/bpf/Makefile       |   3 +-
> >   tools/testing/selftests/bpf/test_xsk.sh    |  39 +-
> >   tools/testing/selftests/bpf/xdpxceiver.c   | 979 +++++++++++++++++++++
> >   tools/testing/selftests/bpf/xdpxceiver.h   | 153 ++++
> >   tools/testing/selftests/bpf/xsk_prereqs.sh |  16 +
> >   5 files changed, 1187 insertions(+), 3 deletions(-)
> >   create mode 100644 tools/testing/selftests/bpf/xdpxceiver.c
> >   create mode 100644 tools/testing/selftests/bpf/xdpxceiver.h
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 6a1ddfe68f15..944ae17a39ed 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -82,7 +82,8 @@ TEST_PROGS_EXTENDED := with_addr.sh \
> >   # Compile but not part of 'make run_tests'
> >   TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
> >       flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
> > -     test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko
> > +     test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
> > +     xdpxceiver
>
> Could you have a patch to put xdpxceiver in .gitignore?
>
> I see below:
> Untracked files:
>    (use "git add <file>..." to include in what will be committed)
>          tools/testing/selftests/bpf/xdpxceiver
>
ACK, patch on the list now

> >
> >   TEST_CUSTOM_PROGS = urandom_read
> >
