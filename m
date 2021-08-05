Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C263E16DA
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 16:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241639AbhHEOYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 10:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241561AbhHEOYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 10:24:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37F5C061765;
        Thu,  5 Aug 2021 07:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zMcKhJ07Z0yEyEv/MZ8pR7li72ad4G0VC4wqCeDkbDY=; b=TD34VTK+iYD0kPSz+/0OveJNoB
        4+17Vc+fWYh1VivpiO7E9EkWZq6sNs5roxK4DdylTJY6XWHXJgfTYWiBdIfRapTigjsHHeVewCB7D
        1ZubSz5VFqO5VB8cuo+g+qOxMduOo92Hc5cDvqxW47UBcFyNgvLvLSq4NLrdLGJu0+nLA7SNk7TY9
        IszYqQfinEAXUDDKXtXAFihhqOa7rUvGHGIIdZyisOXOukZM7AbTS5ppYc/gYtPaTKKUrvHqjEJLl
        R4PXAFIkUGmwTfkVvjp+CIdYdTsNaKp7Qun2UYMo0dF0viDkVLDaUQsmtvm981wJR2qzcyfXcIIyy
        45SAAq6Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mBeHd-0079h6-MS; Thu, 05 Aug 2021 14:23:43 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 412973002C1;
        Thu,  5 Aug 2021 16:23:41 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1E329201DCD23; Thu,  5 Aug 2021 16:23:41 +0200 (CEST)
Date:   Thu, 5 Aug 2021 16:23:41 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        Tianyu.Lan@microsoft.com, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        brijesh.singh@amd.com, thomas.lendacky@amd.com, pgonda@google.com,
        david@redhat.com, krish.sadhukhan@oracle.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, xen-devel@lists.xenproject.org,
        martin.b.radev@gmail.com, ardb@kernel.org, rientjes@google.com,
        tj@kernel.org, keescook@chromium.org,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, parri.andrea@gmail.com
Subject: Re: [PATCH V2 03/14] x86/set_memory: Add x86_set_memory_enc static
 call support
Message-ID: <YQv0bRBUq1N5+jgG@hirez.programming.kicks-ass.net>
References: <20210804184513.512888-1-ltykernel@gmail.com>
 <20210804184513.512888-4-ltykernel@gmail.com>
 <5823af8a-7dbb-dbb0-5ea2-d9846aa2a36a@intel.com>
 <942e6fcb-3bdf-9294-d3db-ca311db440d3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <942e6fcb-3bdf-9294-d3db-ca311db440d3@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 10:05:17PM +0800, Tianyu Lan wrote:
>  static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>  {
> +	return static_call(x86_set_memory_enc)(addr, numpages, enc);
>  }

Hurpmh... So with a bit of 'luck' you get code-gen like:

__set_memory_enc_dec:
	jmp __SCT_x86_set_memory_enc;

set_memory_encrypted:
	mov $1, %rdx
	jmp __set_memory_enc_dec

set_memory_decrypted:
	mov $0, %rdx
	jmp __set_memory_enc_dec


Which, to me, seems exceedingly daft. Best to make all 3 of those
inlines and use EXPORT_STATIC_CALL_TRAMP_GPL(x86_set_memory_enc) or
something.

This is assuming any of this is actually performance critical, based off
of this using static_call() to begin with.
