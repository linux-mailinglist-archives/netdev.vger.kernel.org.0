Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205C66DAA83
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238501AbjDGI7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjDGI7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:59:04 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3C983F0
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 01:59:02 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5398A1C0008;
        Fri,  7 Apr 2023 08:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680857941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x5GZuDQ8yoGaQNtwIN4Z53AOSe49RQ4ZZhX6Ibwvt44=;
        b=ZKMQGPQ4kt7cDWUbpuIu/ZInRZgNzFTrVKcLHiScLoGYJ/eCAmI/NT4EMnuMMH3kP4dejy
        K+NFX+X9Ejg7C+yHfTZT2+4oTc+yJrLqK/PQf+QcToKA1Vj6Tku8+PqpmR1EvAV588l9NY
        ouB8hBaUoouOTm0V1JmdsYGzwMxDJYV4YTrvxzNSJKccQuzwadPj4lwip/46dINbaCQZkU
        oO7cFmq1Wa4JuZnwGjFpr2aAJz/3rEfja88RHRpzxnUYYp1TF56ipx3PdlHMoyfmeZG8VR
        x/8fprzF/oEwDe+ash/vFFC0qgCOJVB3TZoWlget3w+ggoe41yRrF7v6hmdKiA==
Date:   Fri, 7 Apr 2023 10:58:57 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, thomas.petazzoni@bootlin.com,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <20230407105857.1b11a000@kmaincent-XPS-13-7390>
In-Reply-To: <20230406184646.0c7c2ab1@kernel.org>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
        <20230406173308.401924-3-kory.maincent@bootlin.com>
        <20230406184646.0c7c2ab1@kernel.org>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review.

On Thu, 6 Apr 2023 18:46:46 -0700
Jakub Kicinski <kuba@kernel.org> wrote:
=20
> Please put some words in here :) Documentation matters to the users.

Ok.

>=20
> Also let me advertise tools/net/ynl/cli.py to you:
> https://docs.kernel.org/next/userspace-api/netlink/intro-specs.html

Ok I will take look.
Seems broken on net-next:
./tools/net/ynl/cli.py --spec Documentation/netlink/specs/ethtool.yaml --do=
 rings-get --json '{"header":{"dev-index": 18}}'
Traceback (most recent call last):
  File "./tools/net/ynl/cli.py", line 52, in <module>
    main()
  File "./tools/net/ynl/cli.py", line 31, in main
    ynl =3D YnlFamily(args.spec, args.schema)
  File "/home/kmaincent/Documents/linux/tools/net/ynl/lib/ynl.py", line 361=
, in __init__
    self.family =3D GenlFamily(self.yaml['name'])
  File "/home/kmaincent/Documents/linux/tools/net/ynl/lib/ynl.py", line 331=
, in __init__
    self.genl_family =3D genl_family_name_to_id[family_name]
KeyError: 'ethtool'


> Please fill in the new commands in the ethtool spec. Feel free to ask
> if you have any questions, it's still a bit of a rough.. clay?
>=20
> > +/* Hardware layer of the SO_TIMESTAMPING provider */
> > +enum timestamping_layer {
> > +	SOF_MAC_TIMESTAMPING =3D (1<<0),
> > +	SOF_PHY_TIMESTAMPING =3D (1<<1), =20
>=20
> What does SOF_ stand for? =F0=9F=A4=94=EF=B8=8F

It was to follow the naming reference in
"Documentation/networking/timestamping.rst" like SOF_TIMESTAMPING_RX_HARDWA=
RE
or SOF_TIMESTAMPING_RX_SOFTAWRE but indeed I do not really understand the S=
OF
prefix. SocketF?

>=20
> We need a value for DMA timestamps here.

Alright,

>=20
> > +/* TSLIST_GET */
> > +static int tslist_prepare_data(const struct ethnl_req_info *req_base,
> > +			       struct ethnl_reply_data *reply_base,
> > +			       struct genl_info *info)
> > +{
> > +	struct ts_reply_data *data =3D TS_REPDATA(reply_base);
> > +	struct net_device *dev =3D reply_base->dev;
> > +	const struct ethtool_ops *ops =3D dev->ethtool_ops;
> > +	int ret;
> > +
> > +	ret =3D ethnl_ops_begin(dev);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	data->ts =3D 0;
> > +	if (phy_has_tsinfo(dev->phydev))
> > +		data->ts =3D SOF_PHY_TIMESTAMPING;
> > +	if (ops->get_ts_info)
> > +		data->ts |=3D SOF_MAC_TIMESTAMPING; =20
>=20
> We can't make that assumption, that info must come from the driver.

Why can't we list the available time stamp like that, can't we just test if=
 they
have time stamp support.=20

> Also don't we need some way to identify the device / phc from which=20
> the timestamp at the given layer will come?

I don't think so, the PHC will be described by the get_ts_info from each
ethernet driver. Do I miss something?

K=C3=B6ry
