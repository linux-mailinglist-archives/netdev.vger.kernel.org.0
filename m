Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904C762381E
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 01:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbiKJA0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 19:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiKJAZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 19:25:59 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4192934F;
        Wed,  9 Nov 2022 16:25:59 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id v3so194799pgh.4;
        Wed, 09 Nov 2022 16:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UpdZWa52LuHE45E/59xKz1HV+fCoqG7jrw4QGjpnIC4=;
        b=XVG/DhIfJEUn3b0QY8eG3Gb9QwUyA0OfzXtMM0kLyVKoeklZ/4B8hAw5/UzNiuNEes
         v/ctjdVk+Ys4C51JBt00u8soglc3ij3CxbQ27hdG6OrG04RVs2cIUVWIOCBDxqA4BxhJ
         sxs1IjuVr/AX/L5PrCoYRWZ5vT73+TOIeOc5YWPxiHLTZtav84AAUWBLWNMW03Hz9vCM
         CvZMe6t1R0QXqx0R1c5BY1Ei7b1teAT5Rh3Yitk3ymPR7Da7JQTcfajd11jrHMBLkVi7
         sSsynC8h9Wg/k+ohxt9HSxThKAl0cZilGZaq/2YHwiVcFNojoIIrvfKu39o+Hag60uhP
         F7SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UpdZWa52LuHE45E/59xKz1HV+fCoqG7jrw4QGjpnIC4=;
        b=Pj3/WlARvLBVFKiwoanB99K5O2QtqT3wQ2fkGkthBJBd70V7qaPRnr+WIWHx/Mw7lk
         oTtIwSgecjMdhFgOto6Zzk/3+qr6aVFq9mMaXpEgqplbjv8Mz3s2z/82D2mmfafmAdPj
         XGhM7L/fCANwAEf7iU8hcYA7xZxDa3z4fAUzMooXXTjSRIjcciFoy6B7pZlHBVyvK60u
         Ju29uiz17DxvhH4pJQBBGHl4oSSs8rWSkX8+GuYuA3RbEHP67trWOls/lOEa3cD06I8P
         u8O2JnINVzvGfifz+qnoWOKFHYKExdDusK+BlulVo8iud5ps8/eTUjap7yywYmRTNqmn
         TAcQ==
X-Gm-Message-State: ACrzQf2hFnffmPjTw9WWwANi8oXryTc0fV7UMfFu9GjMqsDFQrjbBI8N
        iG2ziwxS6EfqAEV/CaEANKc=
X-Google-Smtp-Source: AMsMyM6t7ofI3W9XzGtTFMxDYkyIg+4vYfWwApy9Usj6siKXAtjwG3/1kqh6vritUkwSEORmBCUuSA==
X-Received: by 2002:a65:6c0d:0:b0:46f:a98a:5abf with SMTP id y13-20020a656c0d000000b0046fa98a5abfmr1390604pgu.128.1668039958636;
        Wed, 09 Nov 2022 16:25:58 -0800 (PST)
Received: from localhost ([98.97.44.95])
        by smtp.gmail.com with ESMTPSA id p2-20020a17090a868200b0020d51aefb82sm1832784pjn.19.2022.11.09.16.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 16:25:58 -0800 (PST)
Date:   Wed, 09 Nov 2022 16:25:56 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Message-ID: <636c4514917fa_13c168208d0@john.notmuch>
In-Reply-To: <20221104032532.1615099-5-sdf@google.com>
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-5-sdf@google.com>
Subject: RE: [RFC bpf-next v2 04/14] veth: Support rx timestamp metadata for
 xdp
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev wrote:
> xskxceiver conveniently setups up veth pairs so it seems logical
> to use veth as an example for some of the metadata handling.
> 
> We timestamp skb right when we "receive" it, store its
> pointer in new veth_xdp_buff wrapper and generate BPF bytecode to
> reach it from the BPF program.
> 
> This largely follows the idea of "store some queue context in
> the xdp_buff/xdp_frame so the metadata can be reached out
> from the BPF program".
> 

[...]

>  	orig_data = xdp->data;
>  	orig_data_end = xdp->data_end;
> +	vxbuf.skb = skb;
>  
>  	act = bpf_prog_run_xdp(xdp_prog, xdp);
>  
> @@ -942,6 +946,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
>  			struct sk_buff *skb = ptr;
>  
>  			stats->xdp_bytes += skb->len;
> +			__net_timestamp(skb);

Just getting to reviewing in depth a bit more. But we hit veth with lots of
packets in some configurations I don't think we want to add a __net_timestamp
here when vast majority of use cases will have no need for timestamp on veth
device. I didn't do a benchmark but its not free.

If there is a real use case for timestamping on veth we could do it through
a XDP program directly? Basically fallback for devices without hw timestamps.
Anyways I need the helper to support hardware without time stamping.

Not sure if this was just part of the RFC to explore BPF programs or not.

>  			skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
>  			if (skb) {
>  				if (skb_shared(skb) || skb_unclone(skb, GFP_ATOMIC))
