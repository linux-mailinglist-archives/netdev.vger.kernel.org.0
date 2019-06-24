Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7667950C1E
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbfFXNgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:36:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44781 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729423AbfFXNgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:36:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id r16so13921881wrl.11
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 06:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aIXChZl47hIpdRUJyVwNJXqgSFVkN9Mais0wimBMIoI=;
        b=IDWKSiJLVD6dW2x4RgLHeadU+nbRMawKI2GudFSngdVGqx07XZHvN9L78QgkmxAHZP
         y78b3cyljB+zQ9g4Esgmg/kOn2V2bwVd9SjY8EVXE4shrZ4DAHSXZLsG4PIHIIjuwC3P
         WRiCp4PgFlwBGlsEoq4tjwUrELgRALGFW/MMWDvz1ft/YttIQELjEEJjl9eDVr7zH8pr
         hx9PPlkDexXeXlQ2e7RJKOyvXbBuXslNVIFgQ7AczLTEgJqs9DvNBuYw/b24xSxiG1XW
         qU05x2UofrmUjborAGI60MqPRN9MJ8tBmNo89YiPDp5VTrZtL68lIkggbVq7yvkja6sa
         X58Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aIXChZl47hIpdRUJyVwNJXqgSFVkN9Mais0wimBMIoI=;
        b=NIqVTp5wOHLU/Rhbk1vSkrGr8Fpe06jI57YAW7ZcKFIem9rDvqHXBHtUKNkpSEyW5v
         5UCMY6kM5W7C3/ub1rPWM7ZtmcQEIwvjqEuslmV/5Y1z/LcgKxb35xExsLdWSmjtUrr4
         XYxwsWgSkSeL7qVMhPGVJFBhE4rHWjfdx3ZjgmJu7jI7WJxgBqOEjP3lJCeJNusqxx+9
         j8cbzFLDYvwQvGdeZGOnJemJ6EsrMfYNcmMXuq2w9Ypc4aILW4kzH1YFnx6LKXFxF+Q3
         z3zhUi/4kO7FYEw6UGPmjBVqvEU/Brcw/1tMWZfjMUhMhRV87YkOsmMjz80he5bKPKmu
         tb6g==
X-Gm-Message-State: APjAAAXRojaSxKToIBl1W/RdckQImrY3xDIdmC/kaqv62ffKmRW8qdrl
        NlT/Y8BCW1/JYBDGs309F/cjHUuiMj4=
X-Google-Smtp-Source: APXvYqxAnLgc/d+Kt5NAB/DrgT3GdBAXLIDHhlNbkbQ1fgSYLLjKO/IDkT0T9HipgAN+M0ssmD2wrw==
X-Received: by 2002:adf:fbc7:: with SMTP id d7mr3420978wrs.224.1561383408142;
        Mon, 24 Jun 2019 06:36:48 -0700 (PDT)
Received: from [10.8.2.125] ([193.47.165.251])
        by smtp.googlemail.com with ESMTPSA id x3sm11121008wrp.78.2019.06.24.06.36.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 06:36:47 -0700 (PDT)
Subject: Re: [PATCH rdma-next v1 09/12] IB/mlx5: Register DEVX with mlx5_core
 to get async events
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-10-leon@kernel.org>
 <20190624115206.GB5479@mellanox.com>
From:   Yishai Hadas <yishaih@dev.mellanox.co.il>
Message-ID: <3bc6780f-5c3e-b121-e4ea-f7b8f00cbd13@dev.mellanox.co.il>
Date:   Mon, 24 Jun 2019 16:36:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190624115206.GB5479@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/2019 2:52 PM, Jason Gunthorpe wrote:
> On Tue, Jun 18, 2019 at 08:15:37PM +0300, Leon Romanovsky wrote:
>>   void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
>> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
>> index 9cf23ae6324e..556af34b788b 100644
>> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
>> @@ -944,6 +944,13 @@ struct mlx5_ib_pf_eq {
>>   	mempool_t *pool;
>>   };
>>   
>> +struct mlx5_devx_event_table {
>> +	struct mlx5_nb devx_nb;
>> +	/* serialize updating the event_xa */
>> +	struct mutex event_xa_lock;
>> +	struct xarray event_xa;
>> +};
>> +
>>   struct mlx5_ib_dev {
>>   	struct ib_device		ib_dev;
>>   	struct mlx5_core_dev		*mdev;
>> @@ -994,6 +1001,7 @@ struct mlx5_ib_dev {
>>   	struct mlx5_srq_table   srq_table;
>>   	struct mlx5_async_ctx   async_ctx;
>>   	int			free_port;
>> +	struct mlx5_devx_event_table devx_event_table;
> 
> I really question if adding all these structs really does anything for
> readability..
> 

I would prefer this option to add only one structure (i.e. 
mlx5_devx_event_table) on ib_dev, it will hold internally the other 
related stuff.
