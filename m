Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64553319E5D
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 13:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhBLMZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 07:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbhBLMXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 07:23:54 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E853C061574;
        Fri, 12 Feb 2021 04:23:13 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id hs11so15233230ejc.1;
        Fri, 12 Feb 2021 04:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oAkh6JJVyX7ngecxDdQvglBOLyHNnX0FyZZLG8idRao=;
        b=UNezosfMr9+hm0SI9j2bJhhnYuMnPZDZ7UXSFalWY20RPpK4uA+3gwLA+agW5jDe0o
         eXwRsUHVsu6fiFM/z9zkRbkk0qZKWuQTaJzA3McH6mSAgk1C2whm7x2pbcXYOA7ozgNE
         BD40S3X4M56Zry8V7WdWrV7gn1Nd8dE+Lp8t2dwuPr3iw3LqSiLVqNR4jiJbj3d+9A4f
         SOI7PWSpK7o3CDevo7JIWOSIcBtWpsJxciXYan3BS6GytZxqWvyg3ce1xxDoVh5q8Pg6
         kdg3mvRzsawZ+MX3PXBpiGi2HZ51TkHeTx46j86WTzPsaPsRs/H+c2dORSJjRvi1Q81q
         jFNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oAkh6JJVyX7ngecxDdQvglBOLyHNnX0FyZZLG8idRao=;
        b=MbXbwBGGf3L1Jya32e2ZePAzj5Gz6AXRFicYyPyjn3ihtxOADQPdhZhJUCnE7m5o7c
         3jypCPhAb/xu/wt/Gr2NHL7Sv6a+Qy5JC0Hj9a2zsBWYlp+fEMKt8z/ctYqKIwLB0ovA
         q/bAHgbhpgE9ZbTpnno0OTtDPECdpsjTinvKkdkC5tQZ87hy2AiV9hMLgIk3TIWRereV
         dy02zNdJPJFXvlTXr1qTey97ORSYPOQP12ZDs4vGsvmaVIj08YR2iFklMOi4RdWFl74n
         zD66yZ6KwgYniun4upX9Faz2vFpqEE4TlqspvKFLLGMc8O43d0OYWxly1uri4NANLL+8
         HuyQ==
X-Gm-Message-State: AOAM5316RTFdJiN+Ozpme0pDodLhdz997azgWUZ80MzM9nrbaqW9GKfQ
        aEmUGwxQ25o2Wfr6Tu917E0=
X-Google-Smtp-Source: ABdhPJxCV/uDu+B1aZTDEIW0K0r5Aqr9vysmDwZG09Mi9VVfNGYjX2uN5Vt6fOUAEG8Dybn0iNzzbw==
X-Received: by 2002:a17:906:755:: with SMTP id z21mr2810355ejb.514.1613132592317;
        Fri, 12 Feb 2021 04:23:12 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id l25sm464065eja.82.2021.02.12.04.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 04:23:10 -0800 (PST)
Date:   Fri, 12 Feb 2021 14:23:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v4 net-next 7/9] net: mscc: ocelot: use separate flooding
 PGID for broadcast
Message-ID: <20210212122309.ffv6zuhscwtvrhjk@skbuf>
References: <20210212010531.2722925-1-olteanv@gmail.com>
 <20210212010531.2722925-8-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212010531.2722925-8-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 03:05:29AM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In preparation of offloading the bridge port flags which have
> independent settings for unknown multicast and for broadcast, we should
> also start reserving one destination Port Group ID for the flooding of
> broadcast packets, to allow configuring it individually.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

After more testing with the ocelot-8021q tagger too, not just the
default NPI-based one, I noticed that I introduced a regression.

devlink-sb tells me that broadcast packets remain stuck in the ingress
queues of the front-panel ports instead of being forwarded to the CPU.
This is because I forgot this:

-----------------------------[cut here]-----------------------------
 drivers/net/dsa/ocelot/felix.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 96d9d13c5ae0..2771560cef61 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -299,6 +299,7 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 	cpu_flood = ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports));
 	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_UC);
 	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_MC);
+	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_BC);
 
 	felix->dsa_8021q_ctx = kzalloc(sizeof(*felix->dsa_8021q_ctx),
 				       GFP_KERNEL);
-----------------------------[cut here]-----------------------------

If there is no other feedback on this series, can I send this as a
follow-up fixup? Thanks.
