Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656EA6BB893
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbjCOPxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbjCOPxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:53:25 -0400
Received: from out-14.mta0.migadu.com (out-14.mta0.migadu.com [IPv6:2001:41d0:1004:224b::e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7107DD27
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:52:50 -0700 (PDT)
Message-ID: <a406597f-60f4-5602-1f13-6c00cdc98c05@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678895567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LAZRybupTvQEP0hHnGktZ9GfjVa1Kn4GHkLJyjxmJqc=;
        b=tFSK0itZaddcvsbD3fAZ9iXUM0mQS0REsGD8wAg1x+9tvOgAED3Tiak+5dNwulyIDk6r+b
        vJB3jicZXYqgY4aqwugxCaJtviRADODqZy0M6g3TdD2eSzoBh7Sv3bxekgEheC/CGwIh0M
        AA7w63hptaRkbZZybILr5Y9bvmJGc/s=
Date:   Wed, 15 Mar 2023 15:52:43 +0000
MIME-Version: 1.0
Subject: Re: [PATCH RFC v6 6/6] ptp_ocp: implement DPLL ops
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-7-vadfed@meta.com> <ZBHliPPS+e5d5JQe@nanopsycho>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <ZBHliPPS+e5d5JQe@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/03/2023 15:34, Jiri Pirko wrote:
> Sun, Mar 12, 2023 at 03:28:07AM CET, vadfed@meta.com wrote:
> 
> [...]
> 
>> @@ -4226,8 +4377,44 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>
>> 	ptp_ocp_info(bp);
>> 	devlink_register(devlink);
>> -	return 0;
>>
>> +	clkid = pci_get_dsn(pdev);
>> +	bp->dpll = dpll_device_get(clkid, 0, THIS_MODULE);
>> +	if (!bp->dpll) {
> 
> You have to use IS_ERR() here. Same problem in ice.
> 

Yep, fixed, thanks!

