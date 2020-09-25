Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6280277EBE
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 05:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgIYDzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 23:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbgIYDzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 23:55:44 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76D1C0613CE;
        Thu, 24 Sep 2020 20:55:44 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id fa1so1181571pjb.0;
        Thu, 24 Sep 2020 20:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UbFfxDhyHW98ecFS7ZgdggwhXbqrMDrJVZ5yrZgpOsU=;
        b=Kq2/UmUpRtM0exsecIyh/b6wjvbZ0vdR5gPZak1XWVTGNDj09LyfqZ0FmbklwmHjYn
         eVJtaCOkcVysYqce976CUXMusudAwXvom7Q5obBxseE1BnedSakPDZLlvjcRRt3PnCLZ
         SyB7amsB1Cse1vXtcwBl7MKyPSd94uY/UBql8BSwYDqpv1N6cHfEDU/nZLwKKWFDsPmZ
         PoHgKlzFg2F6nMhSwrcUmcFiRuE3JhZWRk3QUIYBVxUdAjgMScnWb8SEmKnpwrR7PIB5
         yZY7NUQJpTvilkOik2CjLC7qdnEZSW/ws3p7FpxacrH7h0UtNuvGn2KHWHPM6bhdTspf
         qtpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UbFfxDhyHW98ecFS7ZgdggwhXbqrMDrJVZ5yrZgpOsU=;
        b=mUbc7l6UUt58gDJqftYrpdumSEA1F1QCD381sXHSYUlmLM5cOgeeJdUtgZVI4Xtpmz
         SorB9hZl6T+hhzkr4d+Rv3hUsUoTIOOpj2MmK552gF2P4ej5bu32yiuZ7vh6/rLOrINh
         uBeOOJcp170kuIQTKmmOoFO+g1Cfg4jUQdvAzNCe4soL6LBM45qQK5Rj1NxdDb3m7t8Q
         +evZSM+XYWKSUp/TWw8j7lQakLnTio11Ow6LMBUiwJUPoaB2dqorx2aM/VkqXGptzRri
         mYLCAyOz9Hvtb7QKzITRqExgNTK3DR+46DYeJWZZEQAAOgUBrU10u5cLdycQ8mzoziY1
         fb5g==
X-Gm-Message-State: AOAM531dKgLYTQLrOMDRbzWY64t3IVuQG4KiAe8cszYpTaHRmxbye5f4
        x2nrEhLGFiamHsf9hIcUTyM=
X-Google-Smtp-Source: ABdhPJx4BEKtPMkvvggfCwcRi7G012CbUW5PAfHlKcN80VNN8ix0H1v3Z3OYIi/t0LFgoF08COP9pA==
X-Received: by 2002:a17:90b:317:: with SMTP id ay23mr820390pjb.68.1601006144147;
        Thu, 24 Sep 2020 20:55:44 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:396c])
        by smtp.gmail.com with ESMTPSA id gn24sm619524pjb.8.2020.09.24.20.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 20:55:43 -0700 (PDT)
Date:   Thu, 24 Sep 2020 20:55:41 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH bpf-next 7/9] libbpf: add BTF writing APIs
Message-ID: <20200925035541.2hjmie5po4lypbgk@ast-mbp.dhcp.thefacebook.com>
References: <20200923155436.2117661-1-andriin@fb.com>
 <20200923155436.2117661-8-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923155436.2117661-8-andriin@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 08:54:34AM -0700, Andrii Nakryiko wrote:
> Add APIs for appending new BTF types at the end of BTF object.
> 
> Each BTF kind has either one API of the form btf__append_<kind>(). For types
> that have variable amount of additional items (struct/union, enum, func_proto,
> datasec), additional API is provided to emit each such item. E.g., for
> emitting a struct, one would use the following sequence of API calls:
> 
> btf__append_struct(...);
> btf__append_field(...);
> ...
> btf__append_field(...);

I've just started looking through the diffs. The first thing that struck me
is the name :) Why 'append' instead of 'add' ? The latter is shorter.

Also how would you add anon struct that is within another struct ?
The anon one would have to be added first and then added as a field?
Feels a bit odd that struct/union building doesn't have 'finish' method,
but I guess it can work.
