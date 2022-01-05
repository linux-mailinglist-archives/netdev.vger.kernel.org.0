Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F476485621
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241643AbiAEPoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241641AbiAEPoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:44:25 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E048DC061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 07:44:24 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z29so163644124edl.7
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 07:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eqwGD9UokDN9AU9Zm6Xj/LCn+ypWHHeElujYubQFiIY=;
        b=b7gu7rCJbh1dh63GXGswMoMuO9W0ouFVjIKzPtPeyimsPdhtoarMb7we6G2P8n8RHD
         NhxsbRRk+CL7D/OXd4E8iT2RzNQYI6M1xYv9ZbwtVwGpcRxqg8gunUNVYlJdIbi8pPvg
         dahHy2I2MehIJ1HCqp/d6GNX059hVYjW45ObOZPFg7fLQ0/DFeeSAHY7hsQq0u+pl6cP
         jjgGJJimpHJb3tcK0PHyx4yZUhMpobQH9WE0RAhkq8xhV0w+hdLhkJfNIEJ4iOAyM497
         0MzkakAXwmghGTPcHnIXu74cPLbjgTI62ihoXZDXP+dnqVwD1P6WTt+CgdrhPC51jBj3
         YENw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eqwGD9UokDN9AU9Zm6Xj/LCn+ypWHHeElujYubQFiIY=;
        b=XwOAnNhn7PTh4I36lwMaKzohoI801ygz+6dZOSIqT6Ua0h6VWw51lsVOI3rYUMlV0O
         BfADhQtEGRe70VEAd0hyuX9eNp+ZCcRwJkJesyyH0kfJw1aIZo1hisqxuTj4Wdh3yKrL
         FLeZFp7RziI8yXU3UWGYJy9SuLYrgEU8CnOyt+p6cEIJzfLjQ5oA4opU7ZumHWjKctcM
         luSxJcxsGorflcEHojjgsypyMW0SFFmrAC6XinZKjzkceNOnuWBxRUVj10egPwFgOkPn
         VZ8fKCgnol7LAU+577xwJqFZjtCgpUaYs5O0HWWQkDa6Pi4JSPyabnzonsR6Q5RQ2U+w
         y0dQ==
X-Gm-Message-State: AOAM531vqPu28BBCSd/RyqKT/MrLO5Ko0T4bs4wKByYZMdW1Hvcc5g08
        lc9hp3DKM5BXBRwq82AGRiA=
X-Google-Smtp-Source: ABdhPJxd1bbXhuZiZbaIM5epOqENOZeCAJmCsxhL97CBJyBoELMIfYo7qvj9VhTrn46yitbtCqjJLA==
X-Received: by 2002:a17:907:a412:: with SMTP id sg18mr42688548ejc.2.1641397463390;
        Wed, 05 Jan 2022 07:44:23 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id ky5sm4120983ejc.204.2022.01.05.07.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 07:44:22 -0800 (PST)
Date:   Wed, 5 Jan 2022 17:44:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] testptp: set pin function before other requests
Message-ID: <20220105154422.r7pkgikdiffxpl77@skbuf>
References: <20220105152506.3256026-1-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105152506.3256026-1-mlichvar@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 04:25:06PM +0100, Miroslav Lichvar wrote:
> When the -L option of the testptp utility is specified with other
> options (e.g. -p to enable PPS output), the user probably wants to
> apply it to the pin configured by the -L option.
> 
> Reorder the code to set the pin function before other function requests
> to avoid confusing users.
> 
> Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> ---

This makes sense. Looking back at my logs, I was setting the pin
function via sysfs, but if the code was structured differently I could
have done it in a single command using testptp. Not sure why I didn't
think of that.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  tools/testing/selftests/ptp/testptp.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
> index f7911aaeb007..c0f6a062364d 100644
> --- a/tools/testing/selftests/ptp/testptp.c
> +++ b/tools/testing/selftests/ptp/testptp.c
> @@ -354,6 +354,18 @@ int main(int argc, char *argv[])
>  		}
>  	}
>  
> +	if (pin_index >= 0) {
> +		memset(&desc, 0, sizeof(desc));
> +		desc.index = pin_index;
> +		desc.func = pin_func;
> +		desc.chan = index;
> +		if (ioctl(fd, PTP_PIN_SETFUNC, &desc)) {
> +			perror("PTP_PIN_SETFUNC");
> +		} else {
> +			puts("set pin function okay");
> +		}
> +	}
> +
>  	if (extts) {
>  		memset(&extts_request, 0, sizeof(extts_request));
>  		extts_request.index = index;
> @@ -444,18 +456,6 @@ int main(int argc, char *argv[])
>  		}
>  	}
>  
> -	if (pin_index >= 0) {
> -		memset(&desc, 0, sizeof(desc));
> -		desc.index = pin_index;
> -		desc.func = pin_func;
> -		desc.chan = index;
> -		if (ioctl(fd, PTP_PIN_SETFUNC, &desc)) {
> -			perror("PTP_PIN_SETFUNC");
> -		} else {
> -			puts("set pin function okay");
> -		}
> -	}
> -
>  	if (pps != -1) {
>  		int enable = pps ? 1 : 0;
>  		if (ioctl(fd, PTP_ENABLE_PPS, enable)) {
> -- 
> 2.33.1
> 
