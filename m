Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04B24A74F0
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 16:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiBBPt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 10:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345571AbiBBPt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 10:49:57 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC78C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 07:49:57 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so6375712pjb.1
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 07:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8Qnr1jdwo+p+79L6+/yznLSB3/bBihBeVkN0e4DIqYE=;
        b=2tLXrmMd9Y8LcbQIE32+QUhCBBMakWoZJqw+Q+WjIxvPDOSf/dknS8NZ+07+beeNfN
         5w81RwL3cg1eGVL40ARYWli6WO4OHDfTTDxfT/U7cmLpQWg/DTTY0GRHMbvTDyfSKPbh
         kO7cwCLStf+jDNQoFCalH9N/iyP3S9CB2MRrzm/xHCwD4QBGkDnBi9YGvr7KBfscDiwh
         PchShXpXUlOZLvDkSa3LppwAJd98Aiwp4qQR0vIN5fLaYRarON5zQe9Xm52MnyBP70Co
         WKQrVUJHhcP0IuBK+jG8NYEci+ivGySY0pMozFsDaU5w0CdJB+fI1pjcmyB3iOsB4af0
         oZ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Qnr1jdwo+p+79L6+/yznLSB3/bBihBeVkN0e4DIqYE=;
        b=dGRwDSMXkpe67mL83BuCZRYl0YeyJmSeOtKrlePYRXKMnXp0hO+8VtdpOMlFXmQhlp
         JodR0oVf5aoiA8po1uX4bxRZO+CcEfFA58GIYaFohubX8Xu0PuPNsSFSwdThX5o38wdJ
         dKIqU0pEOjpmvm2nkWd05t0s26YaR7suvLGQoEV8+7PR0D/u3Dzot1NI+oIv3n+xUsb4
         AHFgfMnRVd1NXeEOPXgXaUdLduUHnIHbTZfm63S9iOyYqQ9aVqfvFhdYo1+RPfo/rHl0
         3VkbCAnHIJLB+6FjkNwNlCfHtqcuFNa1xUOT6k7m3sS88mPd6hh++tFq2iGhfIFzjv+m
         LWYw==
X-Gm-Message-State: AOAM5322M/8CxSqoCueeU+UMNp5uvfhIvxRLw41DaQAPIxAQd//dBHcX
        nitcWjuvJkcqbv4VSZhqaD1D3A==
X-Google-Smtp-Source: ABdhPJw5FsPnoDw2/z/PlcZOrc0fSh3dnSbBynKthzXZCA8CpGFQMVmK7QuPh89GVppRHBjQUWLI5A==
X-Received: by 2002:a17:902:9a06:: with SMTP id v6mr31239000plp.60.1643816996957;
        Wed, 02 Feb 2022 07:49:56 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id l20sm26985311pfc.53.2022.02.02.07.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 07:49:56 -0800 (PST)
Date:   Wed, 2 Feb 2022 07:49:53 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, markzhang@nvidia.com,
        leonro@nvidia.com
Subject: Re: [PATCH iproute2 1/3] lib/fs: fix memory leak in get_task_name()
Message-ID: <20220202074953.330c11b2@hermes.local>
In-Reply-To: <YfqXWG+hyjVtdwR6@tc2>
References: <cover.1643736038.git.aclaudi@redhat.com>
        <c7d57346ddc4d9eaaabc0f004911d038c95238af.1643736038.git.aclaudi@redhat.com>
        <20220201102712.1390ae4d@hermes.local>
        <YfqXWG+hyjVtdwR6@tc2>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Feb 2022 15:38:16 +0100
Andrea Claudi <aclaudi@redhat.com> wrote:

> On Tue, Feb 01, 2022 at 10:27:12AM -0800, Stephen Hemminger wrote:
> > On Tue,  1 Feb 2022 18:39:24 +0100
> > Andrea Claudi <aclaudi@redhat.com> wrote:
> >   
> > > +	if (fscanf(f, "%ms\n", &comm) != 1) {
> > > +		free(comm);
> > > +		return NULL;  
> > 
> > This is still leaking the original comm.
> >  
> 
> Thanks Stephen, I missed the %m over there :(
> 
> > Why not change it to use a local variable for the path
> > (avoid asprintf) and not reuse comm for both pathname
> > and return value.
> >   
> 
> Thanks for the suggestion. 
> 
> What about taking an extra-step and get rid of the %m too?
> We can do something similar to the get_command_name() function so that
> we don't need to use free in places where we use get_task_name().

What ever works best.
