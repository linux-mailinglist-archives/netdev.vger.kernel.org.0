Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D570B3A25F8
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 09:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhFJIBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 04:01:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32005 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230120AbhFJIA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 04:00:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623311943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VBw1udpHWu0ICMQTCJT7xYM4Al6unbCRKTXQMUMBSOA=;
        b=e2TGWwHjtouvfpnLJ07lZNYisgfWlVEUxImaRKQJj8RJW8NPfTTv4LRINbDeOACmjDwuVk
        fvPJ7CPsGlGGMPOk06POfcNvasywwsOIjU6eGF1ZrempzOTiw7v0Xy7Jg8j3snl/Dor48a
        UNwOIjoJVvfQRG4ArLad1nU2uNOZTN0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-_zWGj0uXPhuXFbl6dc2XMQ-1; Thu, 10 Jun 2021 03:59:02 -0400
X-MC-Unique: _zWGj0uXPhuXFbl6dc2XMQ-1
Received: by mail-wm1-f71.google.com with SMTP id f186-20020a1c1fc30000b02901aaa08ad8f4so3468238wmf.8
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 00:59:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VBw1udpHWu0ICMQTCJT7xYM4Al6unbCRKTXQMUMBSOA=;
        b=n7+aTBXVe2l33K80Tc25dJDBp1GAazeTaIyvc5eQYCfIFDn4Bm3RPJEOi4X9eYRfvq
         NQiKpuQ2dJvM6ozRwqp+2UM/DKHfBuU2zQA8Pp9GOUa/33II0dK85VuAplzt5ioSBRjk
         jMCDDwcWFjT/jgRmG2eagKTqwSNt18nZDvgpVKTDr8ELGMpIuM8vA8nZ9hRpBX2cksuG
         spYuD77bG9Cm8wbnzdtP0wGX3DiZ+WPicrl6mI4MJOxfjjadVmIw8BSTzP47Vukjfb6M
         3+GsdNwbStTG4/y3MZa4x33cobbETfs2Y5Cz+4oiWym0lJ3UUJ5Ro6YDj4/uLK4E0QHF
         eZcA==
X-Gm-Message-State: AOAM5308dLrz7GIvQR/wOteRn50iu6wU7VxJ7MF536tm9Zb04lliUAho
        Ze4H1Pika4LclurT7nfHiK6mJxKHzA3QC5ivSizgS3h2RM8g5ie86ZH+Lm1DHFyU19lEbjklFvb
        XDwWoGdLyT2RNfZpm
X-Received: by 2002:adf:e401:: with SMTP id g1mr3715663wrm.415.1623311940478;
        Thu, 10 Jun 2021 00:59:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyULHnGEEM1u9BzDNIdiHkMjf/6GIp7jpgs0OlEbaWkpg+ROoFcrjR3vJVuYwi88nFqPmyizw==
X-Received: by 2002:adf:e401:: with SMTP id g1mr3715644wrm.415.1623311940230;
        Thu, 10 Jun 2021 00:59:00 -0700 (PDT)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id b22sm2105774wmj.22.2021.06.10.00.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 00:58:59 -0700 (PDT)
Date:   Thu, 10 Jun 2021 09:58:57 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] utils: bump max args number to 256 for batch
 files
Message-ID: <20210610075857.GA7611@linux.home>
References: <4a0fcf72130d3ef5c4ca91b518f66ac6449cf57f.1622565590.git.gnault@redhat.com>
 <20210609165949.5806f75d@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609165949.5806f75d@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 04:59:49PM -0700, Stephen Hemminger wrote:
> On Tue, 1 Jun 2021 19:09:31 +0200
> Guillaume Nault <gnault@redhat.com> wrote:
> 
> > Large tc filters can have many arguments. For example the following
> > filter matches the first 7 MPLS LSEs, pops all of them, then updates
> > the Ethernet header and redirects the resulting packet to eth1.
> > 
> > filter add dev eth0 ingress handle 44 priority 100 \
> >   protocol mpls_uc flower mpls                     \
> >     lse depth 1 label 1040076 tc 4 bos 0 ttl 175   \
> >     lse depth 2 label 89648 tc 2 bos 0 ttl 9       \
> >     lse depth 3 label 63417 tc 5 bos 0 ttl 185     \
> >     lse depth 4 label 593135 tc 5 bos 0 ttl 67     \
> >     lse depth 5 label 857021 tc 0 bos 0 ttl 181    \
> >     lse depth 6 label 239239 tc 1 bos 0 ttl 254    \
> >     lse depth 7 label 30 tc 7 bos 1 ttl 237        \
> >   action mpls pop protocol mpls_uc pipe            \
> >   action mpls pop protocol mpls_uc pipe            \
> >   action mpls pop protocol mpls_uc pipe            \
> >   action mpls pop protocol mpls_uc pipe            \
> >   action mpls pop protocol mpls_uc pipe            \
> >   action mpls pop protocol mpls_uc pipe            \
> >   action mpls pop protocol ipv6 pipe               \
> >   action vlan pop_eth pipe                         \
> >   action vlan push_eth                             \
> >     dst_mac 00:00:5e:00:53:7e                      \
> >     src_mac 00:00:5e:00:53:03 pipe                 \
> >   action mirred egress redirect dev eth1
> > 
> > This filter has 149 arguments, so it can't be used with tc -batch
> > which is limited to a 100.
> > 
> > Let's bump the limit to the next power of 2. That should leave a lot of
> > room for big batch commands.
> > 
> > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> 
> Good idea, but we should probably go further up to 512.
> Also, rather than keeping magic constant. Why not add value to
> utils.h.

Yes, right.

> I considered using sysconf(_SC_ARG_MAX) gut that is huge on modern
> machines (2M). And we don't need to allocate for all possible args.

Yes, 2M is probably overkill (and too much to allocate on the stack).

> diff --git a/include/utils.h b/include/utils.h
> index 187444d52b41..6c4c403fe6c2 100644
> --- a/include/utils.h
> +++ b/include/utils.h
> @@ -50,6 +50,9 @@ void incomplete_command(void) __attribute__((noreturn));
>  #define NEXT_ARG_FWD() do { argv++; argc--; } while(0)
>  #define PREV_ARG() do { argv--; argc++; } while(0)
>  
> +/* upper limit for batch mode */
> +#define MAX_ARGS 512
> +
>  #define TIME_UNITS_PER_SEC     1000000
>  #define NSEC_PER_USEC 1000
>  #define NSEC_PER_MSEC 1000000
> diff --git a/lib/utils.c b/lib/utils.c
> index 93ae0c55063a..0559923beced 100644
> --- a/lib/utils.c
> +++ b/lib/utils.c
> @@ -1714,10 +1714,10 @@ int do_batch(const char *name, bool force,
>  
>         cmdlineno = 0;
>         while (getcmdline(&line, &len, stdin) != -1) {
> -               char *largv[100];
> +               char *largv[MAX_ARGS];
>                 int largc;
>  
> -               largc = makeargs(line, largv, 100);
> +               largc = makeargs(line, largv, MAX_ARGS);
>                 if (!largc)
>                         continue;       /* blank line */
>  
> 

Is this a patch you're going to apply, or should I repost it formally?

