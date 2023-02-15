Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D30B6974C3
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 04:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbjBODTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 22:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBODTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 22:19:19 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173A6241D6
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 19:19:18 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso2940394pju.0
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 19:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hBDtDorWVGGnbAJlstCVLXC4KgZYcpfN89nn0eLodho=;
        b=TDWQ9PmrwvLUcTo0lBlRuDBs6LfyqBjYoFXCZSj6/7iKJCjhRwcJUbUfI2buPyb9rd
         xeco65Idbt5F69GXs19eLIIr/E1mdOW2sDO18XzrsZBD+rCxSEr0HrphkGMlLecQRNWE
         fKVUl2wxjhX+iWtZIZ57DBC+0rBbt0ZIv31fmglw+YVgSA6KxZa6p66Eua+MsJsNGMI8
         QUdukJNui/NdiTy6lOPb8nzXYjzh8NSH1P61qaqV/ULSjXcyz1Qe24/S8Er3ohkeZQiP
         ZlVHKsxbxVvaOFpdk5QC1EZcAOetNy6F/lOwxCTH9nYKnwp5L9U3HtfofiOq7NcIsB2B
         A1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hBDtDorWVGGnbAJlstCVLXC4KgZYcpfN89nn0eLodho=;
        b=GVu4Z6/d+TiPt9rOJZ1ycyGrC7e12uJQDf6kwOrPh5UoRTMKw1lxdbDw3R6DjHf6rj
         EEXjWPmIRozMqpGLC0i5MwlaDQA+7ZjqCOGqcepJmZbQ277YVrzMo1KEcugk150MvIy3
         oDAzDgvmryrUXBpIqdVPmWIqZTjQ3rfvog+Ax60HkwY179y2UsyLoqNCyRYSh2qvBiVV
         77/QIoLpdpWz1rsreeWD0+t9+aTNz9d8GZ67Ii/QL1dONzedce+xLcFUp2K4XxsQXPNo
         npEP6zRGleXxpeRxGTo1CKWW95Brg1C/zoT25HTSx/zSJkAYFMRdz3fBtZpsKpgneUas
         ACNw==
X-Gm-Message-State: AO0yUKWkcXp3FiXqQuQKNLXcQsBqqsEobk4xYa7fGgjnmX+B8nOuxIU9
        O7AUIqcB3Ii8zUPT1RqdDMOmSVZZ+HxNWRxmgGs=
X-Google-Smtp-Source: AK7set8IZlzKTCD+NS6NLk03tw12Y2YvjAU5Kw+8dpbaSxkri3GTeMpV3jTg9FWVdAem4jZpgiABJg==
X-Received: by 2002:a17:902:d2c8:b0:19a:85d9:93fd with SMTP id n8-20020a170902d2c800b0019a85d993fdmr938693plc.22.1676431157460;
        Tue, 14 Feb 2023 19:19:17 -0800 (PST)
Received: from localhost ([135.180.226.51])
        by smtp.gmail.com with ESMTPSA id s15-20020a170902b18f00b00189bf5dc96dsm10887390plr.230.2023.02.14.19.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 19:19:16 -0800 (PST)
Date:   Tue, 14 Feb 2023 19:19:16 -0800 (PST)
X-Google-Original-Date: Tue, 14 Feb 2023 19:19:13 PST (-0800)
Subject:     Re: [PATCH] mm: remove zap_page_range and create zap_vma_pages
In-Reply-To: <20230104002732.232573-1-mike.kravetz@oracle.com>
CC:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, david@redhat.com,
        mhocko@suse.com, peterx@redhat.com, nadav.amit@gmail.com,
        willy@infradead.org, vbabka@suse.cz, riel@surriel.com,
        Will Deacon <will@kernel.org>, mpe@ellerman.id.au,
        borntraeger@linux.ibm.com, dave.hansen@linux.intel.com,
        brauner@kernel.org, edumazet@google.com, akpm@linux-foundation.org,
        mike.kravetz@oracle.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     mike.kravetz@oracle.com
Message-ID: <mhng-6dc92fd9-0fe6-4a0d-974f-4f4468f143e4@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 03 Jan 2023 16:27:32 PST (-0800), mike.kravetz@oracle.com wrote:
> zap_page_range was originally designed to unmap pages within an address
> range that could span multiple vmas.  While working on [1], it was
> discovered that all callers of zap_page_range pass a range entirely within
> a single vma.  In addition, the mmu notification call within zap_page
> range does not correctly handle ranges that span multiple vmas.  When
> crossing a vma boundary, a new mmu_notifier_range_init/end call pair
> with the new vma should be made.
>
> Instead of fixing zap_page_range, do the following:
> - Create a new routine zap_vma_pages() that will remove all pages within
>   the passed vma.  Most users of zap_page_range pass the entire vma and
>   can use this new routine.
> - For callers of zap_page_range not passing the entire vma, instead call
>   zap_page_range_single().
> - Remove zap_page_range.
>
> [1] https://lore.kernel.org/linux-mm/20221114235507.294320-2-mike.kravetz@oracle.com/
> Suggested-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>

[...]

> diff --git a/arch/riscv/kernel/vdso.c b/arch/riscv/kernel/vdso.c
> index e410275918ac..5c30212d8d1c 100644
> --- a/arch/riscv/kernel/vdso.c
> +++ b/arch/riscv/kernel/vdso.c
> @@ -124,13 +124,11 @@ int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
>  	mmap_read_lock(mm);
>
>  	for_each_vma(vmi, vma) {
> -		unsigned long size = vma->vm_end - vma->vm_start;
> -
>  		if (vma_is_special_mapping(vma, vdso_info.dm))
> -			zap_page_range(vma, vma->vm_start, size);
> +			zap_vma_pages(vma);
>  #ifdef CONFIG_COMPAT
>  		if (vma_is_special_mapping(vma, compat_vdso_info.dm))
> -			zap_page_range(vma, vma->vm_start, size);
> +			zap_vma_pages(vma);
>  #endif
>  	}

Acked-by: Palmer Dabbelt <palmer@rivosinc.com> # RISC-V

Thanks!
