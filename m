Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776EC48B2ED
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242842AbiAKRJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242530AbiAKRJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:09:52 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A1AC06173F;
        Tue, 11 Jan 2022 09:09:52 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id pf13so41980pjb.0;
        Tue, 11 Jan 2022 09:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=57czanYP5Q2b4OYDOc6CpasiXsnfYjeLs0Wps/Ww8UA=;
        b=J/XcacddpOe/fOijVK7gKcDJKRjJJg7nVdvQl1Q0CuNQv4lRpopqUBWn6T5ccjT3B0
         N8OVnbm1uNp+6ZNMnFxqHQyfT+fOStOLtg2n78GfnpU7OLiaJp6vOv7qXwuPjdpfUJz+
         P26rN+PEMAhvp2vnYZgT91LCmWY8pt6zpPYqR2PG6gKdoC12LktLmP5eySGGoFVEPsxI
         gtZ996KWj2kqCwLStu/1ybbu7pQNVUuB2N0r/3fDKD4NA49Y3XpiTFQifmDKcAzHr9SG
         2yS0uselQPtB3ZHX8n6msxKP6VqG1q8jsbuKmsMVfrA/rA5yPGmmDENY/FiOL1HsXFMK
         Kgxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=57czanYP5Q2b4OYDOc6CpasiXsnfYjeLs0Wps/Ww8UA=;
        b=c0wYDHxJpsJUeFmq3GFo59QqhY7D5KRv5+bLONxUUUc+fu6qsnaN1VuljHXncDJS8y
         RnqQ4kBPhO0uamY6QN3BOxsFDxSBPY2yRKBE+lkDRfqRsaXMaa1u31pLioYxXgM39AzI
         OtQ49ag9M4rAXDg+JWP3Theu4QnByF6SzNLfiXSQUC1GQi8ODtIdzWk1sc5GmsvQNf3i
         PRttI746Z1wWRPtcM34Regnet2GaZAgh+0YmcYAAS36BLRwI4AAldLd6e1AVjbnji+SC
         9NYfV1gA3Z5lDo0IzKVrkFC5vHlWPzP+EyJHujrRb7yLsfj7SXzVAkkLwAm9fliLbDdX
         lj4w==
X-Gm-Message-State: AOAM531riNYxuTfrDoCb8/c4IStXXxWYfRTaTC+EF0unmYX4VzmHtaTT
        quStuMJ7SNNLnOV8UaEbBUI=
X-Google-Smtp-Source: ABdhPJxvqKdeEG6ekW/di2Oj20ysA6X9QvFmKDXCgk5AA1AFNsL2x63WhUwfPu7eDovgAoj8qfKdpg==
X-Received: by 2002:a63:8f09:: with SMTP id n9mr4810039pgd.308.1641920991608;
        Tue, 11 Jan 2022 09:09:51 -0800 (PST)
Received: from chaofan ([111.199.185.103])
        by smtp.gmail.com with ESMTPSA id t207sm10378069pfc.205.2022.01.11.09.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:09:51 -0800 (PST)
Date:   Wed, 12 Jan 2022 01:09:46 +0800
From:   Wei Fu <fuweid89@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com,
        fuweid89@gmail.com
Subject: Re: [PATCH bpf] tools/bpf: only set obj->skeleton without err
Message-ID: <20220111170946.GA16663@chaofan>
References: <20220108084008.1053111-1-fuweid89@gmail.com>
 <CAEf4Bzag+qQOs86t2ESmYvTY8xCip+_GTKqXa0m7MQWjDMO5Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzag+qQOs86t2ESmYvTY8xCip+_GTKqXa0m7MQWjDMO5Mg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 09, 2022 at 06:04:45PM -0800, Andrii Nakryiko wrote:
> On Sat, Jan 8, 2022 at 12:40 AM Wei Fu <fuweid89@gmail.com> wrote:
> >
> > After `bpftool gen skeleton`, the ${bpf_app}.skel.h will provide that
> > ${bpf_app_name}__open helper to load bpf. If there is some error
> > like ENOMEM, the ${bpf_app_name}__open will rollback(free) the allocated
> > object, including `bpf_object_skeleton`.
> >
> > Since the ${bpf_app_name}__create_skeleton set the obj->skeleton first
> > and not rollback it when error, it will cause double-free in
> > ${bpf_app_name}__destory at ${bpf_app_name}__open. Therefore, we should
> > set the obj->skeleton before return 0;
> >
> > Signed-off-by: Wei Fu <fuweid89@gmail.com>
> > ---
> >  tools/bpf/bpftool/gen.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> 
> Great catch! Added (please add it yourself in the future):
> 
> Fixes: 5dc7a8b21144 ("bpftool, selftests/bpf: Embed object file inside
> skeleton")
> 
> Also reworded the subject a bit. Pushed to bpf-next.

Sure! Thanks for the review.
