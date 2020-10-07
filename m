Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F81B286657
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 19:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbgJGR4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 13:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728469AbgJGR4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 13:56:54 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28F9C0613D2
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 10:56:53 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id l16so3116485eds.3
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 10:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yq0DVe/5LgoLrafjHe5mSCSMY2VmvWajHz+tFb+u+28=;
        b=oScKh8bZMM3GwPgMgh7e2mKJhr/RDvlD19fy2Gj2ia3yiv2+DyknsuBoaQ/yb+iQ/U
         MNY1sN92FN5Ds8fDHALJCTF5iANzNB8YW3Uq/UAlumTnS3fGGPzpnCuorZPybU6+cU1j
         D10/iiEXaclvPB7S+za1DzRBh2oHw+13TQwaifDTruG1DJwFzBcjfbywIP1LpuBGjToi
         dVJ+fgXQJHjmKApvE0XsZAmkJh55qGjFazjTkW2apKR3p6fXg2Ozc0SFVNKGJyZNBAe8
         E6orRzaeM1WYP+NDqUDJj8i/wY//NaFAtECitNQRlTrJCyFp/TUqjbCvJZmLAUYysFBr
         FKlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yq0DVe/5LgoLrafjHe5mSCSMY2VmvWajHz+tFb+u+28=;
        b=I9V3wK9tut4L+rdEJ8L3M3bW7l4tEzfKmtrPTh+OUHa3PG5Vdx5VphBSYus4k5goft
         pPtkhLKDstR6lucqxUVCIi55nSWz0DjFaZLQVCJ1IjWT7awayCNZle+erE99wDT0g+J4
         pkBPQDLEMSCBZthw9SwvlK7CejofIREL/4uW+3PUD/F9T/uusMGOOAhnFFPR0OaBn/lW
         dYgz5vydKcW2iwMpaLgNn0UW9ddEo74TpsFocOBhD5i9ZnL38XNw8UGIyrZ+SJHIE7Ne
         /oZeQ13u4PGmti3sSukahL+doh5zsWK01LsJhAiL+dVw/YXCOX4ko2eXjAlBODhQeKos
         o7LQ==
X-Gm-Message-State: AOAM530/XKK1psry89BNtbzupK/ulxjl7Zyl3c1dCnT71VGcuZJs+LGA
        Chfg5kPn3QC59rebzrH71AlZepTSIUViNTJVLMz7/Q==
X-Google-Smtp-Source: ABdhPJypFgCtTmiEsHsp4FHdHKWX2PNLBOZVBMZUj4SJiIzZ7yQhnSakPNBmUJIcdCZfG5T+UAo5oI9dspZwEexZcJ0=
X-Received: by 2002:aa7:ca52:: with SMTP id j18mr4624038edt.147.1602093412081;
 Wed, 07 Oct 2020 10:56:52 -0700 (PDT)
MIME-Version: 1.0
References: <20201002010633.3706122-1-andriin@fb.com>
In-Reply-To: <20201002010633.3706122-1-andriin@fb.com>
From:   Luka Perkov <luka.perkov@sartura.hr>
Date:   Wed, 7 Oct 2020 19:56:41 +0200
Message-ID: <CAKQ-crhUT07SXZ16NK4_2RtpNA+kvm7VtB5fdo4qSV4Qi4GJ_g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] libbpf: auto-resize relocatable LOAD/STORE instructions
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        kernel-team@fb.com, Tony Ambardar <tony.ambardar@gmail.com>,
        Juraj Vijtiuk <juraj.vijtiuk@sartura.hr>,
        Luka Oreskovic <luka.oreskovic@sartura.hr>,
        Sven Fijan <sven.fijan@sartura.hr>,
        David Marcinkovic <david.marcinkovic@sartura.hr>,
        Jakov Petrina <jakov.petrina@sartura.hr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrii,

On Fri, Oct 2, 2020 at 3:09 AM Andrii Nakryiko <andriin@fb.com> wrote:
> Patch set implements logic in libbpf to auto-adjust memory size (1-, 2-, 4-,
> 8-bytes) of load/store (LD/ST/STX) instructions which have BPF CO-RE field
> offset relocation associated with it. In practice this means transparent
> handling of 32-bit kernels, both pointer and unsigned integers. Signed
> integers are not relocatable with zero-extending loads/stores, so libbpf
> poisons them and generates a warning. If/when BPF gets support for sign-extending
> loads/stores, it would be possible to automatically relocate them as well.
>
> All the details are contained in patch #1 comments and commit message.
> Patch #2 is a simple change in libbpf to make advanced testing with custom BTF
> easier. Patch #3 validates correct uses of auto-resizable loads, as well as
> check that libbpf fails invalid uses.
>
> I'd really appreciate folks that use BPF on 32-bit architectures to test this
> out with their BPF programs and report if there are any problems with the
> approach.
>
> Cc: Luka Perkov <luka.perkov@sartura.hr>

First, thank you for the support and sending this series. It took us a
bit longer to run the tests as our target hardware still did not fully
get complete mainline support and we had to rebase our patches. These
are not related to BPF.

Related to this patch, we have tested various BPF programs with this
patch, and can confirm that it fixed previous issues with pointer
offsets that we had and reported at:

https://lore.kernel.org/r/CA+XBgLU=8PFkP8S32e4gpst0=R4MFv8rZA5KaO+cEPYSnTRYYw@mail.gmail.com/.

Most of our programs now work and we are currently debugging other
programs that still aren't working. We are still not sure if the
remaining issues are related to this or not, but will let you know
sometime this week after further and more detailed investigation.

Thanks,
Luka
