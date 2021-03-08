Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AF733155B
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 18:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhCHR4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 12:56:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbhCHR4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 12:56:49 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BE2C061760
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 09:56:49 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 16so6175898pfn.5
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 09:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EqoGlpC+7mcmjQ0PLZPTkqoc1U0k8KneLfUwlOYcIcE=;
        b=ebvg4AN6mIkN/4JrTKRJeIpdageU0AKMVFNImGGzgMsRkH5EmnuJKFUvjDDqxYITMl
         hd6S7vWaM37R+Tpfx9GBbFu8BaEMd6KLDKxto90PHthIksTqwZohDWm/QXrIxi3OgE19
         BYo+T9L4FVy5kz2iBdA//Iq6nT9ubesbOz4dbDGvuDF6xkcu+NjhEalpdo+YjtShDSPt
         QR/MI4tSTYUeCfvy0gaGj7MVEjYBPzWpdLan7ZbXJ2ZHphTRUgvHQ2isyso7ULXJOnhn
         l888uKT0FKakvOGBuZsQFEla30uWt7/iJyFV38PCR70bSFsAJv/BYecYUZAJsPiEuRcM
         VeVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EqoGlpC+7mcmjQ0PLZPTkqoc1U0k8KneLfUwlOYcIcE=;
        b=DIKIZ7El04o8YuSd1P6njsLXmx+SUROvNkB0iDd2b/NLpOvlUHFL/SnsEbLXx0dOgs
         1K/e+bfNWUP0s7zktfAcy2lpxTaMIZOmMhok3FkgVaXu0Qh2rutg/57WpITs2jF4tu/d
         Mlag1VSqw3pD96G3biUWFAwAQ7onohGY7WDDDS5N1XlEyRO4dvNevHGz70Aen/5sxYH1
         qh3KsMgX/YotMQnb3ID/f48yzVvw2FyopMJodPpWj3Y+qSNaleOVzaEOEUHA1Ytt0YTE
         lmfdh08FMd4qDE8w0p88rGPh1TyEcdv1oeZUSnwfAGgG1cqMNCSpx/G/ey64zi7oAd3a
         Z46w==
X-Gm-Message-State: AOAM532D7aQAutEfVnCKlYTF6vio+hfktwQgntlOhrU8d+TPkX5BgTA9
        p4CHnULmzz8/C9BbU/8m9eisvRxZQUQ=
X-Google-Smtp-Source: ABdhPJx2pbG9Yyfj7bUERp4CsXXwbaSv8i0ImgjfAOv+orKcnSXYrd/ijzHKzArIpve90hLhoRQhtA==
X-Received: by 2002:a05:6a00:1693:b029:1ec:b0af:d1d with SMTP id k19-20020a056a001693b02901ecb0af0d1dmr22034845pfc.42.1615226207935;
        Mon, 08 Mar 2021 09:56:47 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b9sm10288421pgn.42.2021.03.08.09.56.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 09:56:47 -0800 (PST)
Subject: Re: stmmac driver timeout issue
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <DB8PR04MB679570F30CC2E4FEAFE942C5E6979@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <8a996459-fc77-2e98-cc0c-91defffc7f29@gmail.com>
 <DB8PR04MB6795BB20842D377DF285BB5FE6939@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <49fedeb2-b25b-10d0-575f-f9808a537124@gmail.com>
Date:   Mon, 8 Mar 2021 09:56:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB6795BB20842D377DF285BB5FE6939@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/21 4:45 AM, Joakim Zhang wrote:
> 
> Hi Florian, Andrew,
> 
> Thanks for your help, after debug, It seems related to PHY(RTL8211FDI). It stop output RXC clock for dozens to hundreds milliseconds during auto-negotiation, and there is no such issue with AR8031.
> When do ifup/ifdown test or system suspend/resume test, it will suspend then resume phy which do power down and then change to normal operation.(switch from power to normal operation)
> 
> There is a note in RTL8211FDI datasheet:
> Note 2: When the RTL8211F(I)/RTL8211FD(I) is switched from power to normal operation, a software reset and restart auto-negotiation is performed, even if bits Reset(0.15) and Restart_AN(0.9) are not set by the users.
> 
> Form above note, it will trigger auto-negotiation when do ifup/ifdown test or system suspend/resume, so we will meet RXC clock is stop issue on RTL8211FDI. My question is that, Is this a normal behavior, all PHYs will perform this behavior? And Linux PHY frame work can handle this case, there is no config_init after resume, will the config be reset?

I do not have experience with Realtek PHYs however what you describe
does not sound completely far off from what Broadcom PHYs would do when
auto-power down is enabled and when the link is dropped either because
the PHY was powered down or auto-negotiation was restarted which then
leads to the RXC/TXC clocks being disabled.

For RGMII that connects to an actual PHY you can probably use the same
technique that Doug had implemented for GENET whereby you put it in
isolate mode and it maintains its RXC while you do the reset. The
problem is that this really only work for an RGMII connection and a PHY,
if you connect to a MAC you could create contention on the pins. I am
afraid there is no fool proof situation but maybe you can find a way to
configure the STMMAC so as to route another internal clock that it
generates as a valid RXC just for the time you need it?

With respect to your original problem, looks like it may be fixed with:

https://git.kernel.org/netdev/net/c/9a7b3950c7e1

or maybe this only works on the specific Intel platform?
-- 
Florian
