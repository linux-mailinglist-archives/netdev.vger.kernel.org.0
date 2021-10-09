Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E0F427B12
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 17:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbhJIPDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 11:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbhJIPD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 11:03:29 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3861C061570;
        Sat,  9 Oct 2021 08:01:32 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id t16so25896107eds.9;
        Sat, 09 Oct 2021 08:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kI+qfmNu25vhf0KEHYlOsIc63fBz8V6mbn5iEi7uekM=;
        b=NVglp6g6BE7s6/uPPGdESPWKktWgrNRe3vauZF9j45RnrMrXgitQOYxNFj+7o9mKbi
         3blqGnZczkxCYTEyfBBembMnnjISSnHVbHfryHqUhNpdbNEKHubvmTTPSZme0Y7zRfKv
         HRl7t/hB3CR3WSarLvMkKnEYXj5a9T1s8hx4NbtZQBu8zEMCPUu7xNnaOUSxEa6zQRFc
         z6mUy7PTj41c4wxxRmxhEZOfNEl0BlTTH7oTTAcIBwi7GoFO7MXSd8GEhHd+NDVqlV9H
         idCBELnLqpZpFWu4pKLMkD/MrDLQQEgEpft8mnNq1QuIcwvnxIfsZfHRM7dIBnASk60L
         Ry5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kI+qfmNu25vhf0KEHYlOsIc63fBz8V6mbn5iEi7uekM=;
        b=iB1XfE9BtfsdlssNLuvOzFTQiqjMCnyqCjnX65Q2SBtYgKi1vTS0DWZrr15J2DQfwQ
         UZKvWzpu5Vs6i74GhyEDLnc1ap9fZne12NX3E0SmweiPBORr+YhAIxm4Xe9DPYfy+rpg
         kaefeLrYj8X1qp6TEGF3djdNqE/VMt0F3Qa9D73WOrQHSjoa1cfeEZRFh8z+Pg+PB+ip
         T6TrnglEiXbCUiDyF37TbNf2fDa7DqvWwR/gpcCHj0NOTGcfDf+LDPC10XuCxNhijajc
         oAi+nF6HSOqmp/rr91VSGepOjGpGmuewECpSL2LBwQiv7Pi8zCn/GAyNTvv4yqGG/K+N
         xwUw==
X-Gm-Message-State: AOAM5323apNpxiic5gC6o0v+tnBBpsJeb7NN7prIGHLRCcCVUsNUyp06
        3vKCvjNxDIBxJ3zg/Xw0xeY=
X-Google-Smtp-Source: ABdhPJxYIPd4uSW4KKziGMnsWylLsbrv87/0cy0dDX6nD5TQ3EeZoGCHJX87KhrUUkwgyjL691YSfw==
X-Received: by 2002:a17:906:4a09:: with SMTP id w9mr10612099eju.419.1633791691152;
        Sat, 09 Oct 2021 08:01:31 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id t20sm1066157ejc.105.2021.10.09.08.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 08:01:30 -0700 (PDT)
Date:   Sat, 9 Oct 2021 17:01:28 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net PATCH 1/2] drivers: net: phy: at803x: fix resume for
 QCA8327 phy
Message-ID: <YWGuyLJc24zhoSp9@Ansuel-xps.localdomain>
References: <20211008233426.1088-1-ansuelsmth@gmail.com>
 <20211008164750.4007f2d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YWDZPfWOe+C2abWz@Ansuel-xps.localdomain>
 <20211008171355.74ea6295@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YWDfXyuvmFYwywJW@Ansuel-xps.localdomain>
 <YWGuL+/E4xHdNsQD@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWGuL+/E4xHdNsQD@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 09, 2021 at 04:58:55PM +0200, Andrew Lunn wrote:
> > It's ok. We got all confused with the Fixes tag. Pushing stuff too
> > quickly... I should have notice they were not present in net and
> > reporting that. Sorry for the mess.
> 
> It would still be good to post those fixes separate from the rest of
> the series. I think the DT binding will need more discussion.
> 
>     Andrew

Considering the other phy changes are OK. Can I post the 4 phy patch
to net-next as an unique series? (so split qca8k and phy patches)

-- 
	Ansuel
