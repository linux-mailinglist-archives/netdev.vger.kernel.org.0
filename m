Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33315431F41
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhJROSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbhJROSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 10:18:14 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4231C04CD6B
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 07:00:23 -0700 (PDT)
Subject: Re: [Intel-wired-lan] [PATCH 1/1] ice: compact the file ice_nvm.c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1634565621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uCmTVYdqiFj8dnSfWVXPlxsBjONsYEUym9vDHdCm4MQ=;
        b=n8rsAcYSX+YSPmh0+NE52IDk51i6PQ+Coz3sOGXQ505LYcHs7QvhhP0qLRE6pQblXrAN9f
        ZVLZSyTJDP5sLKwcmQB/rU5/dx69zNQUWXUWOkylbKa5Kx36oKiyQqpmeE9yU3NDRaRGc7
        uqth/t1knbr1MAZlusqPPOLahE44RKw=
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
References: <20211018131713.3478-1-yanjun.zhu@linux.dev>
 <c1903730-9508-1fef-4232-3a5b62f28d7c@molgen.mpg.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Yanjun Zhu <yanjun.zhu@linux.dev>
Message-ID: <087710e9-2aeb-c070-cebb-82ae9cb5c20e@linux.dev>
Date:   Mon, 18 Oct 2021 22:00:05 +0800
MIME-Version: 1.0
In-Reply-To: <c1903730-9508-1fef-4232-3a5b62f28d7c@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yanjun.zhu@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/10/18 21:44, Paul Menzel 写道:
> Dear Yanjun,
>
>
> Am 18.10.21 um 15:17 schrieb yanjun.zhu@linux.dev:
>> From: Zhu Yanjun <yanjun.zhu@linux.dev>
>>
>> The function ice_aq_nvm_update_empr is not used, so remove it.
>
> Thank you for the patch. Could you please make the commit message 
> summary more descriptive? Maybe:
>
>> ice: Remove unused `ice_aq_nvm_update_empr()`
>
> If you find out, what commit removed the usage, that would be also 
> good to document, but it’s not that important.


Thanks for your suggestion.

IMO, removing the unused function is one method of compact file.

I agree with you that the commit message summary is not important.

If someone finds more important problem in this commit, I will resend the

patch and change the commit message summary based on your suggestion.


Best Regards.

Zhu Yanjun

>
>
> Kind regards,
>
> Paul
>
>
>> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
>> ---
>>   drivers/net/ethernet/intel/ice/ice_nvm.c | 16 ----------------
>>   drivers/net/ethernet/intel/ice/ice_nvm.h |  1 -
>>   2 files changed, 17 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c 
>> b/drivers/net/ethernet/intel/ice/ice_nvm.c
>> index fee37a5844cf..bad374bd7ab3 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_nvm.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
>> @@ -1106,22 +1106,6 @@ enum ice_status ice_nvm_write_activate(struct 
>> ice_hw *hw, u8 cmd_flags)
>>       return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
>>   }
>>   -/**
>> - * ice_aq_nvm_update_empr
>> - * @hw: pointer to the HW struct
>> - *
>> - * Update empr (0x0709). This command allows SW to
>> - * request an EMPR to activate new FW.
>> - */
>> -enum ice_status ice_aq_nvm_update_empr(struct ice_hw *hw)
>> -{
>> -    struct ice_aq_desc desc;
>> -
>> -    ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_nvm_update_empr);
>> -
>> -    return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
>> -}
>> -
>>   /* ice_nvm_set_pkg_data
>>    * @hw: pointer to the HW struct
>>    * @del_pkg_data_flag: If is set then the current pkg_data store by FW
>> diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.h 
>> b/drivers/net/ethernet/intel/ice/ice_nvm.h
>> index c6f05f43d593..925225905491 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_nvm.h
>> +++ b/drivers/net/ethernet/intel/ice/ice_nvm.h
>> @@ -39,7 +39,6 @@ enum ice_status
>>   ice_aq_erase_nvm(struct ice_hw *hw, u16 module_typeid, struct 
>> ice_sq_cd *cd);
>>   enum ice_status ice_nvm_validate_checksum(struct ice_hw *hw);
>>   enum ice_status ice_nvm_write_activate(struct ice_hw *hw, u8 
>> cmd_flags);
>> -enum ice_status ice_aq_nvm_update_empr(struct ice_hw *hw);
>>   enum ice_status
>>   ice_nvm_set_pkg_data(struct ice_hw *hw, bool del_pkg_data_flag, u8 
>> *data,
>>                u16 length, struct ice_sq_cd *cd);
>>
