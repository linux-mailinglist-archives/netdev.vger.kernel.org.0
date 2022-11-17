Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD6962E272
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 18:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240328AbiKQRB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 12:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240452AbiKQRBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 12:01:34 -0500
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEFA76160;
        Thu, 17 Nov 2022 09:01:16 -0800 (PST)
Received: by mail-wr1-f50.google.com with SMTP id y16so4829605wrt.12;
        Thu, 17 Nov 2022 09:01:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TCtKsbdbGCL0+efRLWW3g52mJNVL+7oDz6rW5IEN9zQ=;
        b=FVWcwWwIlSooynuz4s9nJ0yRdsAIXNlvau1VbDoEGl6z0ynrsuZdPrmvC7PFaNOOVE
         ftLVTJFxpEDHGFUK6peRxtUT9HXYjYNGDFdCf29HC7DM7o41Dpxe06aGa9ZlRkUsF+GV
         BknVoWh2hilFO5oDxUH6yaj1mDtROK4EZ5AgVbEOW2cj24u/3V2sMIBuLQU+EtNdzekH
         mrKaAenbTBgcsGBvDHX8RJFbNAltNxsVRQMjv1mEcq54M/DhCcxTTOu0xpsuE0NmsbAJ
         IuTC/8P8lAFhcwrcHPEkPqYUwVJyWjMqgfgCNrzCO38cyBLXJnpVEPQMal7bF0eQ4Z7O
         PnYA==
X-Gm-Message-State: ANoB5pndIEjBoLtvnyb9t8f5NKFC/KBEWONktrwtt9kPu727Tc6Liepm
        FtZiv0WtswZzYwry/hn18pI=
X-Google-Smtp-Source: AA0mqf7E6EBcNgl7/0rKpmjSNjeqcv15ZypUN6Bh7EtNRf6vRUVAjnCbO/f4FevAbKhhgNYSiA+ZCw==
X-Received: by 2002:a05:6000:61a:b0:236:8a38:66f1 with SMTP id bn26-20020a056000061a00b002368a3866f1mr2043698wrb.327.1668704470746;
        Thu, 17 Nov 2022 09:01:10 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id r4-20020a05600c35c400b003c6b874a0dfsm2164698wmq.14.2022.11.17.09.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 09:01:10 -0800 (PST)
Date:   Thu, 17 Nov 2022 17:01:03 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     Wei Liu <wei.liu@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "jane.chu@oracle.com" <jane.chu@oracle.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: Re: [Patch v3 13/14] PCI: hv: Add hypercalls to read/write MMIO space
Message-ID: <Y3Zoz2VcpXlhlazS@liuwe-devbox-debian-v2>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-14-git-send-email-mikelley@microsoft.com>
 <Y3ZQVpkS0Hr4LsI2@liuwe-devbox-debian-v2>
 <SN6PR2101MB16939A620AE1C8C7D98816A5D7069@SN6PR2101MB1693.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR2101MB16939A620AE1C8C7D98816A5D7069@SN6PR2101MB1693.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 04:14:44PM +0000, Michael Kelley (LINUX) wrote:
> From: Wei Liu <wei.liu@kernel.org> Sent: Thursday, November 17, 2022 7:17 AM
> >
> > On Wed, Nov 16, 2022 at 10:41:36AM -0800, Michael Kelley wrote:
> > [...]
> > >
> > > +static void hv_pci_read_mmio(struct device *dev, phys_addr_t gpa, int size, u32
> > *val)
> > > +{
> > > +	struct hv_mmio_read_input *in;
> > > +	struct hv_mmio_read_output *out;
> > > +	u64 ret;
> > > +
> > > +	/*
> > > +	 * Must be called with interrupts disabled so it is safe
> > > +	 * to use the per-cpu input argument page.  Use it for
> > > +	 * both input and output.
> > > +	 */
> > 
> > Perhaps adding something along this line?
> > 
> > 	WARN_ON(!irqs_disabled());
> > 
> > I can fold this in if you agree.
> 
> These two new functions are only called within this module from code
> that already has interrupts disabled (as added in Patch 14 of the series),
> so I didn't do the extra check.  But I'm OK with adding it.  These functions
> make a hypercall, so the additional check doesn't have enough perf
> impact to matter.

Okay, not adding them is fine too.

Thanks,
Wei.
