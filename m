Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC3251F4ED
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 09:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbiEIHRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 03:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbiEIG6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 02:58:17 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BAE1A021F;
        Sun,  8 May 2022 23:54:24 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id e24so12315385pjt.2;
        Sun, 08 May 2022 23:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3nKM/0/HHALognv0Zk99w+J+a8OnPMYc69HYC2U7ub8=;
        b=VZhFu1YRYSVn4ASDKUESe/K4kQa+jbfHhigKuiywnYCBGKvwkROUChQtEH5e4CT3kB
         jyJdt0I2jUHbZfXNZlh9vMH6t0PosGWRAVIP7mnrGwwokY8UnlH9io4pJtjjXe9uSBtO
         zMe8tNqtOP60BWJNi1ANQCpYt2xBk0GeiXXGuK72l/R5if94NDurIofMwgbhvBfKTL+Z
         932RrMo6wFho+5zbdKYfLhbTnB7C/2CN0Ne2Z5LQT6B5tBDai1LZH5HdCI8wR0iwYPHg
         GeTz2PvccPMLDJjvlzWz2scnzy4gqe3qtF6EZEDSD6Nh6l8/Ngb9YwlowLkR7fk1ZwZo
         rPaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3nKM/0/HHALognv0Zk99w+J+a8OnPMYc69HYC2U7ub8=;
        b=QkFJwocQxecZtbADuCB4rJE8kXUVefg2ILfTHYQbg5Pj7xhGq9Q+8ykuDMdMYLK649
         tSma0igbJIeno/cJSHQTxxNhofJo3qh7m6LRaQ4D/Ftt6hJuA4dkSRZcZLXceZWn+hy2
         wq0j3m2l0UbB4Tt/ZyEYzIdZ4cYqf3nRIeRA+uvg3Y5oz1nljsyRDnCHHKJLvTbaHEHM
         dNmUWTdkjEaZUd/25mkOVW3Mgw5noNSdEUNATAwXKZnfdOLII/Jmq7dqgeocUGZHdZFY
         +aWT7kEzGgGji9HDjPIcxLwPOp6wUF/KRt69117MqOLQCSq2evbUcijxJAd4rGo8roub
         hi9w==
X-Gm-Message-State: AOAM531U9r/fWmHYrV+hYSWnvs3CUZBpTfSCNTm3toMq9H/EadXuF8Ok
        VrrU5lOj0oe/S4BOmciDLBElFFim08A=
X-Google-Smtp-Source: ABdhPJwZXCXGD14gg2tQpxyhNsz4kCz5ZWznUc2zu1b4qSh+GVoU+ggG8/BYGaelRCTO2lvFuGcq6g==
X-Received: by 2002:a17:902:d490:b0:15e:b443:6852 with SMTP id c16-20020a170902d49000b0015eb4436852mr14888232plg.111.1652079264383;
        Sun, 08 May 2022 23:54:24 -0700 (PDT)
Received: from localhost (subs32-116-206-28-19.three.co.id. [116.206.28.19])
        by smtp.gmail.com with ESMTPSA id t10-20020a62ea0a000000b0050dc762816asm2267902pfh.68.2022.05.08.23.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 23:54:23 -0700 (PDT)
Date:   Mon, 9 May 2022 13:54:20 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Akira Yokosawa <akiyks@gmail.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next v3] net/core: Rephrase function description of
 __dev_queue_xmit()
Message-ID: <Yni6nBTq+0LrBvQN@debian.me>
References: <20220507084643.18278-1-bagasdotme@gmail.com>
 <0cf2306a-2218-2cd5-ad54-0d73e25680a7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cf2306a-2218-2cd5-ad54-0d73e25680a7@gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 08, 2022 at 08:48:10PM +0900, Akira Yokosawa wrote:
> So, appended below is my version of the fix with the answer to
> Stephen's question, "I am not sure why this has turned up just now."
> 
> Stephen, Jakub, what do you think?
> 
>         Thanks, Akira
> 
> ----8<--------------
> From: Akira Yokosawa <akiyks@gmail.com>
> Subject: [PATCH -next] net/core: Hide __dev_queue_xmit()'s kernel-doc
> 
> Commit c526fd8f9f4f21 ("net: inline dev_queue_xmit()") added
> export of __dev_queue_exit() to cope with inlining of its
> wrapper functions dev_queue_xmit() and dev_queue_xmit_accel().
> This made __dev_queue_exit()'s comment block visible to Sphinx
> processing in "make htmldocs" because
> Documentation/networking/kapi.rst has the directive of:
> 
>     .. kernel-doc:: net/core/dev.c
>        :export:
> 
> Unfortunately, the kernel-doc style comment has a number of
> issues when parsed as RestructuredText.  Stephen reported a
> new warning message from "make htmldocs" caused by one of
> such issues.
> 
> The leading "__" in the function name indicates that it is an
> internal API and should not be widely used.
> Exposing documentation of such a function in HTML and PDF
> documentations does not make sense.
> 

Oops, I don't see that internal API marker. Maybe we can add "Only
public funtions should be added kernel-doc comments" note to
Documentation/doc-guide/kernel-doc.rst?

> For the time being, hide the kernel-doc style comment from Sphinx
> processing by removing the kernel-doc marker of "/**".
> 
> Proper kernel-doc comments should be added to the inlined
> wrapper functions, which is deferred to those who are familiar
> with those netdev APIs.
> 

Ah! Thanks for the explanation.

Did you mean proper kernel-doc comments should be added to the wrapper
functions that called this inlined method?

> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Fixes: c526fd8f9f4f21 ("net: inline dev_queue_xmit()")
> Link: https://lore.kernel.org/linux-next/20220503073420.6d3f135d@canb.auug.org.au/
> Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  net/core/dev.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index c2d73595a7c3..a97fd413d705 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4085,8 +4085,7 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
>  	return netdev_get_tx_queue(dev, queue_index);
>  }
>  
> -/**
> - *	__dev_queue_xmit - transmit a buffer
> +/*	__dev_queue_xmit - transmit a buffer
>   *	@skb: buffer to transmit
>   *	@sb_dev: suboordinate device used for L2 forwarding offload
>   *
> -- 
> 2.25.1
> 

I'm in favor of this patch. Thanks.

-- 
An old man doll... just what I always wanted! - Clara
