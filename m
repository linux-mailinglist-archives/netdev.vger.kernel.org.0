Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E581A3A3C36
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 08:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhFKGuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 02:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhFKGuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 02:50:01 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EC0C061574;
        Thu, 10 Jun 2021 23:47:48 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id h16so5150834pjv.2;
        Thu, 10 Jun 2021 23:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZY03pMXXYOjF4yQ1kl+6a46AcEo8IDBYUKTzMqVVkg8=;
        b=OhdZ/ZTCryKdOU+hK+w2+Ew6ptxZ8xvEThONwgLQDnin9ZLPUALexYKVfFd8OhH0Sr
         H6AbV23HJP3zfHgaKgZObVO58rtzvyjIygDU+Fmbd9OD3OMkD7u2e/zTEVqj1VmLwNdK
         YqQadp9kMtcJv+aEr39wF7YNdctiY/Sb5njx9ZOfs39uue1hcmKt3DGZcI1qc5lDxYi6
         w4FNTCOf+VoXJXaReY87xPdOy7TPSdbHV6uFJ2gCWjs2xBT7wp+0GuziLirpV/DSt9ck
         GTdVz9EPg2gFGMiSy7GGybSUTL80BfeuWhFw7azd14rgKD3MYfqkBsO0cB4HVYDN/9S7
         FV0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZY03pMXXYOjF4yQ1kl+6a46AcEo8IDBYUKTzMqVVkg8=;
        b=Vcvmpt0FyOCk0UCZ27kyQ95BPxvUgEaaHK723Jw4srWsnzmItfCEw/VVAV7K/wHgq4
         ROxnr9bBFRxUsMUs/ymahwHHmj7UBZO56k8w98a8bKuUeXMYo2ur/6GYCvpN0xWolDw8
         xNHM+7d+VHp5JU0AAiEqYoBJDwUZJNMJOv8O48dn2fixG46ZNqXdy6MeBBrxO+Z+FuYy
         Z2wXyBesMtusGCe7rb4vb/x34patlJmZOZ1XGrFFxX5PMecORKqzdX8aSVFme90z4CFq
         XD7sUb6MF/i45YnnKqpGKLh+fRxqMn/zDRP8v9U+pVi4VDe2VzQpY4uujE/8BUlRADx9
         Fz2g==
X-Gm-Message-State: AOAM531R118hNMglV37psNo15FadnRjSKAaPg5YDEQdPP+4zZFwNTNlc
        GFCCsHHXYXkUXOrGi5rkIcIjHDhVQrDVPBdHZEI=
X-Google-Smtp-Source: ABdhPJxI5Lganc7aq7tkinhttx8NVFW6lv/6t1sq6hNzHT+GEsUaFydQvgNOUP1ovtG+9g94flv5hQafBpFz6AOop3Y=
X-Received: by 2002:a17:90b:190a:: with SMTP id mp10mr7745745pjb.145.1623394068465;
 Thu, 10 Jun 2021 23:47:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 10 Jun 2021 23:47:37 -0700
Message-ID: <CAM_iQpWwGNnVtdUdnMp4P2pazp5te-rHEXMU7h-9KYg27BM1tA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/3] bpf: Introduce BPF timers.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 9:26 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> v1->v2:
> - Addressed great feedback from Andrii and Toke.
> - Fixed race between parallel bpf_timer_*() ops.
> - Fixed deadlock between timer callback and LRU eviction or bpf_map_delete/update.
> - Disallowed mmap and global timers.
> - Allow bpf_spin_lock and bpf_timer in an element. One of each.
> - Fixed memory leaks due to map destruction and LRU eviction.
> - Add support for specifying clockid in bpf_timer_init.
> - Make bpf_timer helpers gpl_only.
> - Fix key pointer in callback_fn when bpf_timer is inside array.
> - A ton more tests.
>
> The 1st patch implements interaction between bpf programs and bpf core.
> The 2nd patch implements necessary safety checks.
> The 3rd patch is the test.

What is your use case to justify your own code? Asking because
you deny mine, so clearly my use case is not yours.

And more importantly, why not just use BPF_TEST_RUN with
a user-space timer? Asking because you offer no API to read or
modify timer expiration, so literally the same with BPF_TEST_RUN
approach.

Thanks.
