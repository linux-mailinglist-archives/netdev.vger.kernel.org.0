Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2A3772FF
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 22:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfGZUtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 16:49:42 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40206 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfGZUtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 16:49:42 -0400
Received: by mail-qt1-f195.google.com with SMTP id a15so53921665qtn.7;
        Fri, 26 Jul 2019 13:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TLhMgtjQ1fa5Xy/DvH23jyyfwNmD8xrdziSiYm1Qurw=;
        b=ZxT6eIy+CG02RVwJjaO2D7+74DFNLgCwEXIXe70HDCpOz+YFqH6rocTANd7zTI02qb
         5pcp3KRn+jDVE36xFQI8M4VBOlSXSdav0Bdb1nRwubc0eNZjCoEhDWz3kyOkj+MfcSsb
         zCBovDRjsThRl8rv6qLESBP2kU7XdK/VT9htwxS/a7nOd2vi70T/s7rfk//Gk18ffR5y
         sVsDWhN6IKL8ut3My8QoPpssfKOnRNfajUX64ZUJZ1Y9cEqyQcsmos+SdH95y8F1ZEov
         BF33EoUH9cyTIiF+rC7ea9xdLS7RrZ95Yd2v5vgix+Q9+hPuaMj+N0pHYNrPFNA8s98Z
         FyfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TLhMgtjQ1fa5Xy/DvH23jyyfwNmD8xrdziSiYm1Qurw=;
        b=hucamXL72KkRn9ngVkk5oZ/aU9DblDC0HsfLew2nkDJrPyhqaUARQlT1PGrFklmWg+
         wrKunzCywCbBB9TT80hLAwHejKATzJ+eIKcIiS9EtKRyrx5PxymUI1gyqWczN0F3FIIO
         gr4/ybhTACsbfpz8kMDLIp9bV5ihDo5MXEs1l8HmR1pVeVENtVqOlkqCdMFI+CD40vG8
         oq9wXT5kSFsLXxtFNxFPuU0vEj3QS3HYms2ZzBFWCQqhdHGQ0LO5B+dQiJUua4b7Qxjo
         zxWHJxbgSgIFsaBL1tS8i0bdb6iO2cDF3102xx+Dw94C770YZ8fYMiHVgEA8rrcCNyCZ
         FIbA==
X-Gm-Message-State: APjAAAXjjWCSNYC/Uuste4dcPZeBEMRscXG8/Uu1tdvsVc9IR3OuEfWN
        td7zkeRbi8BC5vD7hijmhtfm9EmA
X-Google-Smtp-Source: APXvYqzWFvW3SmI4FZi4GPJCI7kgtZ9dbKXGcrVtOn5p8qcwFwO2iM5AXbEWOOyNv9eVPCpofuXYNA==
X-Received: by 2002:aed:3595:: with SMTP id c21mr69512299qte.48.1564174180844;
        Fri, 26 Jul 2019 13:49:40 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id m3sm21405437qki.87.2019.07.26.13.49.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 13:49:40 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id DA0D940340; Fri, 26 Jul 2019 17:49:37 -0300 (-03)
Date:   Fri, 26 Jul 2019 17:49:37 -0300
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, acme@redhat.com, andrii.nakryiko@gmail.com,
        kernel-team@fb.com
Subject: Re: [PATCH v2 bpf] libbpf: fix missing __WORDSIZE definition
Message-ID: <20190726204937.GD24867@kernel.org>
References: <20190718173021.2418606-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718173021.2418606-1-andriin@fb.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Jul 18, 2019 at 10:30:21AM -0700, Andrii Nakryiko escreveu:
> hashmap.h depends on __WORDSIZE being defined. It is defined by
> glibc/musl in different headers. It's an explicit goal for musl to be
> "non-detectable" at compilation time, so instead include glibc header if
> glibc is explicitly detected and fall back to musl header otherwise.
> 
> Fixes: e3b924224028 ("libbpf: add resizable non-thread safe internal hashmap")
> Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Couldn't find ths in the bpf tree, please consider applying it:

Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>


- Arnaldo

> ---
>  tools/lib/bpf/hashmap.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> index 03748a742146..bae8879cdf58 100644
> --- a/tools/lib/bpf/hashmap.h
> +++ b/tools/lib/bpf/hashmap.h
> @@ -10,6 +10,11 @@
>  
>  #include <stdbool.h>
>  #include <stddef.h>
> +#ifdef __GLIBC__
> +#include <bits/wordsize.h>
> +#else
> +#include <bits/reg.h>
> +#endif
>  #include "libbpf_internal.h"
>  
>  static inline size_t hash_bits(size_t h, int bits)
> -- 
> 2.17.1

-- 

- Arnaldo
