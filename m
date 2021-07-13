Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FDF3C6778
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 02:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbhGMAgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 20:36:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:50764 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230099AbhGMAgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 20:36:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10043"; a="273907575"
X-IronPort-AV: E=Sophos;i="5.84,235,1620716400"; 
   d="scan'208";a="273907575"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 17:33:29 -0700
X-IronPort-AV: E=Sophos;i="5.84,235,1620716400"; 
   d="scan'208";a="629866664"
Received: from atton-mobl.amr.corp.intel.com (HELO skuppusw-mobl5.amr.corp.intel.com) ([10.212.86.233])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 17:33:28 -0700
Subject: Re: [PATCH v2 5/6] platform/x86: intel_tdx_attest: Add TDX Guest
 attestation interface driver
To:     Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Peter H Anvin <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210707204249.3046665-1-sathyanarayanan.kuppuswamy@linux.intel.com>
 <20210707204249.3046665-6-sathyanarayanan.kuppuswamy@linux.intel.com>
 <06c85c19-e16c-3121-ed47-075cfa779b67@kernel.org>
 <169451ef-e8f6-5a07-f47a-61eaa085b4ef@intel.com>
 <ce0feeec-a949-35f8-3010-b0d69acbbc2e@linux.intel.com>
From:   "Kuppuswamy, Sathyanarayanan" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Message-ID: <afba42c2-e925-d937-8893-80f995a143b4@linux.intel.com>
Date:   Mon, 12 Jul 2021 17:33:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ce0feeec-a949-35f8-3010-b0d69acbbc2e@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

On 7/8/21 5:38 PM, Andi Kleen wrote:
>> Expensive and permanently fractures the direct map.
>>
>> I'm struggling to figure out why the direct map is even touched here.
> I think Sathya did it this way because the TD interface requires a physical address.
>> Why not just use a vmalloc area mapping?  You really just need *a*
>> decrypted mapping to the page.  You don't need to make *every* mapping
>> to the page decrypted.
> 
> Yes it would be possible to use vmap() on the page and only set the vmap encrypted by passing the 
> right flags directly.

Is it alright to have non coherent mappings? If yes, any documentation reference for it?

> 
> That would avoid breaking up the direct mapping.

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
