Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F0BD8078
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 21:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732418AbfJOTk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 15:40:29 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34661 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727856AbfJOTk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 15:40:28 -0400
Received: by mail-lf1-f68.google.com with SMTP id r22so15452282lfm.1
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 12:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=n2qGhWk0+fwNlXFx2d4BeGPCJeIsvEP8japRoWMrwRY=;
        b=DekZaf+9KlWM4oBBUggBrskZ2WBZuEggHCcZq7hMqpme7jThNhlWjl0GYAOK2CDwFd
         n3t0hvSQtBmJgqDD4Mio1b+ZOtxJ65TazP9b9fzArq+kRYs4M/7cdcJI4aRaPUyzb7lk
         Y/WIS94dANWyvEjlMQ3WoqqvR7Bb5qTj7lHrRJ0orH+xe/40zHol77UKa7FkkTyCpX+Q
         6eV9Oej4qt1sFybNSmfDgjp5N6zgaj5nIKSexLcD8k0019Wrgy47yyDEeoKNmfDvdXy2
         2aO9wMNa2CliSrOR7Rah4zlmhR74quivAAcYIg94z9wE5yybpMeLM3+ZnwkKBiDmTVyq
         pdWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=n2qGhWk0+fwNlXFx2d4BeGPCJeIsvEP8japRoWMrwRY=;
        b=QLB/kNQMURrcrrQrXnTLxlpoq9+ZD9EDEAsIFEFofMX5rLV887Q1ZWRXmboBYN9zZj
         wTilGnyQFOl5kfjnYSzsJ+EwL9M7uFOyfginsgKzDgQOajxmUyfx4umjR8bdpnOnpOHJ
         o8vlcsFlY19HIpvqvh0TNEPCwNCoVCNIRSHtou0QOfcHLx3IddcqfRYuCBHhr1XY9tk2
         KkdKsnoS335B7ioJ7aEGH70FzVrx5NziaJfcUgTRWwJejpx7jUsSR1dsNwIofk0/COfr
         yOVv05Hs5IX7KIZKqq0aTiPJDEwX40gKPKfVTew2dcQZhdjepKHk54b35NQEHA/JE985
         YGuw==
X-Gm-Message-State: APjAAAXKGjoFZ+L1UKaU0AN1cJ4lbEbXSZGulZfCXs2biI49k1Ez0zsJ
        tj+C+E7MpjN+EOdBVJM2D0KPcw==
X-Google-Smtp-Source: APXvYqwBhoACukeIlLor4YYkJimf56mu+/7EZbbftGvZCYpSQX3Bgs8p6UoQ69zE4MERxPdlUAIjKQ==
X-Received: by 2002:ac2:4d1b:: with SMTP id r27mr21669285lfi.133.1571168425291;
        Tue, 15 Oct 2019 12:40:25 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u21sm5675766lje.92.2019.10.15.12.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 12:40:25 -0700 (PDT)
Date:   Tue, 15 Oct 2019 12:40:17 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, davem@davemloft.net,
        netdev@vger.kernel.org,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH v2 net 2/2] dpaa2-eth: Fix TX FQID values
Message-ID: <20191015124017.64a3d19b@cakuba.netronome.com>
In-Reply-To: <20191015192923.GC7839@lunn.ch>
References: <1571045117-26329-1-git-send-email-ioana.ciornei@nxp.com>
        <1571045117-26329-3-git-send-email-ioana.ciornei@nxp.com>
        <20191015192923.GC7839@lunn.ch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Oct 2019 21:29:23 +0200, Andrew Lunn wrote:
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers=
/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > index 5acd734a216b..c3c2c06195ae 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > @@ -1235,6 +1235,8 @@ static void dpaa2_eth_set_rx_taildrop(struct dpaa=
2_eth_priv *priv, bool enable)
> >  	priv->rx_td_enabled =3D enable;
> >  }
> > =20
> > +static void update_tx_fqids(struct dpaa2_eth_priv *priv);
> > + =20
>=20
> Hi Ioana and Ioana
>=20
> Using forward declarations is generally not liked. Is there something
> which is preventing you from having it earlier in the file?

Ha! I was just about to ask the same question =F0=9F=98=8A

+out_err:
+	netdev_info(priv->net_dev,
+		    "Error reading Tx FQID, fallback to QDID-based enqueue");
+	priv->enqueue =3D dpaa2_eth_enqueue_qd;
+}

Here dpaa2_eth_enqueue_qd is a function pointer which is is defined
towards the end of the file :S

But your point obviously stands, and in the future the code should be
structured more carefully :(


Also can I point out that this:

static inline int dpaa2_eth_enqueue_qd(struct dpaa2_eth_priv *priv,        =
    =20
                                       struct dpaa2_eth_fq *fq,            =
    =20
                                       struct dpaa2_fd *fd, u8 prio)       =
    =20
{                                                                          =
    =20
        return dpaa2_io_service_enqueue_qd(fq->channel->dpio,              =
    =20
                                           priv->tx_qdid, prio,            =
    =20
                                           fq->tx_qdbin, fd);              =
    =20
}                                                                          =
    =20
                                                                           =
    =20
static inline int dpaa2_eth_enqueue_fq(struct dpaa2_eth_priv *priv,        =
    =20
                                       struct dpaa2_eth_fq *fq,            =
    =20
                                       struct dpaa2_fd *fd, u8 prio)       =
    =20
{                                                                          =
    =20
        return dpaa2_io_service_enqueue_fq(fq->channel->dpio,              =
    =20
                                           fq->tx_fqid[prio], fd);         =
    =20
}                                                                          =
    =20
                                                                           =
    =20
static void set_enqueue_mode(struct dpaa2_eth_priv *priv)                  =
    =20
{                                                                          =
    =20
        if (dpaa2_eth_cmp_dpni_ver(priv, DPNI_ENQUEUE_FQID_VER_MAJOR,      =
    =20
                                   DPNI_ENQUEUE_FQID_VER_MINOR) < 0)       =
    =20
                priv->enqueue =3D dpaa2_eth_enqueue_qd;                    =
      =20
        else                                                               =
    =20
                priv->enqueue =3D dpaa2_eth_enqueue_fq;=20
}

Could be the most pointless use of the inline keyword possible :)
Both dpaa2_eth_enqueue_qd() and dpaa2_eth_enqueue_fq() are only ever
called via a pointer..
