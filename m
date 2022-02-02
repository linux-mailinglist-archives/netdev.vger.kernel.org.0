Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1F44A76DC
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 18:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345160AbiBBRae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 12:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiBBRad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 12:30:33 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68099C061714;
        Wed,  2 Feb 2022 09:30:33 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d1so18912208plh.10;
        Wed, 02 Feb 2022 09:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xdhYsHsZ6GcM52cBZ3hWzm8M2TNSQxqnbArcpF/Qhc0=;
        b=Rxg1nA2ZyobRs5qmnZTUqWBxhRyiOJ42MD4WC/Io+/7Gr4kBmnc3l9W8V+Ep8DrdHE
         LeEsDe/3e8OxEwFlluZKIo8/Z9WPuwHZcuWYSnk4y0CfXSAcw8q1GxOnPPp0OPZbxrIR
         ElQE2fUQddaaYcZB0xDrnPIx3VLSGN6G30AEN/ua7fov82YJz12vVjRDU9uNbeUZe/+m
         2VAoHJE4J1FW/wOOTRSd/Jl4mpDGPFWJ2ZanK6maolOmAYlnecdanqZgrkRpOCnWK9yH
         4CnRc1ptW9MPKZW0t8Z4V6+f1MccGBVfhJ1mJBCvz9PsdZzCjrPhhLD9sOS8PrPoF1KP
         TCnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xdhYsHsZ6GcM52cBZ3hWzm8M2TNSQxqnbArcpF/Qhc0=;
        b=S57PWEGa8XCkRaw17GVVmGy9YA5VZX7oHYtaa/SN/TYJSJrGBOfDbcSgdqBD4+gnfk
         balDrcHTkBlPVyNvHg+GjTc8g0kw0oUOF5tuEtoHoLEcfepoEnL3t7KadRCfB1ryNrXg
         /evzOOjaZBWZGU+/pJHZ5VjOHpDn8MsIdV/pQcgI4M6wBn4nreSQLzbUvwX1uFaj0mYi
         FrWYzaBRoSMCkp10fYmu5BmcirNsIgb2EgHtDB85tKCr2UdNtxeNMEjkmwnjzKXVm7gS
         dpXnb8TIB+xVR4JKir34IRkbWUgK3SGN4NYZlL0IG3Te2+Pw5pFkodQxxxtzk8hrYUcy
         yXqg==
X-Gm-Message-State: AOAM531JoKCQ/LoFFhLfeimo3lMCQmYCCPfs5IDdn+5P9wQt2AcaFlqR
        zCN2dhuXkKi3YLi1k4JxehP6RVORQRfml5auL44=
X-Google-Smtp-Source: ABdhPJxcsPfujm5y+1c1M83Izh2Yn3yGyxpc3DaPP0XfcEntiK/9RcjH+hkRDRBa1ODded2xnwRB5fQ880bd0rWu95M=
X-Received: by 2002:a17:90b:1e41:: with SMTP id pi1mr9065420pjb.62.1643823032844;
 Wed, 02 Feb 2022 09:30:32 -0800 (PST)
MIME-Version: 1.0
References: <20220202135333.190761-1-jolsa@kernel.org> <CAADnVQ+hTWbvNgnvJpAeM_-Ui2-G0YSM3QHB9G2+2kWEd4-Ymw@mail.gmail.com>
 <Yfq+PJljylbwJ3Bf@krava>
In-Reply-To: <Yfq+PJljylbwJ3Bf@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 2 Feb 2022 09:30:21 -0800
Message-ID: <CAADnVQKeTB=UgY4Gf-46EBa8rwWTu2wvi7hEj2sdVTALGJ0JEg@mail.gmail.com>
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 9:24 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Feb 02, 2022 at 09:09:53AM -0800, Alexei Starovoitov wrote:
> > On Wed, Feb 2, 2022 at 5:53 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > hi,
> > > this patchset adds new link type BPF_LINK_TYPE_FPROBE that attaches kprobe
> > > program through fprobe API [1] instroduced by Masami.
> >
> > No new prog type please.
> > I thought I made my reasons clear earlier.
> > It's a multi kprobe. Not a fprobe or any other name.
> > The kernel internal names should not leak into uapi.
> >
>
> well it's not new prog type, it's new link type that allows
> to attach kprobe program to multiple functions
>
> the original change used BPF_LINK_TYPE_RAW_KPROBE, which did not
> seem to fit anymore, so I moved to FPROBE, because that's what
> it is ;-)

Now I don't like the fprobe name even more.
Why invent new names? It's an ftrace interface.

> but if you don't want new name in uapi we could make this more
> obvious with link name:
>   BPF_LINK_TYPE_MULTI_KPROBE
>
> and bpf_attach_type:
>   BPF_TRACE_MULTI_KPROBE

I'd rather get rid of fprobe name first.
