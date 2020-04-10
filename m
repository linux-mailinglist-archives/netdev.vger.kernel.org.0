Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40AD01A470E
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 15:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgDJNtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 09:49:13 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58022 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726092AbgDJNtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 09:49:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586526553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=49ipUzSe9X30v9tPRFdX12EssE4OU6GOQhoEiogwVg8=;
        b=EukGuBLnba6Oy1zik17IVmYr9fS6NDPl2FqQnolyJF+rUA7j2s79mCCkukXngtWMn9Nrt+
        dkygob/87S0tYu785kdFREbDVx5dUzz9xQ+sPrksFbWRNMCCon/W0LBxFTcvJQ4p81dVmC
        TziDegYSG/PRzKZc7yjHofC29Ugnry8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-I-DnnRB5NhWSHhwTxGNh1w-1; Fri, 10 Apr 2020 09:49:11 -0400
X-MC-Unique: I-DnnRB5NhWSHhwTxGNh1w-1
Received: by mail-ed1-f69.google.com with SMTP id bm26so2105925edb.17
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 06:49:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=49ipUzSe9X30v9tPRFdX12EssE4OU6GOQhoEiogwVg8=;
        b=M1WkEAwL9jeXpo/bBRj2Lw2I5it2Obxg/oOqUp/txfeHcUiylkeWFxN/8Unwz0/4BD
         knncWi+361t3WzTBD9jWHKBoGwMrD2uux0o9BNffv2H9rErjiXRK4cvizFRXjaPxPl5D
         mmFDb9gDdppDOWjmLq3E1PQXOw4xKDat5MyYvwX3l5sHXx4+2FzzCHf1qinpL2EtdPcZ
         KyLaX3keOQigeMb5pHzJuGrk8Tn30eDcAyN68yKGJYTqVqZN/Djf6tIhgURkKNJqP+dT
         zvKcTG5h8o/PzcoB4V+Tm7dAKp4754oqomKxM+kg5IJtnlyofcdJTLwwLhQNEx0w3YEg
         ZSdA==
X-Gm-Message-State: AGi0PuZ8wd73Ew1HQqUR2Fn9fo2gCuzWgu+SSQlOcOjy1RrpkdRMUrRI
        McvPzSTiGAUaF0ciGC+mGBvNtf1Zfo4RcI+F8p2Hx6vaLxDF5aMpA4oicSX6oyqX2SF4uu7T7FM
        fpCRSAI0d2QmnSridmXDwg3zo5vE/fF6L
X-Received: by 2002:a17:907:262a:: with SMTP id aq10mr3758793ejc.377.1586526550196;
        Fri, 10 Apr 2020 06:49:10 -0700 (PDT)
X-Google-Smtp-Source: APiQypIBuYfSlQ43XeNpiogMP3+6x1JRgbMoTtlVbJyQ2qZ3avPlPK0mR+O/cT2vjMbYA7o+3hImpyGORvTtP2kzqnc=
X-Received: by 2002:a17:907:262a:: with SMTP id aq10mr3758778ejc.377.1586526550013;
 Fri, 10 Apr 2020 06:49:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200303155347.GS25745@shell.armlinux.org.uk> <E1j99sC-00011f-22@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1j99sC-00011f-22@rmk-PC.armlinux.org.uk>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 10 Apr 2020 15:48:34 +0200
Message-ID: <CAGnkfhx+JkD6a_8ojU6tEL_vk6vtwQpxbwU9+beDepL4dxgLyQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] net: phy: marvell10g: place in powersave
 mode at probe
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Luka Perkov <luka.perkov@sartura.hr>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 3:24 PM Russell King <rmk+kernel@armlinux.org.uk> wrote:
>
> Place the 88x3310 into powersaving mode when probing, which saves 600mW
> per PHY. For both PHYs on the Macchiatobin double-shot, this saves
> about 10% of the board idle power.
>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Hi,

I have a Macchiatobin double shot, and my 10G ports stop working after
this change.
I reverted this commit on top of latest net-next and now the ports work again.

Bye,
-- 
Matteo Croce
per aspera ad upstream

