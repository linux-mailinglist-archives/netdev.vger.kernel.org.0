Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C79A3304D6
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 00:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfE3WeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 18:34:23 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42159 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfE3WeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 18:34:23 -0400
Received: by mail-qt1-f195.google.com with SMTP id s15so9036970qtk.9;
        Thu, 30 May 2019 15:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dX8WKZ9qrWHo5nxihC0jGW8Sb1EefXDVfC2HVTjTW0U=;
        b=SHqwW19zaTXztrJeZskOeIDsvYpDUNgAyfzDHK+7CwSuJ/UY2vvMulHl3fn3EPiwKp
         7dKcSWfYL+Q3/J5scsAXqmDM93STQJCcctjaf+s7HkYdnWxeY4IOiufkNdk8pufPU0pj
         GhFes5XTPJLMDHW+THbGMSg8EmhmiYBNj0buWdRMkcs7B2pPSWWIzRlxtrj9EbpXMpqm
         T/VOdM5GzRAnyKCZmB0mQ86cnoV3h2WF3fPP29KhYS5ojCjCyIL9rq8qPU/93eYdIMY0
         x81ZlfNy4Cd1zUGsYKKuU2JtB3Z+xL3smYWMothHCdscWTLrYojSJEBTU3RFPTlEcGYr
         S/OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dX8WKZ9qrWHo5nxihC0jGW8Sb1EefXDVfC2HVTjTW0U=;
        b=YVEbwD8LVkmLiuNvLhn38ZDFn46ES1nnrrn/hzzkhvJNIy9UJa8M3ZTLMZRDCGJoew
         NPcHqqzcCd4wmZMDdWWt5m7xePORLkfgjKvg2R8sTHyzlMpbm9FZBM69qBx06ktZzon9
         OhrstqwIX6Ylg/tszWleYNDt/R21ZusNBC8f9YClQO5WJDCBMwScTIE2oTZfjonfdJcj
         2vKGYivDUONsgg7bwR+K+HcdNR3YKQbeeeO4gXAut0oYQuV57Jwe7K9B6ETRZkGb6eMi
         DisEBSQCEfIvH0aCKpoGh2IUPZK0yTg742eAk/nG4XA/G7VRoyNxQA8ddjPWBeDl+aOl
         oqhQ==
X-Gm-Message-State: APjAAAU9LTHEGxOXaTU8Q0h7vjz3j61nxu/NqDIpy7oDtj5UGazAjDQg
        A+ehMCo0Jt1jPxWJ+UoGlrI/kmq9LD1dEfYH49o=
X-Google-Smtp-Source: APXvYqyd9G1R8zZihg8bY4icpgogJCi9+Y+3btVGT2ymcWviQbGEG+KSKqLohEXCy5dnnujIVem0Lk5vCSbh6Nw1U4s=
X-Received: by 2002:a0c:b032:: with SMTP id k47mr5801528qvc.86.1559255662262;
 Thu, 30 May 2019 15:34:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190530190800.7633-1-luke.r.nels@gmail.com> <CAPhsuW4kMBSjpATqHrEhTmuqje=XZNGOrMyNur8f6K0RNQP=yw@mail.gmail.com>
In-Reply-To: <CAPhsuW4kMBSjpATqHrEhTmuqje=XZNGOrMyNur8f6K0RNQP=yw@mail.gmail.com>
From:   Luke Nelson <luke.r.nels@gmail.com>
Date:   Thu, 30 May 2019 15:34:10 -0700
Message-ID: <CAB-e3NSidgz8gLRTL796A0DyRVePPjVDpSC6=gSA4hH8q6VqvQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] bpf, riscv: fix bugs in JIT for 32-bit ALU operations
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Xi Wang <xi.wang@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>,
        linux-riscv@lists.infradead.org, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 1:53 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> This is a little messy. How about we introduce some helper function
> like:
>
> /* please find a better name... */
> emit_32_or_64(bool is64, const u32 insn_32, const u32 inst_64, struct
> rv_jit_context *ctx)
> {
>        if (is64)
>             emit(insn_64, ctx);
>        else {
>             emit(insn_32, ctx);
>            rd = xxxx;
>            emit_zext_32(rd, ctx);
>        }
> }

This same check is used throughout the file, maybe clean it up in a
separate patch?
