Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F4C2AE008
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 20:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731623AbgKJTqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 14:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgKJTqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 14:46:15 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA3DC0613D1;
        Tue, 10 Nov 2020 11:46:14 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id l5so7601569edq.11;
        Tue, 10 Nov 2020 11:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Anc9729w5bnLptmWcTI4n8UBjauKlWlA7UMK2xjRk50=;
        b=DuvV7Rs+wN1FvU3Pn5pyLf2jQSs82wtkitnDkGcss8Bt/6Gj0mpscIKfmSY/HGnZlJ
         Czr45WjgaYaaebexOE96wZXv8qJXJDduWaFP9nqfbmB7UtX2Yk8IpsmFI84e5TFdZiVh
         mMrF5HkWK837Vnq5H8MZE35a73HC33x6Ho7Mu1rUywfWRe5pcEontAJ2t0WEwRPK+YbG
         aROurtMQguwWNtsN+gLxb+u/hYG1BiZ2j3oe5ueABcLq37ShPfn4f8rl2gN0Ofe5ShC1
         bV5u/GeOpvxj5MVZJC0RcmQA9mlFuoaNHAOfTN5s5cxhZX58ITAk4KKAn1GnFr98BY9h
         dGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Anc9729w5bnLptmWcTI4n8UBjauKlWlA7UMK2xjRk50=;
        b=kAkd1YsGENBH6RiHY93Ax7pIsSKe8Q78poETLwXnQfMN8C1FBdcmTVGYkFQGtma47d
         4lW7kRb4fGIgm9uqrGnOlm0sIZSFBkLzCSMhWXQU8YjtGf8kpDWOGDFI4jma9ZAZbJSP
         Gm1Mgliamx96FSWiDaaVedcL8ijaSrUNIzS/+MXqyiQAJluN0ANbZA70et/NkHXnlZNL
         NrwO0WoqpROQuHjcVxwrCx+ZgGuUIMGoRRx+xLMUy/PEtyVUqdG3OHcrdWwCCTri1DOL
         FJHv52YPQgNGbjUvXv70GEJjrS6i4Gud8zzdVr7FgbDTL8HX7YxkvbFP1CWuEI3I9Utn
         iE6Q==
X-Gm-Message-State: AOAM530JXCrymKc1SPqjVAFe14FY2L2aFaVSpaUQA6i13OWwJ3nKC0lE
        f+6DzEsLbmYTP+O2qxM0DOY=
X-Google-Smtp-Source: ABdhPJxaXCK9tPL6iSrvixVmpwNOQPXq17WUqXwiVqZSbeIPlUpZgLtUmXJGUzWiDx/9U/RBKCGZiA==
X-Received: by 2002:a05:6402:1c8e:: with SMTP id cy14mr23612676edb.39.1605037573704;
        Tue, 10 Nov 2020 11:46:13 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id s21sm11619664edc.42.2020.11.10.11.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 11:46:13 -0800 (PST)
Date:   Tue, 10 Nov 2020 21:46:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: Re: [PATCH 03/10] ARM: dts: BCM5301X: Update Ethernet switch node
 name
Message-ID: <20201110194611.5a4fbsrkgtlbebjy@skbuf>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
 <20201110033113.31090-4-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110033113.31090-4-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 07:31:06PM -0800, Florian Fainelli wrote:
> Update the switch unit name from srab to ethernet-switch, allowing us to
> fix warnings such as:
> 
>   CHECK   arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dt.yaml
> arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dt.yaml:
> srab@18007000: $nodename:0: 'srab@18007000' does not match
> '^(ethernet-)?switch(@.*)?$'
>         From schema:
> Documentation/devicetree/bindings/net/dsa/b53.yaml
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

You're lucky that you don't have any firmware that fixes up DT
properties by path.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
