Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310C448481C
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 19:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236025AbiADSxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 13:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbiADSxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 13:53:31 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB99C061761;
        Tue,  4 Jan 2022 10:53:31 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso4087693pjb.1;
        Tue, 04 Jan 2022 10:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=878RGf7G5xfSkN8ej4TdN81e7RTEV0mxJ9Xgt75AUUE=;
        b=IJ77n83ECbSB+kdRdX5qjRc+aSZSJFT4uzLrnbpTK8jOWA8F2k59cLapDgE7ANO2gW
         vwzq1tl60fYsbGIhkTv5MZkkYRuO6AOv9VS2GsAZ6i6J4tbKgOJLkOYs1Z4yyTFbAps2
         QlRlDHzDfnMLbw8cJaP6hOnOnYxFzZ8OvLK2g2q0ZfQL5a7jTs4nId7I2oiAkrzPz+jC
         cim0D1QhaICDtwJUiMtT5X1ZbY/xfvYeSFrkc+mJpuAIx+Tq5ps8vApku2wp+cwfP4He
         2CTj4RDcT/4cVYc/Vt3Jtv67AkxStu7tibGpQPFUIPYUmBqqyNVWG1u4ROpmWSY+sCN9
         Fo6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=878RGf7G5xfSkN8ej4TdN81e7RTEV0mxJ9Xgt75AUUE=;
        b=NKQAOXpwEUpRpgKgBXwtKkiKtM9YX7FR+cNTcZu+SI3oCHmLYfpV/Iz4YLZ3C/zPdz
         ddSQZh1SWfRq+/vCl1GWV++v9IrTzThXbGnNSwN8L9XhQSOfBHctCfPgCh/9hGzkFWvw
         Hd3TQ7K5ezlPt61n6LUyX5/SSCAUssfSpFp0jG2jfWNCan6KlH4tYi/hQ3HC/uPeX/ls
         /kyLvZTSfI3GTKe1s3inHf6FtFZxaupyEMndbFa7f/UQh4A6pR/v2Ji5KixSniuOZX8d
         9t52urrB9Y3ia9bKKXfEyeZExaBaFWLcmGXFBruhF32UC85j9JpifXp4eZftj0h0ZbML
         9S9w==
X-Gm-Message-State: AOAM533XT9DBXlLtvM6G8VysC7clxAqGYtGg8/1ZYud7I1Y+g2YFXHk8
        rdVZK0xZqfHom0nSoWuyATm2lq0zsRmadRDZ3cY=
X-Google-Smtp-Source: ABdhPJzdLaJwn8kNn+k7D+hlUghYv6CNpvjQNRPwlSxXwCsTRX4ocx/Bt3dou1s7om3gsPL4T2blgTsQ5F/hdZA4GwY=
X-Received: by 2002:a17:90b:798:: with SMTP id l24mr62011210pjz.122.1641322410956;
 Tue, 04 Jan 2022 10:53:30 -0800 (PST)
MIME-Version: 1.0
References: <20220104080943.113249-1-jolsa@kernel.org>
In-Reply-To: <20220104080943.113249-1-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 4 Jan 2022 10:53:19 -0800
Message-ID: <CAADnVQKZcr38aXwN6DyV7C9Ernfwkz5nsx8pXapKGNmnZ1JMDQ@mail.gmail.com>
Subject: Re: [RFC 00/13] kprobe/bpf: Add support to attach multiple kprobes
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
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 12:09 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> hi,
> adding support to attach multiple kprobes within single syscall
> and speed up attachment of many kprobes.
>
> The previous attempt [1] wasn't fast enough, so coming with new
> approach that adds new kprobe interface.
>
> The attachment speed of of this approach (tested in bpftrace)
> is now comparable to ftrace tracer attachment speed.. fast ;-)

What are the absolute numbers?
How quickly a single bpf prog can attach to 1k kprobes?
