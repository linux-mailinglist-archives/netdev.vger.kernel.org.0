Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27058639F83
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 03:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiK1CjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 21:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiK1Ci7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 21:38:59 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE10211460
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 18:38:56 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id z9so4438828ilu.10
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 18:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cuFF8JiuUF+OouyKLi5o1bz927z4lwXxfm9JO6gCJp8=;
        b=ewIVRk+dAVCbJqcEdLW5nyqbkWkOQ5e5HkT3I469Uz+93hUI+5sAw/nCLdl3l1sCT2
         FfxRoVThmsy3LhdQVYvgcivWJ+KQYrflPDR6JfsBWl5Nulnb+ilBtbZJL063SBqCefPE
         dkxdhzefkerikyrHVvZ3etH3AlQ7v3X6kEtmxoNJHE0FguSOaaWxr6LFLL0p88xf2b7l
         +ZkotCyU6YgLekspHsTksebuSW6mEck7wNUq0sXMzfR+/X0A1xbAZ68gyg7+j84w3IgH
         Yt7CXUApv0D4XgWawOB5fGsgunflTc3b6RWH8qrItF2Fc4FsXGYgWXzL9vBIvBG2O5Db
         Jetg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cuFF8JiuUF+OouyKLi5o1bz927z4lwXxfm9JO6gCJp8=;
        b=LqKs1+VXwIr8CotquXejb4gmJV0j91R3Vtjw929eZUeEhSxV50gtEQuf0TA8LUQgAL
         xSmmGpkxe7zcr4jn4VyeObbkD+QoWVZ2FVXSeqTBQVJrYX1VpVVqa5X2HgKu8gzGWz69
         PCGUbLXUYgL79LvTrdrSuBouvtX2dSLKS6iG6P/vDQqdTMSnt7ZAZOCAcRmgszA9KMwV
         GTuZr20HS+hG8fIbm/XIbrN3/bHXuq6Q4oZrWDzvV0KRsQBRFKdHeR1JZgX/qAr26ITs
         7fLfnemN6K8AkAeqt7Mm2D1iBORvI2LGzQfTzvcDQQxdtiIEqDIeteyiEPLe7RCjt0Qh
         VzvA==
X-Gm-Message-State: ANoB5pm6cXk2zYhbY6+mpoYYVirUpjug8I/lRO6Qe4C8chw+viuDC2XS
        gUMSq2l/8EV1bp/zzNFWeq8=
X-Google-Smtp-Source: AA0mqf6RWVQQzFlaDKFIuNCVziuU5EQDR4ZhfkwYMlY6akusrOCUD18/D54pdAe6Im6R6pIZ1USJtw==
X-Received: by 2002:a05:6e02:108:b0:302:b8e6:deb7 with SMTP id t8-20020a056e02010800b00302b8e6deb7mr14441905ilm.247.1669603136370;
        Sun, 27 Nov 2022 18:38:56 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:e10a:56f2:3d71:c68c? ([2601:282:800:dc80:e10a:56f2:3d71:c68c])
        by smtp.googlemail.com with ESMTPSA id a17-20020a027351000000b00374fe4f0bc3sm3826349jae.158.2022.11.27.18.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Nov 2022 18:38:55 -0800 (PST)
Message-ID: <0f75a656-97f8-5f90-ab86-258fadc7ae63@gmail.com>
Date:   Sun, 27 Nov 2022 19:38:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH iproute2-next 1/5] devlink: Fix setting parent for 'rate
 add'
Content-Language: en-US
To:     Michal Wilczynski <michal.wilczynski@intel.com>,
        netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, przemyslaw.kitszel@intel.com,
        jiri@resnulli.us, wojciech.drewek@intel.com,
        stephen@networkplumber.org
References: <20221125123421.36297-1-michal.wilczynski@intel.com>
 <20221125123421.36297-2-michal.wilczynski@intel.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20221125123421.36297-2-michal.wilczynski@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/22 5:34 AM, Michal Wilczynski wrote:
> Setting a parent during creation of the node doesn't work, despite
> documentation [1] clearly saying that it should.
> 
> [1] man/man8/devlink-rate.8
> 
> Example:
> $ devlink port function rate add pci/0000:4b:00.0/node_custom parent node_0
>   Unknown option "parent"
> 
> Fix this by passing DL_OPT_PORT_FN_RATE_PARENT as an argument to
> dl_argv_parse() when it gets called from cmd_port_fn_rate_add().
> 
> Fixes: 6c70aca76ef2 ("devlink: Add port func rate support")

so this is a bug fix that needs to go in main branch first?


> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
>  devlink/devlink.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/devlink/devlink.c b/devlink/devlink.c
> index 8aefa101b2f8..5cff018a2471 100644
> --- a/devlink/devlink.c
> +++ b/devlink/devlink.c
> @@ -5030,7 +5030,8 @@ static int cmd_port_fn_rate_add(struct dl *dl)
>  	int err;
>  
>  	err = dl_argv_parse(dl, DL_OPT_PORT_FN_RATE_NODE_NAME,
> -			    DL_OPT_PORT_FN_RATE_TX_SHARE | DL_OPT_PORT_FN_RATE_TX_MAX);
> +			    DL_OPT_PORT_FN_RATE_TX_SHARE | DL_OPT_PORT_FN_RATE_TX_MAX |
> +			    DL_OPT_PORT_FN_RATE_PARENT);
>  	if (err)
>  		return err;
>  

