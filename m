Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAAC196FD9
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 22:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgC2UOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 16:14:06 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41498 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727606AbgC2UOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 16:14:06 -0400
Received: by mail-qt1-f193.google.com with SMTP id i3so13396444qtv.8;
        Sun, 29 Mar 2020 13:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=V9/YiousU3cFLlbSDBU5cLChHej2btokTY5DS/F3EDo=;
        b=YBVntn9W3uR2Hr6KMbpgQfjW8HSST8C1kTwxXURki6fn3SS6N5MgHGBrVyfOmr6Gnz
         6A9JYSka3RYlyjxji0zXYFW5YWvC4WVgZFXuCEsIwQSH2fngyD0iS+AlmKPQgEyYZTIv
         DrQ2ISVPpR/+VQEad2L6/Qssd/qjEqQOliGPlPCUfduINr1mxuapx+OpYY3F2BYfuHwN
         Z7SaKk4gnr4Ochay5IHMc2SfDtx5eZrVpu5sUyVtdG77q4ke4O1wOw5bN9uyd4efWGc1
         3HJipgjidkZGM/mKhHKY9NxYG32kie/YUDQs/0OLY776qTfOCa0Xu37Xi49d8Q789UG6
         lUew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=V9/YiousU3cFLlbSDBU5cLChHej2btokTY5DS/F3EDo=;
        b=L45FGh8Q5r0KS5oSs9R74NPZ7+nlUi1xvsImbGDl+8Amce6JCcVLJswWNL3YVqwYEc
         n3EQMM/Yh8BhkKl00PFJpA5aQQDtYcI9wV394jY6xMASRnokTjBg9yPne4pNhFsNbqqL
         bI3D6tYfOm0snHMIM9Gzp/uDl4t2n9Rd15I4SOuNO4YX2cMOa5/wvc86NGEnhQDAzwWw
         5O/JZdKqvc79xWsFgfV5J7HPU3JGsizfFwjXVgvNCAfaE5RQQS1X8ras2+MIvretiiOV
         M56c9TZp6dSjsrZpkWcY3BxPuU9XIcH7N/yL2sWF2aQsA7mfuZzKtARkIu3mZ/wi9rek
         D7Yg==
X-Gm-Message-State: ANhLgQ2J/0lGmZMQiLv4rr8XWMW36+mipEgOxcQnGSwoo8EnLIUlaCoq
        Ac5eR0jgUhQ8h2JOqS0OHYWMP6H66JRIsvBjIE5Gz5re
X-Google-Smtp-Source: ADFU+vuIyMQmdGYyF5yaa0KOlo5J6IlpSFfCBzWyJcvovssgX0Opo+Ex3fVZkukn+SqdclA4TrP2DfUTH54cpn5CV/M=
X-Received: by 2002:ac8:6918:: with SMTP id e24mr8786477qtr.141.1585512843429;
 Sun, 29 Mar 2020 13:14:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200328182834.196578-1-toke@redhat.com> <20200329132253.232541-2-toke@redhat.com>
In-Reply-To: <20200329132253.232541-2-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 29 Mar 2020 13:13:52 -0700
Message-ID: <CAEf4BzYNO9bS98VPm4xhB3VRN53zWMmfAhE11bqeq2oz-NcfkQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] selftests: Add test for overriding global data
 value before load
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 29, 2020 at 6:23 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> This adds a test to exercise the new bpf_map__set_initial_value() functio=
n.
> The test simply overrides the global data section with all zeroes, and
> checks that the new value makes it into the kernel map on load.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

I guess given you don't attach or run any BPF program, it's fine to
reuse test_global_data.o for this.

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  .../bpf/prog_tests/global_data_init.c         | 61 +++++++++++++++++++
>  .../selftests/bpf/progs/test_global_data.c    |  2 +-
>  2 files changed, 62 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/global_data_in=
it.c
>

[...]
