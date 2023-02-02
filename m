Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DDD68862F
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbjBBSQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbjBBSQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:16:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830D55356D;
        Thu,  2 Feb 2023 10:15:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D75161C83;
        Thu,  2 Feb 2023 18:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F91C433D2;
        Thu,  2 Feb 2023 18:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675361758;
        bh=G3bxvNOGrAnML7LXFiqFZvt5gM1/U0tbusvEZ2bH+4g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DhIKRMjatY7cUFvhzm215hYxGrYmtVxvvFEi36tclahYz8fizJzVgFlz5YP+GMyfc
         f7Q34x2cxvpcYpPq9GDDNOS3IaM9ckMhpAFosSlxz4YsBGdMefp/sjwcGulhZCexRk
         U1nzr1mr509B2qQdUN+0VnpOjx6xuov4jqAmCqiDxladbuahEsbhuW27CVbbNOwZhf
         ixVkb6K/cmpp+Zz7AGf0ABOkDFYXI2hXVFdb+lrtTPvRwNvHMtgucroH9WPTZ53K7A
         9yXS+hIKRv0fSuVIyKNukQeT1VqB/o4C/yHbSTtA2Fo1cVAzPMz5t77ElwJX2x5nUF
         6goerugxDbQZQ==
Date:   Thu, 2 Feb 2023 10:15:57 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <Y9v93cy0s9HULnWq@x130>
References: <20230126230815.224239-1-saeed@kernel.org>
 <Y9tqQ0RgUtDhiVsH@unreal>
 <20230202091312.578aeb03@kernel.org>
 <Y9vvcSHlR5PW7j6D@nvidia.com>
 <20230202092507.57698495@kernel.org>
 <Y9v2ZW3mahPBXbvg@nvidia.com>
 <20230202095453.68f850bc@kernel.org>
 <Y9v61gb3ADT9rsLn@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y9v61gb3ADT9rsLn@unreal>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02 Feb 20:03, Leon Romanovsky wrote:
>On Thu, Feb 02, 2023 at 09:54:53AM -0800, Jakub Kicinski wrote:
>> On Thu, 2 Feb 2023 13:44:05 -0400 Jason Gunthorpe wrote:
>> > > You don't remember me trying to convince you to keep the RoCE stuff
>> > > away from our open source IPsec implementation?
>> >
>> > Huh? What does this:
>> >
>> > https://lore.kernel.org/all/cover.1673960981.git.leon@kernel.org/
>> >
>> > Have to do with IPsec?
>>
>> Dunno. But I don't know what it has to do with the PR we're commenting
>> on either..
>
>It has to do, because I need shared branch to put net/mlx5 patches from
>that "special keys" series and I patiently waited for any response.
>

Hi Jakub, in a nutshell, my PR adds the steering rules needed for ipsec
RoCE purely in mlx5 only, ipsec tables are shared between netdev and rdma
It's a reality that mlx5_core is serving both netdev and rdma, it's not
about who has the keys for approving, it's that the fact the mlx5_core is
not just a netdev driver, this is true for all vendors who serve both
worlds it's not just mlx5.


