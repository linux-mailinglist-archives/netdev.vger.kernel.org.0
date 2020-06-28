Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3DA20C9D3
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgF1TJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgF1TJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:09:31 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EACBC03E979;
        Sun, 28 Jun 2020 12:09:31 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q90so6300517pjh.3;
        Sun, 28 Jun 2020 12:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JZBJV05R4IVsZf04PFv9ZJ5X6xhIx2E5BZ8UHc5FNyY=;
        b=T+/ASvv3hQw2nhyAbvNU3BRA9CElgUAyNDHFTTg+6m+1yFiONZINJMQbdBMyf5M7xs
         tEPa2LlUctZB0R3bfGytUhU5590oEL2YfztKE1432TPMnWEjBEPpXNy55R8R/AbKy2DR
         fKy4gorYMMto+PghHGZmUk0U70VdQb7WULX+ePqfGah4Vz5ixL8Ei4dy6KGU9gXJSgWE
         FUmjOnXTZb+xEYUsvcXtiiHz38EOOC/j4dm5e+6lhOhu7aGDDYBh22mqMP1PhaJGWacH
         CZHK1CRe4EnYnV5eagIn8E3d6mGZxeCPKlxOaq0oNN2rUbWlc4Ygf/MGcKHwEnXKE0Jt
         S0NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JZBJV05R4IVsZf04PFv9ZJ5X6xhIx2E5BZ8UHc5FNyY=;
        b=axSZW3Lt+5MbfjJRU2gL9jNw0WjKr+6SUwwljioxwCax1++CiKcojMzXEWc7vaSyNX
         NoBD3SEUrsEdAPVqb5q5zBnvajzI5KY+jiVU/db6zTHq6v+jssTBZEEJAY+7ei+4JLNz
         +pc5zuzjuYz4BfDYmxl76qK06KZsZxPkD4//NhCVDt3XHJ9a4aapKZ01IGgUOAkGMPJc
         lgk61GUgCrVyCUFBKa/PWlpe7Pbkn80y6GjI+XLuY5cnvFFTAmcY4Myc7kelTnnNZ+U9
         g7JrP5v0zK25b0REVVznyx1E2JJKTQaNF6Qo9e+93lxWExUiJfJkh0B+ZWu+XewdzM8u
         JYrg==
X-Gm-Message-State: AOAM5307x+WSpsrVOJoCgWtWBJxUlB2q3NZK6TuTq8fYUMCajwsZiht6
        Fsg1S6fmoJux1V3hdPbyC9k=
X-Google-Smtp-Source: ABdhPJzdnx9MRDoADc1RgI93hDTFibfGkHvODhHhBzZTWY0aF+sAYRWcwGbzshkxV7V/thfWkoRZrw==
X-Received: by 2002:a17:90a:ea05:: with SMTP id w5mr14623391pjy.37.1593371370959;
        Sun, 28 Jun 2020 12:09:30 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:616])
        by smtp.gmail.com with ESMTPSA id q29sm9954390pfl.77.2020.06.28.12.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:09:30 -0700 (PDT)
Date:   Sun, 28 Jun 2020 12:09:27 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 bpf-next 01/14] bpf: Add resolve_btfids tool to
 resolve BTF IDs in ELF object
Message-ID: <20200628190927.43vvzapcxpo7wxrq@ast-mbp.dhcp.thefacebook.com>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-2-jolsa@kernel.org>
 <d521c351-2bcd-2510-7266-0194ade5ca64@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d521c351-2bcd-2510-7266-0194ade5ca64@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 02:09:53PM -0700, Yonghong Song wrote:
> 
> After applying the whole patch set to my bpf-next tree locally, I cannot
> build:
> 
> -bash-4.4$ make -j100 && make vmlinux
>   GEN     Makefile
>   DESCEND  objtool
>   DESCEND  bpf/resolve_btfids
> make[4]: *** No rule to make target
> `/data/users/yhs/work/net-next/tools/bpf/resolve_btfids/fixdep'.  Stop.
> make[3]: *** [fixdep] Error 2
> make[2]: *** [bpf/resolve_btfids] Error 2
> make[1]: *** [tools/bpf/resolve_btfids] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make[1]: *** wait: No child processes.  Stop.
> make: *** [__sub-make] Error 2
> -bash-4.4$
> 
> Any clue what is the possible issue here?

Same here. After applying patch 1 and 2 it doesn't build for me 
with the same error as above.

But if I do:
cd tools/bpf/resolve_btfids; make; cd -; make
it works.
