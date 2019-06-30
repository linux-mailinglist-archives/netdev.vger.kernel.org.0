Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F197A5B0AA
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 18:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfF3QcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 12:32:20 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51123 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfF3QcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 12:32:20 -0400
Received: by mail-wm1-f67.google.com with SMTP id n9so1578615wmi.0
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 09:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ml2+heovZWJhTfyAw7eC+MjRDUwaiwynrflJIpHs6Bw=;
        b=pg5EOxkIlE6Ezz4o1lUxruxC8rOsOKIy/pTKz1sz3s14cive3cen83YNn+j9Mhcd6L
         MbmySFqF8TcjSXceAbmPxBBTW8DoeC5i3PhguY1CcZQbBJE5tKD+vL/FVYNQHGn3iJWc
         YGeIvavqCx3fwEZoGxbaS06qS0QepqjhAmTEgoj1o0eyFDIXH9OLK3c5QegeAOKeN775
         O50xnT+TDi+eMnAliKFHrpjZHExnWaceaWnSV5bhaXZylkePVEV3XjTrui1TjhPIHwEy
         eA7Zfz0szu1gJ1tcKCeSQrS7B/gwAf9GwqtT5pi8wiT3zVgGQPztHtmb/ULsAusy6bJb
         AoLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ml2+heovZWJhTfyAw7eC+MjRDUwaiwynrflJIpHs6Bw=;
        b=VY65s33zIaea4YeSTdMjRAKBEEtWJoeHbNQAzpAoWecHF4zZSN3B5BN154kwVyhA9z
         3bZCklw693EhPr4Xd84KlPvfBi3cj1axJ4aRdTGFpi+CK1IVQPggzE+t4VpBRxUE2TPt
         mLwZZtJbz0JecEdRSB5t10WOa2dcbKIIsu5dbf1rbYBvjG9wauafOK/pW+r1oLDPSYvn
         ajzVw+H9TJyVltRDe5SetT1VuQVI0WJaAog3eNAaxzEVZGK6h93a+A9UPDKZW2ZuQh3m
         rhB5NC6MlJM7iA9LLpmM7lqnCibMMHb+OclJETsQz89u2ZEMGi6bYQDA7bJfYlxBwnZm
         peGA==
X-Gm-Message-State: APjAAAUykq1pSWOO2eQEFG8Igwfr/BdAihdkElK2EGUc1KR5eUG7umtU
        N/MhrbsANjfxds+GV8Ijs/XU7A==
X-Google-Smtp-Source: APXvYqx7n2vkIMrSIrkEWKby6wFA0mtmWgQTElTGS0Fkv1+dkqfcwGFZiDBIJPiweRur8mnboRiA0w==
X-Received: by 2002:a7b:c398:: with SMTP id s24mr14388511wmj.53.1561912337815;
        Sun, 30 Jun 2019 09:32:17 -0700 (PDT)
Received: from apalos (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id y4sm9649656wrn.68.2019.06.30.09.32.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Jun 2019 09:32:17 -0700 (PDT)
Date:   Sun, 30 Jun 2019 19:32:14 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net, maciejromanfijalkowski@gmail.com
Subject: Re: [net-next, PATCH 3/3, v2] net: netsec: add XDP support
Message-ID: <20190630163214.GA10484@apalos>
References: <1561785805-21647-1-git-send-email-ilias.apalodimas@linaro.org>
 <1561785805-21647-4-git-send-email-ilias.apalodimas@linaro.org>
 <20190630162552.GB12704@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190630162552.GB12704@khorivan>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 07:25:53PM +0300, Ivan Khoronzhuk wrote:
> On Sat, Jun 29, 2019 at 08:23:25AM +0300, Ilias Apalodimas wrote:
> >The interface only supports 1 Tx queue so locking is introduced on
> >the Tx queue if XDP is enabled to make sure .ndo_start_xmit and
> >.ndo_xdp_xmit won't corrupt Tx ring
> >
> >- Performance (SMMU off)
> >
> >Benchmark   XDP_SKB     XDP_DRV
> >xdp1        291kpps     344kpps
> >rxdrop      282kpps     342kpps
> >
> >- Performance (SMMU on)
> >Benchmark   XDP_SKB     XDP_DRV
> >xdp1        167kpps     324kpps
> >rxdrop      164kpps     323kpps
> >
> >Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> >---
> >drivers/net/ethernet/socionext/netsec.c | 361 ++++++++++++++++++++++--
> >1 file changed, 334 insertions(+), 27 deletions(-)
> >
> 
> [...]
> 
> >+
> >+static int netsec_xdp_setup(struct netsec_priv *priv, struct bpf_prog *prog,
> >+			    struct netlink_ext_ack *extack)
> >+{
> >+	struct net_device *dev = priv->ndev;
> >+	struct bpf_prog *old_prog;
> >+
> >+	/* For now just support only the usual MTU sized frames */
> >+	if (prog && dev->mtu > 1500) {
> >+		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
> >+		return -EOPNOTSUPP;
> >+	}
> >+
> >+	if (netif_running(dev))
> >+		netsec_netdev_stop(dev);
> And why to stop the interface. XDP allows to update prog in runtime.
> 
Adding the support is not limited to  adding a prog only in this driver.
It also rebuilts the queues which changes the dma mapping of buffers.
Since i don't want to map BIDIRECTIONAL buffers if XDP is not in place,
i am resetting the device and forcing the buffer re-allocation

Thanks
/Ilias
