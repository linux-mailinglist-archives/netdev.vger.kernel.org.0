Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3781866A23D
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 19:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjAMSlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 13:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjAMSlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 13:41:07 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9B01ADB8
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 10:41:03 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id bj3so20048151pjb.0
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 10:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=c0+Sdo0KEI7o1bohHc1jHwiM206A+991wKrqsl42gBA=;
        b=PBjE6fpa3XZ0R5lmeJaHS88HKwQd9U/loRunVFiGhmLwRqhpknZ9+P6RbsMgk3PDL1
         PgLj8+ehJmtj4zrs/d19QRniRQHhylp9ECRge3nOAok3HgG/eSF5Ym1Nqq+DUSeyVh9J
         GXuA9hPbl/TGZTbC4iwiqwta7/olfZdvm9dJ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c0+Sdo0KEI7o1bohHc1jHwiM206A+991wKrqsl42gBA=;
        b=aQLOWf7/5t08i0cMBmg8svniqNeY1R7PkYfDFwCiVCfQ8DigNha9V1jLN6/48Ftexq
         6AZEgHKFAfaegOC9qaPOJVT17dzJflx5Vdw2v1KhcWjZlwLSiSd/LPR9sQPB8B90dBLu
         tXyM0uPuYal7R5TxKJLNiCSGLURcIbNS0E6mz5sADwLjZxns5GZdixL9q6e7kY+ikhbl
         G2SKsEZIY3dAsKf8TU0e3QrgwKsUTR2rW1kCDgOTUrkSHhTHOSfkyFOkhADD/y+N9Is4
         y/08lDpaaYX3uFd3VHOqcf12AKoFwMsSYYL4fYqgVj559/B522/F3aJ03cXnc3WKPgMB
         8RTA==
X-Gm-Message-State: AFqh2kp2DlB7NZS0WlEMOthNQpjBGNeDZRiaCuyFhsnQY1uCqbRURj1i
        Fm1+tOfXgHH0XreLyZde9CF19A==
X-Google-Smtp-Source: AMrXdXtp0c0JUJUWnsyKvdP7j8ZaYi2JqXlPXCfJ6A2WBcV5A5fqLTp0v6thjvEtH6OYKXj/pGtg1g==
X-Received: by 2002:a17:90a:7e14:b0:219:eeb9:943f with SMTP id i20-20020a17090a7e1400b00219eeb9943fmr82718118pjl.49.1673635262948;
        Fri, 13 Jan 2023 10:41:02 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w1-20020a17090a1b8100b0022721df27e9sm1724684pjc.11.2023.01.13.10.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 10:41:02 -0800 (PST)
Date:   Fri, 13 Jan 2023 10:41:01 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Yupeng Li <liyupeng@zbhlos.com>, tariqt@nvidia.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Caicai <caizp2008@163.com>
Subject: Re: [PATCH 1/1] net/mlx4: Fix build error use array_size() helper in
 copy_to_user()
Message-ID: <202301131039.7354AD35CF@keescook>
References: <20230107072725.673064-1-liyupeng@zbhlos.com>
 <Y7wb1hCpJiGEdbav@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y7wb1hCpJiGEdbav@ziepe.ca>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 09:51:18AM -0400, Jason Gunthorpe wrote:
> On Sat, Jan 07, 2023 at 03:27:25PM +0800, Yupeng Li wrote:
> > When CONFIG_64BIT was disabled, check_copy_size() was declared with
> > attribute error: copy source size is too small, array_size() for 32BIT
> > was wrong size, some compiled msg with error like:
> > 
> >   CALL    scripts/checksyscalls.sh
> >   CC [M]  drivers/net/ethernet/mellanox/mlx4/cq.o
> > In file included from ./arch/x86/include/asm/preempt.h:7,
> >                  from ./include/linux/preempt.h:78,
> >                  from ./include/linux/percpu.h:6,
> >                  from ./include/linux/context_tracking_state.h:5,
> >                  from ./include/linux/hardirq.h:5,
> >                  from drivers/net/ethernet/mellanox/mlx4/cq.c:37:
> > In function ‘check_copy_size’,
> >     inlined from ‘copy_to_user’ at ./include/linux/uaccess.h:168:6,
> >     inlined from ‘mlx4_init_user_cqes’ at drivers/net/ethernet/mellanox/mlx4/cq.c:317:9,
> >     inlined from ‘mlx4_cq_alloc’ at drivers/net/ethernet/mellanox/mlx4/cq.c:394:10:
> > ./include/linux/thread_info.h:228:4: error: call to ‘__bad_copy_from’ declared with attribute error: copy source size is too small
> >   228 |    __bad_copy_from();
> >       |    ^~~~~~~~~~~~~~~~~
> > make[6]: *** [scripts/Makefile.build:250：drivers/net/ethernet/mellanox/mlx4/cq.o] 错误 1
> > make[5]: *** [scripts/Makefile.build:500：drivers/net/ethernet/mellanox/mlx4] 错误 2
> > make[5]: *** 正在等待未完成的任务....
> > make[4]: *** [scripts/Makefile.build:500：drivers/net/ethernet/mellanox] 错误 2
> > make[3]: *** [scripts/Makefile.build:500：drivers/net/ethernet] 错误 2
> > make[3]: *** 正在等待未完成的任务....
> > make[2]: *** [scripts/Makefile.build:500：drivers/net] 错误 2
> > make[2]: *** 正在等待未完成的任务....
> > make[1]: *** [scripts/Makefile.build:500：drivers] 错误 2
> > make: *** [Makefile:1992：.] 错误 2
> > 
> > Signed-off-by: Yupeng Li <liyupeng@zbhlos.com>
> > Reviewed-by: Caicai <caizp2008@163.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx4/cq.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
> > index 4d4f9cf9facb..7dadd7227480 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/cq.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
> > @@ -315,7 +315,11 @@ static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
> >  		}
> >  	} else {
> >  		err = copy_to_user((void __user *)buf, init_ents,
> > +#ifdef CONFIG_64BIT
> >  				   array_size(entries, cqe_size)) ?
> > +#else
> > +				   entries * cqe_size) ?
> > +#endif
> >  			-EFAULT : 0;
> 
> This can't possibly make sense, Kees?

Uuuuh, that's really weird. What compiler version and arch? I'll see if
I can reproduce this.

-- 
Kees Cook
