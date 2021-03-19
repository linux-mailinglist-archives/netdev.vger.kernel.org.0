Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11709341367
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 04:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhCSDOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 23:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbhCSDOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 23:14:12 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739EAC06174A;
        Thu, 18 Mar 2021 20:14:12 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id u3so4775471ybk.6;
        Thu, 18 Mar 2021 20:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=elw9sMcXdAUZNIfVaedkZcIkuQIRdhJqvkBpf/+pDA4=;
        b=pYdJ1JPHu3NaSDVmlY26DtWqvl0T5dpyP7xvFKG9t8TaidWVgV4EYeIsrB0mmu1nOH
         5kZlYlk7plK9WMQxUdLtWOUWCb7yS08IFl6QaSwF4jEK7sR3Tr3NL8pKITUh0EPZEIYZ
         PxM+D/2pjdj8JWAsjI02KZ86ijxhHjw020l7u/qvLqJCJC6NgKGQDW4BzFvqSjpfhMLf
         h6pM3sKp/YwpQj85cpIEurDOU5FoQu9UYfTclcu2JWrMmbrQi4xfflY2A3rfmZftaVbe
         MuqvTC/01IaDUJxnOIaZ4ccie1vkznNbRuIEsuQgLe5vuCOMG5RcVe13lS0TZ0P5S1j2
         R8Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=elw9sMcXdAUZNIfVaedkZcIkuQIRdhJqvkBpf/+pDA4=;
        b=sdd2DsATPlmoMYd3xWpg9CZMFJAcKjuctkYeKGkt64oTOTK5x5Rgyb+L+gzetlfrPL
         dsYFxai3lQChvPCZ+3hXa1mB7b0SvYDqTH2Rju9X91o4O9SvQqhdEJIn0PO7J0ax18rk
         6mk81P9pizmEMHi0MsjQAxb7orIy3kr6lafI4Dw1eG0YZOXC6ZjyHs7So/jZLRmkeSdD
         5n9QBq8CkQzbXREbJaEmyNamVai3kjMm7mWEGAhKchQRx4naKjvg/y/v6nB89mCUapCN
         J/AbaYG+Q8w+oOycwCCbtdqgq2UYaEHQHgAadEF3o/BffZnXlD2hcDyIb8BoxXt0wEUB
         z/kA==
X-Gm-Message-State: AOAM533+e6LRXdj4pVdb3QSaqcFptU60gWvYinfFfU7B4VWi8kZEZy7B
        70akSFauCZi+OOGUK5PZE+rdEM9QzzxPbU4ZZCv/vtMwYIOi8g==
X-Google-Smtp-Source: ABdhPJyERLOB4RpEeR5wYktPfbmXC58MsFSGONjhPPI6BhSmwUYzYcUkzO0RKgPxfbwdGHolNRTzY19bAwTd0FNS7p4=
X-Received: by 2002:a25:74cb:: with SMTP id p194mr3610534ybc.347.1616123651759;
 Thu, 18 Mar 2021 20:14:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210316011336.4173585-1-kafai@fb.com> <20210316011432.4178797-1-kafai@fb.com>
In-Reply-To: <20210316011432.4178797-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Mar 2021 20:14:00 -0700
Message-ID: <CAEf4Bzb7=WG24jqh_Gt_L1gd7jgoDzOOvb9rOzt4CB1e=dkToA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 09/15] libbpf: Refactor codes for finding btf id
 of a kernel symbol
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 12:02 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch refactors code, that finds kernel btf_id by kind
> and symbol name, to a new function find_ksym_btf_id().
>
> It also adds a new helper __btf_kind_str() to return
> a string by the numeric kind value.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  tools/lib/bpf/libbpf.c | 44 +++++++++++++++++++++++++++++++-----------
>  1 file changed, 33 insertions(+), 11 deletions(-)
>

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
