Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 968335D6D2
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 21:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfGBTXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 15:23:08 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37703 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfGBTXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 15:23:08 -0400
Received: by mail-qt1-f194.google.com with SMTP id y57so19894204qtk.4;
        Tue, 02 Jul 2019 12:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zxlnXYMeCUDVWov9VKANbsKKyc2Eiic06UOkJaRthqc=;
        b=h/YUwUj2bPv0c7rXJOQ1MjoMm69jpUa5dMNwhBam9nMdPkevaz0pKbOt4R8sRlUtIO
         QkDTVRyB9vxoq1/ggzte9PDcWl5t4aIHjl/9prqxXvcEdXx4iqypYCy4e+g7HjpU8QJe
         fMDxEtrFO3BXQ+lxkkzN8iRk1be9b24zV9tk9FRKCIpdPT3RkjA6P0ZkrxIzsOd1ZvAK
         5BWT3LeEzNY3daxrUpLyEweUIkvXwhFu43HZE7EDdA9ZCfI1xRicrYL2jOpmFnHvTc4r
         YWr0SRh/oGHIpERbwjCJoccV+pCNDOIGNKRUT6qy0F08VmscowOizcPbdva/+jTfQ4de
         YOiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zxlnXYMeCUDVWov9VKANbsKKyc2Eiic06UOkJaRthqc=;
        b=hfkEhwQMzwvZnkbcr5r6qO8faSHjyUAscLRnI5sAe/36TXLyAsRtfi+nUGy0iLbtDW
         q4+wCIMCXIVYY0K84SC2qp09ZmYc7V6YnB0g31yLBcKUCjnOOZAv3to40WtaW4YMRkJF
         5Qu0sFQIt7Zi6iCrKe+9550Ufz/hMMXgcqlISqr32NfkHcXCk239iSt1VO4EU8f+1ffY
         f8sb/GIE0WXlXhJkSqaIRa9AqR7bmEdCfAPQMXPqLw2EjPrDRkSNvWuS0nmt2agRcdtn
         ETAmAd3Jzbt+YtRxSiXm8S63sH38ZWx6iB+bjSXeSNX6Ev3i73bUodAmXccFuftmpXlU
         C0bw==
X-Gm-Message-State: APjAAAU6eYJo1Y5ogZrh0bC1DX5WAcvXzyBhQXreJuG+6b47tohxjhzu
        iri6JKD7QEnTfgEcPduXhPaiSVwclB/I+vsBVj0=
X-Google-Smtp-Source: APXvYqxmXueavSn/BFyG/K3TwDUG7bocLUwHXO9I7vL0zYZ7HAyLzi16rl8/4Xo/LBc2Iai8GQhyRNOCEPtaW+4nZDo=
X-Received: by 2002:ac8:1725:: with SMTP id w34mr26673440qtj.117.1562095387392;
 Tue, 02 Jul 2019 12:23:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190627201923.2589391-1-songliubraving@fb.com> <20190627201923.2589391-2-songliubraving@fb.com>
In-Reply-To: <20190627201923.2589391-2-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 2 Jul 2019 12:22:56 -0700
Message-ID: <CAEf4Bzb4ASMSNR0h+xgQHKEPryCtQnqFxtLnPvKuT4ME0eoe1Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
To:     Song Liu <songliubraving@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>, gregkh@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 1:20 PM Song Liu <songliubraving@fb.com> wrote:
>
> This patch introduce unprivileged BPF access. The access control is
> achieved via device /dev/bpf. Users with write access to /dev/bpf are able
> to call sys_bpf().
>
> Two ioctl command are added to /dev/bpf:
>
> The two commands enable/disable permission to call sys_bpf() for current
> task. This permission is noted by bpf_permitted in task_struct. This
> permission is inherited during clone(CLONE_THREAD).
>
> Helper function bpf_capable() is added to check whether the task has got
> permission via /dev/bpf.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  Documentation/ioctl/ioctl-number.txt |  1 +
>  include/linux/bpf.h                  | 11 +++++
>  include/linux/sched.h                |  3 ++
>  include/uapi/linux/bpf.h             |  6 +++
>  kernel/bpf/arraymap.c                |  2 +-
>  kernel/bpf/cgroup.c                  |  2 +-
>  kernel/bpf/core.c                    |  4 +-
>  kernel/bpf/cpumap.c                  |  2 +-
>  kernel/bpf/devmap.c                  |  2 +-
>  kernel/bpf/hashtab.c                 |  4 +-
>  kernel/bpf/lpm_trie.c                |  2 +-
>  kernel/bpf/offload.c                 |  2 +-
>  kernel/bpf/queue_stack_maps.c        |  2 +-
>  kernel/bpf/reuseport_array.c         |  2 +-
>  kernel/bpf/stackmap.c                |  2 +-
>  kernel/bpf/syscall.c                 | 71 +++++++++++++++++++++-------
>  kernel/bpf/verifier.c                |  2 +-
>  kernel/bpf/xskmap.c                  |  2 +-
>  kernel/fork.c                        |  5 ++
>  net/core/filter.c                    |  6 +--
>  20 files changed, 99 insertions(+), 34 deletions(-)
>
> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
> index c9558146ac58..19998b99d603 100644
> --- a/Documentation/ioctl/ioctl-number.txt
> +++ b/Documentation/ioctl/ioctl-number.txt
> @@ -327,6 +327,7 @@ Code  Seq#(hex)     Include File            Comments
>  0xB4   00-0F   linux/gpio.h            <mailto:linux-gpio@vger.kernel.org>
>  0xB5   00-0F   uapi/linux/rpmsg.h      <mailto:linux-remoteproc@vger.kernel.org>
>  0xB6   all     linux/fpga-dfl.h
> +0xBP   01-02   uapi/linux/bpf.h        <mailto:bpf@vger.kernel.org>

should this be 0xBF?

>  0xC0   00-0F   linux/usb/iowarrior.h
>  0xCA   00-0F   uapi/misc/cxl.h
>  0xCA   10-2F   uapi/misc/ocxl.h

<snip>
