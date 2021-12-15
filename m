Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88E24755A7
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 10:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241413AbhLOJ6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 04:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236424AbhLOJ6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 04:58:32 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7C0C061574;
        Wed, 15 Dec 2021 01:58:32 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id o20so73090559eds.10;
        Wed, 15 Dec 2021 01:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wqwN6a1m1SmAd2kO8sEWXhlIvxjALunGrfiJPe7wSPI=;
        b=YSq87FtuhH0XFwuiLLX5pM+rQ4ll/yWPMLQhn2KGK4mdWeUFvvcBHqsFpWLdLvDe2e
         xcR8QouzapZb2IsfjTnGx4lVaoerLa58sshRqc9L1W2V34D5pzFoLa8JV1C4/NKixt97
         rmY+mvzoi1Dj1GTVr3DqAs0z/7qCjEmHiAflh7rgneAsHuQGhb/72TCsxzRlEhlaYEWw
         wLLVe9rTK1lV7uOS56YbybIS08FX5FbSzCohDgq7hzRQab6c2gtzFjmTPyBgYIeOGEmh
         qIM/LmEKdq3/+UvgnzrkrNc1h5KQT33HGvTJ5jBI6L37HPgft9cLXYr+MCc34zdFG0tC
         m3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wqwN6a1m1SmAd2kO8sEWXhlIvxjALunGrfiJPe7wSPI=;
        b=qCCkpuZghCmE/EHLcPw04IX+YdbSrAhByhv1eRjGwacGErp0NiPI2rK2FlFGBIzS+f
         vV7mVAwchAQrSUIOYuRTxpkDGt4iuAP19Fy5O53GuACdRZcetf7yujab7DV1N86iN3lU
         GRH+XgD30aSc00yYgnpQ47AGiLHjnjE71Q0ifZAZRJyae4HCVpopNGizgqFcBsUomBcL
         1VfcpgQfawaO/Ot0g0HghlxjpTwP48i6n5F3TdcFb2ZyGkanNPF38QfAtVexcUQWa6a2
         9cJiyXogjojc4Qnu4RID5g18/etJe9DI3OVXza+4NATuCkn08iM4GWq3x3ppevAvMPp1
         rGWg==
X-Gm-Message-State: AOAM530gILGjzsRW4ypp5i2UIRJSndn91Tqx3dWHvfsGCQocSRV7HvDU
        G5GYciE9gWhgk0Y8hPb8ylk=
X-Google-Smtp-Source: ABdhPJxawxaBDP21NCKLWizAuLzGnt+0c9cSdztkFAHEE3MmwWQLyhKklUKyILIdbq/1ybYgpAcIHw==
X-Received: by 2002:a17:906:229b:: with SMTP id p27mr10212335eja.264.1639562310762;
        Wed, 15 Dec 2021 01:58:30 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id ji4sm531785ejc.148.2021.12.15.01.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 01:58:30 -0800 (PST)
Date:   Wed, 15 Dec 2021 11:58:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH RFC v6 07/16] net: dsa: tag_qca: enable
 promisc_on_master flag
Message-ID: <20211215095829.jakvqqhyxgo6v6v2@skbuf>
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
 <20211214224409.5770-8-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214224409.5770-8-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 11:44:00PM +0100, Ansuel Smith wrote:
> Ethernet MDIO packets are non-standard and DSA master expects the first
> 6 octets to be the MAC DA. To address these kind of packet, enable
> promisc_on_master flag for the tagger.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  net/dsa/tag_qca.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
> index 34e565e00ece..f8df49d5956f 100644
> --- a/net/dsa/tag_qca.c
> +++ b/net/dsa/tag_qca.c
> @@ -68,6 +68,7 @@ static const struct dsa_device_ops qca_netdev_ops = {
>  	.xmit	= qca_tag_xmit,
>  	.rcv	= qca_tag_rcv,
>  	.needed_headroom = QCA_HDR_LEN,
> +	.promisc_on_master = true,
>  };
>  
>  MODULE_LICENSE("GPL");
> -- 
> 2.33.1
> 

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
