Return-Path: <netdev+bounces-6063-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C8577149B1
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 14:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7C36280EA3
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 12:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B078E6AB8;
	Mon, 29 May 2023 12:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62403D60
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 12:50:22 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-28.smtpout.orange.fr [80.12.242.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42014BE
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 05:49:51 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id 3cJHqJjQi7PLm3cJHqd6v7; Mon, 29 May 2023 14:49:18 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1685364558;
	bh=XoQbgvxypteKRvYSbooN/t9qEyY5FoztBSboiKjXBiQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZUl3C+/pW2OBrpSbLR2US9qae0y7TDuebI1UT8hnIJpqqhgkWIZKKMxycl1S8Kwj1
	 u7CwGXoGvGndNcXntCrEbHCNbtICeSMWiAhl94fqu0xIQmU4vzzZbz5B3tZp9B1odC
	 N33eNi0RIl1bELXMryoxSxUOQWWrD4JF5Pyw0doiwOue5cFwgSIYdV9SWqALvx37cS
	 uTHWr0rPggRCPpel2Cn17l4eW10bcw0bG9Sr4FWMukmUgn0bTwDhxyRXygCVMGqud4
	 oieR2iQn3PtBjCz5Ol2vAen+9MKF9bNhbj/eKcGyk7vOdrYoUT7m5nc/IYIidZIij+
	 bvnClHqeKsq4g==
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 29 May 2023 14:49:18 +0200
X-ME-IP: 86.243.2.178
Message-ID: <92bc6f3e-4463-e0fe-5cab-54c6c5eecd3f@wanadoo.fr>
Date: Mon, 29 May 2023 14:49:15 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3] hv_netvsc: Allocate rx indirection table size
 dynamically
Content-Language: fr
To: Shradha Gupta <shradhagupta@linux.microsoft.com>,
 linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Michael Kelley <mikelley@microsoft.com>,
 "David S. Miller" <davem@davemloft.net>,
 Steen Hegelund <steen.hegelund@microchip.com>,
 Simon Horman <simon.horman@corigine.com>
References: <1685080949-18316-1-git-send-email-shradhagupta@linux.microsoft.com>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <1685080949-18316-1-git-send-email-shradhagupta@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Le 26/05/2023 à 08:02, Shradha Gupta a écrit :
> Allocate the size of rx indirection table dynamically in netvsc
> from the value of size provided by OID_GEN_RECEIVE_SCALE_CAPABILITIES
> query instead of using a constant value of ITAB_NUM.
> 
> Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
> Tested-on: Ubuntu22 (azure VM, SKU size: Standard_F72s_v2)
> Testcases:
> 1. ethtool -x eth0 output
> 2. LISA testcase:PERF-NETWORK-TCP-THROUGHPUT-MULTICONNECTION-NTTTCP-Synthetic
> 3. LISA testcase:PERF-NETWORK-TCP-THROUGHPUT-MULTICONNECTION-NTTTCP-SRIOV
> 
> ---

[...]

> @@ -1596,11 +1608,18 @@ void rndis_filter_device_remove(struct hv_device *dev,
>   				struct netvsc_device *net_dev)
>   {
>   	struct rndis_device *rndis_dev = net_dev->extension;
> +	struct net_device *net = hv_get_drvdata(dev);
> +	struct net_device_context *ndc = netdev_priv(net);
>   
>   	/* Halt and release the rndis device */
>   	rndis_filter_halt_device(net_dev, rndis_dev);
>   
>   	netvsc_device_remove(dev);
> +
> +	ndc->rx_table_sz = 0;
> +	kfree(ndc->rx_table);
> +	ndc->rx_table = NULL;
> +

Nit: useless empty NL

>   }
>   
>   int rndis_filter_open(struct netvsc_device *nvdev)


