Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C7C442FF2
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 15:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhKBOPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 10:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbhKBOPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 10:15:00 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70855C0613F5;
        Tue,  2 Nov 2021 07:12:25 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id p17so654393pgj.2;
        Tue, 02 Nov 2021 07:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O4WFsXzMqjFJjODjVmvQJrTg2heM7mzhLnJLW/+wWv0=;
        b=bq9os5g7vQy10HyDqcY/e/+KxnUSeXtPmPXlCqD9z3fO+MGXLHP56v5izFiAmK5T+X
         ylCX4MUmSw5Xos9wn0fKQT5/UT8Cxrxc5vER+3t2BeeBRP5ELs1C7l7g507hJ1zr0trl
         IEMpa6lNvfB9+sYfbEVhWDUiXg/dfaTXkL1EJK7iA5Jhhqqz2lPdslX129P3T4OiWANK
         TFb9I3e+4J/Aj5XFpHwH2imU+oUTlTe+zbkw9wwSBvY6wqzTITUKeTUwR1czMYqGfrUr
         3+CL218D5e+lklyAze5WKrPqbl4Pyc87xX24Q4sxnpo41CLks/wjXcQCHTSqiGpzVj4P
         Atng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O4WFsXzMqjFJjODjVmvQJrTg2heM7mzhLnJLW/+wWv0=;
        b=hLvUSbuKF7OVMZo/lIx9l5RkdK1a4XoD3r7OqLxPDQ60yRRsPggLEPZRErHVPrgRKO
         Mn3x4n+y6pigklDm4cPry1O6/skUOgV7h2kvkZhqzxBuv8p5QXMPJyD1UFF1iv//xLNp
         BX92Aolt0GriIUtnR1KWQWbKsIA4Jr5O2SclJhpujdRdvuuSIIyl71uQ74VsNK6G1NdB
         Loab+lchq9uhg7rA+hTFPEkKxZiNy7/SGwJI5B6/05ixZkIDb1FNV0nez0dXD52iQGOt
         ndbPY3/M7GyZbUTU1SFqruF3dJzf3y3OgXdMd7EjBP+MANIBbnCrim92D0GueE2X8u5Z
         Ou5w==
X-Gm-Message-State: AOAM531CiGrFDRNhBFxrKFOfjzhPY9iyehDGra8L3G27S88AEe0d3buJ
        T8rWJY+jdJus8JfJQjmgB98=
X-Google-Smtp-Source: ABdhPJzRu8XbOYPiETj7ZurwK/CASyVTWX2iCdZggXs+Zr+xHgkgm1dH+hT3GbjFp2nkNsXFRGpcNQ==
X-Received: by 2002:a62:e406:0:b0:480:fd90:1082 with SMTP id r6-20020a62e406000000b00480fd901082mr17971148pfh.45.1635862344897;
        Tue, 02 Nov 2021 07:12:24 -0700 (PDT)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id d6sm18672646pfa.39.2021.11.02.07.12.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 07:12:24 -0700 (PDT)
Subject: Re: [PATCH net-next] amt: fix error return code in amt_init()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net
References: <20211102130353.1666999-1-yangyingliang@huawei.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <cf76ccea-5678-4ed4-7bda-d9a522f31d61@gmail.com>
Date:   Tue, 2 Nov 2021 23:12:21 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211102130353.1666999-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yang,

On 11/2/21 10:03 PM, Yang Yingliang wrote:
> Return error code when alloc_workqueue()
> fails in amt_init().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>   drivers/net/amt.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/amt.c b/drivers/net/amt.c
> index 60a7053a9cf7..d8c9ed9f8a81 100644
> --- a/drivers/net/amt.c
> +++ b/drivers/net/amt.c
> @@ -3259,8 +3259,10 @@ static int __init amt_init(void)
>   		goto unregister_notifier;
>   
>   	amt_wq = alloc_workqueue("amt", WQ_UNBOUND, 1);
> -	if (!amt_wq)
> +	if (!amt_wq) {
> +		err = -ENOMEM;
>   		goto rtnl_unregister;
> +	}
>   
>   	spin_lock_init(&source_gc_lock);
>   	spin_lock_bh(&source_gc_lock);
> 

Reviewed-by: Taehee Yoo <ap420073@gmail.com>
