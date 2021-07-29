Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93463DA353
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 14:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237205AbhG2MqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 08:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236868AbhG2MqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 08:46:10 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A666C0613C1
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 05:46:06 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id z18so9989584ybg.8
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 05:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pi7rp1GNYexymoUQyvMFYPbnqInCufc4sEVtUctnyiw=;
        b=FU9ZCHbqtqfXorPLTVawPI1sEJoaFb7y5+mTOrSRXARFRLvEnFEaNrVc7H4jY+vJRK
         MIDYM+/VAKVEhocttsWZfM4Tovs2RQYk7kkjylUi9SCBcB5WolWxDzswWvs1VaCpWZqn
         B2fDAP/iE+6NANp05iFix395vI+zELGZSzruExp47Qbt0x92z7d4yKalhyUNCO98JVq0
         QVbN4IVpkqFXCUQTtt4DIJAdDJXeCBKdqvDkZL/NM5xCK592owEGcRZ3ckS41Tim+ayr
         r26qATc5cXa9OhpFHjbmQPYbtR3jWGz4fYANRRmAxYPKmXOk1zaHB7+cru/qtdcxrCcA
         Z/bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pi7rp1GNYexymoUQyvMFYPbnqInCufc4sEVtUctnyiw=;
        b=dvpucaRUtPxT/mDWzhxj+QijolQy68stqL4UrDe92g775PRVFdOQm3SnGH6pOYQ1IP
         +7akweTTyjfwQ/Ms22umvfC1VjCbcS3L5aLN79/DMTVjWIZk7ab1b8Z8NbcnErAnqmB9
         /krM7qOMHaUNC2yar00HD8K87DaOOlQpep6ftZ1UjUnNzLvdveizilYAwn4gmLK4vOjH
         Rrlah0cXB9n0JNPVmfoE/KAnkIdcavpHIpGFZqhzUDiISCYAEndk6/qxUgt15I+Dk8RI
         IPTnv5HlK6O5PZYZDU8MK/de0S1IRESc9KO0S7Y0TnxryJyc/0EU7lfbQBAYrrxlPF2V
         rEXA==
X-Gm-Message-State: AOAM533gmyzrVmfU2u9jFqScpO2N7J/2NrcBy+s/4uTGo4xyrwUVWTgV
        QrYdJyQhFzkxv7UR6x/blhNXfEqBAUU6D2+P9XeQSg==
X-Google-Smtp-Source: ABdhPJzVsxIRnXRzkqfX+4EUYDqbW6pnCNN0xiWCPWlBybZjpXqtAz4jBFXNKJrWPI3si5FTgR7HD5Eyk7IDm+X+Hk8=
X-Received: by 2002:a25:ba08:: with SMTP id t8mr6382446ybg.111.1627562765580;
 Thu, 29 Jul 2021 05:46:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-11-johan.almbladh@anyfinetworks.com> <693d7244-6b92-8690-4b04-e0a066ca4f6f@fb.com>
In-Reply-To: <693d7244-6b92-8690-4b04-e0a066ca4f6f@fb.com>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Thu, 29 Jul 2021 14:45:54 +0200
Message-ID: <CAM1=_QRqcVYy+ZAKkqoUZghXqLPuD8E4he47ADCRCegM2oGf_g@mail.gmail.com>
Subject: Re: [PATCH 10/14] bpf/tests: Add branch conversion JIT test
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tony Ambardar <Tony.Ambardar@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 1:59 AM Yonghong Song <yhs@fb.com> wrote:
> > +static int bpf_fill_long_jmp(struct bpf_test *self)
> > +{
> > +     unsigned int len = BPF_MAXINSNS;
> > +     struct bpf_insn *insn;
> > +     int i;
> > +
> > +     insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
> > +     if (!insn)
> > +             return -ENOMEM;
>
> When insn will be freed?

It is freed by the existing test runner code. If the fill_helper
member is set, the function destroy_bpf_tests frees the insn pointer
in that test case. This is the same as with other tests that use the
fill_helper facility.
