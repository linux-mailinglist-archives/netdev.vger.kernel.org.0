Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3258C62E1FC
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 17:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240425AbiKQQep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 11:34:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240341AbiKQQeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 11:34:20 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D998B5BD42
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 08:32:04 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id w23so2073491ply.12
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 08:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y9CVDfHX+ht3pe9PoZgShRnEuMK3hhYjUL+PhteMYLs=;
        b=f/q9dbYV9KIClED5x6XtnNH9OBcIoYvpVlY3B8f7i0gA+unFTY0qNc4wR8aIGoXTrT
         rtw+8cfJhy5Qza7fbjpkC+luhVdAYjWJuUet1bg8OVb/V98lJ1qBftWPC1VPNWyZtibz
         6sRgxWBE2yoShXjcUM9Ugr7rntaliexeg8YjtupMP2ZG1G3AGrEQzZCKaRlakNdoR9HJ
         ICnuOTPJVhQur77Ec83ZeeoLqeaQWIt11K3f5W91Npt26VtuNXMms15xGcz2GRSYgksD
         LaZ62GhBy3dwvAxldgN57cZKNCROlQJp8qt9pfYixbMd+q4BfRhxdsoercr8tXDSLUy8
         8Sfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y9CVDfHX+ht3pe9PoZgShRnEuMK3hhYjUL+PhteMYLs=;
        b=z0FfILpotP7y0k3a0m7QKR7JEAC/z/23H1UHyrY07ONNhFd420ODssdWVxrFlQwhob
         Nmq+v7rGO+jphPxNpbzzKNrdGNW3OTzNK7hkZ74umgxdzJZDVbyDX6HLi0D64YoxJWUM
         hxWwULIBjKhML3yvnrnjCFziiVNgvxes3/v399Ekq+nV/Fhb30Axe4tl/i6ZfrlYwd0w
         9p3ELL7/Z+Er5i/xhDIIN/M8NMvNFLU1BokUESGsDnTeo75UdAQylzkPSM8x/DlE+fai
         5RH//30YCmWfA9H2l5GdcOTEv9WzS68y2dbPQE51D4pjqDXhmOikSBpJq6/glWMMyFqI
         FjZw==
X-Gm-Message-State: ANoB5pnJ41lfFj7J0i6Pfo61WKZOxIFOWHP2cOUjTztbP8GkOPKknWOT
        fJV0adLuNp9x+GPPYrHHGVn09A==
X-Google-Smtp-Source: AA0mqf41sG/xf71mLgHjciiG592ZXvC0SB+A5zP4I/x7n/699zzfKplULxnAHjLteW5fbWVaokc20w==
X-Received: by 2002:a17:90b:710:b0:20a:2547:907 with SMTP id s16-20020a17090b071000b0020a25470907mr9733486pjz.37.1668702724236;
        Thu, 17 Nov 2022 08:32:04 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u15-20020a170902e80f00b001869581f7ecsm1628090plg.116.2022.11.17.08.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 08:32:03 -0800 (PST)
Date:   Thu, 17 Nov 2022 16:32:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Liu <wei.liu@kernel.org>
Cc:     Michael Kelley <mikelley@microsoft.com>, hpa@zytor.com,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lpieralisi@kernel.org, robh@kernel.org, kw@linux.com,
        bhelgaas@google.com, arnd@arndb.de, hch@infradead.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, tony.luck@intel.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arch@vger.kernel.org, iommu@lists.linux.dev
Subject: Re: [Patch v3 13/14] PCI: hv: Add hypercalls to read/write MMIO space
Message-ID: <Y3ZiAE+t6+ZptUuo@google.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-14-git-send-email-mikelley@microsoft.com>
 <Y3ZQVpkS0Hr4LsI2@liuwe-devbox-debian-v2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3ZQVpkS0Hr4LsI2@liuwe-devbox-debian-v2>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022, Wei Liu wrote:
> On Wed, Nov 16, 2022 at 10:41:36AM -0800, Michael Kelley wrote:
> [...]
> >  
> > +static void hv_pci_read_mmio(struct device *dev, phys_addr_t gpa, int size, u32 *val)
> > +{
> > +	struct hv_mmio_read_input *in;
> > +	struct hv_mmio_read_output *out;
> > +	u64 ret;
> > +
> > +	/*
> > +	 * Must be called with interrupts disabled so it is safe
> > +	 * to use the per-cpu input argument page.  Use it for
> > +	 * both input and output.
> > +	 */

There's no need to require interrupts to be disabled to safely use a per-cpu
variable, simply disabling preemption also provides the necessary protection.
And this_cpu_ptr() will complain with CONFIG_DEBUG_PREEMPT=y if preemption isn't
disabled.

IIUC, based on the existing code, what is really be guarded against is an IRQ arriving
and initiating a different hypercall from IRQ context, and thus corrupting the page
from this function's perspective.

> Perhaps adding something along this line?
> 
> 	WARN_ON(!irqs_disabled());

Given that every use of hyperv_pcpu_input_arg except hv_common_cpu_init() disables
IRQs, what about adding a helper to retrieve the pointer and assert that IRQs are
disabled?  I.e. add the sanity for all usage, not just this one-off case.

And since CPUHP_AP_ONLINE_DYN => hv_common_cpu_init() runs after scheduling is
activated by CPUHP_AP_SCHED_WAIT_EMPTY, I believe that hv_common_cpu_init() is
theoretically broken.  Maybe someone can look at that when fixing he KVM vs.
Hyper-V issue?

https://lore.kernel.org/linux-hyperv/878rkqr7ku.fsf@ovpn-192-136.brq.redhat.com
https://lore.kernel.org/all/87sfikmuop.fsf@redhat.com
