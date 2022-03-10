Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5484D4D00
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343675AbiCJPIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345496AbiCJPIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:08:19 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4433E1081B3;
        Thu, 10 Mar 2022 06:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646924300; x=1678460300;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7G2fSsO6atF49CySwf2ewvaCvBVI0nCqa72M1BYrlqo=;
  b=gg8QpQ1ynq14p8MCWg9BNd+0wWSwL4DRuGQJ0SfUf0xjOSx5Bi6UXaU6
   Rnmculj+fyevhYRRE9Oz1L7DV1xhF6W4qwuMBHlP8AkcpogLtpOkVE/8G
   7mK9owN4+Rz/yj+8zaDliZ0HB/Zvu8I+ZZhmeESiCtOumXhyh8Uf4/4V5
   v8ggxsVev2rX9AeLQ2DuWOPu2FiunDz/XWf37KDvdRb3U0agDomQvhafd
   U3DeznStdtejBGkcDj0EkHMUqAvI4bqUbCtqqquOcrnr9qRVh/rIrkIrH
   5Ol93SpseCrPEqtYBUmup7GcWwXq7qC0gGn0BDLPOnLL/+dxj+JZ7QKp5
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="237436853"
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="237436853"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 06:57:55 -0800
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="538483108"
Received: from cpatricx-mobl.amr.corp.intel.com (HELO [10.212.255.151]) ([10.212.255.151])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 06:57:54 -0800
Message-ID: <8587f16c-d171-ba47-aaa1-dcec77e86d2c@linux.intel.com>
Date:   Thu, 10 Mar 2022 06:57:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH v1 4/6] platform/x86: intel_tdx_attest: Add TDX Guest
 attestation interface driver
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
 <20220222231735.268919-5-sathyanarayanan.kuppuswamy@linux.intel.com>
 <369eb270-92c5-1788-127e-bb31f2a51680@linux.intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <369eb270-92c5-1788-127e-bb31f2a51680@linux.intel.com>
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



On 3/10/22 6:55 AM, Aubrey Li wrote:
> There seems to be a mismatch with
> https://github.com/intel/qemu-tdx/blob/tdx/target/i386/kvm/tdx.c#L1262
> 
> It looks like qemu expects a tdx_get_quote_header before the raw TDREPORT data?

Yes, this is a recent change. I have modified the attestation test app
to accommodate it. It will be submitted in next version.

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
