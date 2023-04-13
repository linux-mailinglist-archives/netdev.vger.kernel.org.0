Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB756E05D7
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 06:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjDMERv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 00:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjDMERW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 00:17:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209CF83C0
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 21:15:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD915629B4
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 04:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1462C433EF;
        Thu, 13 Apr 2023 04:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681359315;
        bh=0p5LsJfZuJwXmF2n9TQsrA0fEvpP3fGgxjjpOr1ML0U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T8DMM8xCWh5ZCE4mRVCj7u9WgGCAvVBS/OXIRoa9ZrdpNMJ9pZw3kePHIA+gmg6WO
         Xn/dfp4xGttQVGM6Ukeln4xL/K+PxceYTuUPOe+JZZxfa2iFUTwCqzIjIdfp9k5how
         t4YC3BzseafEby8nOPS7+6CVgKrOyMLtbTrUMW9zobFc0Vz03jrriYw0Urny++NVk3
         e2/DDynhiaArNLsGwqW9O/LhELBcWYH2POiiS6paSQ9j0IHb+RYrnwWOO12uqERmtQ
         YqaSyvlZMadn5BtCRO6L/juV1eKdPHFUyQesh6UwN2sjKAfWQYCU8sWQY/DV92npPS
         OVhv8huyVYr7A==
Date:   Wed, 12 Apr 2023 21:15:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Corinna Vinschen <vinschen@redhat.com>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        alexandre.torgue@foss.st.com, Jose Abreu <joabreu@synopsys.com>
Subject: Re: [PATCH net-next] net: stmmac: propagate feature flags to vlan
Message-ID: <20230412211513.2d6fc1f7@kernel.org>
In-Reply-To: <20230411130028.136250-1-vinschen@redhat.com>
References: <20230411130028.136250-1-vinschen@redhat.com>
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

On Tue, 11 Apr 2023 15:00:28 +0200 Corinna Vinschen wrote:
> stmmac_dev_probe doesn't propagate feature flags to VLANs.  So features
> like TX offloading don't correspond with the general features and it's
> not possible to manipulate features via ethtool -K to affect VLANs.

Actually, could you add to the commit message a sentence or two about
the features that you tested and/or a mention of the manual indicating
that they are supported over vlans? Especially TSO on a quick look.
I just realized now that you didn't explicitly say that those features
work, just that you can manipulate them...
