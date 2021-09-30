Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05EFE41E13F
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 20:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245167AbhI3Sfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 14:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhI3Sfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 14:35:33 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E195CC06176A;
        Thu, 30 Sep 2021 11:33:50 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0e160042ff9e72dd33ffc9.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:1600:42ff:9e72:dd33:ffc9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4D7001EC0531;
        Thu, 30 Sep 2021 20:33:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1633026829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=mKafYKu2L6ScClp7GA/OUijqYHN57nrEQkXpftg3Ak0=;
        b=r3v0g/iKj0jUiBnH0rcU3VsWsLBnYdTVDy1wgC5crwocRr5xGWgmo9UMkVJMj0/N/MvCfK
        WtV3el2mda980dgWzStndneIDNVbzNr1WsulU7qp9TNBiYIHoeNaEHeDqdHptPYSv+IqgV
        cgNEXah3g1hq/NTzRJjTVgwn9VQ0Sgo=
Date:   Thu, 30 Sep 2021 20:33:44 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Tianyu Lan <ltykernel@gmail.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        kuba@kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de,
        brijesh.singh@amd.com, jroedel@suse.de, Tianyu.Lan@microsoft.com,
        pgonda@google.com, akpm@linux-foundation.org, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, rientjes@google.com, tj@kernel.org,
        michael.h.kelley@microsoft.com, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        konrad.wilk@oracle.com, hch@lst.de, robin.murphy@arm.com,
        joro@8bytes.org, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: Re: [PATCH V6 5/8] x86/hyperv: Add Write/Read MSR registers via ghcb
 page
Message-ID: <YVYDCHavgLb6WFiM@zn.tnic>
References: <20210930130545.1210298-1-ltykernel@gmail.com>
 <20210930130545.1210298-6-ltykernel@gmail.com>
 <0f33ca85-f1c6-bab3-5bdb-233c09f86621@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0f33ca85-f1c6-bab3-5bdb-233c09f86621@amd.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 01:27:20PM -0500, Tom Lendacky wrote:
> > +	if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1)
> 
> Really, any non-zero value indicates an error, so this should be:
> 
> 	if (ghcb->save.sw_exit_info_1 & 0xffffffff)

That's ok but that should be a separate patch - first patch splits the
function and second changes the functionality.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
