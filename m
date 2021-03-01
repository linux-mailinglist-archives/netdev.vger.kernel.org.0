Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD52D327F9C
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 14:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbhCANfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 08:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235819AbhCANfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 08:35:08 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D148BC061788
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 05:34:27 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id dx17so670569ejb.2
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 05:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TFCW00AVj8biu0KNVpBcjsjAdkVzVWzi4Dt6X4a3OIw=;
        b=QtnajKnsDPdzw59f4/A+ydhWYagBgpNj2vdBJHR4tImoSkdHoacCYewWKgWTwJb8L4
         b7AiJCqp3LTQ9qnaosG2WcJdja3tcMX0D4D/stnVxmGUqBKBv13yHxn4UV15ENvIabo0
         8g3eJuwrB4q3b2t7XDALsKYsNODcM61/mIM32j39NJWiq9xVZqOyeeib0796nGG9O3Eo
         JEM/Np8H+nf0ZPjSdNf18uaD1IA12YpoYFGodPnRB3qMe+OMGajXHyCdcGEZHYI33uz8
         gINRGVGOJXl/O6Dm1pAAFRYbBjdEsUJfcgqVqROK5+WQsJF7kVrNDF7tiBcKvsgC3qki
         sFwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TFCW00AVj8biu0KNVpBcjsjAdkVzVWzi4Dt6X4a3OIw=;
        b=ofdXGSsGbYYlrI0EpwiMcn0P3OXiIy72dFheXNsIh2EyMGKeCjl0PDJNkAjc77qoUx
         eKHTjhyb0uQqW/RbY4MkSLex29g94WHQfL1wyJykAMxrEECR7u1oh/N1LVYEE2bV5/qD
         SJA/EA4O96FPd/mw9JQOPOfL3X2RGkQoHZHoMROQYTXAG43L50AumITiwmkjaTPkWPLC
         7GBHUoxrUPLkhG2ReGpFTE8pQWTrR8q1ZtfAVwIKZSnBEi+kQBADF5WZC3u/f+toR3FU
         yI5wnthIJMtKkSCJ3CBnihZO8uqndm4/68HLRSV57mmEdetctFOu7/SpfTugRLrFQDrI
         TY+w==
X-Gm-Message-State: AOAM531k/b3gk3hrLeaPnVflIcBRGv/iH4fUSdjBZH+LTsu7rQHftx97
        UrRX/hnFa/bkcRASbCEYGtc=
X-Google-Smtp-Source: ABdhPJzwo/sJxZe2+hwVvZ2G/i58mykrWNYMSRAIYSXXajDzMlDbW/D1ltwzA35nYKt61yMcpj78EA==
X-Received: by 2002:a17:907:76ed:: with SMTP id kg13mr15202517ejc.99.1614605666599;
        Mon, 01 Mar 2021 05:34:26 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id bw22sm14272234ejb.78.2021.03.01.05.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 05:34:26 -0800 (PST)
Date:   Mon, 1 Mar 2021 15:34:25 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v3 net 8/8] net: enetc: keep RX ring consumer index in
 sync with hardware
Message-ID: <20210301133425.drijvbm542apzv6b@skbuf>
References: <20210301111818.2081582-1-olteanv@gmail.com>
 <20210301111818.2081582-9-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301111818.2081582-9-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 01:18:18PM +0200, Vladimir Oltean wrote:
> The simpler thing would be to put the write to the consumer index into
> enetc_refill_rx_ring directly, but there are issues with the MDIO
> locking: in the NAPI poll code we have the enetc_lock_mdio() taken from
> top-level and we use the unlocked enetc_wr_reg_hot, whereas in
> enetc_open, the enetc_lock_mdio() is not taken at the top level, but
> instead by each individual enetc_wr_reg, so we are forced to put an
> additional enetc_wr_reg in enetc_setup_rxbdr. Better organization of
> the code is left as a refactoring exercise.
> 
> Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Claudiu pointed out privately that this is exactly what was done prior
to commit fd5736bf9f23 ("enetc: Workaround for MDIO register access issue"),
and therefore, the driver used to work before that (I missed that during
my assessment). So my Fixes: tag is actually incorrect. I will send a
follow-up version where this is squashed with patch 7/8 and the Fixes:
tag is adjusted.
