Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3723309070
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 00:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhA2XFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 18:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbhA2XFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 18:05:43 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2A6C061573
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 15:05:03 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id 8so834423plc.10
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 15:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hp/5Qf63SVYiEi2ohZItVGmPBR3EhIpEmiCu1aslUo0=;
        b=aDRrl39o6eUhvXFuTEAYVQzisk52v+CX/wAMUvrY8TkU+g1nf4OyYFLgV9nqpYbNiS
         nZattU34tfDLX50yRYxd3rrK59oKMEhdQ6aokwF3TYjQPpGiS0oCO8dGdc0wX9wNexjG
         TbZhI2iUtacHc0TlUXq0arMQlBoVljAzsBnUYPQt1AYF9a+l6gbW/ZUiPPRJUCDTF/LY
         v6JNiuNPiXNvfZiLn/4ukaSgCKw3ASVVMPoTTearUqNkI5kGCp020N9zXTJH7JgA3klX
         BMzBHsdyFzOmMWd5nGxORSisGXv1f2dVOoIluc1SWLAhOTCmG8mAgeqSHkMTPKu4XE+h
         6Vaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hp/5Qf63SVYiEi2ohZItVGmPBR3EhIpEmiCu1aslUo0=;
        b=sXis0rHaR2Y0/4D8eQxBoHoaO5dOTRK9U8nvMdZRHGPnATwL1jHebPPR/op8deBJsO
         Dfx5l/0m8dg2+ZjQvnxOmbqeOlHCF8mHzjC7tknxclzkjZT9pAnWN+Owb5y+eUquDlKt
         z9lmT2oOsbe35MI/SfUvKB5ZHxhQSQgG7wly7SBz+iNrXnmYw6czp7SKf+12JGqswCK9
         WmaEE2WxafV42L3tjtZreSeEPNsxsiNrV3mKa3W+L07Ef00ZaugmNLZJhse+0M9cqSqB
         mASIPKbSguXJfxeVgCk+MXeYrnZNUj7eOrLRWX5wD+fp5xmihG+s8Wf87huFTN9NtVxq
         suWg==
X-Gm-Message-State: AOAM530MPeSqysHcNvYnODMmwekZc4K6nBfc3srg48UPxv2hMYwguBW9
        j8PW55cc6nPGyP5fGiYbXJuvRlFmedCFJlcpxLnN8cFYJZs=
X-Google-Smtp-Source: ABdhPJz84PgqfEjFm5x+UsQMiYLydVn5jKbQWc//lIVxNfmi00hCmXo7lWcNZVieALZB0TGw7kPQ5sa9nW/Uno5w/3w=
X-Received: by 2002:a17:902:d64e:b029:df:e5b1:b7f7 with SMTP id
 y14-20020a170902d64eb02900dfe5b1b7f7mr6164874plh.10.1611961502861; Fri, 29
 Jan 2021 15:05:02 -0800 (PST)
MIME-Version: 1.0
References: <20210129102856.6225-1-simon.horman@netronome.com>
In-Reply-To: <20210129102856.6225-1-simon.horman@netronome.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 29 Jan 2021 15:04:51 -0800
Message-ID: <CAM_iQpVnd9s6rpNOSNLTBHzLH7BtKvdZmWMhZdFps8udfCyikQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net/sched: act_police: add support for
 packet-per-second policing
To:     Simon Horman <simon.horman@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, Baowen Zheng <baowen.zheng@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 2:29 AM Simon Horman <simon.horman@netronome.com> wrote:
> +/**
> + * psched_ratecfg_precompute__() - Pre-compute values for reciprocal division
> + * @rate:   Rate to compute reciprocal division values of
> + * @mult:   Multiplier for reciprocal division
> + * @shift:  Shift for reciprocal division
> + *
> + * The multiplier and shift for reciprocal division by rate are stored
> + * in mult and shift.
> + *
> + * The deal here is to replace a divide by a reciprocal one
> + * in fast path (a reciprocal divide is a multiply and a shift)
> + *
> + * Normal formula would be :
> + *  time_in_ns = (NSEC_PER_SEC * len) / rate_bps
> + *
> + * We compute mult/shift to use instead :
> + *  time_in_ns = (len * mult) >> shift;
> + *
> + * We try to get the highest possible mult value for accuracy,
> + * but have to make sure no overflows will ever happen.
> + *
> + * reciprocal_value() is not used here it doesn't handle 64-bit values.
> + */
> +static void psched_ratecfg_precompute__(u64 rate, u32 *mult, u8 *shift)

Am I the only one who thinks "foo__()" is an odd name? We usually use
"__foo()" for helper or unlocked version of "foo()".

And, you probably want to move the function doc to its exported variant
instead, right?

Thanks.
