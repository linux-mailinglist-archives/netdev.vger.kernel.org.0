Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82065B656C
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 04:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiIMCMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 22:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiIMCMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 22:12:12 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E62113CDA;
        Mon, 12 Sep 2022 19:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663035131; x=1694571131;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mo0emAiOJ18klsHjvFTruZ4gWXQXs6molcKd5bmMm9s=;
  b=MDOWNzeZrqH4atszv54GWpEBw2Eq9exezvsAfe/2fyN/lT1qx+llU24e
   IaLMSooGAbUqcwVHH3Eu1f7ypWUewzaSIYYdFFpyxxBDPX7R5TQijEocw
   /veVBQQD57Uew1iTrXDVRZa5jLG7gkE+mKAYuu455fDGQz1z2IdsU5XUQ
   JuWMXGyyP6mvT4nfdZVyJx1PTEq04edu3Ja7zq/kXUO+NoIqdiZ6rADq7
   ikNKUYLjzatsIeljJcVMyiQIiZyp14L2fL4e0AGlhIBjOPVbkt5qxIXxs
   gOYX/8tZaSN7B8zyInr0E0YZYXYpUGDxtN8ZGKjotHDZ6t0AoOZj2aNUc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="361967153"
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="361967153"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 19:12:11 -0700
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="593739044"
Received: from jiaqingz-mobl.ccr.corp.intel.com (HELO [10.249.172.208]) ([10.249.172.208])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 19:12:09 -0700
Message-ID: <36c12486-57d4-c11d-474f-f26a7de8e59a@linux.intel.com>
Date:   Tue, 13 Sep 2022 10:12:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] net/ncsi: Add Intel OS2BMC OEM command
To:     Paul Fertser <fercerpav@gmail.com>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        openbmc@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20220909025716.2610386-1-jiaqing.zhao@linux.intel.com>
 <YxrWPfErV7tKRjyQ@home.paul.comp>
 <8eabb29b-7302-d0a2-5949-d7aa6bc59809@linux.intel.com>
 <Yxrun9LRcFv2QntR@home.paul.comp>
Content-Language: en-US
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
In-Reply-To: <Yxrun9LRcFv2QntR@home.paul.comp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-09-09 15:43, Paul Fertser wrote:
> Hello,
> 
> On Fri, Sep 09, 2022 at 03:34:53PM +0800, Jiaqing Zhao wrote:
>>> Can you please outline some particular use cases for this feature?
>>>
>> It enables access between host and BMC when BMC shares the network connection
>> with host using NCSI, like accessing BMC via HTTP or SSH from host. 
> 
> Why having a compile time kernel option here more appropriate than
> just running something like "/usr/bin/ncsi-netlink --package 0
> --channel 0 --index 3 --oem-payload 00000157200001" (this example uses
> another OEM command) on BMC userspace startup?
> 

Using ncsi-netlink is one way, but the package and channel id is undetermined
as it is selected at runtime. Calling the netlink command on a nonexistent
package/channel may lead to kernel panic.

Why I prefer the kernel option is that it applies the config to all ncsi
devices by default when setting up them. This reduces the effort and keeps
compatibility. Lots of things in current ncsi kernel driver can be done via
commands from userspace, but I think it is not a good idea to have a driver
resides on both kernel and userspace.
