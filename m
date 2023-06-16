Return-Path: <netdev+bounces-11406-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6397E733005
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:39:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 108312816EC
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 438FB1428F;
	Fri, 16 Jun 2023 11:39:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370BD6117
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 11:39:46 +0000 (UTC)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEA42D5D;
	Fri, 16 Jun 2023 04:39:44 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-30adc51b65cso441186f8f.0;
        Fri, 16 Jun 2023 04:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686915583; x=1689507583;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+HsF8RgsrNQZ4KBY+cF3uOkWXNRFDW/Y+5wfIoYhuBc=;
        b=h+dp9cYrtIAB6w3LprJ4on7eTSjRzY9dDwel2ciFQhsWL2traVr08k9PFJh8jgLuPG
         W+LNqS0ug7++7NPXqC0eVDAWo7ONCc6X4Cco3zsdrramRYlu44B4Bxb5X0FVv1/DnM2S
         Bgi241DovJs8xSSD4cP9iGkecKnJJ4zLH6jl3igUtMtdUdRoKPSnf/+zqyy8tzPu9oa8
         xc+Ofw1V7hytnPPXKAzO32e7L0R0kNivqAlSzPV3xym6W+WvrYXjMQ6o+uYNAvK9e2ws
         6cBhU8VOECEVTTO4FwdbaboCYD9JXQpG+WQT+rcV95B5R0GreOQXFAzCmpV0+0DqMiWG
         Ephg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686915583; x=1689507583;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+HsF8RgsrNQZ4KBY+cF3uOkWXNRFDW/Y+5wfIoYhuBc=;
        b=SuPy6gWfQYk3qiw2dGh4hNidFDcr67PxIV8ADGyMqSfjj6i70K9pu2qSpq4w8MrzaQ
         N3bVj5xr9hGOjIVpuPAfP24y+1eJHbLMq5yZSy4T1bRqoyzyIMkHaydKZIuT7NIn2YV8
         /8pUGvfbDL5dHyHI68YJlWeNsYl44QNzotQyMwTG/DFgUjn7o2DUjdN5lRy1CxEP+3+W
         dClhpDNRqEYZ2Ne215+6t2nYzNdkVPwZNWaa4vu6ZZMBlidZuyIA2YSlwQa00f5Exzeg
         EnuhwT22dI04LQXBVjM1uelJEXfBaHW8nstbCSuElvepz4+91dsZvkYco0JX2kdy+wWW
         povw==
X-Gm-Message-State: AC+VfDyPqzliLAmgmVHCPAlNRY/RSVe2yzh9g9E4tLElHM9ThFjoRct3
	P27KztEeMBfBFyvteSNITU+4MRlVH50=
X-Google-Smtp-Source: ACHHUZ7mGzhTRTMBnWM/tcZFXNIq/6YeZ2DDobf0R6YYCXET5cm4AD1spP7gt20rTuI7bDQ19eG1sQ==
X-Received: by 2002:adf:f601:0:b0:311:d9f:46b4 with SMTP id t1-20020adff601000000b003110d9f46b4mr1243833wrp.14.1686915582775;
        Fri, 16 Jun 2023 04:39:42 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id t12-20020adfeb8c000000b0030ae6432504sm23470331wrn.38.2023.06.16.04.39.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 04:39:42 -0700 (PDT)
Subject: Re: [PATCH 2/2] sfc: add CONFIG_INET dependency for TC offload
To: Arnd Bergmann <arnd@kernel.org>, Martin Habets
 <habetsm.xilinx@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Alejandro Lucero <alejandro.lucero-palau@amd.com>,
 Jiri Pirko <jiri@resnulli.us>,
 Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
 Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
 linux-net-drivers@amd.com, linux-kernel@vger.kernel.org
References: <20230616090844.2677815-1-arnd@kernel.org>
 <20230616090844.2677815-2-arnd@kernel.org>
From: Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <2fa7c4a5-79cb-b504-2381-08cb629d473d@gmail.com>
Date: Fri, 16 Jun 2023 12:39:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230616090844.2677815-2-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 16/06/2023 10:08, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The driver now fails to link when CONFIG_INET is disabled, so
> add an explicit Kconfig dependency:
> 
> ld.lld: error: undefined symbol: ip_route_output_flow
>>>> referenced by tc_encap_actions.c
>>>>               drivers/net/ethernet/sfc/tc_encap_actions.o:(efx_tc_flower_create_encap_md) in archive vmlinux.a
> 
> ld.lld: error: undefined symbol: ip_send_check
>>>> referenced by tc_encap_actions.c
>>>>               drivers/net/ethernet/sfc/tc_encap_actions.o:(efx_gen_encap_header) in archive vmlinux.a
>>>> referenced by tc_encap_actions.c
>>>>               drivers/net/ethernet/sfc/tc_encap_actions.o:(efx_gen_encap_header) in archive vmlinux.a
> 
> ld.lld: error: undefined symbol: arp_tbl
>>>> referenced by tc_encap_actions.c
>>>>               drivers/net/ethernet/sfc/tc_encap_actions.o:(efx_tc_netevent_event) in archive vmlinux.a
>>>> referenced by tc_encap_actions.c
>>>>               drivers/net/ethernet/sfc/tc_encap_actions.o:(efx_tc_netevent_event) in archive vmlinux.a
> 
> Fixes: a1e82162af0b8 ("sfc: generate encap headers for TC offload")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
 and I think you also need
Fixes: 7e5e7d800011 ("sfc: neighbour lookup for TC encap action offload")
 since that added the references to ip_route_output_flow and arp_tbl (the
 commit in your Fixes: added the ip_send_check reference on top of that).

You also might want to add the Closes: tag from [1], I don't know how
 that works but I assume it'll make someone's regression-bot happy.

-ed

[1] https://lore.kernel.org/oe-kbuild-all/202306151656.yttECVTP-lkp@intel.com/

> ---
>  drivers/net/ethernet/sfc/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
> index 4af36ba8906ba..3eb55dcfa8a61 100644
> --- a/drivers/net/ethernet/sfc/Kconfig
> +++ b/drivers/net/ethernet/sfc/Kconfig
> @@ -50,6 +50,7 @@ config SFC_MCDI_MON
>  config SFC_SRIOV
>  	bool "Solarflare SFC9100-family SR-IOV support"
>  	depends on SFC && PCI_IOV
> +	depends on INET
>  	default y
>  	help
>  	  This enables support for the Single Root I/O Virtualization
> 


