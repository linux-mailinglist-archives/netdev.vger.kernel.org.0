Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F9A6B93FA
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjCNMhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCNMhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:37:03 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9550720A2A
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:36:36 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso13047970wmq.1
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678797330;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p84TLvp+HdQDxexv0ZVgLjFCMe9ll2v7yG7+lC1ClDs=;
        b=Mld9CHmB4FHTzkBAeS0Rb14jtQAWfKlcWa1tq0b3sPZ80TE2e0u/zDdJr1uYgJsYu5
         m42BB9k5pGSnurOlsoN5ACj9DT+SZs4Gy7nlcAX0Bvfh/TIGqkkDKA+CW775OlHUF1BY
         7E0+vEXZiVDJEs8ZuGxv9QwcwZCoYYoMo3UFmz8VSaiZgMfZbtgQ8+sHsY+Yy1fb5E0s
         M3Xo29UGyw1SSxVIH17lg4HsIbDef2pkRMkHD7EP+W++6Edj+ycq3mMIJ+mgCP1Ne86k
         yDrBDrkYVbocUKJfvKYD7vFZl4K4JgSb6vX/pupmNdSU0JHx0Fx+vAH0k2tF1HQ/3F0n
         6vGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678797330;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p84TLvp+HdQDxexv0ZVgLjFCMe9ll2v7yG7+lC1ClDs=;
        b=gVxqWt+ASsUuM3XEsnvY/gVFkuYqE2WdisEUnp8GSYLXwGN+sz35XzGFMLveELo4mP
         FjuQjtL11e9xpaGEVM0+skKHtjaXALSXfz3fQaeBgnJVPCuSxFTdYe1E+DC0Zqm4XwcI
         hT6MOnfNL+P4nZ8cD0OztBMdnxqMpGR1K5JkxVcrHJZ5kuxRS2Q2uG6LgYn0/43FZKuZ
         sklp3OO/g38nyNVDqEuYw9/O9cyxMwaZqupUWR0O8R0XRJj98cQs6FFi4gZdYjUFY2Aw
         zgjuCZgoE/uEaIzUg+4qwITpJbWmEpdef2HFPKyJwW+mmj7rEpSCX3HE7Btx8M3jF79+
         6v/Q==
X-Gm-Message-State: AO0yUKXyQK+aFc7x236weGIcg7bx8gXizyV75KVUlDALDy3HHm2+I4iY
        n7x/wy33+SOMj33on66uXp4uSVsQVQ+FVtU9aFheOA==
X-Google-Smtp-Source: AK7set9SEJBVMu/4jgX0Tq5pWXfXaPcangezvpLj6M40QeGTXvm8Jl+5woVo+iRDTQfXr4I6JXcA1A==
X-Received: by 2002:a05:600c:314c:b0:3eb:2f06:c989 with SMTP id h12-20020a05600c314c00b003eb2f06c989mr14509179wmo.22.1678797330012;
        Tue, 14 Mar 2023 05:35:30 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id s7-20020a7bc387000000b003e7f1086660sm2773592wmj.15.2023.03.14.05.35.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 05:35:29 -0700 (PDT)
Message-ID: <ce921c1d-2acf-6e67-8bf3-3d5a133c15b9@blackwall.org>
Date:   Tue, 14 Mar 2023 14:35:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 10/11] vxlan: Enable MDB support
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230313145349.3557231-1-idosch@nvidia.com>
 <20230313145349.3557231-11-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230313145349.3557231-11-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2023 16:53, Ido Schimmel wrote:
> Now that the VXLAN MDB control and data paths are in place we can expose
> the VXLAN MDB functionality to user space.
> 
> Set the VXLAN MDB net device operations to the appropriate functions,
> thereby allowing the rtnetlink code to reach the VXLAN driver.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  drivers/net/vxlan/vxlan_core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
> index 1e55c5582e67..e473200b731f 100644
> --- a/drivers/net/vxlan/vxlan_core.c
> +++ b/drivers/net/vxlan/vxlan_core.c
> @@ -3083,6 +3083,9 @@ static const struct net_device_ops vxlan_netdev_ether_ops = {
>  	.ndo_fdb_del		= vxlan_fdb_delete,
>  	.ndo_fdb_dump		= vxlan_fdb_dump,
>  	.ndo_fdb_get		= vxlan_fdb_get,
> +	.ndo_mdb_add		= vxlan_mdb_add,
> +	.ndo_mdb_del		= vxlan_mdb_del,
> +	.ndo_mdb_dump		= vxlan_mdb_dump,
>  	.ndo_fill_metadata_dst	= vxlan_fill_metadata_dst,
>  };
>  

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

