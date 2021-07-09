Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87363C1CD5
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 02:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhGIAl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 20:41:26 -0400
Received: from mga06.intel.com ([134.134.136.31]:16188 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhGIAl0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 20:41:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10039"; a="270737872"
X-IronPort-AV: E=Sophos;i="5.84,225,1620716400"; 
   d="scan'208";a="270737872"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 17:38:42 -0700
X-IronPort-AV: E=Sophos;i="5.84,225,1620716400"; 
   d="scan'208";a="458088979"
Received: from akleen-mobl1.amr.corp.intel.com (HELO [10.212.178.170]) ([10.212.178.170])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 17:38:41 -0700
Subject: Re: [PATCH v2 5/6] platform/x86: intel_tdx_attest: Add TDX Guest
 attestation interface driver
To:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
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
From:   Andi Kleen <ak@linux.intel.com>
Message-ID: <ce0feeec-a949-35f8-3010-b0d69acbbc2e@linux.intel.com>
Date:   Thu, 8 Jul 2021 17:38:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <169451ef-e8f6-5a07-f47a-61eaa085b4ef@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Expensive and permanently fractures the direct map.
>
> I'm struggling to figure out why the direct map is even touched here.
I think Sathya did it this way because the TD interface requires a 
physical address.
> Why not just use a vmalloc area mapping?  You really just need *a*
> decrypted mapping to the page.  You don't need to make *every* mapping
> to the page decrypted.

Yes it would be possible to use vmap() on the page and only set the vmap 
encrypted by passing the right flags directly.

That would avoid breaking up the direct mapping.


-Andi


