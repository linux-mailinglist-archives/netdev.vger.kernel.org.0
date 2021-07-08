Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB46A3C14DF
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 16:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbhGHOKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 10:10:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:3830 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229592AbhGHOKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 10:10:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="206494882"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="206494882"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 07:07:28 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="492127379"
Received: from palgarin-mobl.amr.corp.intel.com (HELO skuppusw-mobl5.amr.corp.intel.com) ([10.212.55.207])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 07:07:27 -0700
Subject: Re: [PATCH v2 1/6] x86/tdx: Add TDREPORT TDX Module call support
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Peter H Anvin <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210707204249.3046665-1-sathyanarayanan.kuppuswamy@linux.intel.com>
 <20210707204249.3046665-2-sathyanarayanan.kuppuswamy@linux.intel.com>
 <d9aac97c-aa08-de9f-fa44-91b7dde61ce3@intel.com>
From:   "Kuppuswamy, Sathyanarayanan" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Message-ID: <46944ac2-4841-7f1d-4f54-ecb477f43d63@linux.intel.com>
Date:   Thu, 8 Jul 2021 07:07:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d9aac97c-aa08-de9f-fa44-91b7dde61ce3@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/21 1:16 AM, Xiaoyao Li wrote:
> 
> Sorry I guess I didn't state it clearly during internal review.
> 
> I suggest something like this
> 
> if (ret != TDCALL_SUCCESS) {
>      if (TDCALL_RETURN_CODE(ret) == TDCALL_INVALID_OPERAND)
>          return -EINVAL;
>      else if (TDCALL_RETURN_CODE(ret) == TDCALL_OPERAND_BUSY)
>          return -EBUSY;
>      else
>          return -EFAULT; //I'm not sure if -EFAULT is proper.
> }

As per current spec, TDCALL_INVALID_OPERAND, TDCALL_OPERAND_BUSY and
0 are the only possible return values. So I have checked for failure case
in if condition and returned success by default. Any reason for specifically
checking for success code ?

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
