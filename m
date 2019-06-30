Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 708515B0A9
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 18:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfF3QZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 12:25:58 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42200 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfF3QZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 12:25:58 -0400
Received: by mail-lj1-f196.google.com with SMTP id t28so10545963lje.9
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 09:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0c2fo/z1d7POAVm35sVPDhPi3YhySRy0dSUq7hcCsyI=;
        b=VMWUSoZrOXLjsDGFMajsASN3YyaakWDCMbknsCmQwYDGvLsxwNjTORMqCKuEuWphmU
         7ArkKPFS+NXAVfnTLx3mfJWY1cuLJ/yTH/QErxr3A/xbCdEjcuLiOYyulXr6tpSOgOSw
         RaajUih82bjfnBBBKiMyL+Xb8opNk9P3ZxEU4f1NtNpRnmEN4tcmXw659S62az7riKP7
         Yo4RaWkJ14e74MbkAelCDwLV9jvw6JUaimsl3SSED9oyfiZu/TAbTU/8fpWtY4uO5rGG
         R5Zyyb1NcFSMTyMOTWtSta/QIGGNVyoR1MqrHS11GuFPvc5mYplcCG1RElKukPOcYqyQ
         3YPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0c2fo/z1d7POAVm35sVPDhPi3YhySRy0dSUq7hcCsyI=;
        b=ER9cG6pTKQ7E6c9qerLca/JF8IVKXIvSgbAysihgtHPcYFhBfjMsmD0Egvvj4IL7pp
         7ZzfAi+DDTwdC7qijuZNIjPi1a76kEa3m5CtQUt5z3k2faYaHNEb5f0BUHiKZYunhrbT
         4IfV7EufVglBvMC2/e2NehUOSD5F3yKVZKNuWtKO/cUxnOuRQ94nk7bDhPxJbm7HfVxE
         sm4p+FqhdFhdfwygNzGtFkpVUR49c9h7t3sUZ6m5qiunEndmxBjtL0CoQDKaxnwvCvlV
         cXImQmzjUi4JXDE43FyfvkmMfN7f/c1u2c9Is47vt7S/A8g6ozqqtXV01myt00WrN6gz
         B5xg==
X-Gm-Message-State: APjAAAWQjm5ZLItkhUw++2UHxSHFjlthz2Eu1SFkPsqUTCrEn+Wzug2y
        0eMTyj9DghVGguAe1CikvTNvTA==
X-Google-Smtp-Source: APXvYqwNqkrbZXGZxpHPV+cBoIpHWUqU+T13OxMc6h6z/+cAqoqIaVhq7u+4zbP56ewa7TWZZesjGw==
X-Received: by 2002:a05:651c:95:: with SMTP id 21mr11823134ljq.128.1561911956619;
        Sun, 30 Jun 2019 09:25:56 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id q2sm2153772lfj.25.2019.06.30.09.25.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 30 Jun 2019 09:25:56 -0700 (PDT)
Date:   Sun, 30 Jun 2019 19:25:53 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net, maciejromanfijalkowski@gmail.com
Subject: Re: [net-next, PATCH 3/3, v2] net: netsec: add XDP support
Message-ID: <20190630162552.GB12704@khorivan>
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
>The interface only supports 1 Tx queue so locking is introduced on
>the Tx queue if XDP is enabled to make sure .ndo_start_xmit and
>.ndo_xdp_xmit won't corrupt Tx ring
>
>- Performance (SMMU off)
>
>Benchmark   XDP_SKB     XDP_DRV
>xdp1        291kpps     344kpps
>rxdrop      282kpps     342kpps
>
>- Performance (SMMU on)
>Benchmark   XDP_SKB     XDP_DRV
>xdp1        167kpps     324kpps
>rxdrop      164kpps     323kpps
>
>Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
>---
> drivers/net/ethernet/socionext/netsec.c | 361 ++++++++++++++++++++++--
> 1 file changed, 334 insertions(+), 27 deletions(-)
>

[...]

>+
>+static int netsec_xdp_setup(struct netsec_priv *priv, struct bpf_prog *prog,
>+			    struct netlink_ext_ack *extack)
>+{
>+	struct net_device *dev = priv->ndev;
>+	struct bpf_prog *old_prog;
>+
>+	/* For now just support only the usual MTU sized frames */
>+	if (prog && dev->mtu > 1500) {
>+		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
>+		return -EOPNOTSUPP;
>+	}
>+
>+	if (netif_running(dev))
>+		netsec_netdev_stop(dev);
And why to stop the interface. XDP allows to update prog in runtime.

>+
>+	/* Detach old prog, if any */
>+	old_prog = xchg(&priv->xdp_prog, prog);
>+	if (old_prog)
>+		bpf_prog_put(old_prog);
>+
>+	if (netif_running(dev))
>+		netsec_netdev_open(dev);
>+
>+	return 0;
>+}
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
