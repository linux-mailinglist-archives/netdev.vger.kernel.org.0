Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B42320F396
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 13:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732959AbgF3Lbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 07:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbgF3Lbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 07:31:41 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B66C061755;
        Tue, 30 Jun 2020 04:31:41 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id l6so6274200pjq.1;
        Tue, 30 Jun 2020 04:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iSzKjPE7Q/bcmLPgwav6pvuAnH2KjNETVRm7VbUG+wc=;
        b=BDbyBT3ogv3cW0OPfgttzmIhkVAi258FDi/waFPExBvW77tkP8dTvnhPhS/wNG95oC
         4XeiunNymDn3Ej3mp901CB1x/ExSDw6mZO7cYlkngJTMD/YQTap0jhdir7BSTL+94Iel
         DfWkgOy9WTbjfezSjeslu+ywU3tmGI5lrEm77E4GROYc0KUOTWtQdcMBa+QEgRBLdujs
         k+nkE/kwsMCXixPciNUpbBWA8rudmJ6h6EOK/urQJHQEb4TzubyFPFTjmn2LayGUEzSw
         8vHCle6hPaNFR7lAMxwXRc1gZoGbMabwDoJZ4IZ4aecL+HT+3iMYmXZbMoNAqsM2ExH0
         QkvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iSzKjPE7Q/bcmLPgwav6pvuAnH2KjNETVRm7VbUG+wc=;
        b=p5D4eyPUllOj4KOpSuRP0N70mLL+zmnsEzx8XvY1Zob+MbfUOH7McG7mMRCsKcrOan
         SCRUEh/MUJPUhV3WkpgXEcjySzfCoBvSM3T+Mxf0RRgeVy8jdCiwSGEqDXOXNuEmQkln
         GngI+Kl8TTBK/4p0DWOGKe3uuKXIGDWbptjTWr24r04P8OBJFKGITmLrP3inwBWde/mn
         cXmWqTOQVcrbENRpZxk5amXDQDp8yqyFyvYsUxCestQWUQMRyvq7KwHpyDjECWjp+y14
         tNWr+fnr2Tu+KICzmNKE3Qlifyuf6hVXxNef5DfJv/FfZY/H2OamW6Up8sGe1dtbyvS/
         ZpZQ==
X-Gm-Message-State: AOAM532C+Axq3irx2FWbBrnXuYXyOhiZlGOILI6v7rB/QEJ+f03KoE3y
        4OKdpx/+UqdK1z0kWw41rgw=
X-Google-Smtp-Source: ABdhPJwApLDmnbZsW2059pf2TQp6rsBGpQ7CU9JsEecPlrcz1m2w+Ma/YAwx/UMmY9kJ4laYypXj3Q==
X-Received: by 2002:a17:90a:a887:: with SMTP id h7mr20346290pjq.0.1593516700728;
        Tue, 30 Jun 2020 04:31:40 -0700 (PDT)
Received: from localhost ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
        by smtp.gmail.com with ESMTPSA id ia13sm2100255pjb.42.2020.06.30.04.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 04:31:39 -0700 (PDT)
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
X-Google-Original-From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Date:   Tue, 30 Jun 2020 20:31:37 +0900
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, andriin@fb.com,
        arnaldo.melo@gmail.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux@rasmusvillemoes.dk, joe@perches.com, pmladek@suse.com,
        rostedt@goodmis.org, sergey.senozhatsky@gmail.com,
        andriy.shevchenko@linux.intel.com, corbet@lwn.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 bpf-next 0/8] bpf, printk: add BTF-based type printing
Message-ID: <20200630113137.GA145027@jagdpanzerIV.localdomain>
References: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (20/06/23 13:07), Alan Maguire wrote:
>   struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
> 
>   pr_info("%pT", BTF_PTR_TYPE(skb, "struct sk_buff"));
> 
> ...gives us:
> 
> (struct sk_buff){
>  .transport_header = (__u16)65535,
>  .mac_header = (__u16)65535,
>  .end = (sk_buff_data_t)192,
>  .head = (unsigned char *)000000007524fd8b,
>  .data = (unsigned char *)000000007524fd8b,
>  .truesize = (unsigned int)768,
>  .users = (refcount_t){
>   .refs = (atomic_t){
>    .counter = (int)1,
>   },
>  },
> }

Hmm. So this can expose the kernel memory layout (IOW do you print out real
%px pointers and so on)? If so, then I'd suggest not to use printk.
Unprivileged /dev/kmsg or /proc/kmsg reads are really OK thing for printk()
log buffer. And if you are going to print pointer hashes instead,

  .transport_header = (__u16)65535,
  .mac_header = (__u16)65535,
  .end = (sk_buff_data_t)192,
  .head = (unsigned char *)34897918740,   // pointer_hash
  .data = (unsigned char *)23942384983,   // pointer hash
  .truesize = (unsigned int)768,
  .users = (refcount_t){
   .refs = (atomic_t){
    .counter = (int)1,
   },
  },

then the value of such printouts becomes a bit unclear to me, sorry.

Probably, something like a seq print into a file somewhere in
/sys/kernel/debug/foo, from which only privileged processes can
read, would be a better approach? My 5 cents.

	-ss
