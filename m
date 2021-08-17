Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBA53EF018
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 18:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhHQQUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 12:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230329AbhHQQUO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 12:20:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7362D60FDA;
        Tue, 17 Aug 2021 16:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629217181;
        bh=iUlO3PuGFNltUnMT3WDkXLiBGlayG2bvatslX30u5/Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FMc1EjOmFu2ho4EYKLvznnMRTP9XqvazGbd0GSlDtI8gXyRfJVUE/VSBUkUw2Rb0Z
         34oQugx+x+0tKgcVZSrqTjjJWKrtkLTf1+JZq8x/y6hlu7kgeUh1P732zT+lInXROf
         mxVvIRszu9hdq8MR1hkiBFUuBUi82MK0v9AfhXBRF3G+CYsl91fmonb+c/ws12u/I/
         c7j/GPToJ4amCnV8tFVQAYYXyG2LEowvZim4leStznNPbA/G47GRwnVzte//531mpT
         jDPdjtyqiQXYXtD86mDv53TybSppvxypvrLFu7jA7PEuBoUMZeJnDRneMYwPL/9VaO
         AJQ5a5eJjd44Q==
Received: by mail-lf1-f48.google.com with SMTP id x27so42428477lfu.5;
        Tue, 17 Aug 2021 09:19:41 -0700 (PDT)
X-Gm-Message-State: AOAM530Avd6qimpF6gkXcoR53ObrFpwdEaRa+CoWZs8PF/shccINp42u
        ld0xazQl4gIaIUis0gLl5YFZZxZ4qdHSi/+0ANg=
X-Google-Smtp-Source: ABdhPJwxt+CYiX94xy4tpC44j6dME09jjH6K1B0m2gKcGRDsdK/IFUjLOuJFv9aJxSZhggHHTx5WuSzs8MfNIfdH8Jg=
X-Received: by 2002:a05:6512:3b3:: with SMTP id v19mr3085875lfp.10.1629217179810;
 Tue, 17 Aug 2021 09:19:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210817154556.92901-1-sdf@google.com>
In-Reply-To: <20210817154556.92901-1-sdf@google.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 17 Aug 2021 09:19:28 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7O+rC6gw_YQjDQbswWA5OSd+dE9EuuJ9pPyxnrsUv+ww@mail.gmail.com>
Message-ID: <CAPhsuW7O+rC6gw_YQjDQbswWA5OSd+dE9EuuJ9pPyxnrsUv+ww@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] bpf: use kvmalloc for map values in syscall
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 8:46 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Use kvmalloc/kvfree for temporary value when manipulating a map via
> syscall. kmalloc might not be sufficient for percpu maps where the value
> is big (and further multiplied by hundreds of CPUs).
>
> Can be reproduced with netcnt test on qemu with "-smp 255".
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Song Liu <songliubraving@fb.com>
