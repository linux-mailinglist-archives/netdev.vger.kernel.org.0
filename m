Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506493C1D8D
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 04:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhGICq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 22:46:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:36767 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230336AbhGICqZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 22:46:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10039"; a="231399821"
X-IronPort-AV: E=Sophos;i="5.84,225,1620716400"; 
   d="scan'208";a="231399821"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 19:43:42 -0700
X-IronPort-AV: E=Sophos;i="5.84,225,1620716400"; 
   d="scan'208";a="564861698"
Received: from npujari-mobl.amr.corp.intel.com (HELO skuppusw-mobl5.amr.corp.intel.com) ([10.213.167.42])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 19:43:41 -0700
Subject: Re: [PATCH v2 5/6] platform/x86: intel_tdx_attest: Add TDX Guest
 attestation interface driver
To:     Dan Williams <dan.j.williams@intel.com>,
        Andi Kleen <ak@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Peter H Anvin <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        X86 ML <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org, bpf@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>
References: <20210707204249.3046665-1-sathyanarayanan.kuppuswamy@linux.intel.com>
 <20210707204249.3046665-6-sathyanarayanan.kuppuswamy@linux.intel.com>
 <CAPcyv4h8SaVL_QGLv1DT0JuoyKmSBvxJQw0aamMuzarexaU7VA@mail.gmail.com>
 <24d8fd58-36c1-0e89-4142-28f29e2c434b@linux.intel.com>
 <CAPcyv4heA8gps2K_ckUV1gGJdjGeB+5dOSntS=TREEX5-0rtwQ@mail.gmail.com>
 <4972fc1a-1ffb-2b6d-e764-471210df96a3@linux.intel.com>
 <CAPcyv4gwsT4rJzemkofk6SP5cAp9=nr5T6vtu+i6wTbU91R_Bg@mail.gmail.com>
 <ca608162-2a48-0816-4302-c2a5b2766a7a@linux.intel.com>
 <CAPcyv4jPqv43Hh836bpDUwMYAsPHDrjUhXoJ0Ufgjbqc3h2eyQ@mail.gmail.com>
From:   "Kuppuswamy, Sathyanarayanan" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Message-ID: <4b22be93-a401-6b96-48e1-18a71a6a17bc@linux.intel.com>
Date:   Thu, 8 Jul 2021 19:43:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jPqv43Hh836bpDUwMYAsPHDrjUhXoJ0Ufgjbqc3h2eyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/21 7:04 PM, Dan Williams wrote:
> Ok, not my first choice for how to handle the allocation side of that,
> but not broken.
> 
> I'd still feel better if there was an actual data structure assigned
> to file->private_data rather than using that 'void *' pointer directly
> and casting throughout the driver.

We can add a data structure if we have more member requirements. Currently
we only need to pass the memory pointer. But after moving memory allocation
to init code (even for vmap), we may not need to use this private pointer.

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
