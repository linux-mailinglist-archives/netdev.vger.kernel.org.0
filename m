Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B726A7587A
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 21:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfGYT7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 15:59:01 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38824 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfGYT7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 15:59:00 -0400
Received: by mail-pf1-f196.google.com with SMTP id y15so23278524pfn.5;
        Thu, 25 Jul 2019 12:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cpyirJXDh9h8czsrm8diGlgzVasCQVeBxDBBT0kRH8Q=;
        b=IAygKrKRP2P+c57jC3Usui4wkuG1yhYeyS5jH0e+PzPPoOMw+P8hmY7fJKjzVzfTrQ
         0ixvJjz6yaD28U8iowE62DKlxs0hUFmJ2H3PR4zJlMCmASymcEYJ1D57MQyI6BEpaiU/
         hkjfH+WO+w4CjmtqeP0afaxSb7GifzhnpMdfkfExWVORsk+96psPnnjw40L8kb5f63hH
         T5/JmT59NnivDFgHMKEkiTnYGxb6Cit9tZ2LpXCNA+v1qbs3WmbCprAdIC7ZJGIQrVxT
         FJmriU1eJnb5R1qZeBGLghI4vqoo+0scLhycAbdXacIxYB/yldTHh1aEjD31eAopdh8X
         mN5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cpyirJXDh9h8czsrm8diGlgzVasCQVeBxDBBT0kRH8Q=;
        b=CvbcA81U6vkHttzvvJkO+ARfBsLNzhHoyuQf2v+Pdi+9izwcRLfWs7DyW10AXYs+Cd
         G9yjVN4p+2GVBLqfsXIOCkya4UwPa1TYMzJJNu45Bv8SeY/qLEUDEzMsuKS8SEqt493g
         63jUE+j4sHJQk1IOQpuL8a7ffbcZ7Hq4EqnFvPzQX+oaK9B4KMNz9y4HUd135M0M8HHU
         gaGKjmgs2Qzq7DgvUDMqfJ2jy1cfbIsXDA+HsNUFK2aZXWq35lCtTghUuMJCdQNu8xij
         YuZNok6orsmFQrWesXSceeEiaHUxgGY/t+tLjweBwybK57ftdNoDVcZ5yZZ6qBbPzRZf
         hmrQ==
X-Gm-Message-State: APjAAAXuMyZww2L1qEh+/0oE0qkUNVgtotM9cCwW3kyYAYPBbBrg8vyy
        QCAiwXyE8PUCeTK4w599zk4+CKmW
X-Google-Smtp-Source: APXvYqyg760WdoR5kvAShIbeRBem4WYeJI6pGDE/+yPWCAI3w6KC93H9CRNvwKuSaEustNmBCZQrNQ==
X-Received: by 2002:aa7:9293:: with SMTP id j19mr18887294pfa.90.1564084740023;
        Thu, 25 Jul 2019 12:59:00 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::1:85f9])
        by smtp.gmail.com with ESMTPSA id u134sm48876100pfc.19.2019.07.25.12.58.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 12:58:59 -0700 (PDT)
Date:   Thu, 25 Jul 2019 12:58:57 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net,
        Willem de Bruijn <willemb@google.com>,
        Song Liu <songliubraving@fb.com>,
        Petar Penkov <ppenkov@google.com>
Subject: Re: [PATCH bpf-next v2 1/7] bpf/flow_dissector: pass input flags to
 BPF flow dissector program
Message-ID: <20190725195856.ttdt75dxwhawjqvi@ast-mbp>
References: <20190725153342.3571-1-sdf@google.com>
 <20190725153342.3571-2-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725153342.3571-2-sdf@google.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 08:33:36AM -0700, Stanislav Fomichev wrote:
> C flow dissector supports input flags that tell it to customize parsing
> by either stopping early or trying to parse as deep as possible. Pass
> those flags to the BPF flow dissector so it can make the same
> decisions. In the next commits I'll add support for those flags to
> our reference bpf_flow.c
> 
> Acked-by: Willem de Bruijn <willemb@google.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Petar Penkov <ppenkov@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/linux/skbuff.h       | 2 +-
>  include/net/flow_dissector.h | 4 ----
>  include/uapi/linux/bpf.h     | 5 +++++
>  net/bpf/test_run.c           | 2 +-
>  net/core/flow_dissector.c    | 5 +++--
>  5 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 718742b1c505..9b7a8038beec 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1271,7 +1271,7 @@ static inline int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
>  
>  struct bpf_flow_dissector;
>  bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
> -		      __be16 proto, int nhoff, int hlen);
> +		      __be16 proto, int nhoff, int hlen, unsigned int flags);
>  
>  bool __skb_flow_dissect(const struct net *net,
>  			const struct sk_buff *skb,
> diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> index 90bd210be060..3e2642587b76 100644
> --- a/include/net/flow_dissector.h
> +++ b/include/net/flow_dissector.h
> @@ -253,10 +253,6 @@ enum flow_dissector_key_id {
>  	FLOW_DISSECTOR_KEY_MAX,
>  };
>  
> -#define FLOW_DISSECTOR_F_PARSE_1ST_FRAG		BIT(0)
> -#define FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL	BIT(1)
> -#define FLOW_DISSECTOR_F_STOP_AT_ENCAP		BIT(2)
> -
>  struct flow_dissector_key {
>  	enum flow_dissector_key_id key_id;
>  	size_t offset; /* offset of struct flow_dissector_key_*
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index fa1c753dcdbc..b4ad19bd6aa8 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3507,6 +3507,10 @@ enum bpf_task_fd_type {
>  	BPF_FD_TYPE_URETPROBE,		/* filename + offset */
>  };
>  
> +#define FLOW_DISSECTOR_F_PARSE_1ST_FRAG		(1U << 0)
> +#define FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL	(1U << 1)
> +#define FLOW_DISSECTOR_F_STOP_AT_ENCAP		(1U << 2)
> +

I'm a bit concerned with direct move.
Last time we were in similar situation we've created:
enum {
        BPF_TCP_ESTABLISHED = 1,
        BPF_TCP_SYN_SENT,

and added:
        BUILD_BUG_ON((int)BPF_TCP_ESTABLISHED != (int)TCP_ESTABLISHED);
        BUILD_BUG_ON((int)BPF_TCP_SYN_SENT != (int)TCP_SYN_SENT);

It may be overkill here, but feels safer than direct move.
Adding BPF_ prefix also feels necessary to avoid very unlikely
(but still theoretically possible) conflicts.

