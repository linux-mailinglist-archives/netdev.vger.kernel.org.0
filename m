Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B124F2DF493
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 10:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgLTJIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 04:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbgLTJIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 04:08:38 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878C5C0613CF
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 01:07:58 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id d17so9326743ejy.9
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 01:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/DIvBKhgnt5Ly3+S8IYKgzsTzNYNuBFOXEam0Euc3U8=;
        b=i7icMjIef/QgVSpp+8Lz6c1txrG1SuK0VYZRHwjHMtm9iyv5TjGtXaJZJHCLV8YULn
         ZWhnGFh7UpC0PG45+nm3MxpmUa31XqQlk2qRfmRrWorzufxKsMfwtis+G8/TCZprAjDL
         H84fbXJkH33QiMBaclrTgngEOncCyp85c+b0+gqA/MIFPJQbsqoatIldoIArMjZC9Zlp
         rGiO9wxJ3N6le3LF1+01NvGenoSOwV5Wi6n7pTiCpodmrkDTwWhbt5xjypydbxkv0O50
         HOhKzKf1+oHnf9a8zMuHXdSvx8DhPFP21pdAiy/31AdZh7DUlxkGakKJIOImMnrMn1Vy
         DEPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/DIvBKhgnt5Ly3+S8IYKgzsTzNYNuBFOXEam0Euc3U8=;
        b=AuCracj2gxb6nQjw9S00VOlURExLazLirA5pEEfTUjW1L0ab0jPh+IQVy+1J3TTNqB
         ecUa4hUciqlTqs2vRuSqbCF8gbeXxnIi++nLtiAlgmz13O83Wi6V59ewloFKFrQZL1jo
         6iYWhI3Gmd1/Wpk9zNPPM/sSmlspZ1F2Hfhb1lj6a3vFweyQg3BBryVQT3CG+3xyd8Fp
         kLvzF86Whw3uiTaHX8FTxh3s+EVU8ZRAEBbevRpcnYYNJMML9ojOzNJq16pLVcGpnHGZ
         4t018nRJ7uj1dE8G5kc8/Mx6QZFFAs3xF7GnAjYdOU3G6Hnq13NjUzF/pxIe+G4+Rg8+
         Wq8Q==
X-Gm-Message-State: AOAM533+ETKMb3rz1oFzlT7NnVcelhTme8pYBnCPY0/SpYabImdwgyYR
        3fX1N6WuAUFrsrVVOOOQOpo=
X-Google-Smtp-Source: ABdhPJxibYJYYAnPASg1TTu1ArW8y5xpfLQ/rPDUAcFK3hQJlEihbU3mYcnQEMxaqzEGE0oLTsvl7Q==
X-Received: by 2002:a17:906:4d8d:: with SMTP id s13mr11120229eju.305.1608455277160;
        Sun, 20 Dec 2020 01:07:57 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id hb18sm7641896ejb.86.2020.12.20.01.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 01:07:56 -0800 (PST)
Date:   Sun, 20 Dec 2020 11:07:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Ungerer <gerg@kernel.org>,
        Rene van Dorst <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: rename MT7621 compatible
Message-ID: <20201220090755.2fuxts4mhsa4sbgm@skbuf>
References: <20201219162153.23126-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201219162153.23126-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 20, 2020 at 12:21:53AM +0800, DENG Qingfang wrote:
> MT7621 is a SoC, so using "mediatek,mt7621" as its compatible is ambiguous.
> Rename it to "mediatek,mt7621-gsw".
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---

I would say that you need to resolve the situation with the docs at
Documentation/devicetree/bindings/net/mediatek,mt7620-gsw.txt
and with the bindings at drivers/staging/mt7621-dts/mt7621.dtsi first
(or in the same series). And still then, it would be nice if you could
preserve compatibility with the existing bindings at least for a while.
