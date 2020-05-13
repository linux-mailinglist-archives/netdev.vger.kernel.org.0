Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C201D1E9D
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390368AbgEMTLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390303AbgEMTLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:11:48 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADB7C061A0E
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:11:47 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 188so448065lfa.10
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DlDe1IobgVm68K0PtFybaGZyKFGHK1OfKry00qMtGtQ=;
        b=V1UkNiRNfL733X9vr+6V4+xkxNISM7utjyshsT36quvy8jA5IVqpf+k3EDQxjXOIYU
         JkvVkJQB05ajebE0nuwA1SP0j1/ZNVxXHdyZbBxtTdovrxuSXCzKJOTV20D7eG1vu7ZV
         OomJViLlEUU/v3q1g+qPNyPfCuDydticNEJPw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DlDe1IobgVm68K0PtFybaGZyKFGHK1OfKry00qMtGtQ=;
        b=EBgCpmJu/Uc59QuHP4To4DoNwswyzth2DyTY//n1/ZZLh61GSB6IhgIel6Lz/YjqjV
         UyYbjpWpKAR2iyCQ34EcFEZnYYu33eKRc/JkeRfpOq4CsMadbOowJepSDe0OmEm/PNTh
         ZCWGG7p4BRMoPYvXkvjNsC/GWpd+3+deZpIUWy/H1LyCbJ24w8UtsGkDnoGjxM6uJyKk
         abGVFIBLrxz4Dkc1P6KRja4n5qM6AuXP3/la1gc1aosMJUGV1H11Ve0PK49Ytkn+VNWc
         YisR0wfX2nktubwO96MGXCpLfw6OPB+15xc05xL7pbLKagnU6YwdaWpqek8oahsOJNSB
         eHBw==
X-Gm-Message-State: AOAM533VhcSj36d3LmOuUTOrsDli3KABHX4OxKrc+2r/YQTm9xBHizIn
        CyFAFo8RdkoL0a2P8qTPS5hBD0SwtMs=
X-Google-Smtp-Source: ABdhPJz+jXAB/uwQh2/2jC7WJ1PAp3tE6M9tnO00n8iqRwblpJuN/EVcvqRJwuB8zVcZZ2HO9WHbhg==
X-Received: by 2002:a19:f70f:: with SMTP id z15mr619742lfe.53.1589397105048;
        Wed, 13 May 2020 12:11:45 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id d28sm280844lfe.76.2020.05.13.12.11.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 12:11:44 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id 8so482100lfp.4
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:11:43 -0700 (PDT)
X-Received: by 2002:a19:ed07:: with SMTP id y7mr627896lfy.31.1589397103373;
 Wed, 13 May 2020 12:11:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200513160038.2482415-1-hch@lst.de> <20200513160038.2482415-12-hch@lst.de>
In-Reply-To: <20200513160038.2482415-12-hch@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 13 May 2020 12:11:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj=u+nttmd1huNES2U=9nePtmk7WgR8cMLCYS8wc=rhdA@mail.gmail.com>
Message-ID: <CAHk-=wj=u+nttmd1huNES2U=9nePtmk7WgR8cMLCYS8wc=rhdA@mail.gmail.com>
Subject: Re: [PATCH 11/18] maccess: remove strncpy_from_unsafe
To:     Christoph Hellwig <hch@lst.de>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 9:01 AM Christoph Hellwig <hch@lst.de> wrote:
>
> +static void bpf_strncpy(char *buf, long unsafe_addr)
> +{
> +       buf[0] = 0;
> +       if (strncpy_from_kernel_nofault(buf, (void *)unsafe_addr,
> +                       BPF_STRNCPY_LEN))
> +               strncpy_from_user_nofault(buf, (void __user *)unsafe_addr,
> +                               BPF_STRNCPY_LEN);
> +}

This seems buggy when I look at it.

It seems to think that strncpy_from_kernel_nofault() returns an error code.

Not so, unless I missed where you changed the rules.

It returns the length of the string for a successful copy. 0 is
actually an error case (for count being <= 0).

So the test for success seems entirely wrong.

Also, I do wonder if we shouldn't gate this on TASK_SIZE, and do the
user trial first. On architectures where this thing is valid in the
first place (ie kernel and user addresses are separate), the test for
address size would allow us to avoid a pointless fault due to an
invalid kernel access to user space.

So I think this function should look something like

  static void bpf_strncpy(char *buf, long unsafe_addr)
  {
          /* Try user address */
          if (unsafe_addr < TASK_SIZE) {
                  void __user *ptr = (void __user *)unsafe_addr;
                  if (strncpy_from_user_nofault(buf, ptr, BPF_STRNCPY_LEN) >= 0)
                          return;
          }

          /* .. fall back on trying kernel access */
          buf[0] = 0;
          strncpy_from_kernel_nofault(buf, (void *)unsafe_addr,
BPF_STRNCPY_LEN);
  }

or similar. No?

                   Linus
