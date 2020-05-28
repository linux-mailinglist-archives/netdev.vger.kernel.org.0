Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094BD1E57A2
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 08:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgE1Ggm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 02:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE1Ggl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 02:36:41 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DD9C05BD1E;
        Wed, 27 May 2020 23:36:41 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id c185so2126678qke.7;
        Wed, 27 May 2020 23:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0amOchmDsqcUzF+cWoGP0KCTy3ejb6HUTP67rmJQFu4=;
        b=TN1aXrTltN3wuUmgN8WPiIyl3Rscu+nyF80CAslZc0t8t3ce2hMBf9mbz7CwVHrjI7
         H7ILlhWIde7uQ3xR1YtnrIkluslLlBNIbsVijpZEy0KQGaOESBp0HgQK6uPA62j/BDQE
         2EDC9eShDDKPyJM5m0sf6wWnO6wBCVaW3ggQXUlaGcMc2mm01EXOoeErjnpCYuwU0n70
         otwm//I3FbTlCzy+m+m2rRfNI0kzVUK5Szy24as0l+WG5+lSag0RaoKQHyUul0GzaWa6
         t01hHszZ4oPeBzTafRmE6PBCnRQV7yI6xuBEKUPza7BVL7ygNi7B6cmAv3i2Cf8wac4s
         M8nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0amOchmDsqcUzF+cWoGP0KCTy3ejb6HUTP67rmJQFu4=;
        b=TG1ZmjGKuTWzS+GaN0KhJD+fBmcPd0fupD7ODfwZ7Ce9AQ80fIY8n+vnFx4XrcTG3z
         OjYUGmxzyJOj/FS7LjJfRzI0xU/Ze3tT0SO1ghdM5JG6XD4ct5qbc72ohCEC5P2zXnzn
         WxscgQZX8WHAZmQloopveysnIee1uAPC2rf29CJhe35w+zB0miG/z0FAq48pHpbijkyi
         PqB0YjsRnBD5zEua/iZhJApeF2OnouZLpTHbuRe0QcZwC6kK0hFvu6lU8d/kflnR/EDo
         YsVn/nDx6AZ6cTixfjP6MVUZb+kEAwVYdSoBO1W27IYTuNMvW3KsFDrSw0R59iBDHmj8
         hLKw==
X-Gm-Message-State: AOAM530dSHF1eDjZyzWtWDugtD+rByRZzuy6busn/0tafl/kFDXt5UyH
        VXpVD8KJWe7nTdlKUV1nLMwMxocFa+pZLfPJUa0=
X-Google-Smtp-Source: ABdhPJxJuU/mMi4LoHKwCacMUXEHrhBvL3NRaAWWtZAb80jwxR1onoEbQTf6uvr/BY0h14+s2qBANITgBdoylqbwAwk=
X-Received: by 2002:a37:a89:: with SMTP id 131mr1354085qkk.92.1590647800486;
 Wed, 27 May 2020 23:36:40 -0700 (PDT)
MIME-Version: 1.0
References: <6561a67d-6dac-0302-8590-5f46bb0205c2@linux.alibaba.com>
In-Reply-To: <6561a67d-6dac-0302-8590-5f46bb0205c2@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 May 2020 23:36:29 -0700
Message-ID: <CAEf4BzYwO59x0kJWNk1sfwKz=Lw+Sb_ouyRpx8-v1x8XFoqMOw@mail.gmail.com>
Subject: Re: [RFC PATCH] samples:bpf: introduce task detector
To:     =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 7:53 PM =E7=8E=8B=E8=B4=87 <yun.wang@linux.alibaba.=
com> wrote:
>
> This is a tool to trace the related schedule events of a
> specified task, eg the migration, sched in/out, wakeup and
> sleep/block.
>
> The event was translated into sentence to be more readable,
> by execute command 'task_detector -p 49870' we continually
> tracing the schedule events related to 'top' like:
>
> ----------------------------
> 923455517688  CPU=3D23  PID=3D49870  COMM=3Dtop          ENQUEUE
> 923455519633  CPU=3D23  PID=3D0      COMM=3DIDLE         PREEMPTED       =
         1945ns
> 923455519868  CPU=3D23  PID=3D49870  COMM=3Dtop          EXECUTE AFTER WA=
ITED     2180ns
> 923468279019  CPU=3D23  PID=3D49870  COMM=3Dtop          WAIT AFTER EXECU=
TED      12ms
> 923468279220  CPU=3D23  PID=3D128    COMM=3Dksoftirqd/23 PREEMPT
> 923468283051  CPU=3D23  PID=3D128    COMM=3Dksoftirqd/23 DEQUEUE AFTER PR=
EEMPTED  3831ns
> 923468283216  CPU=3D23  PID=3D49870  COMM=3Dtop          EXECUTE AFTER WA=
ITED     4197ns
> 923476280180  CPU=3D23  PID=3D49870  COMM=3Dtop          WAIT AFTER EXECU=
TED      7996us
> 923476280350  CPU=3D23  PID=3D128    COMM=3Dksoftirqd/23 PREEMPT
> 923476322029  CPU=3D23  PID=3D128    COMM=3Dksoftirqd/23 DEQUEUE AFTER PR=
EEMPTED  41us
> 923476322150  CPU=3D23  PID=3D49870  COMM=3Dtop          EXECUTE AFTER WA=
ITED     41us
> 923479726879  CPU=3D23  PID=3D49870  COMM=3Dtop          DEQUEUE AFTER EX=
ECUTED   3404us
> ----------------------------
>
> This could be helpful on debugging the competition on CPU
> resource, to find out who has stolen the CPU and how much
> it stolen.
>
> It can also tracing the syscall by append option -s.
>
> Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
> ---

I haven't looked through implementation thoroughly yet. But I have few
general remarks.

This looks like a useful and generic tool. I think it will get most
attention and be most useful if it will be part of BCC tools. There is
already a set of generic tools that use libbpf and CO-RE, see [0]. It
feels like this belongs there.

Some of the annoying parts (e.g., syscall name translation) is already
generalized as part of syscount tool PR (to be hopefully merged soon),
so you'll be able to save quite a lot of code with this. There is also
a common build infra that takes care of things like vmlinux.h, which
would provide definitions for all those xxx_args structs that you had
to manually define.

With CO-RE, it also will allow to compile this tool once and run it on
many different kernels without recompilation. Please do take a look
and submit a PR there, it will be a good addition to the toolkit (and
will force you write a bit of README explaining use of this tool as
well ;).

As for the code itself, I haven't gone through it much, but please
convert map definition syntax to BTF-defined one. The one you are
using is a legacy one. Thanks!

  [0] https://github.com/iovisor/bcc/tree/master/libbpf-tools

>  samples/bpf/Makefile             |   3 +
>  samples/bpf/task_detector.h      | 382 +++++++++++++++++++++++++++++++++=
++++++
>  samples/bpf/task_detector_kern.c | 329 +++++++++++++++++++++++++++++++++
>  samples/bpf/task_detector_user.c | 314 ++++++++++++++++++++++++++++++++
>  4 files changed, 1028 insertions(+)
>  create mode 100644 samples/bpf/task_detector.h
>  create mode 100644 samples/bpf/task_detector_kern.c
>  create mode 100644 samples/bpf/task_detector_user.c
>

[...]
