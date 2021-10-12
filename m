Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5FE42A6EB
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 16:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237191AbhJLOP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236943AbhJLOP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 10:15:57 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC45FC061570;
        Tue, 12 Oct 2021 07:13:55 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y1so13581025plk.10;
        Tue, 12 Oct 2021 07:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NnwqvTRj0woh3E8EshCqUWUgR2UVN04yKDTc5wj96cI=;
        b=GI9XXj/5uxLbMyp8Z4wuPimGYeSjPoyFsqA33pX229q4NEccEYmPA6gFvQecPx7q+Q
         0XPLaV2/clb8higyTzATpmmijhDbfDQm4SHSRgETl0tg2MuXImkxL86x3mZ6e2kfbeu/
         zhSQim6hIpTEv/3i4UzQ7JhMu0N7pBTZ1vG00dymbZxzHAz7oJ3Ph9mTQ0ONYJweoO3V
         fkwhHPCvL0+xm+XZdrQxTh/9qJt0CW5Q+JyufvRsSG08Ql+IxZAbcU/zgHwgwZGFMq1S
         GgIjGapdd7tvC81KRCOWnIee3+Y2+vTxe5wt8h+NxgiZAVNaJj+Ees1TDR63qealCEkU
         ag0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NnwqvTRj0woh3E8EshCqUWUgR2UVN04yKDTc5wj96cI=;
        b=6pxVpte/XaycQXRL0EYUedG9/enf5kScALIEnF8SaoZnDO5qxuNhxf0gFr1WkyAMmU
         Xww2Uufwvuy0OxqDr2ZoXGvFJq+SzmsjeBmJevFahGCxOqT4LfXE6BSAIBE1madwtDw3
         XxwA29SlJXjthybm8cRL3be58bzVsVa8aMGKPK0WSNuE2J7txtR55QvRPB4DRW8MAsvI
         Em4yk7cxKXqRSFtJhjcaLt3mtTafrhTKaesm+URT1SjuQkFCwz3gp9IfE+ogvyVqc76I
         QYYHzBcElJ9eM7w18tWqbM7VoGCPfdobvJc7p2JrTJ5BJKoddNG4TWHHyRcLrqVujwg4
         yUCw==
X-Gm-Message-State: AOAM531T+jeQsP36xezO6Sc+87ffiUlZGUYjFNUJKbwqtC2Og/u0v29Q
        M+xEqvpjGlR6x0Yv9MB/b6o=
X-Google-Smtp-Source: ABdhPJwJvdOQ0jPl3L9eYjYXV/rgGLEfs79cpa7JfWJIAUgeaN6stVSAdOP2EQqyAjt0k+CMZ/SJVg==
X-Received: by 2002:a17:903:1c6:b0:13f:2b8:afe8 with SMTP id e6-20020a17090301c600b0013f02b8afe8mr30748592plh.81.1634048035338;
        Tue, 12 Oct 2021 07:13:55 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id n202sm11477588pfd.160.2021.10.12.07.13.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 07:13:54 -0700 (PDT)
Subject: Re: [PATCH V7 5/9] x86/sev-es: Expose __sev_es_ghcb_hv_call() to call
 ghcb hv call out of sev code
To:     Borislav Petkov <bp@alien8.de>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        konrad.wilk@oracle.com, hch@lst.de, robin.murphy@arm.com,
        joro@8bytes.org, parri.andrea@gmail.com, dave.hansen@intel.com,
        Hikys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        hpa@zytor.com, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, kuba@kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, jroedel@suse.de,
        brijesh.singh@amd.com, Tianyu.Lan@microsoft.com, pgonda@google.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, tj@kernel.org, aneesh.kumar@linux.ibm.com,
        saravanand@fb.com, hannes@cmpxchg.org, rientjes@google.com,
        michael.h.kelley@microsoft.com
References: <20211006063651.1124737-1-ltykernel@gmail.com>
 <20211006063651.1124737-6-ltykernel@gmail.com>
 <9b5fc629-9f88-039c-7d5d-27cbdf6b00fd@gmail.com> <YWRyvD413h+PwU9B@zn.tnic>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <92cff62b-806d-2762-7a5d-922843cff3f2@gmail.com>
Date:   Tue, 12 Oct 2021 22:13:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YWRyvD413h+PwU9B@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sure. Will do that. Thanks.

On 10/12/2021 1:22 AM, Borislav Petkov wrote:
> On Mon, Oct 11, 2021 at 10:42:18PM +0800, Tianyu Lan wrote:
>> Hi @Tom and Borislav:
>>       Please have a look at this patch. If it's ok, could you give your ack.
> 
> I needed to do some cleanups in that area first:
> 
> https://lore.kernel.org/r/YWRwxImd9Qcls/Yy@zn.tnic
> 
> Can you redo yours ontop so that you can show what exactly you need
> exported for HyperV?
> 
> Thx.
> 
