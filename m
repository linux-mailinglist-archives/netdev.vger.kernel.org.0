Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02EA34EFD05
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 01:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351852AbiDAXPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 19:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350461AbiDAXPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 19:15:09 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A02BEBA;
        Fri,  1 Apr 2022 16:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1648854798; x=1680390798;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t/uxrWafaSD5EnT5QwWMjaFa+/9c7ciaXbOG1s2P/OA=;
  b=qpw3bnZHIqMksDumE/FzG29z4HPvjDVJnI0/68ECk2NExzlDhpbyHb8/
   fJhN+vBFesB082aynXEwwmUKkZyuD16DBfgAEuVJnZfZssUxNmIirkCSF
   5liMwz/3KCWGF3BRLHTJY9dD/IjKUYI3KcrYZe56OllSQqbTuIK5D0hLj
   s=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 01 Apr 2022 16:13:18 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 16:13:18 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 1 Apr 2022 16:13:17 -0700
Received: from [10.110.67.71] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 1 Apr 2022
 16:13:16 -0700
Message-ID: <275930a5-6f6e-4a93-6ac4-d5f99075d672@quicinc.com>
Date:   Fri, 1 Apr 2022 16:13:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] ice: Fix memory leak in ice_get_orom_civd_data()
Content-Language: en-US
To:     Jianglei Nie <niejianglei2021@163.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220401080051.16846-1-niejianglei2021@163.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220401080051.16846-1-niejianglei2021@163.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/1/2022 1:00 AM, Jianglei Nie wrote:
> Line 637 allocates a memory chunk for orom_data by vzmalloc(). But

References to lile numbers don't age very well.
suggest you s/Line 637/ice_get_orom_civd_data()/

> when ice_read_flash_module() fails, the allocated memory is not freed,
> which will lead to a memory leak.
> 
> We can fix it by freeing the orom_data when ce_read_flash_module() fails.

s/We can fix/Fix/

actual patch LGTM
> 
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
> ---
>   drivers/net/ethernet/intel/ice/ice_nvm.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
> index 4eb0599714f4..13cdb5ea594d 100644
> --- a/drivers/net/ethernet/intel/ice/ice_nvm.c
> +++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
> @@ -641,6 +641,7 @@ ice_get_orom_civd_data(struct ice_hw *hw, enum ice_bank_select bank,
>   	status = ice_read_flash_module(hw, bank, ICE_SR_1ST_OROM_BANK_PTR, 0,
>   				       orom_data, hw->flash.banks.orom_size);
>   	if (status) {
> +		vfree(orom_data);
>   		ice_debug(hw, ICE_DBG_NVM, "Unable to read Option ROM data\n");
>   		return status;
>   	}

