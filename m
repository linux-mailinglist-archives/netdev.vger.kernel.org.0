Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4534F3734E4
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 08:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhEEGQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 02:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhEEGQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 02:16:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10926C06174A
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 23:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=3x504moR027wB70A61EWjTnXXtq1k1scVxydRO8gD7o=; b=mXWxmYS8//CgJ1KEeX5ceAh5FM
        bi16S1Yb98HQi5mxu6Of34HkNa5NQwKt0BLXq5WhXuMz5KAgFt371bAJqz19L0znyOXNGTHA/yjNA
        K+dXvs4monydELTsq4LkTjy+grc6iaJE2SwGVG/oJ4K+/jFST2qvLG1PSmXY2yC+fjZE8x8i1CkiS
        7PQomSiNZIPadwZSSS1tnD/7RlKeMj+z8EFgprnAPtfPO3j48XJqPtYp1B9E9UUaBCgVwyvkCu8ct
        wGhTCo8Y3RG5E+aU/yaTQQtDN7zMYEgjo1PRBxb6E2PshFkn+Lhc/1y+4X85Pr3Y9f8qG6i/PxHwu
        9X7mi6zQ==;
Received: from [2601:1c0:6280:3f0::7376]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1leAnL-00HYnF-3j; Wed, 05 May 2021 06:14:14 +0000
Subject: Re: [PATCH v2 net] ionic: fix ptp support config breakage
To:     Leon Romanovsky <leon@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
References: <20210505000059.59760-1-snelson@pensando.io>
 <YJIt+cm6dAOQmU0g@unreal>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <1f59a61f-b358-1248-15cf-d7ffd1446747@infradead.org>
Date:   Tue, 4 May 2021 23:13:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YJIt+cm6dAOQmU0g@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/21 10:32 PM, Leon Romanovsky wrote:
> On Tue, May 04, 2021 at 05:00:59PM -0700, Shannon Nelson wrote:
>> Driver link failed with undefined references in some
>> kernel config variations.
>>
>> v2 - added Fixes tag
> 
> Changelogs should be below "---" line.
> We don't need them in commit message history.
> 
>>
>> Fixes: 61db421da31b ("ionic: link in the new hw timestamp code")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>  drivers/net/ethernet/pensando/ionic/Makefile    | 3 +--
>>  drivers/net/ethernet/pensando/ionic/ionic_phc.c | 3 +++
>>  2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
>> index 4e7642a2d25f..61c40169cb1f 100644
>> --- a/drivers/net/ethernet/pensando/ionic/Makefile
>> +++ b/drivers/net/ethernet/pensando/ionic/Makefile
>> @@ -5,5 +5,4 @@ obj-$(CONFIG_IONIC) := ionic.o
>>  
>>  ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
>>  	   ionic_debugfs.o ionic_lif.o ionic_rx_filter.o ionic_ethtool.o \
>> -	   ionic_txrx.o ionic_stats.o ionic_fw.o
>> -ionic-$(CONFIG_PTP_1588_CLOCK) += ionic_phc.o
>> +	   ionic_txrx.o ionic_stats.o ionic_fw.o ionic_phc.o
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
>> index a87c87e86aef..30c78808c45a 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
>> @@ -1,6 +1,8 @@
>>  // SPDX-License-Identifier: GPL-2.0
>>  /* Copyright(c) 2017 - 2021 Pensando Systems, Inc */
>>  
>> +#if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
> 
> I'm not sure, but think that IS_ENABLED() is intended to be used inside
> functions/macros as boolean expression.
> 
> For other places like this, "#if CONFIG_PTP_1588_CLOCK" is better fit.

s/#if/#ifdef/

but the patch looks OK to me as is.

-- 
~Randy

