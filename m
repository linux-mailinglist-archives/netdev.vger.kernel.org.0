Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA0422CE73
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 21:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgGXTJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 15:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgGXTI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 15:08:59 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F99C0619D3;
        Fri, 24 Jul 2020 12:08:59 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id n5so5839581pgf.7;
        Fri, 24 Jul 2020 12:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ci89MFjHF1xHBKrkv+tsO7VybOGcbOoWzkwOoEdp1gQ=;
        b=Sau8/faTtT5grJDjr4yWX4vRYiclbsqyOQPDCHxfVcW6TXT5BMdymX0QXXYBqP5/1F
         8FQdjJwTa3+pZcI6MFKva4QWzxuvtxiKtK7YeVOrw9qMhqyQCW8dHnupaFaoBwoPqR4k
         6JSQwpjq+1mPTItTx6RwNmCUNilNwwe8WihdX8Apxz7+EwPelY6GKT6fSnEaLp2TdEZL
         7G0tFwyY5pLLc+aIWIdxZpYN2/6vnWhGZCcZkp2gdf35VGhdDFunXKzc15uQRI/55aGK
         q52sQqvP6yF9+BEvv+jq9NfsNIe71NJRC5+yaLPBEd3lhTdDcdlcaHczvCTmd5BIeY1L
         cTMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ci89MFjHF1xHBKrkv+tsO7VybOGcbOoWzkwOoEdp1gQ=;
        b=jKCd7A78yt8or/sAeVB2ffVTx+OzPf6Ty4nmJyRKtTuWT3XxyFA8jyRT3MNg/qm14F
         /PGeooExUpIrKz24IDwfPPeOVc1EL6i5jjtFWcK3GelXfoUFKCeVlZAGHt6neen7+2s2
         72smztuxB8lcaGCsjGl5z7YLEFphmgLgHuAC8m/i9j2LpMW878NIsSgLz0b01CXGP5LC
         Jh+blVKUBSViM+LJcWVi/B07fe3fCnXmsuutac6hPzHifVem9F6BtiUaNvU+TDAGVpYZ
         KaFmte3XYwHbGh8uRJoc7WZE4QJdZ2wYvbPay9mKAPLs5zUAYuUvMCcPktrj12dssO9B
         t5sw==
X-Gm-Message-State: AOAM530i706hA8wcLbukA3H5Y2JQeRLss2p0kRXbJTcVQOmqbmCw1vzD
        TYUMFMp0isDDyoDzx/12uds=
X-Google-Smtp-Source: ABdhPJz6m9tlp5bidoBXSO/U48yqYRHvm3uyzjQtlAK9zr96nA/nnk4vLUgX3+kuB84SgXa+elmOug==
X-Received: by 2002:aa7:8391:: with SMTP id u17mr10790917pfm.156.1595617739088;
        Fri, 24 Jul 2020 12:08:59 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:dfa8])
        by smtp.gmail.com with ESMTPSA id c27sm7197359pfj.163.2020.07.24.12.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 12:08:57 -0700 (PDT)
Date:   Fri, 24 Jul 2020 12:08:55 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, torvalds@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 3/4] bpf: Add kernel module with user mode
 driver that populates bpffs.
Message-ID: <20200724190855.3gdvbuut6ge7o7im@ast-mbp.dhcp.thefacebook.com>
References: <20200724055854.59013-1-alexei.starovoitov@gmail.com>
 <20200724055854.59013-4-alexei.starovoitov@gmail.com>
 <418b538a-1799-af47-be1e-22e88d0119af@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <418b538a-1799-af47-be1e-22e88d0119af@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 04:53:47PM +0200, Daniel Borkmann wrote:
> 
> static const struct bpf_preload_umd_ops umd_ops = {
>         .preload        = do_preload,
>         .finish         = do_finish,
>         .owner          = THIS_MODULE,
> };

Thanks for the suggestion. It helped to get rid of ugly #if IS_BUILTIN too.
I'm kinda surprised that THIS_MODULE works for builtin too. Nice.
