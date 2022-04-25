Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B1850D769
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbiDYDPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbiDYDPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:15:46 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25495158C
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 20:12:43 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id j8so24005179pll.11
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 20:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZXxjd/MPII33XETKWpx4qAcbqVCXZGWC80GHGMxlxUo=;
        b=Vs6KufAKjRIL4dDXQYwGg9wpNNEhz5abw60qwpj36QTFfzQ54acUgbiOfVnQgrsPzG
         gkvNDOE8vzJfeK8iQtM9//pGj+mAC+B/h0qyfdJd/7BO+loA/nb1hIkd/Yq2vcM0GMZT
         zmoCyDKiFWqiaB4ODq5pnKK9De9YEgsM8CEpIZgQao7wFls2xK1lqoUYgL048ZEESM6Z
         +Z0Tal468uK3ET+omF96Ag6hgvIeSgBFTVwMtpTfDV2sK2t+iCOy7ch1j/RSBOFjKPE5
         bKnnNhS/4is4uHyS624njmQYSSqeGkrFfLtR1IxlzVxB3gyu8vzKt+hFaThB0ULNP6X7
         ln/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZXxjd/MPII33XETKWpx4qAcbqVCXZGWC80GHGMxlxUo=;
        b=Yvw2IrblP7SAdZgsmgURO+8W8fursqt2BSNxBLgboYIjJCSbp7UJXttgIY35FqXjnc
         SIhVfRJbrYv4c1/azTsFHDa+XKnwteua0hKB098XCosBB2OU8wr0JNhK7yPwWkoK658X
         q1asbyU+O1g9XXUJ/imRGm23WUhtmE5squl8gymCrGF8bQ26oZsi/yj2AREvNouh2hsK
         ukqDhBXQSSiQQgBB/ylZFXTfqFFmUOHmmcjf55bVAtlz5whmuxAwfPKYNyDkFt8h1Whh
         gYXRB2RjQfjJTJynGZ9psmnP0NxGtCyFGhi4FLm6utep6y1PLjfifqrKc55u0Eb1JYvT
         fSYw==
X-Gm-Message-State: AOAM533E3O4z88WxLS8HjQCHAD7hRbU6LCFUWJ7pFeioHMN58aNAtf02
        2vNd2YrSlU0GwLWtYeadvb3ygnnkAjk=
X-Google-Smtp-Source: ABdhPJwlHStz2HJKvVvvrbUrt9hYfWbWFWQGWXvuvMp89d1bPM/CmyhtqnqPK9DvBgxC/BptpNFBgA==
X-Received: by 2002:a17:90b:1a89:b0:1d2:f7ae:4928 with SMTP id ng9-20020a17090b1a8900b001d2f7ae4928mr29276617pjb.46.1650856363334;
        Sun, 24 Apr 2022 20:12:43 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id p12-20020a63ab0c000000b00381f7577a5csm7732588pgf.17.2022.04.24.20.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 20:12:42 -0700 (PDT)
Date:   Sun, 24 Apr 2022 20:12:39 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next v1 1/4] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220425031239.GA6294@hoboy.vegasvil.org>
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

> +static int bcm_ptp_settime_locked(struct bcm_ptp_private *priv,
> +				  const struct timespec64 *ts)
> +{
> +	struct phy_device *phydev = priv->phydev;
> +	u16 ctrl;
> +
> +	/* set up time code */
> +	bcm_phy_write_exp(phydev, TIME_CODE_0, ts->tv_nsec);
> +	bcm_phy_write_exp(phydev, TIME_CODE_1, ts->tv_nsec >> 16);
> +	bcm_phy_write_exp(phydev, TIME_CODE_2, ts->tv_sec);
> +	bcm_phy_write_exp(phydev, TIME_CODE_3, ts->tv_sec >> 16);
> +	bcm_phy_write_exp(phydev, TIME_CODE_4, ts->tv_sec >> 32);
> +
> +	/* zero out NCO counter */
> +	bcm_phy_write_exp(phydev, NCO_TIME_0, 0);
> +	bcm_phy_write_exp(phydev, NCO_TIME_1, 0);
> +	bcm_phy_write_exp(phydev, NCO_TIME_2_CTRL, 0);

You are setting the 48 bit counter to zero.

But Lasse's version does this:

	// Assign original time codes (48 bit)
	local_time_codes[2] = 0x4000;
	local_time_codes[1] = (u16)(ts->tv_nsec >> 20);
	local_time_codes[0] = (u16)(ts->tv_nsec >> 4);

	...

	// Write Local Time Code Register
	bcm_phy_write_exp(phydev, NSE_DPPL_NCO_2_0_REG, local_time_codes[0]);
	bcm_phy_write_exp(phydev, NSE_DPPL_NCO_2_1_REG, local_time_codes[1]);
	bcm_phy_write_exp(phydev, NSE_DPPL_NCO_2_2_REG, local_time_codes[2]);

My understanding is that the PPS output function uses the 48 bit
counter, and so it ought to be set to a non-zero value.

In any case, it would be nice to have the 80/48 bit register usage
clearly explained.

> +	/* set up load on next frame sync */
> +	bcm_phy_write_exp(phydev, SHADOW_LOAD, TIME_CODE_LOAD | NCO_TIME_LOAD);
> +
> +	ctrl = priv->nse_ctrl;
> +	return bcm_ptp_framesync(phydev, NULL, ctrl | NSE_INIT);
> +}

Thanks,
Richard
