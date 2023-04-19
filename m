Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7FCE6E8130
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 20:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjDSSYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 14:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbjDSSYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 14:24:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0102E10D9
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 11:24:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98FFE6109A
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 18:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1984C433EF;
        Wed, 19 Apr 2023 18:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681928653;
        bh=cqEyr+NQ1EuXAzbwhz4cdQGv6R5OkSdyKS/l7P6ykek=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gi6BWExXn/aJpCwRuOGbwl2xKH4MupB0qDsSSZKfkCEYeEIB/3k9AzBnxufpVqwFt
         VhZjzvmRt7WWXUsNB03uw6Zl479LaopoEeppHIkQGgh975oj1nz/opSGFoEc6eguyp
         XCCGuY4cdW0+vNOlkVadUT+lam9Sp+N8aaCWO/Xd1ANCxi84fUYf3AxYnJVCBKpzTu
         x6hES/c9yF5Py7pji/yFhyJtC846vaB6RyOk8Ia4X6fHatUrS97sMuzx70BCmVZZAh
         NYy6H1GQemmfyuIybreKBk1ycETYXpoLGUHz+qSktsGWZfvOW0lvyPgDUaogwq3og8
         oMpyAl315r3Ww==
Date:   Wed, 19 Apr 2023 11:24:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <michael.chan@broadcom.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH net-next] page_pool: add DMA_ATTR_WEAK_ORDERING on all
 mappings
Message-ID: <20230419112411.52dc99c8@kernel.org>
In-Reply-To: <0e4f2fe3-1d5e-2a3a-005b-042bc7ef3d9e@intel.com>
References: <20230417152805.331865-1-kuba@kernel.org>
        <0e4f2fe3-1d5e-2a3a-005b-042bc7ef3d9e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Apr 2023 15:49:17 +0200 Alexander Lobakin wrote:
> And you do that 2 days before I send this: [0] :D
> Just jokin' :p

Ha! It's karma for not posting the netlink int stuff, yet :P

> Unconditional weak ordering seems reasonable to me as well. BTW, I've
> seen one driver converted to PP already, which manages DMA mappings on
> its own *solely* because it needs to map stuff with weak ordering =\
> It could be switched to PP builtin map handling thanks to this change
> (-100 locs).

Neat!  I hope it will unblock a number of conversions.
