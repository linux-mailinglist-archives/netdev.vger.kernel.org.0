Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477C53892E9
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 17:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348078AbhESPrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 11:47:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241115AbhESPrJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 11:47:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60A81611B0;
        Wed, 19 May 2021 15:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621439150;
        bh=5mq2zuZKNWGNXVkYrvisy1MuhWbWO9mkUZ4l0aSaBjI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U8XYy2y9TO1XoEExwcRb5SUOfmX3W3ua2IclWwusIw9WGR23Veww2UNOQLMhzKcET
         NG/YiptSwY68QO5aL3cNAUTR00HZLOCgB0Zq3GmJyM4sam73EnqZjsTcd7ooc0bH9W
         PdQjeETbN9TRnemzx/r+GkZYv6GrQN4NHvv5rgG4mnVy/5X8V0SH4/XzV7QHXtFFrc
         4c/N2O4A2ewS5GWS/cXmJGwrCUJC0I2k4JtHofbakiZOL9ItfYbJNOGxajW18tWSCM
         7aQvdobEbIfLGDtTeINHy8iCUkuSn3LbKm+MY+vPMtn4/C/mCoozsteSPJwh2DNjLN
         T+tDJuClF/5bg==
Date:   Wed, 19 May 2021 18:45:46 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Karsten Keil <isdn@linux-pingi.de>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] mISDN: Mark local variable 'incomplete' as
 __maybe_unused in dsp_pipeline_build()
Message-ID: <YKUyqhva+2UQ44Ly@unreal>
References: <20210519125352.7991-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519125352.7991-1-thunder.leizhen@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 08:53:52PM +0800, Zhen Lei wrote:
> GCC reports the following warning with W=1:
> 
> drivers/isdn/mISDN/dsp_pipeline.c:221:6: warning:
>  variable 'incomplete' set but not used [-Wunused-but-set-variable]
>   221 |  int incomplete = 0, found = 0;
>       |      ^~~~~~~~~~
> 
> This variable is used only when macro PIPELINE_DEBUG is defined.

That define is commented 13 years ago and can be seen as a dead code
that should be removed.

Thanks

> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  drivers/isdn/mISDN/dsp_pipeline.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
> index 40588692cec7..6a31f6879da8 100644
> --- a/drivers/isdn/mISDN/dsp_pipeline.c
> +++ b/drivers/isdn/mISDN/dsp_pipeline.c
> @@ -218,7 +218,7 @@ void dsp_pipeline_destroy(struct dsp_pipeline *pipeline)
>  
>  int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
>  {
> -	int incomplete = 0, found = 0;
> +	int __maybe_unused incomplete = 0, found = 0;
>  	char *dup, *tok, *name, *args;
>  	struct dsp_element_entry *entry, *n;
>  	struct dsp_pipeline_entry *pipeline_entry;
> -- 
> 2.25.1
> 
> 
