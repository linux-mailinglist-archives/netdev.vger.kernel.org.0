Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE64411FDA9
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 05:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfLPEtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 23:49:53 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33465 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfLPEtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 23:49:53 -0500
Received: by mail-pl1-f195.google.com with SMTP id c13so3921723pls.0;
        Sun, 15 Dec 2019 20:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=N4ss58iIpeiNf6IgLyQmGag+w8P05Oi8xyk1QaK0LPg=;
        b=T7W72bwqnK9OxlWgYqXE2QlD7RZnyzaBAhwrYyTnqT9bRaVFr+hIb3D6i558/TMvtw
         v7+tny3YTgBGPkX+whN4TV91RXfs04ssLHAt4KksovgIa+bviIDfiZVSyP20cvO2iilc
         oxx9CS6XFN1T6TW9uGV3qgsarFWnQUDq7vTh1H2jaGPk6eida8AN1Mo6lA/ft6SV/7aB
         UoiwSrYhn5MXYDN9vwqGh70n6Fv8Vn8/6lteFw6JwGnLfpJjCVOZ0Jo60ZQCV1CodaS7
         ItBt9RYutGEOzHioVdutYJvxmF9/WYHLJBVo+21w73Zwsb8jMuj8sgT6J0RQjGY/6fDg
         KJtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=N4ss58iIpeiNf6IgLyQmGag+w8P05Oi8xyk1QaK0LPg=;
        b=mKDK4XYUrlbVTxwkHotXdhpO5NyQ6y/dt3RKY7K/dpbFDE3RY6TvFO7NFPEHJz6Dst
         hccgHwZVtoBnWXTP3SUx2DKEj+QTIw/mxheC5XPpXfBxWcnEYATGirnzXbKXuqCgx8Zi
         BeiM4xxci5uoESrFmfWroTbde3rURQnFVX/f8xcxwVxpEuUdANZMK4oLoTSGxebl2wUm
         eJfIgz/dcPrOKhxp7jfIf+X9ZDERJodB7zzMkMZCvP8IVWsXTHyn441o1Nu1we8SODB0
         i5rLt6ZF/wuw5WlS5GjyvjRlpMSLIeusVAKLEuZ7SSAcVNJLQPGLS7RNsZGSY6PmdOi8
         jsNQ==
X-Gm-Message-State: APjAAAU/SFjwA9XXgnGGg509EzVdnqoht0zvF0OtM7Z62duHcpN28Xad
        cOdwN6jl+P2UjtTM9d8axGg=
X-Google-Smtp-Source: APXvYqw6sh8FgfMTvA6F2fpFUDKta3rxJB0DIIVyNdmXCdeSUR9EOk5xDK4SFqXuBGkXevT/kup37Q==
X-Received: by 2002:a17:902:760e:: with SMTP id k14mr14331760pll.238.1576471792314;
        Sun, 15 Dec 2019 20:49:52 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::4748])
        by smtp.gmail.com with ESMTPSA id f9sm19923513pfd.141.2019.12.15.20.49.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Dec 2019 20:49:51 -0800 (PST)
Date:   Sun, 15 Dec 2019 20:49:50 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     kjlu@umn.edu, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bpf: Replace BUG_ON when fp_old is NULL
Message-ID: <20191216044948.gj7kwyfgr6laskip@ast-mbp.dhcp.thefacebook.com>
References: <20191215154432.22399-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191215154432.22399-1-pakki001@umn.edu>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 15, 2019 at 09:44:32AM -0600, Aditya Pakki wrote:
> If fp_old is NULL in bpf_prog_realloc, the program does an assertion
> and crashes. However, we can continue execution by returning NULL to
> the upper callers. The patch fixes this issue.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  kernel/bpf/core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 49e32acad7d8..4b46654fb26b 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -222,7 +222,8 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
>  	u32 pages, delta;
>  	int ret;
>  
> -	BUG_ON(fp_old == NULL);
> +	if (!fp_old)
> +		return NULL;

This change makes no sense to me. fp_old should be valid. That's the point of
BUG_ON. It can happen only during development. Can remove BUG_ON just as well
and let kernel page fault.
