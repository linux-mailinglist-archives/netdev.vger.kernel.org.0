Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A22A644481
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbiLFN1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbiLFN1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:27:47 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33926AE68;
        Tue,  6 Dec 2022 05:27:42 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id x22so6117314ejs.11;
        Tue, 06 Dec 2022 05:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8gGm5AvWlpFGL9MI7cu+T1k82OabJfNpmbCFTAalHdc=;
        b=RadXzTZ7omYsfiEgzDAl49cDFWa7za/xIUbGvXGFuM9rVCKqKhRLqm1aLbayIK9c8h
         LB2CwJ6t8vepNuYaKeOloYMVR8J6g+yP1Rnwjib++yuT2hw5EbgmqwC794+eGvQqSK9p
         5uy7ZKcOvH8f36QcYrKz/jVxRukIR24Vl5ir4C/CUjFvPMR8h29rQ13oVVsF5a/YqLLP
         RDf22Vh0NNqoJHvlcQyoUzQi57+vL0BvkGdrqt9PYVsorCAK9LCxJdewaUGsLjT47E4W
         394D7V2BgOmpxMv7EOYaiwta8smfzTZaKnbwC8PgGe8XkI5fbhgyF8CWKyD+pZm2aBNS
         H10g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8gGm5AvWlpFGL9MI7cu+T1k82OabJfNpmbCFTAalHdc=;
        b=ilBYkYtdeIx+MFnfgbWiY9/b7/hw49gQop7TAp1JmYtCZ5PF8QV3fJrae2IJQs0HqC
         ZTLCWqY6GFHvVz1wVHMSnuJOypDTIaoeAE5qvKhKqBlovzkhv4lDEAKtmDCNxy8PIVa/
         hRaHUDX1HKPtBTgNCpgjfXYVllXmuByMiRxaghvXL/mQLIrJIM1vkLHZGf73XylWHOom
         H7oo+IfQEs5HJG1bsCKO0qO0tUmsLWnsNAs8WTMcU0OdrsXUGMFCzPtCeLORf7Hem+rI
         ACVyaGtEDFKHJ3alOoVUcETc9P+/uS/IZkafontYxlf7Ofq0lOXiTKZFUklHVLT21Ff8
         seBA==
X-Gm-Message-State: ANoB5pmGUw+8MwNk1pf0JZ4viLnsRiXIVmPGh4neEcIqp+ZoqIJrSZUF
        33c3GweWCDySjrlFVb2J6nE=
X-Google-Smtp-Source: AA0mqf4MUqc7enU8xV43/Jc/1OKvAAjNXgI7lJ2oWUsp0NI/WMSCfEaKw0eOXLy/TBpDMLX5Q4ehLg==
X-Received: by 2002:a17:906:48c9:b0:7c0:eb33:e7c2 with SMTP id d9-20020a17090648c900b007c0eb33e7c2mr9196428ejt.666.1670333260625;
        Tue, 06 Dec 2022 05:27:40 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id d36-20020a056402402400b004585eba4baesm975704eda.80.2022.12.06.05.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 05:27:40 -0800 (PST)
Date:   Tue, 6 Dec 2022 14:27:50 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 0/2] ethtool: add PLCA RS support
Message-ID: <Y49DVmIp7CpdQRfe@gvm01>
References: <cover.1670121214.git.piergiorgio.beruto@gmail.com>
 <20221205180527.7cad354c@kernel.org>
 <20221205201152.4577d15d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205201152.4577d15d@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 08:11:52PM -0800, Jakub Kicinski wrote:
> On Mon, 5 Dec 2022 18:05:27 -0800 Jakub Kicinski wrote:
> > On Sun, 4 Dec 2022 03:37:57 +0100 Piergiorgio Beruto wrote:
> > > This patchset is related to the proposed "add PLCA RS support and onsemi
> > > NCN26000" patchset on the kernel. It adds userland support for
> > > getting/setting the configuration of the Physical Layer Collision
> > > Avoidance (PLCA) Reconciliation Sublayer (RS) defined in the IEEE 802.3
> > > specifications, amended by IEEE802.3cg-2019.  
> > 
> > nit: for the user space patches use the tool name in the subject tag
> > [PATCH ethtool-next], I bet quite a few people looked at your set
> > expecting kernel changes ;)
> 
> ... which you already figured out / was told. Is a very bad day 
> for my ability to spot next postings of the same set it seems :S
Thanks Jakub, don't worry, I am still learning the process, so better
one more feedback than none!

BTW, I've just updated the patchset to include all the feedback I did
receiver so far. Hopefully this one is good :-)

Kind Regards,
Piergiorgio
