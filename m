Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86F0622130
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 02:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiKIBJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 20:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiKIBJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 20:09:54 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FCE61753;
        Tue,  8 Nov 2022 17:09:53 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id l2so15670720pld.13;
        Tue, 08 Nov 2022 17:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jOb8CdCVvGjEFSrtUYMypDotXZ7Qmr/ylq+lPB8RqYI=;
        b=FbGhI1U07I2Ib7bngG++TzwNALRWAG0ey7HTAkwEHDkP7glq1VjzOOEBTsqy2WRtIe
         vhlu+x25dhyOBCn548HzBbokiqoaSNd2lx6wDF/bHFq9tMs0qT7GumSLBJl0zYNHl3xy
         kMUEnEJmLcQ5GCBAqzrYLn5QroXFP9FIAAozBf87CuD4DFpsRiAjgbEknWZhVDmKOSQm
         rFSYHPwA+WpHr062xQEuJWsNOL1FnNarF517pgTiNSfIy3QVDNnXX713dGqcOcsZgJKr
         zzuXZE9NyLRQvQKrpG4KAV+BIK9hXubYcCzbsZV0OMpXoTZcZiPzEj3yg9UV8xeA2L4j
         kgIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jOb8CdCVvGjEFSrtUYMypDotXZ7Qmr/ylq+lPB8RqYI=;
        b=mZeUBC1/DcHxoKim4Wh9UBREGUS4rJGW7zvGKn6xZLB6vnhN1rqSH+8ToMWQyqgkod
         hrbZ/9Mt/JyxUc3acEtg34LC/6R9nw9ut1AE5ihic8aTBV6NHp17zOB7EjW5hvFKSish
         4jev2CX7I3FrdXArvgVFBfSKqhk1BnK+q3LO+yd/xtm2htsAnPMTLHzJbYItvDlVrju0
         neDZPo0M/g5rADOl+aLLrp8yYO0klU3s3TBsdCoZEy9qpVJDVOr0a7qw69qLTccTVegN
         kO7wo4bVSLDppLkh572v8PzRWLrK80BgJeAF6l9I5D0i0vUfizMayBCAjh5SOtf0e+PM
         ZkvA==
X-Gm-Message-State: ACrzQf2zg9bTgGtEAGkY0JZHg3Ul3WtmOEUvQhKkjW0SIpl5KBqTTYVL
        4pqE21OeecplRq7rS9V2yn4=
X-Google-Smtp-Source: AMsMyM5QmJtSIiQCEKD5mUUNC6x3o97LkqpzN4dvxk0Zr+DUBLK/5FoU74/JfI3A+Ob7hrszMaJdDA==
X-Received: by 2002:a17:902:9891:b0:17d:a81a:5dca with SMTP id s17-20020a170902989100b0017da81a5dcamr1082825plp.15.1667956192963;
        Tue, 08 Nov 2022 17:09:52 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::75b? ([2404:f801:9000:18:efec::75b])
        by smtp.gmail.com with ESMTPSA id n14-20020a17090ac68e00b002135de3013fsm6677073pjt.32.2022.11.08.17.09.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 17:09:52 -0800 (PST)
Message-ID: <845b8952-5bd1-2744-c57d-760494823015@gmail.com>
Date:   Wed, 9 Nov 2022 09:09:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 05/12] x86/hyperv: Change vTOM handling to use standard
 coco mechanisms
Content-Language: en-US
To:     Michael Kelley <mikelley@microsoft.com>, hpa@zytor.com,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
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
References: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
 <1666288635-72591-6-git-send-email-mikelley@microsoft.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <1666288635-72591-6-git-send-email-mikelley@microsoft.com>
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

On 10/21/2022 1:57 AM, Michael Kelley wrote:
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
> * Update Hyper-V initialization to set the cc _mask based on vTOM
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
> * Remove the Hyper-V special case from __set_memory_enc_dec(), and
>    make the normal case active for Hyper-V VMs, which have
>    CC_ATTR_GUEST_MEM_ENCRYPT, but not CC_ATTR_MEM_ENCRYPT.
> 
> [1]https://lore.kernel.org/all/20211025122116.264793-1-ltykernel@gmail.com/
> [2]https://lore.kernel.org/all/20211213071407.314309-1-ltykernel@gmail.com/
> 
> Signed-off-by: Michael Kelley<mikelley@microsoft.com>
> ---

Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
