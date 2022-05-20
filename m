Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B623452F1CB
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 19:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352308AbiETRnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 13:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237892AbiETRnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 13:43:09 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CEE108AA1
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 10:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653068588; x=1684604588;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wVM63kQ5b3T7v0Zr10tKjC6/g9v8GcXrc9O2OZ5YjF4=;
  b=m0RTsHNS8VvpZ3D8tk/h6PDaz3h7Z2gEYoL/gLl7R712P1OnJYkeCX9Z
   LnqIVdrlGUXDH3XvwVu4xcaz2qNFJs7oDlnsr8cOO9F64UOeBM8TrVdUO
   YYXzrkEuk7bpAL8FaKL/+3cU1IXZU9WOiOwQMRwF4LO9qX8F6WquDFBLD
   JamB9u1SLQzQYv1j5TbKtskP8ReQtavakrTLk0N0skGwJ658NIYnYQ+Ez
   +/qRKcJBqxfrzWwzSS6Y5C/6zIa0knz+nNezNHbesFCjm00MHPXeFd/xX
   9sNQm7MowsAswr0U4CalDAelYxG323eDYd2bHwO6oPXN/jCwbbtaHn1tA
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="335737940"
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="335737940"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 10:43:08 -0700
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="743601180"
Received: from vckummar-mobl.amr.corp.intel.com (HELO [10.209.85.227]) ([10.209.85.227])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 10:43:07 -0700
Message-ID: <34c7de82-e680-1c61-3696-eb7929626b51@linux.intel.com>
Date:   Fri, 20 May 2022 10:42:56 -0700
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
From:   "moises.veleta" <moises.veleta@linux.intel.com>
In-Reply-To: <20220520103711.5f7f5b45@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/20/22 10:37, Jakub Kicinski wrote:
> On Thu, 19 May 2022 11:27:03 -0700 Moises Veleta wrote:
>> +	ret = copy_from_user(skb_put(skb, actual_len), buf, actual_len);
>> +	if (ret) {
>> +		ret = -EFAULT;
>> +		goto err_out;
>> +	}
>> +
>> +	ret = t7xx_port_send_skb(port, skb, 0, 0);
>> +	if (ret)
>> +		goto err_out;
> We don't allow using debugfs to pass random data from user space
> to firmware in networking. You need to find another way.


Can we use debugfs to send an "on" or "off" commands, wherein the driver 
then sends special command sequences to the the firmware triggering the 
modem logging on and off?

