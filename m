Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6146B271F
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbjCIOiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbjCIOhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:37:18 -0500
Received: from mail.8bytes.org (mail.8bytes.org [IPv6:2a01:238:42d9:3f00:e505:6202:4f0c:f051])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5745CE825D;
        Thu,  9 Mar 2023 06:37:02 -0800 (PST)
Received: from 8bytes.org (p5b006afb.dip0.t-ipconnect.de [91.0.106.251])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id D346522612F;
        Thu,  9 Mar 2023 15:36:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1678372607;
        bh=YEVQxyXVIWhtxmM89JVtDEvi45tG9UXS9RSbGs8FK7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xCatCVjyEy4xQJHvjjbD2l9cMxXCXww3G7LEduHxM1vfuSPjxWRZg2kYog+LA0Wnk
         bAJrDbNQKKKbVV0Z3qrDvbqaZrCPE641s9105ZPbxhOLLA4uIfNZgZhLveaHzUOoFw
         ttR8WZFVJf9vZNlw8vQ43LUzsdU0ovlLOyu3NwD5+Kto4lKnZRokXfwpAcfsrYqMAC
         xXNHm1ZsKNVrU9YJK+NO1cvqS4pfNCf1VyYdeJ/BF9ebc7KhCajE0fNygY9zIJkQNd
         utNI0fJbSTdI1Y1uWTaEyB1W1JZ1HJUUfwT7eEkvsINHZcyAsOmlj/fCs7Q8UetRov
         2n+MpjSTBe+gQ==
Date:   Thu, 9 Mar 2023 15:36:45 +0100
From:   =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        David Woodhouse <dwmw2@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
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
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "jane.chu@oracle.com" <jane.chu@oracle.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: Re: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Message-ID: <ZAnu/Um+4qq4Owuh@8bytes.org>
References: <Y/adN3GQJTdDPmS8@google.com>
 <Y/ammgkyo3QVon+A@zn.tnic>
 <Y/a/lzOwqMjOUaYZ@google.com>
 <Y/dDvTMrCm4GFsvv@zn.tnic>
 <BYAPR21MB1688F68888213E5395396DD9D7AB9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <255249f2-47af-07b7-d9d9-9edfdd108348@intel.com>
 <20230306215104.GEZAZgSPa4qBBu9lRd@fat_crate.local>
 <a23a36ccb8e1ad05e12a4c4192cdd98267591556.camel@infradead.org>
 <20230309115937.GAZAnKKRef99EwOu/S@fat_crate.local>
 <a4fc8686-f82d-370e-309f-d6d3fc0568e8@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4fc8686-f82d-370e-309f-d6d3fc0568e8@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 08:19:58AM -0600, Tom Lendacky wrote:
> I believe Joerg added that key for performance reasons, since it is used on
> the exception path and can avoid all the calls to cc_platform_has(). I think
> that key should stay.

Yes, that is right. The key is mainly for the NMI entry path which can
be performance relevant in some situations. For SEV-ES some special
handling is needed there to re-enable NMIs and adjust the #VC stack in
case it was raised on the VC-handlers entry path.

Regards,

	Joerg
