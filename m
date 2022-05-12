Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B329524192
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 02:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349696AbiELAft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 20:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344576AbiELAfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 20:35:48 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AD92A9;
        Wed, 11 May 2022 17:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652315744; x=1683851744;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Pa3IAVTpVZpXKpk9YhVTbJh3buDK9LGyq4dCv/GcDXI=;
  b=Gy3FOqU4yLpRZg4WRSakp4kFDEquNMWYMK7oU+7XubDFi9+RaWY8z/NW
   R7CgrYTiDcLc31beoR6exJxIo9t4Qg0nicQUrGN7RzV9xFZmfFYMIdRIe
   VVRWvqxIgR00VV1qC/p6Djbg36ZS4A0mGXbY8dxznX9FsRvOxUMf52RX8
   53fid39WWiE5+EJVMSrQ0a//j0oja7qV7UJ+SfrgLUj7QqPrRYaUPbm6J
   ulk89nUDCahtxe9Tt1btq8WI8Vx3JFazHLzlYVeYJl0bUCusmC4ImW3nr
   q9pgcd689aTrBm+pGpcGmbQTDteHeyoVWS+KOQOWueom27H5DBeTyl7q+
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="269787644"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="269787644"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 17:35:44 -0700
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="697804307"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.212.129.114]) ([10.212.129.114])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 17:35:44 -0700
Message-ID: <add45b0e-3081-3ca0-d03c-fe306526cc01@linux.intel.com>
Date:   Wed, 11 May 2022 17:35:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next] net: wwan: t7xx: Fix return type of
 t7xx_dl_add_timedout()
Content-Language: en-US
To:     YueHaibing <yuehaibing@huawei.com>,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        m.chetan.kumar@linux.intel.com, loic.poulain@linaro.org,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220511071907.29120-1-yuehaibing@huawei.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <20220511071907.29120-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/11/2022 12:19 AM, YueHaibing wrote:
> t7xx_dl_add_timedout() now return int 'ret', but the return type
> is bool. Change the return type to int for furthor errcode upstream.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/net/wwan/t7xx/t7xx_dpmaif.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wwan/t7xx/t7xx_dpmaif.c b/drivers/net/wwan/t7xx/t7xx_dpmaif.c
> index c8bf6929af51..8ee15af1a1ce 100644
> --- a/drivers/net/wwan/t7xx/t7xx_dpmaif.c
> +++ b/drivers/net/wwan/t7xx/t7xx_dpmaif.c
> @@ -1043,7 +1043,7 @@ unsigned int t7xx_dpmaif_dl_dlq_pit_get_wr_idx(struct dpmaif_hw_info *hw_info,
>   	return value & DPMAIF_DL_RD_WR_IDX_MSK;
>   }
>   
> -static bool t7xx_dl_add_timedout(struct dpmaif_hw_info *hw_info)
> +static int t7xx_dl_add_timedout(struct dpmaif_hw_info *hw_info)
yes, int is the right return type, thanks!
>   {
>   	u32 value;
>   	int ret;
