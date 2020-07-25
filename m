Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC0622D623
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 10:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgGYIlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 04:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgGYIlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 04:41:05 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D28C0619D3;
        Sat, 25 Jul 2020 01:41:04 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id s9so6439149lfs.4;
        Sat, 25 Jul 2020 01:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gLa0yIa3R6CxeFbpWBGfvSi9WOpvvBRp1bfTmHbwGgA=;
        b=kGmsAr4ZBv5Vi8BRAQbjW9+ycHKsMrrz796Jl/fafG9EID941bQh6Y1DdoPI1ITRLD
         aZR0flmjyNvQaIwnkxfYa+sFFnifO2rzVXB/1ybFQ1SVmffzTM5pytXZZAMyQtAWFLNy
         Imju1YwixY/+ICD/d8vI9mV/qlxxIseDZ/xNCwEuwXs5H0BsZFuE/tjEVjlGlR6Ml7Dd
         x9NE6RH1RxhMsTi6RttlugQqcI+5/TWOHHMom8TigdlACrBFNuj8pLfdq1IETbmkI1ke
         hYAItowlGyZUNTetLkJY6nUOm863cI2M6poZgzR2ZUvvPm8NBSFNk9IKOPASSYDX3SLU
         YGVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gLa0yIa3R6CxeFbpWBGfvSi9WOpvvBRp1bfTmHbwGgA=;
        b=VG8UUhhGQnSpCaDmISfbuvGQ6vIck0g3VLMYHom4jbUVpdifdrT43LxWtgIx+des8N
         uYvGcjL4MjQifOJ0KstK9JjRSMapKKFxiCa5RPyMxk9lPhZ7fKGoDFwl2vZFECSC/8lR
         zYjYo2b5usjKHYfI6MDx1GaJCurPTmOwWUMuRURuYWmOUWdMUKpYxKMZcW0JyEEbMG9E
         um9Y6wtV/jMxx9zzxTBmninsOaZa3Zm96r2d+RfsHOvyu5wdx7tNn2sabHQLJi7ssqQG
         q0/Rt15Rvq/abuY4KCf/KkVNw0WilhPtUx5WPVW4ps5t3Fb0/UCfyzcHoB5gSVJ1EpMD
         c4zg==
X-Gm-Message-State: AOAM5310hiNp6vEfCizfzUWo5IkRxI05dndvqUa3KtwvN47JC1gZFlKN
        D5rsVE1d0GL5dR0q8qZr6w4JBIsqInb9IXpM2fQ=
X-Google-Smtp-Source: ABdhPJzPUinusgTSMJuckILlfLGJqmZxIxWiac5hfQtiBRbrYhXjTRayaHMOLQTds20E7/LSZ/rvKXoVb4zjnPk1QWA=
X-Received: by 2002:a19:84ce:: with SMTP id g197mr6793620lfd.73.1595666463180;
 Sat, 25 Jul 2020 01:41:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200724200503.3629591-1-songliubraving@fb.com>
In-Reply-To: <20200724200503.3629591-1-songliubraving@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 25 Jul 2020 01:40:51 -0700
Message-ID: <CAADnVQLsNcXUAYbWButG8PpxDh5uc=rC8KuyxovddfykMsUqYw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix build on architectures with special bpf_user_pt_regs_t
To:     Song Liu <songliubraving@fb.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 1:08 PM Song Liu <songliubraving@fb.com> wrote:
>
> Architectures like s390, powerpc, arm64, riscv have speical definition of
> bpf_user_pt_regs_t. So we need to cast the pointer before passing it to
> bpf_get_stack(). This is similar to bpf_get_stack_tp().
>
> Fixes: 03d42fd2d83f ("bpf: Separate bpf_get_[stack|stackid] for perf events BPF")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>

Applied. Thanks
