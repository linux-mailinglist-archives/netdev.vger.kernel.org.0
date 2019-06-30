Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B805B0AC
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 18:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfF3QeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 12:34:23 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53515 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfF3QeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 12:34:23 -0400
Received: by mail-wm1-f65.google.com with SMTP id x15so13484100wmj.3
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 09:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EypuURH9sKtEK/trOZ+xqInEJ9rs1CqeTvZO7G7LZ6w=;
        b=GOuD85SHWhyZYd6JUpC7GicjJfb7OUQ6xjfSEhVIsKhioNQXJ172iPrZu8AXapG9Ns
         Ovrn00kIl5FOdHjHbaCTyLFVqb+f3Kz9DL2+HhuNBTPIkjk+j0TirfkseYuRnHVpi93Z
         Xs32xWQoNu3BAqaw+xDhOGpZuCkz/zrhWuqY0emVezeGXJ4w/oE33PdbfJHeddkXGNen
         ULZ9m8xoq6ib+d5RPWSmOT0/tRWiPAPK+raBiv19e/knw3kEYhbChFhS8GRcN9dYMx1z
         1+XZl5slYIToCH5RNtbhdOg8qcqZeXDdm0eL/DwqyhkUMGAc0twS3dTmcTbaXkkKDOdM
         rrtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EypuURH9sKtEK/trOZ+xqInEJ9rs1CqeTvZO7G7LZ6w=;
        b=I3BW9iorVzHuKT/js4dWbmJiBVdVJONQ6P7nvGWmqGBaSZCuWP8ofti6AbfdzgGkii
         JjRhngMbTJE9u5U/Sq2BbRs7sgcJ39dCH2OREgL/tFMzIoB7SiMLFGt9rYqn+449ba70
         v+P60pzsjZES1UO9qbvoJSxdsH+Dafs8IwQHeMXrI0bkJ9bV7xqZyFNakQSJtfHFCguD
         8gP7QiWsixGeQUGAW6yAUSJAD4/jzZY52yc9NgX2or/3c3//cRrVyOqP2PqAc/g9Frxj
         rvbOW6gpD5f7rX17Qn8+hAcQEXrFroQlr/o7HkKG3/jrAY5K4woKM8YQ/xaUzFVxdysV
         T+jg==
X-Gm-Message-State: APjAAAUrfitDUu6WLMfz6GxfAjRA3+2Os5kDXbVxWFyoMR5NzpKpTtno
        jp/VpLlM6RJm2B8zHqgVF0N6QQ==
X-Google-Smtp-Source: APXvYqwoktb3Hi0g53TDyUHJ2rvwf+umg1y81MMQ7vSxYF66PuEeGzUgjo1ic92cXdsYwCTuLXxEJA==
X-Received: by 2002:a1c:7614:: with SMTP id r20mr14831819wmc.142.1561912461106;
        Sun, 30 Jun 2019 09:34:21 -0700 (PDT)
Received: from apalos (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id b9sm827043wrx.57.2019.06.30.09.34.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Jun 2019 09:34:20 -0700 (PDT)
Date:   Sun, 30 Jun 2019 19:34:17 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net, maciejromanfijalkowski@gmail.com
Subject: Re: [net-next, PATCH 3/3, v2] net: netsec: add XDP support
Message-ID: <20190630163417.GB10484@apalos>
References: <1561785805-21647-1-git-send-email-ilias.apalodimas@linaro.org>
 <1561785805-21647-4-git-send-email-ilias.apalodimas@linaro.org>
 <20190630162042.GA12704@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190630162042.GA12704@khorivan>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ivan,
> 
> [...]
> 
> >+
> >+static int netsec_xdp(struct net_device *ndev, struct netdev_bpf *xdp)
> >+{
> >+	struct netsec_priv *priv = netdev_priv(ndev);
> >+
> >+	switch (xdp->command) {
> >+	case XDP_SETUP_PROG:
> >+		return netsec_xdp_setup(priv, xdp->prog, xdp->extack);
> >+	case XDP_QUERY_PROG:
> >+		xdp->prog_id = priv->xdp_prog ? priv->xdp_prog->aux->id : 0;
> xdp_attachment family to save bpf flags?
Sure why not. This can always be added later though since many drivers are
already doing it similarly no?

> 
> >+		return 0;
> >+	default:
> >+		return -EINVAL;
> >+	}
> >+}
> >+
> >static const struct net_device_ops netsec_netdev_ops = {
> >	.ndo_init		= netsec_netdev_init,
> >	.ndo_uninit		= netsec_netdev_uninit,
> >@@ -1537,6 +1842,8 @@ static const struct net_device_ops netsec_netdev_ops = {
> >	.ndo_set_mac_address    = eth_mac_addr,
> >	.ndo_validate_addr	= eth_validate_addr,
> >	.ndo_do_ioctl		= netsec_netdev_ioctl,
> >+	.ndo_xdp_xmit		= netsec_xdp_xmit,
> >+	.ndo_bpf		= netsec_xdp,
> >};
> >
> >static int netsec_of_probe(struct platform_device *pdev,
> >-- 
> >2.20.1
> >
> 
> -- 
> Regards,
> Ivan Khoronzhuk

Thanks
/Ilias
