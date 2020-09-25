Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68714278E53
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 18:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgIYQYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 12:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbgIYQYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 12:24:12 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9C1C0613CE;
        Fri, 25 Sep 2020 09:24:12 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id c13so3348841oiy.6;
        Fri, 25 Sep 2020 09:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ggTSlAK8V0yAHpycYnz3OTRWUPOuUqY3u82fdl5Csrk=;
        b=KmJ8f8nPlVMuveROhgr9LLhCw+rn07DbzSzux4MJCuWB1EHl6Iqj6RWlOXLXddcEhZ
         k9uLPpy/5YeFybc7Um4y/hpOYSryZ15MOLsex/oNWDE+DSkM6iVBFx/apdnkmR4+eNIM
         a3xEbwPBZe8I5DuaRy1t3Lq+9staqHg7WwfXl+TmSwdzbqR7pmiY4s+btUafegF0G0rn
         5SHDUnYPzMbC6z9RpJ6RH4WlufH3H5AbbrEpUw0zHIxPcKbtNOP/bd5+1i5KUZpbPvM6
         2YQ6qCbMMq9mem4iyj3eHBAwIDCPs+jiJIdb11JDeUaJyRnloGNmSmujgBMoBOGCopmn
         Qw1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ggTSlAK8V0yAHpycYnz3OTRWUPOuUqY3u82fdl5Csrk=;
        b=MKLSNoKT6/lAR4HxR64Mq2XsDTnb+GMdka0H5jxFoNCvRHaRejMMWeIVWTE9j/grdU
         GKLc4wPe/hyNypfFxKjQ5AYZmChCQVR5UUqDCAol2lrV0o4WOb10O33/m0CF/r7iE25R
         zh8Z2X4HyPYlFo3v+embPYa8MnnHY2e0gJioYyXkLnRE3sdkgMk1pyxRYPx2GUbYmd7Z
         ccHSrHWsRB6kyjcyqk92x25aemb/PUjs0xFrUXINUMywQuL/rzYzI51O1Fh6fN8FmFlS
         eeY9VOb54H9U/FvAoRIpGKgUhxZXFUKw7yoHn3nKQBXGhTv0HkuYiH/qwToCjNDXz11g
         M9KA==
X-Gm-Message-State: AOAM532FL1LijI2rXxgfLXK8g8XF4l8PnWgPJNXbhHk6LfrihMquiya1
        ChCUFSPQ7Ks3Cnn1wXaRYH4=
X-Google-Smtp-Source: ABdhPJwHmXXCPLnHVoKab8hdLtSFDDhIjUa2qR5nZE06mN+2Cn4RfoLLpS1v5GSy7Yj6tAjc2uVf+A==
X-Received: by 2002:aca:4007:: with SMTP id n7mr74013oia.160.1601051051368;
        Fri, 25 Sep 2020 09:24:11 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y7sm749204ots.11.2020.09.25.09.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 09:24:10 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:24:02 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Lorenz Bauer <lmb@cloudflare.com>, netdev@vger.kernel.org
Message-ID: <5f6e19a2621d8_8ae15208fd@john-XPS-13-9370.notmuch>
In-Reply-To: <20200925000458.3859627-1-kafai@fb.com>
References: <20200925000337.3853598-1-kafai@fb.com>
 <20200925000458.3859627-1-kafai@fb.com>
Subject: RE: [PATCH v4 bpf-next 13/13] bpf: selftest: Add
 test_btf_skc_cls_ingress
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau wrote:
> This patch attaches a classifier prog to the ingress filter.
> It exercises the following helpers with different socket pointer
> types in different logical branches:
> 1. bpf_sk_release()
> 2. bpf_sk_assign()
> 3. bpf_skc_to_tcp_request_sock(), bpf_skc_to_tcp_sock()
> 4. bpf_tcp_gen_syncookie, bpf_tcp_check_syncookie
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  tools/testing/selftests/bpf/bpf_tcp_helpers.h |   5 +
>  .../bpf/prog_tests/btf_skc_cls_ingress.c      | 234 ++++++++++++++++++
>  .../bpf/progs/test_btf_skc_cls_ingress.c      | 174 +++++++++++++
>  3 files changed, 413 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_btf_skc_cls_ingress.c
> 


Hi Martin,

One piece I'm missing is how does this handle null pointer dereferences
from network side when reading BTF objects? I've not got through all the
code yet so maybe I'm just not there yet.

For example,

> diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> index a0e8b3758bd7..2915664c335d 100644
> --- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> @@ -16,6 +16,7 @@ BPF_PROG(name, args)
>  
>  struct sock_common {
>  	unsigned char	skc_state;
> +	__u16		skc_num;
>  } __attribute__((preserve_access_index));
>  
>  enum sk_pacing {
> @@ -45,6 +46,10 @@ struct inet_connection_sock {
>  	__u64			  icsk_ca_priv[104 / sizeof(__u64)];
>  } __attribute__((preserve_access_index));
>  
> +struct request_sock {
> +	struct sock_common		__req_common;
> +} __attribute__((preserve_access_index));
> +
>  struct tcp_sock {
>  	struct inet_connection_sock	inet_conn;

add some pointer from tcp_sock which is likely not set so should be NULL,

        struct tcp_fastopen_request *fastopen_req;

[...]

> +	if (bpf_skc->state == BPF_TCP_NEW_SYN_RECV) {
> +		struct request_sock *req_sk;
> +
> +		req_sk = (struct request_sock *)bpf_skc_to_tcp_request_sock(bpf_skc);
> +		if (!req_sk) {
> +			LOG();
> +			goto release;
> +		}
> +
> +		if (bpf_sk_assign(skb, req_sk, 0)) {
> +			LOG();
> +			goto release;
> +		}
> +
> +		req_sk_sport = req_sk->__req_common.skc_num;
> +
> +		bpf_sk_release(req_sk);
> +		return TC_ACT_OK;
> +	} else if (bpf_skc->state == BPF_TCP_LISTEN) {
> +		struct tcp_sock *tp;
> +
> +		tp = bpf_skc_to_tcp_sock(bpf_skc);
> +		if (!tp) {
> +			LOG();
> +			goto release;
> +		}
> +
> +		if (bpf_sk_assign(skb, tp, 0)) {
> +			LOG();
> +			goto release;
> +		}
> +


Then use it here without a null check in the BPF program,

                fastopen = tp->fastopen_req;
		if (fastopen->size > 0x1234)
                      (do something)

> +		listen_tp_sport = tp->inet_conn.icsk_inet.sk.__sk_common.skc_num;
> +
> +		test_syncookie_helper(ip6h, th, tp, skb);
> +		bpf_sk_release(tp);
> +		return TC_ACT_OK;
> +	}

My quick check shows this didn't actually fault and the xlated
looks like it did the read and dereference. Must be missing
something? We shouldn't have fault_handler set for cls_ingress.

Perhaps a comment in the cover letter about this would be
helpful? Or if I'm just being dense this morning let me know
as well. ;)

> +
> +	if (bpf_sk_assign(skb, bpf_skc, 0))
> +		LOG();
> +
> +release:
> +	bpf_sk_release(bpf_skc);
> +	return TC_ACT_OK;
> +}
