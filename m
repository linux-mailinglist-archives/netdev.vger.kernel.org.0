Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19B83DD61C
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 14:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbhHBM45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 08:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbhHBM4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 08:56:55 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D4BC061760;
        Mon,  2 Aug 2021 05:56:46 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so13938206pjb.2;
        Mon, 02 Aug 2021 05:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/GYPS7X+85wR6YC8425aJSok3ZXyi4U2bTyYNUsfO5w=;
        b=pyQkhPeDqOZN1lKQvpgjaZhDuqcfBH++qI9Yz80iquDkO6oGt+tBuSPtyV0nMGVBJ1
         M2E5aA/XAnoteOyDQT8M+x5AliZKopkoGnInKwL3m2QqBiWDu36W26gL/YPC8K/KeYlr
         lKiZUAf6XKEOBg70NsE3K9fU4mOPUUIoCYKqtgQQ2HjvRH1Q+CjUYFOowxeVCbfkbnu7
         GXswmjuYPprsxcXIE4NienyvsAMjibDdMeps+gxmOrpMJQUHeDF7e/9b+DgNRmsrf0dj
         R82WDqtlRqQuveuh5cTGWXuurfZKwGo+CrnXy7KJkYXeft1AWFi82RFU5cJODZER7tHh
         HwOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/GYPS7X+85wR6YC8425aJSok3ZXyi4U2bTyYNUsfO5w=;
        b=rrQnvroREh2lzghJkvH2U/ojYO3L0NmRV7JJFuYQUXDTIqPGYR6Rcij7ihjFmzgNJQ
         mkdaOkLN1jYbe5o32gpwVSeeujdufvy3hKZaUXkRTqNpIskdgh5zN/Ndwyay3hZvIyrL
         n+Dn7iGXruIGy5LNhbFluSoNHOfha6Oj+Mw0pYbERbZ5Mcoo8rza+5NER0XsnryI+w40
         C7g+fONcn788RhZd0MEVV4pHdjPTzWDrGP83kg6BsdzLptgypFvOG/dmNOyDR0l/vUWu
         HZhI+snNNzdulBGXoHqTsp1ZGxsVowjZ2IlTPvalbDHT7/XJRUnncPksy0YflbysJYI5
         TU7Q==
X-Gm-Message-State: AOAM533ThRRBnRAPRb96QhFcxQ0mzS4Ya2ROpZpS1VCxA/Mpof/3bP/V
        qap4wV5zVSIH2t8/CssSYe0=
X-Google-Smtp-Source: ABdhPJyLDEEPYFYa8bCYhczgLUorbl2lwmF46SVfXQIXh/rESGtdQ+84YDRl3Rg46/KGbl2xu2SCOw==
X-Received: by 2002:a17:902:b48b:b029:12c:59b:dc44 with SMTP id y11-20020a170902b48bb029012c059bdc44mr14086944plr.47.1627909005643;
        Mon, 02 Aug 2021 05:56:45 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id g7sm6679837pfv.66.2021.08.02.05.56.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 05:56:45 -0700 (PDT)
Subject: Re: [PATCH 04/13] HV: Mark vmbus ring buffer visible to host in
 Isolation VM
To:     Joerg Roedel <joro@8bytes.org>
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
 <20210728145232.285861-5-ltykernel@gmail.com> <YQfgH04t2SqacnHn@8bytes.org>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <173823d1-280c-d34e-be2c-157b55bb6bc3@gmail.com>
Date:   Mon, 2 Aug 2021 20:56:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQfgH04t2SqacnHn@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/2021 8:07 PM, Joerg Roedel wrote:
> On Wed, Jul 28, 2021 at 10:52:19AM -0400, Tianyu Lan wrote:
>> +	if (type == HV_GPADL_BUFFER)
>> +		index = 0;
>> +	else
>> +		index = channel->gpadl_range[1].gpadlhandle ? 2 : 1;
> 
> Hmm... This doesn't look very robust. Can you set fixed indexes for
> different buffer types? HV_GPADL_BUFFER already has fixed index 0. But
> as it is implemented here you risk that index 2 gets overwritten by
> subsequent calls.

Both second and third are HV_GPADL_RING type. One is send ring and the
other is receive ring. The driver keeps the order to allocate rx and
tx buffer. You are right this is not robust and will add a mutex to keep
the order.
