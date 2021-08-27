Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B466E3F9150
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 02:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243823AbhH0A1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 20:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhH0A1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 20:27:22 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844A8C061757;
        Thu, 26 Aug 2021 17:26:34 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id s21-20020a4ae495000000b0028e499b5921so1496527oov.12;
        Thu, 26 Aug 2021 17:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pnwBhL+bIRZ+1AujOyithEsycI0iSDtmHs6X+/x+Fhc=;
        b=sBP1y9OgvieB5CccQH32mPE+X+ashq9FrlnUIlsj20FzDRksOusy3AEq18QQTjGlTN
         j7HCMqzoDTKGUfxl+NjSTSPWAUvFySjZO2ED4rFuZfmfE1hI6G1UxrJ+xMKI6/Q8ot8S
         Sm1unDbFtNAXi53kHjGwYPwHpcpv93aMMdzCexVagDs0dEy6PmXV9BWlHWVWJrBKn2Jn
         EnWBCmWzEhsA6E9EqeyVzjiW0afuEbMkhoV+ivtaNJW8PaDxbtZr/xwdBRfdeY0D/S86
         HUhj6QWPmCd3lNBSskZ67qX+MG9QVqCHfVaCI+HGe84L3JR3YSDQtuQ4mlLI5azhbI50
         YxGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pnwBhL+bIRZ+1AujOyithEsycI0iSDtmHs6X+/x+Fhc=;
        b=anoBQSwBHflfgaX5kbSsRaRh8R8BeVqXiXb4x4iYuc8xYtG0L8w1oCTv1xHGxmu3Qt
         kQe9pRDk3DaGpmqTW4m2nlxtM1REdN8u7tYRtiyFSglIzZ1jkb3zsAPESIsq7FqJIWx6
         tL+/R06izYrKoBxVnSTW/cAj2U+3g4G19AhWuT6fcbR+OPQsvMTlt7T6M3RjyZIkhWb7
         okPVqdYpMJXh1C92KUVBsiAcMwBANHq73LdIgQvrRNdoaawUy0+7jXMZGFdOmi/JLxuf
         WRbV5jKLFU80G8hVjJFQVhYTaa5WHMV4AbSxDBfJMlKTD4CdkE68oXC70KT8OZpSpAEm
         8afw==
X-Gm-Message-State: AOAM533nl1W1cUWdj+RqXLYZj5iNBot4iYN9x9WhxA9lbDFE18rxiT+P
        pinFXA/jQdyhDLRiGEcynbqS1syPYEekixKuhU+KVyT+sY1eNsQH
X-Google-Smtp-Source: ABdhPJzaoHbOjah8e/X215Kp/Z3xDTS2cp8NQupcSAzhDxBFPFu/G55Fo9UBoorbueobdipf4Ayxle3exSXBftAU5DA=
X-Received: by 2002:a4a:5742:: with SMTP id u63mr5507687ooa.87.1630023993563;
 Thu, 26 Aug 2021 17:26:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210826141623.8151-1-kerneljasonxing@gmail.com>
 <00890ff4-3264-337a-19cc-521a6434d1d0@gmail.com> <860ead37-87f4-22fa-e4f3-5cadd0f2c85c@intel.com>
 <CAL+tcoCovfAQmN_c43ScmjpO9D54CKP5XFTpx6VQpwJVxZhAdg@mail.gmail.com> <da5da485-9dc7-e731-a8d9-f5ad7c7dffde@gmail.com>
In-Reply-To: <da5da485-9dc7-e731-a8d9-f5ad7c7dffde@gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Fri, 27 Aug 2021 08:25:57 +0800
Message-ID: <CAL+tcoCyYeb+ppM4gBU3MZWKcm4513J49QNu2yLjY2O8-KaRog@mail.gmail.com>
Subject: Re: [PATCH v4] ixgbe: let the xdpdrv work with more than 64 cpus
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 2:19 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 8/26/21 10:03 AM, Jason Xing wrote:
>
> >
> > Honestly, I'm a little confused right now. @nr_cpu_ids is the fixed
> > number which means the total number of cpus the machine has.
> > I think, using @nr_cpu_ids is safe one way or the other regardless of
> > whether the cpu goes offline or not. What do you think?
> >
>
> More exactly, nr_cpu_ids is the max number cpu id can reach,
> even in presence of holes.
>
> I think that most/many num_online_cpus() in drivers/net are simply broken
> and should be replaced by nr_cpu_ids.
>

Thank you, Eric, really. I nearly made a terrible mistake.

> The assumptions of cpus being nicely numbered from [0 to X-1],
> with X==num_online_cpus() is wrong.
>
> Same remark for num_possible_cpus(), see commit
> 88d4f0db7fa8 ("perf: Fix alloc_callchain_buffers()") for reference.
