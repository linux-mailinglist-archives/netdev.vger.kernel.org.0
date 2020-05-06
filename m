Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F291C772A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730793AbgEFQvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730444AbgEFQsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:48:20 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F83EC061A0F;
        Wed,  6 May 2020 09:48:20 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id a21so3087597ljb.9;
        Wed, 06 May 2020 09:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=IlweazdekYqS94U1Xj1r4OmuyOC1Nv3qU7YSDeCBRlM=;
        b=AN3uHAOGD4JKrw8xuzUE7vpMKBJ5J8AJ/7JmX91Bmlt+py0Z7v16qngoQx+tkwuEVh
         gDpn6xF1T0uGoHJmF8E0ezr227yjEmehoFoC75hYmJJ+AMM2GsbPnaoWgepSJv+B/vXa
         PJT/p93k7uV1awCS2I4lP5lov50nMdUvCqkj9GU8Ua4CVJMEViYfoc9UKixCMp1mU4x4
         A7iQ4nCVxlfU8K+H5FOSAfPpL6x8VVJBBx6YGA5VM+/2oythOg7/4oVj6mxPOt4mGHwK
         ZcfNzwyMyLlHugrgi58R2Dr/grZOWsFfQPr+lewnPi6AYqpI44xbxkbMWTTIDE5JyL9I
         pMUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=IlweazdekYqS94U1Xj1r4OmuyOC1Nv3qU7YSDeCBRlM=;
        b=uO4dendeLXG1enmS0QZc5KIIr+yCo+02YCdu8NKt10G6M9MKQyQum3bfOjuBcj/LkY
         ul0kuFOiV1Q+bLsbV8NFiBesUXCCTaeiBI3SfmX2vN1J2NU4ysWl+u2ziFJPXZtQgn1C
         Y1ScKLcs0VTedGZrDFvlQqObLNKKxM0MzGCXgPraDMIYAW4K0d5CE71QH5US/yNPVqjL
         AbrcKJiUWOMMfIQ5ma3uV21v/0l7DcZhNzL5CJpfvInCPNvsNPjwfDE45OQqahZw2f0c
         VB0ulBcjkadaSLOB21Vm0MjVp3odAG6Jj6Fj/m9yx4DLYXS2gFA+Nb5rv2sT0YY9D7Rb
         BQlg==
X-Gm-Message-State: AGi0PuYNXh4Qr5w2eWD5aD/Ai4ymzBWYpIJOq1Xq321d/DkNj32SIfpo
        M7VKtellgQQy723UroGSAFHDn1gTF9SaeSIo1+CuCw==
X-Google-Smtp-Source: APiQypI2hjOb8TJaiPFfUG3oI9wfgz7TFR6gbZ+bohBeA0V3R1j0LyOpgLqQFPK3JItM2/KSqOJkEQ1G8J7Bw/Zepdo=
X-Received: by 2002:a2e:9011:: with SMTP id h17mr5839071ljg.138.1588783698970;
 Wed, 06 May 2020 09:48:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQJfD1dLVsfg4=c4f6ftRNF_4z0wELjFq8z=7voi-Ak=7w@mail.gmail.com>
 <CAADnVQ+GOn4ZRGMZ+RScdSvM8gpXD9xbe3EYHCcUHdSs=i_NGA@mail.gmail.com>
In-Reply-To: <CAADnVQ+GOn4ZRGMZ+RScdSvM8gpXD9xbe3EYHCcUHdSs=i_NGA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 6 May 2020 09:48:07 -0700
Message-ID: <CAADnVQLKuLu8wMJNO5w3AtFqyUTMmwzpctJMw0ORyUJM=M3bwA@mail.gmail.com>
Subject: Re: pulling cap_perfmon
To:     Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 4, 2020 at 1:52 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Apr 30, 2020 at 11:03 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > Hi Ingo,
> >
> > I'd like to pull
> > commit 980737282232 ("capabilities: Introduce CAP_PERFMON to kernel
> > and user space")
> > into bpf-next to base my CAP_BPF work on top of it.
> > could you please prepare a stable tag for me to pull ?
> > Last release cycle Thomas did a tag for bpf+rt prerequisite patches and
> > it all worked well during the merge window.
> > I think that one commit will suffice.
> >
> > Thanks!
>
> Looks like Ingo is offline.
> Thomas,
> could you please create a branch for me to pull?
>
> Thanks!

ping
