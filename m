Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C264BEA22
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiBUSFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:05:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiBUSCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:02:14 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2666457
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:53:42 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id r13so12178790ejd.5
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mXjjfm75vHst+1aYByanTQl2MuM3hLpxl8q3SG2OJAY=;
        b=YgKybXE00+oWW69fU5AbCh1k8tRxddQQ7NSgLz63paNe74nadrv9RA5ilD4iQzt72V
         J3tIBWgQHcNSVypx8CNLTGklRuMJs8XozGmIHyJkwUNqvGFvdI6kqpO8VwrShHxfKxOt
         r5xL54jlR6/5Cf037+p1oRxrERivxkI2af6nUF4eHDW0ZCT7lrRrFcde2T/bEDErL8DU
         2Wmg6umEjqN3qc7AvJ9Cpqm4PlWJfMWUlpl0Va7SepCw4X7gl005xBDMp8pBCcAnq+cN
         DcCvVg8o0MvDuNFJ2nXy/CuHTddhrC2T5G3vv5uq3+JOYZUCEFEtTaRfCguaBxCDt455
         ZbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mXjjfm75vHst+1aYByanTQl2MuM3hLpxl8q3SG2OJAY=;
        b=B5vZt5tQmMX1mt3GuL4aTawYXdx04rra0qq5OlBdBvnk5tKafKtsaJ2LG90Bvv336q
         b19GTiilNyoTGAM6ywgAxFRnv91sMkkezAx86UrAq5aFwH+pcC+50G+WJJ81DXCzzkux
         832rQfRbHCM2Tf+C0ExpO9Xy6o5fK+0N16OyRzq2cToV+m31yojOx2RDBNJtzRpSQPI3
         IzZJPrp36Lo0PlnY62tpKihxCssCPYFKla9jTpa83n2/T6D5ie/KX5EiYvwPvV2UY9z4
         BKEsLsKMpx9fe5fHISaLlaLYkoMjKq8iWhatVEPeC0Fyy8V9ORZ+F37a1RGCgbR9huW7
         l8+w==
X-Gm-Message-State: AOAM532do2v/GUx7ypN6fA81K7hGKvf/1W9F+1wLapHQPLpqbe6QeAaU
        yJBdCi5GOm81No1dcjyX5Z8=
X-Google-Smtp-Source: ABdhPJw6UcD+mkNt1ONx42aKUFDng++7wDeNiV6v4VE/naYlxh+YJTkh+uabPdG5uvkvjhNqJKWevQ==
X-Received: by 2002:a17:906:3a84:b0:6cd:e829:ca37 with SMTP id y4-20020a1709063a8400b006cde829ca37mr16879082ejd.83.1645466020576;
        Mon, 21 Feb 2022 09:53:40 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id a29sm3249291edm.54.2022.02.21.09.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 09:53:40 -0800 (PST)
Date:   Mon, 21 Feb 2022 19:53:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: phylink: fix DSA mac_select_pcs()
 introduction
Message-ID: <20220221175339.azdcj6t72wkrtvrb@skbuf>
References: <E1nMCD6-00A0wC-FG@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nMCD6-00A0wC-FG@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 05:10:52PM +0000, Russell King (Oracle) wrote:
> Vladimir Oltean reports that probing on DSA drivers that aren't yet
> populating supported_interfaces now fails. Fix this by allowing
> phylink to detect whether DSA actually provides an underlying
> mac_select_pcs() implementation.
> 
> Reported-by: Vladimir Oltean <olteanv@gmail.com>
> Fixes: bde018222c6b ("net: dsa: add support for phylink mac_select_pcs()")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

Tested-by: Vladimir Oltean <olteanv@gmail.com>

Thanks.
