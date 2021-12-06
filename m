Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71FF468FAE
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 04:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236118AbhLFDVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 22:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhLFDVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 22:21:41 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D60C0613F8;
        Sun,  5 Dec 2021 19:18:13 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id i9so8901159ilu.1;
        Sun, 05 Dec 2021 19:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=HoPvzKKlsWLuEL2aHu1a2QCfAbDKSMZKrQKmcYXYMLM=;
        b=GeI1DGdXssqYBgEGXPMXsEuCoeea32uaiKQt4Fy/u1moXPel4NHS2hlFFtHg3Lfx3q
         Doq/c0wtlDTbisAk7S6bkdA17cc3NrtSxwRHCAVKDDhBCAdSxTpMtWKP6vwUkG3p4ddb
         h0CzVpoq5ECF1Y2gRhZJR+eSHz/yo/7k07TdlmA34+WzFSjsZ7bD0N2NCWqvTM7MI9/z
         hv8BHfG6K5lHLwGX7HVaQq/hmTZajvpQckjUq1zrhF73yma82/0bLFtze2jLBDxMsk25
         Np2xhAO2/NVvUEAxLVetBjusHYQ2VgmUDYiEXET+GMIvzDskNkXLCUYXnUUls3pieFHQ
         jd9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=HoPvzKKlsWLuEL2aHu1a2QCfAbDKSMZKrQKmcYXYMLM=;
        b=YrQgSxBCYE+QDnOzwYcicc8AzJfoZpQ1MTC4xA+GuBU4iEhxNpczHFyMlA6G62gAWF
         ujG10BdlLAJctJteBPMJxRIKA0i4+vRuCCj5Dn1LbACBsjWWbJktlOgTk/9TGUIDF+U9
         NjosgCyAbqc1FrQtz0fT3dn3SV39Y+XTqqp7LV5rQi3F80e4wMxE+iRi0GxFqYiYuwwd
         o9O9KfH8w4Zkj5VvuVJ6B471AblzVBXFNe6epLiKU/lVP2Nt6O2lir2supi0sqmzZpZ3
         Y9XuOn4gSe8knj09uCxwvsDGzpveanPBCOMRAsgxZxR4KCV69wmv6uOEi426wT28zHD0
         gyjg==
X-Gm-Message-State: AOAM531K6lEbnKx6lhDk+gQO0HdZbJkUXbG23xTCw/6cdXbD9bSrr9qA
        2F4r+cNDk7SvYXphn06pCbU=
X-Google-Smtp-Source: ABdhPJzdmQJEfC8lO/gsx69d8tRIlOR8YExFA7jIhzrQF6Yv/YvRBhTZ8T2GY9I9Xtctasc3vgWRGA==
X-Received: by 2002:a05:6e02:1b02:: with SMTP id i2mr29542677ilv.139.1638760693230;
        Sun, 05 Dec 2021 19:18:13 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id y9sm3724405ill.78.2021.12.05.19.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 19:18:12 -0800 (PST)
Date:   Sun, 05 Dec 2021 19:18:03 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <61ad80eb139f9_444e2082e@john.notmuch>
In-Reply-To: <47932365c53acbf359c26944f0bec363928d342f.1638272238.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <47932365c53acbf359c26944f0bec363928d342f.1638272238.git.lorenzo@kernel.org>
Subject: RE: [PATCH v19 bpf-next 10/23] net: mvneta: enable jumbo frames if
 the loaded XDP program support mb
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Enable the capability to receive jumbo frames even if the interface is
> running in XDP mode if the loaded program declare to properly support
> xdp multi-buff. At same time reject a xdp program not supporting xdp
> multi-buffer if the driver is running in xdp multi-buffer mode.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Allow me to enumerate the cases as a sanity check.

 mb prog on driver w/out mb support:

    The program will never receive a non-linear buffer so no
    trouble here. If user tries to configure MTU >1500 an error
    will be thrown by driver same as always.
  
 !mb prog on driver w/out mb support.

    This is the normal case, no change.

 mb prog on driver with mb support.

    Allowed and user may now set MTU >1500.    

 !mb prog on driver with mb support

    Allowed and now driver must throw an error on MTU >1500

OK works for me. Thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>

>  drivers/net/ethernet/marvell/mvneta.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 332699960b53..98db3d03116a 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -3750,6 +3750,7 @@ static void mvneta_percpu_disable(void *arg)
>  static int mvneta_change_mtu(struct net_device *dev, int mtu)
>  {
>  	struct mvneta_port *pp = netdev_priv(dev);
> +	struct bpf_prog *prog = pp->xdp_prog;
>  	int ret;
>  
>  	if (!IS_ALIGNED(MVNETA_RX_PKT_SIZE(mtu), 8)) {
> @@ -3758,8 +3759,11 @@ static int mvneta_change_mtu(struct net_device *dev, int mtu)
>  		mtu = ALIGN(MVNETA_RX_PKT_SIZE(mtu), 8);
>  	}
>  
> -	if (pp->xdp_prog && mtu > MVNETA_MAX_RX_BUF_SIZE) {
> -		netdev_info(dev, "Illegal MTU value %d for XDP mode\n", mtu);
> +	if (prog && !prog->aux->xdp_mb && mtu > MVNETA_MAX_RX_BUF_SIZE) {
> +		netdev_info(dev,
> +			    "Illegal MTU %d for XDP prog without multi-buf\n",
> +			    mtu);
> +
>  		return -EINVAL;
>  	}
>  
> @@ -4428,8 +4432,9 @@ static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
>  	struct mvneta_port *pp = netdev_priv(dev);
>  	struct bpf_prog *old_prog;
>  
> -	if (prog && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
> -		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
> +	if (prog && !prog->aux->xdp_mb && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "prog does not support XDP multi-buff");
>  		return -EOPNOTSUPP;
>  	}
>  
> -- 
> 2.31.1
