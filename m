Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB154A53B3
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 01:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiBAAFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 19:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiBAAFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 19:05:21 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA90C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 16:05:21 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id t199so13427509oie.10
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 16:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QCKQVmWjPU4am1IB1HRTAad0UyZsM4M4bXE/0UUx4OM=;
        b=ZOsDyVe4kvHNWs+NjElecOefo43rUIcSYceYGyffNEVqkgimTqiLvUy/3P3Yr8oucy
         8s462v5f8sZJOkzaHiF5SI/cyQH9j45zVcu+BmeIErRPoKC86N8jBGrm2mG9E6vuYdtP
         bcIBwtvUTs8xR3fj5dsQtlnzjHwV13y/5uRzans16PSihGQfZwbnvg5+8V/kVDONYm9S
         rnMhoPeB3Ki2rqeYvmXkwYyRn9xETNkEmA9g4CEBjCPzJqiRIjgttmRmJ8uziIjnbbli
         nIfo8B80kaWuCpQP0D2ruzkQ4euxJX5cgkd2py3KqJzXBdryz05iIYLcJu0C+GRYw/bg
         JqQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QCKQVmWjPU4am1IB1HRTAad0UyZsM4M4bXE/0UUx4OM=;
        b=050rqbFhQ8g1MVQCSAif513I8bfjb23EcpnDGDPeZ6cg7+rrmELSPhkBlCLIIiRQ/W
         uId6j9UsGNVwGni8ARigKxEekr2rjpsanjmsxPiy1VcL+eYl/r07FgyCFNf8dKdE1/CH
         SkTn7F6UqvOZ25005pI0BoPn0r6ZPYXMDBtytefPnsasQVJGZ9gQkN9T24OkJOSK0+w8
         4IY3pGYFOn08xJFWJhJAaHXas8mWJEB474QS+jGQ/G7ROLbZ6DcQ6gSO2WnVQDYQ6/IU
         scAqVEuGpoVCXiyrPWb/3DLowEt0qis5nigVbfHmnalGPK6X3h7Zz/xi+uxIza/CFSt+
         gKqQ==
X-Gm-Message-State: AOAM530iLi+klPF5DJ5sBDbki2t47n4SiunUvUDAFpn9gbziZwb1vS8g
        MfYkNNzTkKPw38b+TG9/SowSsA==
X-Google-Smtp-Source: ABdhPJzDPBkWMgsXGrWZrHMyZ9FYC3vx4V73mxgp7I0v3jdShKDLw/XSDUwTYo9OPTqIHeFAfH185w==
X-Received: by 2002:a05:6808:354:: with SMTP id j20mr14958946oie.130.1643673920773;
        Mon, 31 Jan 2022 16:05:20 -0800 (PST)
Received: from builder.lan ([2600:1700:a0:3dc8:3697:f6ff:fe85:aac9])
        by smtp.gmail.com with ESMTPSA id d23sm8656828ote.35.2022.01.31.16.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 16:05:20 -0800 (PST)
Date:   Mon, 31 Jan 2022 18:05:18 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, sboyd@kernel.org,
        tdas@codeaurora.org, mturquette@baylibre.com,
        linux-clk@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 8/8] clk: qcom: gcc-sm8150: Use PWRSTS_ON (only) as a
 workaround for emac gdsc
Message-ID: <Yfh5Pjpw693ZMteC@builder.lan>
References: <20220126221725.710167-1-bhupesh.sharma@linaro.org>
 <20220126221725.710167-9-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126221725.710167-9-bhupesh.sharma@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 26 Jan 16:17 CST 2022, Bhupesh Sharma wrote:

> EMAC GDSC currently has issues (seen on SA8155p-ADP) when its
> turn'ed ON, once its already in OFF state. So, use PWRSTS_ON
> state (only) as a workaround for now.
> 
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>  drivers/clk/qcom/gcc-sm8150.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/qcom/gcc-sm8150.c b/drivers/clk/qcom/gcc-sm8150.c
> index 2e71afed81fd..fd7e931d3c09 100644
> --- a/drivers/clk/qcom/gcc-sm8150.c
> +++ b/drivers/clk/qcom/gcc-sm8150.c
> @@ -3449,12 +3449,16 @@ static struct clk_branch gcc_video_xo_clk = {
>  	},
>  };
>  
> +/* To Do: EMAC GDSC currently has issues when its turn'ed ON, once
> + * its already in OFF state. So use PWRSTS_ON state (only) as a
> + * workaround for now.

So you're not able to turn on the GDSC after turning it off?

> + */
>  static struct gdsc emac_gdsc = {
>  	.gdscr = 0x6004,
>  	.pd = {
>  		.name = "emac_gdsc",
>  	},
> -	.pwrsts = PWRSTS_OFF_ON,
> +	.pwrsts = PWRSTS_ON,

Doesn't this tell the gdsc driver that the only state supported is "on"
and hence prohibit you from turning it on in the first place?

>  	.flags = POLL_CFG_GDSCR,

You could add ALWAYS_ON to .flags, but we need a better description of
the actual problem that you're working around.

Regards,
Bjorn

>  };
>  
> -- 
> 2.34.1
> 
