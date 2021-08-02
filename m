Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F84E3DD652
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbhHBNAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233883AbhHBNAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:00:18 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC900C06179F;
        Mon,  2 Aug 2021 06:00:05 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id u2so11218725plg.10;
        Mon, 02 Aug 2021 06:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EeSreHE5hdlnf0oXwm47d4tHu8/yxl93O4VWV6niMlg=;
        b=efFY4vl/l2ivNbm9EOrCQxUa+dPOqt+8w3noLnVCdDetf0McOpBx3fU1tspnDVVuA9
         7Pzv+sfvPIPgVGU0Gqn+pSKd3nKVxLIzug5jkaYAf1sxqB4Sj0UeiEE6tIsKyIsNrbdb
         ZzB+XhOGshwvZxs1k3uAu6PqViC47olBDYUYasFKmXsBP6Tc5r37JShifRbS9KCBLzOo
         ccydI/zYibadoznRJjQWxzc/7VlNTvJt95AEOP6ibHmciLPQPtUqMmcQXmeQ5eZpI1FU
         pyJaLee84JdYVXLzgQtCDJTZdDbbh45idglyEUAoA7BOt7lOK6B0ANXplELatDb4KrR+
         M5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EeSreHE5hdlnf0oXwm47d4tHu8/yxl93O4VWV6niMlg=;
        b=P65vByGAlRukg9JoQcsynBQcQLRMR0WZpbD8oezVcmUsH1c6ZZk97CVsdstebL+ViQ
         Cf6wAwkUct+fLOygJ8S06D2nrg5FXLu3KDN5wF8pA9kTzBEDyoFEu4TJycD6SeggYWgu
         VdpoJxf61NIzg1pwqtFRGZAg1TKHcozKZ7bO5o17E7YrxYEQXhafCTLoN6JoIfMWwir8
         a2/TaWUXwxfTWMvtNleVjdPFhpyqXUPNBBiwzYUTuQe6efjeGquYeZjJ9Onljcphuqsp
         Kw4FQudwrmOS6qQ59DO46NvoK/RFQ0hMnVLWWXUmDrvIa6v8z4uomHsScCMTCJlFI05g
         4V2Q==
X-Gm-Message-State: AOAM530+Xy81g/O6Y/Swz+ItdINiFyLjU4mC/HKNldY5UuBzIYjGF80V
        bgD+2NflFmx4c5qsbgIeWFyXRLG2qcakKbw+
X-Google-Smtp-Source: ABdhPJwQqurl+5kiEreCzf7V/W8FK4cyMJ1mZbyof3Kxoh8aAKG0BtZ6XERTRpAICjuoFK7OauJ+1Q==
X-Received: by 2002:a17:90b:3556:: with SMTP id lt22mr17715473pjb.174.1627909205346;
        Mon, 02 Aug 2021 06:00:05 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id c16sm12058607pfb.196.2021.08.02.05.59.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 06:00:04 -0700 (PDT)
Subject: Re: [PATCH 03/13] x86/HV: Add new hvcall guest address host
 visibility support
To:     Joerg Roedel <joro@8bytes.org>, Dave Hansen <dave.hansen@intel.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, arnd@arndb.de, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, rientjes@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        rppt@kernel.org, kirill.shutemov@linux.intel.com,
        aneesh.kumar@linux.ibm.com, krish.sadhukhan@oracle.com,
        saravanand@fb.com, xen-devel@lists.xenproject.org,
        pgonda@google.com, david@redhat.com, keescook@chromium.org,
        hannes@cmpxchg.org, sfr@canb.auug.org.au,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, anparri@microsoft.com
References: <20210728145232.285861-1-ltykernel@gmail.com>
 <20210728145232.285861-4-ltykernel@gmail.com>
 <c00e269c-da4c-c703-0182-0221c73a76cc@intel.com>
 <YQfepYTC4n6agq9z@8bytes.org>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <996e46e1-6776-6c87-d791-0df6f0aa58dc@gmail.com>
Date:   Mon, 2 Aug 2021 20:59:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQfepYTC4n6agq9z@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/2021 8:01 PM, Joerg Roedel wrote:
> On Wed, Jul 28, 2021 at 08:29:41AM -0700, Dave Hansen wrote:
>> __set_memory_enc_dec() is turning into a real mess.  SEV, TDX and now
>> Hyper-V are messing around in here.
> 
> I was going to suggest a PV_OPS call where the fitting implementation
> for the guest environment can be plugged in at boot. There is TDX and an
> SEV(-SNP) case, a Hyper-V case, and likely more coming up from other
> cloud/hypervisor vendors. Hiding all these behind feature checks is not
> going to make things cleaner.
> 

Yes, that makes sense. I will do this in the next version.
