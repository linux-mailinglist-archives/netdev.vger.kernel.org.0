Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FB42F15C5
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 14:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387634AbhAKNoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 08:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731796AbhAKNoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 08:44:34 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FC3C061786;
        Mon, 11 Jan 2021 05:43:53 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id jx16so24741983ejb.10;
        Mon, 11 Jan 2021 05:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TqQMMmVG//s097FZcK6S1d+MUdnJBT3N8IWJdlGCSdY=;
        b=vQ7xg/NMs8B/jW9COLAiIpNiEJ+21BdjvoLnazkLt9/lR13If2ikF5RZJksFN0Dkoo
         C0zqtI4JCm9GWfi/CnjsDhI23DQE22A6bgR9PF4vRW7MkpPcJj/AfIk/3yfLeBcsdnrl
         Yxa9K6+wwF493HZ7SArizr69FpCLfQl6lpgliMFGI+kKl21Gl8bYrR6g9FSUpBY5PsE3
         tGUj1wkuFyjj1ZdM3ORq7/uzV+J+9E46Sk41CqgvwrUGYV7JHTTfAzR2DYg1oKwxXg5l
         95cO6WK6GrEoNp+J3zEoxppuEPX80yVLWxK08AgEQL/vFBuUgkRl+BMTYNyireUNYVig
         F/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TqQMMmVG//s097FZcK6S1d+MUdnJBT3N8IWJdlGCSdY=;
        b=dA886S/8gKGJScICiiMhsQDVcDs7yXMRws7AodAdW6A34rnzYKHqBAPeMc1OnbSxIN
         /y8w0V5f23i2OV/eqi96ipfpildcKQjqrx3Cq44UmCADUdkDoqKE0NtUorPL1apoYAvm
         vPqeaSevdY1ZuV6hTcYqDB+7vgyxrf8Q05zOTo/lbaA1c0WkBODsuWRpwfBuLiGe/wQT
         s7ddCkFscOyvLccnb+6zvpKNR8kRrZrpw/aO0nB1Hl5j8hH+b3jyYHe+MfWtZ1FLcJQF
         04mBDeZ/vqP5H8ocYZezmzTmHxM01ihtQECiG9YxqpR4RXBs3WSCOCNiGz8LRQJ53aSK
         eamg==
X-Gm-Message-State: AOAM532/2G4h2sMoeaAjxhcE9Rq5fZ+Z0TQEVqv09bvUporakHisUWXT
        6rn/hdi8c5GxqC4ExXReOV0=
X-Google-Smtp-Source: ABdhPJxqhexf4kPL914wqbd3XhrF0WLk2Dmhk3wPJ0oFcVMccX9vwvzyZgV6p+0xwhhjVShAmlSr8g==
X-Received: by 2002:a17:906:7689:: with SMTP id o9mr5102315ejm.324.1610372632156;
        Mon, 11 Jan 2021 05:43:52 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t26sm7120228eji.22.2021.01.11.05.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 05:43:51 -0800 (PST)
Date:   Mon, 11 Jan 2021 15:43:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-gpio@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>, linux-leds@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH net-next 0/2] dsa: add MT7530 GPIO support
Message-ID: <20210111134349.vdhyebdllbaakukk@skbuf>
References: <20210111054428.3273-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111054428.3273-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 01:44:26PM +0800, DENG Qingfang wrote:
> MT7530's LED controller can be used as GPIO controller. Add support for
> it.
> 
> DENG Qingfang (2):
>   dt-bindings: net: dsa: add MT7530 GPIO controller binding
>   drivers: net: dsa: mt7530: MT7530 optional GPIO support
> 
>  .../devicetree/bindings/net/dsa/mt7530.txt    |  6 ++
>  drivers/net/dsa/mt7530.c                      | 96 +++++++++++++++++++
>  drivers/net/dsa/mt7530.h                      | 20 ++++
>  3 files changed, 122 insertions(+)
> 
> -- 
> 2.25.1

Adding GPIO and LED maintainers to also have a look.
https://patchwork.kernel.org/project/netdevbpf/cover/20210111054428.3273-1-dqfext@gmail.com/
