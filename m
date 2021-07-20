Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6093D03CD
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 23:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbhGTUit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 16:38:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:42193 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236662AbhGTUfd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 16:35:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="211328752"
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="211328752"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 14:16:09 -0700
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="632441016"
Received: from akleen-mobl1.amr.corp.intel.com (HELO [10.212.245.156]) ([10.212.245.156])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 14:16:08 -0700
Subject: Re: [PATCH v3 5/6] platform/x86: intel_tdx_attest: Add TDX Guest
 attestation interface driver
To:     Dave Hansen <dave.hansen@intel.com>,
        "Kuppuswamy, Sathyanarayanan" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
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
References: <20210720045552.2124688-1-sathyanarayanan.kuppuswamy@linux.intel.com>
 <20210720045552.2124688-6-sathyanarayanan.kuppuswamy@linux.intel.com>
 <eddc318e-e9c9-546d-6cff-b3c40062aecd@intel.com>
 <4c43dfe4-e44b-9d6d-b012-63790bb47b19@linux.intel.com>
 <52caa0e2-d3da-eef0-da5f-e83cc54c133c@intel.com>
From:   Andi Kleen <ak@linux.intel.com>
Message-ID: <4f8dc9dd-0dbc-bff9-570b-0d20f673d3f0@linux.intel.com>
Date:   Tue, 20 Jul 2021 14:16:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <52caa0e2-d3da-eef0-da5f-e83cc54c133c@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/20/2021 10:59 AM, Dave Hansen wrote:
> On 7/20/21 10:52 AM, Kuppuswamy, Sathyanarayanan wrote:
>>> Why does this need to use the page allocator directly?
> ^^ You didn't address this question.


The address needs to be naturally aligned, and I'm not sure all slab 
allocators guarantee 64 byte alignment. So using the page allocator 
seems to be safer. I guess a comment would be good.


-Andi

