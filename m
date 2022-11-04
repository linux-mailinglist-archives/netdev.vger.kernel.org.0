Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA4C6194E4
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 11:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbiKDK4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 06:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiKDK4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 06:56:10 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202272C64B;
        Fri,  4 Nov 2022 03:56:07 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BC87FC0005;
        Fri,  4 Nov 2022 10:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667559366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nI94nXw77S0PIOidCMCWACbCeQJev+vpcblKg+RZyk4=;
        b=HTDO7cUpVEXPkYrmoOIAjhWAQjz1Yvpg5UlQ18FDnwc6yZBP01sR1Zzq0qQKjEgvyMZzjm
        An4va/9zcKsK/JDOIhqUQCPwHPBvbAiK/5aXPHQ56Z3gUOLK6Syj5p59dKWzRPmz1s3UzD
        Jw9zuRrHPquC2Is9rfDurv0f+rIGyPfz+7SR9mUH8CGJz0B/NR8lyW5a68GhE+maS3eHND
        GaMbHFD8RDlXNOkPFala+JNTDebMhiCdcxXSm9m4qoi2oc6kKo+raV5BxwXFsaAitPJOHk
        CpVXecVq/SxQDioPc/pmCvIRrvRXe8K88rCk/aKM/wm2T6w2a4fiz8fcC/iP3Q==
Date:   Fri, 4 Nov 2022 11:56:03 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Robert Marko <robert.marko@sartura.hr>,
        Michael Walle <michael@walle.cc>, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        linux-kernel@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Eric Dumazet <edumazet@google.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/5] dt-bindings: nvmem: add YAML schema for the ONIE
 tlv layout
Message-ID: <20221104115603.35b55506@xps-13>
In-Reply-To: <20221028213556.GA2310662-robh@kernel.org>
References: <20221028092337.822840-1-miquel.raynal@bootlin.com>
        <20221028092337.822840-3-miquel.raynal@bootlin.com>
        <166695949292.1076993.16137208250373047416.robh@kernel.org>
        <20221028154431.0096ab70@xps-13>
        <20221028213556.GA2310662-robh@kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

robh@kernel.org wrote on Fri, 28 Oct 2022 16:35:56 -0500:

> On Fri, Oct 28, 2022 at 03:44:31PM +0200, Miquel Raynal wrote:
> > Hi Rob & Krzysztof,
> >=20
> > robh@kernel.org wrote on Fri, 28 Oct 2022 07:20:05 -0500:
> >  =20
> > > On Fri, 28 Oct 2022 11:23:34 +0200, Miquel Raynal wrote: =20
> > > > Add a schema for the ONIE tlv NVMEM layout that can be found on any=
 ONIE
> > > > compatible networking device.
> > > >=20
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > ---
> > > >  .../nvmem/layouts/onie,tlv-layout.yaml        | 96 +++++++++++++++=
++++
> > > >  1 file changed, 96 insertions(+)
> > > >  create mode 100644 Documentation/devicetree/bindings/nvmem/layouts=
/onie,tlv-layout.yaml
> > > >    =20
> > >=20
> > > My bot found errors running 'make DT_CHECKER_FLAGS=3D-m dt_binding_ch=
eck'
> > > on your patch (DT_CHECKER_FLAGS is new in v5.13):
> > >=20
> > > yamllint warnings/errors:
> > >=20
> > > dtschema/dtc warnings/errors:
> > > Documentation/devicetree/bindings/nvmem/layouts/onie,tlv-layout.examp=
le.dtb:0:0: /example-0/onie: failed to match any schema with compatible: ['=
onie,tlv-layout', 'vendor,device'] =20
> >=20
> > Oh right, I wanted to ask about this under the three --- but I forgot.
> > Here was my question:
> >=20
> > How do we make the checker happy with an example where the second
> > compatible can be almost anything (any nvmem-compatible device) but the
> > first one should be the layout? (this is currently what Michael's
> > proposal uses). =20
>=20
> That seems like mixing 2 different meanings for compatibles. Perhaps=20
> that should be split with the nvmem stuff going into a child container=20
> node.
>=20
> Rob
>=20
> P.S. Any compatible string starting with 'foo' will pass, but I probably=
=20
> won't be happy to see that used.

Ok, I've scratched my forehead a little bit and came with something (I
hope) better. I've taken over the binding patches from Michael's
original series to show how they conform with my changes. Basically
I've introduced an nvmem-layout container node which will improve a lot
the description without mixing everything. More details in the upcoming
series.

Thanks, Miqu=C3=A8l
