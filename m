Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658F63AA794
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 01:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbhFPXmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 19:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234597AbhFPXl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 19:41:59 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457CFC06175F
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 16:39:52 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id g19so1331196qkk.2
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 16:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GZ8Uwa036gpNLbWnfaBzspVA5CRluDlqQqEct0C37As=;
        b=kshY+ojjwAXK3pIhmxDE0VeTVJfmns8FASuchPW9vaayL5PkSHnddwPEF9UdgL0AhX
         cyZgGsKHE9Sd3FSdb6G2Q+vFBJ6O8CrHW1at/8a5AvNErf0kvKHZCwDv7siXwqRsYKOI
         9rePAjFvXqt6aZK8kQO4kbVCRmAWFY/zXtkDazo2V81MI/wJ/fqeNAogpoaO8ProQNG2
         7UU+l9uOW5KweJetqGyNu6XKmv3pRgdzpmcJdqQCjbCC2pFcwNQmbOmNu3FHtLl5OEu7
         GBisdHRuJZsCH1LcAWDE3i8KaDOtQ+Nh4V3oy1Mi/eDlJAP8NiJwq1LWAYEAgR0wXoAJ
         KVkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GZ8Uwa036gpNLbWnfaBzspVA5CRluDlqQqEct0C37As=;
        b=rIazox2MP8nCtP6iQGIzVC3pVGq9zN9JBZpdFkoevemvOZVWtMLzekgDL/+aXBIDVa
         Q+NzUGcNJwlKDH6ipyMpHTr2rb0TPJYbitXsE/C6ALWKrRKvkLIXokgr/a6EJAW0T8Xi
         GRonnn+EjMGUKohI0dub63O7NeRnb66U6sQvV1X4MrGsOTMw2d6krA1vmvFQC+IUZ+YB
         Hk/8kS1RTpkSPXWrNwapTKzU2z0v+5OPWxMolcpFrHYxPZr4dNa+XpsbF6hpcrOyaL+E
         3j+OhH0wmsyhBjX22lhT8e4VMNL+ku4qFq40ng01NglcgsylByz6Xzcv4/0TFfeEbetH
         8PPA==
X-Gm-Message-State: AOAM531vPcwQJtdSzoW5lxzgt3h+ARBoMVxVopxNGp9aghADBu02s6eh
        3ZIwdNCLf5cekwIvgGZcyXblz/7FMFoqBsS02xN05g==
X-Google-Smtp-Source: ABdhPJyaBR6uwbvnXk7V1aA9uldwi5ixDr/g7IQB3vX383R9Ezb0ebsCYcz5SzXZCRq+ysp+Tauc/N8qa1cEvW9QoUc=
X-Received: by 2002:a37:a1d5:: with SMTP id k204mr932037qke.300.1623886791313;
 Wed, 16 Jun 2021 16:39:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210616190759.2832033-1-mw@semihalf.com> <20210616190759.2832033-4-mw@semihalf.com>
 <YMpShczKt1TNAqsV@lunn.ch>
In-Reply-To: <YMpShczKt1TNAqsV@lunn.ch>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 17 Jun 2021 01:39:40 +0200
Message-ID: <CAPv3WKde+LCmxxr6UuA7X=XShF6d4io49baxsjw1kMqR=T7XrA@mail.gmail.com>
Subject: Re: [net-next: PATCH v2 3/7] net/fsl: switch to fwnode_mdiobus_register
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>, upstream@semihalf.com,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        Jon Nettleton <jon@solid-run.com>,
        Tomasz Nowicki <tn@semihalf.com>, rjw@rjwysocki.net,
        lenb@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=C5=9Br., 16 cze 2021 o 21:35 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
>
> On Wed, Jun 16, 2021 at 09:07:55PM +0200, Marcin Wojtas wrote:
> > Utilize the newly added helper routine
> > for registering the MDIO bus via fwnode_
> > interface.
>
> You need to add depends on FWNODE_MDIO
>

Do you mean something like this?

--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -68,8 +68,8 @@ config FSL_PQ_MDIO
 config FSL_XGMAC_MDIO
        tristate "Freescale XGMAC MDIO"
        select PHYLIB
-       depends on OF
-       select OF_MDIO
+       depends on ACPI || OF
+       select FWNODE_MDIO
        help

Best regards,
Marcin
