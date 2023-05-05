Return-Path: <netdev+bounces-602-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 20FF96F8723
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 18:57:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 591D91C2194D
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 16:57:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2FC1C2ED;
	Fri,  5 May 2023 16:57:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58095383
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 16:57:28 +0000 (UTC)
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB55E19922
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 09:57:21 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1ab1ce53ca6so14495495ad.0
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 09:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683305841; x=1685897841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MRnH3Cqyhep5CEq8cjj0HvIYZ//rx8xK1w3m3boBFtg=;
        b=Cyf/IQwjmN9nQoPYngzzVl136RZUda/4n2mxEslQE6sZXsNPA8HPj7FUmIk4yH/+Ul
         CGE5+hMHUuhvWiMrdhcQ/HHILkaTdCVWE2E1FFRP15KyTbmDfuaSgT46WsKX6jjnhdCc
         qZN4gR2llEQKeHIA3LEIWEO2NOvJd0J2Yv2QhCa8uDlEG4Z6y2RzMgVkL01DBdbuaqoE
         t7wEXYL4RYq3GDXOjJ5w3vEJguzJSKRMLOSN65oWtMlSTHjTj4gmbgwHmETw67ZtZINV
         88UsYbpmdrEPjoEyvb7s9l3l5iSdgBRIPPuuERshVM37DqaUym8OWO4n72s9AR5DfuMD
         4w1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683305841; x=1685897841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MRnH3Cqyhep5CEq8cjj0HvIYZ//rx8xK1w3m3boBFtg=;
        b=YxrhgktEwUZ9zXNsmZ8kboMU2j5egn5q/32dDR+gIjUDTSEPzgPOtvnLikVPyncDCt
         0FwMVwPe+w1NuySK5BvflvgbJQy32jarZ/ymYtMMc9I3hNTlwQsDdrJyscXFiT0Y9cHn
         Lob4AdOovEKjUKhFPv3sKG9NU1u53lpPUZud6HN7BlNcYOKv4tly7v4GqAhvLdFrPYKV
         +hJYu0KR2hvhpuxpNJVr3COs/volZF9zRpLAzL2vVkcllBbV9eLy7b7/TQr3Od5ql0If
         +SBVeCk+TGMbqyAcgRzfsPJQ7sRIFy7ZarPZ5bwKU1oO9TH222zDYj3nfScfm/a2Jn9E
         5Row==
X-Gm-Message-State: AC+VfDyWH0cSQ2A8WYr+zeczC66ofdryvKVrFtdscUP2rBFt6uMXHbU0
	b83Q4ZmJUdkJPF4zYLXtRsFnKw==
X-Google-Smtp-Source: ACHHUZ7LKP3CgdJgRxrVJzoZS412nCrFH/uVDLZE6eaj78oMi5iMd/a/L1rEOrB3ZxMOJ5q/i06cTg==
X-Received: by 2002:a17:902:be01:b0:1a8:1c9a:f68 with SMTP id r1-20020a170902be0100b001a81c9a0f68mr1814959pls.36.1683305841239;
        Fri, 05 May 2023 09:57:21 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id w1-20020a170902904100b001a69c1c78e7sm2017229plz.71.2023.05.05.09.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 09:57:20 -0700 (PDT)
Date: Fri, 5 May 2023 09:57:17 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Chuck Lever <cel@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, BMT@zurich.ibm.com,
 tom@talpey.com
Subject: Re: [PATCH RFC 2/3] net/lo: Ensure lo devices have a MAC address
Message-ID: <20230505095717.6ad2b4ca@hermes.local>
In-Reply-To: <168330135435.5953.3471584034284499194.stgit@oracle-102.nfsv4bat.org>
References: <168330051600.5953.11366152375575299483.stgit@oracle-102.nfsv4bat.org>
	<168330135435.5953.3471584034284499194.stgit@oracle-102.nfsv4bat.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 05 May 2023 11:42:44 -0400
Chuck Lever <cel@kernel.org> wrote:

> From: Chuck Lever <chuck.lever@oracle.com>
> 
> A non-zero MAC address enables a network device to be assigned as
> the underlying device for a virtual RDMA device. Without a non-
> zero MAC address, cma_acquire_dev_by_src_ip() is unable to find the
> underlying egress device that corresponds to a source IP address,
> and rdma_resolve_address() fails.
> 
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  drivers/net/loopback.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
> index f6d53e63ef4e..1ce4f19d8065 100644
> --- a/drivers/net/loopback.c
> +++ b/drivers/net/loopback.c
> @@ -192,6 +192,8 @@ static void gen_lo_setup(struct net_device *dev,
>  	dev->needs_free_netdev	= true;
>  	dev->priv_destructor	= dev_destructor;
>  
> +	eth_hw_addr_random(dev);
> +
>  	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
>  }
>  
> 
> 
> 

This enough of a change, it will probably break somebody.
If you need dummy endpoint (ie multiple loopback), a common way
is to use dummy devices for that.

