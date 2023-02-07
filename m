Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8605368D9AE
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbjBGNv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbjBGNvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:51:25 -0500
X-Greylist: delayed 60 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Feb 2023 05:51:20 PST
Received: from smtpcmd03116.aruba.it (smtpcmd03116.aruba.it [62.149.158.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735081025B
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 05:51:20 -0800 (PST)
Received: from [192.168.1.189] ([213.215.163.55])
        by Aruba Outgoing Smtp  with ESMTPSA
        id POMRpOrLjQC6APOMSpnlcj; Tue, 07 Feb 2023 14:50:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1675777817; bh=NcFSD1+hQkDyhML9faTlgcz6QoKVti5xKqEWWp0kIPQ=;
        h=Subject:From:To:Date:Content-Type:MIME-Version;
        b=GQ4ZVZoTUQiZ0bHywdXm2iNKSQwKGsDqoXPfhrLNIpC+Pvlv2g3MAbGgF5kd0zkJv
         9YT/wWJtNSgp1iNoihuXViqU/eolc+MZ0BpcbUuBDljIPLfglQ6sEz+i5FU2OO7z3A
         wlk+JcPHxoVl+aZP4hkikqQvasQ6g7wkKdELTgQSvA+zYdoCNCsu0Z/JOWhdjwZIRS
         on/kUbqElLF3h4g17M5O4nreU2JMcOxNtWASrt4Rg5b0KwueOpNok8j3Z05Wu0wBiP
         +K8f6Q+ZH71jxTzg+Xc2t/N4nF9ZxwOQFwqqbTR9MZNYBPv9OlC+2pCNx3pWWLHZv5
         ZHN/3Rvca0WqA==
Message-ID: <1ae01ab918876941dc57d01d4c2f1d7376dda87b.camel@egluetechnologies.com>
Subject: Re: [PATCH v2] can: j1939: do not wait 250 ms if the same addr was
 already claimed
From:   Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Robin van der Gracht <robin@protonic.nl>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 07 Feb 2023 14:50:15 +0100
In-Reply-To: <20221126102840.GA21761@pengutronix.de>
References: <20221124051611.GA7870@pengutronix.de>
         <20221125170418.34575-1-devid.filoni@egluetechnologies.com>
         <20221126102840.GA21761@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-CMAE-Envelope: MS4xfHjTsmG/3kzQnWEX/yQougaeflBWS+XaKBGWU4V8UDcseLaVHyFCE9JSBHXVmUsVWEPWtvKkARZggLEfHIuv4nJf7v4bOEMxFgXQcKoN//sqtcKHNzrA
 Zv7AkeePhZKn9JrhUmqKhQbmTzg9uXS9N6SEwrz6gyNAdC4Vlug/cbL3LkcVfdcOmbZLJI7te/K3uU4FTAbiJQFEE/kX5ocDXTUejTmodZZeUi5wRXiPqhsb
 OeZkBLZAAijGiCZoTXdH/I4J+d/12pqU2O0KmUZSIB3NQQkXlAPIeQIvLo/w0IFe5Z8Qo/wkNNcZgVDJh+enPklAqbZxmBWrdgl2D6YiOmtY+tc59JeJqKXO
 Hb+hcluVAaPVxLOoBpkp+sGnysQq1OAaKIS0Aazw3ucCu2vmTMFoUuAqw5u/hg7VDTT6MKoIjE2rbmA0s9Gwid6z21QE3IcWh2IIa5DxcJeqChroebYssoWS
 BGyIEXAM7l374FVzt8bz5+8QTSbijvD4fn3rqvzVeCJfeM6smlTsMxW4PM9FCzFhdLIrDS44ebdwKRLfnxvYHKFg1+S+y/TSMmsFXDxxauwb3CweVMxRf+qM
 M2dd8JdgyXytwouHxjqH2FB5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-11-26 at 11:28 +0100, Oleksij Rempel wrote:
> On Fri, Nov 25, 2022 at 06:04:18PM +0100, Devid Antonio Filoni wrote:
> > The ISO 11783-5 standard, in "4.5.2 - Address claim requirements", stat=
es:
> >   d) No CF shall begin, or resume, transmission on the network until 25=
0
> >      ms after it has successfully claimed an address except when
> >      responding to a request for address-claimed.
> >=20
> > But "Figure 6" and "Figure 7" in "4.5.4.2 - Address-claim
> > prioritization" show that the CF begins the transmission after 250 ms
> > from the first AC (address-claimed) message even if it sends another AC
> > message during that time window to resolve the address contention with
> > another CF.
> >=20
> > As stated in "4.4.2.3 - Address-claimed message":
> >   In order to successfully claim an address, the CF sending an address
> >   claimed message shall not receive a contending claim from another CF
> >   for at least 250 ms.
> >=20
> > As stated in "4.4.3.2 - NAME management (NM) message":
> >   1) A commanding CF can
> >      d) request that a CF with a specified NAME transmit the address-
> >         claimed message with its current NAME.
> >   2) A target CF shall
> >      d) send an address-claimed message in response to a request for a
> >         matching NAME
> >=20
> > Taking the above arguments into account, the 250 ms wait is requested
> > only during network initialization.
> >=20
> > Do not restart the timer on AC message if both the NAME and the address
> > match and so if the address has already been claimed (timer has expired=
)
> > or the AC message has been sent to resolve the contention with another
> > CF (timer is still running).
> >=20
> > Signed-off-by: Devid Antonio Filoni <devid.filoni@egluetechnologies.com=
>
>=20
> Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
>=20
> > ---
> >  v1 -> v2: Added ISO 11783-5 standard references
> >=20
> >  net/can/j1939/address-claim.c | 40 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 40 insertions(+)
> >=20
> > diff --git a/net/can/j1939/address-claim.c b/net/can/j1939/address-clai=
m.c
> > index f33c47327927..ca4ad6cdd5cb 100644
> > --- a/net/can/j1939/address-claim.c
> > +++ b/net/can/j1939/address-claim.c
> > @@ -165,6 +165,46 @@ static void j1939_ac_process(struct j1939_priv *pr=
iv, struct sk_buff *skb)
> >  	 * leaving this function.
> >  	 */
> >  	ecu =3D j1939_ecu_get_by_name_locked(priv, name);
> > +
> > +	if (ecu && ecu->addr =3D=3D skcb->addr.sa) {
> > +		/* The ISO 11783-5 standard, in "4.5.2 - Address claim
> > +		 * requirements", states:
> > +		 *   d) No CF shall begin, or resume, transmission on the
> > +		 *      network until 250 ms after it has successfully claimed
> > +		 *      an address except when responding to a request for
> > +		 *      address-claimed.
> > +		 *
> > +		 * But "Figure 6" and "Figure 7" in "4.5.4.2 - Address-claim
> > +		 * prioritization" show that the CF begins the transmission
> > +		 * after 250 ms from the first AC (address-claimed) message
> > +		 * even if it sends another AC message during that time window
> > +		 * to resolve the address contention with another CF.
> > +		 *
> > +		 * As stated in "4.4.2.3 - Address-claimed message":
> > +		 *   In order to successfully claim an address, the CF sending
> > +		 *   an address claimed message shall not receive a contending
> > +		 *   claim from another CF for at least 250 ms.
> > +		 *
> > +		 * As stated in "4.4.3.2 - NAME management (NM) message":
> > +		 *   1) A commanding CF can
> > +		 *      d) request that a CF with a specified NAME transmit
> > +		 *         the address-claimed message with its current NAME.
> > +		 *   2) A target CF shall
> > +		 *      d) send an address-claimed message in response to a
> > +		 *         request for a matching NAME
> > +		 *
> > +		 * Taking the above arguments into account, the 250 ms wait is
> > +		 * requested only during network initialization.
> > +		 *
> > +		 * Do not restart the timer on AC message if both the NAME and
> > +		 * the address match and so if the address has already been
> > +		 * claimed (timer has expired) or the AC message has been sent
> > +		 * to resolve the contention with another CF (timer is still
> > +		 * running).
> > +		 */
> > +		goto out_ecu_put;
> > +	}
> > +
> >  	if (!ecu && j1939_address_is_unicast(skcb->addr.sa))
> >  		ecu =3D j1939_ecu_create_locked(priv, name);
> > =20
> > --=20
> > 2.34.1
> >=20
> >=20
>=20

Hello,
I noticed that this patch has not been integrated in upstream yet. Are
there problems with it?

Thank you,
Devid
