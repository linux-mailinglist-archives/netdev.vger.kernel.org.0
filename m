Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE48C34BB9B
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 09:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhC1HwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 03:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbhC1HwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 03:52:03 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B938C061762
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 00:52:03 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id h13so10860920eds.5
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 00:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k5RatkOVxFfdM84AfEKATbLyXLOQRY2v+7NM3rQVkqM=;
        b=UbPMa2FJDzeq6AM75/Ro4Y/pBu3pTEb3ODgLGiE4h1NIdgMkv+jowrcltpTqfLtAgz
         UTZl3dayJc2WSal44ScOBaFaD13VU0y8G+EfkhYB18ppdnVhs/8MUp4kiC+UUlPhfXeX
         Xw3u9rKNbd1FAYJEAGUFBd/cPZM6wNt5QQrjbyyIv6slaDPghhPeLthS/j6pgi2EEqbr
         wPb1Xa82lVIIA1GoBcNzSJUjqwcSWnJ8pTbTEfVlqkydw5z1r85IBWrlkAeep/pEOQT7
         F8k25vqPlP0Ae7xiRFl8C3u6nLSgSun2QZV1IwarIDjJB1GuGbXVadFUXP2lm6l1Jb/D
         Gepg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k5RatkOVxFfdM84AfEKATbLyXLOQRY2v+7NM3rQVkqM=;
        b=Dmh+uMurJl68t5YiNaZPgZW1bovzhzYcFjV3MzJcWWb1ygEAghO9Lu6mX0wI8j2Nr8
         oQV4zwOD+A0AlDn/NbV9ttlzqLAeFxK8K01jNvxIt5sELyy8QdXI8aZTanLZQm6yjG2W
         g6TRvwqOvoLX8N7Z2R6pXDJO2IFt7tqetLa/5oclg5PiRPY22jV1seEgL9u9gRsXTGXA
         H9gkbrJ35ubLOZsc1c/fEB6Q1+ZNZNG7VZ/W0Qdm00EpduWzWAoOUkcneD3XQPLA930n
         8tIB6z+4R/oUmYyU1BiJv0Ce/WZ+xnGj03IrcJxfzTFt1iWAgZemKs+1dVrq1pJEPygW
         gObg==
X-Gm-Message-State: AOAM531mFbMKp2mqzvI47xgH0DcAxE5SZdmsNqjSPyN/qUfcwUbjZs0v
        crRltrmU5iQFueJw97GGXDU=
X-Google-Smtp-Source: ABdhPJwhZ2wEDy0gOF8AEhYOMDadpooDqnnnMmu+rdBIfCGx/ivXlNM3Z1V6JJdMHyS0vHdnsZ076w==
X-Received: by 2002:a05:6402:50ce:: with SMTP id h14mr23207210edb.279.1616917921703;
        Sun, 28 Mar 2021 00:52:01 -0700 (PDT)
Received: from [192.168.0.129] ([82.137.32.50])
        by smtp.gmail.com with ESMTPSA id w6sm6223360eje.107.2021.03.28.00.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Mar 2021 00:52:01 -0700 (PDT)
Subject: Re: [PATCH 2/2] enetc: support PTP Sync packet one-step timestamping
To:     Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210326083554.28985-1-yangbo.lu@nxp.com>
 <20210326083554.28985-3-yangbo.lu@nxp.com>
From:   Claudiu Manoil <claudiu.manoil@gmail.com>
Message-ID: <8fa3394e-847f-a3fa-438a-1b357b5726fa@gmail.com>
Date:   Sun, 28 Mar 2021 10:51:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210326083554.28985-3-yangbo.lu@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yangbo,
Pls add the [net-next] prefix to the subject of these patches next time, 
to avoid the patchwork warnings and let reviewers know where to apply them.

On 26.03.2021 10:35, Yangbo Lu wrote:
[...]> +netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev)
> +{
> +	struct enetc_ndev_priv *priv = netdev_priv(ndev);
> +	u8 udp, msgtype, twostep;
> +	u16 offset1, offset2;
> +
> +	/* Mark tx timestamp type on skb->cb[0] if requires */
> +	if ((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
> +	    (priv->active_offloads & ENETC_F_TX_TSTAMP_MASK)) {
> +		skb->cb[0] = priv->active_offloads & ENETC_F_TX_TSTAMP_MASK;
> +	} else {
> +		skb->cb[0] = 0;
> +	}
> +
> +	if (skb->cb[0] & ENETC_F_TX_ONESTEP_SYNC_TSTAMP) {
> +		/* For one-step PTP sync packet, queue it */
> +		if (!enetc_ptp_parse(skb, &udp, &msgtype, &twostep,
> +				     &offset1, &offset2)) {
> +			if (msgtype == PTP_MSGTYPE_SYNC && twostep == 0) {
> +				skb_queue_tail(&priv->tx_skbs, skb);
> +				queue_work(priv->enetc_ptp_wq,
> +					   &priv->tx_onestep_tstamp);
> +				return NETDEV_TX_OK;
> +			}
> +		}
> +
> +		/* Fall back to two-step timestamp for other packets */
> +		skb->cb[0] = ENETC_F_TX_TSTAMP;
> +	}
> +
> +	return enetc_start_xmit(skb, ndev);
> +}
> +
[...]
> +static void enetc_tx_onestep_tstamp(struct work_struct *work)
> +{
> +	struct enetc_ndev_priv *priv;
> +	struct sk_buff *skb;
> +
> +	priv = container_of(work, struct enetc_ndev_priv, tx_onestep_tstamp);
> +
> +	while (true) {
> +		skb = skb_dequeue(&priv->tx_skbs);
> +		if (!skb)
> +			return;
> +
> +		/* Lock before TX one-step timestamping packet, and release
> +		 * when the packet has been sent on hardware, or transmit
> +		 * failure.
> +		 */
> +		mutex_lock(&priv->onestep_tstamp_lock);
> +		enetc_start_xmit(skb, priv->ndev);
> +	}
> +}
> +
What happens if the work queue tries to send the ptp packet concurrently 
with a regular packet being sent by the stack, via .ndo_start_xmit?
If both skbs are targetting the same tx_ring then we have a concurrency 
problem, as enetc_map_tx_buffs(tx_ring, skb) is not thread safe!

Regards,
Claudiu
