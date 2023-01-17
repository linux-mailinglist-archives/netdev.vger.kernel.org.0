Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2C266D581
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 06:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbjAQFBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 00:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbjAQFBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 00:01:10 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594EA18AB4;
        Mon, 16 Jan 2023 21:01:02 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30H50V3R068923;
        Mon, 16 Jan 2023 23:00:31 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1673931631;
        bh=ReUAVl9/wZrAkh+n6h8AJpl4/f0ZkpgcJrGf5N3oh5Y=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=EcdoY/RK3EqwZ1YRKWFqiwQ18NOUOmInO7HGkzf/PMd/vlmMrxxz9a3JIZZlxaUnU
         wWi27GwrLIQ+u9PJddCIY2QZ4A/LVUs4olAHf06cDjJcSKUoBdiWQkLQ4b6q2Nq3/M
         WFbRmrJrQZ4xqpIApt8xVydGWwrD4v+qwmDgZyOM=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30H50VPc110793
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 16 Jan 2023 23:00:31 -0600
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 16
 Jan 2023 23:00:30 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 16 Jan 2023 23:00:30 -0600
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30H50Qtq070857;
        Mon, 16 Jan 2023 23:00:27 -0600
Message-ID: <aebaa171-bf4e-c143-a186-a37cd34b724e@ti.com>
Date:   Tue, 17 Jan 2023 10:30:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <vigneshr@ti.com>,
        <srk@ti.com>, <s-vadapalli@ti.com>
Subject: Re: [PATCH net-next v2] net: ethernet: ti: am65-cpsw/cpts: Fix CPTS
 release action
To:     Roger Quadros <rogerq@kernel.org>,
        Leon Romanovsky <leon@kernel.org>
References: <20230116044517.310461-1-s-vadapalli@ti.com>
 <Y8T8+rWrvv6gfNxa@unreal> <f83831f8-b827-18df-36d4-48d9ff0056e1@ti.com>
 <b33c25c5-c93f-6860-b0a5-58279022a91c@kernel.org>
Content-Language: en-US
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <b33c25c5-c93f-6860-b0a5-58279022a91c@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Roger, Leon,

On 16/01/23 21:31, Roger Quadros wrote:
> Hi Siddharth,
> 
> On 16/01/2023 09:43, Siddharth Vadapalli wrote:
>>
>>
>> On 16/01/23 13:00, Leon Romanovsky wrote:
>>> On Mon, Jan 16, 2023 at 10:15:17AM +0530, Siddharth Vadapalli wrote:
>>>> The am65_cpts_release() function is registered as a devm_action in the
>>>> am65_cpts_create() function in am65-cpts driver. When the am65-cpsw driver
>>>> invokes am65_cpts_create(), am65_cpts_release() is added in the set of devm
>>>> actions associated with the am65-cpsw driver's device.
>>>>
>>>> In the event of probe failure or probe deferral, the platform_drv_probe()
>>>> function invokes dev_pm_domain_detach() which powers off the CPSW and the
>>>> CPSW's CPTS hardware, both of which share the same power domain. Since the
>>>> am65_cpts_disable() function invoked by the am65_cpts_release() function
>>>> attempts to reset the CPTS hardware by writing to its registers, the CPTS
>>>> hardware is assumed to be powered on at this point. However, the hardware
>>>> is powered off before the devm actions are executed.
>>>>
>>>> Fix this by getting rid of the devm action for am65_cpts_release() and
>>>> invoking it directly on the cleanup and exit paths.
>>>>
>>>> Fixes: f6bd59526ca5 ("net: ethernet: ti: introduce am654 common platform time sync driver")
>>>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>>>> Reviewed-by: Roger Quadros <rogerq@kernel.org>
>>>> ---
>>>> Changes from v1:
>>>> 1. Fix the build issue when "CONFIG_TI_K3_AM65_CPTS" is not set. This
>>>>    error was reported by kernel test robot <lkp@intel.com> at:
>>>>    https://lore.kernel.org/r/202301142105.lt733Lt3-lkp@intel.com/
>>>> 2. Collect Reviewed-by tag from Roger Quadros.
>>>>
>>>> v1:
>>>> https://lore.kernel.org/r/20230113104816.132815-1-s-vadapalli@ti.com/
>>>>
>>>>  drivers/net/ethernet/ti/am65-cpsw-nuss.c |  8 ++++++++
>>>>  drivers/net/ethernet/ti/am65-cpts.c      | 15 +++++----------
>>>>  drivers/net/ethernet/ti/am65-cpts.h      |  5 +++++
>>>>  3 files changed, 18 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>> index 5cac98284184..00f25d8a026b 100644
>>>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>> @@ -1913,6 +1913,12 @@ static int am65_cpsw_am654_get_efuse_macid(struct device_node *of_node,
>>>>  	return 0;
>>>>  }
>>>>  
>>>> +static void am65_cpsw_cpts_cleanup(struct am65_cpsw_common *common)
>>>> +{
>>>> +	if (IS_ENABLED(CONFIG_TI_K3_AM65_CPTS) && common->cpts)
>>>
>>> Why do you have IS_ENABLED(CONFIG_TI_K3_AM65_CPTS), if
>>> am65_cpts_release() defined as empty when CONFIG_TI_K3_AM65_CPTS not set?
>>>
>>> How is it possible to have common->cpts == NULL?
>>
>> Thank you for reviewing the patch. I realize now that checking
>> CONFIG_TI_K3_AM65_CPTS is unnecessary.
>>
>> common->cpts remains NULL in the following cases:

I realized that the cases I mentioned are not explained clearly. Therefore, I
will mention the cases again, along with the section of code they correspond to,
in order to make it clear.

Case-1: am65_cpsw_init_cpts() returns 0 since CONFIG_TI_K3_AM65_CPTS is not
enabled. This corresponds to the following section within am65_cpsw_init_cpts():

if (!IS_ENABLED(CONFIG_TI_K3_AM65_CPTS))
	return 0;

In this case, common->cpts remains NULL, but it is not a problem even if the
am65_cpsw_nuss_probe() fails later, since the am65_cpts_release() function is
NOP. Thus, this case is not an issue.

Case-2: am65_cpsw_init_cpts() returns -ENOENT since the cpts node is not present
in the device tree. This corresponds to the following section within
am65_cpsw_init_cpts():

node = of_get_child_by_name(dev->of_node, "cpts");
if (!node) {
	dev_err(dev, "%s cpts not found\n", __func__);
	return -ENOENT;
}

In this case as well, common->cpts remains NULL, but it is not a problem because
the probe fails and the execution jumps to "err_of_clear", which doesn't invoke
am65_cpsw_cpts_cleanup(). Therefore, common->cpts being NULL is not a problem.

Case-3 and Case-4 are described later in this mail.

>> 1. am65_cpsw_init_cpts() returns 0 since CONFIG_TI_K3_AM65_CPTS is not enabled.
>> 2. am65_cpsw_init_cpts() returns -ENOENT since the cpts node is not defined.
>> 3. The call to am65_cpts_create() fails within the am65_cpsw_init_cpts()
>> function with a return value of 0 when cpts is disabled.
> 
> In this case common->cpts is not NULL and is set to error pointer.
> Probe will continue normally.
> Is it OK to call any of the cpts APIs with invalid handle?
> Also am65_cpts_release() will be called with invalid handle.

Yes Roger, thank you for pointing it out. When I wrote "cpts is disabled", I had
meant that the following section is executed within the am65_cpsw_init_cpts()
function:

Case-3:

cpts = am65_cpts_create(dev, reg_base, node);
if (IS_ERR(cpts)) {
	int ret = PTR_ERR(cpts);

	of_node_put(node);
	if (ret == -EOPNOTSUPP) {
		dev_info(dev, "cpts disabled\n");
		return 0;
	}

......
}

Leon,

In the above code, when the section corresponding to:
dev_info(dev, "cpts disabled\n");

is executed, CONFIG_TI_K3_AM65_CPTS is enabled. Therefore, the
am65_cpts_release() is not NOP. If the probe fails after the call to
am65_cpsw_init_cpts(), then the am65_cpsw_cpts_cleanup() function will be called
in the cleanup path of probe, which needs to check for common->cpts not being
NULL. This is because common->cpts is NULL after returning 0 from the
am65_cpsw_init_cpts() function at the
dev_info(dev, "cpts disabled\n");

section. Thus, I believe that in this case, am65_cpts_release() shouldn't be
invoked from the am65_cpsw_cpts_cleanup() function, since it would have already
been invoked from am65_cpts_create()'s cleanup path. This can be ensured by
checking whether common->cpts is NULL or not, before invoking
am65_cpts_release() within am65_cpsw_cpts_cleanup().

> 
>> 4. The call to am65_cpts_create() within the am65_cpsw_init_cpts() function
>> fails with an error.
> 
> In this case common->cpts is not NULL and will invoke am65_cpts_release() with
> invalid handle.

Case-4: The call to am65_cpts_create() within the am65_cpsw_init_cpts() function
fails with an error. This corresponds to the following section within
am65_cpsw_init_cpts():

cpts = am65_cpts_create(dev, reg_base, node);
if (IS_ERR(cpts)) {
......
	dev_err(dev, "cpts create err %d\n", ret);
	return ret;
}
	

Roger,

If the call to am65_cpts_create() fails with an error other than -EOPNOTSUPP,
which corresponds to Case-4, the call to am65_cpts_release() would have been
invoked within the am65_cpts_create()'s cleanup path itself if necessary. Also,
when the error is not -EOPNOTSUPP, the am65_cpsw_init_cpts() function returns an
error, due to which the execution jumps to "err_of_clear" in
am65_cpsw_nuss_probe(). Therefore, am65_cpsw_cpts_cleanup() is not invoked in
this case, due to which common->cpts being NULL is not a problem.


Roger, Leon, please review my comments and let me know. I think that Case-3
demands checking whether common->cpts is NULL or not, within the
am65_cpsw_cpts_cleanup() function.

Regards,
Siddharth.
