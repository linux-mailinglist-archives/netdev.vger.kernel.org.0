Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018CE35C96F
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 17:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242683AbhDLPJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 11:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242650AbhDLPJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 11:09:06 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78061C061574;
        Mon, 12 Apr 2021 08:08:48 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id l76so9606478pga.6;
        Mon, 12 Apr 2021 08:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=7c5hbFDJuzW8IbaNLbCCwK5N29exubinPApJnJHDfR0=;
        b=ITLLe2DYMYPMeZVGTkOR3bOoGfykAoYj/bQy2kCNye+lBUJ4XaLgFBgV6f2/yXfdd7
         oFAVX0mQPwwymASavuDGXYqCdTXy47ZVJ/xlr9FH+qYoJ0kyvIHWC7SglHHDqrO50knq
         erVGGF9AYHklUu3pGvXTBSIB1dK/wjQF3ksPtYKoYc3UTmIXSSS5oIwQ8EYvT/rFv2Qw
         B9VpY9yz26CcM80Jg4PDwvFix5CNjmrPsjA+feH4HFT9yDVUE0HBsePWEfP2D1E6A0BC
         k9hnIqKMl0A/k7zYjwFsYK0ENESXfAjEks0+fqqa79661PTy2kc8s1fOcLNn/eQCZcR7
         09Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=7c5hbFDJuzW8IbaNLbCCwK5N29exubinPApJnJHDfR0=;
        b=hGpyIUrv/oH2nPeRq8EExspcIGJ2/gpDgR5extAG9pFMMdqkfeBP6ryoxCjpKN/uAX
         TUFnwvEcXqWkWJOBju+Qj6c+4cNOXX3em8W4A5XPkZI6pZtqIkKnu/Re/eqV/7qHAGE0
         XAa+XWbno47nsLJ9ncso0QlSk9KJQjIzQtlgUC+5MzDwlJPr7//AQfIepl8T+bOasgRA
         IGyb3HuXcFYlpIPhlAbkZdcAbvbTwbdUbhVlDKIozzoQ5s129Wbz73HoD+LZtQhcspFQ
         IstokF54F90OEuUch9ynJi0+PREDM1/Bp0njtNNoBJiDDSfuw7BCXD9NP/oW9HtCuIWJ
         FeNw==
X-Gm-Message-State: AOAM532QQJoca1jA5OwRPt7LvgupfsAaG+uBOpi0WnMpDB5MTHMAske7
        suu6fwC7Nn4iLn6QAcalNBmF+2B+PsjW4+kX
X-Google-Smtp-Source: ABdhPJz7KRLv1g9bRdFHzT6lp7tQwKP2uj+NoPFEntDd1eukLWRlre8tS73iPaLZc+mPS/pqqEeSxQ==
X-Received: by 2002:aa7:91d1:0:b029:1fe:2a02:73b9 with SMTP id z17-20020aa791d10000b02901fe2a0273b9mr25310238pfa.2.1618240125830;
        Mon, 12 Apr 2021 08:08:45 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id k13sm8406233pji.14.2021.04.12.08.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 08:08:45 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC v4 net-next 1/4] net: phy: add MediaTek PHY driver
Date:   Mon, 12 Apr 2021 23:08:36 +0800
Message-Id: <20210412150836.929610-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210412070449.Horde.wg9CWXW8V9o0P-heKYtQpVh@www.vdorst.com>
References: <20210412034237.2473017-1-dqfext@gmail.com> <20210412034237.2473017-2-dqfext@gmail.com> <20210412070449.Horde.wg9CWXW8V9o0P-heKYtQpVh@www.vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 07:04:49AM +0000, René van Dorst wrote:
> Hi Qingfang,
> > +static void mtk_phy_config_init(struct phy_device *phydev)
> > +{
> > +	/* Disable EEE */
> > +	phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0);
> 
> For my EEE patch I changed this line to:
> 
> genphy_config_eee_advert(phydev);
> 
> So PHY EEE part is setup properly at boot, instead enable it manual via
> ethtool.
> This function also takes the DTS parameters "eee-broken-xxxx" in to account
> while
i> setting-up the PHY.

Thanks, I'm now testing with it.

> 
> > +
> > +	/* Enable HW auto downshift */
> > +	phy_modify_paged(phydev, MTK_PHY_PAGE_EXTENDED, 0x14, 0, BIT(4));
