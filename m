Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0335E5A1D46
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 01:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243853AbiHYXmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 19:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiHYXmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 19:42:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0149B7EF4;
        Thu, 25 Aug 2022 16:42:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92152B82ACE;
        Thu, 25 Aug 2022 23:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFF6C433D6;
        Thu, 25 Aug 2022 23:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661470928;
        bh=/Tpql5Yi3qmtZsU+kf66TQjsEE08zYwEWK4hVc8NV4g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SJ0aKlT93VmkeowUMhCTAGUZbrJQR//yctZ7fjyx3y+raY63R8IG5EChjn+fEc4B4
         pA2GNryNwwjuC2T2GQpGsMEkhUfxzL2WjVX95WyRLD4eJip5gNqL7ONVGPaYWRheo4
         Nw56CdZqGa2p8LdcJzWUh5djSoixizu1yj1i3ppM7O27xjhcYlDHNU1RvRRqo/fASx
         n0ErrSzyB1z1BWAjNfJ3ZAA2Q6vjpqKjs6FXoVSxQ76ZQEebiOfNQKcp6Ka86ZK7PU
         XVxNolB23D5NDHSvQLAeUlVKVGa2SG5z9TcHLtDnI2vNapFbWyxeDaXmz2u3GjS0F/
         AdT4Zh2Z0wZlA==
Date:   Thu, 25 Aug 2022 16:42:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Marcus Carlberg <marcus.carlberg@axis.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <kernel@axis.com>,
        Pavana Sharma <pavana.sharma@digi.com>,
        Ashkan Boldaji <ashkan.boldaji@digi.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] net: dsa: mv88e6xxx: support RGMII cmode
Message-ID: <20220825164206.200f564e@kernel.org>
In-Reply-To: <20220826012659.32892fef@thinkpad>
References: <20220822144136.16627-1-marcus.carlberg@axis.com>
        <20220825123807.3a7e37b7@kernel.org>
        <20220826000605.5cff0db8@thinkpad>
        <20220825155140.038e4d12@kernel.org>
        <20220826012659.32892fef@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Aug 2022 01:26:59 +0200 Marek Beh=C3=BAn wrote:
> > Could you explain why? Is there an upstream-supported platform
> > already in Linus's tree which doesn't boot or something? =20
>=20
> If you mean whether there is a device-tree of such a device, they I
> don't think so, because AFAIK there isn't a device-tree with 6393 in
> upstream Linux other than CN9130-CRB.
>=20
> But it is possible though that there is such a device which has
> everything but the switch supported on older kernels, due to this RGMII
> bug.
>=20
> I think RGMII should have been supported on this switch when I send the
> patch adding support for it, and it is a bug that it is not, becuase
> RGMII is supported for similar switches driven by mv88e6xxx driver
> (6390, for example). I don't know why I overlooked it then.
>=20
> Note that I wouldn't consider adding support for USXGMII a fix, because
> although the switch can do it, it was never done with this driver.
>=20
> But if you think it doesn't apply anyway, remove the Fixes tag. This is
> just my opinion that it should stay.

I see, I can only go by our general guidance of not treating omissions=20
as fixes, but I lack the knowledge to be certain what's right here.
Anyone willing to cast a tie-break vote? Andrew? net or net-next?
