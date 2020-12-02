Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D262CB2B4
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 03:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgLBCPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 21:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbgLBCPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 21:15:21 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA24FC0613CF;
        Tue,  1 Dec 2020 18:14:40 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id d77so245737pfd.2;
        Tue, 01 Dec 2020 18:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Obg14oVqT2hmGCEw6+gPnYmtm3d2f/qGhj1jJeiogDs=;
        b=YGLVcjRY1hrgmQGXXr0uR+s3AUXHO26eQEvLxV4LNnmQaZ1IMQhpqbv/u8dYuVBY2F
         /TPQBG5AQXTDwt6HRSWo6Vjjor+FdflUHF/dFb3QdYhihvGpDTYiuwrQmhmHt6PHbsdF
         n5NyFeE7ATA9Lkyx+raN/FPmKHPrzYWjXBK3dtahfJzZ4UyAhfDij7iV2nyT8+bhBrAB
         Hv2YAGo2nGbk7RI8nEFC4as6RzVPNWhoe9E+pmRQ/7C9TsfrdN1qrrMumN03YNYTIAmK
         Se41X2vOvGCshhPYMGwIxwhk88qrfetu2H4tdiaMKNCljfw/MXAaA4bMVN17nsJXQXFu
         29Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Obg14oVqT2hmGCEw6+gPnYmtm3d2f/qGhj1jJeiogDs=;
        b=JcZCkb5L5X5gMyo1BNyWx9HAsSWRGIVW5LJ8wUch7DQfVHKqgRwih582r9+VmHbYTX
         31JEFNmTu28ThojCsD/DACfAyFPQvRK9O35t9LSR3hGjsd9U26pFuyAOvBKziQw41XGt
         Mt0HGBUJmcGWacJArrm4oHdcIzkSxuowZzEK5xr7eW8yG08ICsSINes4iZIOTe1/m2Hk
         yCJZl/xwtiEKwm4OvE8ciIfRLlLe6ncIm4U03GGWPx6eO7cmXW42PzCSoSLGOSi6wfdM
         QgD5Vmqf8JM+VM7I2TNErd2oQcopHXuIgKO4rdhe1fIardIszLKVhdlhooQP8pz4wPa1
         hAog==
X-Gm-Message-State: AOAM532sTFfUF3Y053qBu97FWFaUfOP40eanzHidJh1DWdhPglerYOCg
        X1O80xihklN/VXbKSnkPlktdirtjLO4=
X-Google-Smtp-Source: ABdhPJzbUq3HaTK1QFsgIRcwNXMGF9HF3ZItS9gZNIhzpL0xZ5BquXliEngyS8KB763fxUmaymdYAg==
X-Received: by 2002:a63:fb42:: with SMTP id w2mr552738pgj.354.1606875280387;
        Tue, 01 Dec 2020 18:14:40 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:edc0])
        by smtp.gmail.com with ESMTPSA id z11sm68225pjn.5.2020.12.01.18.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 18:14:39 -0800 (PST)
Date:   Tue, 1 Dec 2020 18:14:37 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Prankur gupta <prankgup@fb.com>
Cc:     bpf@vger.kernel.org, kernel-team@fb.com, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/2] bpf: Adds support for setting window clamp
Message-ID: <20201202021437.rbllajmj27u2ezyf@ast-mbp>
References: <20201201164357.2623610-1-prankgup@fb.com>
 <20201201164357.2623610-2-prankgup@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201164357.2623610-2-prankgup@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 08:43:56AM -0800, Prankur gupta wrote:
> Adds a new bpf_setsockopt for TCP sockets, TCP_BPF_WINDOW_CLAMP,
> which sets the maximum receiver window size. It will be useful for
> limiting receiver window based on RTT.
> 
> Signed-off-by: Prankur gupta <prankgup@fb.com>
> ---
>  net/core/filter.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 2ca5eecebacf..8c52ffae7b0c 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4910,6 +4910,19 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>  				tp->notsent_lowat = val;
>  				sk->sk_write_space(sk);
>  				break;
> +			case TCP_WINDOW_CLAMP:
> +				if (!val) {
> +					if (sk->sk_state != TCP_CLOSE) {
> +						ret = -EINVAL;
> +						break;
> +					}
> +					tp->window_clamp = 0;
> +				} else {
> +					tp->window_clamp =
> +						val < SOCK_MIN_RCVBUF / 2 ?
> +						SOCK_MIN_RCVBUF / 2 : val;
> +				}

May be extract this logic into a helper instead of copy-paste?
