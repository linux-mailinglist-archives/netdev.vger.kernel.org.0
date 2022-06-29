Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17877560D4C
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 01:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiF2XcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 19:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiF2XcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 19:32:01 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FCD31F;
        Wed, 29 Jun 2022 16:32:00 -0700 (PDT)
Received: from [10.22.0.128] (unknown [176.74.39.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id C79E35005C5;
        Thu, 30 Jun 2022 02:30:20 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru C79E35005C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1656545421; bh=nuefLE1G5OwMPAfk0WFiIBC94LretIpZqAk2u42KMGM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=jnkK6/hdmhGC57itbxeqFGEgknpFnkbX2UJqz7nKPf/PEhlZ7A4CbEAp8rL3RtQYm
         MIABuOuDSwEs2O14YhqR9qUpo6aSJ9q0pvnKsi1rh9si9Z/B6cOo1kKyq3GejP0xVk
         6syGeALP6k2iVRFN3iJJKOPBodcW3gNA9fEWu0h8=
Message-ID: <a4defe2e-143d-0dba-03a1-cb23082ce673@novek.ru>
Date:   Thu, 30 Jun 2022 00:31:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v2 3/3] ptp_ocp: implement DPLL ops
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org
References: <20220626192444.29321-1-vfedorenko@novek.ru>
 <20220626192444.29321-4-vfedorenko@novek.ru>
 <20220627193436.3wjunjqqtx7dtqm6@bsd-mbp.dhcp.thefacebook.com>
 <7c2fa2e9-6353-5472-75c8-b3ffe403f0f3@novek.ru>
 <20220628191124.qvto5tyfe63htxxr@bsd-mbp.dhcp.thefacebook.com>
 <20220628202414.02ac8fd1@kernel.org>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220628202414.02ac8fd1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.06.2022 04:24, Jakub Kicinski wrote:
> On Tue, 28 Jun 2022 12:11:24 -0700 Jonathan Lemon wrote:
>>>> 80-column limit (here and throughout the file)
>>>
>>> I thought this rule was relaxed up to 100-columns?
>>
>> Only in exceptional cases, IIRC.  checkpatch complains too.
> 
> Yup, for networking I still prefer 80 chars.
> My field of vision is narrow.
> 
Ok, no problem, will follow strict rules next time.


>>>> 80 cols, and this should be done before ptp_ocp_complete()
>>>> Also, should 'goto out', not return 0 and leak resources.
>>>
>>> I don't think we have to go with error path. Driver itself can work without
>>> DPLL device registered, there is no hard dependency. The DPLL device will
>>> not be registered and HW could not be configured/monitored via netlink, but
>>> could still be usable.
>>
>> Not sure I agree with that - the DPLL device is selected in Kconfig, so
>> users would expect to have it present.  I think it makes more sense to
>> fail if it cannot be allocated.
> 
> +1

Ok, it's not a big deal to make it fail in case of DPLL error, will do it in 
next iteration.
