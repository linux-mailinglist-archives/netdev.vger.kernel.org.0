Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5C5640C1B
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 18:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbiLBRY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 12:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233863AbiLBRYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 12:24:45 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C73218B3;
        Fri,  2 Dec 2022 09:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zUXVGsGMh+J8NDrj8u+PCst2Y4XAJpMNDS89Vq82I14=; b=uT02KzrxkLym6ZdxehkGwU99ce
        FTzqPsyzeLJUnwoA9pTh0pmGXBhSgZxkMdOt9P+9QtUiHcI7qf/8GNWYBtzXvlC9C/PCTed8n7Cch
        qFVIouY6JD+QqX75RcFHcvw/1XkYYQcKL2Nclt5slBZPKBAcgMUjv8i9isSUxpFZ0REgB5SiMURvA
        9bOCE6lhuq9aAtis/mFn5ZjzGkAw0H/DBSgtbkcwlo+6lzGLp9BBswUmHUOuDQjKZg6TiI9RhpXId
        zIE6hfzdrvPWI2hb1XlfO027jq+3b8WNCNnG2MvPdtqh2qn3Anw037zMQ9goTvFuhOfd0I+2ZWGGy
        t+NKcXsw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35532)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p19lv-0004O3-JT; Fri, 02 Dec 2022 17:24:23 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p19lq-0004ZQ-L6; Fri, 02 Dec 2022 17:24:18 +0000
Date:   Fri, 2 Dec 2022 17:24:18 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Goh, Wei Sheng" <wei.sheng.goh@intel.com>
Cc:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Ahmad Tarmizi, Noor Azura" <noor.azura.ahmad.tarmizi@intel.com>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>
Subject: Re: [PATCH net v4] net: stmmac: Set MAC's flow control register to
 reflect current settings
Message-ID: <Y4o0wglBDaP5+w49@shell.armlinux.org.uk>
References: <20221123105110.23617-1-wei.sheng.goh@intel.com>
 <20221125160135.83994-1-alexandr.lobakin@intel.com>
 <DM8PR11MB55909F0270753517565B12A9A3139@DM8PR11MB5590.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB55909F0270753517565B12A9A3139@DM8PR11MB5590.namprd11.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 06:06:11AM +0000, Goh, Wei Sheng wrote:
> Hi,
> 
> > -----Original Message-----
> > From: Lobakin, Alexandr <alexandr.lobakin@intel.com>
> > Any particular reason why you completely ignored by review comments to the
> > v3[0]? I'd like to see them fixed or at least replied.
> > 
> > [0] https://lore.kernel.org/netdev/20221123180947.488302-1-
> > alexandr.lobakin@intel.com
> > 
> > Thanks,
> > Olek
> 
> Due to v4 is being accepted. Therefore I will submit a new patch to address your review comments.
> Thanks and appreciate your effort for reviewing my patch.

And on that very same subject, why did you ignore my review comments on
v2?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
