Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C9541891E
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 15:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbhIZNsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 09:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbhIZNsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 09:48:13 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65D1C061575
        for <netdev@vger.kernel.org>; Sun, 26 Sep 2021 06:46:36 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so8057101pjw.0
        for <netdev@vger.kernel.org>; Sun, 26 Sep 2021 06:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hoc2plF4+OPmT8eX4M5TRQfS1ftQ4Y9cbVzrDjNipG4=;
        b=q4UFSf9V4CinTaVH9/B+glFy0NCCcYAodoA2K2RDWOuDpkmcbjyDnuvmWgaKBarRwt
         m57jKwUbxiIF1EYfusaMvuWTB37aESty/PEWwpcn+MNJMjcL2fGu0F43uKQ125ouet5J
         r9U5r4HE1OjN41yvRzxd5MdAqo8NweKm9V+wAmxDgSxcA3aircxDIHIj6Kwcfvx+7S7W
         6YY6bRRhRoBkCM10OA0GTSw9UXCgg7lDvH2PZ0kfzpexHG9Ksni+RVl6h66HJdrdsfON
         mMYADp0F5MrDnjNn0e6n1ONeEXRIEi6rvlgpR6exxgVBf64VWRKuKR1hx2aJM8zk4hOm
         He/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hoc2plF4+OPmT8eX4M5TRQfS1ftQ4Y9cbVzrDjNipG4=;
        b=c2je+J8sw4Yz5cLqZmtbqkpKXoSAf4xK/GgYSDbemBKwrcq14dt49yZEdXSDt/nuKT
         2wStJsaevE4H8H+jhg/GlbALu4KMZqIzJ4cQbYN0QDxm7MyaQoODE+BimMfQfgE1AgQP
         rOocrHkzK+kmYRtAITN8eBewLtLBLJqLV6qTGTQpQN+4mk9L9fzpsT/yfzD1RUc2ujiS
         BC9+3Nl1ISI1emCsByvwf6B1PWmLfBIUZjWTBuV9diqHnPHTGtajCp3Zcnw+stySOO6F
         LKGTG3pib1nv7C4tXxYSqJ4SvkTyiIl3S8VjYqjvQFa139kVhzO60OcDSSfB9JqMzvU9
         iCCg==
X-Gm-Message-State: AOAM532JBJCkDm+bR4MuEtOQuxs/7GR5iLLszpQIkd3gF97z4FO7UskY
        +G0v9jsMeYEWdv6zPPDW7OpMow==
X-Google-Smtp-Source: ABdhPJyO/t4E3u3BJCQfQDqwBaAi3UUlEPIhdqN0GASaBE1juM8PWSXqYr9pni33YFxR1cQxlmTvYQ==
X-Received: by 2002:a17:90a:8c81:: with SMTP id b1mr7919024pjo.61.1632663996302;
        Sun, 26 Sep 2021 06:46:36 -0700 (PDT)
Received: from dragon (80.251.214.228.16clouds.com. [80.251.214.228])
        by smtp.gmail.com with ESMTPSA id m186sm12443375pfb.165.2021.09.26.06.46.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 26 Sep 2021 06:46:36 -0700 (PDT)
Date:   Sun, 26 Sep 2021 21:46:29 +0800
From:   Shawn Guo <shawn.guo@linaro.org>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Alex Elder <elder@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Steev Klimaszewski <steev@kali.org>, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipa: Declare IPA firmware with MODULE_FIRMWARE()
Message-ID: <20210926134628.GC9901@dragon>
References: <20210926065529.25956-1-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210926065529.25956-1-shawn.guo@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 26, 2021 at 02:55:29PM +0800, Shawn Guo wrote:
> Declare IPA firmware with MODULE_FIRMWARE(), so that initramfs tools can
> build the firmware into initramfs image or warn on missing of the
> firmware.
> 
> W: Possible missing firmware /lib/firmware/ipa_fws.mdt for module ipa
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  drivers/net/ipa/ipa_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
> index cdfa98a76e1f..264bebc78d1e 100644
> --- a/drivers/net/ipa/ipa_main.c
> +++ b/drivers/net/ipa/ipa_main.c
> @@ -545,6 +545,8 @@ static int ipa_firmware_load(struct device *dev)
>  	return ret;
>  }
>  
> +MODULE_FIRMWARE(IPA_FW_PATH_DEFAULT);
> +

Just reminded by Steev, .mdt file conventionally means we are using
split firmware.  Building only .mdt file into initramfs is not
sufficient.  So please disregard the patch.

Shawn

>  static const struct of_device_id ipa_match[] = {
>  	{
>  		.compatible	= "qcom,msm8998-ipa",
> -- 
> 2.17.1
> 
