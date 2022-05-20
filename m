Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8649652F1FA
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352392AbiETSBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351777AbiETSBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:01:34 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068B1E04
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 11:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653069693; x=1684605693;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=i15Ose8RcaOtBQ7GsBMZBs7o68MsXlHGkrbtToK+4rc=;
  b=MsSCsY5by3RmXek+S5z+GMpd9/rOvn1/tnlINJdHTpTUyWgPGB7zuWVl
   0qdF45G2xR0J7xwEWR1YIfBhqy1eReYGUFpTshBvjixKWzhuRjwLSWw6O
   xNgr9xs3jdMV66kQDzsPzQ5LGGg7zb1u0DsB14itGpwmcMgZr4n4qzf5i
   hC7MpKUhW5lK5AJV7/nevMmSvn1ksG7/QJrJRMq3MWMFL5tRKgcQCGHUm
   CZq2uZX/rOWPOXRlbCQPjCHtIJ7d3sFgBJQzw5pLFu1dr4sHlMX153O8r
   +og1PAX3fYU9H+B8024UPm5RuWQYaXlKSH+7MFVVstt5UDW8Mk6vgmy29
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="254744855"
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="254744855"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 11:01:32 -0700
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="743609480"
Received: from vckummar-mobl.amr.corp.intel.com (HELO [10.209.85.227]) ([10.209.85.227])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 11:01:32 -0700
Message-ID: <09ce56a3-3624-13f9-6065-1367db5b8a6a@linux.intel.com>
Date:   Fri, 20 May 2022 11:01:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next 1/1] net: wwan: t7xx: Add port for modem logging
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, m.chetan.kumar@intel.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        haijun.liu@mediatek.com, andriy.shevchenko@linux.intel.com,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        sreehari.kancharla@intel.com, dinesh.sharma@intel.com
References: <20220519182703.27056-1-moises.veleta@linux.intel.com>
 <20220520103711.5f7f5b45@kernel.org>
 <34c7de82-e680-1c61-3696-eb7929626b51@linux.intel.com>
 <20220520104814.091709cd@kernel.org>
From:   "moises.veleta" <moises.veleta@linux.intel.com>
In-Reply-To: <20220520104814.091709cd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/20/22 10:48, Jakub Kicinski wrote:
> On Fri, 20 May 2022 10:42:56 -0700 moises.veleta wrote:
>> On 5/20/22 10:37, Jakub Kicinski wrote:
>>> On Thu, 19 May 2022 11:27:03 -0700 Moises Veleta wrote:
>>>> +	ret = copy_from_user(skb_put(skb, actual_len), buf, actual_len);
>>>> +	if (ret) {
>>>> +		ret = -EFAULT;
>>>> +		goto err_out;
>>>> +	}
>>>> +
>>>> +	ret = t7xx_port_send_skb(port, skb, 0, 0);
>>>> +	if (ret)
>>>> +		goto err_out;
>>> We don't allow using debugfs to pass random data from user space
>>> to firmware in networking. You need to find another way.
>>
>> Can we use debugfs to send an "on" or "off" commands, wherein the driver
>> then sends special command sequences to the the firmware triggering the
>> modem logging on and off?
> On/off for all logging or for particular types of messages?
> If it's for all logging can't the act of opening the debugfs
> file be used as on "on" signal and closing as "off"?
>
> Where do the logging messages go?

It would be "on/off" for all logging.
Yes, opening the debugfs file can be used for "on" and closing for "off" 
without needing to use copy_from_user.

Logging messages would go to the relay interface file for consumption by 
a user application.

