Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7D11CFD43
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 20:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730821AbgELS3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 14:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELS3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 14:29:48 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681E1C061A0C;
        Tue, 12 May 2020 11:29:47 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t16so5732409plo.7;
        Tue, 12 May 2020 11:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0R4IiugdXp8iJ7umOfVfh8AnVyRiIFK4KYXJSuwKSos=;
        b=AenWkeOovINppkTw/K3pXCkiLiXodKNI5ZKlljKh5H/aN2KosAWyqcmDl8XXdvbc+0
         Aht05AloRQigsgfFrol0DZnJdvHu0cJNBgsQbuUxL4Lc4R46KoMl9ICrpJk4+bppjLR1
         CM7nX4nZ9Dp1xgB6jMqTQs0Q63LzHLQ1D5mRZHVG5UsW/Q4XX/sBAAz0oCj5I+YPqY68
         AlY8cNNOOxdcOS4TQKp+1orbE56hfXBAKh9hc4GF/w50CuCj9+53iy+vvDkR08yZQCqL
         9a/bNyDr1fDhbzmgtT1CGUAE0/LNNYOBu4v7sQgKZBRhSk7b0kySos/BCs6LSkCgXXga
         QLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0R4IiugdXp8iJ7umOfVfh8AnVyRiIFK4KYXJSuwKSos=;
        b=CnCcYMUBm4NCjB7NlrXniZMX/4yNE6j1ScH+uGNWHhwD9EhCNk+elBplN/sYUdpI5v
         iSDnXh5Et0+mzO+MRfLueirRa0GzgjCxeDQDcuYuqHGIH1/YbDmjm9UHzy/iJYE6PcQJ
         AnAwQVQPNXGxEmXuSUNKIu/KdKOMDzFx94JZkzX//0nroNKj7hMXoWUSgDlfv6L0F9MR
         Q8GvpiIEjaAHuU9qPn8LweFba9UU8hlUorNPEPCLXebBlwFyTPQIrCRHQzBC8L9IvqvJ
         20eWvIVpBXh4ewSZbaoU+oIcaRgj5JcWdzWqvxNonfACkm3o1H33rQ36HuoJfqwEa/Lx
         LhoA==
X-Gm-Message-State: AGi0PubfsfL1D+hFzauBqLpSDszoN3iyxPSHZP4OaEXl4BgDZ/nORwVm
        YvLoGMDk7wwKa0blB5GDrAHrfth/
X-Google-Smtp-Source: APiQypJRV+2Szp2twPUffO+9/g6a/xCYel89YR1a4Y4bbyNkc24pwGr6wwPvfbBCN/fBZ9hbIjsl0A==
X-Received: by 2002:a17:902:6b01:: with SMTP id o1mr21786210plk.64.1589308186851;
        Tue, 12 May 2020 11:29:46 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:c3f6])
        by smtp.gmail.com with ESMTPSA id f136sm12240030pfa.59.2020.05.12.11.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 11:29:46 -0700 (PDT)
Date:   Tue, 12 May 2020 11:29:44 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com, jannh@google.com,
        kpsingh@google.com
Subject: Re: [PATCH v5 bpf-next 2/3] bpf: implement CAP_BPF
Message-ID: <20200512182944.wzfs7nzgppqn23l6@ast-mbp>
References: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
 <20200508215340.41921-3-alexei.starovoitov@gmail.com>
 <fcc61b50-16f7-4fc9-5cd4-7def57f37c35@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcc61b50-16f7-4fc9-5cd4-7def57f37c35@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 05:05:12PM +0200, Daniel Borkmann wrote:
> > -	env->allow_ptr_leaks = is_priv;
> > +	env->allow_ptr_leaks = perfmon_capable();
> > +	env->bpf_capable = bpf_capable();
> 
> Probably more of a detail, but it feels weird to tie perfmon_capable() into the BPF
> core and use it in various places there. I would rather make this a proper bpf_*
> prefixed helper and add a more descriptive name (what does it have to do with perf
> or monitoring directly?). For example, all the main functionality could be under
> `bpf_base_capable()` and everything with potential to leak pointers or mem to user
> space as `bpf_leak_capable()`. Then inside include/linux/capability.h this can still
> resolve under the hood to something like:
> 
> static inline bool bpf_base_capable(void)
> {
> 	return capable(CAP_BPF) || capable(CAP_SYS_ADMIN);
> }

I don't like the 'base' in the name, since 'base' implies common subset,
but it's not the case. Also 'base' implies that something else is additive,
but it's not the case either. The real base is unpriv. cap_bpf adds to it.
So bpf_capable() in capability.h is the most appropriate.
It also matches perfmon_capable() and other *_capable()

> static inline bool bpf_leak_capable(void)
> {
> 	return perfmon_capable();
> }

This is ok, but not in capability.h. I can put it into bpf_verifier.h
