Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB364EDE7E
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239706AbiCaQQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239707AbiCaQQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:16:38 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F3855201
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 09:14:50 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id h19so57933pfv.1
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 09:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nzdRKNhSadAGU2/1+9CJCIsH9iz4xNg93BLTCvdABBQ=;
        b=kwvMVzfuXIcvvzsQ/j5YgQYI3vhnY5RbNuMVIycbxZO4sjXpzZJouBZuCvbw4DeauP
         K7Q5Aqxhf1nkdiGW4OKzEmdc6mjnqw9vNNc9z1wnxpGnRMbC6BkFvRSwC7bM203EX+Oj
         Q0Nr/zawkq2K+Ido40uBOgDhiPJRfoukYC1EHWwPTXOFg1o7dHzYJBbpp5B3RhqBd8LS
         yC+P5kAlRxsAWWCN4qfzD7OnSa/V1o3zhQ5KciZnlXMp5LuD+VRML3bul4UH20JxzSnq
         CvhVLb1Z2jfAlNt4eStGNyG38Q3m76jUjBgkphuY/5mZOOVKTp2RAVw3Wx1kMUfF6h/Z
         d0ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nzdRKNhSadAGU2/1+9CJCIsH9iz4xNg93BLTCvdABBQ=;
        b=wskJBROq1o6qyhMEpNIWV9yAi+FjaFnb0gEN7BE+tSjwrcTcGCA4b6en6ez8KnyhmS
         /6qnRM6+BJdnXae/szZHO/EOS/G6swxZqSwOT2jpnviq6ZqDC/W5V8XFD+IxQvO305FY
         2zN1lrc4RQbGrU9EGCPeSYWEubWNSdDesu5j85CyQiANLYaw64NVLWextw3wxSSpKJx5
         JzQ8lp1Pgao0h07oAufA7SpNAGMnVKrj7wZhcsEYA6DNlCpCJ26VEjhobI4DdPOasM2L
         GtTdg0qBPjuCgOILOiWSJlFPM/zd/9/RaHSAuEUt2Oxun9KsD6hJ8wQmCkGp5SW8DtTN
         M/Mg==
X-Gm-Message-State: AOAM531kyS6ck5gDJ6xw8nPCO0TBVajBL/IgjhK4vNJnEgfwOI8pBnH9
        76uzYo8hzaSn1ml6noESoTauUA==
X-Google-Smtp-Source: ABdhPJyNOuupobAksijWayq6Ffs/N+B1zxVK8M2fdvImwOFpb2TCmYL3X8fCPVrhWr8LX0wNMT9cNw==
X-Received: by 2002:a05:6a00:440c:b0:4fa:da3f:251c with SMTP id br12-20020a056a00440c00b004fada3f251cmr6303682pfb.73.1648743290114;
        Thu, 31 Mar 2022 09:14:50 -0700 (PDT)
Received: from [192.168.0.2] ([50.53.169.105])
        by smtp.gmail.com with ESMTPSA id 124-20020a621682000000b004f6a2e59a4dsm27306697pfw.121.2022.03.31.09.14.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 09:14:49 -0700 (PDT)
Message-ID: <b498023a-08d8-eda6-abfc-4339fe82522a@pensando.io>
Date:   Thu, 31 Mar 2022 09:14:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net v1] ixgbe: ensure IPsec VF<->PF compatibility
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Shannon Nelson <shannon.nelson@oracle.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
References: <737616899df2a482e4ec35aa4056c9ac608d2f50.1648714609.git.leonro@nvidia.com>
From:   Shannon Nelson <snelson@pensando.io>
In-Reply-To: <737616899df2a482e4ec35aa4056c9ac608d2f50.1648714609.git.leonro@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/22 1:20 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>
> The VF driver can forward any IPsec flags and such makes the function
> is not extendable and prone to backward/forward incompatibility.
>
> If new software runs on VF, it won't know that PF configured something
> completely different as it "knows" only XFRM_OFFLOAD_INBOUND flag.
>
> Fixes: eda0333ac293 ("ixgbe: add VF IPsec management")
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>a


Thanks!

Reviewed-by: Shannon Nelson <snelson@pensando.io>


> ---
> Chaagelog:
> v1:
>   * Replaced bits arithmetic with more simple expression
> v0: https://lore.kernel.org/all/3702fad8a016170947da5f3c521a9251cf0f4a22.1648637865.git.leonro@nvidia.com
> ---
>   drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> index e596e1a9fc75..69d11ff7677d 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> @@ -903,7 +903,8 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
>   	/* Tx IPsec offload doesn't seem to work on this
>   	 * device, so block these requests for now.
>   	 */
> -	if (!(sam->flags & XFRM_OFFLOAD_INBOUND)) {
> +	sam->flags = sam->flags & ~XFRM_OFFLOAD_IPV6;
> +	if (sam->flags != XFRM_OFFLOAD_INBOUND) {
>   		err = -EOPNOTSUPP;
>   		goto err_out;
>   	}

