Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4738922A6CA
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 07:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgGWFKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 01:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgGWFKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 01:10:25 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03D5C0619DC;
        Wed, 22 Jul 2020 22:10:24 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id x9so4966533ljc.5;
        Wed, 22 Jul 2020 22:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SiNQ3FgnGRzw5D+bZtfZYqQAVIXBOtMOE+9HpbyBTyA=;
        b=REZdtIPqU+e/hbQxzn0qiUvLQSSTZC7FvcjwwjWSVzfCo//BdUcc2/ckmOGz4kHr0F
         YYhnVWXUOHFEvl0zFQTG2w0jC6AJ0alrnQtTbbznExJQbMl3JoZCfruUpSnb9PLsVamx
         Wlgvl1Ghy++xzt5jxKofh+Ih5IcUt7m01tuHWUEyezAZODh4634bNxQviFv3gcW+g5xz
         Ew2lIIogdG0graRknw9x+VUbzALYLexBPjvmL76gUYkJgcERbzc7NfgUeSBR5z/uCXmd
         YuBRHyqACsGP8f38ULe1TVEjHXkcFOAUWvKzyUcefmYfVRgumr8x5rt3a7uztiSUzDpy
         v/tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SiNQ3FgnGRzw5D+bZtfZYqQAVIXBOtMOE+9HpbyBTyA=;
        b=VpZ/GX05HeY7LrBgYVLgIrsiAMlfQ1fF7LLfwJUGcQw/6UwuGxkabRj192e6jsZr23
         oQVA2qdcdUZYC0bhMgflQpBgdz2sNjGslbKNDawvGgzhGGg+ZOuqiwdmYuM18uf+VP7d
         DYPrKw+iAJ6/YKqdf+qmzSvnRoNwEHpu3yw7A9qqoFWsbRsNSfFqNGJ2FSLSfkMm2x3s
         YPyeK1LCfTL2yiNXDeG+1lYkU7btB4iSQCwiplRC2ASJaabPDLjrCOdGPLxVWF6vtg1M
         E1WbM7EWcOwq+TxfwkbL3K03SvBi6jftn47DwWNpzi9y8W1ww0JWAoPuz1s9jIAux2Hh
         Pnpw==
X-Gm-Message-State: AOAM530EX1jiywPv3Orl6YnOD4IiaYoiekKx08BHGWw7wzykpOJ50crK
        zuO/Fy4k6fdRawPywiGeNx4uH4Qhbs6zGiPxJs3oDg==
X-Google-Smtp-Source: ABdhPJxBTiKhjXg6GTDGfRN3y7A9BXv1Z7+M31+8WZ5vSznRvMGxY0U5cPRRFxGAm6lU0eTjfMV2IiWZ0OnT1r22c2I=
X-Received: by 2002:a2e:9a0f:: with SMTP id o15mr1139573lji.450.1595481023007;
 Wed, 22 Jul 2020 22:10:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200722043804.2373298-1-andriin@fb.com> <bae8109d-3f01-eafb-eff8-4df425771b2b@isovalent.com>
In-Reply-To: <bae8109d-3f01-eafb-eff8-4df425771b2b@isovalent.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Jul 2020 22:10:11 -0700
Message-ID: <CAADnVQKijJTbQ8Gmh4x4dJqh++DT7JESZ1eyYsQngcw-UK6O=A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools/bpftool: strip BPF .o files before
 skeleton generation
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 1:21 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On 22/07/2020 05:38, Andrii Nakryiko wrote:
> > Strip away DWARF info from .bpf.o files, before generating BPF skeletons.
> > This reduces bpftool binary size from 3.43MB to 2.58MB.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> Acked-by: Quentin Monnet <quentin@isovalent.com>

Applied. Thanks
