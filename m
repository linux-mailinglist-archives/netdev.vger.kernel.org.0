Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5DC2F3DF6
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393785AbhALV7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393775AbhALV7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 16:59:08 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC9CC061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:58:27 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id w10so3149989edu.5
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=dFHOvrZvzu4T767u95NqXPaB/1B5vUyzVFhSf1ov3G8=;
        b=igQky6x4cpjN3PRlOMqzKHzsObQjcRVwnX58tjMJBcFOCTMbWFRa31TXNCp8mfZnBu
         P54G92sFObJI+ip1SYe2sOr5hhvEb3c4LYx3+NJqEwLmaDn5jJifdhMaWtw7yRKJXANC
         HykKzqpdyaqKC9KG2MLcYixeXjAYz7LYrkiIF2GoYXDCjuz1hK2ed/0WmLPXIphNy3yB
         +hvag2MHs7z0bxbYJlSwssOGlt51KhIlgmSi+69CQrwDekb21p2SuvVyH7YmBDur5Edu
         VQhkQ0SAs3dgnaZO6VrnKjTvdIIcJ5DU3swLa5a5P4qx3k1oYxbyWg6Ap2Um0mIE+kYh
         +qVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=dFHOvrZvzu4T767u95NqXPaB/1B5vUyzVFhSf1ov3G8=;
        b=Do0olUplSMGH9yswFV6PwRdCV94ffFaD1a9xRC8g5XFcD60hWl4Mg2Ze7/AGfBb9AB
         Qq6msQNoC9NKIRrvgTcVCb3sh/Zd1+f2sDzldgZnsgJc7F6gkns/KYPI9xJxzqSwPRzT
         OdGa2Xb9G3CKitDNPExfkQrcePjOAQmdvo3D+nVUHShqWHUjOeHqMiLEx/YWjmnD56BO
         i9StgWS7jeCNYtwNFYRsFmhKYDJLdNB/IjLGrz44uBxdNAz9SAmMv2hdPfuD/diQbjV3
         VKyK8Q0SdYJt9xko57cRZvKzeh614+8J3KmBBnNfB5A2Nb9uNr4CFysRq1UMDl47mgFQ
         EF6A==
X-Gm-Message-State: AOAM530JanHIaFHNMLtidWggoH2xUsRlXchJQM/914JZh8gUn0wu6Zme
        sKB4lxy1gKq8PtzGODfKavM=
X-Google-Smtp-Source: ABdhPJzeGKf/XMEG4qhcd9mi7FwSp23ixbqlJ8Kqpk9rz7k7/R5nmLVhGWtoyAOB1luPi+HcO3DBkw==
X-Received: by 2002:a50:fb1a:: with SMTP id d26mr962581edq.101.1610488706648;
        Tue, 12 Jan 2021 13:58:26 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z1sm2072497edm.89.2021.01.12.13.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 13:58:26 -0800 (PST)
Date:   Tue, 12 Jan 2021 23:58:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH net-next v14 5/6] net: dsa: mv88e6xxx: Add support for
 mv88e6393x family of Marvell
Message-ID: <20210112215824.zosvizu4w3mqmjsr@skbuf>
References: <20210111012156.27799-1-kabel@kernel.org>
 <20210111012156.27799-6-kabel@kernel.org>
 <20210112111139.hp56x5nzgadqlthw@skbuf>
 <20210112170226.3f2009bd@kernel.org>
 <20210112162909.GD1551@shell.armlinux.org.uk>
 <20210112190629.5a118385@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210112190629.5a118385@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 07:06:29PM +0100, Marek Behún wrote:
> On Tue, 12 Jan 2021 16:29:09 +0000
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> 
> > I'm seriously thinking about changing the phylink_validate() interface
> > such that the question of which link _modes_ are supported no longer
> > comes up with MAC drivers, but instead MAC drivers say what interface
> > modes, speeds for each interface mode, duplexes for each speed are
> > supported.
> 
> BTW this would also solve the situation where DSA needs to know which
> interface modes are supported on a particular port to know which modes
> we can try on SFP connected to a DSA port.

What do you mean here? What makes this specific to DSA?
