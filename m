Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4AD1D1F65
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390747AbgEMTih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390593AbgEMTig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:38:36 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A58C061A0C;
        Wed, 13 May 2020 12:38:36 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k7so6548720pjs.5;
        Wed, 13 May 2020 12:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0u0exKw+YiYAyn84F3w6huQTNlYyARlFIAHEEGZPygc=;
        b=quBH0RjnqfonJHvJ7a/AnGNdgBzTtg+jEfAo5XYwZSYWX1bZwhtc0wSlGs/ehCxh0T
         +2DmqNWO00jIjDZEXQoSDolkO0uZNkQmCtKaIWLzUgjqrJKxz8ZT23NSC2pjwGclnKa3
         zTxMHnnfDdazSlLGZy9EsNN0CL4xfHC6LCfsw3+clyE5d1tEhdoZyc7rRnmwi7iKhUWQ
         VJ4bBAVUCdzfoPf9hkzr4wADG/LEkHVrw13j7L0u07YihcEENsPhKdeIXWAjfo3WaeO4
         pnvSD+e3XHyMQZRfnk7IaDGIWMODeOkCP627/FBCSOprAXMbK4wbNggXmNxxjvPU/tpf
         S3bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0u0exKw+YiYAyn84F3w6huQTNlYyARlFIAHEEGZPygc=;
        b=daT5O3cYM3JpdVEVugpM/7RuVXvt+Ja+u+AcC41TmibRgs8Qm3sFk7+sIiLzyKMqbv
         aOZlim47NxUgZ70bbNzkJeN5m6VbAXrmq6H0HeoNCQY0xRWQVnSLzyksK4DexSiKaH68
         Dl9ZR9d98GkKuWpb4+qMKoRX6iYmFuqM3CW7Ax2e+9N/sjXLpTVx8L4fAKk0InIyRwn+
         ich3GcfThLYxgB7kgJDlCu9aE6vewjFRBXHFrKW+qru0e2ggobVPuU06n6Z1lF2DVbrn
         RkEpM6tVggooErz3CLZh2CldGwyoqAsu6mP2nYruWNbsSusIumDgUoF+ZjVfRebDgM9P
         hJIA==
X-Gm-Message-State: AGi0PuYOgWVCISroZ+/r4OgoZJncdP2d08I8XjYnfgQPL/LKsRMzdsn1
        xgDV3zdsVM0mlbG6z6HcXv8=
X-Google-Smtp-Source: APiQypJ/RWzMMdyDz/uJDEfMcnv+/XB6W0NC7oinxrJqzp6J8ofrJi4I5Y0llt+A0PKxm8q9BEFrcQ==
X-Received: by 2002:a17:90a:71c3:: with SMTP id m3mr35927363pjs.17.1589398716047;
        Wed, 13 May 2020 12:38:36 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:ba8f])
        by smtp.gmail.com with ESMTPSA id j26sm282722pfr.215.2020.05.13.12.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 12:38:35 -0700 (PDT)
Date:   Wed, 13 May 2020 12:38:33 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: Re: [PATCH bpf-next v2 0/7] bpf: misc fixes for bpf_iter
Message-ID: <20200513193833.536oc5neayhiisvi@ast-mbp.dhcp.thefacebook.com>
References: <20200513180215.2949164-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513180215.2949164-1-yhs@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 11:02:15AM -0700, Yonghong Song wrote:
> Commit ae24345da54e ("bpf: Implement an interface to register
> bpf_iter targets") and its subsequent commits in the same patch set
> introduced bpf iterator, a way to run bpf program when iterating
> kernel data structures.
> 
> This patch set addressed some followup issues. One big change
> is to allow target to pass ctx arg register types to verifier
> for verification purpose. Please see individual patch for details.
> 
> Changelogs:
>   v1 -> v2:
>     . add "const" qualifier to struct bpf_iter_reg for
>       bpf_iter_[un]reg_target, and this results in
>       additional "const" qualifiers in some other places
>     . drop the patch which will issue WARN_ONCE if
>       seq_ops->show() returns a positive value.
>       If this does happen, code review should spot
>       this or author does know what he is doing.
>       In the future, we do want to implement a
>       mechanism to find out all registered targets
>       so we will be aware of new additions.

Applied, Thanks
