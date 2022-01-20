Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30543495249
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 17:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347042AbiATQZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 11:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347124AbiATQZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 11:25:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CDFC06173F
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 08:25:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AB3A6147A
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 16:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5541FC340E7;
        Thu, 20 Jan 2022 16:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642695914;
        bh=zeD07rISmB5eNLSg0w1Q5+H0KfEmIPW+7opPNrOljXQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=THy5mWlG2C0w2XQ67Q02JcDb+NCWShQ+iZ+dSZ5Q06nKlDGqYS24SF4CpS9TFoqBe
         K8iqD4wzbPNmGVlZ9W87KSrvdc2Vj5pW4AUem25tHF5S3e/aXp4sP7QdwguxEdzb5I
         dQSzCUkqKQ613b9FnFOe2u8yZ4GldcQHZXFICgePb5xyjMobaYioPb3qSAqeD9NoPL
         wz5On2chNm8VmJmxBZe5khSDeD47KLFmxSHZPV2CoG3h2L2N/sHqyl58qoySCMQeZQ
         Pn4gYPb0r4EYtM3rFrZkRhCAB/k9jG91rZ0y+RmuG79e7iNAxgYn3T94pVVViqFCgW
         /VaoRB8rC1wjg==
Date:   Thu, 20 Jan 2022 08:25:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net] tcp: Add a stub for sk_defer_free_flush()
Message-ID: <20220120082513.46b401ba@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CANn89iJ79Zt0eOjdr96GE1dtaO-7e-+0wT54Sa7Q-q-2fzsjtg@mail.gmail.com>
References: <20220120123440.9088-1-gal@nvidia.com>
        <CANn89iK=2cxKC+8AFEu_QbANd1-LU+aUxNOfPvrjVJT5-e0ubA@mail.gmail.com>
        <20220120080530.69cbbcf2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CANn89iJ79Zt0eOjdr96GE1dtaO-7e-+0wT54Sa7Q-q-2fzsjtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jan 2022 08:13:24 -0800 Eric Dumazet wrote:
> On Thu, Jan 20, 2022 at 8:05 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 20 Jan 2022 04:39:19 -0800 Eric Dumazet wrote:  
> > > Yes, this is one way to fix this, thanks.  
> >
> > Yeah.. isn't it better to move __sk_defer_free_flush and co.
> > out of TCP code?  
> 
> sk->defer_list is currently only fed from tcp_eat_recv_skb(),
> I guess we can leave the code, until we have another user than TCP ?

I was mostly thinking of a way to avoid the #ifdef-inery
but I guess it's not too bad
