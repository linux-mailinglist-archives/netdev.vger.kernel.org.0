Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839B83EC696
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 03:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbhHOBNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 21:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhHOBNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 21:13:16 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF102C061764
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 18:12:46 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id b10so16766723eju.9
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 18:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ywGTwv/V2iNCJuwFU2HjnJTNB15/LsVs0BrMvewzsEA=;
        b=KjmCxn85dE4ojhpqcGJn9rmCCc3dEFGE8TqyLzdJzVFntOtB6W2V3bBp5tvaB98svq
         3F8NnPw3iGvLkOfvOXHUA2ioAzJ4uaUcWQkMhvcxwullS7naKqyiVVTUSg7TGWozc5Ow
         MY0SU075yFfj9peyVbg2H2J8oW0c8utE5WJhxAlsdfrtsUVApb9mgTrjL2+a0Gswv4cv
         wf/i01aGIUr32vKfNIh/TCGQHNNw3innoglxhU0OzplplsWJSe65PCuiBD0l8RLQGLqF
         Mh/y2IRAun1R8Jis9/WSaMU+NXA3le5LTAPHP5e3WPt3gGFuA/KboOM7wbXAKlccnIjT
         /2ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ywGTwv/V2iNCJuwFU2HjnJTNB15/LsVs0BrMvewzsEA=;
        b=lKJnwiou7F/sWMjBX6xsdbuuhACEg7kH2jqNfAH55T84fAfpX6dadtOmv5GGOFbs40
         fsXymYEQLmw0Nb0fCkDzVGvvF87EMt8jD/WshulVC7ItQXwebbAlfyVituV+nd/7ztis
         emk1RmVK1W5n3pGavGmof4u2td6azRIZt7hA/1y27vNmN2NfNGTsSE01ItxBiDlJouxi
         iKKRe9ovrAkyQ81CcvlpKO0MczSqKrmpY9aE13Nde1Holx4hfyEs5xq64zHkZW3qn5E5
         l0Z/Xxei1kVokcyTt1g37nWc0fzp6lG4XwSkE56lGZnc0sKmBZCuDllbS22ePqS/oiq4
         3LMw==
X-Gm-Message-State: AOAM530p2DxV15A4OUsF1hR+p6e0AqsRbemNWuXsZbbeZdgrZlxmGreQ
        sKvZyC+NxlwRirRWo+xm/Bo=
X-Google-Smtp-Source: ABdhPJyAbfSP9MP3dDL/D7uHcvFBQlU/J8W3vDA1l+yV5w90NUo5dus9vsCG44jacPAZnP/pMohhPg==
X-Received: by 2002:a17:906:a01:: with SMTP id w1mr9420283ejf.117.1628989964968;
        Sat, 14 Aug 2021 18:12:44 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id s24sm2825634edq.56.2021.08.14.18.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 18:12:44 -0700 (PDT)
Date:   Sun, 15 Aug 2021 04:12:43 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 2/2] net: mscc: ocelot: convert to phylink
Message-ID: <20210815011243.prsztuzllmgiflui@skbuf>
References: <20210815005622.1215653-1-vladimir.oltean@nxp.com>
 <20210815005622.1215653-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210815005622.1215653-3-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 15, 2021 at 03:56:22AM +0300, Vladimir Oltean wrote:
> -	switch (phydev->speed) {
> +	if (duplex == DUPLEX_FULL)
> +		mode |= DEV_MAC_MODE_CFG_FDX_ENA;
> +	/* Only full duplex supported for now */
> +	ocelot_port_writel(ocelot_port, DEV_MAC_MODE_CFG_FDX_ENA |
> +			   mode, DEV_MAC_MODE_CFG);

I forgot to add a change to the patch, we shouldn't unconditionally OR
with DEV_MAC_MODE_CFG_FDX_ENA like the old code did if we aren't in
DUPLEX_FULL mode.

Anyway I'll wait for the automatic build tests to finish and I'll resend
a v2 very quickly afterwards.
