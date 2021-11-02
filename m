Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5E3443985
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 00:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhKBXWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 19:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbhKBXVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 19:21:43 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5143AC06120D;
        Tue,  2 Nov 2021 16:19:08 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x66so443628pfx.13;
        Tue, 02 Nov 2021 16:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x3KYIl2RmfZiFMPLreQReW0AtYCyiKE94y/hBMKiNfs=;
        b=KGVjZzKwiROgE8HWH+kQG+OxDlcR9JfCDPLvYJS4KSOi/9kY6SymRnksTVV0LmDzYw
         g2MPztKtUF7jihnaZERfeQKXQ8r6w+V8pryGKWHmNRRahibqey2u/x72gdmobbPHQ7o8
         JjxK9Dw02bDux7XLHz0T2HsIKANy5FCxhpuC8JvZE0Hhce9HupFoJgv/ZnhN27scVERR
         oVYDbWXw9EP3RhJ7wCq9566WoyQDAyDWuLMU9gpZq7SOWoFYCnawX5Kt8SIU/RqQCKSb
         k3gZ5Hksp0YwNTLtJJV863AyshElwJp/0UyzePADZi7rqtkyvuZ0lCxf8B2y2VS7djvv
         OIUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x3KYIl2RmfZiFMPLreQReW0AtYCyiKE94y/hBMKiNfs=;
        b=7rk/34Gj881dUdzlp2F+8yXrU2IbYpiRU8cYqxdAwa0EULTES7wEydiOY1JD4pHMx3
         sYwqlicZ4KH1FmnL5CAjKVL/h5Og87RPE4y2zSaNKE+7oymd0AhvPen2dd7kmws5kfsX
         kLXqft2QhUaurA6VCcIIskLuSLKU0a57dkTGv2CSAYPr26s1VzPEKX/NnZLdcYmaChe9
         2kgWR9FX6YUbTXLfyD0u/bAsDykv1n/PXtHk8UaSZjdJvfKPGl2mzxDUHwFgSDBfWbIy
         CbpcxTA0rNYELvOxy7hu04vX6Uu5hiZ5IM0UwWxW1zANFVU7ZS/VvEgMwsjk8A6YI7LG
         ehHQ==
X-Gm-Message-State: AOAM532x73CdLwksgM/3vc7o2To28JfBVYeeU2hw3ZcljiB1MpxeeSwE
        /COrMBk/vaBpyYmYimjSgJk=
X-Google-Smtp-Source: ABdhPJxg5YoLmT0R43lqEDsSFk0Vktwr2XYbl2ZgPIMiiJulmETALee6zpv5jlo4ANoT08SRtpkK8Q==
X-Received: by 2002:a05:6a00:2405:b0:3e1:9f65:9703 with SMTP id z5-20020a056a00240500b003e19f659703mr40674356pfh.6.1635895147855;
        Tue, 02 Nov 2021 16:19:07 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9df1])
        by smtp.gmail.com with ESMTPSA id ip8sm3929418pjb.9.2021.11.02.16.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 16:19:07 -0700 (PDT)
Date:   Tue, 2 Nov 2021 16:19:05 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC bpf-next v1 5/6] net: netfilter: Add unstable CT
 lookup helper for XDP and TC-BPF
Message-ID: <20211102231905.5q6jdddyrobny63b@ast-mbp.dhcp.thefacebook.com>
References: <20211030144609.263572-1-memxor@gmail.com>
 <20211030144609.263572-6-memxor@gmail.com>
 <20211031191045.GA19266@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211031191045.GA19266@breakpoint.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 31, 2021 at 08:10:45PM +0100, Florian Westphal wrote:
> 
> Depending on meaning of "unstable helper" this
> is ok and can be changed in incompatible way later.

"unstable helper" means that it's not part of uapi.
All kfuncs are like that. They can and will change.
bpf progs that call them would have to adjust.
Just like bpf progs that read kernel data and walk kernel types.
