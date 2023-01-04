Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B539A65D537
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 15:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239509AbjADON2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 09:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239636AbjADOMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 09:12:39 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6493C1D0C6;
        Wed,  4 Jan 2023 06:12:38 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ud5so82977598ejc.4;
        Wed, 04 Jan 2023 06:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tg9g76SwEQ03nnPlXSR+de3Y9ReWrRYeaDvRIoSCF7U=;
        b=LbqgVt1i/G/e5VGblt8eTNeGBoZhrKLBzcJQ54RevnYpe6ESzdpmgOdZQyTVfu0WwJ
         DzlydqkjwbtKy/NwYvCc1KXQxTAs6FFkMaFnoZaYEXS75lIl4g8xIEcuPDG1j3l2OSBk
         /fFAc/YOkVr5mSL+5kqVF6foWe7pUxOaLk/58DN8SM1ivOIt6PazWIHJjrPnsrAZa9o8
         ymUjcvI/7jU8KCCA5mLyOe+U/GnWnsSJfNWybQFypcSc/VJQmFHWgqjLmHXo2dIyQCIH
         TnbZ+2mMwm/RwwqhXlrz4s3yOOPPcJa5nx3NMiwjDQ8cJ7dKlqsYXc5js2UQ9fkYWeNt
         thnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tg9g76SwEQ03nnPlXSR+de3Y9ReWrRYeaDvRIoSCF7U=;
        b=Fd7pfvwo/mVIwRT6RkWngxdjP/jaCKGze/UgxZG0CpB7k+nm83gJ5+iaukizMx1UX1
         B2nAF4NqghSYV4gWAQPaKyJihK9ms/lkj6tKOsn1tQqWaikmJA6P0vxAQcjtRl0uGIi2
         DTg7iejV0ReDdc5gDRA4bysSEE+Ruu0VPLpOw76MVg2RFnRZwJVyILBGrV9OtnnCzWeG
         MHJ2v3Z6URXjc01KOo/epG+VIHiuTLf/mlDm05VlzLHT14VOG4L9uTAsAxdkD5y4IndL
         HJbM5ytBMLiJq862j+zv02yYnJ7URq3nPWi20tOlYgCD6Qz7WSvhugqdLD6vOe+Ia17T
         qi0w==
X-Gm-Message-State: AFqh2kqdZ5lRjd+lYoinhq2KQs8TBLW77RRimLpwFc95n81ladhcvbCF
        rVhDmV5wLZMWJwdBXSiZgwY=
X-Google-Smtp-Source: AMrXdXtXQ0ALq3KiEPUKTv21ShKFEupnZPx4oOAlgODEyOVWekZ+XWvHLHXJ8N2OrlzazchgGI4iPw==
X-Received: by 2002:a17:906:8e91:b0:7c1:5248:4f3a with SMTP id ru17-20020a1709068e9100b007c152484f3amr37459694ejc.56.1672841556990;
        Wed, 04 Jan 2023 06:12:36 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id t7-20020a1709066bc700b0081bfc79beaesm15199181ejs.75.2023.01.04.06.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 06:12:36 -0800 (PST)
Date:   Wed, 4 Jan 2023 15:12:44 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v7 net-next 2/5] drivers/net/phy: add the link modes for
 the 10BASE-T1S Ethernet PHY
Message-ID: <Y7WJXFx9Fz1oQiDY@gvm01>
References: <cover.1671234284.git.piergiorgio.beruto@gmail.com>
 <fb30ee5dae667a5dfb398171263be7edca6b6b87.1671234284.git.piergiorgio.beruto@gmail.com>
 <20221216204808.4299a21e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216204808.4299a21e@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 16, 2022 at 08:48:08PM -0800, Jakub Kicinski wrote:
> On Sat, 17 Dec 2022 01:48:33 +0100 Piergiorgio Beruto wrote:
> > +const int phy_basic_t1s_p2mp_features_array[2] = {
> > +	ETHTOOL_LINK_MODE_TP_BIT,
> > +	ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT,
> > +};
> > +EXPORT_SYMBOL_GPL(phy_basic_t1s_p2mp_features_array);
> 
> Should this be exported? It's not listed in the header.
I've added the export in phy.h

Thanks!
Piergiorgio
