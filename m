Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D117244CD2
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 18:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgHNQkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 12:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgHNQkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 12:40:33 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631A3C061384;
        Fri, 14 Aug 2020 09:40:33 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id j9so8939921ilc.11;
        Fri, 14 Aug 2020 09:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=6kFd9MKJ26HXWbtZalFdRqvz3pTX7PP0OTXt4UnbRWo=;
        b=n5LWdSu7L9rgnPtztRpSIfGLxql9kQGyKLAbC+ID0HNw8i12hLRYN9Gg5xTSxvjjFb
         ENw2YIpZL/fIuLE9nLvTkO2Zf07KDkKCit2uiZQ/IXcqWm28jWQSAYIMcYOmAc5bV3ME
         U7pYhRgOaci3HKZyFI7lv3QPYVPAdHlsaPplA6kZU0DOkuoj4IVfFxZqZdZJILsJvbw/
         kKZ1inh/0aRkArdJ6ETKLP3V7+GPJ0tml8UUiesQlR3GhcbDRF2iCgPU8GyiSdnnpQpr
         B3OS35sJJ7LSn856cPU99tnhpz0XdqMgG+4Vra61B2Gbug1XTAI8FVEtE3TKfiKIVmRE
         Q71g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=6kFd9MKJ26HXWbtZalFdRqvz3pTX7PP0OTXt4UnbRWo=;
        b=PRvUDJR3fJcmdPwufol1TesfrZRoTCnKckjUGqDxPTb+QDqOvIwee3soCxrOPryAQL
         OXOh/Vdqe8Aq2qz665tYn/TPTDdHlx7p9wJOq4E9BN/npJEco3Xeb1SyhxOuj3bgMlHC
         amweigprNBMud5FliKc56Wj4H6yMWLO1AyGG3sN/qDbfawLi+/bAjZjw7LdrhfP6dqgm
         svMJ4tGURqnylManOdhaYapoN7lAxh9xqyAxI7ZGxjuru+PZr/LxjjxzrSK+jwoF18C/
         b26BnccPHsXlUIygKy8azTU8avqc3AraWE3T69KCoSBZQKUHwJc8JICUt3phdLlCrdIL
         TyRA==
X-Gm-Message-State: AOAM530Q+F6DNl2bvTwgsbrn6gNuN7cv/Y8sZ/HtCe+EJRVTQItESmCS
        mqXWruRuUwuB2SqZoyxiRY1ykhjlsJWxE1Qw1fQ=
X-Google-Smtp-Source: ABdhPJzvaBuDiE50Vb6Q7YRhmN5NkFmWlJD3sMdLIyDRDHJv8cYBY5vvXM5zEZduDvaYqXBCYDiGO4BFv2Kg36Hw8PU=
X-Received: by 2002:a92:98c1:: with SMTP id a62mr3201014ill.195.1597423232780;
 Fri, 14 Aug 2020 09:40:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6602:2815:0:0:0:0 with HTTP; Fri, 14 Aug 2020 09:40:32
 -0700 (PDT)
In-Reply-To: <20200814144844.1920-1-tangbin@cmss.chinamobile.com>
References: <20200814144844.1920-1-tangbin@cmss.chinamobile.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Fri, 14 Aug 2020 18:40:32 +0200
Message-ID: <CAKR_QVLYeY5g8kuGwCPBj+aRMmE_yAUYx593vW1-UGYZGZnH3w@mail.gmail.com>
Subject: Re: [PATCH] ath10k: fix the status check and wrong return
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/08/2020, Tang Bin <tangbin@cmss.chinamobile.com> wrote:
> In the function ath10k_ahb_clock_init(), devm_clk_get() doesn't
> return NULL. Thus use IS_ERR() and PTR_ERR() to validate
> the returned value instead of IS_ERR_OR_NULL().
>
> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> ---
>  drivers/net/wireless/ath/ath10k/ahb.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/ahb.c
> b/drivers/net/wireless/ath/ath10k/ahb.c
> index ed87bc00f..ea669af6a 100644
> --- a/drivers/net/wireless/ath/ath10k/ahb.c
> +++ b/drivers/net/wireless/ath/ath10k/ahb.c
> @@ -87,24 +87,24 @@ static int ath10k_ahb_clock_init(struct ath10k *ar)
>  	dev = &ar_ahb->pdev->dev;
>
>  	ar_ahb->cmd_clk = devm_clk_get(dev, "wifi_wcss_cmd");
> -	if (IS_ERR_OR_NULL(ar_ahb->cmd_clk)) {
> +	if (IS_ERR(ar_ahb->cmd_clk)) {
>  		ath10k_err(ar, "failed to get cmd clk: %ld\n",
>  			   PTR_ERR(ar_ahb->cmd_clk));
> -		return ar_ahb->cmd_clk ? PTR_ERR(ar_ahb->cmd_clk) : -ENODEV;
> +		return PTR_ERR(ar_ahb->cmd_clk);
>  	}
>
>  	ar_ahb->ref_clk = devm_clk_get(dev, "wifi_wcss_ref");
> -	if (IS_ERR_OR_NULL(ar_ahb->ref_clk)) {
> +	if (IS_ERR(ar_ahb->ref_clk)) {
>  		ath10k_err(ar, "failed to get ref clk: %ld\n",
>  			   PTR_ERR(ar_ahb->ref_clk));
> -		return ar_ahb->ref_clk ? PTR_ERR(ar_ahb->ref_clk) : -ENODEV;
> +		return PTR_ERR(ar_ahb->ref_clk);
>  	}
>
>  	ar_ahb->rtc_clk = devm_clk_get(dev, "wifi_wcss_rtc");
> -	if (IS_ERR_OR_NULL(ar_ahb->rtc_clk)) {
> +	if (IS_ERR(ar_ahb->rtc_clk)) {
>  		ath10k_err(ar, "failed to get rtc clk: %ld\n",
>  			   PTR_ERR(ar_ahb->rtc_clk));
> -		return ar_ahb->rtc_clk ? PTR_ERR(ar_ahb->rtc_clk) : -ENODEV;
> +		return PTR_ERR(ar_ahb->rtc_clk);
>  	}
>
>  	return 0;
> --
> 2.20.1.windows.1
>
>
>
>

Hi

You should've include which HW/FW combination you tested this on
