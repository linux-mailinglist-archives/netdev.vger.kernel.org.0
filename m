Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC39495CEA
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 10:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349619AbiAUJgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 04:36:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42774 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348823AbiAUJgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 04:36:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642757768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hoaYXAQChgh3tvwXdFFCo3FDp1lyfGhyr9jB0V2S1uQ=;
        b=CWWqhvs3WusJiXCRgEPuHjDvU8VH/2vg242E6CHkm/bBK0g+totxradXXKglQvlQHcrzgZ
        dhqJXzYTWcQE+w2PZDP9wKe3AHD0xd6WWxXBl6Y3v3N6GgwvpOq560xC3wScFmsNNEzj9x
        ic2jcXZP2pp3Pn13yxZ+m/y6iyrkL/g=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-U22KS8nsOnmvV0cBH5sLaQ-1; Fri, 21 Jan 2022 04:36:06 -0500
X-MC-Unique: U22KS8nsOnmvV0cBH5sLaQ-1
Received: by mail-yb1-f197.google.com with SMTP id f12-20020a056902038c00b006116df1190aso17623299ybs.20
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 01:36:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hoaYXAQChgh3tvwXdFFCo3FDp1lyfGhyr9jB0V2S1uQ=;
        b=g7zCmHxZTV4M4qc/V7GQLjz7MLGFHTg9pesG5fDRN03wj2fexweeL8kXnZaz9k7qn3
         hWATIjiSuMucSYbgfZpfO3HsvnqYyR4kp0EcoKFk8JiXo8SD8Eq9kFoXdtDkpc3od4Po
         jkAUjb6+Ma/OZI1T3RnOYf3IH6AoMz4azh+VGISCSwZAmOUkFFVV0PoN3zzt490fyEsM
         1+ffsccck8q0RDymYMZDbLcG+6FNSKAMgOkPA6a9NLmtmM+ZW5qBoN0TbN2JZOHdqbRz
         wZaay4VSRCQi7ml5Jg1figg/badjxkFWmIih5shtqpdlPiCeyPl5calJ723Ha8kr+bwk
         3QIg==
X-Gm-Message-State: AOAM531araRLpXVPjb9WmxasISU4B8oRfo8YMNgPD62mXyTbbrgBhPXj
        gxLuLt6rrav8edwTb/Uqyf+8tXEOrI2A625qL7n9gSiDtBojYDjN1V/Td6sr1WhbbcxBybXBfoP
        EvBJPuwQZg3sjkxbyWyXp9LGhunwtwbnI
X-Received: by 2002:a25:4b85:: with SMTP id y127mr4665444yba.181.1642757766421;
        Fri, 21 Jan 2022 01:36:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwyGcn4L6RaLdxCH2N8NovlcgoKtl+Vz7RkL5ebBc5/DIbMjrmIBVyYorBaC1fYK0xNOTaZbVnwIl43AfNGBLo=
X-Received: by 2002:a25:4b85:: with SMTP id y127mr4665432yba.181.1642757766194;
 Fri, 21 Jan 2022 01:36:06 -0800 (PST)
MIME-Version: 1.0
References: <CA+NMeC-xsHvQ5KPybDUV02UW_zyy02k6fQXBy3YOBg8Qnp=LZQ@mail.gmail.com>
 <c4983694-0564-edca-7695-984f1d72367f@mojatatu.com>
In-Reply-To: <c4983694-0564-edca-7695-984f1d72367f@mojatatu.com>
From:   Davide Caratti <dcaratti@redhat.com>
Date:   Fri, 21 Jan 2022 10:36:12 +0100
Message-ID: <CAKa-r6teP-fL63MWZzEWfG4XzugN-dY4ZabNfTBubfetwDS-Rg@mail.gmail.com>
Subject: Re: tdc errors
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Victor Nogueira <victor@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 8:34 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2022-01-20 12:22, Victor Nogueira wrote:
> > Hi,
> >
> > When running these 2 tdc tests:
> >
> > 7d64 Add police action with skip_hw option
> > 3329 Validate flags of the matchall filter with skip_sw and
> > police action with skip_hw
> > I get this error:
> >
> > Bad action type skip_hw
> > Usage: ... gact <ACTION> [RAND] [INDEX]
> > Where: ACTION := reclassify | drop | continue | pass | pipe |
> > goto chain <CHAIN_INDEX> | jump <JUMP_COUNT>
> > RAND := random <RANDTYPE> <ACTION> <VAL>
> > RANDTYPE := netrand | determ
> > VAL : = value not exceeding 10000
> > JUMP_COUNT := Absolute jump from start of action list
> > INDEX := index value used
> >
> > I'm building the kernel on net-next.
> >
> > I'm compiling the latest iproute2 version.
> >
> > It seems like the problem is that support is lacking for skip_hw
> > in police action in iproute2.
> >
>
>
> So... How is the robot not reporting this as a regression?
> Davide? Basically kernel has the feature but code is missing
> in both iproute2 and iproute2-next..

my guess (but it's only a guess) is that also the tc-testing code is
less recent than the code of the kernel under test, so it does not not
contain new items (like 7d64).

But even if we had the latest net-next test code and the latest
net-next kernel under test, we would anyway see unstable test results,
because of the gap with iproute2 code.  My suggestion is to push new
tdc items (that require iproute2 bits, or some change to the kernel
configuration in the build environment) using 'skip: yes' in the JSON
(see [1]), and enable them only when we are sure that all the code
propagated at least to stable trees.

wdyt?

thanks!
-- 
davide

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=255c1c7279abf991

