Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073A13BF469
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 06:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhGHEH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 00:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhGHEH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 00:07:59 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5ED4C061574;
        Wed,  7 Jul 2021 21:05:16 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id p1so10769948lfr.12;
        Wed, 07 Jul 2021 21:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JV+VaWd/6J+WlCINhp97XNGTiHiF5wnPa8mQp+MN7Is=;
        b=i4LDMwlaGWcf2pLIF1NVjAA8yZMPP0LknNaZW6RXcWdRZlRI+cJQc+9Cy01Mbb+bir
         74DvKWKbK0kRQHifsoUy6/69X2lb0AVV/Dn92CxwkajuqRifuugLiglrFdAdkPE3DLbL
         StN6t3Iy5xPsUQumJuk7V3BUcnQ0mg7arR+DFDrc4RH0FFIrcHOpbX/NWlqR/gB/AknM
         JSv9wgW/4U8Y5iRLe/KWNzASl2G9CVvQMFpiB4yPozBEx/Bh13szaGOnFMMBYPTN4v1+
         m1Kqpj11qU4tUh1aB7SnU1au5cby7EGB0W8+/XjR4nomHUY7Z6Jb9DNHRiwhuVmfjV5P
         /lpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JV+VaWd/6J+WlCINhp97XNGTiHiF5wnPa8mQp+MN7Is=;
        b=OR7h8arJurQUFt+UuHMOxHfL/ivYMfa4fg76mFlXgudao2X9ABPU6OFWzVqMnLwHsa
         7JT6McZYG85blsdaSRywf2B00Tdo4ww81CkFy5X4ZdIZWULpjRmeKBz46vyJqmbJcV/9
         uIm0dKdda4dLo4gaBgsloNwbFFvzpWhqW+nVHjKCsCYt5qV5J4L+lvL64K2bNaxkFbQX
         CyDfirWYSA/SBKUFkOhhUzhJTLJdyab/TzxDDS/WsqHqw2nCBjWM7rRV8jJt5gY35ozy
         m0kx2gcflTVsVq3W5FW4aPl2pd9sgtEtylv6RfHJCvvxxudacNiliKroKiRr5WgKIdhW
         XmOw==
X-Gm-Message-State: AOAM532C1IuF/uQROwqpy8f/NNyRdh5qMPzA6vbQzfg9SQhNmHiUkbXp
        fbB/cUStXtL7mBZ7uFb481U+Blhmajr8mrFOlXc=
X-Google-Smtp-Source: ABdhPJwnOZfwomqQLP47SXqjSomfpfwSWMzgtsrfhvtTsviwvCR1RLwYsGzSDk/gJLpB1o9e900D7wZiInb2OAHghgQ=
X-Received: by 2002:a05:6512:3709:: with SMTP id z9mr17731964lfr.182.1625717115123;
 Wed, 07 Jul 2021 21:05:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210707223848.14580-1-john.fastabend@gmail.com> <20210707223848.14580-3-john.fastabend@gmail.com>
In-Reply-To: <20210707223848.14580-3-john.fastabend@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 7 Jul 2021 21:05:03 -0700
Message-ID: <CAADnVQLUDh1vJGc8sC2_uaY2uEQU_DeHdaMbNx9VhOMbSH-Ezg@mail.gmail.com>
Subject: Re: [PATCH bpf v2 2/2] bpf: selftest to verify mixing bpf2bpf calls
 and tailcalls with insn patch
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 3:39 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> -static volatile int count;
> +int count = 0;
> +int noise = 0;
> +
> +__always_inline int subprog_noise(void)
> +{
> +       __u32 key = 0;
> +
> +       bpf_printk("hello noisy subprog %d\n", key);
> +       bpf_map_lookup_elem(&nop_table, &key);
> +       return 0;
> +}

This selftest patch I had to apply manually due to conflicts.
I've also removed the noisy printk before pushing.
I verified that I saw the spam before removing it.
The patch 1 looks great. Thanks a lot for the fix.
