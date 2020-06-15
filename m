Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605EB1F9FFC
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 21:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731374AbgFOTLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 15:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbgFOTLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 15:11:34 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C06C061A0E;
        Mon, 15 Jun 2020 12:11:34 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id c14so16801319qka.11;
        Mon, 15 Jun 2020 12:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rdkpIsIw6sRIoGnuOlulGFCOXMxUltM2VCp1RbU21dg=;
        b=iTbRo0q8FVkocB7ftDkONGmUYqNUIaF5aixAH33JB6cA3BpBLq8mUH2P05gbV+mD+5
         +1hqspa9jCav+K4LYzZTDcu8yIvSew2jO3bOQFIQ0B/N7lGxaf0mp8uF0rwOa0mDFD9X
         8sN1O6hdZQCY7O7uj4AfkTLge9tiBUVSjcB+ehx1RBYv7sZ1TMJECfOdWWR9kowJgcSY
         9E3R+4ErJly+BRkXLb7VSJ/rLa/MA32yUajxPDrbtCqbemV4C+YTeflCke08QSdkWgTp
         vOVcse2xxtrhTN3nuhiJrBG6ZnCiYj573kdAr9cpzGl7J9494r9BDrGOI5NWgMhSjz++
         kUHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rdkpIsIw6sRIoGnuOlulGFCOXMxUltM2VCp1RbU21dg=;
        b=Vo/IDYIo2RQPAIr2U87Lbqd7O3GB2mP2TLIqyiEw9OuGPIZ+cTKavd3NsLOeZ99HnT
         ZTqzXGQEtQIZSB6P7S8hKUIfWXoE4DV2MWZ//pBeNPOgO85FM1cXsI0N0iVY6p8Rsx7z
         dnDG/INZnl/9dJp1b/hLjbrGyBscRd1GCEKF5rzRj6HgdF/RNrqc3BZc3R1llAB2E2Cf
         Z2A/pWG+4ORVglotO+SpST4/r9zIdEGLc7d4GCGqpOr9HzViiJGMMrn9XjxdbFIa0X/s
         CSd+eMRZrmri1m6O5qH1e8yAlTwA6Z1H912kFb4fxDAZRf8MslsPM9DSAM/r1G7IzLma
         RTzA==
X-Gm-Message-State: AOAM531ahRLAaPvdstI5bEwlgRqp8HNlS5NBuE54tDSfydkJJUQw2hJX
        N9s4d1wniX0Ke7skvcI7byVr+XowN68nhOHwMFA=
X-Google-Smtp-Source: ABdhPJw22D438K5vly+hM9sl/edTx+Uc9e1F++PayshnqRM6JUYbgqIJfTcq8m9Iie5bdXGN5wk3uWagtlOBcmj2STc=
X-Received: by 2002:a37:6508:: with SMTP id z8mr16940330qkb.39.1592248293220;
 Mon, 15 Jun 2020 12:11:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200612223150.1177182-1-andriin@fb.com> <20200612223150.1177182-4-andriin@fb.com>
 <CA+khW7jxdS1KRpk2syVGjDqbyn3wAd3Eh_LEMAEhkPUehuXMwg@mail.gmail.com>
In-Reply-To: <CA+khW7jxdS1KRpk2syVGjDqbyn3wAd3Eh_LEMAEhkPUehuXMwg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 15 Jun 2020 12:11:22 -0700
Message-ID: <CAEf4BzbQBNnNV2rGOJHUs1Yh2Njqu5bEtB_DsgF9AOruGorKHg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 3/8] selftests/bpf: add __ksym extern selftest
To:     Hao Luo <haoluo@google.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 9:45 AM Hao Luo <haoluo@google.com> wrote:
>
> Andrii, a couple of general comments on fixed_percpu_data.
>
> I think it would be better to check the existence of fixed_percpu_data in=
 kallsyms first. If it's not there, just skip, or maybe warn but not fail.

fixed_percpu_data is always there, but I missed the fact that it's
x86-specific one. I'll switch to some bpf-specific symbol (e.g., like
bpf_prog_fops or something along those lines).

>
> Further, if we really want to be sure that  fixed_percpu_data is the firs=
t percpu var, we can read the value of __per_cpu_start, which marks the beg=
inning address of the percpu section. Checking the address of fixed_percpu_=
data against __per_cpu_start rather than 0 should be more robust, I think, =
given that fixed_percpu_data exists.

There are assertions in Linux sources that fixed_percpu_data is 0, so
I don't think that it necessary. But it's a moot point, as I'll use
something less x86-specific.

>
> Hao
>
> On Fri, Jun 12, 2020 at 3:35 PM Andrii Nakryiko <andriin@fb.com> wrote:
>>
>> Validate libbpf is able to handle weak and strong kernel symbol externs =
in BPF
>> code correctly.
>>
>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>> ---
>>  .../testing/selftests/bpf/prog_tests/ksyms.c  | 71 +++++++++++++++++++
>>  .../testing/selftests/bpf/progs/test_ksyms.c  | 32 +++++++++
>>  2 files changed, 103 insertions(+)
>>  create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms.c
>>  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms.c
>>

[...]
