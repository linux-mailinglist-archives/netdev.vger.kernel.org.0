Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9800E262AF2
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgIIIvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgIIIvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:51:33 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC89C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:51:33 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id g4so2025808wrs.5
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FmjsDP04mfdZLFJ3+qkXlrf94+T5cynHI+nHZZTQUrA=;
        b=F5HxnmxZmh/Rkv0qYZTpW/Qud5QjTIfK4ymVAgR9qcydWiqEqt/HTRNU0lmvMH2ZMT
         Wl9nNSsqZoLNibRimE5TzxpM6MhB4TgjKS/Z9JhwnxfUqBXgMfHylbGkssA2AtQCMQsx
         yvZqfVAEg1GG3oZNwCiBM7geET/0rZkSd4/thWucjAHRmL+SFYrqo2UZHXm3tgkh5Exc
         GzEqPfB5FikAQNGFITL3YAuXwyxYk2+W4/U0FYgXdXk5A7wMoNk5y7c7YORrk13S1kTS
         4tSvLHn4bUyPLN8eHOkL1ZZ5VhE7pOOIBpWDC0y9g88ZTZ2kPDLWmDIymgE2RFuNL1LT
         mqJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FmjsDP04mfdZLFJ3+qkXlrf94+T5cynHI+nHZZTQUrA=;
        b=WyS/MKmFPcOU3Itzm2ScaaoCE0y3SQ8sFxtkGL9cmUWJ5o7UEUBE0rIn66tJcYtvfM
         UUFsO8hbOI7u+BEDvpt0+c+gugXI/dfj53DHfJB/tkeQTwxxL0ngfs/B96YKLJuXk+Cj
         6fumr6hJyzhpLBIZty6OwVOAQaa+r2VI7uKgMfN7NVovuetV47aGh6rLowQUNI89Let/
         Fz6HzL/JRExnpvrKVP43+exX4BRJyF9NdU22BjSrf7BAEFOXXoVw10S9bNepSsra+g3N
         fJkbzDu1fIg7gllihLuTuB6uOa+UdbcKtDhSijI/q1xdw7tlTATs3eYTHDogX3yJHkla
         IzVg==
X-Gm-Message-State: AOAM533oYaOHTS1E/rimhhxJ7rniEVnpj4ApIxhXG41vBKsndqcEiu1J
        /nny5N2a9Jn/K70XJHbbbzqRHg==
X-Google-Smtp-Source: ABdhPJwFSjSHep5K3LKvgNDc2UUUNZuY5swjq7QdRad9kG32ZF8UyIG2HVpfoOhciBbg5VIW4okArA==
X-Received: by 2002:adf:9ed4:: with SMTP id b20mr2914850wrf.206.1599641491830;
        Wed, 09 Sep 2020 01:51:31 -0700 (PDT)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id a74sm3000027wme.11.2020.09.09.01.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:51:31 -0700 (PDT)
Date:   Wed, 9 Sep 2020 10:51:30 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Paul Davey <paul.davey@alliedtelesis.co.nz>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/3] ipmr: Use full VIF ID in netlink cache
 reports
Message-ID: <20200909085128.GA14965@netronome.com>
References: <20200907220408.32385-1-paul.davey@alliedtelesis.co.nz>
 <20200907220408.32385-4-paul.davey@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907220408.32385-4-paul.davey@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 10:04:08AM +1200, Paul Davey wrote:
> Insert the full 16 bit VIF ID into ipmr Netlink cache reports.
> 
> The VIF_ID attribute has 32 bits of space so can store the full VIF ID
> extracted from the high and low byte fields in the igmpmsg.
> 
> Signed-off-by: Paul Davey <paul.davey@alliedtelesis.co.nz>
> ---
>  net/ipv4/ipmr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
> index 4809318f591b..939792a38814 100644
> --- a/net/ipv4/ipmr.c
> +++ b/net/ipv4/ipmr.c
> @@ -2432,7 +2432,7 @@ static void igmpmsg_netlink_event(struct mr_table *mrt, struct sk_buff *pkt)
>  	rtgenm = nlmsg_data(nlh);
>  	rtgenm->rtgen_family = RTNL_FAMILY_IPMR;
>  	if (nla_put_u8(skb, IPMRA_CREPORT_MSGTYPE, msg->im_msgtype) ||
> -	    nla_put_u32(skb, IPMRA_CREPORT_VIF_ID, msg->im_vif) ||
> +	    nla_put_u32(skb, IPMRA_CREPORT_VIF_ID, msg->im_vif | (msg->im_vif_hi << 8)) ||

nit: the inner parentheses seem unnecessary

Otherwise, FWIIW, this series looks good to me.

>  	    nla_put_in_addr(skb, IPMRA_CREPORT_SRC_ADDR,
>  			    msg->im_src.s_addr) ||
>  	    nla_put_in_addr(skb, IPMRA_CREPORT_DST_ADDR,
> -- 
> 2.28.0
> 
