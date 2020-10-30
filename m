Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328A229F9D9
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 01:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgJ3Aj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 20:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ3Aj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 20:39:56 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE3AC0613CF;
        Thu, 29 Oct 2020 17:39:56 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id y17so5047634ilg.4;
        Thu, 29 Oct 2020 17:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yZnOjRgB/c43lsals/+DEM4gRXJ6X/fANm5gDe0g+8A=;
        b=vbWKj5Ps1IwqjXpX9wQFw6SK9yjzQzVSw3QwZCcjs5XT0JNWL4TGI0E/hDn7op0o2J
         rtvKVheXhvrUC8eLOCgVCe38iyI9bpUz5y255ojpHBdYLx7qFPU2C/Q5koLmifSGb3FL
         CtGXZCdm1CVOFNMosnnyMAMCjKcI62hPgU+ZvvPWzEppc4TXCQRBq9Tqhf9wveMlI1lC
         7rpaUv2RTCs+f8+wH+UlQuilNCEXdnRo9iXA7IWlVXwuNEiXSFFo2ujTxZsVarwY+mXJ
         WABOrr8I5t/RfZSUxEct8o9dQFI9QeO0e3bAses4WHP7lV8pBkWZGV71iCxn54/eKDkH
         bK8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yZnOjRgB/c43lsals/+DEM4gRXJ6X/fANm5gDe0g+8A=;
        b=s7xoWqeNBtJz/sEh62WNrVZ6IqYvPXWZbyZdrSkQ8Ux8jK27d93cvZEBf/Vaa1GlaC
         Xq2gSKlnKFKikQYX7pYfJQgfOrbxiM5d/vNcEwvBjP5mzjWWxLJWkDWeYzPKEKKQPh5k
         w3HtrdXgcwVAssTNw5d0fy1DGKogLD5FoeIhJ7YB0iH8CKmQa9yfM9X+dE439Cr45XaD
         UtBh155zNjdoPpfmNBqjQwe0yateh22KuMV4cXPULeJOcJgoELLtoOumpSpHl7BUXg9i
         y2odlVZmNgZW8p/eaDGZPAW4kqFwsyv4WpOjtkSFgHoSnQ7pVMM5n9iKgSKLORvESxil
         e4yw==
X-Gm-Message-State: AOAM53181PeP6f6I0kN3BLGQcTRNOx6FGeZmT6zninRxBkSENPKYLJGZ
        VEEqtRSByioyeX3SVrJzCh3uIooDFpV/FlavOGQ=
X-Google-Smtp-Source: ABdhPJxmM2AUBi9UjcBbUj4zZKDfZXLd5XqbzIxFHxtHCahZbyCJ187i+yEOdLgnT8za4WvQxHX2w3DxBn7lWqAV32w=
X-Received: by 2002:a92:950d:: with SMTP id y13mr72110ilh.42.1604018395320;
 Thu, 29 Oct 2020 17:39:55 -0700 (PDT)
MIME-Version: 1.0
References: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
 <160384962569.698509.4528110378641773523.stgit@localhost.localdomain> <CAEf4BzZxevcUHurBQ49006g87CzztDdWn6pWZRWzpL+_97R4qg@mail.gmail.com>
In-Reply-To: <CAEf4BzZxevcUHurBQ49006g87CzztDdWn6pWZRWzpL+_97R4qg@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 29 Oct 2020 17:39:44 -0700
Message-ID: <CAKgT0Uc35p7cgzgcw2--wfqMofBXHpr42uwhfOd1S1RT=VzcRw@mail.gmail.com>
Subject: Re: [bpf-next PATCH 1/4] selftests/bpf: Move test_tcppbf_user into test_progs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>, alexanderduyck@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 4:27 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Oct 28, 2020 at 4:50 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > From: Alexander Duyck <alexanderduyck@fb.com>
> >
> > Recently a bug was missed due to the fact that test_tcpbpf_user is not a
> > part of test_progs. In order to prevent similar issues in the future move
> > the test functionality into test_progs. By doing this we can make certain
> > that it is a part of standard testing and will not be overlooked.
> >
> > As a part of moving the functionality into test_progs it is necessary to
> > integrate with the test_progs framework and to drop any redundant code.
> > This patch:
> > 1. Cleans up the include headers
> > 2. Dropped a duplicate definition of bpf_find_map
> > 3. Replaced printf calls with fprintf to stderr
> > 4. Renamed main to test_tcpbpf_user
> > 5. Dropped return value in favor of CHECK calls to check for errors
> >
> > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> > ---
> >  tools/testing/selftests/bpf/Makefile               |    3
> >  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |  138 +++++++++++++++++
> >  tools/testing/selftests/bpf/test_tcpbpf_user.c     |  165 --------------------
>
> Please remove the binary from .gitignore as well

Okay, I will update that.

> >  3 files changed, 139 insertions(+), 167 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> >  delete mode 100644 tools/testing/selftests/bpf/test_tcpbpf_user.c
>
> if this file is mostly the same, then Git should be able to detect
> that this is a file rename. That will be captured in a diff explicitly
> and will minimize this patch significantly. Please double-check why
> this was not detected properly.
>
> [...]

I'll look into it. I hadn't noticed that the patch it generated is
different then the one I am looking at in stgit. When I am doing a stg
show in stgit it is listing it as a rename so I suspect it is a
setting somewhere that is likely assuming legacy support or something.
I'll get that straightened out before I submit a v2.

Thanks.

- Alex
