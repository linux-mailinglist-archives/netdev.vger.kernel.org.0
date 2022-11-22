Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB152634400
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbiKVSvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbiKVSvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:51:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C898C0BB
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:51:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 10D21CE1EF5
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 18:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0378DC433C1;
        Tue, 22 Nov 2022 18:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669143060;
        bh=3RUlhWEg2K43Vqk2MqC/uajcS35KKQ+Oc8wMuePV39I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o38igfijJTthyRmOyY4eF5OmgPA7JvzlWHDMIBv0FzjQoAPJNkgDunvuDoTESoaPa
         d0sQJScfMwb2x2ZL0ozk0IvL/oO51ER4EK6UlYg3R5MP4iZN5LWhMDiHpUZ7hARmIA
         vCBa4mSdRVFqCqdY3q750FOaeagODo5PTSZzCcj0Lp1B4eBIQG6SVe7QZfzKpIFbrT
         AZ9VQ4DMD9OHTmwlkslCpMRa59BzTI0WSOtav7O+ryp1WtNVh+acHKSq5u2DvdNy/J
         UY4oohYgYWcEBnmoO69PyWVezttYJWSGpN/99UOf1JrQwIHYypyHzOTAbkW6O7vumZ
         ZP2oaf7BHxLnw==
Date:   Tue, 22 Nov 2022 10:50:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>
Subject: Re: [PATCH net-next 0/5] Remove uses of kmap_atomic()
Message-ID: <20221122105059.7ef304ff@kernel.org>
In-Reply-To: <Y3yyf+mxwEfIi8Xm@unreal>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
        <Y3yyf+mxwEfIi8Xm@unreal>
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

On Tue, 22 Nov 2022 13:29:03 +0200 Leon Romanovsky wrote:
> >  drivers/net/ethernet/sun/cassini.c            | 40 ++++++-------------
> >  drivers/net/ethernet/sun/sunvnet_common.c     |  4 +-  
> 
> Dave, Jakub, Paolo
> I wonder if these drivers can be simply deleted.

My thought as well. It's just a matter of digging thru the history,
platform code and the web to find potential users and contacting them. 
