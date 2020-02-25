Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB23116B6CD
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 01:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgBYAiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 19:38:24 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43374 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBYAiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 19:38:24 -0500
Received: by mail-lj1-f196.google.com with SMTP id a13so12106356ljm.10;
        Mon, 24 Feb 2020 16:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ana9E6RDbo7rTzSG5WwHKKNvS6xH2TdpuyMpSGxZFN4=;
        b=H2ildp0M7mgJdJKcmHBhbaucGhJa8T89hVZrflFxucXKIoVrOwgh+sNl6r1E+03sb1
         tRSnn3QPcxtw+Wo3ga8YEyW+Bc3iqqG2TRaizxeXd4TxLEH1M6fiRBwVH0v2ZMiFC5eT
         7Rm7lzLxoy/A7fiOwLTjgcqF1nSWWm6BsjUuTCC+XJtaBXlDqKoX1cWni2hWK4WhhhOI
         PHPB1SDp6kYqahv0Yffy0o5N7vqc5I0Od8fTJcGdGpHMC7pu7VR1HKNLAivo2vKHJ3+R
         60bggEbFimTNiM+p78dhv8//1T5QOa4fBcwfu5GsaqPH9VpGYJ6PNMc7u+qkP6lWE0SM
         5fNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ana9E6RDbo7rTzSG5WwHKKNvS6xH2TdpuyMpSGxZFN4=;
        b=IYeC4gQuLQKP5pQb3N0jcYF3o298YHX3zqThZ7At+i51VZBAszj4e9SoUFv26KMGeX
         6O6x68EnyRduWtVzAmPtx5cgCVCOnCsjwc/0C/Jk73HgDKXEuy3GRCsz3M4Dt92kGlyW
         pT2R7VQy/4KTnDF2Uc7DVd33VfVJ1E7138LELdma/friuo15YzzlLd0hZ9YHubrEDm06
         6bLFpbe58KkITsfFvFr6JwXa7z+lSOg+4723Aeq3LM3lfeNgBjQxjezhiSvsNEk5g34J
         EKBQCviKI1tQu6M18PzEIjsXl0IDeRWkuwP6jnvA+QmfyAPU75RbfLeVvig1BYBS3bCt
         GveA==
X-Gm-Message-State: APjAAAVAW6WZLqAcnFOu+wNwxqqiGczn7y3cyr+Mxv0YwPIr5KHReooY
        6NP7lOrMm26NBscFkmU9e9En+SMKXpA+q/31Q4w=
X-Google-Smtp-Source: APXvYqx+X7K3kZ5BieGB+2SM/MPwJB73/YSA4gZ2jqBLi5E49EMyyIi7kKcz2iMxW6Hyf65B5KhGFUUfktqDVO6jKP0=
X-Received: by 2002:a2e:b007:: with SMTP id y7mr30440360ljk.215.1582591102202;
 Mon, 24 Feb 2020 16:38:22 -0800 (PST)
MIME-Version: 1.0
References: <20200224135327.121542-1-jakub@cloudflare.com>
In-Reply-To: <20200224135327.121542-1-jakub@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 24 Feb 2020 16:38:10 -0800
Message-ID: <CAADnVQJVzaSZQ+hMY3LbECAMxsV0xQrSqUeubmG8i5shekc1Hg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] selftests/bpf: Run reuseport tests only with
 supported socket types
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Martin Lau <kafai@fb.com>, Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 5:53 AM Jakub Sitnicki <jakub@cloudflare.com> wrote=
:
>
> SOCKMAP and SOCKHASH map types can be used with reuseport BPF programs bu=
t
> don't support yet storing UDP sockets. Instead of marking UDP tests with
> SOCK{MAP,HASH} as skipped, don't run them at all.
>
> Skipped test might signal that the test environment is not suitable for
> running the test, while in reality the functionality is not implemented i=
n
> the kernel yet.
>
> Before:
>
>   sh# ./test_progs -t select_reuseport
>   =E2=80=A6
>   #40 select_reuseport:OK
>   Summary: 1/126 PASSED, 30 SKIPPED, 0 FAILED
>
> After:
>
>   sh# ./test_progs  -t select_reuseport
>   =E2=80=A6
>   #40 select_reuseport:OK
>   Summary: 1/98 PASSED, 2 SKIPPED, 0 FAILED
>
> The remaining two skipped tests are SYN cookies tests, which will be
> addressed in the subsequent patch.
>
> Fixes: 11318ba8cafd ("selftests/bpf: Extend SK_REUSEPORT tests to cover S=
OCKMAP/SOCKHASH")
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

Applied. Thanks
