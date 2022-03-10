Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DB84D4C45
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244470AbiCJOyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347158AbiCJOue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:50:34 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7388918F201;
        Thu, 10 Mar 2022 06:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646923547; x=1678459547;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=QaPegg1jNSdooo38T77D3oKrBjhFtC11zzudIxnPRLo=;
  b=Lfha/SC6mGJLFFRe8FbDBC8jFAwjZe7h2OxcU7Q+vYTLN16Xg8FBTLdz
   HTiZbCUKXfYnRKhwGFjr8V8iX3ig+Y1Ua+DU5xa1XtepvVoVtpDsTCdjv
   bbwNAbx5NNf45cRXIbc0Kgv35IdvY86oWYaj8VySrPFwXebPhf6KM00/p
   JiF+dhPQy4MqONAUxbjgitm322CbGm0P8qG05q/p7g56uDcmqr8F7MnC/
   bZjAT7YgLhvSFjA4jAWyygip7LhHJQ4EEG0RdWls4BYU5koMrN0eMOiSG
   WgvOettJwRJ5mfffihZlPCGR2WBjhanDcTenhzM69ckcm/8/1XaoZtj2P
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="252830990"
X-IronPort-AV: E=Sophos;i="5.90,170,1643702400"; 
   d="scan'208";a="252830990"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 06:45:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,170,1643702400"; 
   d="scan'208";a="644464959"
Received: from aubrey-app.sh.intel.com (HELO [10.239.53.25]) ([10.239.53.25])
  by orsmga004.jf.intel.com with ESMTP; 10 Mar 2022 06:45:42 -0800
Subject: Re: [PATCH v1 0/6] Add TDX Guest Attestation support
To:     Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
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
From:   Aubrey Li <aubrey.li@linux.intel.com>
Message-ID: <93767fe9-9edd-8e31-c3ca-155bfa807915@linux.intel.com>
Date:   Thu, 10 Mar 2022 22:45:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220222231735.268919-1-sathyanarayanan.kuppuswamy@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/2/23 上午7:17, Kuppuswamy Sathyanarayanan wrote:
> Hi All,
> 
> Intel's Trust Domain Extensions (TDX) protect guest VMs from malicious
> hosts and some physical attacks. VM guest with TDX support is called
> as TD Guest.
> 
> In TD Guest, the attestation process is used to verify the 
> trustworthiness of TD guest to the 3rd party servers. Such attestation
> process is required by 3rd party servers before sending sensitive
> information to TD guests. One usage example is to get encryption keys
> from the key server for mounting the encrypted rootfs or secondary drive.
>     
> Following patches add the attestation support to TDX guest which
> includes attestation user interface driver, user agent example, and
> related hypercall support.
> 
> In this series, only following patches are in arch/x86 and are
> intended for x86 maintainers review.
> 
> * x86/tdx: Add TDREPORT TDX Module call support
> * x86/tdx: Add GetQuote TDX hypercall support
> * x86/tdx: Add SetupEventNotifyInterrupt TDX hypercall support
> * x86/tdx: Add TDX Guest event notify interrupt vector support
> 
> Patch titled "platform/x86: intel_tdx_attest: Add TDX Guest attestation
> interface driver" adds the attestation driver support. This is supposed
> to be reviewed by platform-x86 maintainers.
> 
> Also, patch titled "tools/tdx: Add a sample attestation user app" adds
> a testing app for attestation feature which needs review from
> bpf@vger.kernel.org.
> 
> Dependencies:
> --------------
> 
> This feature has dependency on TDX guest core patch set series.
> 
> https://lore.kernel.org/all/20220218161718.67148-1-kirill.shutemov@linux.intel.com/T/

Does this feature also have dependency on QEMU tdx support?

> 
> History:
> ----------
> 
> Previously this patch set was sent under title "Add TDX Guest
> Support (Attestation support)". In the previous version, only the
> attestation driver patch was reviewed and got acked. Rest of the
> patches need to be reviewed freshly.
> 
> https://lore.kernel.org/bpf/20210806000946.2951441-1-sathyanarayanan.kuppuswamy@linux.intel.com/
> 
> Changes since previous submission:
>  * Updated commit log and error handling in TDREPORT, GetQuote and
>    SetupEventNotifyInterrupt support patches.
>  * Added locking support in attestation driver.
> 
> Kuppuswamy Sathyanarayanan (6):
>   x86/tdx: Add tdx_mcall_tdreport() API support
>   x86/tdx: Add tdx_hcall_get_quote() API support
>   x86/tdx: Add SetupEventNotifyInterrupt TDX hypercall support
>   platform/x86: intel_tdx_attest: Add TDX Guest attestation interface
>     driver
>   x86/tdx: Add TDX Guest event notify interrupt vector support
>   tools/tdx: Add a sample attestation user app
> 
>  arch/x86/coco/tdx.c                           | 170 ++++++++++++
>  arch/x86/include/asm/hardirq.h                |   4 +
>  arch/x86/include/asm/idtentry.h               |   4 +
>  arch/x86/include/asm/irq_vectors.h            |   7 +-
>  arch/x86/include/asm/tdx.h                    |   5 +
>  arch/x86/kernel/irq.c                         |   7 +
>  drivers/platform/x86/intel/Kconfig            |   1 +
>  drivers/platform/x86/intel/Makefile           |   1 +
>  drivers/platform/x86/intel/tdx/Kconfig        |  13 +
>  drivers/platform/x86/intel/tdx/Makefile       |   3 +
>  .../platform/x86/intel/tdx/intel_tdx_attest.c | 241 ++++++++++++++++++
>  include/uapi/misc/tdx.h                       |  37 +++
>  tools/Makefile                                |  13 +-
>  tools/tdx/Makefile                            |  19 ++
>  tools/tdx/attest/.gitignore                   |   2 +
>  tools/tdx/attest/Makefile                     |  24 ++
>  tools/tdx/attest/tdx-attest-test.c            | 240 +++++++++++++++++
>  17 files changed, 784 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/platform/x86/intel/tdx/Kconfig
>  create mode 100644 drivers/platform/x86/intel/tdx/Makefile
>  create mode 100644 drivers/platform/x86/intel/tdx/intel_tdx_attest.c
>  create mode 100644 include/uapi/misc/tdx.h
>  create mode 100644 tools/tdx/Makefile
>  create mode 100644 tools/tdx/attest/.gitignore
>  create mode 100644 tools/tdx/attest/Makefile
>  create mode 100644 tools/tdx/attest/tdx-attest-test.c
> 

