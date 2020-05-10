Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447CE1CC5D0
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 02:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgEJAlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 20:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726778AbgEJAln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 20:41:43 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B12C061A0C;
        Sat,  9 May 2020 17:41:43 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id r22so1129268pga.12;
        Sat, 09 May 2020 17:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=46tABJsTFEZXbjBTEhMjktkP7+Lc7a/dZ9VNTH+uahA=;
        b=XebyrWOkDUwfaHKLIMHrVYv2gRmgQab++i7anNE1zwJe4eSMTga2TVzaV/zUNWcBUt
         PXFCC0FY1x5pD61Aez1P7g1vwqNPt48F03pWTnsRuUzGcdsNLeKUt9gsBVRXYbjn8QeO
         so4v4ch9neuISHlxc6GLoMCDtAO3f2131yr772Lm4G8IZxLxRauX07WLaS4fvyzsEqPo
         U2us53w1pSYmi6Htfjt/tID1mHTwq8Oz0dyGno/MLQj18HryywxmiqqF6YZsug8jCaND
         C95KG6+JcxmOI7pqcrh0/SZ1eU58EJ0WSTOv9OqrWVYyf8avnAa6jGODDNQ1rKYqaAKD
         NyIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=46tABJsTFEZXbjBTEhMjktkP7+Lc7a/dZ9VNTH+uahA=;
        b=d1SCXh0ufZ+X7DDgkYnxu0wrxDbnHN1hC9HRRBxREVu38sJgYa7jK4cgb5BsmNTvJJ
         b4WhI4ZQGN1NnG9/Bp79qVG7AqspaC2lhApknYKk5NwTEiNYlPASe1HVpi5hmAAkJmWD
         Amr086oSScUIW/FIFXWYuuw54XxsGr0GYo0WAUf1yNajzWYroExtFqxVyPsHrBgCJMPz
         gwqGNp7SOI1EEtF0JwLQfUAiEYBz/ahtc/P7M6MoM6FG5sjGnRwZmlnbxohnVfAgXdEE
         XaNocT+hhUm1EBj0ii5K1RlZfNSwq15M7VJlFGL6ukgnG26XUS4GonRn9N+VPyZU6jFX
         pDhA==
X-Gm-Message-State: AGi0PuZlVqPrEE2Rm8GQpQDHW4wuQ09AyIdKj3T6Mb8uczs/o1j8ldHt
        xJA00jPd4cHEFJM0V7cJ52o=
X-Google-Smtp-Source: APiQypLqQA+ITBBspbKKqxhe4GRiyVvDPn4soSfqS+LwFtQ8JhgmjF1RE6hg/5DjbADwtAiSCTBRGg==
X-Received: by 2002:a05:6a00:2b4:: with SMTP id q20mr9907950pfs.104.1589071302501;
        Sat, 09 May 2020 17:41:42 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:7bdb])
        by smtp.gmail.com with ESMTPSA id k10sm5545538pfa.163.2020.05.09.17.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2020 17:41:41 -0700 (PDT)
Date:   Sat, 9 May 2020 17:41:39 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: Re: [PATCH bpf-next v4 02/21] bpf: allow loading of a bpf_iter
 program
Message-ID: <20200510004139.tjlll6wqq7zevb73@ast-mbp>
References: <20200509175859.2474608-1-yhs@fb.com>
 <20200509175900.2474947-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509175900.2474947-1-yhs@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 10:59:00AM -0700, Yonghong Song wrote:
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 70ad009577f8..d725ff7d11db 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7101,6 +7101,10 @@ static int check_return_code(struct bpf_verifier_env *env)
>  			return 0;
>  		range = tnum_const(0);
>  		break;
> +	case BPF_PROG_TYPE_TRACING:
> +		if (env->prog->expected_attach_type != BPF_TRACE_ITER)
> +			return 0;
> +		break;

Not related to this set, but I just noticed that I managed to forget to
add this check for fentry/fexit/freplace.
While it's not too late let's enforce return 0 for them ?
Could you follow up with a patch for bpf tree?
