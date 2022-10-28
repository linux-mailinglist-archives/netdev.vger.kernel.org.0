Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E1961135D
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbiJ1NpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiJ1Noz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:44:55 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FCDB10;
        Fri, 28 Oct 2022 06:44:37 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8247740008;
        Fri, 28 Oct 2022 13:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666964675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p+nLdRj+8OUj3qiwCvpQ1lxFy6TRepZB0071YCG29E8=;
        b=imB9yEPn61l8qq77msz4sIun2w4ZFowREgZ1KGLqw0HpfzW22oyTt8UIJ2iCq2LZ6EXWW7
        DpQeM3QKho8/TuGAjFrbRvGAccykwijKa4vJks31PHn/hJBR7Ts3T7/OdsEgaNA/uYuMGy
        Z+ll5Rz10DhCAh0sqgUKTTqI+cE8aZu99SScC14NJLbppEeuvGjoOtRNBHR2f3M+eUxACz
        ytGKlDHk7FMU4vyVMSgMRs+XOW/sWEx3l5FBn4vVwHXWM6F/AraZcURVvStTSGOyA/g81A
        hPcqNRfLmGaBUfXuF6lalkjIfFS9kuTUAm8a1aHzQh9h4DBOyRakzco2dBRNlA==
Date:   Fri, 28 Oct 2022 15:44:31 +0200
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
        Rob Herring <robh+dt@kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        linux-kernel@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Eric Dumazet <edumazet@google.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/5] dt-bindings: nvmem: add YAML schema for the ONIE
 tlv layout
Message-ID: <20221028154431.0096ab70@xps-13>
In-Reply-To: <166695949292.1076993.16137208250373047416.robh@kernel.org>
References: <20221028092337.822840-1-miquel.raynal@bootlin.com>
        <20221028092337.822840-3-miquel.raynal@bootlin.com>
        <166695949292.1076993.16137208250373047416.robh@kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob & Krzysztof,

robh@kernel.org wrote on Fri, 28 Oct 2022 07:20:05 -0500:

> On Fri, 28 Oct 2022 11:23:34 +0200, Miquel Raynal wrote:
> > Add a schema for the ONIE tlv NVMEM layout that can be found on any ONIE
> > compatible networking device.
> >=20
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  .../nvmem/layouts/onie,tlv-layout.yaml        | 96 +++++++++++++++++++
> >  1 file changed, 96 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/nvmem/layouts/oni=
e,tlv-layout.yaml
> >  =20
>=20
> My bot found errors running 'make DT_CHECKER_FLAGS=3D-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
>=20
> yamllint warnings/errors:
>=20
> dtschema/dtc warnings/errors:
> Documentation/devicetree/bindings/nvmem/layouts/onie,tlv-layout.example.d=
tb:0:0: /example-0/onie: failed to match any schema with compatible: ['onie=
,tlv-layout', 'vendor,device']

Oh right, I wanted to ask about this under the three --- but I forgot.
Here was my question:

How do we make the checker happy with an example where the second
compatible can be almost anything (any nvmem-compatible device) but the
first one should be the layout? (this is currently what Michael's
proposal uses).

> doc reference errors (make refcheckdocs):
>=20
> See https://patchwork.ozlabs.org/patch/
>=20
> This check can fail if there are any dependencies. The base for a patch
> series is generally the most recent rc1.
>=20
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
>=20
> pip3 install dtschema --upgrade
>=20
> Please check and re-submit.
>=20


Thanks,
Miqu=C3=A8l
