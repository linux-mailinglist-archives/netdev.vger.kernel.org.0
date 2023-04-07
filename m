Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BE76DA710
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 03:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239384AbjDGBqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 21:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjDGBqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 21:46:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AA66EB7
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 18:46:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2677064D44
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 01:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED176C4339B;
        Fri,  7 Apr 2023 01:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680832008;
        bh=XggO3Ow47v2KhhO1Ts2zn+GweBKAmeXDGqlhDF7kbCM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gU0TGU6G+kA12SoveO0h9ZMTxT2oj307KDWG+HXkLfZB/Rys2gfYtqgMNgbs7a6xe
         7fmGEPilDh4NV8ObdB6jfat3vc005JLHxQ33uS+H+qnfYOLAFCSo5uWivZB/XIWS84
         VsWRZchVwzInoronazoETgdUR/1/HvNDyUXskdY341Yca9hUDpxushqQ8XIqKOCs5Y
         NPKl2lfH6V8OpPzJgaKMatMXNsctJYnYLqjrXQBlZvsaox4YgGQvnqFrWrJmcmWb2X
         clolpML4Bx0dSXTFy3D7tFEx8ff1hcm4NWqi3S/9pPe/fqOiorAWJU8ivXWYswyjkr
         hrDhip4QQuJOw==
Date:   Thu, 6 Apr 2023 18:46:46 -0700
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
Message-ID: <20230406184646.0c7c2ab1@kernel.org>
In-Reply-To: <20230406173308.401924-3-kory.maincent@bootlin.com>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
        <20230406173308.401924-3-kory.maincent@bootlin.com>
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

On Thu,  6 Apr 2023 19:33:05 +0200 K=C3=B6ry Maincent wrote:
> +Gets transceiver module parameters.
> +
> +Request contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +  ``ETHTOOL_A_TS_HEADER``            nested  request header
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Kernel response contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
 =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +  ``ETHTOOL_A_TS_HEADER``  nested  reply header
> +  ``ETHTOOL_A_TS_LAYER``   u32     current hardware timestamping
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
 =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +TSLIST_GET
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Gets transceiver module parameters.
> +
> +Request contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +  ``ETHTOOL_A_TS_HEADER``            nested  request header
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Kernel response contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
 =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +  ``ETHTOOL_A_TS_HEADER``  nested  reply header
> +  ``ETHTOOL_A_TS_LAYER``   u32     available hardware timestamping
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
 =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Please put some words in here :) Documentation matters to the users.

Also let me advertise tools/net/ynl/cli.py to you:
https://docs.kernel.org/next/userspace-api/netlink/intro-specs.html

Please fill in the new commands in the ethtool spec. Feel free to ask
if you have any questions, it's still a bit of a rough.. clay?

> +/* Hardware layer of the SO_TIMESTAMPING provider */
> +enum timestamping_layer {
> +	SOF_MAC_TIMESTAMPING =3D (1<<0),
> +	SOF_PHY_TIMESTAMPING =3D (1<<1),

What does SOF_ stand for? =F0=9F=A4=94=EF=B8=8F

We need a value for DMA timestamps here.

> +/* TSLIST_GET */
> +static int tslist_prepare_data(const struct ethnl_req_info *req_base,
> +			       struct ethnl_reply_data *reply_base,
> +			       struct genl_info *info)
> +{
> +	struct ts_reply_data *data =3D TS_REPDATA(reply_base);
> +	struct net_device *dev =3D reply_base->dev;
> +	const struct ethtool_ops *ops =3D dev->ethtool_ops;
> +	int ret;
> +
> +	ret =3D ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	data->ts =3D 0;
> +	if (phy_has_tsinfo(dev->phydev))
> +		data->ts =3D SOF_PHY_TIMESTAMPING;
> +	if (ops->get_ts_info)
> +		data->ts |=3D SOF_MAC_TIMESTAMPING;

We can't make that assumption, that info must come from the driver.

Also don't we need some way to identify the device / phc from which=20
the timestamp at the given layer will come?
