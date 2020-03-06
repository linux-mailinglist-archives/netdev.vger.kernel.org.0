Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA5617C201
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 16:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbgCFPjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 10:39:40 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43915 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbgCFPjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 10:39:39 -0500
Received: by mail-pf1-f196.google.com with SMTP id c144so1275412pfb.10;
        Fri, 06 Mar 2020 07:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=01auyVOQOnmmGHsCrlqWNGYttolHZqoJ9JgRiuGuMyo=;
        b=hosp7VIcMUWHTTtVxmxRimw0gy07kUqT8NA98th/tukhekAjpmE8g8JYMtkOzCXB31
         29x3wzxR4HB4/oUZyAjM7BMZzDZKyENSMfFNWHm2kO0Gqjxi3BqZ15XVUaWyWtXPiX8D
         alwEyUpvEeEm8BtjucFLQBpLr7CYdQ2qcNjmt2niw+kAoKRupMMk5fdoL1zmNdggC/qx
         Q0ESkMnJShesRHVjXQ1qbGzZBp2s7Ij3O73pkGrpQl4JYEKzf+0tqFwUzc5gGRVVhFVY
         bTOdROal3tbu0uUEI/pp57/iigfcCH6KBP41zw/lDKeQVB7zLQQQu8TN4Ra4vtyFCO94
         cl3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=01auyVOQOnmmGHsCrlqWNGYttolHZqoJ9JgRiuGuMyo=;
        b=qN+Asv7BaFDSp+TeHSPBnh6grEYvnhVrg5lkTfa+0gg+9ILQO3PueoIEy+nQAAgL4M
         TU2zM67W9PqGjkV7zrNiIR/2IdrNSm4pZagbw/TCQRp02Cxk+tbbTqzuTbFnH48Uw33y
         kxf9JanrkYQkkVwMl6up45KhnIa/79/RtvuHhYOo85Iu+GgZEMstic/HfWJCzMvtTVAn
         d8eWsi1aTrqxMygK0E1vlFo375ohDRRA8jWnGv/EBJuEcc5bB+K+umPLirlPusCsAxyl
         1tVb3kmKdlb9uIJcHepgUmSDRxemY+6CHjc3q28ro5qgDIxKM+18ATVZi+tyTAKGT6UQ
         SnLQ==
X-Gm-Message-State: ANhLgQ3z2fYcnXnZblXym4RfuJUzT/ttQadhELYvNzHrJo8yBE+auh86
        PCP8j8xH08CBMufZUsfYWyc=
X-Google-Smtp-Source: ADFU+vs5TxpEZaOTbbgCG5qzJAurHhrkyvHQs6W0vh8sDSjdQa8Y+I5b3jm+pRY4Q1PRPXiDu4yZWw==
X-Received: by 2002:aa7:83d7:: with SMTP id j23mr1135850pfn.77.1583509178257;
        Fri, 06 Mar 2020 07:39:38 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g11sm7861075pfo.184.2020.03.06.07.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 07:39:37 -0800 (PST)
Date:   Fri, 06 Mar 2020 07:39:29 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, john.fastabend@gmail.com,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5e626eb118da1_17502acca07205b42f@john-XPS-13-9370.notmuch>
In-Reply-To: <20200304101318.5225-12-lmb@cloudflare.com>
References: <20200304101318.5225-1-lmb@cloudflare.com>
 <20200304101318.5225-12-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next v3 11/12] selftests: bpf: enable UDP sockmap
 reuseport tests
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> Remove the guard that disables UDP tests now that sockmap
> has support for them.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/select_reuseport.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
> index a1dd13b34d4b..821b4146b7b6 100644
> --- a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
> +++ b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
> @@ -805,12 +805,6 @@ static void test_config(int sotype, sa_family_t family, bool inany)
>  	char s[MAX_TEST_NAME];
>  	const struct test *t;
>  
> -	/* SOCKMAP/SOCKHASH don't support UDP yet */
> -	if (sotype == SOCK_DGRAM &&
> -	    (inner_map_type == BPF_MAP_TYPE_SOCKMAP ||
> -	     inner_map_type == BPF_MAP_TYPE_SOCKHASH))
> -		return;
> -
>  	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
>  		if (t->need_sotype && t->need_sotype != sotype)
>  			continue; /* test not compatible with socket type */
> -- 
> 2.20.1
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
