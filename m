Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FED73F3291
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 19:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbhHTRzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 13:55:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32940 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234436AbhHTRzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 13:55:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Bdz/p/at4jlOjqhVxrG6hP3yPXVb/rT5dEj10L9Ee+E=; b=0Fvm3p2Fs6NGA5ydeGkRNTQkmG
        FGKIjMw/L6ihgBYXXkddCtIjac9WzJzzucYNuDJ4PSPhBGove59fCWuOVFEOzHtH4oXt35HZl50my
        BlPD0HVCd712Qmd3ltyXkc8h5UOwl21FKpKp5L6t9bWCwkVQJjhg/mbR9Z+JEHPeC9YA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mH8iw-001CPd-OX; Fri, 20 Aug 2021 19:54:34 +0200
Date:   Fri, 20 Aug 2021 19:54:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
Message-ID: <YR/sWodANPdthPyA@lunn.ch>
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
 <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk>
 <20210817223101.7wbdofi7xkeqa2cp@skbuf>
 <CAGETcx8T-ReJ_Gj-U+nxQyZPsv1v67DRBvpp9hS0fXgGRUQ17w@mail.gmail.com>
 <6b89a9e1-e92e-ca99-9fbd-1d98f6a7864b@bang-olufsen.dk>
 <CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com>
 <875f7448-8402-0c93-2a90-e1d83bb7586a@bang-olufsen.dk>
 <CAGETcx_M5pEtpYhuc-Fx6HvC_9KzZnPMYUH_YjcBb4pmq8-ghA@mail.gmail.com>
 <CAGETcx_+=TmMq9hP=95xferAmyA1ZCT3sMRLVnzJ9Or9OnDsDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_+=TmMq9hP=95xferAmyA1ZCT3sMRLVnzJ9Or9OnDsDA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 3. If dsa_register_switch() fails, we can't defer the probe (because
> it already succeeded). But I'm not sure if it's a likely error code.

That is not a safe assumption. The tagging driver can be a module, and
not be loaded yet. So we defer probing to allow it to load.

Ethernet switches can be a big graph of parts, not a nice tree of
parts.

    Andrew
