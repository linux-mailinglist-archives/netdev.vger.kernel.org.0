Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE49E3A3F83
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 11:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbhFKJxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 05:53:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46990 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231699AbhFKJx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 05:53:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623405091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UhVoTp1jU7KUXl1MIgvh8N6ZJLzYaSZgYGDndABbbPE=;
        b=DI5KrDpWXD5b92dRwxWlNNzbpANaVlFEGXuKhmWRQag9MB8gs+hVUOELsZoNG42RsmeEAS
        c8xopeVbcVZuZUh8MHLktTeaOOO3xkT3Z3nmDMmbDeLKgABtQURwoSW5qNAL52O8hkwSly
        /FG5IBTf2UA4zYnJZJ4sX8zg44MyIio=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-dn-c5dS7M7WdJy4QnNcMCw-1; Fri, 11 Jun 2021 05:51:29 -0400
X-MC-Unique: dn-c5dS7M7WdJy4QnNcMCw-1
Received: by mail-wm1-f72.google.com with SMTP id m31-20020a05600c3b1fb02901bd331ed39fso1307237wms.0
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 02:51:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UhVoTp1jU7KUXl1MIgvh8N6ZJLzYaSZgYGDndABbbPE=;
        b=atGvNblfQo6IzVwJJSAo2ynmcR7j4lJmb1hIW1SMTVPGLZTw9xlVkT2vyEZQ0SYFp3
         gG01FUx5dFNefrsUj/jKikleYJuBtAhoP6sgCWDN44jmWtd7Dm9q2hdfjIOcyvbipwf1
         ULo0aNoeDfzMoo3+OdZsyvgwK+iws5UdQlU06PPB5e6yvtOC7v4Y/KNMszqDmxiI4ctM
         BFE0RGUy+PhW5uXytxf/LBIlmHm4lJDctc0S3ikOwrEoFQjunLqngJY8i78zlc1DJgdC
         NlnlcyQUOpE4zhVyzH2qv4feNxh5ykhKnn19TjPfehoU2DBTMEUpSUFQH/H8Q+6sM1DL
         xCmw==
X-Gm-Message-State: AOAM530C6oqZf/Ijxkg8LPlCkX57SSA9bLHAsGS2ukFi2TyVloyX8coL
        1WO1K2F8qATP3ILsmutjZE1rH4o4yYJuQS6Klqb9+roip5WGnrYsFxTjPUfFhREcvRp5Pyb7vK+
        ZkOwxzTOABHIwuukv
X-Received: by 2002:a05:6000:1a87:: with SMTP id f7mr3058691wry.172.1623405088460;
        Fri, 11 Jun 2021 02:51:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHKzmYiqYS8xoIGd18B16Ic8oMyXwXapUSUaB28ZwcYSzgcFTg6fMhNv9JPxPbQ+1lvop9NQ==
X-Received: by 2002:a05:6000:1a87:: with SMTP id f7mr3058682wry.172.1623405088335;
        Fri, 11 Jun 2021 02:51:28 -0700 (PDT)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id x7sm6735154wre.8.2021.06.11.02.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 02:51:27 -0700 (PDT)
Date:   Fri, 11 Jun 2021 11:51:26 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] utils: bump max args number to 256 for batch
 files
Message-ID: <20210611095126.GA1750@linux.home>
References: <4a0fcf72130d3ef5c4ca91b518f66ac6449cf57f.1622565590.git.gnault@redhat.com>
 <20210609165949.5806f75d@hermes.local>
 <20210610075857.GA7611@linux.home>
 <20210610161742.64e4c0e5@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610161742.64e4c0e5@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 04:17:42PM -0700, Stephen Hemminger wrote:
> On Thu, 10 Jun 2021 09:58:57 +0200
> Guillaume Nault <gnault@redhat.com> wrote:
> > > diff --git a/include/utils.h b/include/utils.h
> > > index 187444d52b41..6c4c403fe6c2 100644
> > > --- a/include/utils.h
> > > +++ b/include/utils.h
> > > @@ -50,6 +50,9 @@ void incomplete_command(void) __attribute__((noreturn));
> > >  #define NEXT_ARG_FWD() do { argv++; argc--; } while(0)
> > >  #define PREV_ARG() do { argv--; argc++; } while(0)
> > >  
> > > +/* upper limit for batch mode */
> > > +#define MAX_ARGS 512
> > > +
> > >  #define TIME_UNITS_PER_SEC     1000000
> > >  #define NSEC_PER_USEC 1000
> > >  #define NSEC_PER_MSEC 1000000
> > > diff --git a/lib/utils.c b/lib/utils.c
> > > index 93ae0c55063a..0559923beced 100644
> > > --- a/lib/utils.c
> > > +++ b/lib/utils.c
> > > @@ -1714,10 +1714,10 @@ int do_batch(const char *name, bool force,
> > >  
> > >         cmdlineno = 0;
> > >         while (getcmdline(&line, &len, stdin) != -1) {
> > > -               char *largv[100];
> > > +               char *largv[MAX_ARGS];
> > >                 int largc;
> > >  
> > > -               largc = makeargs(line, largv, 100);
> > > +               largc = makeargs(line, largv, MAX_ARGS);
> > >                 if (!largc)
> > >                         continue;       /* blank line */
> > >  
> > >   
> > 
> > Is this a patch you're going to apply, or should I repost it formally?
> > 
> 
> Either way, you get credit

I've sent v2. Thanks.

