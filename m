Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2456479830
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 03:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhLRCey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 21:34:54 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:33400
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230032AbhLRCey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 21:34:54 -0500
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 303523FFD6
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 02:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639794893;
        bh=2qySw9dXGIHvbux8ulig99RQsrVQe8eIbNPCiuUKumY=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=lgoGUd8RKg1BOYn4KLcbGLsHAaHAkjG3eri84+7zhNxFElHPEBqyIUpDHaeCzyH/Q
         079dg4ZMLGHEb4MyeeQAmtaAie37+DkQPrrj+QfMYPhKNurMUVDx6CEQNg/Boy8/Bu
         OT3QpNCOTIdARGhZsdtBoFIi3m3sXr/pZW5N6Q9mY6fwbwEGiCzVACaec53w1wFY9v
         k9DyvGeLsSTsiS+kXSsn3pY2b+zqRQ8S8/4ed5iwYjbnL63PbpzG2WtPL7ZA9wKFvg
         SqztezXt380mEM8n8Dbhkr5rHTetVaZ8LSRu6iO+VNTtdB5qWHeDH2tYN7aiwv20Xn
         jgxD1tVtQzebg==
Received: by mail-pg1-f199.google.com with SMTP id k124-20020a632482000000b0033af17f2b57so2591418pgk.0
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 18:34:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=2qySw9dXGIHvbux8ulig99RQsrVQe8eIbNPCiuUKumY=;
        b=dnFdYeX6oSdpFb23BNU55p0CIqWxmG5daDigP76MNSJBY+a2T39mL7F6jPoSg+Fj+2
         3ue49/ZHVTo/mDk6zBwTySKavfzMID8wLgbKhtH0IGKEggVqoopsrTzmLh2QFhq8lBcQ
         z/8aPETtBc/1aR42pXWeL+0L3WLhZbK9PIt58dHSXXZZwhitJYtuCwOERwM2E3xQ/BiP
         I+ETXLHrYNbuRBacSnO7LVFRQkMvf16+j/Ls1S6QBuN7yWqNlRBoRngfAwwTYS7VJHbZ
         OEfAszW5Xn3SDt09cu/UUW9CtjgfBNyYMTpMANRPB2QuLoPhq8FiZezg/Hu4rHSl4kxH
         3nJA==
X-Gm-Message-State: AOAM533QrSA0liWTGA4t+ghJkRmts/1MDolqjvgQcLWqwc6QaX18O35b
        +j/iWwV0maZjhrsuDzNZqVbNPQzpE1MW5T0R885PWJzt5DXHXBu8ZhqEmcHK0b9iaxmKfKGoVhM
        FtNfvhe2BDdlADYzqk9RjS4fwpb8ISgnbew==
X-Received: by 2002:a17:902:c78a:b0:142:1b7a:930 with SMTP id w10-20020a170902c78a00b001421b7a0930mr6406317pla.8.1639794890531;
        Fri, 17 Dec 2021 18:34:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzhWU9tbhrkGKH3ARKSwHYhMuWfSnqGKoO0AtmaBB4e6QkQ3PunEuUzWC4cF2LPrtud/c/rfA==
X-Received: by 2002:a17:902:c78a:b0:142:1b7a:930 with SMTP id w10-20020a170902c78a00b001421b7a0930mr6406301pla.8.1639794890287;
        Fri, 17 Dec 2021 18:34:50 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id w7sm518320pfw.133.2021.12.17.18.34.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Dec 2021 18:34:49 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 7D0DF60DD1; Fri, 17 Dec 2021 18:34:49 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 7293BA0B22;
        Fri, 17 Dec 2021 18:34:49 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net v3] bonding: fix ad_actor_system option setting to default
In-reply-to: <20211218015001.1740-1-ffmancera@riseup.net>
References: <20211218015001.1740-1-ffmancera@riseup.net>
Comments: In-reply-to Fernando Fernandez Mancera <ffmancera@riseup.net>
   message dated "Sat, 18 Dec 2021 02:50:01 +0100."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1322.1639794889.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 17 Dec 2021 18:34:49 -0800
Message-ID: <1323.1639794889@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:

>When 802.3ad bond mode is configured the ad_actor_system option is set to
>"00:00:00:00:00:00". But when trying to set the all-zeroes MAC as actors'
>system address it was failing with EINVAL.
>
>An all-zeroes ethernet address is valid, only multicast addresses are not
>valid values.
>
>Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

>---
>v2: added documentation changes and modified commit message
>v3: fixed format warning on commit message
>---
> Documentation/networking/bonding.rst | 11 ++++++-----
> drivers/net/bonding/bond_options.c   |  2 +-
> 2 files changed, 7 insertions(+), 6 deletions(-)
>
>diff --git a/Documentation/networking/bonding.rst b/Documentation/network=
ing/bonding.rst
>index 31cfd7d674a6..c0a789b00806 100644
>--- a/Documentation/networking/bonding.rst
>+++ b/Documentation/networking/bonding.rst
>@@ -196,11 +196,12 @@ ad_actor_sys_prio
> ad_actor_system
> =

> 	In an AD system, this specifies the mac-address for the actor in
>-	protocol packet exchanges (LACPDUs). The value cannot be NULL or
>-	multicast. It is preferred to have the local-admin bit set for this
>-	mac but driver does not enforce it. If the value is not given then
>-	system defaults to using the masters' mac address as actors' system
>-	address.
>+	protocol packet exchanges (LACPDUs). The value cannot be a multicast
>+	address. If the all-zeroes MAC is specified, bonding will internally
>+	use the MAC of the bond itself. It is preferred to have the
>+	local-admin bit set for this mac but driver does not enforce it. If
>+	the value is not given then system defaults to using the masters'
>+	mac address as actors' system address.
> =

> 	This parameter has effect only in 802.3ad mode and is available through
> 	SysFs interface.
>diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bon=
d_options.c
>index a8fde3bc458f..b93337b5a721 100644
>--- a/drivers/net/bonding/bond_options.c
>+++ b/drivers/net/bonding/bond_options.c
>@@ -1526,7 +1526,7 @@ static int bond_option_ad_actor_system_set(struct b=
onding *bond,
> 		mac =3D (u8 *)&newval->value;
> 	}
> =

>-	if (!is_valid_ether_addr(mac))
>+	if (is_multicast_ether_addr(mac))
> 		goto err;
> =

> 	netdev_dbg(bond->dev, "Setting ad_actor_system to %pM\n", mac);
>-- =

>2.30.2
>
