Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57D762D159
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 03:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbiKQC7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 21:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiKQC7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 21:59:47 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5FA29C87;
        Wed, 16 Nov 2022 18:59:46 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id l2so344503pld.13;
        Wed, 16 Nov 2022 18:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cI9YYkR2j8+5CF7GfcB2FXJqCD4sST4budEVfbt757Q=;
        b=oACv8HUbmtF4bbCohU0VsqWmMRoz4kTqqUzaSK/NwOkNHBWesmZfRTXxIv9MMqaiL4
         cFkzGXWV0Yhu71xa8W4PvCJG2RM6jQW99Yg97jB9KyTpD0Wwhh/+fRLbvZMymBmYYZBZ
         h63492wB40VNTe6++pCK2OW7ZWtAxZYuJvnb0uqhYpk15FDkJnN+uezx2MuzWfkZnf1B
         X2gCAu3FyQE8utKdqpXZMwIV7afmW4Z5SPDLDQqhmQGt3lsQYTEuLB+KIZ4n7hC5OO2f
         n85EBvnuYWWeGhIKiX4xEHwPs3Vd2h3x2RyqbEaMY1HwDgDpbdBupM0es8ZXjaNcWXQV
         wlgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cI9YYkR2j8+5CF7GfcB2FXJqCD4sST4budEVfbt757Q=;
        b=NRlNaK95KCL91tywqYl0TXieVZ0M5/Zaw6NsRLYsKFojZjWIFBqktJRHsiWma+Q28j
         iVUFTrxZJetDbjwQ1Y5MdmTTrrP58P65PcBfHRgAr53vWhYWimenzwE3BeoHTaNetKod
         qSXV8gRgWlsdB9dV9ivPre2xCWPo03mfC8QCB7OWgGujyaNN0d1YVy7MnkqMbIn/eOVU
         J9CHBJ3rmglEmASvxyU9X0bX6/FRa8xGKwQPlRgcYLo+XRpGSBI9EnQSY8420oG2xs4j
         HTy2d4VcXYrWAqg3Jtxcz1s5LwS3P4z3+dQ64xtVlFsl7mtq72WzyGXGA0VY4j2Q0TFT
         WsLw==
X-Gm-Message-State: ANoB5pkBX8Sui8P98I22e0BGCwr8B3LcqpqlStr7/fyzZJrQKzOHlvaU
        UKhQD5Jyxi3S5e6JiJdtYJ0=
X-Google-Smtp-Source: AA0mqf4vg7BcdWVHlmKhHo0hA6tIGJidHiu9taIeC8ozWjdRQILWPBG5TLa1G3gSVAigRXnEGtIU0w==
X-Received: by 2002:a17:902:db01:b0:187:3921:2b2d with SMTP id m1-20020a170902db0100b0018739212b2dmr909370plx.13.1668653985703;
        Wed, 16 Nov 2022 18:59:45 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::75b? ([2404:f801:9000:1a:efea::75b])
        by smtp.gmail.com with ESMTPSA id n15-20020a170903110f00b00188c5f0f9e9sm8258439plh.199.2022.11.16.18.59.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 18:59:44 -0800 (PST)
Message-ID: <079dc969-37e7-1da0-84cc-9d2e047156d5@gmail.com>
Date:   Thu, 17 Nov 2022 10:59:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [Patch v3 07/14] x86/hyperv: Change vTOM handling to use standard
 coco mechanisms
Content-Language: en-US
To:     Michael Kelley <mikelley@microsoft.com>, hpa@zytor.com,
        kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lpieralisi@kernel.org, robh@kernel.org,
        kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-8-git-send-email-mikelley@microsoft.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <1668624097-14884-8-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/2022 2:41 AM, Michael Kelley wrote:
> Hyper-V guests on AMD SEV-SNP hardware have the option of using the
> "virtual Top Of Memory" (vTOM) feature specified by the SEV-SNP
> architecture. With vTOM, shared vs. private memory accesses are
> controlled by splitting the guest physical address space into two
> halves.  vTOM is the dividing line where the uppermost bit of the
> physical address space is set; e.g., with 47 bits of guest physical
> address space, vTOM is 0x40000000000 (bit 46 is set).  Guest phyiscal
> memory is accessible at two parallel physical addresses -- one below
> vTOM and one above vTOM.  Accesses below vTOM are private (encrypted)
> while accesses above vTOM are shared (decrypted). In this sense, vTOM
> is like the GPA.SHARED bit in Intel TDX.
> 
> Support for Hyper-V guests using vTOM was added to the Linux kernel in
> two patch sets[1][2]. This support treats the vTOM bit as part of
> the physical address. For accessing shared (decrypted) memory, these
> patch sets create a second kernel virtual mapping that maps to physical
> addresses above vTOM.
> 
> A better approach is to treat the vTOM bit as a protection flag, not
> as part of the physical address. This new approach is like the approach
> for the GPA.SHARED bit in Intel TDX. Rather than creating a second kernel
> virtual mapping, the existing mapping is updated using recently added
> coco mechanisms.  When memory is changed between private and shared using
> set_memory_decrypted() and set_memory_encrypted(), the PTEs for the
> existing kernel mapping are changed to add or remove the vTOM bit
> in the guest physical address, just as with TDX. The hypercalls to
> change the memory status on the host side are made using the existing
> callback mechanism. Everything just works, with a minor tweak to map
> the I/O APIC to use private accesses.
> 
> To accomplish the switch in approach, the following must be done in
> in this single patch:
> 
> * Update Hyper-V initialization to set the cc_mask based on vTOM
>    and do other coco initialization.
> 
> * Update physical_mask so the vTOM bit is no longer treated as part
>    of the physical address
> 
> * Update cc_mkenc() and cc_mkdec() to be active for Hyper-V guests.
>    This makes the vTOM bit part of the protection flags.
> 
> * Code already exists to make hypercalls to inform Hyper-V about pages
>    changing between shared and private.  Update this code to run as a
>    callback from __set_memory_enc_pgtable().
> 
> * Remove the Hyper-V special case from __set_memory_enc_dec()
> 
> * Remove the Hyper-V specific call to swiotlb_update_mem_attributes()
>    since mem_encrypt_init() will now do it.
> 
> [1]https://lore.kernel.org/all/20211025122116.264793-1-ltykernel@gmail.com/
> [2]https://lore.kernel.org/all/20211213071407.314309-1-ltykernel@gmail.com/
> 
> Signed-off-by: Michael Kelley<mikelley@microsoft.com>
> ---
>   arch/x86/coco/core.c            | 11 +++++++++-
>   arch/x86/hyperv/hv_init.c       | 11 ----------
>   arch/x86/hyperv/ivm.c           | 45 +++++++++++++++++++++++++++++++----------
>   arch/x86/include/asm/mshyperv.h |  8 ++------
>   arch/x86/kernel/cpu/mshyperv.c  | 15 +++++++-------
>   arch/x86/mm/pat/set_memory.c    |  3 ---
>   6 files changed, 53 insertions(+), 40 deletions(-)

Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
