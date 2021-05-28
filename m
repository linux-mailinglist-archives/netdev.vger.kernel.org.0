Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136CB394837
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 23:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhE1VSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 17:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhE1VSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 17:18:02 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612F4C06174A;
        Fri, 28 May 2021 14:16:27 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id h11so4464079ili.9;
        Fri, 28 May 2021 14:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=v/OQV6XonkHYxsdEjj3UguFbh0a8sRENiwTRpA4hkmY=;
        b=LPKXWLBCj+PtNIEMS/vwVHQV8trS5iMljsTji0LZki2tWnTUpvZGfkRvFo8y7/O/Qj
         XTGvayeqLWmTnfQdj1vpI1NwDWmkGVYl/rhDbXNwp07LBC/Rzt6oHP8DBZXmKJWjhFRP
         FbQHcVlFM3PXFpdyNgsM02aCAYRqgAgWaUDzy6LQYSkR7tNaDp/TNn/epvRY1UyL4sqx
         6o73zZdVFOqlGjaqyxwNbyOs2CLxlqCJpNmsI7cv/pngv6iEZoMImldh9DM/plD2sCBU
         W72pO6wngWtpdQu1Vs32GmTK+RbynO0y5+PmTw65tFBmWBlyy1kwClMbZsSIRtTHaozB
         Etgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=v/OQV6XonkHYxsdEjj3UguFbh0a8sRENiwTRpA4hkmY=;
        b=WIFLAKTS8vjHgCTvN6LYfrFziO4PrFhyn5PIavYvLqrvcK+E8BbuLNZ0F2SR2e5ybL
         pNJrvbiuJ5d955KGF1/uWs6k2nVrX5RMyO715yn+S1AoChgN+IW1ELe7ug6G5Se3oHgJ
         dd8yDDCGdcO9daU2pf92v9IfW/R9e5p3IE0vbuhhje8unHw3XbafIguj9UHOlBPgFgBi
         l7zEImgHNzg1lzxnLRCAsSk3pU2p3FEsfjOGOPbK8RX95xHyf03n3++azYF25P1jsj72
         HMMhpPBTi4TvjCkueIlsc7jgP4HiFYFbY+Y4v+ENir/xiJj/2eDgXxd0XmNxLKXfuXar
         tEuw==
X-Gm-Message-State: AOAM533xkYuuX95dE7m38F6ly7U259+sWJ7jgE/GAljOlGoIgTlBmZxm
        hJlPApdQgVD/HFXQXAinezA=
X-Google-Smtp-Source: ABdhPJym82mfd955XOx3cHS8rdtodR8EySkpespmxV/v9qxsVv7wv0qkHAYGtmHmJJzfemYZkUZioQ==
X-Received: by 2002:a05:6e02:1b87:: with SMTP id h7mr8797964ili.185.1622236586782;
        Fri, 28 May 2021 14:16:26 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id x13sm3561637ilo.11.2021.05.28.14.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 14:16:26 -0700 (PDT)
Date:   Fri, 28 May 2021 14:16:17 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Yu Kuai <yukuai3@huawei.com>, shuah@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com
Message-ID: <60b15da184eef_303a420848@john-XPS-13-9370.notmuch>
In-Reply-To: <20210528090758.1108464-1-yukuai3@huawei.com>
References: <20210528090758.1108464-1-yukuai3@huawei.com>
Subject: RE: [PATCH] selftests/bpf: Fix return value check in attach_bpf()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yu Kuai wrote:
> use libbpf_get_error() to check the return value of
> bpf_program__attach().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  tools/testing/selftests/bpf/benchs/bench_rename.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/benchs/bench_rename.c b/tools/testing/selftests/bpf/benchs/bench_rename.c
> index c7ec114eca56..b7d4a1d74fca 100644
> --- a/tools/testing/selftests/bpf/benchs/bench_rename.c
> +++ b/tools/testing/selftests/bpf/benchs/bench_rename.c
> @@ -65,7 +65,7 @@ static void attach_bpf(struct bpf_program *prog)
>  	struct bpf_link *link;
>  
>  	link = bpf_program__attach(prog);
> -	if (!link) {
> +	if (libbpf_get_error(link)) {
>  		fprintf(stderr, "failed to attach program!\n");
>  		exit(1);
>  	}
> -- 

Probably should be IS_ERR(link) same as the other benchs/*.c progs.
