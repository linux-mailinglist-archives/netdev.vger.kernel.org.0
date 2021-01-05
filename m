Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7002EA2FD
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 02:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbhAEBrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 20:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbhAEBrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 20:47:09 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB30C061574;
        Mon,  4 Jan 2021 17:46:29 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id y8so15507697plp.8;
        Mon, 04 Jan 2021 17:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6rJHKD1k8iLoBVJmfTVtFUbHaU4YAJTAH6eGwvb2u3I=;
        b=AdTk4JrjQDBKRIFoPKJwvdnCi9Zo+wGhggWuM4Pm7MxcaVsD5M/ypIoOBbjxF2EAKX
         KVpcvNbspbJYX/vF36xIz5XWHNjvIDXXkwBbUmPA0bBlxXOBeAUOEVBGptjtBVzqdoxA
         RdHLiSOR7XBT9qAg2sysOSPfYQtrb85+kx6AlVxyF6EnAPHdAtF/QXrs2S37WaHzetkR
         QBGVKpoqTwirnzPe+coSl1VY6Q35CkYbeP2MdOKJB8k5oWRGzUrBICtgVRd9U3FpxOQ1
         blC1YS71SqNsfybyKSAGeLc18qsEMcfB5EVwU85kHzSvAnj0mao2UJk5ikUqbAdH7QMK
         YrPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6rJHKD1k8iLoBVJmfTVtFUbHaU4YAJTAH6eGwvb2u3I=;
        b=GLc8R0bOwEv7tSvHM/yJKEVKoRGe5IxVQP8+2kRRb4pLOA0pxIAJJaifpCzPIN49k5
         TE1DI+YEaQCLGGjXLonNEbX2yD6Ok0xKGz8A4gAypLYiXCVxR37UQxmPj7NNpNgLJsYt
         K0q+iq9SXH9as2OXWXFkm2TqC1fvSVjgVWyPYxnlEkauZ02pbs97vKtEf6f3jZfd+wdi
         l4sPZVnuU3WPLZdfjA1iI4nNJPvObruPV94kTaU4bSyqFeUTNZ2DViP/F9oyKRBleSLm
         piyoqtpZNLMgoQzRPUH+vRJ7eyiN/6Glw8pK//tV1ms5ASyG+FdYREtJiTujwvkXn+my
         Ts5A==
X-Gm-Message-State: AOAM533dUd+jaVkiNA3q6qyMQgi0VfMwIF2ThHM4OBk4ougz+l/QRRKi
        lUuHuClAkmzHAovrDOM9y4LiR06KBoCPRg==
X-Google-Smtp-Source: ABdhPJyGMQwnusRfLP8VLG4DJ5A+ClXTxS87R559BsbMEPvFt2PBNgMgtY6lIoqinkBcnW22YJHKFQ==
X-Received: by 2002:a17:902:d351:b029:db:e003:3b88 with SMTP id l17-20020a170902d351b02900dbe0033b88mr73812053plk.70.1609811188906;
        Mon, 04 Jan 2021 17:46:28 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:429b])
        by smtp.gmail.com with ESMTPSA id v10sm545118pjr.47.2021.01.04.17.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 17:46:28 -0800 (PST)
Date:   Mon, 4 Jan 2021 17:46:25 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Yonghong Song <yhs@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Message-ID: <20210105014625.krtz3uzqtfu4y7m5@ast-mbp>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-2-songliubraving@fb.com>
 <20201217190308.insbsxpf6ujapbs3@ast-mbp>
 <C4D9D25A-C3DD-4081-9EAD-B7A5B6B74F45@fb.com>
 <20201218023444.i6hmdi3bp5vgxou2@ast-mbp>
 <D964C66B-2C25-4C3D-AFDE-E600364A721C@fb.com>
 <CAADnVQJyTVgnsDx6bJ1t-Diib9r+fiph9Ax-d97qSMvU3iKcRw@mail.gmail.com>
 <231d0521-62a7-427b-5351-359092e73dde@fb.com>
 <09DA43B9-0F6F-45C1-A60D-12E61493C71F@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09DA43B9-0F6F-45C1-A60D-12E61493C71F@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 05:23:25PM +0000, Song Liu wrote:
> 
> 
> > On Dec 18, 2020, at 8:38 AM, Yonghong Song <yhs@fb.com> wrote:
> > 
> > 
> > 
> > On 12/17/20 9:23 PM, Alexei Starovoitov wrote:
> >> On Thu, Dec 17, 2020 at 8:33 PM Song Liu <songliubraving@fb.com> wrote:
> >>>> 
> >>>> ahh. I missed that. Makes sense.
> >>>> vm_file needs to be accurate, but vm_area_struct should be accessed as ptr_to_btf_id.
> >>> 
> >>> Passing pointer of vm_area_struct into BPF will be tricky. For example, shall we
> >>> allow the user to access vma->vm_file? IIUC, with ptr_to_btf_id the verifier will
> >>> allow access of vma->vm_file as a valid pointer to struct file. However, since the
> >>> vma might be freed, vma->vm_file could point to random data.
> >> I don't think so. The proposed patch will do get_file() on it.
> >> There is actually no need to assign it into a different variable.
> >> Accessing it via vma->vm_file is safe and cleaner.
> > 
> > I did not check the code but do you have scenarios where vma is freed but old vma->vm_file is not freed due to reference counting, but
> > freed vma area is reused so vma->vm_file could be garbage?
> 
> AFAIK, once we unlock mmap_sem, the vma could be freed and reused. I guess ptr_to_btf_id
> or probe_read would not help with this?

Theoretically we can hack the verifier to treat some ptr_to_btf_id as "less
valid" than the other ptr_to_btf_id, but the user experience will not be great.
Reading such bpf prog will not be obvious. I think it's better to run bpf prog
in mmap_lock then and let it access vma->vm_file. After prog finishes the iter
bit can do if (mmap_lock_is_contended()) before iterating. That will deliver
better performance too. Instead of task_vma_seq_get_next() doing
mmap_lock/unlock at every vma. No need for get_file() either. And no
__vm_area_struct exposure.
