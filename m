Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0066C52F56D
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 00:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbiETWA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 18:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbiETWA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 18:00:28 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC30018C059
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 15:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653084027; x=1684620027;
  h=message-id:date:mime-version:subject:to:references:from:
   cc:in-reply-to:content-transfer-encoding;
  bh=B7fQyzDp3iLa1Qiz9wr2JduewOqs8PyLWCZGPv1Z9rI=;
  b=j40UdKErf8NN6ssmj1uzNd7EITq+lZdhc6y7zwPpG3qY+SK2bcWSgT/c
   lV+vM31mWKtIczTO34y9mTXV/8iziPny6UuSS8RdEspHHlc3e/Fuj/Vvz
   rjyGIwX1WeJyUcGCAAOyGYyqbN/7pvPh0j+SH6hBbOiLGuud2OPTkJxoY
   Wf7jWpT3TD4kxuKXxYYvh+TUE4lZMAJWJKNTuhrLhLATxzx09eYxflVEh
   Ogy0VQGLo0AEhHjLRDqMHrhNrUpoU/+kdsw+AEZyDyNphBONKZvH15SRj
   GsX/X+3Np1V3cLZUbKSuTsSotLHsK1dl58RAhoyRfKyQn79TP+4j1Gvyf
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="359156152"
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="359156152"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 15:00:27 -0700
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="576394865"
Received: from vckummar-mobl.amr.corp.intel.com (HELO [10.209.85.227]) ([10.209.85.227])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 15:00:26 -0700
Message-ID: <96352703-17b1-bc0b-2a54-e9651bf21b55@linux.intel.com>
Date:   Fri, 20 May 2022 15:00:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next 1/1] net: wwan: t7xx: Add port for modem logging
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
References: <20220519182703.27056-1-moises.veleta@linux.intel.com>
 <20220520103711.5f7f5b45@kernel.org>
 <34c7de82-e680-1c61-3696-eb7929626b51@linux.intel.com>
 <20220520104814.091709cd@kernel.org>
 <09ce56a3-3624-13f9-6065-1367db5b8a6a@linux.intel.com>
 <20220520111541.30c96965@kernel.org>
 <dc07d0a9-793b-5b76-cf10-d8fad77c04ea@linux.intel.com>
 <20220520144630.56841d21@kernel.org>
From:   "moises.veleta" <moises.veleta@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, m.chetan.kumar@intel.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        haijun.liu@mediatek.com, andriy.shevchenko@linux.intel.com,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        sreehari.kancharla@intel.com, dinesh.sharma@intel.com
In-Reply-To: <20220520144630.56841d21@kernel.org>
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


On 5/20/22 14:46, Jakub Kicinski wrote:
> On Fri, 20 May 2022 12:16:19 -0700 moises.veleta wrote:
>> On 5/20/22 11:15, Jakub Kicinski wrote:
>>> On Fri, 20 May 2022 11:01:31 -0700 moises.veleta wrote:
>>>> On 5/20/22 10:48, Jakub Kicinski wrote:
>>>>> On Fri, 20 May 2022 10:42:56 -0700 moises.veleta wrote:
>>>>>> Can we use debugfs to send an "on" or "off" commands, wherein the driver
>>>>>> then sends special command sequences to the the firmware triggering the
>>>>>> modem logging on and off?
>>>>> On/off for all logging or for particular types of messages?
>>>>> If it's for all logging can't the act of opening the debugfs
>>>>> file be used as on "on" signal and closing as "off"?
>>>>>
>>>>> Where do the logging messages go?
>>>> It would be "on/off" for all logging.
>>>> Yes, opening the debugfs file can be used for "on" and closing for "off"
>>>> without needing to use copy_from_user.
>>> Sounds good. Can we also divert the actual logs so that they can be
>>> read out of that debugfs file? That'd feel most natural to me..
>>>
>>>> Logging messages would go to the relay interface file for consumption by
>>>> a user application.
>>> What's the relay interface? a special netdev? chardev? tty?
>>>
>> The relay interface is a 'relay channel' where a userspace applications
>> can read from and retrieve data as it becomes available. The driver
>> would relay modem logs to this created channel file.
>>
>> https://www.kernel.org/doc/html/latest/filesystems/relay.html
> The API for this thing seems confusing, does it not give the kernel
> side any signal that user space has attached / shown interest in the
> data?
>
> If not a simple debugfs file which only accepts on/off or 0/1 SGTM.

For modem logging, the driver is relaying the logs (a large amount 
varying on modem traffic) to the relay interface file that will be 
overwritten if not consumed. It does not care if the user application is 
reading them or not. That is up to the user application to read and process.

The IOSM driver in WWAN uses this relay interface & debugfs combination, 
in a similar fashion, please see "iosm_ipc_trace.c" for their 
implementation. Should have mentioned that earlier, pardon the terseness.

