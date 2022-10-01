Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3EB5F1891
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 04:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbiJACFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 22:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbiJACFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 22:05:03 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6510B3FD43;
        Fri, 30 Sep 2022 19:05:02 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id g130so6424656oia.13;
        Fri, 30 Sep 2022 19:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=T3LnIJ26uQiiA7B3SemPUaPsJwI+2nEAQLG5L7R7jeU=;
        b=h+Jgv94aBrX99gz6XVFhw1Lq6wWcqWWGf4XDJuuU+PQW9NOT4RAmYOzGuOfSqkOvqn
         w5FX3vjwhXcwXmYC/TADxJa+6v9mLcwhalxIZPyH1mNZKVNDp+1JDvkwwQbxLH+5MGNo
         qKf1yhOp1IPno02EVjPQTO80BHDwCAgl2e0xIqb8mPzZFb3LGC7eaFbterPipaflIIbq
         DOFqKDPtHcQWR7fSZDV8fJYYHzESkod0yShI7sXTWP7MMVjHS+C4R1Zzesa9o7ONMCX8
         5AdmE3abwYm4ZqmwRXsqrb/lcLHLpAzjHkDh23f2ZsbW0bMAVvJ87lF8ewQpX+TWBhkw
         SGgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=T3LnIJ26uQiiA7B3SemPUaPsJwI+2nEAQLG5L7R7jeU=;
        b=zUP9CyRwMVfsMEo4JiojpWem68GFFHSw9HOHKd6WCnWP/PW1npo5aXk3406DGB9C4r
         a7089JzDhDYs4Vn4wLRgAJHAdQm+x3KQPkzFqh7LB4gGnCz1i+99SSS051Hb977v5Oo+
         0CwDx9o6Ah77n1+Fw7zl1oX19iTnq4jkgOCg08I/0ZUT0YnHgiFLThhrD7tHni0XGerI
         wnt09Mm5bEaeYNWHkb5vo7RBZWmPQZ4bWUAp7z2Wzpz/gsUPiMCoDhxXjwcnLZZGdivS
         PcetDEygNe+pbfusrSCblpogmA+KSps0VuHJ23Z1YgYvq4s89esl7ggngqvJh90amznd
         HMKg==
X-Gm-Message-State: ACrzQf1+qq5cgQndMZVKflJPD/+KbvqHtLS17SzUJ8CAioOE0AdrYKQt
        NwrDwVCZFw5RCOcWuHTC0ak=
X-Google-Smtp-Source: AMsMyM7zmoOKt6VmTd/TQBI0lUyqNtbsT/yg3mCBcxrLxJzl+Jj3eMkFb4eDftQ5IkQ6+LI9CJwizA==
X-Received: by 2002:a05:6808:1447:b0:350:a9db:d721 with SMTP id x7-20020a056808144700b00350a9dbd721mr387384oiv.33.1664589901643;
        Fri, 30 Sep 2022 19:05:01 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id p6-20020a544606000000b00342ece494ffsm889594oip.46.2022.09.30.19.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 19:05:01 -0700 (PDT)
Date:   Fri, 30 Sep 2022 19:02:50 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 1/7] cpumask: fix checking valid cpu range
Message-ID: <YzefysLuituL+LSA@yury-laptop>
References: <20220919210559.1509179-1-yury.norov@gmail.com>
 <20220919210559.1509179-2-yury.norov@gmail.com>
 <xhsmhbkqz4rqr.mognet@vschneid.remote.csb>
 <YzRfD2aAID8DuHL1@yury-laptop>
 <xhsmhwn9k3ibb.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xhsmhwn9k3ibb.mognet@vschneid.remote.csb>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 06:04:08PM +0100, Valentin Schneider wrote:
[...]

> > next_cpu is a valid CPU number for all, but not for cpumask_next().
> > The warning is valid. If we are at the very last cpu, what for we look
> > for next?
> >
> 
> Consider:
> 
>   nr_cpu_ids=4
> 
>   A)
>   cpumask: 0.1.1.0
>   CPU      0 1 2 3
>   n            ^
>   result: nr_cpu_ids
> 
>   B)
>   cpumask: 0.0.1.1
>   CPU      0 1 2 3
>   n              ^
>   result: nr_cpu_ids + WARN
> 
> Both scenarios are identical from a user perspective: a valid CPU number
> was passed in (either from smp_processor_id() or from a previous call to
> cpumask_next*()), but there are no more bits set in the cpumask. There's no
> more CPUs to search for in both scenarios, but only one produces as WARN.

It seems I have to repeat it for the 3rd time.

cpumask_next() takes shifted cpu index. That's why cpumask_check()
must shift the index in the other direction to keep all that
checking logic consistent.

This is a bad design, and all users of cpumask_next() must be aware of
this pitfall.
 
[...]

> > Maybe we should consider nr_cpu_ids as a special valid index for
> > cpumask_check(), a sign of the end of an array. This would help to
> > silence many warnings, like this one. For now I'm leaning towards that
> > it's more a hack than a meaningful change.
> >
> 
> I agree, we definitely want to warn for e.g.
> 
>   cpumask_set_cpu(nr_cpu_ids, ...);
> 
> Could we instead make cpumask_next*() immediately return nr_cpu_ids when
> passed n=nr_cpu_ids-1?

This is what FIND_NEXT_BIT() does. If you're suggesting to silence the
warning - what for do we need it at all?
 
> Also, what about cpumask_next_wrap()? That uses cpumask_next() under the
> hood and is bound to warn when wrapping after n=nr_cpu_ids-1, I think.

I'm working on a fix for it. Hopefully will merge it in next window.

Thanks,
Yury
