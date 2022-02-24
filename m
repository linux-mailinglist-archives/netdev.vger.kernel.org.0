Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA69C4C304C
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 16:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbiBXPtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 10:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233935AbiBXPtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 10:49:15 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592F1B821C;
        Thu, 24 Feb 2022 07:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645717725; x=1677253725;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZZjGgYtRs7sm8n89V+YPONIkPGKkfnMdwvJnWV+kU4I=;
  b=kP7A3UuotaKNvO6HFh9oYGHnnSAfpQxgazJqq4qMTFE1XNVnQKo6pNAQ
   PE8kZFbTERZyvC/PYNTvfQzSl8ApubreJKSh7DrBW4nsNwvGE7Er0BxXh
   G0+AzNPpsEKbiLUoGYrrQbRo4NGl+hTgzby1FawzwqeTSZD1oVg90OIrz
   0SrdBIOKl3Vk55KD8K1j7gao5YOTd1KTuHScMBZC8rjKQno1vVy+288cg
   5iw9afoo/sZoM5BBA9phnWIlwpz5NkWiJcuHnwgdSaSPKtx62uj5BSICA
   MsZI9djKVSsaZ2qZm7IuEk7tadMQnVlPqgz3pOwWpu6VxXXUosRpIVs53
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="251996304"
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="251996304"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 07:48:30 -0800
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="548798013"
Received: from rsit-mobl.amr.corp.intel.com (HELO [10.209.25.56]) ([10.209.25.56])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 07:48:29 -0800
Message-ID: <4b3e0e05-5721-ba96-2c5a-b7683a992d13@linux.intel.com>
Date:   Thu, 24 Feb 2022 07:48:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH v1 0/6] Add TDX Guest Attestation support
Content-Language: en-US
To:     Hans de Goede <hdegoede@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Mark Gross <mgross@linux.intel.com>,
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
 <202e0882-35a6-766b-6c4a-137abd199247@redhat.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <202e0882-35a6-766b-6c4a-137abd199247@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/24/22 7:32 AM, Hans de Goede wrote:
>> Patch titled "platform/x86: intel_tdx_attest: Add TDX Guest attestation
>> interface driver" adds the attestation driver support. This is supposed
>> to be reviewed by platform-x86 maintainers.
> At a quick glance this looks ok to me, but I really know very little
> about TDX. I assume the rest of the series will be reviewed by someone
> with more detailed knowledge of TDX as such I believe it would be good
> if the platform/x86 patch is also reviewed as part of that.
> 
> Since the platform/x86 patch depends on the other patches I believe
> it is also best if the entire series is merged in one go by the x86/tip
> maintainers here is my ack for this:
> 
> Acked-by: Hans de Goede<hdegoede@redhat.com>

Thanks.

> 
>> Also, patch titled "tools/tdx: Add a sample attestation user app" adds
>> a testing app for attestation feature which needs review from
>> bpf@vger.kernel.org.
> I think that tool should be moved to tools/arch/x86/tdx regardless of
> moving it, tools are typically reviewed together with the kernel side
> and this has nothing to do with bpf.

I am fine with moving it to tools/arch/x86/*. I will do it in next
version. I have included bpf because this is what I got out of
./scripts/get_maintainer.pl.

> 
> Regards,
> 
> Hans
> 

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
