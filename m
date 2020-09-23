Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5018275D02
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 18:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgIWQL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 12:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWQL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 12:11:59 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614D4C0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 09:11:59 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id 60so276424otw.3
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 09:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aWzl/EC6q1pepHIHQi8YGbYrZy43GP7bLV6xiCO5CnY=;
        b=pBaRxKZY6Bq2LG6skyZ0ElNlD3I6//8Tv7LZ7nCwhl+ieLIbsPkxkcsnt9Ev4Q1/dZ
         VzCRsuwVuGKIcAPSgazwokeiQ63BxqmpXK/xFIazF4AQwF3nfvWnYk7cjxKnkkVpoOqf
         rsQXyL3NEaFTZ8Ib6YNGYCAT7T3SXQBkdsjY4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aWzl/EC6q1pepHIHQi8YGbYrZy43GP7bLV6xiCO5CnY=;
        b=faguXq2hEuCW4g2vkJGGzPFqFl9g72JNpuZW6WvgilMvBtlini2iJ4Rkkx7cHUiH6K
         XDgEk5WIdVadF/gdufVdk9lhFXNwGAoljWPqr8FNa/aAIKv0xgiGzMRPSpu2rVE3FU0i
         3nC4xdhymKzODd7X7gsUoQy5+9hrSYFBiAF93Zi23RXuRIGvyKzUOYKfidDO9SUD/cP3
         90sCVpJPn+JsZuX98PofttXqA+gqBLYlAXkfAlLQmvYXOy0T6QGIFkwP//2h/wufk7FL
         KkXRKQC8JDOUMLv3jO8n9oS7M8KM5Vg9MUIMBJUs76tJsb41g+/oc1zbd9a1cNn0ZzDV
         wNwg==
X-Gm-Message-State: AOAM5325HSyadztouqt0ppQ80IFtv6TubuU7Ywy26DlyDlkJymZBPrRi
        djtlwm/PJ7DY2kZYn39ZC5Mkoqgf4Wl/hZIPIw9Emg==
X-Google-Smtp-Source: ABdhPJxy/3/VR1e4GrSjqMPRO34URDmZ6fFIeChhcGylh80eAg8kX60nx9dCxpNmw/vexEssXy4qmLm0gc5DHRcvyM0=
X-Received: by 2002:a05:6830:1653:: with SMTP id h19mr260459otr.147.1600877517353;
 Wed, 23 Sep 2020 09:11:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200916211010.3685-1-maciej.fijalkowski@intel.com> <CAADnVQLEYHZLeu-d4nV5Px6t+tVtYEgg8AfPE5-GwAS1uizc0w@mail.gmail.com>
In-Reply-To: <CAADnVQLEYHZLeu-d4nV5Px6t+tVtYEgg8AfPE5-GwAS1uizc0w@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 23 Sep 2020 17:11:46 +0100
Message-ID: <CACAyw994v0BFpnGnboVVRCZt62+xjnWqdNDbSqqJHOD6C-cO0g@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 0/7] bpf: tailcalls in BPF subprograms
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Sep 2020 at 04:26, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
[...]
>
> Lorenz,
> if you can test it on cloudflare progs would be awesome.

Our programs all bpf_tail_call from the topmost function, so no calls
from subprogs. I stripped out our FORCE_INLINE flag, recompiled and
ran our testsuite. cls_redirect.c (also in the kernel selftests) has a
test failure that I currently can't explain, but I don't have the time
to look at it in detail right now.

Hopefully I can get back to this next week.

Best
Lorenz

--
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
