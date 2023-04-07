Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3AA6DAEDD
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 16:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbjDGO0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 10:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbjDGO0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 10:26:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76A06EB5
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 07:26:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 414E4650BB
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 14:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A88C433EF;
        Fri,  7 Apr 2023 14:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680877578;
        bh=cmCKody/95DcoKaiiS4GKHoqs9htcRtjcs3mRXBNGqQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qqC35M2YP0pGwxgcXotJSjjbcvRzfWFvxo8jjJrhBiKd9KkUVkwoqFs3PGotuCbJj
         WcXzDqzCHM0L743kVcwcMUL7cHY3AKypi6M9RBTgNI8bD9OFP27JUnjKK0pj+0kRjv
         mKI+Wt8KR07DVFrXNaiGTLSkgsUYVSho0+QDANYyNG7Kjv0MIsYZNfhXLvoWvVnFF4
         ZGAUWyqxJpDWS90oLIa5d4xKTVPOtDStYLBtzZLSfV2zv4EksyCbeSk4txIBP+KZM+
         FpAF5qOofxS+gl3ru9xpVPXRCeJ3voK+aybJztXBqZIFjAFFALd1L/RbJHkGHwF7/o
         SXDfZt+lJDMrg==
Date:   Fri, 7 Apr 2023 07:26:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc:     netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, thomas.petazzoni@bootlin.com,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <20230407072615.1891cf07@kernel.org>
In-Reply-To: <20230407105857.1b11a000@kmaincent-XPS-13-7390>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
        <20230406173308.401924-3-kory.maincent@bootlin.com>
        <20230406184646.0c7c2ab1@kernel.org>
        <20230407105857.1b11a000@kmaincent-XPS-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Apr 2023 10:58:57 +0200 K=C3=B6ry Maincent wrote:
> > Also let me advertise tools/net/ynl/cli.py to you:
> > https://docs.kernel.org/next/userspace-api/netlink/intro-specs.html =20
>=20
> Ok I will take look.
> Seems broken on net-next:
> ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/ethtool.yaml --=
do rings-get --json '{"header":{"dev-index": 18}}'
> Traceback (most recent call last):
>   File "./tools/net/ynl/cli.py", line 52, in <module>
>     main()
>   File "./tools/net/ynl/cli.py", line 31, in main
>     ynl =3D YnlFamily(args.spec, args.schema)
>   File "/home/kmaincent/Documents/linux/tools/net/ynl/lib/ynl.py", line 3=
61, in __init__
>     self.family =3D GenlFamily(self.yaml['name'])
>   File "/home/kmaincent/Documents/linux/tools/net/ynl/lib/ynl.py", line 3=
31, in __init__
>     self.genl_family =3D genl_family_name_to_id[family_name]
> KeyError: 'ethtool'

IIRC this usually means ethtool netlink is not selected by you Kconfig.
I should add a clearer error for that I guess.
Booting net-next now, I'll get back to you with a confirmation.

> > Please fill in the new commands in the ethtool spec. Feel free to ask
> > if you have any questions, it's still a bit of a rough.. clay?
> >  =20
> > > +/* Hardware layer of the SO_TIMESTAMPING provider */
> > > +enum timestamping_layer {
> > > +	SOF_MAC_TIMESTAMPING =3D (1<<0),
> > > +	SOF_PHY_TIMESTAMPING =3D (1<<1),   =20
> >=20
> > What does SOF_ stand for? =F0=9F=A4=94=EF=B8=8F =20
>=20
> It was to follow the naming reference in
> "Documentation/networking/timestamping.rst" like SOF_TIMESTAMPING_RX_HARD=
WARE
> or SOF_TIMESTAMPING_RX_SOFTAWRE but indeed I do not really understand the=
 SOF
> prefix.=20

My default would be to prefix it with ethtool, but who knows maybe one
day it will be used in socket (actually it may get used on the
timestamps themselves?) so it's a judgment call.=20

> SocketF?

:D  Yeah, some socketFff feature? flag? =F0=9F=A4=B7=EF=B8=8F

> > We need a value for DMA timestamps here. =20
>=20
> Alright,
>=20
> > > +/* TSLIST_GET */
> > > +static int tslist_prepare_data(const struct ethnl_req_info *req_base,
> > > +			       struct ethnl_reply_data *reply_base,
> > > +			       struct genl_info *info)
> > > +{
> > > +	struct ts_reply_data *data =3D TS_REPDATA(reply_base);
> > > +	struct net_device *dev =3D reply_base->dev;
> > > +	const struct ethtool_ops *ops =3D dev->ethtool_ops;
> > > +	int ret;
> > > +
> > > +	ret =3D ethnl_ops_begin(dev);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	data->ts =3D 0;
> > > +	if (phy_has_tsinfo(dev->phydev))
> > > +		data->ts =3D SOF_PHY_TIMESTAMPING;
> > > +	if (ops->get_ts_info)
> > > +		data->ts |=3D SOF_MAC_TIMESTAMPING;   =20
> >=20
> > We can't make that assumption, that info must come from the driver. =20
>=20
> Why can't we list the available time stamp like that, can't we just test =
if they
> have time stamp support.=20

On embedded devices this will work, but for integrated NICs there's no
standalone PHY driver. The one vendor driver takes care of all.

Maybe we can do something like:

if (dev->phydev)
	/* your code, it should work for phydev users */
else
	/* vendor driver, we need to call the driver */

Until vendor drivers fill in their implementations we may need to
report some form of unknown source. So we'll either have to add
"unknown" to the source enum or return -EOPNOTSUPP.

> > Also don't we need some way to identify the device / phc from which=20
> > the timestamp at the given layer will come? =20
>=20
> I don't think so, the PHC will be described by the get_ts_info from each
> ethernet driver. Do I miss something?

Right, but then to discover all PHCs the user space would have to
switch the source, read the index, switch the source, read the index,
no? I may just be confused..
