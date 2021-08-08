Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B7D3E3C9C
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 22:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbhHHUC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 16:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhHHUC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 16:02:58 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1743C061760
        for <netdev@vger.kernel.org>; Sun,  8 Aug 2021 13:02:38 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id a5-20020a05683012c5b029036edcf8f9a6so15591824otq.3
        for <netdev@vger.kernel.org>; Sun, 08 Aug 2021 13:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UCT7FLsey68PTcAFD96vt4fuP+5ZLftDCPDj1rG9OhQ=;
        b=XxX8WYKCfZVJVL3w1FTUs65UlK9SqjclkVPa8aRr3yiYAJhHoGrG7y57kXYcOmP7CY
         o68jZXbrLI0wIlYWFSo8lQfdrDZlQ7pAMKpJmqqB/iqRaOvtSbkdu34WvdoEiqo8UI5/
         xFx+1xqK3gCGImNDMgSC6WGF0oEoWZqLHyWRpYMNOuNvSXq8X3I3OCFSWiTgxIEYkSbt
         30s8/DTuJngHWcNXX6jKlqlVwi9iNQ9DGcxX1nwD+NY8jXZpGLxcY+ZBtEIkyFjskyUn
         knwj442tzHWC2f4PEXq1SDQpeylD8fRR4//SWvePsm97hZGAAKLJ9JmRGCf5zfEurKEV
         nnZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UCT7FLsey68PTcAFD96vt4fuP+5ZLftDCPDj1rG9OhQ=;
        b=MWoSNcqaB5qGPzJonQM6iAPg8WyzbGgwrjB09W98d9HP2t8b09KzavtBmjxYs7fODR
         PyYX0UXjRZ7dk3at9asfQ3Gfh+HN5pgpnse6mmbE3iVH+Inq7O3NGq8zwM9/D02YhOy5
         4xCZnbZ7UcqhlXd6dEgClOXrwtCWrzAKUTm1jsjevbtyprtttLSHI/OS2x2NC3O0XGHU
         IxNQE5egWqlxVFFcTbXo664deAmV925Emhx2pi2xYt3cXDrrabwspP+kk/Um8oX9/NyA
         o92Cm5OSVBsstE2R2lHqEwMEldeB1i2PgJF4V7hQk7eshbm/0I/HCuY/viqE5IU9Z5mG
         IiBg==
X-Gm-Message-State: AOAM533EE4IvYXXtFUD1ktUVo1EUwhBSLziG7oqDjtB3q+gZSpo1oLYY
        W6mu4vEN7hK0Js+9yloH/yo=
X-Google-Smtp-Source: ABdhPJwCnoV6yw4dt03S7U002zpgtakT1ltiES+iM3veZprrZSZcgJsMe2MexHl+tUZBe7/P63lmFQ==
X-Received: by 2002:a05:6830:2783:: with SMTP id x3mr14814333otu.37.1628452958246;
        Sun, 08 Aug 2021 13:02:38 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id m4sm2406480oou.0.2021.08.08.13.02.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Aug 2021 13:02:37 -0700 (PDT)
Subject: Re: [PATCH] net: Support filtering interfaces on no master
To:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org
Cc:     dsahern@kernel.org, davem@davemloft.net, kuba@kernel.org
References: <20210808132836.1552870-1-lschlesinger@drivenets.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <439cf1f8-78ad-2fec-8a43-a863ac34297b@gmail.com>
Date:   Sun, 8 Aug 2021 14:02:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210808132836.1552870-1-lschlesinger@drivenets.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/21 7:28 AM, Lahav Schlesinger wrote:
> Currently there's support for filtering neighbours/links for interfaces
> which have a specific master device (using the IFLA_MASTER/NDA_MASTER
> attributes).
> 
> This patch adds support for filtering interfaces/neighbours dump for
> interfaces that *don't* have a master.
> 
> I have a patch for iproute2 ready for adding this support in userspace.
> 
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/core/neighbour.c | 7 +++++++
>  net/core/rtnetlink.c | 7 +++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 53e85c70c6e5..1b1e0ca70650 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -2533,6 +2533,13 @@ static bool neigh_master_filtered(struct net_device *dev, int master_idx)
>  		return false;
>  
>  	master = dev ? netdev_master_upper_dev_get(dev) : NULL;
> +
> +	/* 0 is already used to denote NDA_MASTER wasn't passed, therefore need another
> +	 * invalid value for ifindex to denote "no master".
> +	 */
> +	if (master_idx == -1)
> +                return (bool)master;

return !!master;

same below

> +
>  	if (!master || master->ifindex != master_idx)
>  		return true;
>  
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index f6af3e74fc44..8ccc314744d4 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1970,6 +1970,13 @@ static bool link_master_filtered(struct net_device *dev, int master_idx)
>  		return false;
>  
>  	master = netdev_master_upper_dev_get(dev);
> +
> +	/* 0 is already used to denote IFLA_MASTER wasn't passed, therefore need
> +	 * another invalid value for ifindex to denote "no master".
> +	 */
> +	if (master_idx == -1)
> +                return (bool)master;
> +
>  	if (!master || master->ifindex != master_idx)
>  		return true;
>  
> 

