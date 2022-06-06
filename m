Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1140553EDB2
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 20:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiFFSOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 14:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbiFFSOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 14:14:11 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122BC1EE6E9
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 11:14:10 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id b135so13309727pfb.12
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 11:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BKtPwMUXie7g4BTvnYFB06bJ1lqeS0VDnIi+PuKvIk4=;
        b=QPYDCgOhcWP7ZJtPVM6YyQMFudpnbxAWNVBjk8usYVzstW9wTP7fRz9d1vsueKTkXQ
         lJavanuHLYqsz2sdKXd8Aj4un3caqBzXCxcyrvmF/cMqN8V4akbOG2caMaOAWkK/lAz3
         cmwpPdLT8pjFTMWPD2ocNkEfovkxtcqr+ou5c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BKtPwMUXie7g4BTvnYFB06bJ1lqeS0VDnIi+PuKvIk4=;
        b=ok3Tq8/qogLxYpyhlYg6DTE1dpYCLE5D7TMnAtSPbwfbIZJDxUsVXcFfmfJR0mUv4x
         deXOmXlxFme9axNbuexhtEc6bcnRhw7sgsHHe6IAD7kVhu8JmOruJmaMkd8j/edggYl8
         vv2KgAAoFNZKerfo7iubtghy9fpB2aalX8nf3b0dEqicF+YpdMGlGmos38YM9wyH9Zbb
         rrM3uK/A1LG5dFF2ihqTj9nWQI+wE83TSiqE8ZL6dj751aqa7nhVTQulsn61gv2HZsjQ
         FCZfcgVgJZssl0rP9CQ5sJqIz3iYcIlnnDFcZ+0UAYK+tc6U1DlJyGAEvVcSz/IaJWhq
         1Qlg==
X-Gm-Message-State: AOAM533pA/xB2Zb1vXFcC5i/bc2l+2JxFuv5G+XR5tGzFHtrf1Ob17kr
        VgA17r8al9QeE+PCISQmE3FQaQ==
X-Google-Smtp-Source: ABdhPJzXbGFrXBHqxba8t5vpk4T6DIeM1IIDerEZasSPyWlyYN/rGgwQDFwyqowzN83RwvX0/qpenQ==
X-Received: by 2002:a65:5188:0:b0:3fa:6081:7393 with SMTP id h8-20020a655188000000b003fa60817393mr21698692pgq.72.1654539249516;
        Mon, 06 Jun 2022 11:14:09 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:6e63:c427:72dc:aaa8])
        by smtp.gmail.com with ESMTPSA id cp14-20020a170902e78e00b0015e8d4eb1d3sm10770551plb.29.2022.06.06.11.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 11:14:08 -0700 (PDT)
Date:   Mon, 6 Jun 2022 11:14:05 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        johannes@sipsolutions.net, gregkh@linuxfoundation.org,
        rafael@kernel.org
Subject: Re: [PATCH v5 2/2] mwifiex: fix sleep in atomic context bugs caused
 by dev_coredumpv
Message-ID: <Yp5D7TRdNJ+bW1ud@google.com>
References: <cover.1654229964.git.duoming@zju.edu.cn>
 <54f886c2fce5948a8743b9de65d36ec3e8adfaf1.1654229964.git.duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54f886c2fce5948a8743b9de65d36ec3e8adfaf1.1654229964.git.duoming@zju.edu.cn>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 03, 2022 at 01:09:35PM +0800, Duoming Zhou wrote:
> There are sleep in atomic context bugs when uploading device dump
> data in mwifiex. The root cause is that dev_coredumpv could not
> be used in atomic contexts, because it calls dev_set_name which
> include operations that may sleep. The call tree shows execution
> paths that could lead to bugs:
...
> Fixes: f5ecd02a8b20 ("mwifiex: device dump support for usb interface")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
> Changes in v5:
>   - Use delayed work to replace timer.
> 
>  drivers/net/wireless/marvell/mwifiex/init.c      | 10 ++++++----
>  drivers/net/wireless/marvell/mwifiex/main.h      |  2 +-
>  drivers/net/wireless/marvell/mwifiex/sta_event.c |  6 +++---
>  3 files changed, 10 insertions(+), 8 deletions(-)

Looks great! Thanks for working on this.

Reviewed-by: Brian Norris <briannorris@chromium.org>

Some small nitpicks below, but they're definitely not critical.

> diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
> index 88c72d1827a..3713f3e323f 100644
> --- a/drivers/net/wireless/marvell/mwifiex/init.c
> +++ b/drivers/net/wireless/marvell/mwifiex/init.c
> @@ -63,9 +63,11 @@ static void wakeup_timer_fn(struct timer_list *t)
>  		adapter->if_ops.card_reset(adapter);
>  }
>  
> -static void fw_dump_timer_fn(struct timer_list *t)
> +static void fw_dump_work(struct work_struct *work)
>  {
> -	struct mwifiex_adapter *adapter = from_timer(adapter, t, devdump_timer);
> +	struct mwifiex_adapter *adapter = container_of(work,
> +					struct mwifiex_adapter,
> +					devdump_work.work);

Super nitpicky: the hanging indent style seems a bit off. I typically
see people try to align to the first character after the parenthesis,
like:

	struct mwifiex_adapter *adapter = container_of(work,
						       struct mwifiex_adapter,
						       devdump_work.work);

It's not a clearly-specified style rule I think, so I definitely
wouldn't insist.

On the bright side: I think the clang-format rules (in .clang-format)
are getting better, so one can make some formatting decisions via tools
instead of opinion and close reading! Unfortunately, we probably can't
do that extensively and automatically, because I doubt people will love
all the reformatting because of all the existing inconsistent style.

Anyway, to cut to the chase: clang-format chooses moving to a new line:

	struct mwifiex_adapter *adapter =
		container_of(work, struct mwifiex_adapter, devdump_work.work);

More info if you're interested:
https://www.kernel.org/doc/html/latest/process/clang-format.html

>  
>  	mwifiex_upload_device_dump(adapter);
>  }

...

> diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
> index 332dd1c8db3..6530c6ee308 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.h
> +++ b/drivers/net/wireless/marvell/mwifiex/main.h
> @@ -1055,7 +1055,7 @@ struct mwifiex_adapter {

Nitpick: main.h is probably missing a lot of #includes, but you could
probably add <linux/workqueue.h> while you're at it.

Brian

>  	/* Device dump data/length */
>  	void *devdump_data;
>  	int devdump_len;
> -	struct timer_list devdump_timer;
> +	struct delayed_work devdump_work;
>  
>  	bool ignore_btcoex_events;
>  };
