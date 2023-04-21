Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4560C6EA421
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 08:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjDUGwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 02:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjDUGwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 02:52:07 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C5D1BC0;
        Thu, 20 Apr 2023 23:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682059925; x=1713595925;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NEGGzzH1AMFYYH2qguJx0xQL+koWW5dgiIL99qABywU=;
  b=IgCDUt6UoYepHl3p3QxL9c649I8tdlvP2eNbaP8DRHMLClut8akT76Iq
   HTPkhSVQbP6V/42AOfXLpT/gRn3US614yuuepS7kmwDQB9izpjxH3AiwG
   ruWu49UOsxmrzp3MNj/BZFJphuk/2HxCIhER0JLQ0v+KACx1vZhORXtAP
   Pm5RqowrM9oM0z4XmiaLW7X6V2YIKkDR0xeIqxmF/HvabwcwchJD7FK8n
   6Y7Hsx8JXwsVlLUwn0NUJV/aAXtj3jjZt8hG4yz/baHL/eHis2gSgMJ6q
   nEZ5AA59rEP8KaE+HJxshWU+4WpDV+5XKrnGR4e8lNcmGqzqYmY20CQYW
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="432207962"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="432207962"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 23:52:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="781504362"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="781504362"
Received: from mylly.fi.intel.com (HELO [10.237.72.175]) ([10.237.72.175])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Apr 2023 23:52:03 -0700
Message-ID: <9626e30c-9e0c-b182-4c2e-1ec6c0c98c9e@linux.intel.com>
Date:   Fri, 21 Apr 2023 09:52:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v3 2/8] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
To:     Jiawen Wu <jiawenwu@trustnetic.com>, 'Andrew Lunn' <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        olteanv@gmail.com, mengyuanlou@net-swift.com
References: <20230419082739.295180-1-jiawenwu@trustnetic.com>
 <20230419082739.295180-3-jiawenwu@trustnetic.com>
 <ec095b8a-00af-4fb7-be11-f643ea75e924@lunn.ch>
 <03ef01d97372$f2ee26a0$d8ca73e0$@trustnetic.com>
Content-Language: en-US
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
In-Reply-To: <03ef01d97372$f2ee26a0$d8ca73e0$@trustnetic.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/23 13:29, Jiawen Wu wrote:
> On Thursday, April 20, 2023 4:58 AM, Andrew Lunn wrote:
>> On Wed, Apr 19, 2023 at 04:27:33PM +0800, Jiawen Wu wrote:
>>> Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
>>> with SFP.
>>>
>>> Add platform data to pass IOMEM base address, board flag and other
>>> parameters, since resource address was mapped on ethernet driver.
>>>
>>> The exists IP limitations are dealt as workarounds:
>>> - IP does not support interrupt mode, it works on polling mode.
>>> - I2C cannot read continuously, only one byte can at a time.
>>
>> Are you really sure about that?
>>
>> It is a major limitation for SFP devices. It means you cannot access
>> the diagnostics, since you need to perform an atomic 2 byte read.
>>
>> Or maybe i'm understanding you wrong.
>>
>>     Andrew
>>
> 
> Maybe I'm a little confused about this. Every time I read a byte info, I have to
> write a 'read command'. It can normally get the information for SFP devices.
> But I'm not sure if this is regular I2C behavior.
> 
I agree, IC_DATA_CMD operation is obscure. In order to read from the 
bus, writes with BIT(8) set is required into IC_DATA_CMD, wait 
(irq/poll) DW_IC_INTR_RX_FULL is set in DW_IC_RAW_INTR_STAT and then 
read back received data from IC_DATA_CMD while taking into count FIFO sizes.

Full documentation of this IP is in DesignWare DW_apb_i2c Databook. You 
may try to get access to Synopsys or try to find if older version of it 
is available somewhere.

https://www.synopsys.com/dw/ipdir.php?c=DW_apb_i2c

Plain register specifications can be found from some of the Intel 
datasheets. For example chapter 13.2 I2C Memory Mapped Registers 
Summary, page 667 in a datasheet below:

https://cdrdv2-public.intel.com/743845/743845_001.pdf
