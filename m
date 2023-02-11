Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC93A692C25
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 01:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBKAhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 19:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBKAhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 19:37:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C6454554;
        Fri, 10 Feb 2023 16:36:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80765B82683;
        Sat, 11 Feb 2023 00:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25130C433D2;
        Sat, 11 Feb 2023 00:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676075765;
        bh=ZR6UHnSLhkZTwincKhA1MwfDs6shVQ3sA7iUWeLSg7c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LoJDmA9NpPYPeViPKE+6CkePtp8MU75aTgNbGzcFGBfOdovTDs0UZbLRxP4Eq82/t
         Uq6XDivwcjSA8XaSNGy783XUN3ROnDTCd/V3ScwoSfuCpuOhCbjzaVkPY6CiFLSLrl
         a8xwaj7iMon36wx34p0DejTunup8I2OarIw5Ys+UoPgDfsqyTkzfreyluOYLBnDZea
         jebiYP/2QwEPKacDYijJcJMB0Kk9V6Vg8DUFo76TAeaPjwzW+e1MMTu36vubXKwCsj
         AwT95tvfFjCESrJ9jzV/VnOwfxtXrSU8eRSymsttZQvJUUPP6/p4nhoHLVdokOf01y
         MBmg3ZXflefcQ==
Date:   Fri, 10 Feb 2023 16:36:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <saeedm@nvidia.com>, <richardcochran@gmail.com>,
        <tariqt@nvidia.com>, <linux-rdma@vger.kernel.org>,
        <maxtram95@gmail.com>, <naveenm@marvell.com>,
        <bpf@vger.kernel.org>, <hariprasad.netdev@gmail.com>
Subject: Re: [net-next Patch V4 0/4] octeontx2-pf: HTB offload support
Message-ID: <20230210163602.08d1ce5f@kernel.org>
In-Reply-To: <20230210111051.13654-1-hkelam@marvell.com>
References: <20230210111051.13654-1-hkelam@marvell.com>
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

On Fri, 10 Feb 2023 16:40:47 +0530 Hariprasad Kelam wrote:
> octeontx2 silicon and CN10K transmit interface consists of five
> transmit levels starting from MDQ, TL4 to TL1. Once packets are
> submitted to MDQ, hardware picks all active MDQs using strict
> priority, and MDQs having the same priority level are chosen using
> round robin. Each packet will traverse MDQ, TL4 to TL1 levels.
> Each level contains an array of queues to support scheduling and
> shaping.
> 
> As HTB supports classful queuing mechanism by supporting rate and
> ceil and allow the user to control the absolute bandwidth to
> particular classes of traffic the same can be achieved by
> configuring shapers and schedulers on different transmit levels.

Please provide or link to some user-facing documentation under
Documentation/networking/device_drivers/ethernet/marvell/octeon...
