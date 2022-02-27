Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C1F4C591D
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 04:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiB0D0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 22:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiB0DZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 22:25:59 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFEB3DA42;
        Sat, 26 Feb 2022 19:25:24 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id z4so8420184pgh.12;
        Sat, 26 Feb 2022 19:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kv83Ky//M61kMW3XVbVTaEo0StiQOL3eN+TkygAnhs0=;
        b=Pe+S9oIU9PsIcNQHUoOJBZW3IB7VzE68V3KXYdG+S2R/Nyr7yQL/1hIyFpz5VYEalb
         iofoAOQMJnfoBVGuZMVRa6muJFSf9f/vQuljTAM7msYXvcoA1S5VJgPn9uTt+6uxpL5X
         rfvkOQcXMSyPnDf7PI9V0oOJ2PX+3uq6bsb3GzgDn6Iyx1G3iEklXyZyPe996OuKchJn
         PsvlkMN+1JOuDcWGIM8Vl0dbat0576IInhJSAnohyNID8iMDdG9rPP6GKTW59DIz8BSL
         3QpgF741du/Oez0t86Lla1+lBSl9tjjrz5hqfQVnTSov4f2J4D8dZ9DAL62U/BygVsMm
         xMkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kv83Ky//M61kMW3XVbVTaEo0StiQOL3eN+TkygAnhs0=;
        b=xKc/7kS+K3R0fKAY9LeY5vEN9Qqd1OigFaeiEnRdBlxajTNQh8kTta11zA2vr1zX9H
         GrgndWQhPDgSzXMw+alO9boXwQF6QW8t27CatucL25imeR7tClwgTBLUHn5KfVhAIh1M
         vJORLpsAE8OUXEHOiP1CI4HElmR7Vs5K/nndiBKQ/FnoUy5kSCMVZl2+xhEnMAl9e+7t
         ldxC0bC8MKWxK36Bo3LvbLS/E4xJMJU3i/6AVc0zZ9T1dgp/QHUfy9oQGJxio7ba0SkZ
         VcPobKqaNZSlFECMB7tvurNGp9NVme1Rng5xRIXda5hNfed2Sq80Ywb6+yh6rd40KA1+
         KMHw==
X-Gm-Message-State: AOAM532ez/mEGe3YhnRjRe+3oxm6NoUU1AJmSO1HCQK7vsrlVYqwDBz/
        61veLzls+T2vFvKYqWzS14tKyxnW1Y4=
X-Google-Smtp-Source: ABdhPJyxnZbJWwP8oJDjlUVrX3sPYjVHSW2MhOTlli5PUBb2ZLfnmQriVY6w48a5YxlU/dNCVEtgMg==
X-Received: by 2002:a65:6210:0:b0:374:ba5:aacc with SMTP id d16-20020a656210000000b003740ba5aaccmr12149961pgv.8.1645932323644;
        Sat, 26 Feb 2022 19:25:23 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:6566])
        by smtp.gmail.com with ESMTPSA id r15-20020a63ce4f000000b00341c40f913esm6617475pgi.87.2022.02.26.19.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Feb 2022 19:25:23 -0800 (PST)
Date:   Sat, 26 Feb 2022 19:25:19 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        linux-kselftest@vger.kernel.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH bpf-next v3 4/5] bpf: Add helpers to issue and check SYN
 cookies in XDP
Message-ID: <20220227032519.2pgbfassbxbkxjsn@ast-mbp.dhcp.thefacebook.com>
References: <20220224151145.355355-1-maximmi@nvidia.com>
 <20220224151145.355355-5-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224151145.355355-5-maximmi@nvidia.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FROM_FMBLA_NEWDOM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 05:11:44PM +0200, Maxim Mikityanskiy wrote:
> @@ -7798,6 +7916,14 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  		return &bpf_tcp_check_syncookie_proto;
>  	case BPF_FUNC_tcp_gen_syncookie:
>  		return &bpf_tcp_gen_syncookie_proto;
> +	case BPF_FUNC_tcp_raw_gen_syncookie_ipv4:
> +		return &bpf_tcp_raw_gen_syncookie_ipv4_proto;
> +	case BPF_FUNC_tcp_raw_gen_syncookie_ipv6:
> +		return &bpf_tcp_raw_gen_syncookie_ipv6_proto;
> +	case BPF_FUNC_tcp_raw_check_syncookie_ipv4:
> +		return &bpf_tcp_raw_check_syncookie_ipv4_proto;
> +	case BPF_FUNC_tcp_raw_check_syncookie_ipv6:
> +		return &bpf_tcp_raw_check_syncookie_ipv6_proto;
>  #endif

I understand that the main use case for new helpers is XDP specific,
but why limit them to XDP?
The feature looks generic and applicable to skb too.
