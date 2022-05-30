Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46F05375C3
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 09:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbiE3HrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 03:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbiE3HrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 03:47:21 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B681A823
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 00:47:19 -0700 (PDT)
Received: from [192.168.0.4] (ip5f5aeb6c.dynamic.kabel-deutschland.de [95.90.235.108])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 1423861EA1923;
        Mon, 30 May 2022 09:47:18 +0200 (CEST)
Message-ID: <ade6c030-b1c5-e359-7321-fa21310a10f3@molgen.mpg.de>
Date:   Mon, 30 May 2022 09:47:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v3 3/3] igb_main: Assign random MAC address instead of
 fail in case of invalid one
Content-Language: en-US
To:     Lixue Liang <lianglixuehao@126.com>
Cc:     anthony.l.nguyen@intel.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, kuba@kernel.org,
        lianglixue@greatwall.com.cn, netdev@vger.kernel.org
References: <d50b23b1-38b5-2522-cbf4-c360c0ed05cd@molgen.mpg.de>
 <20220530031941.44006-1-lianglixuehao@126.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220530031941.44006-1-lianglixuehao@126.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Lixue,

Am 30.05.22 um 05:19 schrieb Lixue Liang:
> From: Lixue Liang <lianglixue@greatwall.com.cn>
> 
> In some cases, when the user uses igb_set_eeprom to modify the MAC
> address to be invalid, the igb driver will fail to load. If there is no
> network card device, the user must modify it to a valid MAC address by
> other means.
> 
> Since the MAC address can be modified, then add a random valid MAC address
> to replace the invalid MAC address in the driver can be workable, it can
> continue to finish the loading, and output the relevant log reminder.
> 
> Signed-off-by: Lixue Liang <lianglixue@greatwall.com.cn>
> ---
>   drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 746233befade..40f43534a3af 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -3362,7 +3362,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   		eth_hw_addr_random(netdev);
>   		ether_addr_copy(hw->mac.addr, netdev->dev_addr);
>   		dev_err(&pdev->dev,
> -			"Invalid MAC Address, already assigned random MAC Address\n");
> +			"Invalid MAC address, already assigned random MAC address\n");
>   	}
>   
>   	igb_set_default_mac_filter(adapter);

The diff does not do what is described in the commit message. I also 
just noticed, that it was spelled “MAC Address” before, so it would be 
fine for me if you send in this commit separately (but with the correct 
commit message).


Kind regards,

Paul
