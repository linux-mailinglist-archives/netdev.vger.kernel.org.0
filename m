Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3803B50D6A7
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 03:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240194AbiDYBlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 21:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240195AbiDYBlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 21:41:05 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3B55FA8
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 18:38:03 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id w16so7008271pfj.2
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 18:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=beiRTNRgtDPCBbAAxa3gBqhgyIinh7nThahsGNYl1a8=;
        b=AD3f6rL+ZxyDrcR9+SA7Zchov8s1YLCrG1Iu+GTDqDG8sTxYqEw7jZlynKwUVcbTUM
         D7vKwTvvKTLNcF0xaJaBFKtPHYg3U4dzAx2eWHakNcsLWxLPgFvy03U/gBV2NGjMp9uw
         dA0IPW0UvcR4c1JDGLXDoZitRHzXiHy2gdnMsEak/dnhK40jUrm0NqXqL/Uy+P/je7we
         +owO/K6ZRoPEXzG1GBkv28TBFuRefAfVRTtGwctqyMM0dPCfFZy1H1wGeALhxCxmZZ1/
         ekYQTCrh1jMx2SuxA2pCMJpeqFCnAxb8FM7041lmcXUAegEdSfzcxp9SS1ObzdJF0Giq
         Vu6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=beiRTNRgtDPCBbAAxa3gBqhgyIinh7nThahsGNYl1a8=;
        b=vHVcTA72AEYyW5IKOCGrxZLwhBM1rWG/5MfNgIM4YHjDPNgA8LpK5abvN5HKN3hF3Q
         Wl5cv7QAZ1E1uiBbTYiWPai8A8O8m3UQxfmca2e6DW7JflRkE6ryOURAkH8SfSr2fJLi
         EVuwLERAOpl8CCN2ftMJu/gTuJEVQfxIGuRVrtDVsEU6vPMlrHgNWKSQ6Ec+9urpuPQC
         4KYWkrobb4YcHAQm5q9/Zsw9+hqDHDISC3Bbmdo62BSGRMaooiClUxiOhGQH3LCTA92F
         lOpYujKxi2WxV/jql9/Lvqpt3FlOWAgdRjG/ChlC2ydO87piKXjaRALW2aBxs18SJLbO
         bxTg==
X-Gm-Message-State: AOAM533HChgS5SsIVMNq1bk/4NYm22RDOgIG/I/DJbHGge5BySUpu/dM
        8MwqNFpOBkOuYCAqbJjIWW1vA0OoyQM=
X-Google-Smtp-Source: ABdhPJz/9ajh8nJefRtBCl6uqzay0odfgs+Bu1Zu9MQ1/ykI2OLVExLmjqczeoIkhwnw/Ot4EtxMNA==
X-Received: by 2002:a05:6a00:300f:b0:50d:4443:977c with SMTP id ay15-20020a056a00300f00b0050d4443977cmr984177pfb.58.1650850683106;
        Sun, 24 Apr 2022 18:38:03 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id z10-20020a62d10a000000b0050d3c3668bcsm2251977pfg.137.2022.04.24.18.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 18:38:02 -0700 (PDT)
Date:   Sun, 24 Apr 2022 18:38:00 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next v1 1/4] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220425013800.GC4472@hoboy.vegasvil.org>
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
 <20220424022356.587949-2-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424022356.587949-2-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 23, 2022 at 07:23:53PM -0700, Jonathan Lemon wrote:

> +static bool bcm_ptp_get_tstamp(struct bcm_ptp_private *priv,
> +			       struct bcm_ptp_capture *capts)
> +{
> +	struct phy_device *phydev = priv->phydev;
> +	u16 ts[4], reg;
> +	u32 sec, nsec;
> +
> +	mutex_lock(&priv->mutex);
> +
> +	reg = bcm_phy_read_exp(phydev, INTR_STATUS);
> +	if ((reg & INTC_SOP) == 0) {
> +		mutex_unlock(&priv->mutex);
> +		return false;
> +	}
> +
> +	bcm_phy_write_exp(phydev, TS_READ_CTRL, TS_READ_START);
> +
> +	ts[0] = bcm_phy_read_exp(phydev, TS_REG_0);
> +	ts[1] = bcm_phy_read_exp(phydev, TS_REG_1);
> +	ts[2] = bcm_phy_read_exp(phydev, TS_REG_2);
> +	ts[3] = bcm_phy_read_exp(phydev, TS_REG_3);
> +
> +	/* not in be32 format for some reason */
> +	capts->seq_id = bcm_phy_read_exp(priv->phydev, TS_INFO_0);
> +
> +	reg = bcm_phy_read_exp(phydev, TS_INFO_1);
> +	capts->msgtype = reg >> 12;
> +	capts->tx_dir = !!(reg & BIT(11));

Okay, so now I am sad.  The 541xx has:

  TIMESTAMP_INFO_1 0xA8C  bit 0 DIR, bits 1-2 msg_type, etc
  TIMESTAMP_INFO_2 0xA8D  sequence ID

It is the same info, but randomly shuffled among the two registers in
a different way.

So much for supporting multiple devices with a common code base.  :(

> +	bcm_phy_write_exp(phydev, TS_READ_CTRL, TS_READ_END);
> +	bcm_phy_write_exp(phydev, TS_READ_CTRL, 0);
> +
> +	mutex_unlock(&priv->mutex);
> +
> +	sec = (ts[3] << 16) | ts[2];
> +	nsec = (ts[1] << 16) | ts[0];
> +	capts->hwtstamp = ktime_set(sec, nsec);
> +
> +	return true;
> +}

Thanks,
Richard
