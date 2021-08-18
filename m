Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2573F01E9
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 12:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234180AbhHRKk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 06:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbhHRKk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 06:40:27 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6B9C061764;
        Wed, 18 Aug 2021 03:39:52 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id z20so4046954ejf.5;
        Wed, 18 Aug 2021 03:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jyexXWFwOLYI4MhvLQQ6maaI0Sn7cYmdfYYUhVpY6B8=;
        b=XOEGfMyhSqYVXcWQ28Xr/NS8uIQhYBBO+xFC/aYm0Op2Tfyrx2Ot/jdskw9LKFEXO6
         qLtFg/zIU0ssXRQI1da3VulbUOSYXVCkHONr0nkBDD5rviKw1LMftwXr/NtNiBo+HED6
         bs5yVMDOJMannD1c5kygX0DgBfvClv6EP4XLjn0W+Jw6DpeKEnIn1DsBKukdiW0St4GS
         EBodhTTu/xiOIglrkErpio9c1S5+31NTZ2zlbfRnhPN6hydbZkjlyuFl5R6xKq53CukL
         UP7bboxQ/FCCE9lw1Xeow6OHS+bLrhIyHZJgIlAIFI7avIHm0CGSPu6frXAafPTkASz9
         1cEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jyexXWFwOLYI4MhvLQQ6maaI0Sn7cYmdfYYUhVpY6B8=;
        b=s4n9R+OR2ci3tqmQcYxH0qMN3e1b8wFHqkjO52D8scj+mapfuO8JJmAD7bxQ4ekBID
         sQGfHhH5XS8C7+sT4NCkoGqeqBlJHPB2zD51/TUand89DjTthXZXC7U2go9o7bi8QHqW
         NaHduOCiK5BLMpt/4y/nL7swm0VeOaf6Oa45FiMbUEa/Gi/EQH3uF+JuBoW/yZRz6UYj
         PRIENaH7iGbdc/9fS+S/UUfgWDFO8jl2hHnUBdrcE8a/282+HyeJP0nOuEeIu/ZgDlRy
         Qtm0VTe350iNs+B7jXA//jsITKZJRrMuj7lljeUSdcVmE6dL2DswykJxycEtabsoLWQ0
         2+ig==
X-Gm-Message-State: AOAM533REO1ZYQgTHPqkVxrvGhH6UMTU1YSuXzYj3/QhfiSVAGIyARP4
        +rqUrUK2PdA5Kbv+RfdTo1Tj/gjiqshjX6S2S0I=
X-Google-Smtp-Source: ABdhPJxB/vjkjjQ25KDyCRo7YSLCAJiijSouBqtOudr6KaHK7Tun4YzpksQ8FMq4dN5vq+G5YV5lzU0IDjra1ANv35k=
X-Received: by 2002:a17:906:4784:: with SMTP id cw4mr8983302ejc.160.1629283191232;
 Wed, 18 Aug 2021 03:39:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210818032554.283428-1-mudongliangabcd@gmail.com> <20210818033207.GA19350@gondor.apana.org.au>
In-Reply-To: <20210818033207.GA19350@gondor.apana.org.au>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Wed, 18 Aug 2021 18:39:25 +0800
Message-ID: <CAD-N9QVRuBAER0o1H6eTre_YOU+4mbHuj3homHno0UHiJrXuUg@mail.gmail.com>
Subject: Re: [PATCH] net: xfrm: assign the per_cpu_ptr pointer before return
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        syzbot+b9cfd1cc5d57ee0a09ab@syzkaller.appspotmail.com,
        stable@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 11:32 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Aug 18, 2021 at 11:25:53AM +0800, Dongliang Mu wrote:
> >
> > diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
> > index cb40ff0ff28d..01dbec70dfba 100644
> > --- a/net/xfrm/xfrm_ipcomp.c
> > +++ b/net/xfrm/xfrm_ipcomp.c
> > @@ -223,9 +223,9 @@ static void * __percpu *ipcomp_alloc_scratches(void)
> >               void *scratch;
> >
> >               scratch = vmalloc_node(IPCOMP_SCRATCH_SIZE, cpu_to_node(i));
> > +             *per_cpu_ptr(scratches, i) = scratch;
> >               if (!scratch)
> >                       return NULL;
> > -             *per_cpu_ptr(scratches, i) = scratch;
>
> scratches comes from alloc_percpu so it should already be zeroed.

Correct.

:\ Then I have no idea how this crash occurs. This crash report does
not have any reproducer. It seems like a random crash, but I am not
sure.

If you have any patch for this crash, please let me know.

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
