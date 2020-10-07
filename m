Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E508328666C
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 20:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgJGSBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 14:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbgJGSBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 14:01:16 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3A4C061755;
        Wed,  7 Oct 2020 11:01:14 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id 67so2477740ybt.6;
        Wed, 07 Oct 2020 11:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aPRSKR2vmaXTos7k2HTwipXe3QT+VpayPdVEBKBQmuo=;
        b=PI3K6itkIeDPSELREIeGLkhCZSZjdM1crAEOTjYZS05rXZ/Ro5CVWMSSKQGTEjWIQ/
         RXv34RksrkjZdYagTLt+VKlkYzX/oqjpNFILVJiN5uWsAJoMFwQdTww/abadfNlOnHpG
         JvsZFHs2xWUwX7ULNO43DL9L4SjvLpvpwbvjx0A+6RoE1tB2sXhWkZmeGh5bqxVWIV3b
         BzoPeW72TJ4k1NGOoF1s9nKp9rR6CQojBVqkWfDX0rGsJbldae6K0DLuRd+0GDGbHWMV
         QTe+j3Do+g6LrnL0zFUSk+/Rtf/E+9VEApYvsJ6PyOtWnLHhi1gkP2yGJUNhF2zAT115
         drAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aPRSKR2vmaXTos7k2HTwipXe3QT+VpayPdVEBKBQmuo=;
        b=ANvnraEIX8kofQ9zHKRnbAGUyliyTbO0YSGCP7C0lSmXp06p5dDW3hXnTzRo7A7swd
         jQ7LDsSjyAQ3LVxLLXQx6VRa5g35yNFjdFRF613eLc7oK3OSygsSc/bPL2QkJYYky5eZ
         NvKpF8pJHHbIGyqNTujKnkx40RahzcMs8Mj/o/mUpqRRg9ZxJafFUZtP/ncBqeFf7wlq
         lQjQyDgU1tFwQRpBgUsxXDNLTnVCmCQO6azQMQ6Fg1Xm6RM9N//0443NmCo7UULuZdGo
         wSlNFAiOsWExLEysKmPNPSjJyK8lVFsU/0xc7UeT0/g5ex1ntTBhmEGi7ZRrvl+hdrEl
         BXeg==
X-Gm-Message-State: AOAM531+tiNeoVu9hsfa0Eq0iFQFZkxTmeIiljAecDKoxX623oPmSMI4
        r6uNuEY5GMA0slmWUp5RUh8eMUSNT8l5E5sXh5Dz1rsWQJ0=
X-Google-Smtp-Source: ABdhPJxBMVsv92twl+NOia4bCYSE4F0Ryo24Y43Mngj7UdOyWIdpf0VAmJifSRwnbHAYY02DwS3slvQ8lkhOUW8H0rU=
X-Received: by 2002:a25:2596:: with SMTP id l144mr5595715ybl.510.1602093673699;
 Wed, 07 Oct 2020 11:01:13 -0700 (PDT)
MIME-Version: 1.0
References: <20201002010633.3706122-1-andriin@fb.com> <CAKQ-crhUT07SXZ16NK4_2RtpNA+kvm7VtB5fdo4qSV4Qi4GJ_g@mail.gmail.com>
In-Reply-To: <CAKQ-crhUT07SXZ16NK4_2RtpNA+kvm7VtB5fdo4qSV4Qi4GJ_g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Oct 2020 11:01:02 -0700
Message-ID: <CAEf4Bzb7kE5x=Ow=XHMb1wmt0Tjw-qqoL-yihAWx5s10Dk9chQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] libbpf: auto-resize relocatable LOAD/STORE instructions
To:     Luka Perkov <luka.perkov@sartura.hr>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Tony Ambardar <tony.ambardar@gmail.com>,
        Juraj Vijtiuk <juraj.vijtiuk@sartura.hr>,
        Luka Oreskovic <luka.oreskovic@sartura.hr>,
        Sven Fijan <sven.fijan@sartura.hr>,
        David Marcinkovic <david.marcinkovic@sartura.hr>,
        Jakov Petrina <jakov.petrina@sartura.hr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 7, 2020 at 10:56 AM Luka Perkov <luka.perkov@sartura.hr> wrote:
>
> Hello Andrii,
>
> On Fri, Oct 2, 2020 at 3:09 AM Andrii Nakryiko <andriin@fb.com> wrote:
> > Patch set implements logic in libbpf to auto-adjust memory size (1-, 2-, 4-,
> > 8-bytes) of load/store (LD/ST/STX) instructions which have BPF CO-RE field
> > offset relocation associated with it. In practice this means transparent
> > handling of 32-bit kernels, both pointer and unsigned integers. Signed
> > integers are not relocatable with zero-extending loads/stores, so libbpf
> > poisons them and generates a warning. If/when BPF gets support for sign-extending
> > loads/stores, it would be possible to automatically relocate them as well.
> >
> > All the details are contained in patch #1 comments and commit message.
> > Patch #2 is a simple change in libbpf to make advanced testing with custom BTF
> > easier. Patch #3 validates correct uses of auto-resizable loads, as well as
> > check that libbpf fails invalid uses.
> >
> > I'd really appreciate folks that use BPF on 32-bit architectures to test this
> > out with their BPF programs and report if there are any problems with the
> > approach.
> >
> > Cc: Luka Perkov <luka.perkov@sartura.hr>
>
> First, thank you for the support and sending this series. It took us a
> bit longer to run the tests as our target hardware still did not fully
> get complete mainline support and we had to rebase our patches. These
> are not related to BPF.
>
> Related to this patch, we have tested various BPF programs with this
> patch, and can confirm that it fixed previous issues with pointer
> offsets that we had and reported at:
>
> https://lore.kernel.org/r/CA+XBgLU=8PFkP8S32e4gpst0=R4MFv8rZA5KaO+cEPYSnTRYYw@mail.gmail.com/.
>
> Most of our programs now work and we are currently debugging other
> programs that still aren't working. We are still not sure if the
> remaining issues are related to this or not, but will let you know
> sometime this week after further and more detailed investigation.
>

Ok, great, thanks for the update.

> Thanks,
> Luka
