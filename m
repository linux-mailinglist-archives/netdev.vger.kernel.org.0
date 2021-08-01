Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482C53DCD04
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 19:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhHARua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 13:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbhHARu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 13:50:29 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA36C06175F
        for <netdev@vger.kernel.org>; Sun,  1 Aug 2021 10:50:20 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id f20-20020a9d6c140000b02904bb9756274cso3448495otq.6
        for <netdev@vger.kernel.org>; Sun, 01 Aug 2021 10:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=blfyC7IPYa+FvASX39fPApiOocfCs4RJhF13PwLC/PQ=;
        b=KX55b6O+KtCPx0zB2py9qb3TVznor3YJ5sgm9mSPta05tsF2YFYwetOzXLA/59LpXN
         87AohWoQUNYaETxWm4YGBmVl5lWkOylHZMFUpyMjEr5wZVwgWgho8uL9D7eMnSENt0+D
         2b+n5LabR/8rjr5GiR40/oZDMFf34G4KULsdA7DlhGDS/06RZCK3khWyzBtsGa40qtW1
         3HD59ufKTK/pF4CFUXM37UVrU7nPokhkFIZr9ijtrPWTx/TV2aCSniMN9jZpTscvQRaH
         0lG4bVHSqSfUzDGB0rUCVl8Wm/1Wt7Mnby+VcLMAozuKUyCmLrxC7KQjfEHcOUEgjD5k
         d0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=blfyC7IPYa+FvASX39fPApiOocfCs4RJhF13PwLC/PQ=;
        b=sLUjDY7kXEgEDVAGvvm7kbrYNvnLHNtplO1m6si/4s0LSOzYgaJH8sVj646J8ssGu9
         o7RCbHYrZaGcq5mlD/b0N8+abMqxekoevQbjvzjGcGwaSdmc9dp1yoMKhPS+WsveZkA3
         iSBrkJlJph6JG1ERkgvZX3YPfx2ZMOQoKFYnEIN0NdTVErb6mgN6+GwZgZsBD098ZAbP
         MgURGShTGWL7RAXd0cPYQrZ8WKIsGV1IFRtMHx4xq8yVRBq0L91tdshhwSuXwfxsI48X
         LmVBaOrtQXjHlp4QFrALHmLTaRti7dyuF6n0sWgeCRJzxP3Ul275CE2MwUp31ZYAxSV8
         /+OQ==
X-Gm-Message-State: AOAM530b+Njef8T7lOMEaprL0o4E++zan3fQ2S897AiITXFwGbOO/uNq
        MdY4U2gKzaDU9hXYuuuMTSY=
X-Google-Smtp-Source: ABdhPJwxENniXA5VcAX+hpm76SNqGCGLVc1TjJ2ToyaflPrQD65Ecf/u3J9jhKWgf8Amcfwi4OOnZw==
X-Received: by 2002:a05:6830:1e48:: with SMTP id e8mr9229541otj.219.1627840219554;
        Sun, 01 Aug 2021 10:50:19 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id q15sm1483991otf.70.2021.08.01.10.50.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Aug 2021 10:50:19 -0700 (PDT)
Subject: Re: [PATCH] neigh: Support filtering neighbours for L3 slave
To:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org
References: <20210801090105.27595-1-lschlesinger@drivenets.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <351cae13-8662-2f8f-dd8b-4127ead0ca2a@gmail.com>
Date:   Sun, 1 Aug 2021 11:50:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210801090105.27595-1-lschlesinger@drivenets.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/21 3:01 AM, Lahav Schlesinger wrote:
> Currently there's support for filtering neighbours for interfaces which
> are in a specific VRF (passing the VRF interface in 'NDA_MASTER'), but
> there's not support for filtering interfaces which are not in an L3
> domain (the "default VRF").
> 
> This means userspace is unable to show/flush neighbours in the default VRF
> (in contrast to a "real" VRF - Using "ip neigh show vrf <vrf_dev>").
> 
> Therefore for userspace to be able to do so, it must manually iterate
> over all the interfaces, check each one if it's in the default VRF, and
> if so send the matching flush/show message.
> 
> This patch adds the ability to do so easily, by passing a dummy value as
> the 'NDA_MASTER' ('NDV_NOT_L3_SLAVE').
> Note that 'NDV_NOT_L3_SLAVE' is a negative number, meaning it is not a valid
> ifindex, so it doesn't break existing programs.
> 
> I have a patch for iproute2 ready for adding this support in userspace.
> 
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: David Ahern <dsahern@kernel.org>
> ---
>  include/uapi/linux/neighbour.h | 2 ++
>  net/core/neighbour.c           | 3 +++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> index dc8b72201f6c..d4f4c2189c63 100644
> --- a/include/uapi/linux/neighbour.h
> +++ b/include/uapi/linux/neighbour.h
> @@ -196,4 +196,6 @@ enum {
>  };
>  #define NFEA_MAX (__NFEA_MAX - 1)
>  
> +#define NDV_NOT_L3_SLAVE	(-10)
> +
>  #endif
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 53e85c70c6e5..b280103b6806 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -2529,6 +2529,9 @@ static bool neigh_master_filtered(struct net_device *dev, int master_idx)
>  {
>  	struct net_device *master;
>  
> +	if (master_idx == NDV_NOT_L3_SLAVE)
> +		return netif_is_l3_slave(dev);
> +
>  	if (!master_idx)
>  		return false;
>  
> 

you can not special case VRFs like this, and such a feature should apply
to links and addresses as well.

One idea is to pass "*_MASTER" as -1 (use "none" keyword for iproute2)
and then update kernel side to only return entries if the corresponding
device is not enslaved to another device. Unfortunately since I did not
check that _MASTER was non-zero in the current code, we can not use 0 as
a valid flag for "not enslaved". Be sure to document why -1 is used.
