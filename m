Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EE423B244
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgHDB2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHDB2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:28:16 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EEBC06174A;
        Mon,  3 Aug 2020 18:28:16 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id 77so4354228ilc.5;
        Mon, 03 Aug 2020 18:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Z70cZn0HEIIxS9vSsgjhWlsUbqowJbwegulZ+jZ6cE0=;
        b=MVN3jAc4ySgT3qTSvY/lDZyMZay4Mn/kwDx3rxtx04HFJHTs535wzWnlYXTjtTX7Nx
         4Kj7rypl+7+WkN93fWbnEq7NslbjH7IUtb15H8e7XtyYhXlHZ7PUtwJqN2KSz6Zak2Rp
         9N4xoC5pnCLREM5DlNvxXmFzxySDl1lj2FiRAa2ZCwed9O3sHwWL4V9MpfeKybrpzu0A
         3faqaVg5/W9ruiGWGl3I8IpHrxTNTRQ5mHenj548Xf1H/SV0NkkXOPRHwQbAPzGCGiPn
         aXECbbd/gE5A6dWObaNwNG8ZcbXPzyQip8wYhGFZjQzzkRN9QdrUV42ToUKDx41dieEP
         w+Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Z70cZn0HEIIxS9vSsgjhWlsUbqowJbwegulZ+jZ6cE0=;
        b=AkrNqMclvisSxH4qGVgUIOc+iycKpsfdfOf1FR+yhPQzSr080atq4MzgMpGctJ5eAc
         SszNyF3aY2eg9XHXg6xSLweYuoK5tC6Tqs92pNQp9JMZnad422WBEZZqoTSZrjIk/nRg
         WiQ++/qAjInVElwXbaSiRey1fmNRAR4pYpaAI7/1pweQuXd6ClyqaL/1T+Wn0Gmr0Phq
         ZVSgp6iihlD1HL+yys7VZUzzVMjkbhosnUx4V0xQjw1R696chSwI/Y3Twuy3Va97cKGj
         iCzqC/94jUjkcK6LfwF5okK09RN6lir/qJt00yfF/4KjRykzpXEzUJqHOyw7knBL5EYn
         YxHQ==
X-Gm-Message-State: AOAM530/LPjK0AKlhWfsznT2rSZwy4HMn6/CfAH5ZF+9ZA1zyJ9PupJi
        hgyFjzNlDfZPo6S8BJGXCNU=
X-Google-Smtp-Source: ABdhPJzk3UutonUT4zaKpQF/wxVPl98T16Npd5iN30dn55PilfmBjUIkKYWgtEnzhn+xza+s1pF+dA==
X-Received: by 2002:a92:d292:: with SMTP id p18mr2188733ilp.281.1596504495981;
        Mon, 03 Aug 2020 18:28:15 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g13sm11491593ilq.18.2020.08.03.18.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 18:28:15 -0700 (PDT)
Date:   Mon, 03 Aug 2020 18:28:04 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, kernel-team@fb.com,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>
Message-ID: <5f28b9a4704a1_62272b02d7c945b4be@john-XPS-13-9370.notmuch>
In-Reply-To: <20200803231045.2683198-1-kafai@fb.com>
References: <20200803231013.2681560-1-kafai@fb.com>
 <20200803231045.2683198-1-kafai@fb.com>
Subject: RE: [RFC PATCH v4 bpf-next 05/12] bpf: tcp: Add
 bpf_skops_established()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau wrote:
> In tcp_init_transfer(), it currently calls the bpf prog to give it a
> chance to handle the just "ESTABLISHED" event (e.g. do setsockopt
> on the newly established sk).  Right now, it is done by calling the
> general purpose tcp_call_bpf().
> 
> In the later patch, it also needs to pass the just-received skb which
> concludes the 3 way handshake. E.g. the SYNACK received at the active side.
> The bpf prog can then learn some specific header options written by the
> peer's bpf-prog and potentially do setsockopt on the newly established sk.
> Thus, instead of reusing the general purpose tcp_call_bpf(), a new function
> bpf_skops_established() is added to allow passing the "skb" to the bpf prog.
> The actual skb passing from bpf_skops_established() to the bpf prog
> will happen together in a later patch which has the necessary bpf pieces.
> 
> A "skb" arg is also added to tcp_init_transfer() such that
> it can then be passed to bpf_skops_established().
> 
> Calling the new bpf_skops_established() instead of tcp_call_bpf()
> should be a noop in this patch.

Yep, looks like a noop.

> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Acked-by: John Fastabend <john.fastabend@gmail.com>

[...]

>  
> +#ifdef CONFIG_CGROUP_BPF
> +static void bpf_skops_established(struct sock *sk, int bpf_op,
> +				  struct sk_buff *skb)


Small nit because its an RFC anyways.

Should we call this bpf_skops_fullsock(...) instead? Just a suggestion.

> +{
> +	struct bpf_sock_ops_kern sock_ops;
> +
> +	sock_owned_by_me(sk);
> +
> +	memset(&sock_ops, 0, offsetof(struct bpf_sock_ops_kern, temp));
> +	sock_ops.op = bpf_op;
> +	sock_ops.is_fullsock = 1;
> +	sock_ops.sk = sk;
> +	/* skb will be passed to the bpf prog in a later patch. */
> +
> +	BPF_CGROUP_RUN_PROG_SOCK_OPS(&sock_ops);
> +}
