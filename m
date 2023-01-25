Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F89667BC49
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 21:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236330AbjAYUKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 15:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236305AbjAYUKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 15:10:35 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B225D913;
        Wed, 25 Jan 2023 12:10:06 -0800 (PST)
Received: from [192.168.0.2] (ip5f5ae969.dynamic.kabel-deutschland.de [95.90.233.105])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 8FA9561CC40F9;
        Wed, 25 Jan 2023 21:09:40 +0100 (CET)
Message-ID: <21a41a1c-4ae4-47c7-c608-b6dd82758b16@molgen.mpg.de>
Date:   Wed, 25 Jan 2023 21:09:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [Intel-wired-lan] [PATCH] i40e: Add checking for null for
 nlmsg_find_attr()
To:     Natalia Petrova <n.petrova@fintech.ru>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        lvc-project@linuxtesting.org, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20230125141328.8479-1-n.petrova@fintech.ru>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230125141328.8479-1-n.petrova@fintech.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Natalia,


Thank you for your patch.

Am 25.01.23 um 15:13 schrieb Natalia Petrova:

In the commit message summary, you could use:

Check if nlmsg_find_attr() returns null

> The result of nlmsg_find_attr() 'br_spec' is dereferenced in
> nla_for_each_nested, but it can take null value in 'nla_find' finction,

f*u*nction

> which will result in an error.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 51616018dd1b ("i40e: Add support for getlink, setlink ndo ops")
> Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
> ---
>   drivers/net/ethernet/intel/i40e/i40e_main.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index b36bf9c3e1e4..ed4be4ffeb09 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -13101,6 +13101,8 @@ static int i40e_ndo_bridge_setlink(struct net_device *dev,
>   	}
>   
>   	br_spec = nlmsg_find_attr(nlh, sizeof(struct ifinfomsg), IFLA_AF_SPEC);
> +	if (!br_spec)
> +		return -ENOENT;
>   
>   	nla_for_each_nested(attr, br_spec, rem) {
>   		__u16 mode;


Kind regards,

Paul
