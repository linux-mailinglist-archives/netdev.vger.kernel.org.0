Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19B668FDA9
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 04:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbjBIDDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 22:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbjBIDBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 22:01:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816D438013;
        Wed,  8 Feb 2023 18:57:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 210A16186B;
        Thu,  9 Feb 2023 02:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B614FC4339B;
        Thu,  9 Feb 2023 02:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675911469;
        bh=a28hWGAgXHcKzAwvAl61mkMfOBl1pXY4hll/Ho3lNJU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hFGueY1iBFTGzvoCXw8WuYMojfQ7hm/W72zRL2305nodv0mlftmUGZavHgrsI4p9c
         TG5mJ5zSKf6rzrUOpIIJN225l2j2nVRUoKxRulY6qucGkDe2QxVBBvQSOLt7ONNURk
         KXrFIoTiQRzoE2gSh9f90/8Qgke2CQMQV68kCVqLMcHb+//khyYuJ9iUmG28FQq1oI
         sEPqYWPur0GwmuZ8Fdy7H2L1Rw9gWCii0xeNTpmYrmDyuBXY3Ve05uqQjCn2IvxTEv
         z/exISKVOoMgyRHdC2rWmDW2eIQcMKLpPA8yEDhAC+8EmNjBdtHLqsth5lnn11BG4F
         9oHzLIq+aNUuA==
Date:   Wed, 8 Feb 2023 18:57:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jason Xing <kerneljasonxing@gmail.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, richardcochran@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, alexandr.lobakin@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH net 3/3] ixgbe: add double of VLAN header when computing
 the max MTU
Message-ID: <20230208185747.1266ff72@kernel.org>
In-Reply-To: <CAL+tcoBEv6tiAES-JPF4er_bkQWuqZ1m0ouVc19EARCOcaDidQ@mail.gmail.com>
References: <20230204133535.99921-1-kerneljasonxing@gmail.com>
        <20230204133535.99921-4-kerneljasonxing@gmail.com>
        <CAL+tcoD9nE-Ad7+XoshoQ8qp7C0H+McKX=F6xt2+UF1BeWXKbg@mail.gmail.com>
        <CAKgT0Uc7d5iomJnrvPdngt6u9ns7S1ismhH_C2R1YWarg04wWg@mail.gmail.com>
        <CAL+tcoBEv6tiAES-JPF4er_bkQWuqZ1m0ouVc19EARCOcaDidQ@mail.gmail.com>
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

On Thu, 9 Feb 2023 10:22:19 +0800 Jason Xing wrote:
> > It looks like this patch isn't in the patch queue at:
> > https://patchwork.kernel.org/project/netdevbpf/list/
> 
> I got it.
> 
> I have no clue on how patchwork works, I searched the current email,
> see https://patchwork.kernel.org/project/netdevbpf/patch/20230204133535.99921-4-kerneljasonxing@gmail.com/.
> 
> > I believe you will need to resubmit it to get it accepted upstream.

The patches are marked as Awaiting Upstream, that's why they don't show
up. We usually let Tony pick up patches for Intel's drivers rather than
applying directly.
