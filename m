Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1070F664D98
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 21:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbjAJUoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 15:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjAJUoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 15:44:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D013354715
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 12:44:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3574C6174D
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20410C433EF;
        Tue, 10 Jan 2023 20:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673383459;
        bh=nucKswaMYobOWxItav27iPznfXczy1qJyXfbRDqHVvA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WHw3ohWTb8Qf12DxG5bMQl2CqY+PCaA690LWLvqt826vTEiCEa9CgWf0ayO0W5FB+
         WeA0CRcG7cE+C5IWYlt/C6eabvQhZShOTB5GRs7FVci/T+5WkersPwQdlNnHzNOJgP
         /VvoJ5xxPFXAUAALlZrlQcf6z9IB+OafOwmX+i3+jc+MWYRMDQGuvVppkkXu57YTHK
         QkIDU0RwAUC6xAtK9+WnI6H3qvc7TJOgASqAoxi/Y9YkG93kbS8teM2BqA89IlPFIA
         tvXKAzxQjOBuZEp3DSEy51FzIKUmJIFBOZ9ruvpRUiZutswUFOvR6MjU9XgWffswUL
         Pb5wrSYAz3Tcw==
Date:   Tue, 10 Jan 2023 12:44:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Arinzon, David" <darinzon@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH V1 net-next 0/5] Add devlink support to ena
Message-ID: <20230110124418.76f4b1f8@kernel.org>
In-Reply-To: <574f532839dd4e93834dbfc776059245@amazon.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
        <20230109164500.7801c017@kernel.org>
        <574f532839dd4e93834dbfc776059245@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Jan 2023 20:11:23 +0000 Arinzon, David wrote:
> > On Sun, 8 Jan 2023 10:35:28 +0000 David Arinzon wrote: =20
> > > This patchset adds devlink support to the ena driver. =20
> >=20
> > Wrong place, please take a look at
> >=20
> >         struct kernel_ethtool_ringparam::tx_push
> >=20
> > and ETHTOOL_A_RINGS_TX_PUSH. I think you just want to configure the
> > max size of the TX push, right?
>=20
> We're not configuring the max size of the TX push, but effectively the
> maximal packet header size to be pushed to the device.
> This is noted in the documentation on patch 5/5 in this patchset.
> AFAIK, there's no relevant ethtool parameter for this configuration.

Perhaps I should have complained about the low quality of that
documentation to make it clear that I have in fact read it :/

I read it again - and I still don't know what you're doing.
I sounds like inline header length configuration yet you also use LLQ
all over the place. And LLQ for ENA is documented as basically tx_push:

  - **Low Latency Queue (LLQ) mode or "push-mode":**

Please explain this in a way which assumes zero Amazon-specific
knowledge :(

> > The reload is also an overkill, reload should re-register all driver ob=
jects
> > but the devlink instance, IIRC. You're not even unregistering the netde=
v.
> > You should handle this change the same way you handle any ring size
> > changes.
>=20
> The LLQ configuration is different from other configurations set via etht=
ool
> (like queue size and number of queues). LLQ requires re-negotiation
> with the device and requires a reset, which is not performed in the ethto=
ol
> configurations case.

What do you mean when you say that reset is not required in the ethool
configuration case?

AFAIK ethtool config should not (although sadly very often it does)
cause any loss of unrelated configuration. But you can certainly reset
HW blocks or reneg features with FW or whatever else...

> It may be possible to unregister/register the netdev,
> but it is unnecessary in this case, as most of the changes are reflected =
in the
> interface and structures between the driver and the device.
>=20
> > For future reference - if you ever _actually_ need devlink please use t=
he
> > devl_* APIs and take the instance locks explicitly. There has not been a
> > single devlink reload implementation which would get locking right using
> > the devlink_* APIs =F0=9F=98=94=EF=B8=8F =20
>=20
> This operation can happen in parallel to a reset of the device from a dif=
ferent
> context which is unrelated to devlink. Our intention is to avoid such cas=
es,
> therefore, holding the devlink lock using devl_lock APIs will not be suff=
icient.
> The driver holds the RTNL_LOCK in key places, either explicitly or implic=
itly,
> as in ethtool configuration changes for example.

Yeah, which is why you should not be using devlink for this.
