Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA1B1F3D8C
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 16:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbgFIOFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 10:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730011AbgFIOFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 10:05:17 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5C4C03E97C
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 07:05:17 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id q19so22524929eja.7
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 07:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5hepcAY2/ehcC2QRXTzcnN6zPc+QLUZRF3NIFXI3NgY=;
        b=CU9j5ULLQAwSyo5lzgoEK/VLxHk2fXaIjC83AeSXtVcYBK0qoA04HYDsrHYWVeMvS+
         YGjAt81DhuozocMhJKbMfw/IqDZevlAoWNtcX4AiEc/Fr4TgLpg+9VoJcdEwNYhAac/I
         X5nBwrg1GDIxiodJQUkQ15xrodKbrpaDomhYTVTMy5SYPxpIf2zlk6JMKIB+GF+BVINc
         2lXvzaNWSzQuEn/j/IhOdfhX/ndgoVv4UKiDhGCKbBKgoHSGpB58+pEvHSvU8sxmOWuj
         AVoSnoh2CKfWYLHw1KaE7T8Rd3XaaB3y3wlPdRGomcfI7alCTX0vQo9XCn7L+Yj22+BS
         RDiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5hepcAY2/ehcC2QRXTzcnN6zPc+QLUZRF3NIFXI3NgY=;
        b=KmZL1+MCDUOaatAGlxQd31p4mBUzHzowzGPV+SgIbHt5DCRNuR1Bh3Ldscl7V4ApR3
         3ZZmsXvQG5DiKw0uylQb38PprhlYmkT4Y/kiGKF6vN7cs+b28OfWxwgwOHRRymAfDQxK
         t8u/VbR4AABIPq7PXcdastGe0C78NjSzDrMtLHg7frRG0a/e/q1z9ROMbc2h4Qr9CFye
         BzhUwo5aqevn6OmDcUq9F088gtHBbacJdKwK3Kp5h25xAjjCm+GmgXgme/gWGTvHGWRa
         gXUCrQ3TUWlfEzy4HcS8NO/jSlCfHlM1/+cQQXaERg5P8H9uLt8FgWXIUMJRVfjmD6ko
         7sgg==
X-Gm-Message-State: AOAM532jLgjDHNh6dshEkIMg8ue501OBrGkJu6Myt4c8LRuPwZRaqF0R
        F13JJy1pSzf4ik885cJBK8d+HQ==
X-Google-Smtp-Source: ABdhPJzg++2o5ePPL5lY4GZatvE+sm6jWJ3OClVthRqg01qkSFwIJ27W183rZIEmcXKonTMixnWQNw==
X-Received: by 2002:a17:906:2656:: with SMTP id i22mr24427488ejc.397.1591711516099;
        Tue, 09 Jun 2020 07:05:16 -0700 (PDT)
Received: from myrica ([2001:171b:226e:c200:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id k24sm3844512edk.95.2020.06.09.07.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 07:05:15 -0700 (PDT)
Date:   Tue, 9 Jun 2020 16:05:04 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf] libbpf: Fix BTF-to-C conversion of noreturn function
 pointers
Message-ID: <20200609140504.GA915559@myrica>
References: <20200608152052.898491-1-jean-philippe@linaro.org>
 <CAEf4BzaNaHGBxNLdA1RA7VPou7ypO3Z5XBRG5gpkePx4g27yWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaNaHGBxNLdA1RA7VPou7ypO3Z5XBRG5gpkePx4g27yWA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 04:50:37PM -0700, Andrii Nakryiko wrote:
> On Mon, Jun 8, 2020 at 8:23 AM Jean-Philippe Brucker
> <jean-philippe@linaro.org> wrote:
> >
> > When trying to convert the BTF for a function pointer marked "noreturn"
> > to C code, bpftool currently generates a syntax error. This happens with
> > the exit() pointer in drivers/firmware/efi/libstub/efistub.h, in an
> > arm64 vmlinux. When dealing with this declaration:
> >
> >         efi_status_t __noreturn (__efiapi *exit)(...);
> >
> > bpftool produces the following output:
> >
> >         efi_status_tvolatile  (*exit)(...);
> 
> 
> I'm curious where this volatile is coming from, I don't see it in
> __efiapi. But even if it's there, shouldn't it be inside parens
> instead:
> 
> efi_status_t (volatile *exit)(...);

It's the __noreturn attribute that becomes "volatile", not the __efiapi.
My reproducer is:

  struct my_struct {
          void __attribute__((noreturn)) (*fn)(int);
  };
  struct my_struct a;

When generating DWARF info for this, GCC inserts a DW_TAG_volatile_type.
Clang doesn't add a volatile tag, it just omits the noreturn qualifier.
From what I could find, it's due to legacy "noreturn" support in GCC [1]:
before version 2.5 the only way to declare a noreturn function was to
declare it volatile.

[1] https://gcc.gnu.org/onlinedocs/gcc-4.7.2/gcc/Function-Attributes.html

Given that not all compilers turn "noreturn" into "volatile", and that I
haven't managed to insert any other modifier (volatile/const/restrict) in
this location (the efistub example above is the only issue on an
allyesconfig kernel), I was considering simply removing this call to
btf_dump_emit_mods(). But I'm not confident enough that it won't ever be
necessary.

> > Fix the error by inserting the space before the function modifier.
> >
> > Fixes: 351131b51c7a ("libbpf: add btf_dump API for BTF-to-C conversion")
> > Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > ---
> 
> Can you please add tests for this case into selftests (probably
> progs/btf_dump_test_case_syntax.c?) So it's clear what's the input and
> what's the expected output.

Those tests are built with clang, which doesn't emit the "volatile"
modifier. Should I add a separate test for GCC?

Thanks,
Jean
