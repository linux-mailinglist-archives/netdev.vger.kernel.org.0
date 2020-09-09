Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73292635A3
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbgIISLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIISLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:11:45 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD17C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:11:45 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 5so2659697pgl.4
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 11:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gJwt5AomGuDlztQxL55OiA13IPfYNYqh/+PoHj6GXh4=;
        b=JsGan9GGoY0bX/0moUnlLYvK3h655m2vMW0JrJLuxciXHrHZQf+Kx3Nni+G0g6/y14
         37t/6czfPabGXWFulKXzExZbWVul1868OG4GANORb5CqFr3qbxs1YuhuedXZ1ObTzj0N
         GhU7APOBMoHvi+m1uo7mTcuNjb8hbgua0icKSmJ0rPCyXx2+rdDj6Bw/yWi2mOX4WP2C
         iPQGrP4gjdfZC56iMd0kNO6eFJyQ1J6NTCXVlCCRaDG8P51EoX8z1a1LH0FKBAnizK//
         686RUQTS+Ze6kD/9io6ruJY2ncUGdB3jeElhCO5yeWbuzGtPx3J1pLJ5G/HR1fQ0XVoX
         U40A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gJwt5AomGuDlztQxL55OiA13IPfYNYqh/+PoHj6GXh4=;
        b=ta4YEWmfDbIdjkpN9MIQtw7/a6Qf17+1OZaJGAjcsEfD7FnymO/Rz7Dau7XA43nGCo
         kWHYB+lCT2XDqPoc2r/Bl+WTDg210rb/4NvwUqkTtBWLUHoCdl9pwekEfcVukfLqViNt
         SVwd9JyqsWrdqNylBvyErpn7nlrY9woep08M04beqAx7qIO09hMGbuqD3h4KGu/fJIje
         cCevQcDC+/91Hcsjdc8ULmDO8UzNE6ibsAMqghtbrcYSQpxO1gwM6lRyakvN9BT9FGus
         GNZPSPiqcVA0HgyAUtS1gWu6lJ4nFLO1wLCWz/nSj0sZECs+yexnwk0PIPweYN1hDbQR
         PRhA==
X-Gm-Message-State: AOAM532+F633arbdshYIZOrn6ZRp9cMC3OQpGpx95eE9OsERNG+jbBuv
        wCu2pdYSogx6iaqsFyzzm2sC6P6aQSE=
X-Google-Smtp-Source: ABdhPJyXhf9UBV1Gz/xL+a8qSf3UcpaSUXbj6dd1TGu7R1Bd8deT6eOKRKS5I2C670vjyqrIZFPdVw==
X-Received: by 2002:a62:7c82:0:b029:13c:1611:66b9 with SMTP id x124-20020a627c820000b029013c161166b9mr1808624pfc.4.1599675104483;
        Wed, 09 Sep 2020 11:11:44 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id g9sm3549935pfo.144.2020.09.09.11.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 11:11:43 -0700 (PDT)
Date:   Wed, 9 Sep 2020 11:11:41 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 5/6] net: mvpp2: ptp: add support for receive
 timestamping
Message-ID: <20200909181141.GC24551@hoboy>
References: <20200909162501.GB1551@shell.armlinux.org.uk>
 <E1kG2ux-0002zL-Su@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1kG2ux-0002zL-Su@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 05:25:55PM +0100, Russell King wrote:
> Add support for receive timestamping. When enabled, the hardware adds
> a timestamp into the receive queue descriptor for all received packets
> with no filtering. Hence, we can only support NONE or ALL receive
> filter modes.
> 
> The timestamp in the receive queue contains two bit sof seconds and
> the full nanosecond timestamp. This has to be merged with the remainder
> of the seconds from the TAI clock to arrive at a full timestamp before
> we can convert it to a ktime for the skb hardware timestamp field.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Acked-by: Richard Cochran <richardcochran@gmail.com>
