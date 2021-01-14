Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57EF2F5CD3
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 10:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbhANJE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 04:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbhANJEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 04:04:23 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02E6C061575;
        Thu, 14 Jan 2021 01:03:42 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id o11so4578406ote.4;
        Thu, 14 Jan 2021 01:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=yr/MMAs2Fb11VuHGp9TyeBPIvbzmDxCwMaynvb9fj1c=;
        b=qXLLo+nH99Djx2egzXgEeUHGgswYvV8wC6i4G5yQIog24gZfejHtbLKr4nV4qPLesr
         qbZtQKACKYArx78k5TQlnQKUznguBespZdbCSt2hdUcKRAdBWIxtWD7iHXBzncf0lIC2
         ozoCl4OAgyQqWWIjxTTW7r2t0UNNZblMP1tILFjMRVO0YMNPypasSOtO0J4tyg+4KfWO
         hrWpcc3R1hw4XG8cp3sO98BpXvCCxeTDf8IWjU9JeakGm6OCCDaQG205ZeOXKZxKOTOv
         TNCBLrCZyddKOO54AQDI0Qt/ISZfA2t/NsOKK1rIchOGOZ3ho2eaz41ldep2BAa8UIMt
         C1Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=yr/MMAs2Fb11VuHGp9TyeBPIvbzmDxCwMaynvb9fj1c=;
        b=O+eJTZY0jdb134CrCm+nBhCqz4GeoHxr9xUrVspOEIEF72/3ejECwpCsDVFSmv2utv
         zDZhGp4Z+jXfxKrqc3dBUjys3dznyzyWFep/R6P949ogq4JWGlNbuKud7fUuei7ccaHW
         opBJawIO4H2hZL0DLG7jhvPN+EaXJX0MBNYexBD5k9VIacox2P9JVJzgWhFk9tZHEiNg
         WnVKvGC2Ox38yNqlTvPGxDQLK5f3p466G1NdalKgzngEQIwEl+Q9B2rB6lJ3pxKEALLd
         TqhoWnq/1lTlued8VzlFOY4tBxUMlYzR2FwwbsIvBYEuDVWRIoKO7/y4boqVY5Ne4V8W
         Q6LQ==
X-Gm-Message-State: AOAM533TA7FQjhvr+zhDsd6HbsdO3D7zwb7iNGJDBTgNTU7CMbwxPgxs
        4uJi96TMq47+AWGBxsiXTTs=
X-Google-Smtp-Source: ABdhPJwPTpZNYg199+JfX7XSvWftMDOAhHuoJ57StjLhZgaGtiOFGtX7w68/DWQLOIqrc8levJINaQ==
X-Received: by 2002:a9d:71c9:: with SMTP id z9mr4180699otj.61.1610615022347;
        Thu, 14 Jan 2021 01:03:42 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id g92sm945326otb.66.2021.01.14.01.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 01:03:41 -0800 (PST)
Date:   Thu, 14 Jan 2021 01:03:33 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Message-ID: <600008e5e2e80_1eeef20852@john-XPS-13-9370.notmuch>
In-Reply-To: <161047352593.4003084.6778762780747210369.stgit@firesoul>
References: <161047346644.4003084.2653117664787086168.stgit@firesoul>
 <161047352593.4003084.6778762780747210369.stgit@firesoul>
Subject: RE: [PATCH bpf-next V11 5/7] bpf: drop MTU check when doing TC-BPF
 redirect to ingress
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> The use-case for dropping the MTU check when TC-BPF does redirect to
> ingress, is described by Eyal Birger in email[0]. The summary is the
> ability to increase packet size (e.g. with IPv6 headers for NAT64) and
> ingress redirect packet and let normal netstack fragment packet as needed.
> 
> [0] https://lore.kernel.org/netdev/CAHsH6Gug-hsLGHQ6N0wtixdOa85LDZ3HNRHVd0opR=19Qo4W4Q@mail.gmail.com/
> 
> V9:
>  - Make net_device "up" (IFF_UP) check explicit in skb_do_redirect
> 
> V4:
>  - Keep net_device "up" (IFF_UP) check.
>  - Adjustment to handle bpf_redirect_peer() helper
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  include/linux/netdevice.h |   31 +++++++++++++++++++++++++++++--
>  net/core/dev.c            |   19 ++-----------------
>  net/core/filter.c         |   14 +++++++++++---
>  3 files changed, 42 insertions(+), 22 deletions(-)
> 

[...]

> diff --git a/net/core/filter.c b/net/core/filter.c
> index 3f2e593244ca..1908800b671c 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2083,13 +2083,21 @@ static const struct bpf_func_proto bpf_csum_level_proto = {
>  
>  static inline int __bpf_rx_skb(struct net_device *dev, struct sk_buff *skb)
>  {
> -	return dev_forward_skb(dev, skb);

> +	int ret = ____dev_forward_skb(dev, skb, false);
> +
> +	if (likely(!ret)) {
> +		skb->protocol = eth_type_trans(skb, dev);
> +		skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
> +		ret = netif_rx(skb);
> +	}
> +
> +	return ret;

How about putting above block into a dev.c routine call it

 dev_forward_skb_nomtu(...)

or something like that. Then we keep this code next to its pair
with mtu check, dev_forward_skb().

dev_forward_skb() also uses netif_rx_internal() looks like maybe we should
just do the same here?

Thanks,
John
