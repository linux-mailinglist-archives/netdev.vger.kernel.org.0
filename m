Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D583452F5B5
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 00:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbiETWeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 18:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbiETWeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 18:34:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5029816F925
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 15:34:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA15B61D84
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 22:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA45C385A9;
        Fri, 20 May 2022 22:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653086055;
        bh=DbazlJRizFZJpl6+kV15LEW7YI6oKNVAYZmeWUdZguo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=arEB1a1GgT+3brLyr5OFhU2w2r+fMfAjbHNZJnTGCX5eDRU18HSdgRHRPC2Y6Q/4X
         wd2ctSdCJCnnAtxrieJ4umUHMOIa1taspcKkP2DBXGgTYbIQdrG6kMh8XHdE+EpprV
         erc3pV0Xh2eia9ZCtnjcWmbSRbuKLCcCLV3pvcwxEB0vTl612Be5g04B4HVMUl4q33
         eoKtxhXQsweEprdPyBBiKy6NH4hWR+BdYRoMmk2ybF+9AaLGIwbV+zpYWoZvPMcLjd
         duqhsseg74do/Jx9Z0uZ71gz/KQoeg0QzFxs7PWcQsgi9GIip+b0EFT9LZQGEXH5S1
         Vq/tLaD/M9NHA==
Date:   Fri, 20 May 2022 15:34:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, vladimir.oltean@nxp.com,
        po.liu@nxp.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v5 00/11] ethtool: Add support for frame
 preemption
Message-ID: <20220520153413.16c6830b@kernel.org>
In-Reply-To: <20220520011538.1098888-1-vinicius.gomes@intel.com>
References: <20220520011538.1098888-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 May 2022 18:15:27 -0700 Vinicius Costa Gomes wrote:
> Changes from v4:
>  - Went back to exposing the per-queue frame preemption bits via
>    ethtool-netlink only, via taprio/mqprio was seen as too much
>    trouble. (Vladimir Oltean)
>  - Fixed documentation and code/patch organization changes (Vladimir
>    Oltean).

First of all - could you please, please, please rev these patches more
than once a year? It's really hard to keep track of the context when
previous version was sent in Jun 2021 :/

I disagree that queue mask belongs in ethtool. It's an attribute of 
a queue and should be attached to a queue. The DCBNL parallel is flawed
IMO because pause generation is Rx, not Tx. There is no Rx queue in
Linux, much less per-prio.
