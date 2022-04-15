Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9984D50256E
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 08:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350238AbiDOGT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 02:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbiDOGT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 02:19:26 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62749AFAD3;
        Thu, 14 Apr 2022 23:16:59 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id s14so6433416plk.8;
        Thu, 14 Apr 2022 23:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jatt+V+nXfhqQM9//07B65SFV6bMNiaWeVlnWsPUEY8=;
        b=LeUSar5B5rvRe12ca2HvwfsVrBkcS7B5f3PFuXsUAtqfFCTENTy3DNmOjAu0dXQ6ce
         VEvEHCb49p8sHqRbzPcJW+sZFgJ3RwMDydc+m/12fEmiOS4OgNZXWfMGxqQ6zzAyxAlS
         o7AjjKHlHiwFbDNe+H3dQmtZLC7gcjsD/t9UGTICwxqL6JbR2vVugF6SJ7QZMBg5PpwH
         HDaXu/rxmXVGxnh2e60yCk/nvpy5ANAnD+UJtek/THOl1cMa89SCw7BmSJG6R9giD0tP
         BmOdvdyptPOFvmUzIbrSYCMeFmFFgLqFPTCus8q72vLxEn58i0hps40w1pC1q+9AutZl
         598A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jatt+V+nXfhqQM9//07B65SFV6bMNiaWeVlnWsPUEY8=;
        b=5jYjquN8cej1gmd22l6FMD9L8i02HnlKo8Z2VmbkIkrH9cAmHkT3mVYNta44Qfa9j7
         GrlfEZA4MG4g+1Wd8iHj0dX6AdXExS2824lnP4VuSLuqfb7u9diF/+IEWKS8SNk+GAFM
         Q7jIQx2ro5ttJJ/ppUfPNwt21OFy6dO7OyCP8mhrztTkGA1cz5f12LW5Ty8ne/jtFN48
         TKzSzZ86PlyoFbYNCl1YIjFhPdTAwWxgy2Xy5/6RsomOo9ljb0M8SqYfh6kyB+2WuQoK
         geIZrdJR2rbu7dqMVzDCiy5FePf8m+2lKTqLF6brqGr3N5Y/epuYVlB0S1LIUGSWkMhY
         xAZA==
X-Gm-Message-State: AOAM532sXxOKrMqaA39G3W38PilAAi8YdNxUIncjOYsxkRXIkMYfxery
        esuYn6CY5bs9y8r9Rh5eE84=
X-Google-Smtp-Source: ABdhPJxXl2J8MrOMJqY9UdpMm/pHQYL5wUpT7PmiQkXC6CUQF1tguXDxp0bE3E9oeAy+7fsxAK1UUA==
X-Received: by 2002:a17:903:2cb:b0:14f:4fb6:2fb0 with SMTP id s11-20020a17090302cb00b0014f4fb62fb0mr49422092plk.172.1650003418858;
        Thu, 14 Apr 2022 23:16:58 -0700 (PDT)
Received: from d3 ([2405:6580:97e0:3100:ae94:2ee7:59a:4846])
        by smtp.gmail.com with ESMTPSA id h18-20020a056a001a5200b0050a43bb7ae6sm479281pfv.161.2022.04.14.23.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 23:16:58 -0700 (PDT)
Date:   Fri, 15 Apr 2022 15:16:52 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Yihao Han <hanyihao@vivo.com>, Wen Gong <quic_wgong@quicinc.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com
Subject: Re: [PATCH] ath11k: simplify if-if to if-else
Message-ID: <YlkN1FsTd0Bozz0K@d3>
References: <20220414092042.78152-1-hanyihao@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414092042.78152-1-hanyihao@vivo.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-14 02:20 -0700, Yihao Han wrote:
> Replace `if (!ab->is_reset)` with `else` for simplification
> and add curly brackets according to the kernel coding style:
> 
> "Do not unnecessarily use braces where a single statement will do."
> 
> ...
> 
> "This does not apply if only one branch of a conditional statement is
> a single statement; in the latter case use braces in both branches"
> 
> Please refer to:
> https://www.kernel.org/doc/html/v5.17-rc8/process/coding-style.html

Same comment about the curly brackets part of the log as for the qlcnic
patch, it doesn't match the changes.

> 
> Signed-off-by: Yihao Han <hanyihao@vivo.com>
> ---
>  drivers/net/wireless/ath/ath11k/core.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
> index cbac1919867f..80009482165a 100644
> --- a/drivers/net/wireless/ath/ath11k/core.c
> +++ b/drivers/net/wireless/ath/ath11k/core.c
> @@ -1532,8 +1532,7 @@ static void ath11k_core_restart(struct work_struct *work)
>  
>  	if (ab->is_reset)
>  		complete_all(&ab->reconfigure_complete);
> -
> -	if (!ab->is_reset)
> +	else
>  		ath11k_core_post_reconfigure_recovery(ab);
>  }

It seems there is no synchronization around is_reset but is it
guaranteed that it cannot be changed by ath11k_core_reset() between the
two tests? I'm not familiar with the driver.
