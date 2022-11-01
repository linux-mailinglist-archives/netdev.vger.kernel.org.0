Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D29D614DCF
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 16:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbiKAPHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 11:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiKAPHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 11:07:39 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C0D1CB11
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 08:01:07 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-12c8312131fso17082570fac.4
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 08:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MKsMSocFldta8eSwsyxSunB+L0AXX6RWfbl+WJHa7TY=;
        b=WRJT67DX+QDAGJ2Zq7PSdZP5X43ok+2zY5w7gullA/t0mdGmHxDS8OafEctwb+T/dr
         +l9q4MmGdtJjXlnW//CBseygnQdLmpzzCTvovEUlFTfSSckVhZD5qDgfmt1DVT/l/m/Q
         bWgPyLuX0lNx9LfMno8coG+EpzYDu+QOtClw0VuNGmZQtsK0nBdXuBS/d9/H06oolO/u
         EUmgCjZRmFCM/es2LjLDgoz1D2WxIIw5F1a74SbCSSnSUuSGam9FbUzD0H3PJYT2A1hC
         xGRyGcnF5SIDlTG9T15YmTvioL5fu9Jj3SCjJqZafYrUh3Q43BSMLnnkypbl/5yz2a1y
         QeAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MKsMSocFldta8eSwsyxSunB+L0AXX6RWfbl+WJHa7TY=;
        b=EZPHsLUjP7MxFXH+yd0UsQItz4KmeFlQ28f50Hso5XswzLT+WW2kiny2FOUYkDcmfe
         yo7iw1pntytJyyBc+IWDmsOVT0u7UWuwhJeFDHtlXutVtvDEtES5kgjr+DRugCcIzj9O
         vsjqV2m2hz5Gx/5EmJL00GW3aIUa//CpBArJQQ7lF0iWwFIMQyvhxiRsmvBEU8360tO3
         ZlwBeGdEOskKX1FhGlEQGfqkwjiiQD4DbBRjtk1IWPGN+hwPO85mCaEBJwy1H00W4p2M
         bLGK10ccGPSZxBIUDddGAZUHv4amHysLQdpFwIyynVUo4YNiekIthvi44MEBXWYrOT99
         4BWw==
X-Gm-Message-State: ACrzQf2RMgqOXDv+V9dQ1p5drW4JC0zI8H/fP6+ZRIuRvlT9xHqr8LDH
        pAN3DoMppXIEm7lzvSUelkk=
X-Google-Smtp-Source: AMsMyM4xydkD6hsRaS3iuJxS8OHRzTbA9FQgSL+5BWjTiBvwNvdJn9udIUkdV8cipEbs6RuywT3lAQ==
X-Received: by 2002:a05:6871:7a8:b0:13b:8822:bf92 with SMTP id o40-20020a05687107a800b0013b8822bf92mr20896001oap.222.1667314835544;
        Tue, 01 Nov 2022 08:00:35 -0700 (PDT)
Received: from t14s.localdomain ([187.79.93.215])
        by smtp.gmail.com with ESMTPSA id a4-20020a4ab784000000b0044afc1ba91asm3489132oop.44.2022.11.01.08.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 08:00:34 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 883D3444EDC; Tue,  1 Nov 2022 12:00:31 -0300 (-03)
Date:   Tue, 1 Nov 2022 12:00:31 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org, Jiri Pirko <jiri@resnulli.us>,
        Paul Blakey <paulb@nvidia.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, kuba@kernel.org,
        Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ovs-dev] [PATCHv3 net-next 4/4] net: sched: add helper support
 in act_ct
Message-ID: <20221101150031.a6rtrgzwfd7kzknn@t14s.localdomain>
References: <cover.1667230381.git.lucien.xin@gmail.com>
 <4ce649629cc4c5bebe49fdd48a3cf5497a4489fa.1667230381.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ce649629cc4c5bebe49fdd48a3cf5497a4489fa.1667230381.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 11:36:10AM -0400, Xin Long wrote:
...
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -33,6 +33,7 @@
>  #include <net/netfilter/nf_conntrack_acct.h>
>  #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
>  #include <net/netfilter/nf_conntrack_act_ct.h>
> +#include <net/netfilter/nf_conntrack_seqadj.h>
>  #include <uapi/linux/netfilter/nf_nat.h>
>  
>  static struct workqueue_struct *act_ct_wq;
> @@ -655,7 +656,7 @@ struct tc_ct_action_net {
>  
>  /* Determine whether skb->_nfct is equal to the result of conntrack lookup. */
>  static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
> -				   u16 zone_id, bool force)
> +				   struct tcf_ct_params *p, bool force)

Nit, it could have fetched 'force' from p->ct_action too then, as it
is only used in this function.

There's a typo in Ilya's name in the cover letter.

Other than this, LGTM.
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
