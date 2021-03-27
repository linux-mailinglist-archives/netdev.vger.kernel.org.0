Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB75E34B42A
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 04:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhC0Dyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 23:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbhC0DyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 23:54:12 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CA5C0613AA;
        Fri, 26 Mar 2021 20:54:11 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id w8so3469614pjf.4;
        Fri, 26 Mar 2021 20:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=9q46zmcNWInf3xrHk63qlACv7qifZzltPJ3X3hLOIOg=;
        b=H6el4ppzmFXRXBuX4SmUjPLvFGMw0ej6T7BO4FbOO3zlZUTX+o2zDfSBVTmIITxoiL
         B4F/oD3KnFCBbMNPzhq/jBDKumOIIGjvMMm5Hx1p2J9CoagJp7FoYQF5w/1eIvh9LFUp
         M3cS60QcheGHT+cG4lWVK/etKsHfOfuVZlzxY0R4y7Q2Fa+nLecShY9qdqb/G9h2S9r+
         kyN9yFgUO3o7ruzYp8cBIn6ZBlm/OsEXubLF5xpy2yiE3DTHxM8lQa7NcVyvlEpe0EpE
         77gjExBnAl3O9xzYlYKkpv8CeAyrmuwUsdaKkgyOA+CF5aqY/cnhO6POn9xCKIuVhxiv
         B+wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9q46zmcNWInf3xrHk63qlACv7qifZzltPJ3X3hLOIOg=;
        b=MjMwLmczFUpuqqQ/KaaZf3JThzFoZEK1iDGwD/hoQUG34IDlmfN1cuAFXEFln8oKZY
         StSsLope6tZhadPssqn8rj6LJX4dtdc5G5Tmsz+kre4dpjMRCkdqRRcD6E6Ctp9g8kPp
         uKbNYjVcP9hv57lD50qpyZYxQOein59z54rV3OQY1ozy3sWtJUugyMRvyOQiiXjMTNOH
         EOONHj4vkjJ/zkguZ4pcgQhhm+oQLsFGWZHFhG1lqJcwwG5cpQf45bxirsmu5fNYLLaM
         sXQjiFTKxz4uCupUEUdd0a+Z7EXJGB77JwMP8bHj4ffTIu4GquN6To1PLHrdOYIQ2faP
         1GZQ==
X-Gm-Message-State: AOAM530bvePY3kOKvemQzz16PRCxnEPpzOHao9wdoK/tJUOZ5NQ5Y1Bu
        GdvlbY+bWZkmEY/QLtCMeaYUAq9ksALUbw==
X-Google-Smtp-Source: ABdhPJyWP9hLgVYRkewlm98IDU526WaW9IvIQDUzeELbIz32c9NpFdfueklXY9XvhzhNv4jbDQfaAg==
X-Received: by 2002:a17:902:d4c2:b029:e7:32bd:6b77 with SMTP id o2-20020a170902d4c2b02900e732bd6b77mr5789677plg.45.1616817250873;
        Fri, 26 Mar 2021 20:54:10 -0700 (PDT)
Received: from localhost ([47.9.171.52])
        by smtp.gmail.com with ESMTPSA id 138sm10890004pfv.192.2021.03.26.20.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 20:54:10 -0700 (PDT)
Date:   Sat, 27 Mar 2021 09:24:06 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/5] tools pkt_cls.h: sync with kernel sources
Message-ID: <20210327035406.bkc6qnklz5gjgtnm@apollo>
References: <20210325120020.236504-1-memxor@gmail.com>
 <20210325120020.236504-2-memxor@gmail.com>
 <CAEf4BzaVK4=vB6xaMc-VwhQagg6ghx8JAnuLsf43qZa_w_nyyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzaVK4=vB6xaMc-VwhQagg6ghx8JAnuLsf43qZa_w_nyyw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 27, 2021 at 04:55:51AM IST, Andrii Nakryiko wrote:
> On Thu, Mar 25, 2021 at 5:01 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > Update the header file so we can use the new defines in subsequent
> > patches.
> >
> > Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  tools/include/uapi/linux/pkt_cls.h | 174 ++++++++++++++++++++++++++++-
>
> If libbpf is going to rely on this UAPI header, we probably need to
> add this header to the list of headers that are checked for being up
> to date. See Makefile, roughly at line 140.
>

Ok, will do in v2.

> >  1 file changed, 170 insertions(+), 4 deletions(-)
> >
>
> [...]

--
Kartikeya
