Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F89522C5E
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 08:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242108AbiEKGcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 02:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240225AbiEKGco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 02:32:44 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75F25C753
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 23:32:42 -0700 (PDT)
Received: from [192.168.0.3] (ip5f5aeb08.dynamic.kabel-deutschland.de [95.90.235.8])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id AB39F61E6478B;
        Wed, 11 May 2022 08:32:39 +0200 (CEST)
Message-ID: <6b16f60d-0f76-f876-0881-de09ecbbbc89@molgen.mpg.de>
Date:   Wed, 11 May 2022 08:32:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [Intel-wired-lan] [PATCH] igb: Convert a series of if statements
 to switch case
Content-Language: en-US
To:     Linkui Xiao <xiaolinkui@gmail.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        netdev@vger.kernel.org, Linkui Xiao <xiaolinkui@kylinos.cn>,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
References: <20220510025755.19047-1-xiaolinkui@kylinos.cn>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220510025755.19047-1-xiaolinkui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linkui,


Thank you for your patch.

Am 10.05.22 um 04:57 schrieb xiaolinkui:
> From: Linkui Xiao<xiaolinkui@kylinos.cn>

Please add a space before the <.

> Convert a series of if statements that handle different events to
> a switch case statement to simplify the code.

(Nit: Please use 75 characters per line.)

> Signed-off-by: Linkui Xiao<xiaolinkui@kylinos.cn>
> ---
>   drivers/net/ethernet/intel/igb/igb_main.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 34b33b21e0dc..4ce0718eeff6 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -4588,13 +4588,17 @@ static inline void igb_set_vf_vlan_strip(struct igb_adapter *adapter,
>   	struct e1000_hw *hw = &adapter->hw;
>   	u32 val, reg;
>   
> -	if (hw->mac.type < e1000_82576)
> +	switch (hw->mac.type) {
> +	case e1000_undefined:
> +	case e1000_82575:
>   		return;
> -
> -	if (hw->mac.type == e1000_i350)
> +	case e1000_i350:
>   		reg = E1000_DVMOLR(vfn);
> -	else
> +		break;
> +	default:
>   		reg = E1000_VMOLR(vfn);
> +		break;
> +	}
>   
>   	val = rd32(reg);
>   	if (enable)

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
