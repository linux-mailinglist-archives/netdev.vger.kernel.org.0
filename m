Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B816624B3E
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 21:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbiKJUKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 15:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiKJUKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 15:10:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6445F4731F;
        Thu, 10 Nov 2022 12:10:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECAA461CAD;
        Thu, 10 Nov 2022 20:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5D9C433D6;
        Thu, 10 Nov 2022 20:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668111042;
        bh=LKTc2n4uQlV/mul/XTh+EAmjf65d1hccX3/Wa0wcjKw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JjOHaq+jtgmRyvrsLmym0ZUWNHi/Nb0iOuXRtZ71XO8AdqcgMRuiIEfuo7KE53P4m
         EHNp2FkTNwrfse0xVWboSSVQZuVjNLn7fMG2LgeG7qsvuT8IAs+p5I+Y2wZopAvrrR
         eFjo+Ihfh/fwjpPgsPcaLKbjQeJ/etzUO1m5WBWX3UU1a1DxynN7ppRgfJUoZAxv4a
         //0Yff7r8O+xx2DGgGS4OVUoq5ncEGjDXEz1TtdKwXUZDC+J7+wZ7BQYsO9tpxP8tz
         BOROpmsOnOEVVaUwYXdLgPeO8NIRtM2s0Tq8dU2hQQcasqb2ZPRdCTfDRuipH+ME3q
         nocpNAesv0t0A==
Date:   Thu, 10 Nov 2022 12:10:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, edumazet@google.com,
        longli@microsoft.com, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, shiraz.saleem@intel.com,
        Ajay Sharma <sharmaajay@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [Patch v10 00/12] Introduce Microsoft Azure Network Adapter
 (MANA) RDMA driver
Message-ID: <20221110121040.365fa8a9@kernel.org>
In-Reply-To: <Y2yTIczYumDTPXpu@unreal>
References: <1667502990-2559-1-git-send-email-longli@linuxonhyperv.com>
        <Y2qqq9/N65tfYyP0@unreal>
        <20221108150529.764b5ab8@kernel.org>
        <Y2v2CGEWC70g+Ot+@unreal>
        <20221109120544.135f2ee2@kernel.org>
        <Y2yTIczYumDTPXpu@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Nov 2022 07:58:57 +0200 Leon Romanovsky wrote:
> > > Please pull, I collected everything from ML and created shared branch.
> > > 
> > > The following changes since commit f0c4d9fc9cc9462659728d168387191387e903cc:
> > > 
> > >   Linux 6.1-rc4 (2022-11-06 15:07:11 -0800)
> > > 
> > > are available in the Git repository at:
> > > 
> > >   https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/ mana-shared-6.2
> > > 
> > > for you to fetch changes up to 1e6e19c6e1c100be3d6511345842702a24c155b9:
> > > 
> > >   net: mana: Define data structures for protection domain and memory registration (2022-11-09 20:41:17 +0200)  
> > 
> > 
> > It's not on a common base with net-next.
> > Could you rebase on something that's at or below git merge-base ?  
> 
> Done, I downgraded the branch to be based on -rc3.

Perfect, pulled, I'll push it out once the build goes thru
(there won't be a pw-bot notification).

Thank you!
