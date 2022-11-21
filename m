Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7ED632712
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 15:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbiKUO4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 09:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiKUO4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 09:56:06 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A9ECDFD5;
        Mon, 21 Nov 2022 06:46:27 -0800 (PST)
Received: from zn.tnic (p200300ea9733e725329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e725:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 728E61EC071C;
        Mon, 21 Nov 2022 15:46:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669041985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xCGd6hIfxBt7cfQnfEqxSw7FPCqLC4Ck4a/q2jKRpXs=;
        b=LYt3r1VGYpjFq2eY/1Ig8EB3IqiCf4tNl8mN6dMAnrQpepWGDiaxtPiv4BXj0A6jaCD+Kg
        K6ao66qLGGIogTA7O/cDGBLmoMgFJB0PO40fxjVY3RQwJbP6X4+tmXifRdjlV9jvmVnhxt
        RisyrBR0wBFbkpZYBwrRyZoAITaTgGY=
Date:   Mon, 21 Nov 2022 15:46:25 +0100
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
Subject: Re: [Patch v3 06/14] init: Call mem_encrypt_init() after Hyper-V
 hypercall init is done
Message-ID: <Y3uPQTKDnD+/tv6g@zn.tnic>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-7-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1668624097-14884-7-git-send-email-mikelley@microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 10:41:29AM -0800, Michael Kelley wrote:
> Fix this by moving mem_encrypt_init() after late_time_init() and
> related clock initializations. The intervening initializations don't
> do any I/O that requires the swiotlb, so moving mem_encrypt_init()
> slightly later has no impact.

I hope you're right. Our boot ordering is fragile as hell. But
mem_encrypt_init() doesn't do a whole lot of important setup - that has
happened a lot earlier already - so I'm not too worried.

But we'll see what breaks in wider testing.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
