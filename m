Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F217263537
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgIISAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgIISAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:00:52 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83D7C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:00:51 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d6so2828583pfn.9
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 11:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aFmC1pJgIhnfvlhwMi9IZaa/+4AKS/FjOWmImOieiQ8=;
        b=TpHhKE0/V1wspIbV6oa70/4RItUuc8mpMUgcgnZj1I7i+gYgOkODCEW4lyqIOHy7fG
         0ONmhN2C/g4NG1Dzg+l6CkwcK3+9x/oUTqou8h4lA7TjChE3aFO89Ucq+ZQhRj3t46IT
         +f3o5s4PNGreCxwa5LhdIF2btPFTyJij1CE/GmfGDNvCTIbAedfcY0ohoMmSq5oHE7R0
         xBApOyevKaWuv179niUq9C7lQvWURCi5IL42VR1uggLPb5hCYN+1zNEg+ML/zjZU5WRj
         q58pLU/6+kfLO7gzFwpez5cjSMyJQTbPaCOtOJ9EihhPcSZAW5Ij4NAigWYc9WLnfd63
         SbSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aFmC1pJgIhnfvlhwMi9IZaa/+4AKS/FjOWmImOieiQ8=;
        b=sHB5HqxANpZdfuyoOrxYwUvk/pKYTm9oOhkY6XvFGX4l511YMd5vSTFSnxqZuVArR0
         69Cjp4Twv2jCBGCg7DwU8tkspN1JSi//qeDrGccJamjK49O59ajBTg8Mjlzrdd/DpqCW
         OZwqZqCTz6TR3SpjpxHSYkzdV/tcioYvBDhbqQvILWnAhG+jbg4mkzKcroifgp/MfEX/
         WDq8RyQOjMvoR+lKjFaj8XRKdMjShjaXWcRyW1T/+nQfCEix4zzM+dx/lSdfhG5GHud0
         uGxAlDucbkJglMNmd6FfP4gOT9w5o5SHFLM1SUv9Jhdkurnu6ty65fEP+yY/wT3PKl70
         hv/g==
X-Gm-Message-State: AOAM5330er9AEi/Pdk0ltRf19jYXaK4ei7WOtqHj/ncnMuK/odrsiMp4
        basXXQNJ/zSqr1Wy7cr7Drc=
X-Google-Smtp-Source: ABdhPJw7xSAYgrKK8n0XwId8kod7ZXQYoCzDXJ8j5Lin64qZUXOLH+B+R19giwhq2Sy9iStWwnY18A==
X-Received: by 2002:a17:902:7d86:b029:cf:85a7:8372 with SMTP id a6-20020a1709027d86b02900cf85a78372mr2095268plm.1.1599674450586;
        Wed, 09 Sep 2020 11:00:50 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id cf7sm2633260pjb.52.2020.09.09.11.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 11:00:49 -0700 (PDT)
Date:   Wed, 9 Sep 2020 11:00:47 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 7/7] net: mvpp2: ptp: add support for
 transmit timestamping
Message-ID: <20200909180047.GB24551@hoboy>
References: <20200908214727.GZ1551@shell.armlinux.org.uk>
 <E1kFlfN-0006di-Pu@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1kFlfN-0006di-Pu@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 11:00:41PM +0100, Russell King wrote:

> +static bool mvpp2_tx_hw_tstamp(struct mvpp2_port *port,
> +			       struct mvpp2_tx_desc *tx_desc,
> +			       struct sk_buff *skb)
> +{
> +	unsigned int mtype, type, i, offset;
> +	struct mvpp2_hwtstamp_queue *queue;
> +	struct ptp_header *hdr;
> +	u64 ptpdesc;
> +
> +	if (port->priv->hw_version == MVPP21 ||
> +	    port->tx_hwtstamp_type == HWTSTAMP_TX_OFF)
> +		return false;
> +
> +	type = ptp_classify_raw(skb);
> +	if (!type)
> +		return false;
> +
> +	hdr = ptp_parse_header(skb, type);
> +	if (!hdr)
> +		return false;

At this point, the skb will be queued up to receive a transmit time
stamp, and so it should be marked with:

	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;


The rest of the patch looks reasonable.

Acked-by: Richard Cochran <richardcochran@gmail.com>

