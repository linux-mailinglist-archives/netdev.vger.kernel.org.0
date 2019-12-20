Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C44ED127F60
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbfLTPdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:33:40 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34088 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbfLTPdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:33:40 -0500
Received: by mail-wr1-f68.google.com with SMTP id t2so9838676wrr.1
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 07:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j/myDvMwGwJOGxixav8OHdGy9sFqAX9GPJEQWHZcFvo=;
        b=f87xbHzzkG0g/QpZusV3nlCaE0zO9n3zAY5M1LIEqQkBTq1ftJJE3NqJKjSiyAn0E0
         irYlk6X/QZtg+yco3zQp04ySOuI4vqsrdtO2iLHFr0mokjueWiXfSpGsm25Iu7Lyekyl
         rRBSqsqkqojzROqAiLZQB+NjNydsuToclRHGoDJDa2lcxQJGP74caw1oTzonU/rdJVIz
         Uw7uSH2ZHiAA3PBJbKF2nqSQx018aFpm3D8s+T4W/g9JR0R5G0tKN9JsIIHA5H3eGtwi
         zx0KO+wULrgOQdw1m8ftonxWi/rwpIILRYMT6yFta/3G5okHlhgSTx5k8WWP12me8mb1
         36mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j/myDvMwGwJOGxixav8OHdGy9sFqAX9GPJEQWHZcFvo=;
        b=CtcMSIWwNXW4c7KQbBi4mSXli3D9Ctr9ANxQ/vcnPgLOnTC49I/nOGRSVz2ZRO0LiA
         yFewYPdxnjRtsW6Th9VS3T15QglXuP/NMQCKXfplFhsZrFWx816rIY55gA8Tp9PK1YZ3
         RpP/wSPeOK37nNKcPY1HVa2fovv75Zq22wWJUKBEH5lVvpurYIVot6r5QF/mpOMkZszJ
         60+5ycKo93m9RVtdXdGG7YgbO/15qieTzy7qtnsY5XY+8nvKx4RZEjSRYia1M9MLnW7a
         2Wsk6Sr+oEczc9QET4dCdndDTWdQlOvkIbLl5GY5SmyA7AE5D1g11m/3Js1Pcax7+qAC
         xRLQ==
X-Gm-Message-State: APjAAAU8lkgbhY3MrTZyZoaI7l/nxy0aVdQbIeuAmB9xnJGbU3mnyEJF
        +P9AtEaj4pYF4k4iXrZLr9NZIuRk
X-Google-Smtp-Source: APXvYqw0mbW2SlZ8iHXUN6QEZ9IrXJKvfRPFvfLBblVPCKYG7kODIBYyuJIAK4C8abZeolPXbXhPyg==
X-Received: by 2002:adf:ebc3:: with SMTP id v3mr15783886wrn.280.1576856018593;
        Fri, 20 Dec 2019 07:33:38 -0800 (PST)
Received: from [192.168.8.147] (72.173.185.81.rev.sfr.net. [81.185.173.72])
        by smtp.gmail.com with ESMTPSA id g199sm10828478wmg.12.2019.12.20.07.33.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 07:33:38 -0800 (PST)
Subject: Re: [PATCH net-next v5 06/11] mptcp: Add MPTCP to skb extensions
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>
References: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com>
 <20191219223434.19722-7-mathew.j.martineau@linux.intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <eb8a3c9d-4234-1f3a-27f9-3c65fd4496b5@gmail.com>
Date:   Fri, 20 Dec 2019 07:33:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191219223434.19722-7-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/19/19 2:34 PM, Mat Martineau wrote:
> Add enum value for MPTCP and update config dependencies
> 
> Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

...

> +/* MPTCP sk_buff extension data */
> +struct mptcp_ext {
> +	u64		data_ack;
> +	u64		data_seq;
> +	u32		subflow_seq;
> +	u16		data_len;
> +	u8		use_map:1,
> +			dsn64:1,
> +			data_fin:1,
> +			use_ack:1,
> +			ack64:1,
> +			__unused:2;
	__unused:3; 

Also worth noting there is one byte hole in this structure.

> +};
> +
