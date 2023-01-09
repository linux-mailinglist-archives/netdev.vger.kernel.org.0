Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001436627BD
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbjAINva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236605AbjAINvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:51:22 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7823474E
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:51:21 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id bp44so7953329qtb.0
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 05:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lMVp4DBzPEHbESC24TX/tZtXHFYFxaQ3aEbKjvID1W4=;
        b=dKynSNqusmOgSgsJ6qwW0bE7cZpOLP0KpccYzgB3jQGTU3Auam7E9yUKTrf2GeHRee
         8NQWnisSS44QSDiLccsgxAS7vJ5k+SAQU9F6HxrvY4E5eT8YkML63yP2x+3rz34XRy9T
         1gONFV8pTX+s6YF9+eMR6mIbmEEsnXfVsoXI/Ud9ZAuaEPLdT3LlVYOTSHW1cId72xFR
         GOiO4tzpCpU7HtTNQyjD0l0ltNnL6U+5/1yGqS71TSbz5/nNIvR02BcSBAUbxzrQWzLR
         5Dx5hmIYZt63cYZRr1foLknDeU9pGvLXCP+dVHyDT1z9Qn0Chqo0VwYlB4ajwsibWnPY
         rxMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lMVp4DBzPEHbESC24TX/tZtXHFYFxaQ3aEbKjvID1W4=;
        b=JvxRZ904++wnWZNvz9VHnvEl9G79goAh+XqWHFmyIgS04+cfO9aAVqcWYEnsrNOW/d
         NzMY2aJpd5ire8zjCtld4IZRO0RlxwxywYky0rwl/1ACEd36YDIy21Qy4HTJd/bqQdN6
         M2JKNgLTk7au6v9rx2LfqsNMQTmuEJtRRvSxqiLIBRG52rYjTPaO+adi62Ss1rGYcf7s
         tgIWJXmDuDX/bqVuVw+UnCkrRdvf6Sc6YJ8hrtOapRUc9/LKlF6sxcl0cnppfk8W1BSr
         Ovp8MiZ3NwKerZOzkvlvToXs+JAWV/ANZ5xQ4Kwut+9ydXxObGlCBL55M/iGJXGZfbNf
         P0iA==
X-Gm-Message-State: AFqh2krPjlV+I6f7009MrXugQYs8HL/hj68IQDfiVZWXBjngSPhN6c0/
        tLfgI62M+8giuZ6jqeEyeUQR5A==
X-Google-Smtp-Source: AMrXdXsLCQFPQV4atO2Q0j1JNG+UBuuiWvuPu+0Twc1T3PNxBJsf65n8ZRlgngIhIvLkHoNZqRx61w==
X-Received: by 2002:ac8:7601:0:b0:3a8:199b:dcac with SMTP id t1-20020ac87601000000b003a8199bdcacmr83516511qtq.15.1673272280462;
        Mon, 09 Jan 2023 05:51:20 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-50-193.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.50.193])
        by smtp.gmail.com with ESMTPSA id f26-20020ac8499a000000b003ae450e43acsm515663qtq.12.2023.01.09.05.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 05:51:19 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1pEsYY-007h8N-V5;
        Mon, 09 Jan 2023 09:51:18 -0400
Date:   Mon, 9 Jan 2023 09:51:18 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Yupeng Li <liyupeng@zbhlos.com>, Kees Cook <keescook@chromium.org>
Cc:     tariqt@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Caicai <caizp2008@163.com>
Subject: Re: [PATCH 1/1] net/mlx4: Fix build error use array_size() helper in
 copy_to_user()
Message-ID: <Y7wb1hCpJiGEdbav@ziepe.ca>
References: <20230107072725.673064-1-liyupeng@zbhlos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230107072725.673064-1-liyupeng@zbhlos.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 03:27:25PM +0800, Yupeng Li wrote:
> When CONFIG_64BIT was disabled, check_copy_size() was declared with
> attribute error: copy source size is too small, array_size() for 32BIT
> was wrong size, some compiled msg with error like:
> 
>   CALL    scripts/checksyscalls.sh
>   CC [M]  drivers/net/ethernet/mellanox/mlx4/cq.o
> In file included from ./arch/x86/include/asm/preempt.h:7,
>                  from ./include/linux/preempt.h:78,
>                  from ./include/linux/percpu.h:6,
>                  from ./include/linux/context_tracking_state.h:5,
>                  from ./include/linux/hardirq.h:5,
>                  from drivers/net/ethernet/mellanox/mlx4/cq.c:37:
> In function ‘check_copy_size’,
>     inlined from ‘copy_to_user’ at ./include/linux/uaccess.h:168:6,
>     inlined from ‘mlx4_init_user_cqes’ at drivers/net/ethernet/mellanox/mlx4/cq.c:317:9,
>     inlined from ‘mlx4_cq_alloc’ at drivers/net/ethernet/mellanox/mlx4/cq.c:394:10:
> ./include/linux/thread_info.h:228:4: error: call to ‘__bad_copy_from’ declared with attribute error: copy source size is too small
>   228 |    __bad_copy_from();
>       |    ^~~~~~~~~~~~~~~~~
> make[6]: *** [scripts/Makefile.build:250：drivers/net/ethernet/mellanox/mlx4/cq.o] 错误 1
> make[5]: *** [scripts/Makefile.build:500：drivers/net/ethernet/mellanox/mlx4] 错误 2
> make[5]: *** 正在等待未完成的任务....
> make[4]: *** [scripts/Makefile.build:500：drivers/net/ethernet/mellanox] 错误 2
> make[3]: *** [scripts/Makefile.build:500：drivers/net/ethernet] 错误 2
> make[3]: *** 正在等待未完成的任务....
> make[2]: *** [scripts/Makefile.build:500：drivers/net] 错误 2
> make[2]: *** 正在等待未完成的任务....
> make[1]: *** [scripts/Makefile.build:500：drivers] 错误 2
> make: *** [Makefile:1992：.] 错误 2
> 
> Signed-off-by: Yupeng Li <liyupeng@zbhlos.com>
> Reviewed-by: Caicai <caizp2008@163.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/cq.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
> index 4d4f9cf9facb..7dadd7227480 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/cq.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
> @@ -315,7 +315,11 @@ static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
>  		}
>  	} else {
>  		err = copy_to_user((void __user *)buf, init_ents,
> +#ifdef CONFIG_64BIT
>  				   array_size(entries, cqe_size)) ?
> +#else
> +				   entries * cqe_size) ?
> +#endif
>  			-EFAULT : 0;

This can't possibly make sense, Kees?

Jason
