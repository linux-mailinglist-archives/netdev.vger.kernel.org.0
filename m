Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06238398482
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 10:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbhFBItz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 04:49:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25790 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232821AbhFBItt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 04:49:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622623686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QAqDQbuc2zHT+lmvkpkliupEQ5G+pBOcwfPuyVGkZ4M=;
        b=e5U296M4a+m6Up0N6568RA9rPQfdLxacxq9IaJvKiLNsg/fNrMtHE0HyK4OKuTAbbmj+Ki
        sjv6hrK6kwP/HVZEd+hp0zBfo6szo9eb1tdJrKg/X8P14yCT8P04lEnmj8fvOlljfHZL7t
        VU7lLIopYAXR3PRNuAfZbxy6xfz91wM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-4F5Wf6yZNCSZocwA3gLr2Q-1; Wed, 02 Jun 2021 04:48:05 -0400
X-MC-Unique: 4F5Wf6yZNCSZocwA3gLr2Q-1
Received: by mail-ed1-f70.google.com with SMTP id da10-20020a056402176ab029038f0fea1f51so989419edb.13
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 01:48:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QAqDQbuc2zHT+lmvkpkliupEQ5G+pBOcwfPuyVGkZ4M=;
        b=Rk2I4cjge4ZkbsmnrSN6Ay/jFHvCaqlQXTNJd5m7Op5Hv72LP8BaYyC2XV2Zvkkm3y
         voBfIdT4xMaOvq4/hATMACHGD6vipHgd7Jp83i7dv5EfPZrrx/MWcCv7mgEeCFeGScd0
         lqsOEd7/OjM8ZDp9ccQOGBHN2DEYyk3zyQ+Hq7ezHXA8JYixK76Lbfr3uviIFHJ66tTe
         5N8whmHMhSrS8oeMLZR+mTsS3rrzRhg8W/4CfPvzPLDXc2gjauL2wH9/yPSa07DSd6FY
         U5EG606BGVIPDDDQvU/zkDPyYuM5ZZ3ZSuET65DJ1fOcaNq+zGSzmGgNPSqrM+ublmvb
         Oxfg==
X-Gm-Message-State: AOAM531SChb8nlVFNqrxAhfMLQpVwP2VJjt2eFsKYheaU+mhJk9Sl1cv
        gc5d+XwJx0UVRQDxVO4n4DWJuzPxUgI5hcNQHV3G/xJHZ8sX1gC9uhCVjm8tZYhF8CO85W86pcU
        2Tan4FgUgTttepOKs
X-Received: by 2002:aa7:cb5a:: with SMTP id w26mr4404204edt.139.1622623684383;
        Wed, 02 Jun 2021 01:48:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywfTaE0hAprvL9p9WssZnPY02Ob4LEn6uB7GNvr1kyQ4a1zhsGY1pnoio1QZitdVpv/kIDLA==
X-Received: by 2002:aa7:cb5a:: with SMTP id w26mr4404188edt.139.1622623684082;
        Wed, 02 Jun 2021 01:48:04 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id n16sm893224edw.26.2021.06.02.01.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 01:48:03 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CF229180726; Wed,  2 Jun 2021 10:48:02 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
In-Reply-To: <20210602020030.igrx5jp45tocekvy@ast-mbp.dhcp.thefacebook.com>
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <CAM_iQpWDgVTCnP3xC3=z7WCH05oDUuqxrw2OjjUC69rjSQG0qQ@mail.gmail.com>
 <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com>
 <CAM_iQpU-Cvpf-+9R0ZdZY+5Dv+stfodrH0MhvSgryv_tGiX7pA@mail.gmail.com>
 <CAM_iQpVYBNkjDeo+2CzD-qMnR4-2uW+QdMSf_7ohwr0NjgipaQ@mail.gmail.com>
 <CAADnVQJUHydpLwtj9hRWWNGx3bPbdk-+cQiSe3MDFQpwkKmkSw@mail.gmail.com>
 <CAM_iQpXUBuOirztj3kifdFpvygKb-aoqwuXKkLdG9VFte5nynA@mail.gmail.com>
 <20210602020030.igrx5jp45tocekvy@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 02 Jun 2021 10:48:02 +0200
Message-ID: <874kegbqkd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

>> > In general the garbage collection in any form doesn't scale.
>> > The conntrack logic doesn't need it. The cillium conntrack is a great
>> > example of how to implement a conntrack without GC.
>> 
>> That is simply not a conntrack. We expire connections based on
>> its time, not based on the size of the map where it residents.
>
> Sounds like your goal is to replicate existing kernel conntrack
> as bpf program by doing exactly the same algorithm and repeating
> the same mistakes. Then add kernel conntrack functions to allow list
> of kfuncs (unstable helpers) and call them from your bpf progs.

FYI, we're working on exactly this (exposing kernel conntrack to BPF).
Hoping to have something to show for our efforts before too long, but
it's still in a bit of an early stage...

-Toke

