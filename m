Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BED4951FA
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 17:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346846AbiATQFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 11:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243622AbiATQFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 11:05:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71815C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 08:05:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 119DC61489
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 16:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346BDC340E0;
        Thu, 20 Jan 2022 16:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642694732;
        bh=0zMDqwFAuUx2L6+v4Tw1OZQ3oNgRhx2F5+aBc0FwTAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MUrKPIWtBL+xArWSDC7UbspiixELXCQS5wk/8CM5FvXm6iHMDHeYNET/W3eVlVGGV
         JDSXU2krEXX6qWPRfy4fVk8s8g1KlDGJysnhgc4IWlGxGRBAiifRLcI+wOoO6vDqCj
         6DjnaIvCDnn21jSJkeAAIH3Y37lUOCMermmh0ND5dpKdUKw1hHfstZUeqn64R8DMkf
         olao/kqZ3kQOzjK+rGwuzYcUC/+0qqArx/VzLs4ktAGqTDMfYi0RAwcn0iCliztpaC
         Ayw6BLmY5KSgdoohy/U4hD0lmEs6MTc60wnvFvpavj0Z8Wzq1I+eQeJOZORLwi2Qay
         PAwQclbY33Clg==
Date:   Thu, 20 Jan 2022 08:05:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net] tcp: Add a stub for sk_defer_free_flush()
Message-ID: <20220120080530.69cbbcf2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CANn89iK=2cxKC+8AFEu_QbANd1-LU+aUxNOfPvrjVJT5-e0ubA@mail.gmail.com>
References: <20220120123440.9088-1-gal@nvidia.com>
        <CANn89iK=2cxKC+8AFEu_QbANd1-LU+aUxNOfPvrjVJT5-e0ubA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jan 2022 04:39:19 -0800 Eric Dumazet wrote:
> On Thu, Jan 20, 2022 at 4:34 AM Gal Pressman <gal@nvidia.com> wrote:
> > When compiling the kernel with CONFIG_INET disabled, the
> > sk_defer_free_flush() should be defined as a nop.
> >
> > This resolves the following compilation error:
> >   ld: net/core/sock.o: in function `sk_defer_free_flush':
> >   ./include/net/tcp.h:1378: undefined reference to `__sk_defer_free_flush'  
> 
> Yes, this is one way to fix this, thanks.

Yeah.. isn't it better to move __sk_defer_free_flush and co. 
out of TCP code?
