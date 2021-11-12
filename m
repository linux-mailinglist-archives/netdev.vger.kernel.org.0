Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C2044E013
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 03:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbhKLCEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 21:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhKLCEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 21:04:35 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1DEC061766;
        Thu, 11 Nov 2021 18:01:45 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id y7so7350221plp.0;
        Thu, 11 Nov 2021 18:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8D7y19sbzroYP4XFrv6hEdIbLGS8yEPwCoDraIsxJkk=;
        b=RLtHwGFgkQ2JNPE31SyiZGBID/v6FskhlucpmGFugCy/0r+E5PfW1ArXXUuj3sCeVp
         13qyZVrPu0o234xKJLL8HtyjAbO5OWhP6dtHweJJ9w0G65qAguhIiXukDGcsBRsNALCd
         l9h6v3ZIqG5ndkjSyCaEk514B6hK6DpRkLfrmlUgQImQrS2SD9FlLKN8T7XOJ6hlZ5XW
         6gENaO7wrMNT4sauImpeo2NhV/xcDoL155z0NXijvM941lx5hfbPN+e4hauYM/vH5wnI
         ztxCtRva9DDwQ6R7iHgSXdhg6tPXBe/SWB0+C6nnPZjQHO0FRUvYbkxTZKp4Ef4cmmbx
         XOvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8D7y19sbzroYP4XFrv6hEdIbLGS8yEPwCoDraIsxJkk=;
        b=cGOpmItJzQLABJ1pu7KOJqmfxPVsq0g4156ZhSE0ybjnsEKFzoJhlIuki+a2bvQ7/G
         BARvAqcJ4AIQACamonbB+5+I323Cb310Iei15exsqaLezaN4P+gAGFsz+RaxlRzSaDn0
         LqprCWc2bGd3/dmeAtgwwpyk3EHLsnufwdKMwkEmaNVtVemMm1IJYgwhyDXFgai1gW2Z
         WVxcmIgcPKjZBbtRm/hvWcsUvv7+G2j4DzDht3VU41zjSSi44xzvQ3zAMhO2LZDVyq9S
         WfRF+nX1/284cx0QrKeKUPPvOPodHecGmWjnR+qFK9MZ6Yt74wiygFhGf7rRKqnjnM2q
         TviQ==
X-Gm-Message-State: AOAM531tNQ2Bh7uBbnPnJF6gkZmPNSELnMhtBYTaUQW98uevIxXIN66a
        DJ5X1nqH7SYzWnEhL7ZT7CI=
X-Google-Smtp-Source: ABdhPJwP0gH7+NhULLlo59HvvabqTXOPWslj7lSlJAPjnw301UcjNMUFggS3yqaXyvDBzds6Af+0Uw==
X-Received: by 2002:a17:90a:fd93:: with SMTP id cx19mr31063638pjb.190.1636682505160;
        Thu, 11 Nov 2021 18:01:45 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id n7sm4333748pfd.37.2021.11.11.18.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 18:01:44 -0800 (PST)
Date:   Fri, 12 Nov 2021 07:31:42 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf] samples: bpf: fix summary per-sec stats in
 xdp_sample_user
Message-ID: <20211112020142.q656zeu35qjtmvy5@apollo.localdomain>
References: <20211111215703.690-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111215703.690-1-alexandr.lobakin@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 03:27:03AM IST, Alexander Lobakin wrote:
> sample_summary_print() uses accumulated period to calculate and
> display per-sec averages. This period gets incremented by sampling
> interval each time a new sample is formed, and thus equals to the
> number of samples collected multiplied by this interval.
> However, the totals are being calculated differently, they receive
> current sample statistics already divided by the interval gotten as
> a difference between sample timestamps for better precision -- in
> other words, they are being incremented by the per-sec values each
> sample.
> This leads to the excessive division of summary per-secs when
> interval != 1 sec. It is obvious pps couldn't become two times
> lower just from picking a different sampling interval value:
>
> $ samples/bpf/xdp_redirect_cpu -p xdp_prognum_n1_inverse_qnum -c all
>   -s -d 6 -i 1
> < snip >
>   Packets received    : 2,197,230,321
>   Average packets/s   : 22,887,816
>   Packets redirected  : 2,197,230,472
>   Average redir/s     : 22,887,817
> $ samples/bpf/xdp_redirect_cpu -p xdp_prognum_n1_inverse_qnum -c all
>   -s -d 6 -i 2
> < snip >
>   Packets received    : 159,566,498
>   Average packets/s   : 11,397,607
>   Packets redirected  : 159,566,995
>   Average redir/s     : 11,397,642
>
> This can be easily fixed by treating the divisor not as a period,
> but rather as a total number of samples, and thus incrementing it
> by 1 instead of interval. As a nice side effect, we can now remove
> so-named argument from a couple of functions. Let us also create
> an "alias" for sample_output::rx_cnt::pps named 'num' using a union
> since this field is used to store this number (period previously)
> as well, and the resulting counter-intuitive code might've been
> a reason for this bug.
>
> Fixes: 156f886cf697 ("samples: bpf: Add basic infrastructure for XDP samples")
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---

Ouch. Thank you for the fix.

Reviewed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

> [...]

--
Kartikeya
