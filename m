Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110FB644C74
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 20:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiLFTXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 14:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiLFTXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 14:23:00 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C864B65C1;
        Tue,  6 Dec 2022 11:22:59 -0800 (PST)
Received: from zn.tnic (p200300ea9733e7ff329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7ff:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 381411EC0523;
        Tue,  6 Dec 2022 20:22:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1670354577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=PpHLRqc8XLUfoQnYBqYUJLgGKbD1hU1U01mFEABewLc=;
        b=ip6kQ8WwF0mpXQ0La9KuqUE3MOTKrEo5TeF5wuPansskXmkFbbjaXWaMlnJnwVEvbeAdQj
        mtzRq21pzGgnhBSdO5H2XDf2BDv2JuktLnh6D2JSp5w/oc9CSKKcJ6iGHj2dVQ8e+2FNp1
        Q/0Lr3NS4jicx7cJTpdg+i54pwa1LqQ=
Date:   Tue, 6 Dec 2022 20:22:52 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
Subject: Re: [Patch v4 01/13] x86/ioapic: Gate decrypted mapping on
 cc_platform_has() attribute
Message-ID: <Y4+WjB/asSvxXW/t@zn.tnic>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
 <1669951831-4180-2-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1669951831-4180-2-git-send-email-mikelley@microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 07:30:19PM -0800, Michael Kelley wrote:
> Current code always maps the IO-APIC as shared (decrypted) in a
> confidential VM. But Hyper-V guest VMs on AMD SEV-SNP with vTOM
> enabled use a paravisor running in VMPL0 to emulate the IO-APIC.
> In such a case, the IO-APIC must be accessed as private (encrypted).

Lemme see I understand this correctly:

the paravisor is emulating the IO-APIC in the lower range of the address
space, under the vTOM which is accessed encrypted.

That's why you need to access it encrypted in the guest.

Close?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
