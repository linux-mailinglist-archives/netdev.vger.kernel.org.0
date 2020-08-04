Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1DE23C049
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 21:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgHDTy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 15:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHDTy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 15:54:28 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1222C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 12:54:27 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id d6so29954237ejr.5
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 12:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h0o37mqlvJHF7/2fY9yuDetnb6ERD/AxS8JKStsNeh0=;
        b=sQzud/XrtfyYlcoTRp3IJpETo3vQDolNmZiPxBrVIsumSAvZwGwqk+8w+BBM5yAWrV
         sL49K+EtFrT/DKNgNgzBBebm44MC9BVQGXugQwcd+f8l6wQSiY9sD+l1TkzMS6JwovDc
         aGlUpWni3CABLpVvXo+XfUlE1ZKYYJzb9xdaSMCu3/v/yoS7WhC26fYTS03O5HFymk+C
         WLIsAxUUg7hUJ1iAfK27AO2HxbkN8rjEnkW0lZCDppJK4oTJK4RuBQhSlXKinPPPeyRo
         l4BbCiItfeW6Z+PBIxZ4NjkoJK8OCXECQilsoYi86tlLt/bJ4IHQ/qX/54UKiarCHWMk
         IH0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h0o37mqlvJHF7/2fY9yuDetnb6ERD/AxS8JKStsNeh0=;
        b=MQuGmkyvP+yPi9ng8zAge2sw+Mm9LW+i7uQXvju+NRlM+uGqAShBeNpxS/LUFOs7hx
         XAs2b5TPM9bxdi3385dYEiHet75Ayt4bqL372pJC+KZRDB1QjMENPp5rrALncfsOhTSi
         ARlxbBDIbAP0snPx1K9RoXAtnNZwFfxB4lvvR4+EhIUpRRKkAysg5BCLb2JYEesicIMM
         vrekqi4O3hasty6QuLxprbAnlhuiOuYIUiYSGFc5M9Q5X8J05xWm1S40NkV5h/pVJQ1Q
         miN7GDgTDCrrwr3HBFju66CohSM7xuXVVVFXY5qoSaM74SSENR7OeHlryzxrigXJRxzM
         LAcw==
X-Gm-Message-State: AOAM531qDtpSEUyYqqrbPwITmvgScyOPnFDLFz9tq5iAAs7cAJ1PLhuq
        9d/PqameoOZr1nlfdlkC8ek=
X-Google-Smtp-Source: ABdhPJw0VHI3+w0v0z2w9EM6Qi5mMhmKAKGdPJgMlBWM+5PQJYhHeJ92nLsKE1ts7nryiQSouqt5GA==
X-Received: by 2002:a17:906:4c97:: with SMTP id q23mr10224086eju.11.1596570865315;
        Tue, 04 Aug 2020 12:54:25 -0700 (PDT)
Received: from skbuf ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id q21sm19028396ejr.75.2020.08.04.12.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 12:54:24 -0700 (PDT)
Date:   Tue, 4 Aug 2020 22:54:23 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
Message-ID: <20200804195423.ixeevhsviap535on@skbuf>
References: <ad09e947263c44c48a1d2c01bcb4d90a@BK99MAIL02.bk.local>
 <c531bf92-dd7e-0e69-8307-4c4f37cb2d02@gmail.com>
 <f8465c4b8db649e0bb5463482f9be96e@BK99MAIL02.bk.local>
 <b5ad26fe-e6c3-e771-fb10-77eecae219f6@gmail.com>
 <020a80686edc48d5810e1dbf884ae497@BK99MAIL02.bk.local>
 <800bbbe8-2c51-114c-691b-137fd96a6ccd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <800bbbe8-2c51-114c-691b-137fd96a6ccd@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 08:51:00AM -0700, Florian Fainelli wrote:
> "I looked into it deeper, the driver does rxvlan offloading."
> 
> Is this part of the driver upstream or are you using a vendor tree from
> Freescale which has that change included?
> 

Does it matter?
FWIW, mainline fec does declare NETIF_F_HW_VLAN_CTAG_RX:
https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/freescale/fec_main.c#L3317
and move it to the hwaccel area on RX:
https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/freescale/fec_main.c#L1513
