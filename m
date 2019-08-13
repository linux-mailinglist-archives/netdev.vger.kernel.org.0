Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2792E8C265
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 22:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfHMU5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 16:57:35 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39688 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfHMU5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 16:57:35 -0400
Received: by mail-qk1-f193.google.com with SMTP id 125so7814233qkl.6
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 13:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=bNfCPQHfFfS05Ua0jgfTWRkNVMemAI0m1k8K0MkNCfo=;
        b=YwV4nGNRSR1A1eVJ/QD41sekOqfOp8xgyNC95HHYPXad4HG7a2JDRShmZhBlpGQUUt
         WSHEMsmrJ19lmUCYMUrWkocjF2D0hTI4iyF5PpD0ZhSAQO+GkBFVViFj9Gx4u0oJPIWS
         y1GYX3DWqvmZ4Sjfdt+P0aNDrEQX9tP/jtldhK1rGqsPbAAoJ+Bk7SDMmzBcjGOfTvwg
         Pp/zVhGRjz7gsjbgYw3pqzG15i7zJ0RUecjBuDopi4mFQbblrWUTjCHFH52oWPytiFD4
         IVpRDmpauS0ZvJMBttPhzfi9MdcVF7kuk2lhyfa2uX4iQdFXBu9gUfwyrmRD5IvX2NgN
         LlvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=bNfCPQHfFfS05Ua0jgfTWRkNVMemAI0m1k8K0MkNCfo=;
        b=ttddE4x+y/Bt8Z96+PwJwFzpfaHbOPt7CcpoLNmbSak2lsKipMIEx1dPz1hITNWFDH
         WSgXAu9H+3tUxwOEV1QshmEiZtsrD+/DKF1gw6uRAd8DC6+Jjna624i2F0+dB9fLQc1E
         DzCiQGG6bclXJHIGh3rXo/pJf6EZ2hrlKAhMrreRRGFPeD8WT83uke7IJ7DAc/e2MMSG
         9SYcEfnCJXKPplJDJgWh3OHmKvtNcpD22bjvHGMtEk+KuKvnxvWe1o9HQ08mncfcXnku
         5BhRyCzZUonQV3M+ImbpL4Ydt1NIFls0hEvz4nwmq8sdmHWN0R4iH0s46NB2nKDnjxeQ
         JeQA==
X-Gm-Message-State: APjAAAW6aTzoRFOhCKZ8mWZboBHxfjeblhJ1jJFBLKqv+r66W2h9/GD7
        bpviUbllcWXqHtYviAo5LxtpOw==
X-Google-Smtp-Source: APXvYqxfiM+cvNMIUPbfi2x+FX0ul2aixQ+5yH92qTgQl+N7+EOdhtTpE+zWSqcR0Xy7ioIiApIKdw==
X-Received: by 2002:a37:b82:: with SMTP id 124mr33996866qkl.260.1565729854473;
        Tue, 13 Aug 2019 13:57:34 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d71sm11374918qkg.70.2019.08.13.13.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 13:57:34 -0700 (PDT)
Date:   Tue, 13 Aug 2019 13:57:22 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 01/12] net: stmmac: Get correct timestamp
 values from XGMAC
Message-ID: <20190813135722.22ea671d@cakuba.netronome.com>
In-Reply-To: <195f374a0b46e5e65a691742fc2dbeffacfaf148.1565602974.git.joabreu@synopsys.com>
References: <cover.1565602974.git.joabreu@synopsys.com>
        <195f374a0b46e5e65a691742fc2dbeffacfaf148.1565602974.git.joabreu@synopsys.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 11:44:00 +0200, Jose Abreu wrote:
> TX Timestamp in XGMAC comes from MAC instead of descriptors. Implement
> this in a new callback.
> 
> Also, RX Timestamp in XGMAC must be cheked against corruption and we need
> a barrier to make sure that descriptor fields are read correctly.
> 
> Changes from v1:
> 	- Rework the get timestamp function (David)
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>

The barrier sounds like it might be a bug fix, does it occur in he wild?

> @@ -113,13 +119,11 @@ static int dwxgmac2_get_rx_timestamp_status(void *desc, void *next_desc,
>  	unsigned int rdes3 = le32_to_cpu(p->des3);
>  	int ret = -EBUSY;
>  
> -	if (likely(rdes3 & XGMAC_RDES3_CDA)) {
> +	if (likely(rdes3 & XGMAC_RDES3_CDA))
>  		ret = dwxgmac2_rx_check_timestamp(next_desc);
> -		if (ret)
> -			return ret;
> -	}
> -
> -	return ret;
> +	if (!ret)
> +		return 1;
> +	return 0;

nit:

	return !ret;

>  }
>  
>  static void dwxgmac2_init_rx_desc(struct dma_desc *p, int disable_rx_ic,

