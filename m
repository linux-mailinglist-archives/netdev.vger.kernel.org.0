Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B42C55FDAB
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 12:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiF2Ko6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 06:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiF2Ko6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 06:44:58 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE813E0C6;
        Wed, 29 Jun 2022 03:44:57 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id fw3so4067092ejc.10;
        Wed, 29 Jun 2022 03:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=kOaVpaz5661w2bixlQiYEfULRrUSFVOS6Ar20pgYWdM=;
        b=LF2lslnh++0WUUFSJgCf7GvK+7VGZjFnE9ZBbYiMfeRwO2yaf9Ln/SJBTKjRsgHGjc
         ynpjUtRsZ1U+KbtMClec0oNoSnSzavFKBv8njhon7gRuhr3D9yqZx+M0GyZBrZ509Qw4
         +mAKJE7HVZDa3sxZJcmTWL2hEm87MW+sDgJZPFJm6b/JWqG+Jgi45KQCc1t+/H5jK2W+
         fRUCYvZLfdWcmZ/OqgdqLjsS7Ts50BTbwOuUcWRGWj8jTXAfAA6UUa8uG14kqK44fCdx
         nOKfMf8WkJf2JJUqV6PRX94klpxmWXkgKjnuYXfHFkSZZELKHNI3wP3heKqRmRkRJF8u
         CqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=kOaVpaz5661w2bixlQiYEfULRrUSFVOS6Ar20pgYWdM=;
        b=vnh9iLQT8m7g5P3mfSE/TOSiBHoYP105H3AnGmOPr1xeQyE6R34exqOqL9AcigGJX3
         sOrechWxIBXIxmYwQj7U6D8jGA2RqWdF6dhELa0/tpsZFpgief3OmfuOZF+rg+l09mjx
         mdRZjykMO4uj1qjJUAWZ5vsJTQXm8JsDQtQeoNPjCd0b1E4bL/kn59/1SG3WAX+AnJqB
         A4nGBkm9JeZRFUB9rXOybONaZRYjwTTiETnFgcRZVV1Q+/XbDFGFDIn3QoFhU7JcNcla
         +VlwDCQt2deeJbnPVCDB+tQoKAzqENstEV9uuOwMG9XBg8qXI+X73ofdvW0C51iCG5yg
         JD7Q==
X-Gm-Message-State: AJIora8m2kzTdV2UovM8tZbzxvBPYX46yFYYT8XvzaEeFsUksG5vHG8E
        KVcP9GF7HQE4xUSBdFSL7Bs=
X-Google-Smtp-Source: AGRyM1sEQsEwoJqoLD3KZMvpu1kGdNVgPe7HSW37VlXIh+dBpCD8gQzpF8VkmufZxyX5eF3MYN2amQ==
X-Received: by 2002:a17:907:c14:b0:726:9118:3326 with SMTP id ga20-20020a1709070c1400b0072691183326mr2749834ejc.68.1656499495587;
        Wed, 29 Jun 2022 03:44:55 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id v10-20020a1709063bca00b00706e8ac43b8sm7560722ejf.199.2022.06.29.03.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 03:44:54 -0700 (PDT)
Message-ID: <62bc2d26.1c69fb81.8efff.df8d@mx.google.com>
X-Google-Original-Message-ID: <YrwtJVZZJ6QvaXEr@Ansuel-xps.>
Date:   Wed, 29 Jun 2022 12:44:53 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH RFC 2/5] net: ethernet: stmicro: stmmac: first
 disable all queues in release
References: <20220628013342.13581-1-ansuelsmth@gmail.com>
 <20220628013342.13581-3-ansuelsmth@gmail.com>
 <20220628205435.44b0c78c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628205435.44b0c78c@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 08:54:35PM -0700, Jakub Kicinski wrote:
> On Tue, 28 Jun 2022 03:33:39 +0200 Christian Marangi wrote:
> > +	stmmac_disable_all_queues(priv);
> > +
> > +	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
> > +		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
> 
> IIRC this hrtimer is to check for completions. Canceling it before
> netif_tx_disable() looks odd, presumably until the queues are stopped
> the timer can get scheduled again, no?
> 

My concern is that at the time hrtimer_cancel is called there may be
some packet that still has to be processed and this cause kernel panic
as stmmac_release free the descriptor (and tx_clean try to free garbage
pointer)

Bu honestly I put the hrtimer_cancel up to be extra safe, the main
problem here was disabling napi polling after tx_disable that I think
was wrong from the start.

> >  	netif_tx_disable(dev);
> >  
> >  	if (device_may_wakeup(priv->device))
> > @@ -3764,11 +3769,6 @@ static int stmmac_release(struct net_device *dev)
> >  	phylink_stop(priv->phylink);
> >  	phylink_disconnect_phy(priv->phylink);
> >  
> > -	stmmac_disable_all_queues(priv);
> > -
> > -	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
> > -		hrtimer_cancel(&priv->tx_queue[chan].txtimer);

-- 
	Ansuel
