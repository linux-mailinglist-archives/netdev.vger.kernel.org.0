Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3EC33DC69D
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 17:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbhGaPZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 11:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbhGaPZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 11:25:37 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D38C06175F;
        Sat, 31 Jul 2021 08:25:30 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id b6so19424393pji.4;
        Sat, 31 Jul 2021 08:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hKFCzHrB92IWDlBqXaKAnSTYyGuxIzImIhnqt8i8hKs=;
        b=uxpYsrCAo5ObrCQeiET17wsWl20sXpwMOtttRPFY4XnUjWos0dYZF/fd3RoOcUnyP+
         G+BMuae8nHtbZzjx9a4XO1EhTr8Kp2e5GYOVrd53hUjRpC648JdvWLN4fBLFaRPwlVl8
         3G4N0g2hodT1zR7MYpa/qKaHnrHG7bwrRtkgt6NcVDxperHI7Y0n2gX9689B3+63wzH2
         Wpn+vKuV+FMgAlK0ufv32y8aSKSI66GR1VrkgwiL/Hblvlvt9+dcZgX28nE0bUXphk7a
         IO6v7zxn8JtZa5Jxagx8/CfU12O24MMAiCWrsV7aqaijKriuS0l/KSQUi2hhJ+e4mtN9
         T1hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hKFCzHrB92IWDlBqXaKAnSTYyGuxIzImIhnqt8i8hKs=;
        b=R7J36E1LWNtlPgXna/HiJs3Ucn1tIwayLQjbqusaO5PKb9tL1QTWRKD2X2YQnK8zcl
         W7b77MVEagRj6yUcb/HCyQY72gBR80qGogXMQSGbJxYpPEnw4WDYybMWtGxAcjFUOOc7
         onGIrl+SK5FcfBZSnC8DHMolNJC/716QnHZmhXOoqKeI2Sw+OWsEa4R3vBJZ0v2HMY4w
         /h79r84B5xnb6LXXk1653mMcHD3YsYlfwTaVY5owxZZhBPSAe13SLEqklO3LRSBhbfeS
         sntLrnUrCRtZ9wKvB8IIK7NrcZSs9Zd1U8RbvrUHZLFEKFZLuXDSeOo5MSD05HnANzvg
         P+8g==
X-Gm-Message-State: AOAM531IZ5fA6uH0rkaklCp6yM47owFSz2ji41AXolozAKKXHcuewWCn
        a/LMFmP4iTGrc5as6hBlJuY=
X-Google-Smtp-Source: ABdhPJwDw4nikp5i8nOXC5fmKlUIzXVHt+eA8eKys39blLKLPDaW6zi13zF4Kt3Ad+jqkQei+s7rhw==
X-Received: by 2002:a17:90a:f991:: with SMTP id cq17mr8419312pjb.150.1627745130240;
        Sat, 31 Jul 2021 08:25:30 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0bb:dc30:f309:2f53:5818])
        by smtp.gmail.com with ESMTPSA id s193sm6442927pfc.183.2021.07.31.08.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 08:25:30 -0700 (PDT)
Date:   Sat, 31 Jul 2021 20:55:23 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Matthew Cover <werekraken@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthew Cover <matthew.cover@stackpath.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next] samples/bpf: xdp_redirect_cpu: Add
 mprog-disable to optstring.
Message-ID: <20210731152523.22syukzew6c7njjh@apollo.localdomain>
References: <20210731005632.13228-1-matthew.cover@stackpath.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210731005632.13228-1-matthew.cover@stackpath.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 31, 2021 at 06:26:32AM IST, Matthew Cover wrote:
> Commit ce4dade7f12a ("samples/bpf: xdp_redirect_cpu: Load a eBPF program
> on cpumap") added the following option, but missed adding it to optstring:
> - mprog-disable: disable loading XDP program on cpumap entries
>
> Add the missing option character.
>

I made some changes in this area in [0], since the support was primarily to do
redirection from the cpumap prog, so by default we don't install anything now
and only do so if a redirection interface is specified (and use devmap instead).
So this option won't be used anyway going forward (since we don't install a
dummy XDP_PASS program anymore) if it gets accepted.

[0]: https://lore.kernel.org/bpf/20210728165552.435050-1-memxor@gmail.com

PS: I can restore it again if this is something really used beyond redirecting
to another device (i.e. with custom BPF programs). Any feedback would be helpful.

> Fixes: ce4dade7f12a ("samples/bpf: xdp_redirect_cpu: Load a eBPF program on cpumap")
> Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
> ---
>  samples/bpf/xdp_redirect_cpu_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
> index d3ecdc1..9e225c9 100644
> --- a/samples/bpf/xdp_redirect_cpu_user.c
> +++ b/samples/bpf/xdp_redirect_cpu_user.c
> @@ -841,7 +841,7 @@ int main(int argc, char **argv)
>  	memset(cpu, 0, n_cpus * sizeof(int));
>
>  	/* Parse commands line args */
> -	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzFf:e:r:m:",
> +	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzFf:e:r:m:n",
>  				  long_options, &longindex)) != -1) {
>  		switch (opt) {
>  		case 'd':
> --
> 1.8.3.1
>

--
Kartikeya
