Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAEA6E86AA
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 02:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjDTAlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 20:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDTAlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 20:41:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B904199F;
        Wed, 19 Apr 2023 17:41:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9677641A3;
        Thu, 20 Apr 2023 00:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56ECEC433EF;
        Thu, 20 Apr 2023 00:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681951308;
        bh=Lbl1z861LIR5O8tVQwbaa4PU0A1DuxY+uoYSNtOxsBg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yv/xJRKv0vWLlwwR7lcAjEjff6EHOv6gbsQd9zB9oxWgZKE2wcqfkcW6AvIzLSF+t
         6x3yT5kkklnRs6GMgJy02bqMHDjzaZ/MuTPpupokCQv8go1T1/Ks9WynkO5XpmWIaW
         Rbp+glK9hNcP6kSbWfO1ufQciBcvK8pJvI1IPYBSPMB3WNpA8l5wPqHsNS6H8qgmEA
         DeWIrWtM/96zeizwOUvRmYNd0L65t6Xjhqfu+kA44s/WNaH290R890OgNb4ix+gI5n
         KAslLpSSdR1FNy9ce48irx6D2V32NfP9WE2w3kJR3aGrUnkLYFNcbhcs+eV9rhtN3F
         qE3AZ4f+jD5/A==
Date:   Wed, 19 Apr 2023 17:41:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH net-next v2] net: dsa: mt7530: fix support for MT7531BE
Message-ID: <20230419174146.5f797abb@kernel.org>
In-Reply-To: <ZECFvFnhW1D3IRxO@makrotopia.org>
References: <ZDvlLhhqheobUvOK@makrotopia.org>
        <ZECFvFnhW1D3IRxO@makrotopia.org>
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

On Thu, 20 Apr 2023 01:22:20 +0100 Daniel Golle wrote:
> This v2 submission addresses the comments made by Jesse Brandeburg
> regarding zero-initializing regmap_config as we are now not necessarily
> using both of them. Comments by Ar=C4=B1n=C3=A7 =C3=9CNAL have also been =
discussed
> and resulting in receiving Ack.
>=20
> However, I can see in patchwork that the patch has been set to
> "Changes Requested".
>=20
> Can someone please tell me which further changes are needed?
> I don't see any other comments on the mailing list or patchwork.

Someone mis-categorized :( I was keeping an eye, tho, so it wouldn't
have gotten lost.

Applied now, thanks!
