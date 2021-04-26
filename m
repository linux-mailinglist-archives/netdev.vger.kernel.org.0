Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C1436B8C3
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 20:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbhDZSRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 14:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbhDZSRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 14:17:23 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F3BC061574;
        Mon, 26 Apr 2021 11:16:41 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id d14so3025900edc.12;
        Mon, 26 Apr 2021 11:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=xkTVD7TxqQ3Zluwvp9FancUs4koGyF+oIROL0cTLdhk=;
        b=XUQJEpNTdYzJF4uxqnEwIbQVU13+kxG+1fTgzfVoKCcV2260aiookfc9nRP/w+YdEw
         UPStvO2Hb9yEzvEgSF0rro3K6J6ctKM+BJFYlgNIIAVvWw+f5ntN0nmbu4NCmGfvS2Bw
         jYlhT3PDOoyrZDjhcQy7oqfUja/1LFoYvwnIXU5wUeEPcxxnB5Ft83JkHKUJDRFhH6HS
         A9NqRwFtOlq1gJvVJbPcPGleeog6oX7zqg/uLzpRgvuPEu7InxHJLncJos5FtcmvrWng
         9cqfFJjEyAQct+d5jcZq4IXOtGAkodPfj53TkwfatCdME5/LJa16VgVqjI2trzWDABiS
         obEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xkTVD7TxqQ3Zluwvp9FancUs4koGyF+oIROL0cTLdhk=;
        b=E4LSHpfXqfofvccAQGC7tSfTtI1K4aGbMNkZoCcStN6ny2fv8JybKnUSnh2utRXnlc
         6ne+cKSNzZICeA/brFH1k2CzzH6TlDyGOVXSKTJGsNE/qMFO2IgAWA8y7g/SMnNnkFYR
         2E3ImtFEFKk/+T8QGapwZOW3uC5AXnpgyWTu93MpIsBnhe1gqY66qNkMTAGTaxE8nsOM
         0/UjE9w+12NZGR297AiE3XsjRsEJGhjkDZZP+nNzp1wBQ0QlQEucER3k+n1XQOC1EKtn
         SR3+jgS857wvnrUHbRDGXCvx/e5hmgkrpBmHHOYEc01qRjqbiMW2zZN0dKv5MCUsyl/p
         nMyA==
X-Gm-Message-State: AOAM533vGyqlW5KqFHL8wR29toLQXokFHTTrtrrDhTWhGUksm5++ViuJ
        ytiwHBgy7sukVDL3kPkczhc=
X-Google-Smtp-Source: ABdhPJymRIS+gVeyUphhzNtTqGsyyEe/s3ziJnnm1ligBnz6W0XYn9FI1ooD0u92DUFBoIakGIfszw==
X-Received: by 2002:aa7:c789:: with SMTP id n9mr23203387eds.352.1619460999822;
        Mon, 26 Apr 2021 11:16:39 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id h11sm497319eds.15.2021.04.26.11.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 11:16:39 -0700 (PDT)
Date:   Mon, 26 Apr 2021 21:16:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next, v2, 3/7] net: dsa: free skb->cb usage in core driver
Message-ID: <20210426181637.2rneohfxkrvwctf2@skbuf>
References: <20210426093802.38652-1-yangbo.lu@nxp.com>
 <20210426093802.38652-4-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210426093802.38652-4-yangbo.lu@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 05:37:58PM +0800, Yangbo Lu wrote:
> Free skb->cb usage in core driver and let device drivers decide to
> use or not. The reason having a DSA_SKB_CB(skb)->clone was because
> dsa_skb_tx_timestamp() which may set the clone pointer was called
> before p->xmit() which would use the clone if any, and the device
> driver has no way to initialize the clone pointer.
>
> Although for now putting memset(skb->cb, 0, 48) at beginning of
> dsa_slave_xmit() by this patch is not very good, there is still way
> to improve this. Otherwise, some other new features, like one-step
> timestamp which needs a flag of skb marked in dsa_skb_tx_timestamp(),
> and handles as one-step timestamp in p->xmit() will face same
> situation.
>
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
> Changes for v2:
> 	- Added this patch.
> ---
>  drivers/net/dsa/ocelot/felix.c         |  1 +
>  drivers/net/dsa/sja1105/sja1105_main.c |  2 +-
>  drivers/net/dsa/sja1105/sja1105_ptp.c  |  4 +++-
>  drivers/net/ethernet/mscc/ocelot.c     |  6 +++---
>  drivers/net/ethernet/mscc/ocelot_net.c |  2 +-
>  include/linux/dsa/sja1105.h            |  3 ++-
>  include/net/dsa.h                      | 14 --------------
>  include/soc/mscc/ocelot.h              |  8 ++++++++
>  net/dsa/slave.c                        |  3 +--
>  net/dsa/tag_ocelot.c                   |  8 ++++----
>  net/dsa/tag_ocelot_8021q.c             |  8 ++++----
>  11 files changed, 28 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index d679f023dc00..8980d56ee793 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -1403,6 +1403,7 @@ static bool felix_txtstamp(struct dsa_switch *ds, int port,
>
>  	if (ocelot->ptp && ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
>  		ocelot_port_add_txtstamp_skb(ocelot, port, clone);
> +		OCELOT_SKB_CB(skb)->clone = clone;
>  		return true;
>  	}
>

Uh-oh, this patch fails to build:

In file included from ./include/soc/mscc/ocelot_vcap.h:9:0,
                 from drivers/net/dsa/ocelot/felix.c:9:
drivers/net/dsa/ocelot/felix.c: In function ‘felix_txtstamp’:
drivers/net/dsa/ocelot/felix.c:1406:17: error: ‘skb’ undeclared (first use in this function)
   OCELOT_SKB_CB(skb)->clone = clone;
                 ^
./include/soc/mscc/ocelot.h:698:29: note: in definition of macro ‘OCELOT_SKB_CB’
  ((struct ocelot_skb_cb *)((skb)->cb))
                             ^~~
drivers/net/dsa/ocelot/felix.c:1406:17: note: each undeclared identifier is reported only once for each function it appears in
   OCELOT_SKB_CB(skb)->clone = clone;
                 ^
./include/soc/mscc/ocelot.h:698:29: note: in definition of macro ‘OCELOT_SKB_CB’
  ((struct ocelot_skb_cb *)((skb)->cb))
                             ^~~

It depends on changes made in patch 3.
