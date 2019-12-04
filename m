Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC24112ECB
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 16:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbfLDPn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 10:43:27 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46417 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbfLDPn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 10:43:26 -0500
Received: by mail-lf1-f68.google.com with SMTP id a17so6454409lfi.13
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 07:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h3fWfve+7iiO/k2gD5tLBOwnqQP7vRBs+uTKm17AXd8=;
        b=U0xYfjkXSgUf7CVdSOs69f3snS21BWC0S3ZdIGYn6jl0qZ5+T+JmLQ+Ed6WKLVHiV5
         ZvM5Rgd1kpigIXF/o4mYxuMpzx0AWPf4GCUgx5pRbHeRbPzodLrTSgomOvG/V8C2/HJr
         R1hG/vJaghlp+Fc/jhcuqKSJ76p1hW9P6lG3zSOSO7lDOZ/7pGwWqGFChhX7Ekm+oi8z
         146SdCi5pf2L0gIk4mNqF0asadMKfJYqdA/5qf+z0HPKsCtSamNBeaUMhuX3uBzb9EZV
         DHNxk2nkfbQSpBL22D8lFltQIijekLAVjA2CtSg1xdz2thjnFbGPIxCftzymj+Jg0EVw
         /FCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=h3fWfve+7iiO/k2gD5tLBOwnqQP7vRBs+uTKm17AXd8=;
        b=ufw5PLSxZgkXbJQurFd1bgS8DhghBBEhq8cGMAm26ZtYINMnJmXr5MJKuihAs2cUr4
         XpnLJzaCqxMCglyIXVruXBpnLUw98QQ82/81GGBPU0SUHbUQgtCAPi0y66AEeFwXqu/n
         YuCerXMeou/MIbO2KFEZ6vx0kLENSzYDIo3Pi+dJRP0aJFGhYBAThj1+hBPz+Uf7n5av
         r31hwlyFbwxolSNrlZhO1psKwjadZzEbKuNQs04amzDJuSCDs9Vxs+j/JoRxWk9JIDKI
         DD1kbff9VQbadxMa1IXkpLTg57YyumaL7OopFEqun2dKEo1IFP4r68YN8UfhlQyM49CB
         q60g==
X-Gm-Message-State: APjAAAXMDuwycNYEVkDHADY9TanMn9oSJbRfYtmkgNq79f6lYSrmyk0U
        O3yAVG1KTdg/aI1pXjdNFqfyeA==
X-Google-Smtp-Source: APXvYqwjLxbNhdQWOhrtHPhQZJrv0UeEzS/B4sPzddhxzUAynukLpf3QoCNLVUS2l2EO+Rg7JgP8Sg==
X-Received: by 2002:ac2:508f:: with SMTP id f15mr2382528lfm.146.1575474204897;
        Wed, 04 Dec 2019 07:43:24 -0800 (PST)
Received: from wasted.cogentembedded.com ([2a00:1fa0:6e8:b572:763a:52df:7394:14f7])
        by smtp.gmail.com with ESMTPSA id v28sm3446675lfd.93.2019.12.04.07.43.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Dec 2019 07:43:24 -0800 (PST)
Subject: Re: [PATCH] net: thunderx: start phy before starting autonegotiation
To:     Mian Yousaf Kaukab <ykaukab@suse.de>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tharvey@gateworks.com, davem@davemloft.net, rric@kernel.org,
        sgoutham@cavium.com
References: <20191204152651.13418-1-ykaukab@suse.de>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <1df5cd0b-3597-4800-a48d-de88c6792e75@cogentembedded.com>
Date:   Wed, 4 Dec 2019 18:43:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20191204152651.13418-1-ykaukab@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/04/2019 06:26 PM, Mian Yousaf Kaukab wrote:

> Since "2b3e88ea6528 net: phy: improve phy state checking"

   Since 2b3e88ea6528 ("net: phy: improve phy state checking")

> phy_start_aneg() expects phy state to be >= PHY_UP. Call phy_start()
> before calling phy_start_aneg() during probe so that autonegotiation
> is initiated.
> 
> Network fails without this patch on Octeon TX.
> 
> Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>
[...]

MBR, Sergei
