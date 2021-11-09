Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D2D44B2B7
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 19:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhKISbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 13:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242435AbhKISbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 13:31:07 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED54EC061764
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 10:28:20 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u17so52526plg.9
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 10:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YqtAkERQI/ln6XRRI9t4KGym2pBKGt4SPOY54xOyYmc=;
        b=PGOJkkhM/AspXaJubyodGGt3bokcuo1nWeF66Ozy2PSHqL4ozl1ealnJ2sESU77Daa
         5PCgxSnMKmr5LSn7P+UZw5lKAiqvWF452/e/zcO5+QvHTusOJTtt+u60C6PqqZ1Yg/LF
         XnAN//7pVh4I0+4GH1pCdd6cp3HnHcZsIY7gg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YqtAkERQI/ln6XRRI9t4KGym2pBKGt4SPOY54xOyYmc=;
        b=HVRkjjkti5F7V+p4vZkm+IfeFAXAleFrWW5vR/FzHRHdcm8q6gGRKiXguAAQu1sUi+
         6KUZK0+qB70K4a7RUsQLO96e4N7q+2XGB/YASaTntmVe6/v4cP+JWnhsvm5jZlKW4TfZ
         0bglJeR7Cci8z92Q8dLt7tRQpbFNzpvqJbq3/1FkeYGdGIdiDr+Eb6RE5NCTEzJiVo2I
         /vjQRRm1BR6Wh8uUm2i7ht8Dn5YpIS7owS2HpoTP3ritTQ9abb+ADq7wi7FNdjxLYGRt
         Jzg0+uy4cb/A9MLeJfibOdzJv9gmEbLz+oqSyKX79QlFlDWppQOVmco7olunq9pr5dSg
         tAUg==
X-Gm-Message-State: AOAM530ywX7VbYnOBM4kW5LILuBJC5Kx64vZbkOu28HjNTyGrq9+mAn4
        zRa9L/aZt2A47ehvUhUiEsTABA==
X-Google-Smtp-Source: ABdhPJw56zqbHPhzHi/UjO1EuTMs0ckASHUWtACCQVftB6fOpzf6idVKbxIvoc6DXqmWnHNuFyu1UQ==
X-Received: by 2002:a17:90b:3a89:: with SMTP id om9mr9485773pjb.29.1636482500572;
        Tue, 09 Nov 2021 10:28:20 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u11sm7194577pfk.152.2021.11.09.10.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 10:28:20 -0800 (PST)
Date:   Tue, 9 Nov 2021 10:28:19 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 0/7] task comm cleanups
Message-ID: <202111091027.DEF1B6DD@keescook>
References: <20211108083840.4627-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108083840.4627-1-laoar.shao@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 08:38:33AM +0000, Yafang Shao wrote:
> This patchset is part of the patchset "extend task comm from 16 to 24"[1].
> Now we have different opinion that dynamically allocates memory to store 
> kthread's long name into a separate pointer, so I decide to take the useful
> cleanups apart from the original patchset and send it separately[2].
> 
> These useful cleanups can make the usage around task comm less
> error-prone. Furthermore, it will be useful if we want to extend task
> comm in the future.
> 
> All of the patches except patch #4 have either a reviewed-by or a
> acked-by now. I have verfied that the vmcore/crash works well after
> patch #4.
> 
> [1]. https://lore.kernel.org/lkml/20211101060419.4682-1-laoar.shao@gmail.com/
> [2]. https://lore.kernel.org/lkml/CALOAHbAx55AUo3bm8ZepZSZnw7A08cvKPdPyNTf=E_tPqmw5hw@mail.gmail.com/

Thanks for collecting this! It all looks good to me.

Andrew, can you take these?

-Kees

-- 
Kees Cook
