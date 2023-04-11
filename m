Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC4736DDA3B
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjDKMEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjDKMEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:04:06 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB442D48;
        Tue, 11 Apr 2023 05:04:05 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33BC3muM120374;
        Tue, 11 Apr 2023 07:03:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1681214628;
        bh=WDVeTJwyTcw7grlTUYQdYuxVD5Hgg6hWlZAY1CZ2ux4=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=M7AOHNIKSecw/WaL/PSLQFfQkBYN5KtXRJLtdSccMIqMrJrN6EhEIsxx4XnrSGfPn
         nosNuz3cenAzErwKsEA9/eO8gYaqp/15RnPY3trE9KRXJ1B1jx4S84uOyPubGp86Xm
         7PCMXUwH7r4pOhGLFGa4Wxu/svH18eMoQweRcodg=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33BC3mQI000471
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 11 Apr 2023 07:03:48 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 11
 Apr 2023 07:03:48 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 11 Apr 2023 07:03:48 -0500
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33BC3hgd008848;
        Tue, 11 Apr 2023 07:03:43 -0500
Message-ID: <b10106e9-eba7-103a-54a2-b41277af378f@ti.com>
Date:   Tue, 11 Apr 2023 17:33:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [EXTERNAL] Re: [PATCH v7 1/4] soc: ti: pruss: Add
 pruss_get()/put() API
Content-Language: en-US
To:     Mathieu Poirier <mathieu.poirier@linaro.org>,
        MD Danish Anwar <danishanwar@ti.com>
CC:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>, <linux-remoteproc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <srk@ti.com>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20230404115336.599430-1-danishanwar@ti.com>
 <20230404115336.599430-2-danishanwar@ti.com> <20230410170927.GA4129213@p14s>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <20230410170927.GA4129213@p14s>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mathieu

On 10/04/23 22:39, Mathieu Poirier wrote:
> On Tue, Apr 04, 2023 at 05:23:33PM +0530, MD Danish Anwar wrote:
>> From: Tero Kristo <t-kristo@ti.com>
>>
>> Add two new get and put API, pruss_get() and pruss_put() to the
>> PRUSS platform driver to allow client drivers to request a handle
>> to a PRUSS device. This handle will be used by client drivers to
>> request various operations of the PRUSS platform driver through
>> additional API that will be added in the following patches.
>>
>> The pruss_get() function returns the pruss handle corresponding
>> to a PRUSS device referenced by a PRU remoteproc instance. The
>> pruss_put() is the complimentary function to pruss_get().
>>
>> Co-developed-by: Suman Anna <s-anna@ti.com>
>> Signed-off-by: Suman Anna <s-anna@ti.com>
>> Signed-off-by: Tero Kristo <t-kristo@ti.com>
>> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>> Reviewed-by: Roger Quadros <rogerq@kernel.org>
>> Reviewed-by: Tony Lindgren <tony@atomide.com>
>> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
>> ---
>>  drivers/remoteproc/pru_rproc.c                |  2 +-
>>  drivers/soc/ti/pruss.c                        | 64 ++++++++++++++++++-
>>  .../{pruss_driver.h => pruss_internal.h}      |  7 +-
>>  include/linux/remoteproc/pruss.h              | 19 ++++++
>>  4 files changed, 87 insertions(+), 5 deletions(-)
>>  rename include/linux/{pruss_driver.h => pruss_internal.h} (90%)
>>
> 
> Throughout this patchset an API to access resources required by the PRUSS
> is added to pruss.c but all the function declarations are added to
> remoteproc/pruss.h.  Is this something you were asked to do or is this how the
> original implementation was?
> 

Previously in v3 [1] remoteproc/pruss.h had pruss_get() / pruss_put(),
pruss_request_mem_region() / pruss_release_mem_region() and pruss_cfg_read() /
update() API declaration in it. These APIs were defined in pruss.c. The APIs
were defined in pruss.c.

The other APIs [pruss_cfg_get_gpmux()/set(), pruss_cfg_gpimode,
pruss_cfg_miirt_enable, pruss_cfg_xfr_enable] were declared as well as defined
in linux/pruss_driver.h.

But in order to make pruss_cfg_read() / update() API internal to PRUSS as asked
by Roger, the other APIs' [pruss_cfg_get_gpmux()/set(), pruss_cfg_gpimode,
pruss_cfg_miirt_enable, pruss_cfg_xfr_enable] declaration was moved to pruss.c
and definition was moved to remoteproc/pruss.h and pruss_cfg_read() / update()
API's declaration as well as definition was moved to drivers/soc/ti/pruss.h

So now remoteproc/pruss.h has declaration of below APIs.
	pruss_get
	pruss_put
	pruss_request_mem_region
	pruss_release_mem_region
	pruss_cfg_get_gpmux
	pruss_cfg_set_gpmux
	pruss_cfg_gpimode
	pruss_cfg_miirt_enable
	pruss_cfg_xfr_enable

All these APIs are defined in drivers/soc/ti/pruss.c

> Other than pruss_get() nothing in there is related to the remoteproc
> subsystem, the bulk of the work is all about PRUSS.
> 
> In my opinion all the function declaration should go in pruss_driver.h, which
> should stay as it is and not made internal.  The code looks good now but it
> needs to be added where it belongs.
>> Thanks,
> Mathieu
> 

There was discussion on moving these declaration to pruss_driver.h but Andrew
and Roger agreed on keeping these in remoteproc/pruss.h only in v4 [2]. Also
Andrew suggested in v4 to rename pruss_driver.h to internal.

Please let me know if I should keep them as it is or try to move APIs from
remoteproc/pruss.h to pruss_driver.h.

Earlier in v3 below APIs were there in remoteproc/pruss.h
	pruss_get
	pruss_put
	pruss_request_mem_region
	pruss_release_mem_region

Should I keep all these in remoteproc/pruss.h or only pruss_get/put() as
mentioned by you in this email.

[1] https://lore.kernel.org/all/20230306110934.2736465-1-danishanwar@ti.com/
[2] https://lore.kernel.org/all/67dd1d04-147d-0e40-c06b-6e1e0dd05f13@kernel.org/

-- 
Thanks and Regards,
Danish.
