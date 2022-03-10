Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645424D4C8D
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbiCJPBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345654AbiCJPBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:01:09 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08581195304;
        Thu, 10 Mar 2022 06:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646924070; x=1678460070;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mkDxige9BzHQwc97tN/4qCgRy7VLjwdzDuzdIanGC8g=;
  b=P6zVX1SUZMzvCnBCMbIrP+lUMMeiTtLuQSXCxw4Eb2k0yB9C8Dh8x10M
   ShNySXcbih+V0VXEHD/C2I4AehmElkjyVGu1q9PG4aBHcmN1agdBEUSN5
   ltd2e5s+x828KrHNonWgq0z/P1MZqaXiHA2OUuZ63NZXkZ1epZZgfJgWz
   Cxp2HQi2HBQhcfMLmIhjLGP54K5a+ykYF6Z15YmfjBg5KcrwWNj5halV0
   GI+PYppajRBJxtw/6bZBMMYfMmYfgNqHmpC27AsCd4hxmgwgOZmdBuP5n
   u89WdLp2XrKdTs6aCh9atalT6/Xzz6R5a467axh7En2j+uIWB+oLaOvE7
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="237436159"
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="237436159"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 06:54:29 -0800
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="538481674"
Received: from cpatricx-mobl.amr.corp.intel.com (HELO [10.212.255.151]) ([10.212.255.151])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 06:54:29 -0800
Message-ID: <8c111689-b06e-5803-1f66-e5952231459f@linux.intel.com>
Date:   Thu, 10 Mar 2022 06:54:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH v1 0/6] Add TDX Guest Attestation support
Content-Language: en-US
To:     Aubrey Li <aubrey.li@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     "H . Peter Anvin" <hpa@zytor.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20220222231735.268919-1-sathyanarayanan.kuppuswamy@linux.intel.com>
 <93767fe9-9edd-8e31-c3ca-155bfa807915@linux.intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <93767fe9-9edd-8e31-c3ca-155bfa807915@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/22 6:45 AM, Aubrey Li wrote:
>> This feature has dependency on TDX guest core patch set series.
>>
>> https://lore.kernel.org/all/20220218161718.67148-1-kirill.shutemov@linux.intel.com/T/
> Does this feature also have dependency on QEMU tdx support?
> 

Yes, for end-to-end attestation testing it will have dependency
on QEMU. But for testing the operation of GetQuote and TDREPORT 
TDCALLs/Hypercall, we don't need the QEMU attestation support.

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
