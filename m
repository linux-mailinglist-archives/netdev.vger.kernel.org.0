Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86701DB43F
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 14:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgETM4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 08:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgETM4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 08:56:14 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FC5C061A0F
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 05:56:14 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id dh1so1204828qvb.13
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 05:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IokNJFjTtmaZ7K4MBG6Rh51PQnmU94xpcqHKEHyK7kM=;
        b=mdHLn9n+V4RPq21TRcXf4ZofynyeTmnT/OpQcmKgeAZVz946tjFqzIpvVKQxVONELN
         yJPRGKT3YYrLMTsyGzplqFOzZ9CVuPNmcjVmcV+P17r1jbfZdCNnMN9pDAjp/g0ltBH3
         yCBT+6Hu9dddScgJACDEk6PSvVovTpeH2KMg9suiDk6dpTLhkzFrPXgaDgA1MmvA+Wbg
         c+KL1WEjMPAazQ1B0Poj5pi6Q0w6JFVNU1bD0pnax2J+kqa3nPDrhXKD1pcPm943lFYQ
         A5xVWdlEvC/XgLE9wsnTu0xYt8GCxwP9uofHLERm/ay38pD2+HX5G/XEhv3xjhF702Wl
         cA7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IokNJFjTtmaZ7K4MBG6Rh51PQnmU94xpcqHKEHyK7kM=;
        b=JYjYxfwx129UK3EN0MD35IhBkJtzlK2UK2JuaEDcEpjTg5UCLOydkoS7+hTk5fVR9O
         fRGEVunWY72soTM8HjfB7mKqgWLdg/hwVhVH70+RDuwaHCIsdf7P6ubwp4DMsHaMklLc
         aHq+ebtZT7YjgfrpVdjfnSKm8nEBFIa+hAtBMWIodhfZwgjQUPV5JCBllcN4xOb9Jv15
         0dm0aZ8dB/3tSEXHkq0sIV5SmkR7iXPSpd23PMA0XALJQVSskBc6TTUIMMag/NrEWAol
         BM13c6OKO9/G63WBFJEIbZOPIPY5K0fN16WTRE0doJKK4qUAhFJ98ohenSJd75Q3Exc5
         eGpg==
X-Gm-Message-State: AOAM5314pgz9/zO82jcwmOAXB/K3NB3i+7su+ZLVe6hlu9tvHusCmfh2
        tIX+4DzbEz2j0xdLlhTqdGpAfg==
X-Google-Smtp-Source: ABdhPJw/TBxogwmsHQpfJybpr088jEbVeKMKR+iUAF9xj47O8wYEKonN8llw69IAIu85e00zIe+RZg==
X-Received: by 2002:a0c:fd24:: with SMTP id i4mr4625190qvs.69.1589979372928;
        Wed, 20 May 2020 05:56:12 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id g26sm2372719qtk.76.2020.05.20.05.56.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 May 2020 05:56:12 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jbOGZ-0006An-Q0; Wed, 20 May 2020 09:56:11 -0300
Date:   Wed, 20 May 2020 09:56:11 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        pierre-louis.bossart@linux.intel.com,
        Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 11/12] ASoC: SOF: Create client driver for IPC test
Message-ID: <20200520125611.GI31189@ziepe.ca>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-12-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520070227.3392100-12-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 12:02:26AM -0700, Jeff Kirsher wrote:
> +static const struct virtbus_dev_id sof_ipc_virtbus_id_table[] = {
> +	{"sof-ipc-test"},
> +	{},
> +};
> +
> +static struct sof_client_drv sof_ipc_test_client_drv = {
> +	.name = "sof-ipc-test-client-drv",
> +	.type = SOF_CLIENT_IPC,
> +	.virtbus_drv = {
> +		.driver = {
> +			.name = "sof-ipc-test-virtbus-drv",
> +		},
> +		.id_table = sof_ipc_virtbus_id_table,
> +		.probe = sof_ipc_test_probe,
> +		.remove = sof_ipc_test_remove,
> +		.shutdown = sof_ipc_test_shutdown,
> +	},
> +};
> +
> +module_sof_client_driver(sof_ipc_test_client_drv);
> +
> +MODULE_DESCRIPTION("SOF IPC Test Client Driver");
> +MODULE_LICENSE("GPL v2");
> +MODULE_IMPORT_NS(SND_SOC_SOF_CLIENT);
> +MODULE_ALIAS("virtbus:sof-ipc-test");

Usually the MODULE_ALIAS happens automatically rhough the struct
virtbus_dev_id - is something missing in the enabling patches?

JAson
