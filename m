Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 521026E9CEC
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 22:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbjDTURB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 16:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjDTURA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 16:17:00 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C181BF2;
        Thu, 20 Apr 2023 13:16:59 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 98e67ed59e1d1-24799a2ee83so998768a91.3;
        Thu, 20 Apr 2023 13:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682021819; x=1684613819;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vi/5IWUJCZ+MlgvfYraXgzpUkAS2oM24xoqqPnQf/YI=;
        b=dV42e7Vkps+t6ET/772FsBPjIZ4gC0D3dvXdfJKZuY9cAt+IKi9X5G8CVMO00R+TvA
         1Y9QS7x1SaQo6mUIiYOBur6JnfekOZdURGtQqpBwncLc3UyZIur1S3gCoHDnUEp8pA1Q
         RhdIO4k6hQhiCLlT8hudEpEOnjjA1HJhZEAl34We+X+OFxRC5Z1SM8CG3ndUfYv5YQ6L
         ZrBX/OWWcNCG01ky3vsi6afRziZUW6lDAnQwxwGgTsz1ugU5Dfk2APkHl4XSDGYer/5X
         SSoIPAMqNwSl5ZXVtvZxhZWcL/ojAOWW8G81dwvkJLkdxh6xy8356nbJwDMEiCZc9dL/
         b7WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682021819; x=1684613819;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vi/5IWUJCZ+MlgvfYraXgzpUkAS2oM24xoqqPnQf/YI=;
        b=GbQM7QPt0OVEKX7Pv5GzcelpyUmHbMzrveh/jkA4Sx+mqxHkKjqCcXH1Cp7DqeFeZP
         +NyZdsTYU8B7RS2tC7LfzsYVuy1BV0iL2XplxDYqcd0uLaRw976c7EmbL3ImqoINhCZg
         0UPM43/H/8Hgn7kSrStjsP3OoqxU8HxPo5pm3r0UupEiZbd/WF93iLVwea1ZmbB+wwkB
         sQIdqUwuomXlDJGae/dmYvsynNVIvCxyY1W4FR4/yZyY5bgqhuzqV4bi5LD5gu7Vz4ys
         gHzjK+zZRzSBjKNP0r5fP/a6BvGNf0oamJuw3J+1cVukwKTmlUo/mh0m+Sh1sH6te2bq
         GbUQ==
X-Gm-Message-State: AAQBX9d6BW+xi7YkSQdJKlBTuEWVQFVkO8mN41YLF1sKWRrSO4wEIW+W
        ZK36/KkKbfDf08xQXIkn1WvCNZKrf7M=
X-Google-Smtp-Source: AKy350ZvVCUDyHLsj6B7V9atfmuATlg+miWddlzseYXDrSdie6phfayQvuZiI85wqhLXc4pMRII+IQ==
X-Received: by 2002:a17:90b:4d8d:b0:247:3e0a:71cd with SMTP id oj13-20020a17090b4d8d00b002473e0a71cdmr2750411pjb.6.1682021818985;
        Thu, 20 Apr 2023 13:16:58 -0700 (PDT)
Received: from MacBook-Pro-6.local ([2620:10d:c090:500::5:cf1d])
        by smtp.gmail.com with ESMTPSA id y8-20020a17090a784800b002476ee46dbfsm3288781pjl.57.2023.04.20.13.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 13:16:58 -0700 (PDT)
Date:   Thu, 20 Apr 2023 13:16:55 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, dxu@dxuuu.xyz, qde@naccy.de
Subject: Re: [PATCH bpf-next v4 7/7] selftests/bpf: add missing netfilter
 return value and ctx access tests
Message-ID: <20230420201655.77kkgi3dh7fesoll@MacBook-Pro-6.local>
References: <20230420124455.31099-1-fw@strlen.de>
 <20230420124455.31099-8-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420124455.31099-8-fw@strlen.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 02:44:55PM +0200, Florian Westphal wrote:
> +
> +SEC("netfilter")
> +__description("netfilter valid context access")
> +__success __failure_unpriv
> +__retval(1)
> +__naked void with_invalid_ctx_access_test5(void)
> +{
> +	asm volatile ("					\
> +	r2 = *(u64*)(r1 + %[__bpf_nf_ctx_state]);	\
> +	r1 = *(u64*)(r1 + %[__bpf_nf_ctx_skb]);		\
> +	r0 = 1;						\
> +	exit;						\
> +"	:
> +	: __imm_const(__bpf_nf_ctx_state, offsetof(struct bpf_nf_ctx, state)),
> +	  __imm_const(__bpf_nf_ctx_skb, offsetof(struct bpf_nf_ctx, skb))
> +	: __clobber_all);

Could you write this one in C instead?
Also check that skb and state are dereferenceable after that.
Since they should be seen as trusted ptr_to_btf_id skb->len and state->sk should work.
You cannot craft this test case in asm, since it needs CO-RE.

Also see that BPF CI is not happy:
https://github.com/kernel-patches/bpf/actions/runs/4757642030/jobs/8455500277
Error: #112 libbpf_probe_prog_types
Error: #112/32 libbpf_probe_prog_types/BPF_PROG_TYPE_NETFILTER
Error: #113 libbpf_str
Error: #113/4 libbpf_str/bpf_prog_type_str
