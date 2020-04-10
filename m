Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D79621A4C57
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 00:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgDJWx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 18:53:57 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40389 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgDJWx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 18:53:57 -0400
Received: by mail-qk1-f196.google.com with SMTP id z15so3717334qki.7;
        Fri, 10 Apr 2020 15:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SGhwCL7nCuI/FVuTMRltexN6PKg7K1ZDRYfg8l+fyDk=;
        b=qUcIc7w4+H7TUeA4jr5J04vfSqvl+2I5vjMO9JYFY9vNivLlyORloiYoijwiqvsQk7
         yuPj/L7XmzE82e9kdKtihJuJ2B7WkhuCebvvpMymHNbWLyO0ggYd2/FqY8fwBPaCbeDo
         pG/9MSBFMB4iwneQm7FaJoXpqPMlfyULd8QyIwH4/2Qu5Ex+ETk6V/I1XeXo0etMHXKP
         35YTyXjOc8wmnbQVRdDuSvDx7dU2Uh1C8bt1d7hCHUo8NKIrzMMzQCMXp07qxd+vPMfa
         sotBiP7ItSTLi7wNmgma/AIdCgj28o+1Ugj8ZjBKUMO8n6sxyPLpHDerPCTbEbhSO17A
         HiJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SGhwCL7nCuI/FVuTMRltexN6PKg7K1ZDRYfg8l+fyDk=;
        b=IcwVuQaTiEpwPhspiX7FWt0DNF/SWCOFKsyiP/VC/9XtVGPC2qr6k6UubGQo6+yeb4
         Ll0ULk94GDw5F3GSmHEfb+WPSxzfO2bFPbp3LTKpfguC4zRFbLhcC00vtZjvFOKobLoj
         tDNMFCxNbjelZ22evKp6rQhGshA8zhhmkrJ+nTDLS9fitKwSldELDNbmptdyq9tY0HT0
         293ofc9a55b7CJr/Fwqv1uD5GG6Wmv90B9rt64EUfwmfsvP6tQuya6MUEA5JdmUGoOBD
         W/3C0uP02HmQtQ372bu3MLaUbfwmz70wBqx6b4UKLc4IaZ76kOOLmqp3bDB7OrCT3nDT
         U4nQ==
X-Gm-Message-State: AGi0PuZu4FEBf4ThBJzheOV3/DlKf3NkI9941j+9iLZkJzyWqWbAu3l4
        2YJPexi4GfGd4xkJ+W8QOeQu12jxilUnwWkrx0XxdWU2tBI=
X-Google-Smtp-Source: APiQypLR3BLCiorniAkI5K0Flv6bFsl+08GYAR7qyGs079jLdxLPOkeVfg6E+nw02ELi+FJM/EGE/u9u3fzv7vLfxP0=
X-Received: by 2002:a37:6587:: with SMTP id z129mr6396575qkb.437.1586559236591;
 Fri, 10 Apr 2020 15:53:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232526.2675664-1-yhs@fb.com>
 <20200410030017.errh35srmbmd7uk5@ast-mbp.dhcp.thefacebook.com> <c34e8f08-c727-1006-e389-633f762106ab@fb.com>
In-Reply-To: <c34e8f08-c727-1006-e389-633f762106ab@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Apr 2020 15:53:45 -0700
Message-ID: <CAEf4BzYM3fPUGVmRJOArbxgDg-xMpLxyKPxyiH5RQUbKVMPFvA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 3:43 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/9/20 8:00 PM, Alexei Starovoitov wrote:
> > On Wed, Apr 08, 2020 at 04:25:26PM -0700, Yonghong Song wrote:
> >> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> >> index 0f1cbed446c1..b51d56fc77f9 100644
> >> --- a/include/uapi/linux/bpf.h
> >> +++ b/include/uapi/linux/bpf.h
> >> @@ -354,6 +354,7 @@ enum {
> >>   /* Flags for accessing BPF object from syscall side. */
> >>      BPF_F_RDONLY            = (1U << 3),
> >>      BPF_F_WRONLY            = (1U << 4),
> >> +    BPF_F_DUMP              = (1U << 5),
> > ...
> >>   static int bpf_obj_pin(const union bpf_attr *attr)
> >>   {
> >> -    if (CHECK_ATTR(BPF_OBJ) || attr->file_flags != 0)
> >> +    if (CHECK_ATTR(BPF_OBJ) || attr->file_flags & ~BPF_F_DUMP)
> >>              return -EINVAL;
> >>
> >> +    if (attr->file_flags == BPF_F_DUMP)
> >> +            return bpf_dump_create(attr->bpf_fd,
> >> +                                   u64_to_user_ptr(attr->dumper_name));
> >> +
> >>      return bpf_obj_pin_user(attr->bpf_fd, u64_to_user_ptr(attr->pathname));
> >>   }
> >
> > I think kernel can be a bit smarter here. There is no need for user space
> > to pass BPF_F_DUMP flag to kernel just to differentiate the pinning.
> > Can prog attach type be used instead?
>
> Think again. I think a flag is still useful.
> Suppose that we have the following scenario:
>    - the current directory /sys/fs/bpf/
>    - user says pin a tracing/dump (target task) prog to "p1"
>
> It is not really clear whether user wants to pin to
>     /sys/fs/bpf/p1
> or user wants to pin to
>     /sys/kernel/bpfdump/task/p1
>
> unless we say that a tracing/dump program cannot pin
> to /sys/fs/bpf which seems unnecessary restriction.
>
> What do you think?

Instead of special-casing dumper_name, can we require specifying full
path, and then check whether it is in BPF FS vs BPFDUMP FS? If the
latter, additionally check that it is in the right sub-directory
matching its intended target type.

But honestly, just doing everything within BPF FS starts to seem
cleaner at this point...
