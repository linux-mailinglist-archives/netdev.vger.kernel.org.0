Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661E7253D23
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 07:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgH0FOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 01:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbgH0FOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 01:14:43 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FDAC061240;
        Wed, 26 Aug 2020 22:14:43 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id m22so4959120ljj.5;
        Wed, 26 Aug 2020 22:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j2EiiOVQtIuXtayMjxk185GJittEj1l4xRc5OheFlLc=;
        b=IGwkKuXAFLgSaBq7s6s4VR2vr7rYJAQNBcrY6e2wmx+r7Z9nQ3EuxIVcYfgz0cjBxW
         VjBI1ULtfCrvsfsD6mwRcl4iiO0LR+KsdmZM7Xg1ROHM1JHqan/LipqWYzk9lDzjvNVV
         z3MhD3fhQMGQCPJiO7h956ZOBzSiN4NR+5IbH42yrQqn/Gbexmw+8zCGRXGry2Bujk20
         eV8teDJZt0C20uCxcfvG0Rrd2xLArorKuSZOYB00tba6Rj+Qql7Rqf+XI+t45ijODGrk
         GwnHzE7yCtR5Ry7ev3lDoYCRoMP4ih9Idaf5IL+0V5DNvLXWtHpTcAFcyZzYGDgjOYbc
         VfMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j2EiiOVQtIuXtayMjxk185GJittEj1l4xRc5OheFlLc=;
        b=pA+daul61AFhWX1z27UxF+oMYK7IyPKIg/zBllCelNGG/SAM/p08ASWgBSAAAl5T+q
         WZWZVT+Z3Q0FUE0tryesyumQrG/7YYrjCcayQX4/TaE9yxCgj0ufBzCod3k+XnSN8ENv
         GV6fukaS4RnNRozBSx4j7rEpKp98+TRctyK6+ECmXMw7uGOyP8oiITJ6sVs41vOG6d7p
         Y2aYhWpEAH9VJrQicDh4m55PJJu4wgveH5a3B2MKMy5OrW95vaETDlawik4YONRvA3CI
         7Jp03L+0/PwWFHgOiwiOM13RQa198nEXb6EIxrM8d00lTBpCPVdbxSmfP8s4NgKVLMqW
         Gssg==
X-Gm-Message-State: AOAM532svvsmP9Q9J6Y17xC83zLNNWi6bF6RF95eGTvCkv0JgTIzVHsx
        3RXDvnQOzRCyTpwwydbGUoLWrK2yXKVctwxQjHg=
X-Google-Smtp-Source: ABdhPJw4QIGwfZbzPrRlqpg6bzzjkaoQpkuojXuYXcKBBp3SclRwIPtK4grKtZl3C3xn+ct3ikCpz0GwdW7Nn31i5aU=
X-Received: by 2002:a2e:b6cd:: with SMTP id m13mr9128000ljo.91.1598505281404;
 Wed, 26 Aug 2020 22:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200827041109.3613090-1-andriin@fb.com>
In-Reply-To: <20200827041109.3613090-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 26 Aug 2020 22:14:30 -0700
Message-ID: <CAADnVQ+jE8iUqB4mdPA58JQmNow08LGFkemC2BbTb+TYvJ2K1w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: fix compilation warnings for 64-bit
 printf args
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 9:13 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Fix compilation warnings due to __u64 defined differently as `unsigned long`
> or `unsigned long long` on different architectures (e.g., ppc64le differs from
> x86-64). Also cast one argument to size_t to fix printf warning of similar
> nature.
>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Fixes: eacaaed784e2 ("libbpf: Implement enum value-based CO-RE relocations")
> Fixes: 50e09460d9f8 ("libbpf: Skip well-known ELF sections when iterating ELF")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
