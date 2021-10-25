Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D204394AE
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 13:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhJYLYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 07:24:03 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:35623 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhJYLW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 07:22:59 -0400
Received: by mail-wm1-f47.google.com with SMTP id 84-20020a1c0457000000b003232b0f78f8so12778652wme.0;
        Mon, 25 Oct 2021 04:20:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jlGpSAspkabd1CBRf3wOMeuw9ekgHDwWbfgDd4L4Pmo=;
        b=cJFGCF6wChm1PKA9EqaVvm62HO9Fg3zkPHTg43sLaqZ2FxKDLrSZkQyHZQa6TMX5mF
         TXmhbB3POOqCdW8w4JBPSuQAelkDTfKqG5H5eQc6XSklPC7u3xYzWRk+/mxs6XexsxAM
         HsY/T2hexvsjyFRUm4CWg0qelWrLh1XviqekPShWp97iF3yKNNK/OKmMaFlFJiBCbHa2
         gJcYF3AeAlDCHN700iUlig2Ag+qx4ypW4gD0RmF/kPxlGKgVwCZYBRVGBN9SFwvfw4fv
         p9o3Z8tHepf9UKm7PEAKD1WA5t01kC62yVkeEEBhw8+qcoLfGXJqI3iGuP88e//swxrG
         lmsA==
X-Gm-Message-State: AOAM530ZsWeR4rsSMIf5v7L1ByhFTO99lmhbX3QiDCGwSFwGfuATmVk+
        hulbWBS8+SAmUEXXajGQ/eI=
X-Google-Smtp-Source: ABdhPJxOD8l7t1pxirZMFfL27LzJZ/aVBiiSMiOCWM0OpPk22nL9FXAMtDtAGlRR7nqZiUAy7ovAzQ==
X-Received: by 2002:a05:600c:3b82:: with SMTP id n2mr14465885wms.50.1635160835970;
        Mon, 25 Oct 2021 04:20:35 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id o40sm10381489wms.10.2021.10.25.04.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 04:20:35 -0700 (PDT)
Date:   Mon, 25 Oct 2021 11:20:33 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     Borislav Petkov <bp@alien8.de>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        kuba@kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de,
        brijesh.singh@amd.com, jroedel@suse.de, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, rientjes@google.com, pgonda@google.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, saravanand@fb.com, aneesh.kumar@linux.ibm.com,
        hannes@cmpxchg.org, tj@kernel.org, michael.h.kelley@microsoft.com,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: Re: [PATCH V8 5/9] x86/sev-es: Expose sev_es_ghcb_hv_call() to call
 ghcb hv call out of sev code
Message-ID: <20211025112033.eqelx54p2dmlhykw@liuwe-devbox-debian-v2>
References: <20211021154110.3734294-1-ltykernel@gmail.com>
 <20211021154110.3734294-6-ltykernel@gmail.com>
 <YXGTwppQ8syUyJ72@zn.tnic>
 <00946764-7fe0-675f-7b3e-9fb3b8e3eb89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00946764-7fe0-675f-7b3e-9fb3b8e3eb89@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 09:39:48PM +0800, Tianyu Lan wrote:
> On 10/22/2021 12:22 AM, Borislav Petkov wrote:
> > On Thu, Oct 21, 2021 at 11:41:05AM -0400, Tianyu Lan wrote:
> > > diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> > > index ea9abd69237e..368ed36971e3 100644
> > > --- a/arch/x86/kernel/sev-shared.c
> > > +++ b/arch/x86/kernel/sev-shared.c
> > > @@ -124,10 +124,9 @@ static enum es_result verify_exception_info(struct ghcb *ghcb, struct es_em_ctxt
> > >   	return ES_VMM_ERROR;
> > >   }
> > > -static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> > > -					  struct es_em_ctxt *ctxt,
> > > -					  u64 exit_code, u64 exit_info_1,
> > > -					  u64 exit_info_2)
> > > +enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb, bool set_ghcb_msr,
> > > +				   struct es_em_ctxt *ctxt, u64 exit_code,
> > > +				   u64 exit_info_1, u64 exit_info_2)
> > >   {
> > >   	/* Fill in protocol and format specifiers */
> > >   	ghcb->protocol_version = GHCB_PROTOCOL_MAX;
> > > @@ -137,7 +136,15 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> > >   	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
> > >   	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
> > > -	sev_es_wr_ghcb_msr(__pa(ghcb));
> > > +	/*
> > > +	 * Hyper-V unenlightened guests use a paravisor for communicating and
> > > +	 * GHCB pages are being allocated and set up by that paravisor. Linux
> > > +	 * should not change ghcb page pa in such case and so add set_ghcb_msr
> > 
> > "... not change the GHCB page's physical address."
> > 
> > Remove the "so add... " rest.
> > 
> > Otherwise, LGTM.
> > 
> > Do you want me to take it through the tip tree?
> 
> Yes, please and this patch is based on the your clean up patch which is
> already in the tip sev branch.

Borislav, please take the whole series via the tip tree if possible.
That's perhaps the easiest thing for both of us because the rest of the
series depends on this patch. Or else I will have to base hyperv-next on
the tip tree once you merge this patch.

Let me know what you think.

Thanks,
Wei.
