Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B431163ACE7
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 16:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbiK1Prc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 10:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbiK1PrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 10:47:10 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA4F233B9
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 07:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669650427; x=1701186427;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=ou3Loa0MWcDspSQwMCa/XZiFez5PSZ3tHARIcmHlK8Y=;
  b=gN7JUE25L8yIfr6BpwpssOLzYEZUgJKaH97Osjr1rSJmzRM3fwwQaIKh
   P8BvcX8hqM5gdIK48DmUqzdEm/OtmLgpwySDwZFE0ODRdo4vx23VN7lKJ
   ljJKR+gsmUHeLWfqjFH91cSiuxkhTaeGPDV1z5jFMJh9GQMb4aldWU6xk
   Aowa+zObLh7xK9ufQwc17onTU78WtIi3TzYP9cvCmfoFvJIq4HpExuwZP
   tn6PCs7/pC0/gJHbjjMQ1B1NEZZzEfpR0QR7Q4Lp8wDzmA7O6mMNvV5eQ
   JfvXW6TI9sVBr5a5GzXeGL+hRfkRMj8/l/EDHbrahQ0/wqPrmdxSeoTlm
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="294566255"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="294566255"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 07:38:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="785673271"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="785673271"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.209.161.118]) ([10.209.161.118])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 07:38:24 -0800
Message-ID: <dd693036-961a-ea1d-3bad-378222430dc9@intel.com>
Date:   Mon, 28 Nov 2022 08:38:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [PATCH] net: net_netdev: Fix error handling in
 ntb_netdev_init_module()
Content-Language: en-US
To:     Yuan Can <yuancan@huawei.com>, jdmason@kudzu.us, allenbh@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nab@linux-iscsi.org, gregkh@linuxfoundation.org,
        ntb@lists.linux.dev, netdev@vger.kernel.org
References: <20221124070917.38825-1-yuancan@huawei.com>
From:   Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20221124070917.38825-1-yuancan@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/24/2022 12:09 AM, Yuan Can wrote:
> The ntb_netdev_init_module() returns the ntb_transport_register_client()
> directly without checking its return value, if
> ntb_transport_register_client() failed, the NTB client device is not
> unregistered.
> 
> Fix by unregister NTB client device when ntb_transport_register_client()
> failed.
> 
> Fixes: 548c237c0a99 ("net: Add support for NTB virtual ethernet device")
> Signed-off-by: Yuan Can <yuancan@huawei.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   drivers/net/ntb_netdev.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
> index 464d88ca8ab0..a4abea921046 100644
> --- a/drivers/net/ntb_netdev.c
> +++ b/drivers/net/ntb_netdev.c
> @@ -484,7 +484,14 @@ static int __init ntb_netdev_init_module(void)
>   	rc = ntb_transport_register_client_dev(KBUILD_MODNAME);
>   	if (rc)
>   		return rc;
> -	return ntb_transport_register_client(&ntb_netdev_client);
> +
> +	rc = ntb_transport_register_client(&ntb_netdev_client);
> +	if (rc) {
> +		ntb_transport_unregister_client_dev(KBUILD_MODNAME);
> +		return rc;
> +	}
> +
> +	return 0;
>   }
>   module_init(ntb_netdev_init_module);
>   
