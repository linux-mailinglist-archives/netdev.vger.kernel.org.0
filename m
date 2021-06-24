Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7A53B36AC
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 21:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbhFXTQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 15:16:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232370AbhFXTQp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 15:16:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3394D611AD;
        Thu, 24 Jun 2021 19:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624562065;
        bh=JYRu7gCiFRFr43rIKlGqbNde445KKY8pbzER54YD0Vc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f9JdPSkqTUjVqFPFrw0Nd9uS0D7aTOQu1GzbQEErVhCOeUdAvL4KUUBowkBznc8eQ
         QnNyAedgHVFS37QRDOQLZ6/juaCdko8nlDIAJM79GtqPjhwC82Ru3fNAJx2sS6n14G
         yOgWBwJtYIOGu25xd6PEDXSDSDXM4k+7FsJSMzDV+PCZc2RmaaV2abq1GGEVpysK9D
         Os4H0NlzWq2qVHmY4NcKfYVencZ/ID5Vetg6svyo4zAv2+wjlurlXeXBIQb5vAKRUN
         gb1h5f6vvHeV5OQbEo+zcbQKYsvV1oxxh0n5hcoC4Y6/N9pNvSHVaCe342iiYa5+OP
         vl6v1Nl1bqZIg==
Date:   Thu, 24 Jun 2021 12:14:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     David Miller <davem@davemloft.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Nathan Chancellor <nathan@kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20210624121424.51d754bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAPv3WKdjE5ywVFB+94invSLg=jG5JHBdvLQLKDTPq13+8PjqmA@mail.gmail.com>
References: <20210624082911.5d013e8c@canb.auug.org.au>
        <CAPv3WKfiL+sR+iK_BjGKDhtNgjoxKEPv49bU1X9_7+v+ytdR1w@mail.gmail.com>
        <YNPt91bfjrgSt8G3@Ryzen-9-3900X.localdomain>
        <CA+G9fYtb07aySOpB6=wc4ip_9S4Rr2UUYNgEOG6i76g--uPryQ@mail.gmail.com>
        <20210624185430.692d4b60@canb.auug.org.au>
        <CAPv3WKf6HguRC_2ckau99d4iWG-FV71kn8wiX9r5wuK335EEFw@mail.gmail.com>
        <3d6ea68a-9654-6def-9533-56640ceae69f@kernel.org>
        <CAPv3WKdjE5ywVFB+94invSLg=jG5JHBdvLQLKDTPq13+8PjqmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Jun 2021 20:15:00 +0200 Marcin Wojtas wrote:
> TL;DR, we need to get rid of a helper routine (introduced so that to
> address review comments of v1), as it causes a depmod cycles when
> fwnode_/of_/acpi_mdio are built as modules.
> It can be done twofold:
> a. 3 commits, i.e:
>   Revert "net: mdiobus: Introduce fwnode_mdbiobus_register()"
>   Revert "net/fsl: switch to fwnode_mdiobus_register"
>   net: mvmdio: resign from fwnode_mdiobus_register
> b. Same diff but squashed.
> 
> Please let me know your preference, so that I can do it properly up front.

Not sure if Dave will notice this mid-thread question. It probably
doesn't matter as long as (1) doesn't introduce further transient 
build failures.
