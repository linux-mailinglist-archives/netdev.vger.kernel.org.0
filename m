Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52D14C1F9C
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244792AbiBWX1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235909AbiBWX1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:27:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26745F47
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 15:26:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 885F9B82237
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 23:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE60AC340E7;
        Wed, 23 Feb 2022 23:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645658803;
        bh=K8qVmuGR81WuwphqTueR3ROO2hwNcuJZMy7U27KRpwE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K4zaBx4ZSNv/EWIrr5XNknNCeXQDBRXh59QRfzCKMqXDmmhWY2uR7tkxahcSVVRSo
         onQJ86gLr/GiTR6+uKCcPKoBfDcdin+D6ZqoMaufKw9v51vKowmpdX//RSdh57u679
         DKJBDDP0XHf89AgrKv6pI8rrYhmfuNW7uGPb8tcIt0tUtCG6B/vcyHACO/NEUsuyfR
         BdAa21kbZgfUC402r/5c3BtoIgmhsphZqA6zkguxf1DLLrFjTre7izM1n0VimsrXVN
         AG6m3sPEhKHxa5KSeqQ5zIWZagafYndNbt9M8FgX2hg/Gnl0t1wz0i1QUaxARv/STF
         DuoHQzTYQ0OCQ==
Date:   Wed, 23 Feb 2022 15:26:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net 04/19] net/mlx5: DR, Don't allow match on IP w/o matching
 on full ethertype/ip_version
Message-ID: <20220223152641.2bd501c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220223170430.295595-5-saeed@kernel.org>
References: <20220223170430.295595-1-saeed@kernel.org>
        <20220223170430.295595-5-saeed@kernel.org>
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

On Wed, 23 Feb 2022 09:04:15 -0800 Saeed Mahameed wrote:
> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
>=20
> Currently SMFS allows adding rule with matching on src/dst IP w/o matching
> on full ethertype or ip_version, which is not supported by HW.
> This patch fixes this issue and adds the check as it is done in DMFS.
>=20
> Fixes: 26d688e33f88 ("net/mlx5: DR, Add Steering entry (STE) utilities")
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Reviewed-by: Alex Vesker <valex@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c:605:5: warning: s=
ymbol 'mlx5dr_ste_build_pre_check_spec' was not declared. Should it be stat=
ic?
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c:605:5: warning: n=
o previous prototype for =E2=80=98mlx5dr_ste_build_pre_check_spec=E2=80=99 =
[-Wmissing-prototypes]
  605 | int mlx5dr_ste_build_pre_check_spec(struct mlx5dr_domain *dmn,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
