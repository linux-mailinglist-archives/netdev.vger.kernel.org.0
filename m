Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB49854E084
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 14:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359848AbiFPMEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 08:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377055AbiFPMEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 08:04:08 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1214A5F262;
        Thu, 16 Jun 2022 05:04:08 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id c21so1602868wrb.1;
        Thu, 16 Jun 2022 05:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=NvTotWv8XnzVZu+pHQebgM4bWsTTZKNeIdjOwDoju7E=;
        b=FW7I1cA/aAcawnoclOF3N/CI0+ENH8qb6obcOzoQ6ODb2/OGq0INjFy8zF8ZxnNa20
         XLceFXJ3I08a7I7hyt26nZjN+3I4pehoxfIVgpkM11DhEh3oef7rnCC5X0ile71OJtCN
         xaBtR2bmdVgf8LreqXb4Ahr+9eqK6QePgB1O6OxUudDYvuk7EZASerj/LCDO9nJJvLBb
         7Hju6O1R+SHO/mTFJ4/V3GxBq2l1IZzF6EDusy63YRAMNLbhyRLIpa4/yDWq9PuCnMa2
         AEvKYYTowKDUBPWQCc8VlqIyLVWBINn/5sxWbrFJssiHVtuC7/AW6NidGcJcuk1zLBnT
         /SXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=NvTotWv8XnzVZu+pHQebgM4bWsTTZKNeIdjOwDoju7E=;
        b=awlF6vR41aE2Rf5A4/ITvy/GAQ8G8HPoF7HFqDQOrgr5/YEF+OczLxt8PgD/uBfNIS
         Aqk4FMGYWBTz4Cu24S1CrsLfQVYMB2bdt21QGtbk7QXmJc5bbU4EGnYgu4J9jez1CoG8
         xAyLCYTcXptUo3G3Ju15UEsDiOOwdQwNdHwZOOyjF7ngXzP1qLo1XerwdTMumxjQsyvo
         2k7D7jkf3GXw1yzrXgwJjdRuls7CzKfkuxG7xKHbek+bgP0lvFL/eCUfiHsNzpev0zZx
         UIP+L/ekmTfIfEMjkcT4xtVeSQ2xzBfWfeGjgS7UK399iVEPy5okLg5zMIwueoc6wdOD
         uaGA==
X-Gm-Message-State: AJIora8wYlJ2UDgKHVIBRV7fi5LV19JmiCFWlfnVDqHn82TDnsQESq/Q
        QAiAS2xpVDnPZyOLCKvhp4M=
X-Google-Smtp-Source: AGRyM1vGe0hqTNQlFi19vRGu0VDlfq55drHnbDnjclViV5t5NFO8MwRfAtbD0ugYV3SFtgr/4mg+fw==
X-Received: by 2002:a5d:6a0e:0:b0:213:1f7f:e1cc with SMTP id m14-20020a5d6a0e000000b002131f7fe1ccmr4373123wru.31.1655381046289;
        Thu, 16 Jun 2022 05:04:06 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id f3-20020adff583000000b002100316b126sm1700890wro.6.2022.06.16.05.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 05:04:05 -0700 (PDT)
Message-ID: <62ab1c35.1c69fb81.9ea8e.2cb0@mx.google.com>
X-Google-Original-Message-ID: <YqscMzlPDIT0mbTQ@Ansuel-xps.>
Date:   Thu, 16 Jun 2022 14:04:03 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH] net: ethernet: stmicro: stmmac: permit MTU
 change with interface up
References: <20220614224141.23576-1-ansuelsmth@gmail.com>
 <20220615195507.52ee19df@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615195507.52ee19df@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 07:55:07PM -0700, Jakub Kicinski wrote:
> On Wed, 15 Jun 2022 00:41:41 +0200 Christian 'Ansuel' Marangi wrote:
> > +	if (netif_running(dev)) {
> > +		netdev_dbg(priv->dev, "restarting interface to change its MTU\n");
> > +		stmmac_release(dev);
> > +
> > +		stmmac_open(dev);
> > +		stmmac_set_filter(priv, priv->hw, dev);
> 
> What if stmmac_open() fails because the memory is low or is fragmented?
> 
> You'd need to invest more effort into this change and try to allocate
> all the resources before shutting the device down.

Well what I'm doing here is following what is done with other similar
function in stmmac. For example the reinit_queues and reinit_ringparam
doesn't do such check.

But ok you are right, will see a good solution to change stmmac_open to
preallocate the buffers.

-- 
	Ansuel
