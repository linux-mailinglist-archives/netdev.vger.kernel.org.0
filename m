Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFEB0479702
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 23:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhLQWWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 17:22:46 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:46658
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229807AbhLQWWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 17:22:46 -0500
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id BA3DC3F048
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 22:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639779762;
        bh=2++Kc3gMi/RQI7pjOx7RKjXr3ed/h8fyGsmnse9vykc=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=X8LzB/bPGaqwlrA93jwu4wl6hv1LCgf56KPDZz7wY7slNA4da4OdQE+nrwTFOl4PA
         zToQNO64nVtT18OIoWUdoZ7t6KcaK2sRmzRBcQKZfX2z4kVc0jkXLnwMfXBJrZi8Jf
         yC0GsGlxvm4Pwu3Z9fRDUYOwCAQTPvANZ601Uv5UiR45zDD7wt/GuBcqK1+VrcJjV4
         A5de5sVQWabgWFIsYWf4qxy25cdne+pYSQj1tus2z7a0qQky6KThqHysvwibCvzVDP
         7Fw2t6+sNzrZkDjVv2KGvZENmk2zemYTXQQTKxM0vF0KvDsVHjveGGd10WsQlJJsz2
         hVs8t0rTpz5lw==
Received: by mail-pf1-f198.google.com with SMTP id x128-20020a628686000000b004ba53b6ec72so2056037pfd.9
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 14:22:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=2++Kc3gMi/RQI7pjOx7RKjXr3ed/h8fyGsmnse9vykc=;
        b=qI8fWclOS4kxD544S7iSY7FmKSCzO749DgudDkMmGCtSgIrcEvxrtXDL58Vep8reO8
         o/cYtgBdU+MEHwsskzDgJn8ZDFK/gLoitpw5zH1pTF6E44Rx9J9wfW3KtkEbkUWD7ghu
         xV4UvzXR0KiPVmjWKcuCr7sE4S6kyfimJv9aiZKnE9sELx8PKtWsrH1njbWpt22ldela
         hXLmlVYIZoSxnNpvvfYBRDTkEssH3kQC64bMIMxBom24oDfeGEKBCD9wpsqjGptXiHbZ
         P0q+f1UjkANt0mcQ3HEhsF6RwTuMyeh3HzwNNHh+jiIr1OfMMQYv49T30KNK5ZVOHiqM
         69Fw==
X-Gm-Message-State: AOAM530fUJpcAZ4W1A61Qy6TBTsbkQciD8NdQMO0o8t0xqgnORacwLko
        6bRob5XxbCLwFTqZ/fMqSFQEtzontr9055gBVIHzsIWtSR6QWXUiu6UrzF5FDWKR72hhoRmMRA6
        QH3uozqzafjheIRzQsU+COJdDZn9NBSt5HA==
X-Received: by 2002:a17:90b:17cc:: with SMTP id me12mr6195787pjb.179.1639779761389;
        Fri, 17 Dec 2021 14:22:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwxwTl0VwSoNnNs3LP0ueJ3kLEjD1VpZ5obyAK4ZX1HEs9SqEbsAZwLJR18DR2vXbatEmKpeQ==
X-Received: by 2002:a17:90b:17cc:: with SMTP id me12mr6195772pjb.179.1639779761147;
        Fri, 17 Dec 2021 14:22:41 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id c19sm11133696pjr.2.2021.12.17.14.22.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Dec 2021 14:22:40 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 6F4AF60DD1; Fri, 17 Dec 2021 14:22:40 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 6982FA0B22;
        Fri, 17 Dec 2021 14:22:40 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] bonding: fix ad_actor_system option setting to default
In-reply-to: <20211217182846.6910-1-ffmancera@riseup.net>
References: <20211217182846.6910-1-ffmancera@riseup.net>
Comments: In-reply-to Fernando Fernandez Mancera <ffmancera@riseup.net>
   message dated "Fri, 17 Dec 2021 19:28:46 +0100."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14021.1639779760.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 17 Dec 2021 14:22:40 -0800
Message-ID: <14022.1639779760@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:

>When 802.3ad bond mode is configured the ad_actor_system option is set
>to "00:00:00:00:00:00". But when trying to set the default value
>manually it was failing with EINVAL.
>
>A zero ethernet address is valid, only multicast addresses are not valid
>values.

	Your intent here by setting ad_actor_system to all zeroes is to
induce bonding to actually set ad_actor_system to the MAC of the bond
itself?

	If so, please also update Documentation/networking/bonding.rst,
as the current text says

        In an AD system, this specifies the mac-address for the actor in
        protocol packet exchanges (LACPDUs). The value cannot be NULL or
        multicast. It is preferred to have the local-admin bit set for thi=
s
        mac but driver does not enforce it. If the value is not given then
        system defaults to using the masters' mac address as actors' syste=
m
        address.

	I'd suggest something like "The value cannot be a multicast
address.  If the all-zeroes MAC is specified, bonding will internally
use the MAC of the bond itself."

	-J

>Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
>---
> drivers/net/bonding/bond_options.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
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

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
