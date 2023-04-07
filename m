Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9676DA702
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 03:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239278AbjDGBgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 21:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjDGBgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 21:36:43 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D5A26BC;
        Thu,  6 Apr 2023 18:36:42 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c18so38956248ple.11;
        Thu, 06 Apr 2023 18:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680831402; x=1683423402;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I9YDMioh72y0Ct+xcPOrxHBVx5V7y8eDftq4hNHLa8A=;
        b=osuk2aWLJNIdTD2oEL3mVDMzMfMyP/1Hj9UeuaiFScZw1UciE9NfKMgnypmkMgHfrv
         eioDfMkmC3TVuEL4Z2bYA099YZauav8QDyrdzkDrSy5Y7GTpcqOR1uBKGwu2DjfB/qUC
         ikbGmtsKlQhhaelD84xeUcD9kmDfzNeKNIezmDTdlXKswRuyoEx6sVUzBKU/NoqkHLRD
         R6z/5KTIkjLluFEb3jQ+GTPiTN9vbagZPYsmF0FP++BMdgsNBviqNndjDpWa0wG1UtXo
         NpJtaLKpZYEZcN/M81Pq+ErDbR/q6XnPyXgX2Fc3umkDGAJYyCVSrUv3IUlJAAV17yZH
         UXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680831402; x=1683423402;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I9YDMioh72y0Ct+xcPOrxHBVx5V7y8eDftq4hNHLa8A=;
        b=wd2gt9nr1ZBhqKm+c/E6+puJD9MZWE2Oj0aWwhm6rvYRhT3Ib4sZOGi9aOtBpCQN2O
         kDp0L1mHjwXrO/ToVZCoo/7E2eafaVDCJJswuXo1cIV/nh+3OgzmuWu7caOn6hPfJSh1
         BBb7QYz+KJKbhQ4GdEjiJC3uVI+4xJCv4BSMpr1ZXqWbsiUdLw0uEAWqMH1mALmOm2VG
         +yoMpR8aXhLDgc4elnuFapRlYMbBOGZrMDJ8Z9zOh7eP2jjIUb4Vo836l8FWSZqfk/YY
         +8+y5uF3MRCsy1u5SF1ECkMLzoBfnh33t42xonPs8wRP9ju1/JLnqJJTk65C+RZuoHY8
         v0XQ==
X-Gm-Message-State: AAQBX9e6wuGe2tdxm1y+kDvZNQA9cZYIBWTrgcVtOnTpLmmyKqkHQ541
        oIY90lRvVPPPha0UKhAmHrQI3cqInog=
X-Google-Smtp-Source: AKy350bzsc0oH42YAlUsTSNMLXBiXNfn2eMgxfMRaENOsfCyODciiKTpmq785mF4lNlWzvsrCSKggA==
X-Received: by 2002:a05:6a20:c521:b0:d9:7424:341b with SMTP id gm33-20020a056a20c52100b000d97424341bmr1389304pzb.9.1680831401447;
        Thu, 06 Apr 2023 18:36:41 -0700 (PDT)
Received: from dhcp-172-26-102-232.dhcp.thefacebook.com ([2620:10d:c090:400::5:5abd])
        by smtp.gmail.com with ESMTPSA id 3-20020a630a03000000b00476d1385265sm1686852pgk.25.2023.04.06.18.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 18:36:41 -0700 (PDT)
Date:   Thu, 6 Apr 2023 18:36:38 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        bpf@vger.kernel.org, dxu@dxuuu.xyz, qde@naccy.de
Subject: Re: [PATCH bpf-next 6/6] bpf: add test_run support for netfilter
 program type
Message-ID: <20230407013638.iels3lvezufbrenr@dhcp-172-26-102-232.dhcp.thefacebook.com>
References: <20230405161116.13565-1-fw@strlen.de>
 <20230405161116.13565-7-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405161116.13565-7-fw@strlen.de>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 06:11:16PM +0200, Florian Westphal wrote:
> also add two simple retval tests: as-is, a return value other
> than accept or drop will cause issues.
> 
> NF_QUEUE could be implemented later IFF we can guarantee that
> attachment of such programs can be rejected if they get attached
> to a pf/hook that doesn't support async reinjection.
> 
> NF_STOLEN could be implemented via trusted helpers that will eventually
> free the skb, else this would leak the skb reference.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/linux/bpf.h                           |   3 +
>  net/bpf/test_run.c                            | 143 ++++++++++++++++++
>  net/netfilter/nf_bpf_link.c                   |   1 +
>  .../selftests/bpf/verifier/netfilter.c        |  23 +++
>  4 files changed, 170 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/verifier/netfilter.c
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 2d8f3f639e68..453cee1efdd3 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -2235,6 +2235,9 @@ int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
>  int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
>  				const union bpf_attr *kattr,
>  				union bpf_attr __user *uattr);
> +int bpf_prog_test_run_nf(struct bpf_prog *prog,
> +			 const union bpf_attr *kattr,
> +			 union bpf_attr __user *uattr);
>  bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>  		    const struct bpf_prog *prog,
>  		    struct bpf_insn_access_aux *info);
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index f1652f5fbd2e..c14f577fd987 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -19,7 +19,9 @@
>  #include <linux/error-injection.h>
>  #include <linux/smp.h>
>  #include <linux/sock_diag.h>
> +#include <linux/netfilter.h>
>  #include <net/xdp.h>
> +#include <net/netfilter/nf_bpf_link.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/bpf_test_run.h>
> @@ -1690,6 +1692,147 @@ int bpf_prog_test_run_syscall(struct bpf_prog *prog,
>  	return err;
>  }
>  
> +static int verify_and_copy_hook_state(struct nf_hook_state *state,
> +				      const struct nf_hook_state *user,
> +				      struct net_device *dev)
> +{
> +	if (user->in || user->out)
> +		return -EINVAL;
> +
> +	if (user->net || user->sk || user->okfn)
> +		return -EINVAL;
> +
> +	switch (user->pf) {
> +	case NFPROTO_IPV4:
> +	case NFPROTO_IPV6:
> +		switch (state->hook) {
> +		case NF_INET_PRE_ROUTING:
> +			state->in = dev;
> +			break;
> +		case NF_INET_LOCAL_IN:
> +			state->in = dev;
> +			break;
> +		case NF_INET_FORWARD:
> +			state->in = dev;
> +			state->out = dev;
> +			break;
> +		case NF_INET_LOCAL_OUT:
> +			state->out = dev;
> +			break;
> +		case NF_INET_POST_ROUTING:
> +			state->out = dev;
> +			break;
> +		}
> +
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	state->pf = user->pf;
> +	state->hook = user->hook;
> +
> +	return 0;
> +}
> +
> +int bpf_prog_test_run_nf(struct bpf_prog *prog,
> +			 const union bpf_attr *kattr,
> +			 union bpf_attr __user *uattr)
> +{
> +	struct net *net = current->nsproxy->net_ns;
> +	struct net_device *dev = net->loopback_dev;
> +	struct nf_hook_state *user_ctx, hook_state = {
> +		.pf = NFPROTO_IPV4,
> +		.hook = NF_INET_PRE_ROUTING,
> +	};
> +	u32 size = kattr->test.data_size_in;
> +	u32 repeat = kattr->test.repeat;
> +	const struct ethhdr *eth;
> +	struct bpf_nf_ctx ctx = {
> +		.state = &hook_state,
> +	};
> +	struct sk_buff *skb = NULL;
> +	u32 retval, duration;
> +	void *data;
> +	int ret;
> +
> +	if (kattr->test.flags || kattr->test.cpu || kattr->test.batch_size)
> +		return -EINVAL;
> +
> +	if (size < ETH_HLEN + sizeof(struct iphdr))
> +		return -EINVAL;
> +
> +	data = bpf_test_init(kattr, kattr->test.data_size_in, size,
> +			     NET_SKB_PAD + NET_IP_ALIGN,
> +			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
> +	if (IS_ERR(data))
> +		return PTR_ERR(data);
> +
> +	eth = (struct ethhdr *)data;
> +
> +	if (!repeat)
> +		repeat = 1;
> +
> +	user_ctx = bpf_ctx_init(kattr, sizeof(struct nf_hook_state));
> +	if (IS_ERR(user_ctx)) {
> +		kfree(data);
> +		return PTR_ERR(user_ctx);
> +	}
> +
> +	if (user_ctx) {
> +		ret = verify_and_copy_hook_state(&hook_state, user_ctx, dev);
> +		if (ret)
> +			goto out;
> +	}
> +
> +	skb = slab_build_skb(data);
> +	if (!skb) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	data = NULL; /* data released via kfree_skb */
> +
> +	skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
> +	__skb_put(skb, size);
> +
> +	skb->protocol = eth_type_trans(skb, dev);
> +
> +	skb_reset_network_header(skb);
> +
> +	ret = -EINVAL;
> +
> +	switch (skb->protocol) {
> +	case htons(ETH_P_IP):
> +		if (hook_state.pf == NFPROTO_IPV4)
> +			break;
> +		goto out;
> +	case htons(ETH_P_IPV6):
> +		if (size < ETH_HLEN + sizeof(struct ipv6hdr))
> +			goto out;
> +		if (hook_state.pf == NFPROTO_IPV6)
> +			break;
> +		goto out;
> +	default:
> +		ret = -EPROTO;
> +		goto out;
> +	}
> +
> +	ctx.skb = skb;
> +
> +	ret = bpf_test_run(prog, &ctx, repeat, &retval, &duration, false);
> +	if (ret)
> +		goto out;
> +
> +	ret = bpf_test_finish(kattr, uattr, NULL, NULL, 0, retval, duration);
> +
> +out:
> +	kfree(user_ctx);
> +	kfree_skb(skb);
> +	kfree(data);
> +	return ret;
> +}
> +
>  static const struct btf_kfunc_id_set bpf_prog_test_kfunc_set = {
>  	.owner = THIS_MODULE,
>  	.set   = &test_sk_check_kfunc_ids,
> diff --git a/net/netfilter/nf_bpf_link.c b/net/netfilter/nf_bpf_link.c
> index 4b22a31d6df5..c27fd569adf1 100644
> --- a/net/netfilter/nf_bpf_link.c
> +++ b/net/netfilter/nf_bpf_link.c
> @@ -128,6 +128,7 @@ int bpf_nf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>  }
>  
>  const struct bpf_prog_ops netfilter_prog_ops = {
> +	.test_run = bpf_prog_test_run_nf,
>  };
>  
>  static bool nf_ptr_to_btf_id(struct bpf_insn_access_aux *info, const char *name)
> diff --git a/tools/testing/selftests/bpf/verifier/netfilter.c b/tools/testing/selftests/bpf/verifier/netfilter.c
> new file mode 100644
> index 000000000000..deeb87afdf50
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/verifier/netfilter.c
> @@ -0,0 +1,23 @@
> +{
> +	"netfilter, accept all",
> +	.insns = {
> +	BPF_MOV64_IMM(BPF_REG_0, 1),
> +	BPF_EXIT_INSN(),
> +	},
> +	.result = ACCEPT,
> +	.prog_type = BPF_PROG_TYPE_NETFILTER,
> +	.retval = 1,
> +	.data = {
> +		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x08, 0x00,
> +	},
> +},
> +{
> +	"netfilter, stolen verdict",
> +	.insns = {
> +	BPF_MOV64_IMM(BPF_REG_0, 2),
> +	BPF_EXIT_INSN(),
> +	},
> +	.result = REJECT,
> +	.errstr = "At program exit the register R0 has value (0x2; 0x0) should have been in (0x0; 0x1)",
> +	.prog_type = BPF_PROG_TYPE_NETFILTER,

We're adding all new asm tests to test_progs now instead of test_verifier. See progs/verifier_*.c.

Other than this nit and build bot complains it looks good to me.
