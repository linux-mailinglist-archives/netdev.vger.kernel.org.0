Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6DC24282E0
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 20:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhJJSNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 14:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbhJJSNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 14:13:09 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F79C061570;
        Sun, 10 Oct 2021 11:11:10 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id a25so42345890edx.8;
        Sun, 10 Oct 2021 11:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fanxlHZ76pCDHGWrLMR5M6HKF0ll1R6WwASnUds2kMg=;
        b=JzjQGzBT1/Xjs9dQxEEA5WH/MNWceIQG28swRCQmyj8Fs6Vc169VYaBqpTzuEMMdfV
         dRqgYpdsyrjAxVpgxC6wZIE7OErT+wAwyFclOj/f8yf3KboR0oeGKdVl1Ek+cIO8Sqlw
         mRZngYq2/HVNEY9U2lf5I6dgiBU+uVFBLO62LPS2hV1LpqJYI6y75EyRcZQ4r4zpoR36
         EpGTf6q+sL3/O4oyZmdYqN6EsRiOvC4NUgA6oJTSiPMpKI+5vGmJBhahvH9WBGMxQGbH
         QdTZlm6g345SriAW6/Ut7s7LJlLWRiQ5rcieZqKktKKtZKeSxCKuxDKQBAisMize+PHU
         R17Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fanxlHZ76pCDHGWrLMR5M6HKF0ll1R6WwASnUds2kMg=;
        b=Y6IVCMUrkgB6eGHc7X7UY9UakDfzR5mQlWraWxCZsU+CJHFlxTjELMCcmvR5R+oB+1
         Ci0/o0J36EbubJOqXGLBvRETGsjcDb6oEoTBclwcjg2V6eQBqImFPw1KQ1yDs1IPNFwb
         IF/+zXQoau9qe7sq8oelIMvQiDDwgziGNB3R4h2UNcnug4iqR9Mn+0BYMOpCXZ6vkz4M
         6F/r0yKXVraY/xPFyLd2l2FVny0+Hn9y6GcRn9Vu6dRvqGqhyI8CMlwHvbCHPZRDiTAP
         bQd9ofhw3IEI8qh+elj2B1PR6QqQb4QTIc+B1FelzVQoBaSRkDMt0/BOlpqbohmOYXAN
         zxlg==
X-Gm-Message-State: AOAM530C6nB6evq8z4EjLZ2jKE+5GVOsDSqSuFyQlauQI0POYLJxkBy9
        e7L3MIy8gMYBnz1d1FcGCHVKgiZ9OWg=
X-Google-Smtp-Source: ABdhPJyYSPrYSga1IapCtmB862IIsEggAQbpOr6UajRDeOcyocV8uaaFNxgMZXquq9t0Znf1Aa43dg==
X-Received: by 2002:a05:6402:1d55:: with SMTP id dz21mr22556065edb.164.1633889469177;
        Sun, 10 Oct 2021 11:11:09 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id d22sm2357037ejj.47.2021.10.10.11.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 11:11:08 -0700 (PDT)
Date:   Sun, 10 Oct 2021 21:11:07 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v4 06/13] net: dsa: qca8k: move rgmii delay
 detection to phylink mac_config
Message-ID: <20211010181107.4as42prroyitew3m@skbuf>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
 <20211010111556.30447-7-ansuelsmth@gmail.com>
 <20211010124732.fageoraoweqqfoew@skbuf>
 <YWLqh2X0lVwiDMCn@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWLqh2X0lVwiDMCn@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 10, 2021 at 03:28:39PM +0200, Ansuel Smith wrote:
> > I was actually going to say that since RGMII delays are runtime
> > invariants, you should move their entire programming to probe time, now
> > you move device tree parsing to runtime :-/
> >
>
> The main idea here was to move everything to mac config and scan the DT
> node of the current port that is being configured.

If you insist on doing static configuration in a phylink callback, sure,
the comment was mostly about not accessing directly this struct dsa_port
member. It might change in the future, and the less refactoring required,
the better.

> > > -{
> > > -	struct device_node *port_dn;
> > > -	phy_interface_t mode;
> > > -	struct dsa_port *dp;
> > > -	u32 val;
> > > -
> > > -	/* CPU port is already checked */
> > > -	dp = dsa_to_port(priv->ds, 0);
> > > -
> > > -	port_dn = dp->dn;
> > > -
> > > -	/* Check if port 0 is set to the correct type */
> > > -	of_get_phy_mode(port_dn, &mode);
> > > -	if (mode != PHY_INTERFACE_MODE_RGMII_ID &&
> > > -	    mode != PHY_INTERFACE_MODE_RGMII_RXID &&
> > > -	    mode != PHY_INTERFACE_MODE_RGMII_TXID) {
> > > -		return 0;
> > > -	}
> > > -
> > > -	switch (mode) {
> > > -	case PHY_INTERFACE_MODE_RGMII_ID:
> > > -	case PHY_INTERFACE_MODE_RGMII_RXID:
> >
> > Also, since you touch this area.
> > There have been tons of discussions on this topic, but I believe that
> > your interpretation of the RGMII delays is wrong.
> > Basically a MAC should not apply delays based on the phy-mode string (so
> > it should treat "rgmii" same as "rgmii-id"), but based on the value of
> > "rx-internal-delay-ps" and "tx-internal-delay-ps".
> > The phy-mode is for a PHY to use.
> >
>
> Ok so we can just drop the case and directly check for the
> internal-delay-ps presence?

Yes, but please consider existing device trees for this driver. I see
qcom-ipq8064-rb3011.dts and imx6dl-yapp4-common.dtsi, and neither use
explicit rx-internal-delay-ps or tx-internal-delay-ps properties. So
changing the driver to look at just those and ignore "rgmii-id" will
break those device trees, which is not pleasant. What would work is to
search first for *-internal-delay-ps, and then revert to determining the
delays based on the phy-mode, for compatibility.
