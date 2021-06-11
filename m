Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB483A4678
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhFKQbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:31:07 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:42595 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhFKQbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 12:31:06 -0400
Received: by mail-pg1-f170.google.com with SMTP id i34so2878717pgl.9
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 09:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=fez0CCUpwnetBZSJofvOZuZwl38w1gmL2dWjIfz7bU0=;
        b=vd0v4uiUq+f5Pmp/yJuAqj4M2FL1Nrl2slnn728mst/xrxdvpDIZCVdMOUXo7zqMLr
         NGvPnY8G74BuC4Rqcg88VYECzjQH6M8NwRxpon3BEa7+k8n/pN5Gongt+ZO9tSlpLqY8
         slpJp+Px7ZJSDC1mnrb+LGvRZA8MtAxrbkJr+paGD+zRoR0JZPHSCHpWUMtTdTD9z0dH
         guX1WWNMwlbxU2CzdmgLz/doMisxs1zhYy3eUVj2tE8yI7aZiHo31Or659zGur5xk5Cq
         cKwE6sbSsFpww+VGmlL9YoAnVZl/oR/LlTu8MY3s38uszuDlLBXoBCo2QKcov6EU0nxw
         FrbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fez0CCUpwnetBZSJofvOZuZwl38w1gmL2dWjIfz7bU0=;
        b=oJ1W7Q+mqUg6YCtpzXPPOjFt5Le9X5KczN4YPjjoEWcmcAOvLtTg8zdSoKnGiitEMG
         fkgddCPz6LqAE54NakLb5jMHatIpA2pDe1FugSWSBfzwZ8tlCjuLvp9TyXCbbistXo0k
         4FHf4TH/YjL2klkJW83jwvg6GuqTMYmXaA6Ii877BJqcFIwQvHqD3Olsqad8JtZT7/+f
         d9Y46Ai3P2bMoD1U5tjnejG843MnULHqHPQWG65UMlW2jQ7dlBn4QXStFO3Oysazsh4a
         7kradUHbK7bO9eqZyHcttzFD4MZCHUISLwNgNA7QyBk5ERTxe0DLWFRMyFkU/kUsQgIP
         Loew==
X-Gm-Message-State: AOAM530rpGFA2EF8tArQNVTDoVAjGtQ2+VmfoEPjUCiY5LX6z4zj5kAg
        xc0nl90ZddEvzhLtm+vCTI904zdw60Kk3g==
X-Google-Smtp-Source: ABdhPJwWU+6Bre9E8ug2hYT+mm3aEcBsK3peh88xzWBR35rMJZFgQlAhJ2HPPRHhGOvOPPOj+yInZg==
X-Received: by 2002:a63:5760:: with SMTP id h32mr4416232pgm.367.1623428886902;
        Fri, 11 Jun 2021 09:28:06 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id gl13sm2243196pjb.5.2021.06.11.09.28.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 09:28:06 -0700 (PDT)
Subject: Re: [PATCH net-next] ibmvnic: fix kernel build warning in strncpy
To:     Lijun Pan <lijunp213@gmail.com>, netdev@vger.kernel.org
References: <20210611160529.88936-1-lijunp213@gmail.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <e53a2d46-fd6d-d0cc-8b78-205c5bd6784b@pensando.io>
Date:   Fri, 11 Jun 2021 09:28:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210611160529.88936-1-lijunp213@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/11/21 9:05 AM, Lijun Pan wrote:
> drivers/net/ethernet/ibm/ibmvnic.c: In function ‘handle_vpd_rsp’:
> drivers/net/ethernet/ibm/ibmvnic.c:4393:3: warning: ‘strncpy’ output truncated before terminating nul copying 3 bytes from a string of the same length [-Wstringop-truncation]
>   4393 |   strncpy((char *)adapter->fw_version, "N/A", 3 * sizeof(char));
>        |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Signed-off-by: Lijun Pan <lijunp213@gmail.com>
> ---
>   drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 497f1a7da70b..2675b2301ed7 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -4390,7 +4390,7 @@ static void handle_vpd_rsp(union ibmvnic_crq *crq,
>   
>   complete:
>   	if (adapter->fw_version[0] == '\0')
> -		strncpy((char *)adapter->fw_version, "N/A", 3 * sizeof(char));
> +		memcpy((char *)adapter->fw_version, "N/A", 3 * sizeof(char));
>   	complete(&adapter->fw_done);
>   }
>   

This doesn't fix the real problem.  The error message is saying that 
there is no string terminating '\0' byte getting set after the "N/A" 
string, meaning that there could be garbage in the buffer after the 
string that could allow for surprising and bad things to happen when 
that string is used later, including buffer overruns that can cause 
stack smash or other memory munging.

Better would be to use strlcpy() with a limiter of 
sizeof(adapter->fw_version).

sln
