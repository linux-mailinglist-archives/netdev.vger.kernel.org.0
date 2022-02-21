Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2754BE3D2
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378150AbiBUOmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 09:42:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378139AbiBUOmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 09:42:02 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA9A306
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 06:41:38 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id qx21so33754696ejb.13
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 06:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TyBJ8t54ycHk4LjKJh1x02J3LFAdK4h7Ol8QwnnR7cI=;
        b=TglZw4jZDF/Bnu5ZZ5QTZ8H1vrMMLGsDdUFvir6Ua2e/fjAghQmXftCeCqkPOTvHN0
         8rWoQd2sRO+XIS0lJAIi42xJNL8E8ljUlZw1fi3iPuyda5gUuBY8GbMz2pGNBmYQurl5
         EbLNGKAfrqIA72F3u+Uzec1mUy7qPai3lwb40KP8Gj8+1+sWXQ2MXGtyMmU3sX/YZST6
         VWb1Tu3qxEnqkkeqm+vMMyzSPi3JDxVzPkMRZVR70RPwJg8C7HM5RT0ODe7NFwhx8Uoz
         37xyz5R8xjL1pTo8wEqxspqY9BBtA6AUZMYbOVTqOwwU1s1sbLOOOvSist4yUa9/oaX1
         IabA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TyBJ8t54ycHk4LjKJh1x02J3LFAdK4h7Ol8QwnnR7cI=;
        b=TkoVmTJzOzVpi9haMS2iwmt0Uh/XKOQMNBt04YQ+aLDqrEzK5gN/Ds0nyprc1IOV9O
         FZVaPeTQC24OX5ijlLGduiLHFK+y0h9NvzmzW/kOVzU9GbCbUPaZGK5faYFBlEqZxjFK
         VHyem7bomG0YNHxFidb0F1ZSq0wUcIPw6uO85KLhtieOTmaPqBtJJ8/KOIVVJ3REDeFM
         /X+xmNGOMj+rJtjiUbsULHLi3hD3fzzMsq4d/jq14GhQ8EWKH+Yud0PCNpTvfOOYffao
         MFzKfP+yzp4QGCoRZ64Wi4z5H+XIP4FKTMEWepCtrY5pSE9Rgn0el1V1oU909QNCO/qH
         a6bg==
X-Gm-Message-State: AOAM531w0V/ulyC30cydTExpATkfdGZFJRFjJpr18+UM8Y/4HzhOzK7z
        lXVoYHpaLV29y6Os4lfPfwY=
X-Google-Smtp-Source: ABdhPJxMLKztRfVo44hiS7jNCcHPx/K2K6M/jpDZIKjiPR0xJdcMnQvG6roZW5prtVoSXpZyTCRmaA==
X-Received: by 2002:a17:907:2087:b0:6cf:421:ca5 with SMTP id pv7-20020a170907208700b006cf04210ca5mr16521115ejb.540.1645454497399;
        Mon, 21 Feb 2022 06:41:37 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id e27sm5391609ejm.18.2022.02.21.06.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 06:41:37 -0800 (PST)
Date:   Mon, 21 Feb 2022 16:41:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v2 1/6] net: dsa: add support for phylink
 mac_select_pcs()
Message-ID: <20220221144135.2ixdffawkc4kttad@skbuf>
References: <Yg6UHt2HAw7YTiwN@shell.armlinux.org.uk>
 <E1nKlY3-009aKs-Oo@rmk-PC.armlinux.org.uk>
 <20220219211241.beyajbwmuz7fg2bt@skbuf>
 <20220219212223.efd2mfxmdokvaosq@skbuf>
 <YhOT4WbZ1FHXDHIg@shell.armlinux.org.uk>
 <YhOeftlyzP0U9zR8@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhOeftlyzP0U9zR8@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 02:15:26PM +0000, Russell King (Oracle) wrote:
> Please try this patch, thanks:

Probing, bring the interface up, down, and testing with traffic over a
QSGMII port with a pre-March 2020 phylink_pcs works as before, thanks.
