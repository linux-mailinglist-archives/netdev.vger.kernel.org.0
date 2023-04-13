Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC456E106C
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjDMOy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjDMOyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:54:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C4D44B9;
        Thu, 13 Apr 2023 07:54:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D96316153B;
        Thu, 13 Apr 2023 14:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83F6C433D2;
        Thu, 13 Apr 2023 14:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681397663;
        bh=1K6whjALxumgxRYYK0wH4JcChq+2mh8I/hWM/ZKSTx0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jh1XJJ5iy1FUDFpLxlvGUY5LeubD6UBVT8j//2eWNW1nmnj80VGWFTgdtYnpbf3eN
         8bEDfxOOLF4jO4cgdbeWRqD84P1fn7B7oslrTPcQce6Yt0by4HZiSATLY+dkacuOSC
         quzUPZUv3V75PENHZavZowcbHyuOyMvzXMl1CvebNi8dOvk8RiD0p58vEfA+LZc+hq
         4Au+tOfydhmrBM/yXv0u1fFD0KVHxwXEtsj5w+5rJ0XUh6D/wDv7CFkxoFGGuo0PGj
         SisKtwy7VmSjYqlQrBZxeZRMadm45np91hj1rz4v2ohjVmkpQU5riKsJkOo3cqsAtg
         4oOIBhSq4gWKQ==
Date:   Thu, 13 Apr 2023 07:54:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Paul Moore <paul@paul-moore.com>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Saeed Mahameed <saeed@kernel.org>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        selinux@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: Potential regression/bug in net/mlx5 driver
Message-ID: <20230413075421.044d7046@kernel.org>
In-Reply-To: <20230410054605.GL182481@unreal>
References: <CAHC9VhQ7A4+msL38WpbOMYjAqLp0EtOjeLh4Dc6SQtD6OUvCQg@mail.gmail.com>
        <ZCS5oxM/m9LuidL/@x130>
        <CAHC9VhTvQLa=+Ykwmr_Uhgjrc6dfi24ou=NBsACkhwZN7X4EtQ@mail.gmail.com>
        <1c8a70fc-18cb-3da7-5240-b513bf1affb9@leemhuis.info>
        <CAHC9VhT+=DtJ1K1CJDY4=L_RRJSGqRDvnaOdA6j9n+bF7y+36A@mail.gmail.com>
        <20230410054605.GL182481@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Apr 2023 08:46:05 +0300 Leon Romanovsky wrote:
> > I haven't seen any updates from the mlx5 driver folks, although I may
> > not have been CC'd? =20
>=20
> We are extremely slow these days due to combination of holidays
> (Easter, Passover, Ramadan, spring break e.t.c).

Let's get this fixed ASAP, please. I understand that there are
holidays, but it's been over 2 weeks, and addressing regressions
should be highest priority for any maintainer! :(

=46rom what I gather all we need here is to throw in an extra condition
for "FW is hella old" into mlx5_core_is_management_pf(), no?
