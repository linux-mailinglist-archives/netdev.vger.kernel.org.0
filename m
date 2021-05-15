Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4EF3381A0B
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 19:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbhEORBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 13:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhEORBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 13:01:12 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B663C061573;
        Sat, 15 May 2021 09:59:59 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id n2so3000099ejy.7;
        Sat, 15 May 2021 09:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=tqEToDv/so/qf119uO+29f9FwYlBxlT+71skBV44zX0=;
        b=m/UKQ0l9394YvnXW1/Be/2C/B72Ebae+8aByku9/ea+yk62dVF+jxmuNzH08imnK26
         9aO4OXcdNh5z9MGXRrOUQt74oAo8fDWY37mdNz9LveGGbawAgmRujQJUGf3y3BtP25EY
         jzr2rWvAtc/DAqqBEq6CDS9Yc8uncpZRiTmdDBr+4COl6gs5hvlXpJqpCZNndxj7KpdM
         ebJsvifyI8Pnco8zaM1MXTxks2BoQBZG0lEdzQcNTBWLWRZaOnomxd5/Ed1T8CtdRIEK
         9pHa6GXJ0kTg2ISDKNQBSbFhY/DwIEVYECYrg/HDf1T36+zCZCJ2lt5s6Gkh9nBXKGO3
         NH9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=tqEToDv/so/qf119uO+29f9FwYlBxlT+71skBV44zX0=;
        b=Vkf4lkxcAacXSeM7jhDHSjyIFDGVFp2ClAtai+XcUN013vNntWveg2VsozJWk6juf2
         tlVAf32A1/u8abHXvXR7KeX3He7UNwvlpRarDBSx7YVAexpzamERyPO7pcG4dMxsHNrL
         woLiv2Sxq+qJRo+fm1e8eCWbb3AtYdjGnOMtQ6Kr66mnYFIPUXGAI7cx+4jHoaYS6L+v
         HPgT4ririfkM2BiteVIuWQk1jR0a1oOMR8EAluIIaKna9P59Imos7Af6F4+VZdqfPZJA
         78dHOKhF+3Q9n5ZKvzV6DNGgjcMg56cDEmsSqtDtDuFQMVvDwUiQh2rs58en8jg+rCQz
         AZSA==
X-Gm-Message-State: AOAM533z3K0BztGcW6ZCYLxxd9Kw1KWIDS+2/UDCya5a4pZ4z6R3ozos
        K0epunvimNM5dGJQh4D7vII=
X-Google-Smtp-Source: ABdhPJzVuNPldRVV+mkSNNwEnSGsRJF2yqpxsFiVpBFMHoy1wNLXJ0GL4MOVpNtWRBmDrbn3h+p3PA==
X-Received: by 2002:a17:907:990f:: with SMTP id ka15mr46157837ejc.132.1621097998108;
        Sat, 15 May 2021 09:59:58 -0700 (PDT)
Received: from pevik ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id r10sm5497630ejd.112.2021.05.15.09.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 09:59:57 -0700 (PDT)
Date:   Sat, 15 May 2021 18:59:55 +0200
From:   Petr Vorel <petr.vorel@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Heiko Thiery <heiko.thiery@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephen@networkplumber.org,
        Dmitry Yakunin <zeil@yandex-team.ru>
Subject: Re: [PATCH iproute2-next v3] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
Message-ID: <YJ/+C+FVEIRnnJBq@pevik>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
References: <20210508064925.8045-1-heiko.thiery@gmail.com>
 <6ba0adf4-5177-c50a-e921-bee898e3fdb9@gmail.com>
 <CAEyMn7a4Z3U-fUvFLcWmPW3hf-x6LfcTi8BZrcDfhhFF0_9=ow@mail.gmail.com>
 <YJ5rJbdEc2OWemu+@pevik>
 <82c9159f-0644-40af-fb4c-cc8507456719@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82c9159f-0644-40af-fb4c-cc8507456719@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,
> On 5/14/21 6:20 AM, Petr Vorel wrote:

> >>> This causes compile failures if anyone is reusing a tree. It would be
> >>> good to require config.mk to be updated if configure is newer.
> >> Do you mean the config.mk should have a dependency to configure in the
> >> Makefile? Wouldn't that be better as a separate patch?
> > I guess it should be a separate patch. I'm surprised it wasn't needed before.



> yes, it should be a separate patch, but it needs to precede this one.

> This worked for me last weekend; I'll send it when I get a chance.

> diff --git a/Makefile b/Makefile
> index 19bd163e2e04..5bc11477ab7a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -60,7 +60,7 @@ SUBDIRS=lib ip tc bridge misc netem genl tipc devlink
> rdma dcb man vdpa
>  LIBNETLINK=../lib/libutil.a ../lib/libnetlink.a
>  LDLIBS += $(LIBNETLINK)

> -all: config.mk
> +all: config
>         @set -e; \
>         for i in $(SUBDIRS); \
>         do echo; echo $$i; $(MAKE) -C $$i; done
> @@ -80,8 +80,10 @@ all: config.mk
>         @echo "Make Arguments:"
>         @echo " V=[0|1]             - set build verbosity level"

> -config.mk:
> -       sh configure $(KERNEL_INCLUDE)
> +config:
> +       @if [ ! -f config.mk -o configure -nt config.mk ]; then \
> +               sh configure $(KERNEL_INCLUDE); \
> +       fi

>  install: all
>         install -m 0755 -d $(DESTDIR)$(SBINDIR)

Thanks a lot, please send it.

I know this is only a fragment, but:
Reviewed-by: Petr Vorel <petr.vorel@gmail.com>

-nt is supported by dash and busybox sh.

Kind regards,
Petr
