Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F04515B08C
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 18:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfF3QUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 12:20:48 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38973 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfF3QUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 12:20:48 -0400
Received: by mail-lj1-f193.google.com with SMTP id v18so10552844ljh.6
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 09:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uT0azBp5Pz+yltW38ejp0vjnxXV37b9+kSG9CSkj6Sg=;
        b=i/WFVhqose3KcBa7oAI0hwLwyxQ307FBH2ysvZesXoA58jqnJ/k7pTKXZr2Tg/5FVM
         ESjuN98UPX7zMTJV90pDKZyv76oMpsCcSHPqzVtWnsSRr1psp1aFY7k/nFHZcAqcbZrJ
         gZj6ogSsxjoTmMJv4jhTyAlq6Hk7azlTZF7/9Ci4oUDMZ9Fp8Xq04+mfn3Hmp8xrcSNG
         lO5jJ0ry7n80nHpKrD9LYtitSyW/uWE9cqYvIaifPY0lssnpS1vV2mM+DKvwxeOnlYSI
         UNRtXTvms1dJLUY2NEXBYqjFhRQ4jYhIvgE3ZB5JVL66Ua0Z6Mb//3bvD78eefQlqRDp
         7q8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uT0azBp5Pz+yltW38ejp0vjnxXV37b9+kSG9CSkj6Sg=;
        b=jvsyshkIqYkQSrXkPWaTtMSRKqfb+AEhKnO4H10+BaU5/0CaeHCvmYVfGJzNB5QHhV
         B1pYurXdrSE+y0/VUG/KBP4Y2k+g+TkgDiQdylOZx49bijHSzjZSi6qDtpVxkpJSrjtJ
         LNKaJxRH6yKqFyD/kxwDOqw2EOox9ddi6oue3ZLK6qdKXgv5FlmIQTH2FUNg8YpJZQ21
         vUQsERmoKq6Vc1+zvNwCVwaz36dIcF/a9Vo2+kzgvh3wHS1iAbaZ64bOwq/XJqeS2NPE
         hJBXnkQrDK7bj25vMPXsVD1QMqH286UrxxYE8uZ63tk+Li4YMArDrQyXshd/maj23ywf
         4FHQ==
X-Gm-Message-State: APjAAAWmG8T5FZS70UDfGMS//g7MFUlmZSLFAx1COh606F4OTA/q1+im
        1t/MX0MKGaT3pnFWpzUxvKOe5w==
X-Google-Smtp-Source: APXvYqwjwSIdyzLjLFLV8nUIzyd+9tRjC9LK0XBI5kS/bnEcLdq67ROGzHEjy7bJIwf7Pa5UyAj3kQ==
X-Received: by 2002:a2e:6313:: with SMTP id x19mr11591947ljb.25.1561911646063;
        Sun, 30 Jun 2019 09:20:46 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id p27sm2251629lfo.16.2019.06.30.09.20.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 30 Jun 2019 09:20:45 -0700 (PDT)
Date:   Sun, 30 Jun 2019 19:20:43 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net, maciejromanfijalkowski@gmail.com
Subject: Re: [net-next, PATCH 3/3, v2] net: netsec: add XDP support
Message-ID: <20190630162042.GA12704@khorivan>
References: <1561785805-21647-1-git-send-email-ilias.apalodimas@linaro.org>
 <1561785805-21647-4-git-send-email-ilias.apalodimas@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1561785805-21647-4-git-send-email-ilias.apalodimas@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 29, 2019 at 08:23:25AM +0300, Ilias Apalodimas wrote:

[...]

>+
>+static int netsec_xdp(struct net_device *ndev, struct netdev_bpf *xdp)
>+{
>+	struct netsec_priv *priv = netdev_priv(ndev);
>+
>+	switch (xdp->command) {
>+	case XDP_SETUP_PROG:
>+		return netsec_xdp_setup(priv, xdp->prog, xdp->extack);
>+	case XDP_QUERY_PROG:
>+		xdp->prog_id = priv->xdp_prog ? priv->xdp_prog->aux->id : 0;
xdp_attachment family to save bpf flags?

>+		return 0;
>+	default:
>+		return -EINVAL;
>+	}
>+}
>+
> static const struct net_device_ops netsec_netdev_ops = {
> 	.ndo_init		= netsec_netdev_init,
> 	.ndo_uninit		= netsec_netdev_uninit,
>@@ -1537,6 +1842,8 @@ static const struct net_device_ops netsec_netdev_ops = {
> 	.ndo_set_mac_address    = eth_mac_addr,
> 	.ndo_validate_addr	= eth_validate_addr,
> 	.ndo_do_ioctl		= netsec_netdev_ioctl,
>+	.ndo_xdp_xmit		= netsec_xdp_xmit,
>+	.ndo_bpf		= netsec_xdp,
> };
>
> static int netsec_of_probe(struct platform_device *pdev,
>-- 
>2.20.1
>

-- 
Regards,
Ivan Khoronzhuk
