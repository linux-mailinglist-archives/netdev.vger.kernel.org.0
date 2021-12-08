Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0610246D913
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 17:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbhLHRDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 12:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbhLHRDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 12:03:14 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B56C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 08:59:41 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z5so10621115edd.3
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 08:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bC/65P1hLaWLe+G8+OogFBNcMLX1MFGUUNxCExUvl3s=;
        b=lSZuym+WTBFQhDwknqKZ+sJ1pzF6+T7VW7CIAayQ2UZVj8jGunK94aFIHzKHGeGyBM
         zUOWUKVAzPFw8heUqaQ/+GJxYcfUtRcdtdzd5S6CIva0MNGm8kHRIbV5qlMepdTFuXLo
         HddXW0WzxffuCxGknQ4Jjl/RzFbUlcjbDXh7UrCfbuapd6KAMfPh6fmAdUltO2Phj0OS
         DT71bujCCMcKhmxlgTHGu50DoMJ2bryc0EStjWBgtB4tS/8ecET67YzhsHBq7DHBBmzd
         2DzxpY1wmk/1IMLIMtm0i91Vw1At1pGoQn2Su1FAzGHKXm+FPZ9gCgbEWUp5EtAiST9H
         z35g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bC/65P1hLaWLe+G8+OogFBNcMLX1MFGUUNxCExUvl3s=;
        b=fwwx9Aywm656znZoF3jRAYIGZcKb4drhkK6AzQAP3J4QwjstrreftQvfOrOM3W4dG9
         rpNfqfvrIjvz+6FnzXI7a5ggk6ymVfOY3esqnTie3YiOADhr+XDWGOdUDWsCcuV2lxEo
         zD06Vd21q37y67HMNKNIakUmyEgzpGFS4q34xyMSbjeJxjwiECNOVtsl8t6FjcjwWfTK
         f8WZczPE29i6Nw6T5qyBHNy1l2QLvSqpRVc+xKe/OPq6nGu7HyKRBRKSKxj3fdaMFQAi
         HVg7G/NasVf33g7UJdvZUjY6IHFrvTiDLQK+RMxVDHphZlYaGSo+M/7OYS2+td9ZCV9H
         it0Q==
X-Gm-Message-State: AOAM532D0MMriiBwWhfIq7sOBl7ghvcbvUYmdOvZXYXi3mYrarVZjwXG
        V4prG+fEkz5+Pg98uIIoTaA=
X-Google-Smtp-Source: ABdhPJyvxs28/zRJWldmSwOlg34u3imRQGPJnKdFpXsT5buvp67quEI6UgbpclPv9I1xIfY67siLww==
X-Received: by 2002:a17:906:4fc4:: with SMTP id i4mr9250549ejw.81.1638982780578;
        Wed, 08 Dec 2021 08:59:40 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id gn26sm1806321ejc.14.2021.12.08.08.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 08:59:40 -0800 (PST)
Date:   Wed, 8 Dec 2021 18:59:38 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20211208165938.tbjhuyf6pvzqgn3t@skbuf>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
 <20211207190730.3076-2-holger.brunck@hitachienergy.com>
 <20211207202733.56a0cf15@thinkpad>
 <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
 <20211208162852.4d7361af@thinkpad>
 <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
 <20211208171720.6a297011@thinkpad>
 <20211208172104.75e32a6b@thinkpad>
 <20211208164131.fy2h652sgyvhm7jx@skbuf>
 <20211208175129.40aab780@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211208175129.40aab780@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 05:51:29PM +0100, Marek Behún wrote:
> > > Vladimir, can you send your thoughts about this proposal? We are trying
> > > to propose binding for defining serdes TX amplitude.
> >
> > I don't have any specific concern here. It sounds reasonable for
> > different data rates to require different transmitter configurations.
> > Having separate "serdes-tx-amplitude-millivolt" and "serdes-tx-amplitude-modes"
> > properties sounds okay, although I think a prefix with "-names" at the
> > end is more canonical ("pinctrl-names", "clock-names", "reg-names" etc),
> > so maybe "serdes-tx-amplitude-millivolt-names"?
> > Maybe we could name the first element "default", and just the others
> > would be named after a phy-mode. This way, if a specific TX amplitude is
> > found in the device tree for the currently operating PHY mode, it can be
> > used, otherwise the default (first) amplitude can be used.
>
> Yes, the pair
>   serdes-tx-amplitude-millivolt
>   serdes-tx-amplitude-millivolt-names
> is the best.
>
> If the second is not defined, the first should contain only one value,
> and that is used as default.
>
> If multiple values are defined, but "default" is not, the driver should
> set default value as the default value of the corresponding register.
>
> The only remaining question is this: I need to implement this also for
> comphy driver. In this case, the properties should be defined in the
> comphy node, not in the MAC node. But the comphy also supports PCIe,
> USB3 and SATA modes. We don't have strings for them. So this will need
> to be extended in the future.
>
> But for now this proposal seems most legit. I think the properties
> should be defined in common PHY bindings, and other bindings should
> refer to them via $ref.

I wouldn't $ref the tx-amplitude-millivolt-names from the phy-mode,
because (a) not all phy-mode values are valid (think of parallel interfaces
like rgmii) and (b) because sata, pcie, usb are also valid SERDES
protocols as you point out. With the risk of a bit of duplication, I
think I'd keep the SERDES protocol names a separate thing for the YAML
validator.
