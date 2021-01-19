Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213602FC094
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387946AbhASUFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729133AbhASUEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 15:04:10 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF1BC061573
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 12:03:27 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id j18so9782550qvu.3
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 12:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dhx0TaUXqCshsw7OQHzx0ooIDhf18aOQuk4magRFIdk=;
        b=ZXM6sbHIrE4NrlCkx6/cXbRyPOb7X8cdF8vKlmpVYZkGWfg7XEltoe7VXo5xbRHW7s
         WxgjYa2AcuKrJaDqhVDM+ElO4wIBSOfB3k5dM5VpPYE6XwiMSC4rp+bVcNSdylfuOcXe
         0UHfyqVclIYt0x6pmFRPvRdVf5Ji3NA45Ko5wvzAL49at4XWVBiYiwWrH4GkvTtSqcZ6
         fGv03N2bGCGw7SCh6LFLwa3TiTTINr3RFrF/bdTCc8YUSs+mx+m5sVmNtAdR43gnReYs
         sW8e/mcJQRtW9WqsZEvSnMC8DGprO/SgWlKdjk+ijbMAAl6eem0IBpV4ycDOrZ91vpFc
         fp3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dhx0TaUXqCshsw7OQHzx0ooIDhf18aOQuk4magRFIdk=;
        b=BfN8b2NqDoXjXguZqEJYc8hI+0E0RlAOC9Wbmu9duv+2Zt+ds2jFJpONOijAYyuuM0
         kCV8QGnXpzHpzTD4QTBbtE8SVLRrYCDeH1nzYp77S0wT1QtKyLM7/e118A1hW/TkyQWq
         yXo4D3DoqAaHZxl5n2welTjWJLy0lAz+N1G8+rcji0WW+IjY3dl2nFhOIzaLGnnL2WqN
         G3OdsP26k1aIdqakgaFO+qo9vFccEeok7I1+/kqBYbgncYvEM895nJVPy0BblVnEX/U+
         M1wtdX2e1Rqn6OdrfcqCzMFxTorYGt+s12n84+A/CHGSj80+kDKS8yCV1uClxCPUuDn2
         trXg==
X-Gm-Message-State: AOAM532o/hMKzkybgmN78VTtMOJpxTW/X0RgmkzUESCSMXi2VcjW9MC8
        CaDX9kFUBTzZDlTSL5/G+N4=
X-Google-Smtp-Source: ABdhPJy1e4kf+OqGCRHJ4u0U6iOd8hoA46Sdu3PuxdHZGYV7lVscVHA7W6lrNEq/1AlqsnZHz3aXkg==
X-Received: by 2002:ad4:5a53:: with SMTP id ej19mr6159003qvb.61.1611086606555;
        Tue, 19 Jan 2021 12:03:26 -0800 (PST)
Received: from horizon.localdomain ([2001:1284:f016:4ecb:865e:1ab1:c1d6:3650])
        by smtp.gmail.com with ESMTPSA id 134sm13710247qkh.62.2021.01.19.12.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 12:03:25 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 30508C2CDA; Tue, 19 Jan 2021 17:03:23 -0300 (-03)
Date:   Tue, 19 Jan 2021 17:03:23 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu@ucloud.cn
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next ] net/sched: cls_flower add CT_FLAGS_INVALID
 flag support
Message-ID: <20210119200323.GA3961@horizon.localdomain>
References: <1611045110-682-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611045110-682-1-git-send-email-wenxu@ucloud.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

The patch looks good to me, just some side comments below.

On Tue, Jan 19, 2021 at 04:31:50PM +0800, wenxu@ucloud.cn wrote:
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3878,6 +3878,7 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)

I don't know why, but your patches often have function names here that
are not accurate. 

>  
>  	/* qdisc_skb_cb(skb)->pkt_len was already set by the caller. */
>  	qdisc_skb_cb(skb)->mru = 0;
> +	qdisc_skb_cb(skb)->post_ct = false;
>  	mini_qdisc_bstats_cpu_update(miniq, skb);
>  
>  	switch (tcf_classify(skb, miniq->filter_list, &cl_res, false)) {
> @@ -4960,6 +4961,7 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)

Here as well.

>  
>  	qdisc_skb_cb(skb)->pkt_len = skb->len;
>  	qdisc_skb_cb(skb)->mru = 0;
> +	qdisc_skb_cb(skb)->post_ct = false;
>  	skb->tc_at_ingress = 1;
>  	mini_qdisc_bstats_cpu_update(miniq, skb);
>  
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 2d70ded..c565c7a 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -237,9 +237,8 @@ void skb_flow_dissect_meta(const struct sk_buff *skb,

Here, I would expect to see a label/function name just before the
skb_flow_dissect_ct definition. But that's
skb_flow_dissect_set_enc_addr_type. skb_flow_dissect_meta is still one
other function up.

>  void
>  skb_flow_dissect_ct(const struct sk_buff *skb,
>  		    struct flow_dissector *flow_dissector,
> -		    void *target_container,
> -		    u16 *ctinfo_map,
> -		    size_t mapsize)
> +		    void *target_container, u16 *ctinfo_map,
> +		    size_t mapsize, bool post_ct)
>  {
>  #if IS_ENABLED(CONFIG_NF_CONNTRACK)
>  	struct flow_dissector_key_ct *key;
