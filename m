Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014FF6EAB26
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 15:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbjDUNAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 09:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbjDUNAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 09:00:49 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370E1172D;
        Fri, 21 Apr 2023 06:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682082048; x=1713618048;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=g8W9pDwUFXhrARhzIJBcsVWfcUaP7w+6C/FXK+CmseQ=;
  b=ZTaVtDdBdK9TOY1qIoZsdXuthx3Vukwi4s7xkZFVGHQvCEBGyUWjcuL5
   RMNYbM9DJZag7pUwUpLGq/2Wmu8cTlkes3lJkq5nFdaXeHWaUph3F/qdk
   vN2JxKSrQCdFGkJEl7ybg1S5wGxg5/YjWiVYGJZdc12rExG9t0l4VC4DD
   hvDSnWlxczZQIeAjbDRtFi1tAWHAsBwHf6610Dxz1e70vq3C41uecU0BH
   giEyAqwidXwkX/670LNYzvFfvSVoFYCCSFOIgv2ARPFLzMKDTGDLMrGEW
   YpvinpyZx1vg0Pzl6hVs5cqZgD0vRrAjVgP+Jh+9Htjx7+j9xlxhTySRo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="411255329"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="411255329"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 06:00:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="685725720"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="685725720"
Received: from mylly.fi.intel.com (HELO [10.237.72.175]) ([10.237.72.175])
  by orsmga007.jf.intel.com with ESMTP; 21 Apr 2023 06:00:44 -0700
Message-ID: <f1b0995e-a452-84bc-1a5c-d4e31cef0b07@linux.intel.com>
Date:   Fri, 21 Apr 2023 16:00:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v3 2/8] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
        linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
        linux-gpio@vger.kernel.org, olteanv@gmail.com,
        mengyuanlou@net-swift.com
References: <20230419082739.295180-1-jiawenwu@trustnetic.com>
 <20230419082739.295180-3-jiawenwu@trustnetic.com>
 <ec095b8a-00af-4fb7-be11-f643ea75e924@lunn.ch>
 <03ef01d97372$f2ee26a0$d8ca73e0$@trustnetic.com>
 <9626e30c-9e0c-b182-4c2e-1ec6c0c98c9e@linux.intel.com>
 <da4a9993-1445-43a9-a0ef-b3414f492962@lunn.ch>
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
In-Reply-To: <da4a9993-1445-43a9-a0ef-b3414f492962@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/23 15:22, Andrew Lunn wrote:
> On Fri, Apr 21, 2023 at 09:52:02AM +0300, Jarkko Nikula wrote:
>> I agree, IC_DATA_CMD operation is obscure. In order to read from the bus,
>> writes with BIT(8) set is required into IC_DATA_CMD, wait (irq/poll)
>> DW_IC_INTR_RX_FULL is set in DW_IC_RAW_INTR_STAT and then read back received
>> data from IC_DATA_CMD while taking into count FIFO sizes.
> 
> Just for my understanding, this read command just allows access to the
> data in the FIFO. It has nothing to do with I2C bus transactions.
> 
Not only but it controls both the bus transactions and data to/from FIFO.

> You also mention FIFO depth. So you should not need to do this per
> byte, you can read upto the full depth of the FIFO before having to do
> the read command, poll/irq cycle again?
> 
Commands need to be written to IC_DATA_CMD for each byte and no more 
than is the FIFO depth. Like writing n read commands to it, wait for 
RX_FULL and read as many bytes as available, continue waiting if not done.

It perhaps best explained by looking at 
drivers/i2c/busses/i2c-designware-master.c: i2c_dw_xfer_msg() and 
i2c_dw_read().
