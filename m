Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C6827E5B8
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 11:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbgI3Jz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 05:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728695AbgI3Jz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 05:55:27 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BA2C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 02:55:25 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id b22so1349867lfs.13
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 02:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=XE1miD/WXymc166+9P29M5/HrdZzoXOquMtdo9GPAZs=;
        b=TjB+OISz2yXHVoyXaqXYREAKj5EaFJV9/XXdKvbDHUJ66b4xoU1dB4w3j6I2ezODd5
         c1q22MHDvoq69lStXABHdVyatSxRTV1X6x2Jjw3LMIrDrGycd5t/jq87N5EjIaAurbLP
         UOrqLrtgupu8J8JeuSYaFRExD9f86laYipu0s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=XE1miD/WXymc166+9P29M5/HrdZzoXOquMtdo9GPAZs=;
        b=lCqXGHdcyHIiFyJtVrVVgz6Ud4Er6JZ/jnlzjxeb4/L/VDb1O7dqzEVcNbP2zUbhgT
         tpGd2fTXuTXz9e9anCRrM1oXDfl74cux3Kvc6nmMnnElKG5fe9msi2ksaOptGAeuU6i9
         ltz8dATettm70X6UoLc6zYiHqV3UYY2xTHveGSdZIozc7v7GabYjg34z681xz/YkIA/W
         vk+CMtghEqXppcBYPUCW7iW6hTXuvpliEZkfqGEo75H9D9NVxNAB1KsCRyRd1jPQSpXu
         ctsY0r9PEZVsUE3PRJL0OxmSwLzMahS2+Toi3niCg2HtUfGJ4DUxf6vzrzed7t5oeVXD
         QdGA==
X-Gm-Message-State: AOAM530dSrQZdhQjoNIolIN0JIK2Yd9d4afwdnwz4kQEyNpLKAgbUL74
        3ilSCs7syLpTQBUCicRYOOOmLg==
X-Google-Smtp-Source: ABdhPJyaqWC72koT4GVJ6x45sZP7QGmDsOxW1rD0SyV004/f53oApmu+uxoajHCg9hTBQKSKgsxJMA==
X-Received: by 2002:a19:4bc8:: with SMTP id y191mr643586lfa.491.1601459723792;
        Wed, 30 Sep 2020 02:55:23 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id z7sm133935lfc.59.2020.09.30.02.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 02:55:23 -0700 (PDT)
References: <160109391820.6363.6475038352873960677.stgit@john-Precision-5820-Tower> <160109442512.6363.1622656051946413257.stgit@john-Precision-5820-Tower>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        lmb@cloudflare.com, Marek Majkowski <marek@cloudflare.com>
Subject: Re: [bpf-next PATCH 1/2] bpf, sockmap: add skb_adjust_room to pop bytes off ingress payload
In-reply-to: <160109442512.6363.1622656051946413257.stgit@john-Precision-5820-Tower>
Date:   Wed, 30 Sep 2020 11:55:22 +0200
Message-ID: <87eemjtwqd.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 06:27 AM CEST, John Fastabend wrote:
> This implements a new helper skb_adjust_room() so users can push/pop
> extra bytes from a BPF_SK_SKB_STREAM_VERDICT program.
>
> Some protocols may include headers and other information that we may
> not want to include when doing a redirect from a BPF_SK_SKB_STREAM_VERDICT
> program. One use case is to redirect TLS packets into a receive socket
> that doesn't expect TLS data. In TLS case the first 13B or so contain the
> protocol header. With KTLS the payload is decrypted so we should be able
> to redirect this to a receiving socket, but the receiving socket may not
> be expecting to receive a TLS header and discard the data. Using the
> above helper we can pop the header off and put an appropriate header on
> the payload. This allows for creating a proxy between protocols without
> extra hops through the stack or userspace.

This is useful stuff. Apart from the TLS use-case, you might want to pop
off proxy headers like PROXY v1/v2 (CC Marek):

  https://www.haproxy.org/download/1.8/doc/proxy-protocol.txt

>
> So in order to fix this case add skb_adjust_room() so users can strip the
> header. After this the user can strip the header and an unmodified receiv=
er
> thread will work correctly when data is redirected into the ingress path
> of a sock.
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  net/core/filter.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++=
++++
>  1 file changed, 51 insertions(+)
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 4d8dc7a31a78..d232358f1dcd 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -76,6 +76,7 @@
>  #include <net/bpf_sk_storage.h>
>  #include <net/transp_v6.h>
>  #include <linux/btf_ids.h>
> +#include <net/tls.h>
>
>  static const struct bpf_func_proto *
>  bpf_sk_base_func_proto(enum bpf_func_id func_id);
> @@ -3218,6 +3219,53 @@ static u32 __bpf_skb_max_len(const struct sk_buff =
*skb)
>  			  SKB_MAX_ALLOC;
>  }
>
> +BPF_CALL_4(sk_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
> +	   u32, mode, u64, flags)
> +{
> +	unsigned int len_diff_abs =3D abs(len_diff);
> +	bool shrink =3D len_diff < 0;
> +	int ret =3D 0;
> +
> +	if (unlikely(flags))
> +		return -EINVAL;
> +	if (unlikely(len_diff_abs > 0xfffU))
> +		return -EFAULT;
> +
> +	if (!shrink) {
> +		unsigned int grow =3D len_diff;
> +
> +		ret =3D skb_cow(skb, grow);
> +		if (likely(!ret)) {
> +			__skb_push(skb, len_diff_abs);
> +			memset(skb->data, 0, len_diff_abs);
> +		}
> +	} else {
> +		/* skb_ensure_writable() is not needed here, as we're
> +		 * already working on an uncloned skb.
> +		 */

I'm trying to digest the above comment. What if:

static int __strp_recv(=E2=80=A6)
{
        =E2=80=A6
	while (eaten < orig_len) {
		/* Always clone since we will consume something */
		skb =3D skb_clone(orig_skb, GFP_ATOMIC);
                =E2=80=A6
		head =3D strp->skb_head;
		if (!head) {
			head =3D skb;
                        =E2=80=A6
		} else {
                        =E2=80=A6
		}
                =E2=80=A6
		/* Give skb to upper layer */
		strp->cb.rcv_msg(strp, head); // =E2=86=92 sk_psock_init_strp
                =E2=80=A6
	}
        =E2=80=A6
}

That looks like a code path where we pass a cloned SKB.

> +		if (unlikely(!pskb_may_pull(skb, len_diff_abs)))
> +			return -ENOMEM;
> +		__skb_pull(skb, len_diff_abs);
> +	}
> +	bpf_compute_data_end_sk_skb(skb);
> +	if (tls_sw_has_ctx_rx(skb->sk)) {
> +		struct strp_msg *rxm =3D strp_msg(skb);
> +
> +		rxm->full_len +=3D len_diff;
> +	}
> +	return ret;
> +}

[...]
