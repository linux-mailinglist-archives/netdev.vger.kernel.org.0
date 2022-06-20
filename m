Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932E75521A7
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239827AbiFTP4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiFTP4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:56:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38B31D32F;
        Mon, 20 Jun 2022 08:56:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 601DF6135F;
        Mon, 20 Jun 2022 15:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F51C3411B;
        Mon, 20 Jun 2022 15:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655740610;
        bh=fE37JXcAMLz2dAXCM7dSc6/mFlmPqdR9D8KgCu+rjwE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lcMQ2yXpKRZWL78A5ReWS/rN5uagvR+rTANOMAdGhtigwC+wGQ14oD603RYBa9R6k
         +P8FoleMaDXdcKn11KGTxlh/KlNSE60DTSFRCP/Qwigb4AVNtSI1Wqg47JPIoTa0iH
         2oWx+Hnkh9bg7x2e3elkuzwlGITERySan+GBEuE1STy5g9i+ENv4QQxiSdCEI3p6D6
         VoytEKbrJ+u3SZZUrMoOFYg6u0LZeqCJlnfy+MiC7F5w1EYZ7YuZtdwuQ/cs2CgHEG
         a2fBNdNV4JAPvRyuwrta4KTrP+9mgtxa1W3TP6bgP4lqw1CrVwftUtfAhbyos3ILjV
         kZp/nmy6kMMOg==
Date:   Mon, 20 Jun 2022 08:56:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     jdmason@kudzu.us
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Wentao_Liang <Wentao_Liang_g@163.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/ethernet/neterion/vxge: Fix a
 use-after-free bug in vxge-main.c
Message-ID: <20220620085649.79989775@kernel.org>
In-Reply-To: <165563641313.16837.10425130041626423819.git-patchwork-notify@kernel.org>
References: <20220619141454.3881-1-Wentao_Liang_g@163.com>
        <165563641313.16837.10425130041626423819.git-patchwork-notify@kernel.org>
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

On Sun, 19 Jun 2022 11:00:13 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> Hello:
>=20
> This patch was applied to netdev/net.git (master)
> by David S. Miller <davem@davemloft.net>:
>=20
> On Sun, 19 Jun 2022 22:14:54 +0800 you wrote:
> > The pointer vdev points to a memory region adjacent to a net_device
> > structure ndev, which is a field of hldev. At line 4740, the invocation
> > to vxge_device_unregister unregisters device hldev, and it also releases
> > the memory region pointed by vdev->bar0. At line 4743, the freed memory
> > region is referenced (i.e., iounmap(vdev->bar0)), resulting in a
> > use-after-free vulnerability. We can fix the bug by calling iounmap
> > before vxge_device_unregister.
> >=20
> > [...] =20
>=20
> Here is the summary with links:
>   - drivers/net/ethernet/neterion/vxge: Fix a use-after-free bug in vxge-=
main.c
>     https://git.kernel.org/netdev/net/c/8fc74d18639a
>=20
> You are awesome, thank you!

=F0=9F=98=AD=F0=9F=98=AD=F0=9F=98=AD

Jon, if you care about this driver staying upstream please send=20
a correct fix (on top of this change since it's already merged).
