Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573C946604D
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 10:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356408AbhLBJ3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 04:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356406AbhLBJ3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 04:29:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D9AC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 01:25:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 121C1CE21D7
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 09:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2396CC00446;
        Thu,  2 Dec 2021 09:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638437148;
        bh=MMZ1bXBf+X0CsLLns+x0WwnJQdwFNHErTQ/9TP4vTKQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D2Zdv0YnA3UwhuE2/9GMSx6d0Xwy9i0UXnztAUUfOL8C2bFER41w6fuZGgSWtVY9l
         5VpvrYuLzbCuzpRJ1tFciUf1alZl8GODOZVut8mO7uW2olDa2NxBEAleW7lFqDhxV0
         M0wnoLXd3cI5k35lORmEyfOhZmbUfGqmGAaNBn3mj+3IzyhbNlD7/1tZcv2C3Enx2+
         LQjaexOFb2pZB4UPIBjvgdK6aKXO7Mt9eUCKx2XdYFjOO1fSz1dUv6yKJ0mgi85WvM
         G7TqmpOuuAqa+AgaEglZxsYJP9/c47z+m8Al7Wl8wu8v6ml0SVd2zEeWsWTuT/5kV/
         PltE/3M0Q0ZKg==
Date:   Thu, 2 Dec 2021 10:25:41 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [v2 1/2] Docs/devicetree: add serdes-output-amplitude-mv to
 marvell.txt
Message-ID: <20211202102541.06b4e361@thinkpad>
In-Reply-To: <20211202080527.18520-1-holger.brunck@hitachienergy.com>
References: <20211202080527.18520-1-holger.brunck@hitachienergy.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  2 Dec 2021 09:05:26 +0100
Holger Brunck <holger.brunck@hitachienergy.com> wrote:

> This can be configured from the device tree. Add this property to the
> documentation accordingly. This is a property of the port node, which
> needs to be specified in millivolts
>=20
> CC: Andrew Lunn <andrew@lunn.ch>
> CC: Jakub Kicinski <kuba@kernel.org>
> CC: Marek Beh=C3=BAn <kabel@kernel.org>
> Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/marvell.txt | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/net/dsa/marvell.txt b/Docu=
mentation/devicetree/bindings/net/dsa/marvell.txt
> index 2363b412410c..9292b6f960df 100644
> --- a/Documentation/devicetree/bindings/net/dsa/marvell.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/marvell.txt
> @@ -46,6 +46,11 @@ Optional properties:
>  - mdio?		: Container of PHYs and devices on the external MDIO
>  			  bus. The node must contains a compatible string of
>  			  "marvell,mv88e6xxx-mdio-external"
> +- serdes-output-amplitude-mv: Configure the output amplitude of the serd=
es
> +			      interface in millivolts. This option can be
> +                              set in the ports node as it is a property =
of
> +                              the port.
> +    serdes-output-amplitude-mv =3D <210>;

The suffix should be millivolt, as can be seen in other bindings.

Also I think maybe use "tx" instead of "output"? It is more common to
refere to serdes pairs as rx/tx instead of input/output:

  serdes-tx-amplitude-millivolt

I will probably want to add this property also either to mvneta, or to
A3720 common PHY binding. Andrew, do you think it should be put
somewhere more generic?

Marek
