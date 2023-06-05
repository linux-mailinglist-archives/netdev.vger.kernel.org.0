Return-Path: <netdev+bounces-7903-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CC657220A2
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:11:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA7391C20B70
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E51B125A4;
	Mon,  5 Jun 2023 08:10:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F7C8BEA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:10:45 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77E4A1;
	Mon,  5 Jun 2023 01:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685952644; x=1717488644;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HPWdNa03m1xAyahf1uKBoWWQIEqxfz9qy1zZwFxRaa4=;
  b=HPlk27kssthwPCwqNY8L1QjO+Vf4ke7H3UGtqDrk5SiLgug7BllZw3Th
   XOgv2Tns35wbdr/KUHtYOzxMkSO5R4PbxgG+fbnlqsqpMQLLcf46gN1EC
   Ncmjtdi8+S4dQV6rCTY8I1EXLBvoptrTBH7AxRPEpi8xhRtkvZ2eJdLxi
   Z8DAQrt7pXmseseyhPk4ZlNEWTT+tMZmxGoWH9GgLI6IJaTXcho6ZltVK
   t1Z947An/txQ+Kyf/DjuEKB7VQYMhZaeI+O/l/muuaNNAwat8kqRCuwkF
   5EBdgWSfRO1XlX7xjjZOlys+RydSK36wLP/R2CI8fQc/X8QqmUu+SxSRz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="359623653"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="359623653"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 01:10:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="658985053"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="658985053"
Received: from mylly.fi.intel.com (HELO [10.237.72.143]) ([10.237.72.143])
  by orsmga003.jf.intel.com with ESMTP; 05 Jun 2023 01:10:40 -0700
Message-ID: <c3399327-37ee-f34c-4a48-7c1f1a62a785@linux.intel.com>
Date: Mon, 5 Jun 2023 11:10:39 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v11 2/9] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
Content-Language: en-US
To: Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
 andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
 jsd@semihalf.com, Jose.Abreu@synopsys.com, andrew@lunn.ch,
 hkallweit1@gmail.com, linux@armlinux.org.uk
Cc: linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
 mengyuanlou@net-swift.com, Piotr Raczynski <piotr.raczynski@intel.com>
References: <20230605025211.743823-1-jiawenwu@trustnetic.com>
 <20230605025211.743823-3-jiawenwu@trustnetic.com>
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
In-Reply-To: <20230605025211.743823-3-jiawenwu@trustnetic.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/5/23 05:52, Jiawen Wu wrote:
> Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
> with SFP.
> 
> Introduce the property "wx,i2c-snps-model" to match device data for Wangxun
> in software node case. Since IO resource was mapped on the ethernet driver,
> add a model quirk to get regmap from parent device.
> 
> The exists IP limitations are dealt as workarounds:
> - IP does not support interrupt mode, it works on polling mode.
> - Additionally set FIFO depth address the chip issue.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>   drivers/i2c/busses/i2c-designware-common.c  |  8 ++
>   drivers/i2c/busses/i2c-designware-core.h    |  4 +
>   drivers/i2c/busses/i2c-designware-master.c  | 89 +++++++++++++++++++--
>   drivers/i2c/busses/i2c-designware-platdrv.c | 15 ++++
>   4 files changed, 111 insertions(+), 5 deletions(-)
> 
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>

