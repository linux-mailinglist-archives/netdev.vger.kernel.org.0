Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDBE24925F
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgHSBcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgHSBcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 21:32:05 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30A3C061389;
        Tue, 18 Aug 2020 18:32:02 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id s195so12439813ybc.8;
        Tue, 18 Aug 2020 18:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0KLl7QTNidvM9emk/MDbdQ16O+Yga9gwzEzaaHXnHPw=;
        b=ZS79enmr3L3PU35nKHrZmQ/1BUtydkj9F4ZfocJsSso1T2Rksno1C9u8Bk/Ggtzsyi
         0+Dlc5RvNi9ObuD6bu8o5qwAqLoNVMSXjOWCiWiGocO+YbN1T0H4CFG74aro/SpkSmYq
         TlZpEYREqM9mm+zrjTAo2AXKVlJoEIcFkInzlcUJoXL+2Lib0xUZI0rqBvr/7+IE5q+1
         76pJyaWm8BHpIr7lp51uJCsdbVCI/5MJYDAbsceVhi7FLyHD4c8lDOba9lEepsvCYC20
         hJ70a+VlyU7Uu5mYt35H9Zm6xvy/Qh3y66/0IWLAGdw0gWim5FN2+ZPNJ6+M2O6SH/Lf
         KilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0KLl7QTNidvM9emk/MDbdQ16O+Yga9gwzEzaaHXnHPw=;
        b=IUo2XKiAERvF5VfYllE0Or7dXX5CdnM4pD2oO5t6iO40UTAtZioz2b5Q/1fgw+MpDG
         vUfn24WAUAhr3BH2PkPuvgxttZ8W6BIGZ8vD2efIvw9y6DbE34Z4wS2LQWJ+TgXM2pKW
         TIfcaKtZV50opZq09blBtfz23x04ZxW5Ja5Pi37GYpmTRUWAMguB4hss1TSnbKx4yKa6
         MsAHUTTUrhLIqHkh6LrLxm9lDI3/038hvNiFNMyp6l3mdleFClJc1Yf/2/arkSDztZXD
         jL5p7Rd2AQ50O6jtFegBYFljXMR05rjO5GwZG/E9XexBBufZ9PgUV/B4ciMHI7KBD7ZI
         fvSA==
X-Gm-Message-State: AOAM5326CtrSEGsK0b7S8Kg/AFLm+7p7+H4iw6iKP4Bt58DyX6YnWv0a
        +zpR5TPuUoLSNaIG3WPZbyWe4pA/gvSke+Aqk8M=
X-Google-Smtp-Source: ABdhPJxOX7XgMckbBzxn3bugOICWwPezacwQKUxYhTO77Fa18oyRjPx6+4XmDHeWXnbryDmXTfh8JFsf9Ba//7ADa/k=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr29470573ybq.27.1597800722072;
 Tue, 18 Aug 2020 18:32:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200818223921.2911963-1-andriin@fb.com> <20200819012146.okpmhcqcffoe43sw@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200819012146.okpmhcqcffoe43sw@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 18 Aug 2020 18:31:51 -0700
Message-ID: <CAEf4BzbpJ4M0X2XPEadXPzPM+2cOPf-9QDMp=2qz3VvY+bbqsg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/9] Add support for type-based and enum
 value-based CO-RE relocations
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 6:21 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Aug 18, 2020 at 03:39:12PM -0700, Andrii Nakryiko wrote:
> > This patch set adds libbpf support to two new classes of CO-RE relocations:
> > type-based (TYPE_EXISTS/TYPE_SIZE/TYPE_ID_LOCAL/TYPE_ID_TARGET) and enum
> > value-vased (ENUMVAL_EXISTS/ENUMVAL_VALUE):
> >
> > LLVM patches adding these relocation in Clang:
> >   - __builtin_btf_type_id() ([0], [1], [2]);
> >   - __builtin_preserve_type_info(), __builtin_preserve_enum_value() ([3], [4]).
>
> I've applied patches 1-4, since they're somewhat indepedent of new features in 5+.
> What should be the process to land the rest?
> Land llvm first and add to bpf/README.rst that certain llvm commmits are necessary
> to build the tests?

Clang patches landed about two weeks ago, so they are already in Clang
nightly builds. libbpf CI should work fine as it uses clang-12 nightly
builds.


> But CI will start failing. We can wait for that to be fixed,
> but I wonder is there way to detect new clang __builtins automatically in
> selftests and skip them if clang is too old?

There is a way to detect built-ins availability (__has_builtin macro,
[0]) from C code. If we want to do it from Makefile, though, we'd need
to do feature detection similar to how we did reallocarray and
libbpf-elf-mmap detection I just removed in the other patch set :).
Then we'll also need to somehow blacklist tests. Maintaining that
would be a pain, honestly. So far selftests/bpf assumed the latest
Clang, though, so do you think we should change that, or you were
worried that patches hadn't landed yet?
