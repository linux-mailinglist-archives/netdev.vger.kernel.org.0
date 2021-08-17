Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930A03EF5CB
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 00:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbhHQWkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 18:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhHQWko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 18:40:44 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A441C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 15:40:11 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id cq23so16428169edb.12
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 15:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ceu1+v6i//gRjIWTJ4KwKZyCWF5NLGXqIOduck4yuWU=;
        b=cYrIgGyDz+lcquuqZ1iDgu4lQKqv0Pq4gvdqqk3MoKYlswLB6Tywyz15gsIlnk9EnC
         dM4eWB7DkmmuWWCpJ2kyFf3ZNuzhtaC3sDuoa/XQscrFwKIg730lr4eOoRXy+vfKkQt1
         1+tC7bNsTSoVJVlKCypxgs/PrebMFCMcYQNg77bYHS30ZDHfDrDiIXKdMEm5ldZnK1kC
         DqvaNsL7G7OU01gxT6QIzEQDaXEr8EwyzMhcxg0M5hXXBcji4vU/mWIgklEq7qjImaMl
         KT/1ClEWLnT2NHZR9uCBaMKZCV5MuSjCMMM4Lg19ZaN2orlHA3SBkgypSCLsVWsf1b8T
         ixFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ceu1+v6i//gRjIWTJ4KwKZyCWF5NLGXqIOduck4yuWU=;
        b=gN9oIlavKOV9kAqvWDFe6z8sbHTTlpX0b0DhxQlSNJgrRHZZNKiXc1ICIuzkFFgowE
         aFkEWk0R0m0XtxlXOgn6gpoPlzaoZoglkpVroeq+qnlkSuvqnd3FStXJKIV1Ak6k1Rdy
         XfpyVhYFarZOwvhuObka7ymbT/9G87JrRj3nbZJnN9WwCPd7QGIJK8mRtpNFHoYDNqEv
         kD5RxHJw4+oh+GpnpzKjJ+OguNKFd9E978RNAszrG7EMxtXzB23E+XE7EF1TlpSgGVOn
         xOzSgUt+raBdjTz3Qqb9EkIe5S1GB2Uq4Rw597BcBPvvy9eL9PFXjkAxQdfWrzngPYBj
         CVKg==
X-Gm-Message-State: AOAM531UdhA9Wj7lqMmfbXiGDcUwuqZU5DmDIhCbO5vGjfXRF+6qzqnC
        kH7zm2SJrT2vEfKRq3B0oj0=
X-Google-Smtp-Source: ABdhPJy6Hgvovv4+Q3FHiFbq2bCFn6hkca1b2gSGU4bkWIxaAYUngHJ/bRhA5gBFrZhHdcL9dbZyTQ==
X-Received: by 2002:a05:6402:10d6:: with SMTP id p22mr6444215edu.168.1629240009718;
        Tue, 17 Aug 2021 15:40:09 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id v9sm1298906ejk.82.2021.08.17.15.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 15:40:09 -0700 (PDT)
Date:   Wed, 18 Aug 2021 01:40:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
Message-ID: <20210817224008.pzdomrjaw5ewmpdg@skbuf>
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
 <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk>
 <20210817223101.7wbdofi7xkeqa2cp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817223101.7wbdofi7xkeqa2cp@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 01:31:01AM +0300, Vladimir Oltean wrote:
> So it's a circular dependency? Switch cannot finish probing because it
> cannot connect to PHY, which cannot probe because switch has not
> finished probing, which....

The missing piece of the puzzle might be that MAC drivers can either
connect to the PHY at probe time, or at .ndo_open time. DSA chooses to
call phylink_of_phy_connect() inside dsa_port_phylink_register(), so at
probe time. Maybe this is a reason why it is a problem for some drivers
but not for others.
