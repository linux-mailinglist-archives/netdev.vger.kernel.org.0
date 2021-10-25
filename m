Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942E343A51B
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbhJYU5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:57:15 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:45772 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbhJYU5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 16:57:02 -0400
Received: by mail-wr1-f46.google.com with SMTP id a16so13883330wrh.12;
        Mon, 25 Oct 2021 13:54:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fljl4WgLX/RcDUKivgrEUuWkkPxadHqWT4JD6/OvqJY=;
        b=sFqn0yL7Mayf0ddqrpsW8P+8nWh9qqGkoorufwgMJ/8xxQ6Bnv09iREaIE5S5FWCl4
         InMDinUBf3eg15K5JjfSJvPnhazovpIlIASorlsdhdg8wwkxsos+waGiC/vG0AAd4TF9
         Y5sFFdwb5DoiquhPd0BNr5Ks36BTKgWApXpcEge1pWSiCIjLH4bfVfwuHHwC81EyMu08
         w2BJLszalEKeMtbNWVkRSawMgESPEKPyN/abFJ8XCbU+PTGCpAQM4fXXvHoyWb6R8VCX
         IOhkzyIh0s+NaJnUoCRWm3h01xh6xMyyLMO1JMhmFf2Mb2v6IcYArXO/3V3gkNw8zxJy
         f9EA==
X-Gm-Message-State: AOAM531RJNxTveVtG/utVIG0/XSh/GI6mf8aLyn1mMigx1GVQiois3ME
        Gex6pybJV5c9jfgvX2FIl2k=
X-Google-Smtp-Source: ABdhPJwJqAHyUNYlwokS65gx98+Xc0CWlqIMhvB9ZZLYxbfducvvrDped5qEYEt67ILVs8SMgZqnhA==
X-Received: by 2002:a05:6000:1b90:: with SMTP id r16mr25878748wru.153.1635195278570;
        Mon, 25 Oct 2021 13:54:38 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id m9sm441723wrx.39.2021.10.25.13.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 13:54:38 -0700 (PDT)
Date:   Mon, 25 Oct 2021 20:54:36 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Tianyu Lan <ltykernel@gmail.com>, Wei Liu <wei.liu@kernel.org>,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
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
Message-ID: <20211025205436.febcnpnky3xybojz@liuwe-devbox-debian-v2>
References: <20211021154110.3734294-1-ltykernel@gmail.com>
 <20211021154110.3734294-6-ltykernel@gmail.com>
 <YXGTwppQ8syUyJ72@zn.tnic>
 <00946764-7fe0-675f-7b3e-9fb3b8e3eb89@gmail.com>
 <20211025112033.eqelx54p2dmlhykw@liuwe-devbox-debian-v2>
 <YXaT5HcLoX59jZH2@zn.tnic>
 <f5b6f9e8-5888-bd5f-143f-a7b12ec17bbb@gmail.com>
 <YXbdV8N51hMMsP6X@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXbdV8N51hMMsP6X@zn.tnic>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 06:37:43PM +0200, Borislav Petkov wrote:
> On Mon, Oct 25, 2021 at 08:27:39PM +0800, Tianyu Lan wrote:
> >       I just sent out v9 version and compile hv ghcb related functions
> > when CONFIG_AMD_MEM_ENCRYPT is selected. The sev_es_ghcb_hv_call()
> > stub is not necessary in the series and remove it. Please have a look
> > and give your ack if it's ok. Then Wei can merge it through Hyper-V
> > next branch.
> 
> I have merged it after running a bunch of randbuild tests and had to fix
> one or two:
> 
> https://git.kernel.org/tip/007faec014cb5d26983c1f86fd08c6539b41392e
> 
> From my POV that branch is not going to change anymore so Wei can now
> merge this tip branch - tip:x86/sev - and write a proper merge commit
> message explaining why he's merging a tip branch and then apply the rest
> of the HyperV stuff ontop.

Thanks Borislav.

> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
