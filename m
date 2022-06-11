Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4701854722D
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 07:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348251AbiFKFTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 01:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiFKFS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 01:18:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778EEBE6;
        Fri, 10 Jun 2022 22:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654924736; x=1686460736;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DUPTlnLt/iLP3iWZV9PCtpnzKffFuUerVcMAVnD9HIg=;
  b=IzWcLWsZrJBiFuyQ/tzaGRIXTVJvjWx7vmsCK3mN8ACl7ehf+woyKNnX
   DiwsRlAZJLnx/OB1jkRjQZEi8erC+MA3cWDGbfPgqIzfFcaIPfCTZIByQ
   hy7/M2GVJiXGboTN0j4sz4WhNNPBWbzF8GM8KKc3TUqjKhrTC06VXCxtc
   cEcL4GHdI9t0EGV77TrPSusgaRxnfNU/9zCCmm+NjAD2j27RJx0fxcOZv
   gkDEe57v6TxrH6xaUUJxenTJ2RYMvi1Ca8VeYMYmevcKRbY7lYlQxPHL5
   xn9SIYKKHByiEUNtRcNIz3uoGDAfU0GfE+L7UTcp6tn0k3qOKWscorZgD
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="260941788"
X-IronPort-AV: E=Sophos;i="5.91,292,1647327600"; 
   d="scan'208";a="260941788"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 22:18:55 -0700
X-IronPort-AV: E=Sophos;i="5.91,292,1647327600"; 
   d="scan'208";a="638540757"
Received: from jiaqingz-mobl.ccr.corp.intel.com (HELO [10.255.31.17]) ([10.255.31.17])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 22:18:53 -0700
Message-ID: <6f067302-74a8-702f-bf38-4477a805a528@linux.intel.com>
Date:   Sat, 11 Jun 2022 13:18:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 0/6] Configurable VLAN mode for NCSI driver
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
References: <20220610165940.2326777-1-jiaqing.zhao@linux.intel.com>
 <20220610130903.0386c0d9@kernel.org>
 <3c9fa928-f416-3526-be23-12644d18db3b@linux.intel.com>
 <20220610214506.74c3f89c@kernel.org>
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
In-Reply-To: <20220610214506.74c3f89c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-06-11 12:45, Jakub Kicinski wrote:
> On Sat, 11 Jun 2022 11:25:03 +0800 Jiaqing Zhao wrote:
>>> Why is "ncsi,vlan-mode" set via the device tree? Looks like something
>>> that can be configured at runtime.   
>>
>> Actually this cannot be configured at runtime, the NCSI spec defines no
>> command or register to determine which mode is supported by the device.
> 
> To be clear I'm not saying that it should be auto-detected and
> auto-configured. Just that user space can issue a command to change 
> the config.
> 
>> If kernel want to enable VLAN on the NCSI device, either "Filtered tagged
>> + Untagged" (current default) or "Any tagged + untagged" mode should be
>> enabled, but unfortunately both of these two modes are documented to be
>> optionally supported in the spec. And in real cases, there are devices
>> that only supports one of them, or neither of them. So I added the device
>> tree property to configure which mode to use.
> 
> But for a given device its driver knows what modes are supported.
> Is it not possible to make the VLAN mode passed thru ncsi-netlink?
> 
> Better still, can't "Filtered tagged + Untagged" vs "Any tagged +
> untagged" be decided based on netdev features being enabled like it
> is for normal netdevs?

All ncsi devices uses the same driver as they uses same command set,
so the driver doesn't know what modes are supported. And in current
driver, the vlan related parameters are configured when registering
the device, adding an ncsi-netlink command to do so seems to be
unsuitable.

And adding a netlink command requires extra application in userspace
to switch the mode. In my opinion, it would be more user-friendly to
make it usable on boot.

Netdev also does not work as the ncsi device itself does not have
its own netdev, the netdev comes from the mac device. For different
vlan modes, the netdev feature set of its parent mac device are the
same.

