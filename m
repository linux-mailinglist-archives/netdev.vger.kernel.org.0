Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D363F438478
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 19:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhJWRcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 13:32:09 -0400
Received: from mail.skyhub.de ([5.9.137.197]:55486 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230037AbhJWRcH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Oct 2021 13:32:07 -0400
Received: from zn.tnic (p200300ec2f2bf500debdb0fdbaba34b4.dip0.t-ipconnect.de [IPv6:2003:ec:2f2b:f500:debd:b0fd:baba:34b4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A9A5E1EC01FC;
        Sat, 23 Oct 2021 19:29:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1635010186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=45GSEYozrA6ceNXIM9Vtl2tPbqIpym/GAi+hphvjLik=;
        b=eXYNK94H7HLUf6jjICKv1ghrrFt3DJckkQbAhzjHnoRDdocKXs45y5+f8f1K1+DsajwbMZ
        p2kvrlEmAakg9KLeojR4eXMe3vV9dCEAG0UWgftJDZEkYRjvnHHTUTFnrIsjUJkc6wthGS
        nbjtselR4hNzTYzec+YWA+ueywUR46U=
Date:   Sat, 23 Oct 2021 19:29:43 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "david@redhat.com" <david@redhat.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: Re: [PATCH V8.1 5/9] x86/sev-es: Expose sev_es_ghcb_hv_call() to
 call ghcb hv call out of sev code
Message-ID: <YXRGh0rxtbdFJ31m@zn.tnic>
References: <20211021154110.3734294-6-ltykernel@gmail.com>
 <20211022133721.2123-1-ltykernel@gmail.com>
 <MWHPR21MB1593716CD7DDE1326AC93AD4D7809@MWHPR21MB1593.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <MWHPR21MB1593716CD7DDE1326AC93AD4D7809@MWHPR21MB1593.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 08:58:00PM +0000, Michael Kelley wrote:
> >  static inline void sev_es_ist_enter(struct pt_regs *regs) { }
> >  static inline void sev_es_ist_exit(void) { }
> >  static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh) { return 0; }
> >  static inline void sev_es_nmi_complete(void) { }
> >  static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
> > +static inline enum
> > +es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> > +			      bool set_ghcb_msr, u64 exit_code,
> 
> The "struct es_em_ctxt *ctxt" argument is missing from this declaration,
> which would presumably produce a compile error.

Which raises the more important question: that ivm.c thing which is
going to be that function's user gets enabled unconditionally in
HyperV's Makefile so maybe you guys wanna consider perhaps making that
isolation VM functionality dependent on CONFIG_AMD_MEM_ENCRYPT because
without it, it would be useless.

And if you add that dependency, you probably won't need the stub as
outside of AMD SEV, nothing else will be using that function.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
