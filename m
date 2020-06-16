Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB7E1FA98A
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 09:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgFPHHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 03:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbgFPHHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 03:07:50 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E3BC05BD43;
        Tue, 16 Jun 2020 00:07:50 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id w18so693645iom.5;
        Tue, 16 Jun 2020 00:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:message-id:in-reply-to:references:subject:mime-version
         :content-transfer-encoding;
        bh=w2GZ9D1qoyvSkgnyjIsWsEO06r80xGwaHHmxaAjuloc=;
        b=ZZsayt7bxxYDUT0hylS4GIkNoY9UaEBqjyZlYcjF1n2kbPwlgUHVWID4pm2nqznENy
         lNaCpJ4vEkMn2GTetCOZjieycY1XNMwmHcw3boGkBasHphV+tfbXJG7RR0V4VIaxOUVU
         RHwBJCgHJUGk1SglNtWwKLrvr9m82qh0t8XqPlBZ2tbjEgp8CcoSyBttRPjytaD718nv
         IQyJTBOiEesaztsHWYIcHZ65+o+AyVmlmAWnDqIQ7ZEmWaGKnrbzl5yYUy0nm8wXHlwk
         rMYoHRxEQNaZxCT2ocR3qp8YRmToOUFE02PW+RG19CgjdpTCrCJO1D38Ytekg5+YiHbc
         Ubmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:message-id:in-reply-to:references
         :subject:mime-version:content-transfer-encoding;
        bh=w2GZ9D1qoyvSkgnyjIsWsEO06r80xGwaHHmxaAjuloc=;
        b=ZZfY4LL84+kd4V47qEDcKeA+CFtu3l/jOPsLZpz/Sitx0EN6Tzg8HKJYYiFJ+qLqVZ
         JDyfRCXdbzHhgqWvah962j503MiLv+8UOa8Qof5WC5hR8ZtdhkqAg8qpy/L0/lUQGnJu
         wl8NrQCNIbr+uf9ENLcKSawcYhb+B29sDIpTRCMTBPAz+ZDimakDiofvEaYLJQzW2Qqq
         HjNysorSEKRH6f8cV6/TgLqEi+Osw2OZMqZNqiCWSPlZsYkW2y0n7Wk2I7BaDioZqltW
         DUkQqLpvWjRGkcICB6VHYIC8bID5mnsijB/jrvNwXivO2V5CnltXDif00XRck16rglqO
         hvfA==
X-Gm-Message-State: AOAM533LZsvP1hN3U47SJ4YvGwZv45spKhVebBavtiSNP25mBadTxHzX
        IQ+Q8b38r8ubZWmLpUBl4eo=
X-Google-Smtp-Source: ABdhPJy9CA6JH+8SHSFRTCswUNkoFiAoPMulGfLzeqIOWseCvdHKP4qg4kb8JKOvot5bAFrbUg5R+A==
X-Received: by 2002:a02:7f4d:: with SMTP id r74mr24426375jac.51.1592291269465;
        Tue, 16 Jun 2020 00:07:49 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f18sm9242592ion.19.2020.06.16.00.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 00:07:48 -0700 (PDT)
Date:   Tue, 16 Jun 2020 00:07:40 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Gaurav Singh <gaurav1086@gmail.com>, gaurav1086@gmail.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "(open list:BPF \\(Safe dynamic programs and tools\\))" 
        <netdev@vger.kernel.org>,
        bpf@vger.kernel.org (open list:BPF \(Safe dynamic programs and tools\)),
        "(open list:BPF \\(Safe dynamic programs and tools\\) open list)" 
        <linux-kernel@vger.kernel.org>
Message-ID: <5ee86fbc41c03_4be02ab1b668a5b422@john-XPS-13-9370.notmuch>
In-Reply-To: <20200614190434.31321-1-gaurav1086@gmail.com>
References: <20200614190434.31321-1-gaurav1086@gmail.com>
Subject: RE: [PATCH] [bpf] xdp_redirect_cpu_user: Fix null pointer dereference
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gaurav Singh wrote:
> Memset() on the pointer right after malloc() can cause
> a null pointer dereference if it failed to allocate memory.
> Fix this by replacing malloc/memset with a single calloc().
> 
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
> ---
>  samples/bpf/xdp_redirect_cpu_user.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
> index f3468168982e..2ae7a9a1d950 100644
> --- a/samples/bpf/xdp_redirect_cpu_user.c
> +++ b/samples/bpf/xdp_redirect_cpu_user.c
> @@ -207,11 +207,8 @@ static struct datarec *alloc_record_per_cpu(void)
>  {
>  	unsigned int nr_cpus = bpf_num_possible_cpus();
>  	struct datarec *array;
> -	size_t size;
>  
> -	size = sizeof(struct datarec) * nr_cpus;
> -	array = malloc(size);
> -	memset(array, 0, size);
> +	array = calloc(nr_cpus, sizeof(struct datarec));
>  	if (!array) {
>  		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
>  		exit(EXIT_FAIL_MEM);
> @@ -222,11 +219,9 @@ static struct datarec *alloc_record_per_cpu(void)
>  static struct stats_record *alloc_stats_record(void)
>  {
>  	struct stats_record *rec;
> -	int i, size;
> +	int i;
>  
> -	size = sizeof(*rec) + n_cpus * sizeof(struct record);
> -	rec = malloc(size);
> -	memset(rec, 0, size);
> +	rec = calloc(n_cpus + 1, sizeof(struct record));
>  	if (!rec) {
>  		fprintf(stderr, "Mem alloc error\n");
>  		exit(EXIT_FAIL_MEM);
> -- 
> 2.17.1
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
