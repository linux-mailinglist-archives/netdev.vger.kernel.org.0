Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A0F6B528F
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 22:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbjCJVJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 16:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbjCJVJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 16:09:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13640117FDB
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 13:09:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1DB3B8240E
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 21:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43323C433EF;
        Fri, 10 Mar 2023 21:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678482590;
        bh=lcWm3bCwfmka0fL5dMP9S6TcF+Mg7nvgIsTWVa+jdSY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=RVTLMssjCJ/8m8qqRSvW0hY1JXc0gcgXLnxsu1+tECxqmr0z12qa4tmnlB7/Ii3Zl
         9lip6htgVnfDVAFqH981vDD6cUydiZe2vSebok70oVUuui93Q6ZttingwPhuQ/BruN
         v4Y5ha7ULDfsuQYOsCYnzJFw6Md5+qUqY1qM9cTCpJKpKaJzYPo9V7AJxdmvC7EFnO
         SVOAE958R0i1BbRngLaImFDFZ/PVnRlXQTsqb1d5a/YVjkeAX47Ntin2NdnvznVV6y
         aBqQkXBMcMbOjdTN3/3dl3Z+pD/0Np6Hab5RZYFVCs+Jx9vns8dUn08WGh/P0M6jsJ
         a9PPbZDcUtkxw==
Date:   Fri, 10 Mar 2023 15:09:48 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC 4/6] r8169: prepare rtl_hw_aspm_clkreq_enable for
 usage in atomic context
Message-ID: <20230310210948.GA1280141@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a21451a7-dce8-7647-fed3-7615aaa64c9f@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 25, 2023 at 10:46:05PM +0100, Heiner Kallweit wrote:
> Bail out if the function is used with chip versions that don't support
> ASPM configuration. In addition remove the delay, it tuned out that

turned out?

> it's not needed, also vendor driver r8125 doesn't have it.
