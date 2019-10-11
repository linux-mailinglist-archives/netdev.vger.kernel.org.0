Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7180D3A14
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 09:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfJKHeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 03:34:11 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34639 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbfJKHeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 03:34:11 -0400
Received: by mail-ed1-f66.google.com with SMTP id p10so7813681edq.1
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 00:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Dk051UqLtBCCbnzRc3H5TjevjehWWSOh4IGeyPB78po=;
        b=oZYwTv1UOj4CvNFkYeTSxiuH/FMHYBaxmVjqUtwxrgahYEBZ9LSPPHJNN6EzEj/HPv
         v/uobxNGPGByEqraIfnnubGwmzGvS70OvoeiDoEctVWRSYgSkht/vf1/xAWDkdLc2HER
         xaBhchdpNQjNoAj35GTGDSI/YXgPukHrmcixzwXAvtppbvWdv3cAya9VssZ+QwNNfNsi
         6Vhet5r6/FpH2Ol3VglTl7FErafmetZkTaX2R7CJ4pCc9t6jDtyoMheCo+XG6i5AEC1Q
         Rfmgh/BugB51j1/AT6KxfpXEk6r8hzzN9Iwdxm99REa0nc7YqLNDInaqblpZxeGwqTZe
         bjeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Dk051UqLtBCCbnzRc3H5TjevjehWWSOh4IGeyPB78po=;
        b=KoqM2DulSkMURYd1ayHZzSo9Dpv0Ktdvtk8GotH6a49tXdiGu/oNyG8BUYRLadDvHI
         s3x67ypMN5Vl1ViPm9SNISf2ZVo/qqhIVSDKPpOlSK8MHmG95fcQv+u9NuZrZe/mBVfx
         pjeBrT9298OsskrYZqB1I/TlAdvo6YO9Ck8Cqul+vq49ZnuNdXx2veLYqXoBhEtT/myw
         FXOPcE+GtBGQ51jOc44SiXf0hnzUEWrMkX4YjnVv732ClNw8U1ZaTrjmLf4XKLNb4M+M
         xMWAuUgODp6VZmoQstFsxAWkw3lBvJhVoqvmX/qYvfxvUS5CAx8LgieRSMa0zTq59rAl
         WTRA==
X-Gm-Message-State: APjAAAUCuHXYDYfL+8F57mdMODScfDGfQcK+SJ8SWp811vD2ytgAjiMQ
        sW8cKLjSj7IT9pumTDprIi59Qg==
X-Google-Smtp-Source: APXvYqz5Ett99HAGwzFZiUK9FVDk4aQpIMSaaUubOlGUepMTGbO41ooJ4pcQdBbkt+O/YTsUIbojGw==
X-Received: by 2002:a50:cb85:: with SMTP id k5mr12010355edi.131.1570779249123;
        Fri, 11 Oct 2019 00:34:09 -0700 (PDT)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id jp14sm1018501ejb.60.2019.10.11.00.34.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Oct 2019 00:34:08 -0700 (PDT)
Date:   Fri, 11 Oct 2019 09:34:08 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: avoid errors when trying to pop MLPS header
 on non-MPLS packets
Message-ID: <20191011073407.vvogkh53hm6hvb6h@netronome.com>
References: <cover.1570732834.git.dcaratti@redhat.com>
 <9343e3ce8aed5d0e109ab0805fb452e8f55f0130.1570732834.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9343e3ce8aed5d0e109ab0805fb452e8f55f0130.1570732834.git.dcaratti@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 08:43:52PM +0200, Davide Caratti wrote:
> the following script:
> 
>  # tc qdisc add dev eth0 clsact
>  # tc filter add dev eth0 egress matchall action mpls pop
> 
> implicitly makes the kernel drop all packets transmitted by eth0, if they
> don't have a MPLS header. This behavior is uncommon: other encapsulations
> (like VLAN) just let the packet pass unmodified. Since the result of MPLS
> 'pop' operation would be the same regardless of the presence / absence of
> MPLS header(s) in the original packet, we can let skb_mpls_pop() return 0
> when dealing with non-MPLS packets.
> 
> Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Hi Davide,

For the TC use-case I think this is correct for the reasons you explain
above.

For the OVS use-case I also think it is fine because
__ovs_nla_copy_actions() will ensure that MPLS POP only occurs
for packets with an MPLS Ethernet protocol. That is, this condition
should never occur in that use-case.

And it appears that there are no other users of this function.

I think it might be worth adding something about use-cases other than TC
to the changelog, but that aside:

Reviewed-by: Simon Horman <simon.horman@netronome.com>

> ---
>  net/core/skbuff.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 529133611ea2..cd59ccd6da57 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5536,7 +5536,7 @@ int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto)
>  	int err;
>  
>  	if (unlikely(!eth_p_mpls(skb->protocol)))
> -		return -EINVAL;
> +		return 0;
>  
>  	err = skb_ensure_writable(skb, skb->mac_len + MPLS_HLEN);
>  	if (unlikely(err))
> -- 
> 2.21.0
> 
