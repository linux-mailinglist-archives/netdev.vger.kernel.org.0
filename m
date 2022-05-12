Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5055252DD
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356382AbiELQnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356598AbiELQn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:43:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0208263D8C
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 09:43:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A9DD61FD6
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 16:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D68C385B8;
        Thu, 12 May 2022 16:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652373804;
        bh=pKALX6TCNo7TMHVaZTROkQr4T+4sRDpIYMGp2US1+aE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OiZnSRdSzRQnSwZzczaycKgkDlC0fgPFVBqlIg2glbaPNcjEm9lLfV9ghNq9+f+x2
         jtPJkabdv7nLkO3xFgkq7p3/AFkxG4QL++HXEY3gXWSnOiCvgKO0xYJ2Ef8n2TwNNk
         f9vDstKSMyozr7IoIpv1G5/YTyoS8nuufJFVD175rdPVErYuZmmDZX8duKF6eDw2wD
         u4wzdTBn383kPQ63tPYAAb9viKw/3zOtz5EYQJzosIGDEiJIVAMZGNC7hHe1xt46zx
         6sJ0ikUCHSFG6tAsfA8DfMcJBy6NC+kK1Q7ZVATIi2orW24LtOzqwUfTsgl/Z+jr9P
         hq5fOe+a47ayw==
Date:   Thu, 12 May 2022 09:43:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [regression] dpaa2: TSO offload on lx2160a causes fatal
 exception in interrupt
Message-ID: <20220512094323.3a89915f@kernel.org>
In-Reply-To: <20220504080646.ypkpj7xc3rcgoocu@skbuf>
References: <7ca81e6b-85fd-beff-1c2b-62c86c9352e9@leemhuis.info>
        <20220504080646.ypkpj7xc3rcgoocu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 May 2022 08:06:47 +0000 Ioana Ciornei wrote:
> > > Mitigation:
> > > ethtool -K ethX tso off
> > >=20
> > > [reply] [=E2=88=92] Comment 1 kernelbugs@63bit.net 2022-05-02 01:37:0=
6 UTC
> > >=20
> > > I believe this is related to commit 3dc709e0cd47c602a8d1a6747f1a91e97=
37eeed3
> > >  =20
> >=20
> > That commit is "dpaa2-eth: add support for software TSO".
> >=20
> > Could somebody take a look into this? Or was this discussed somewhere
> > else already? Or even fixed? =20
>=20
> I will take a look at it, it wasn't discussed already.

Hi! Any progress on this one? AFAICT this is a new bug in 5.18, would
be great if we can close it in the next week or so, otherwise perhaps
consider disabling TSO by default. maybe?
