Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53CEC5E6B87
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 21:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbiIVTJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 15:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbiIVTJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 15:09:44 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A777A2EF1E
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 12:09:41 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id D2AA8504CFA;
        Thu, 22 Sep 2022 22:06:29 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru D2AA8504CFA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1663873591; bh=mEwnapkenWokKZYiSYBOt8MmfiHzlKD0ql2XQR1Keio=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Qdfl2JgzrXV9NYBZxMJjt2PryQ4HbUkangda5owwi1qAlt+ueVAqEq4IVtCmL3Bgb
         NczlH2iXvrjUrzr1vMnXnTmPzcD9i5qXVZ7Uh+2IwOFG0Iwc/mipRxbigK0bW2HSue
         CL2HC4ub1jpXYxMacMI9IKng72zeRym7N4oiZomw=
Message-ID: <6772ad1d-9d40-4e1e-9e61-acd5b1d9eda5@novek.ru>
Date:   Thu, 22 Sep 2022 20:09:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net v2] bnxt_en: replace reset with config timestamps
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
References: <20220921224430.20395-1-vfedorenko@novek.ru>
 <20220921173818.305eb52e@kernel.org>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220921173818.305eb52e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.09.2022 01:38, Jakub Kicinski wrote:
> On Thu, 22 Sep 2022 01:44:30 +0300 Vadim Fedorenko wrote:
>> +		if (ptp->rx_filter == PORT_MAC_CFG_REQ_FLAGS_ALL_RX_TS_CAPTURE_ENABLE) {
> 
> Doesn't ptp->rx_filter hold the uAPI values, i.e. HWTSTAMP_FILTER_* ?
> 

Thanks for catching this, Jakub.
>> +			rc = bnxt_close_nic(bp, false, false);
>> +			if (!rc)
>> +				rc = bnxt_open_nic(bp, false, false);
>> +		} else
>> +			bnxt_ptp_cfg_tstamp_filters(bp);
> 
> nit: missing brackets around the else branch

v3 is on the way, also moving to net-next and without Fixes tag
