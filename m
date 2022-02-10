Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6EA4B1006
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 15:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241264AbiBJOQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 09:16:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238997AbiBJOQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 09:16:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA16513B
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 06:16:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83718B82366
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 14:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46795C340EE;
        Thu, 10 Feb 2022 14:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644502600;
        bh=CCasU0l3JP+wHk1alqan47cv0DqOrna5/3r8SYRBgV0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ArWK2UYWEz4sqvdulKljKBjLXXv4eLWfxB74s71fVZA0/bwrxe+n4w4eA38egPbiN
         7gwdwH2lRFbQVTZ59VoXlGuR5sGxQQhK3mktZiwAXY1spdL/ILNLz4+ZGkzd2BobX3
         Lx/jHWaJIv8U4Mokv2RRvyilVJ/ERD1vh0OxUXe5aUXa62/SRPspKGsqgI8lCWII4P
         WbQJYVz1UxPyr7DfWH1WF6pEVxi15TzoeW8mJWsxFe2yHAmaAHnnLAPuDByAvzRTa1
         QFudeKSE5+QXAFdxml+Z+3m/BaF6ki0D7VEq3J1hZa4ijnxzHTfqxyntLbJjH0nKVX
         6vuOx6zfi45Ig==
Date:   Thu, 10 Feb 2022 15:16:35 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [v6] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Message-ID: <20220210151635.4b170f5c@dellmb>
In-Reply-To: <20220210084322.15467-1-holger.brunck@hitachienergy.com>
References: <20220210084322.15467-1-holger.brunck@hitachienergy.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
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

On Thu, 10 Feb 2022 09:43:22 +0100
Holger Brunck <holger.brunck@hitachienergy.com> wrote:

> The mv88e6352, mv88e6240 and mv88e6176  have a serdes interface. This pat=
ch
> allows to configure the output swing to a desired value in the
> phy-handle of the port. The value which is peak to peak has to be
> specified in microvolts. As the chips only supports eight dedicated
> values we return EINVAL if the value in the DTS does not match one of
> these values.
>=20
> CC: Andrew Lunn <andrew@lunn.ch>
> CC: Jakub Kicinski <kuba@kernel.org>
> CC: Marek Beh=C3=BAn <kabel@kernel.org>
> Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com>

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>

Keep in mind that the tx-p2p-amplitude DT property is not merged in DT
yet. I suggest you resend this patch as a series of 2 patches, the
first being the DT patch:
  https://lore.kernel.org/linux-devicetree/20220119131117.30245-1-kabel@ker=
nel.org/
where you should also add Rob's reviewed-by tag, which he sent in
  https://lore.kernel.org/linux-devicetree/YgGBe0BS%2Fd0lOVtU@robh.at.kerne=
l.org/

Marek
