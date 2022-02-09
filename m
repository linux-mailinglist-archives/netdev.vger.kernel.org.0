Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733C34AF8F2
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 19:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbiBISEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 13:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbiBISED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 13:04:03 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0E1C0613C9
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 10:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644429846; x=1675965846;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=m+slI4yh82AWCulu6c9KfVHPaB3OAPtNKp6XyfgS5+g=;
  b=QRJ8IGJCipaGYV36Cx4PEraKxir1KBddFUuqNr4Dm9boB936sd6xy/hK
   Wd9xc00ZAqOPmiCJWDom7/V+rNWjZATqHE99AuyRcmlYUBXPaFYUsC2tQ
   tc9GpvS8a7tcpUflvJhCj+iYZxvPsjopABXeDSk3kWEb9V6Qcn/btkfMc
   tPwWdZj1kUkeRic0/WNpg2T4dYZA7mL0Z4KqC8HbFIIRG3iWIXSXsWaaH
   8hngkLhr8WcO/iVJBCT3BHvvilCxj6k7iqL3Xod/Z9bC10tLyRLebW7Bn
   +kBqQYTUZKvvlRp+WY8mbdPdjz5VeeNwNQ0vPdOGPwzXTZpkLDcu01xqV
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="229255646"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="229255646"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 10:04:06 -0800
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="541219685"
Received: from mszycik-mobl.ger.corp.intel.com (HELO [10.252.60.98]) ([10.252.60.98])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 10:04:03 -0800
Message-ID: <fd23700b-4269-a615-a73d-10476ffaf82d@linux.intel.com>
Date:   Wed, 9 Feb 2022 19:04:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [RFC PATCH net-next v3 1/5] gtp: Allow to create GTP device
 without FDs
Content-Language: en-US
To:     Harald Welte <laforge@osmocom.org>
Cc:     netdev@vger.kernel.org, michal.swiatkowski@linux.intel.com,
        wojciech.drewek@intel.com, davem@davemloft.net, kuba@kernel.org,
        pablo@netfilter.org, osmocom-net-gprs@lists.osmocom.org
References: <20220127163749.374283-1-marcin.szycik@linux.intel.com>
 <20220127163900.374645-1-marcin.szycik@linux.intel.com>
 <Yf6nBDg/v1zuTf8l@nataraja>
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
In-Reply-To: <Yf6nBDg/v1zuTf8l@nataraja>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harald,

Sorry for long delay in reply.

On 05-Feb-22 17:34, Harald Welte wrote:
> Hi Marcin, Wojciech,
> 
> thanks for the revised patch. In general it looks fine to me.
> 
> Do you have a public git tree with your patchset applied?  I'm asking as
> we do have automatic testing in place at https://jenkins.osmocom.org/ where I
> just need to specify a remote git repo andit will build this kernel and
> run the test suite.

I've created a public fork with our patchset applied, please see [1].

> 
> Some minor remarks below, all not critical, just some thoughts.
> 
> It might make sense to mention in the commit log that this patch by itself
> would create GTP-U without GTP ECHO capabilities, and that a subsequent
> patch will address this.
> 
>> This patch allows to create GTP device without providing
>> IFLA_GTP_FD0 and IFLA_GTP_FD1 arguments. If the user does not
>> provide file handles to the sockets, then GTP module takes care
>> of creating UDP sockets by itself. 
> 
> I'm wondering if we should make this more explicit, i.e. rather than
> implicitly creating the kernel socket automagically, make this mode
> explicit upon request by some netlink attribute.
> 
>> Sockets are created with the
>> commonly known UDP ports used for GTP protocol (GTP0_PORT and
>> GTP1U_PORT).
> 
> I'm wondering if there are use cases that need to operate on
> non-standard ports.  The current module can be used that way (as the
> socket is created in user space). If the "kernel socket mode" was
> requested explicitly via netlink attribute, one could just as well
> pass along the port number[s] this way.
> 

[1] https://github.com/mszycik/linux/tree/cpk_switchdev_gtp
