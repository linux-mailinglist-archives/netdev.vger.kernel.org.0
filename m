Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0E94CFF8F
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 14:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242749AbiCGNGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 08:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239265AbiCGNGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 08:06:49 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFFB8BE07
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 05:05:53 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id p15so31776669ejc.7
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 05:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oJZ1SPT2kgh+PEF4SSmF0bhEMGeNdgK/Ma7AdkdDay0=;
        b=y0Wti9sNHXVjvW29jtsFzij0PEwo2U1V38kWV5YPmgFL8R6ojcyeXztb6Cc8hUvazd
         TUnM4ctS9McjJ4AR64IY+T25G6CohdYGtiJeCag+6cEJD0QMiAq+UZGXNfAHun3XQldC
         DLz5UP918GxvL0ntgTXoAErB/4OkLXtS7igaqsNkGAw/uKXrm3WWRMe2BWpEzOUfqoYo
         LjPdBP2amkV8gcTKH1tQxgOpaC47vsMQhcWVmiRpwOwZKn7w4rqpT9me8WtnFyQawxD7
         P+Ch16mywUcnI90PYY6vkrDiTA9/BTpbNSblN03CNzYrpftNW/Qd/m92EqKWj5RaeCzb
         VQoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oJZ1SPT2kgh+PEF4SSmF0bhEMGeNdgK/Ma7AdkdDay0=;
        b=KDHkNGMHmygNQjljnx9u8xnFp3hqlVaF1P4ZTrReeFP34V13/pcyIdvVaV4fNZgpVE
         cdRWfO/FQ/OCDH54t4Fdk0g5IpeEj7jEIm9aluFiki1tDH71c1gIqmugnkmM5Y5iobAY
         dlJ6Ap5/sNnQKSAPUcBhvvQzZW1bdyJYzxE7P+QI6gl0Wwm9/NrFBe9kMxQUwAEHoFBD
         qW31kuo+sE3ltbmoIz7R8xTwBB51k2wcN9eUCBh5BxCsRB/6vkrz/x4ngsbEulboyKkC
         V3z374g4Jizwcc5KJTkDJD5PeM4xqe9U7GJ5N4rZuQpoeKqn7GhelVYQpifPIxPU7wIr
         vGFA==
X-Gm-Message-State: AOAM5337UCCntyGCyutkLIPvJ3E/84mbfXoINumTuOv7gNoL373lMVlz
        KS2SWc2VJmB1u4KUghQKGBRLIw==
X-Google-Smtp-Source: ABdhPJzz0pnCBhgBA4dZwC+smiLcSTGiSv4+0dd0Su/I9MmdvkUondJG99DluOMyYWt3OdhTa8ZTpw==
X-Received: by 2002:a17:906:7f02:b0:6cf:86d8:c31c with SMTP id d2-20020a1709067f0200b006cf86d8c31cmr9321312ejr.518.1646658352212;
        Mon, 07 Mar 2022 05:05:52 -0800 (PST)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id n25-20020aa7db59000000b00415965e9727sm6087805edt.18.2022.03.07.05.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 05:05:51 -0800 (PST)
Message-ID: <c568979a-d3da-c577-840f-ca6689f7400f@blackwall.org>
Date:   Mon, 7 Mar 2022 15:05:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] vxlan_core: delete unnecessary condition
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Roopa Prabhu <roopa@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20220307125735.GC16710@kili>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220307125735.GC16710@kili>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/03/2022 14:57, Dan Carpenter wrote:
> The previous check handled the "if (!nh)" condition so we know "nh"
> is non-NULL here.  Delete the check and pull the code in one tab.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This not a bug so a Fixes tag is innappropriate, however for reviewers
> this was introduced in commit 4095e0e1328a ("drivers: vxlan: vnifilter:
> per vni stats")

No, it was not introduced by that commit.
It was introduced by commit:
 1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")

> ---
>  drivers/net/vxlan/vxlan_core.c | 54 ++++++++++++++++------------------
>  1 file changed, 26 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
> index 4ab09dd5a32a..795f438940ee 100644
> --- a/drivers/net/vxlan/vxlan_core.c
> +++ b/drivers/net/vxlan/vxlan_core.c
> @@ -811,37 +811,35 @@ static int vxlan_fdb_nh_update(struct vxlan_dev *vxlan, struct vxlan_fdb *fdb,
>  		goto err_inval;
>  	}
>  
> -	if (nh) {
> -		if (!nexthop_get(nh)) {
> -			NL_SET_ERR_MSG(extack, "Nexthop has been deleted");
> -			nh = NULL;
> -			goto err_inval;
> -		}
> -		if (!nexthop_is_fdb(nh)) {
> -			NL_SET_ERR_MSG(extack, "Nexthop is not a fdb nexthop");
> -			goto err_inval;
> -		}
> +	if (!nexthop_get(nh)) {
> +		NL_SET_ERR_MSG(extack, "Nexthop has been deleted");
> +		nh = NULL;
> +		goto err_inval;
> +	}
> +	if (!nexthop_is_fdb(nh)) {
> +		NL_SET_ERR_MSG(extack, "Nexthop is not a fdb nexthop");
> +		goto err_inval;
> +	}
>  
> -		if (!nexthop_is_multipath(nh)) {
> -			NL_SET_ERR_MSG(extack, "Nexthop is not a multipath group");
> +	if (!nexthop_is_multipath(nh)) {
> +		NL_SET_ERR_MSG(extack, "Nexthop is not a multipath group");
> +		goto err_inval;
> +	}
> +
> +	/* check nexthop group family */
> +	switch (vxlan->default_dst.remote_ip.sa.sa_family) {
> +	case AF_INET:
> +		if (!nexthop_has_v4(nh)) {
> +			err = -EAFNOSUPPORT;
> +			NL_SET_ERR_MSG(extack, "Nexthop group family not supported");
>  			goto err_inval;
>  		}
> -
> -		/* check nexthop group family */
> -		switch (vxlan->default_dst.remote_ip.sa.sa_family) {
> -		case AF_INET:
> -			if (!nexthop_has_v4(nh)) {
> -				err = -EAFNOSUPPORT;
> -				NL_SET_ERR_MSG(extack, "Nexthop group family not supported");
> -				goto err_inval;
> -			}
> -			break;
> -		case AF_INET6:
> -			if (nexthop_has_v4(nh)) {
> -				err = -EAFNOSUPPORT;
> -				NL_SET_ERR_MSG(extack, "Nexthop group family not supported");
> -				goto err_inval;
> -			}
> +		break;
> +	case AF_INET6:
> +		if (nexthop_has_v4(nh)) {
> +			err = -EAFNOSUPPORT;
> +			NL_SET_ERR_MSG(extack, "Nexthop group family not supported");
> +			goto err_inval;
>  		}
>  	}
>  

