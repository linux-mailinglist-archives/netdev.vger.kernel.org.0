Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867BF42A51E
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236591AbhJLNL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbhJLNL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:11:58 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517BDC061570;
        Tue, 12 Oct 2021 06:09:56 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id d3so53270369edp.3;
        Tue, 12 Oct 2021 06:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=YKueiV6JHnO2SWEg4ednq6nX+YbDshzzDq1vLvlG1cw=;
        b=SVZka6ezsMJnMKeWlb8qWlQJzKHOERJP+vQLsax2MT+mBK82kltqBKzjoo+0K/dfDN
         HRqMIXA74pQmlHINDCAHsxyHoACRFDl/WnH7r7DfppzY6yA12USg6fR1NR7tbxP6Tkwl
         Mntb7UF/C3I7cWETSTxQOQbxBnteHoLlkN4SgIRfK0XjS5FzJduAfLiuRvh5kRU1iwe5
         t8Asb7Djhmirt180RLLyOOkUkVOWGLLG5bj9WXQpJ4ulgmJtcr8+skoFYPfKBnHrDFQH
         K5XSfV5QGCHPT/Doxd+FRsHXNijBi4FWKBRs58TwXVnqHyvl3/nX8ObYVfte+yz0Iw9v
         Y4TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YKueiV6JHnO2SWEg4ednq6nX+YbDshzzDq1vLvlG1cw=;
        b=al+p5/skozzhggWh5ShDJRGbLUNn1hTgBk5HzayZHRxFUqtjOx+15FMarnwQ/R3RzV
         1bFT0QG7+bNjJ2loBeZk4NhswSCDVP0ZLuT49hnQTCFeAgsV0ESt9ma9JDCyRM5gsdmm
         73enaP33mgZrOfi6wCHFYlM2gyYVahM5cvRh7H9IabbCH2pDJdZoTM5Qol46kd3eywSU
         6bf4zjkI8i4bPOc3MYqo+iuZM+ney4NK3xIS3hqKvaCrVVJvLDDiMAYc/C6EWoPQdCCA
         jQZVdC13XfV4HmMQXb6GCALabkOys1+0TUN/fGblOdzHguBXyubA+x6gzOZmN8DoMzRC
         tnaA==
X-Gm-Message-State: AOAM53292HpMoZnYCnXs7phxgUAFdaEqj1eQZrv/rqNqu0RsHFIP2SuO
        am0iUIufoAv5LgB7yihwetM=
X-Google-Smtp-Source: ABdhPJzjqxBA2OJOfJfHdplJCe2+fTtUOt4o9kiCTXs2g+veaaqbTRtkdP0/5j/Ps6X9dpAu/N6GHQ==
X-Received: by 2002:a05:6402:5113:: with SMTP id m19mr49885819edd.231.1634044192626;
        Tue, 12 Oct 2021 06:09:52 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id m23sm4899248eja.6.2021.10.12.06.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 06:09:52 -0700 (PDT)
Date:   Tue, 12 Oct 2021 16:09:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/6] ether: add EtherType for proprietary
 Realtek protocols
Message-ID: <20211012130950.nlrqoa6qjtvzvfdh@skbuf>
References: <20211012123557.3547280-1-alvin@pqrs.dk>
 <20211012123557.3547280-2-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211012123557.3547280-2-alvin@pqrs.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 02:35:50PM +0200, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Add a new EtherType ETH_P_REALTEK to the if_ether.h uapi header. The
> EtherType 0x8899 is used in a number of different protocols from Realtek
> Semiconductor Corp [1], so no general assumptions should be made when
> trying to decode such packets. Observed protocols include:
> 
>   0x1 - Realtek Remote Control protocol [2]
>   0x2 - Echo protocol [2]
>   0x3 - Loop detection protocol [2]
>   0x4 - RTL8365MB 4- and 8-byte switch CPU tag protocols [3]
>   0x9 - RTL8306 switch CPU tag protocol [4]
>   0xA - RTL8366RB switch CPU tag protocol [4]
> 
> [1] https://lore.kernel.org/netdev/CACRpkdYQthFgjwVzHyK3DeYUOdcYyWmdjDPG=Rf9B3VrJ12Rzg@mail.gmail.com/
> [2] https://www.wireshark.org/lists/ethereal-dev/200409/msg00090.html
> [3] https://lore.kernel.org/netdev/20210822193145.1312668-4-alvin@pqrs.dk/
> [4] https://lore.kernel.org/netdev/20200708122537.1341307-2-linus.walleij@linaro.org/
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
