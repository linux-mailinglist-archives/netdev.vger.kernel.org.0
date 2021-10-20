Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11B0434E1E
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 16:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhJTOnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 10:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhJTOne (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 10:43:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F01076135F;
        Wed, 20 Oct 2021 14:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634740879;
        bh=ToeXNrIVSqKeCw0+EPhZDTiVKtXJGcgdSvi2IhlgTcg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mbu//0DEzrS9xFXp5bJTwNxCeG7h71ZqvvDo8xNdCQSU2x+taqomOcn2n991+v7l9
         USYCi2ye6530nAd4us8VPzIZXNPmBr7sHpmEAXZO9BKs9RzIgxX1RtIbsJ7TWra9yh
         nEGUj3BwApBYrY0Q46pq6yXWjz4d/DJY/CXA6cE6bsADBLU3IHYuvrXlkjRbYHF3q4
         3GFhV8y+ebEiMtrYQ18JmKZwBSohjXJxIx6t0SixY7R2fKlrZ/7DAa1G9agYdQ2lZ1
         nroERlY/jYG/8DTGYtJ7LNQCZc52EldjBz0/7xzXGmeFf6Fs+hLWaUXOC4IkkzzdVv
         44qtQ+9q6fwtA==
Date:   Wed, 20 Oct 2021 07:41:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Po Liu <po.liu@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 5/5] net: mscc: ocelot: track the port pvid
 using a pointer
Message-ID: <20211020074117.7adb31c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211020105602.770329-6-vladimir.oltean@nxp.com>
References: <20211020105602.770329-1-vladimir.oltean@nxp.com>
        <20211020105602.770329-6-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Oct 2021 13:56:02 +0300 Vladimir Oltean wrote:
> Now that we have a list of struct ocelot_bridge_vlan entries, we can
> rewrite the pvid logic to simply point to one of those structures,
> instead of having a separate structure with a "bool valid".
> The NULL pointer will represent the lack of a bridge pvid (not to be
> confused with the lack of a hardware pvid on the port, that is present
> at all times).

drivers/net/ethernet/mscc/ocelot_mrp.c: In function =E2=80=98ocelot_mrp_sav=
e_mac=E2=80=99:
drivers/net/ethernet/mscc/ocelot_mrp.c:119:21: error: =E2=80=98port->pvid_v=
lan=E2=80=99 is a pointer; did you mean to use =E2=80=98->=E2=80=99?
  119 |      port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
      |                     ^
      |                     ->
drivers/net/ethernet/mscc/ocelot_mrp.c:121:21: error: =E2=80=98port->pvid_v=
lan=E2=80=99 is a pointer; did you mean to use =E2=80=98->=E2=80=99?
  121 |      port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
      |                     ^
      |                     ->
drivers/net/ethernet/mscc/ocelot_mrp.c: In function =E2=80=98ocelot_mrp_del=
_mac=E2=80=99:
drivers/net/ethernet/mscc/ocelot_mrp.c:127:59: error: =E2=80=98port->pvid_v=
lan=E2=80=99 is a pointer; did you mean to use =E2=80=98->=E2=80=99?
  127 |  ocelot_mact_forget(ocelot, mrp_test_dmac, port->pvid_vlan.vid);
      |                                                           ^
      |                                                           ->
drivers/net/ethernet/mscc/ocelot_mrp.c:128:62: error: =E2=80=98port->pvid_v=
lan=E2=80=99 is a pointer; did you mean to use =E2=80=98->=E2=80=99?
  128 |  ocelot_mact_forget(ocelot, mrp_control_dmac, port->pvid_vlan.vid);
      |                                                              ^
      |                                                              ->
make[5]: *** [drivers/net/ethernet/mscc/ocelot_mrp.o] Error 1
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [drivers/net/ethernet/mscc] Error 2
make[3]: *** [drivers/net/ethernet] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [drivers/net] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [__sub-make] Error 2
