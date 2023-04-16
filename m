Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019FB6E389E
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 15:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjDPNYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 09:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDPNYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 09:24:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DF719A6
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 06:24:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF7AE60ED7
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 13:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB89DC433D2;
        Sun, 16 Apr 2023 13:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681651446;
        bh=B4xwpAqF9r1qYOKMR+64Gt44Yh0pv9axRxO26SaYWhs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HCESqNdDfPVwIWGBl4ubebqJpcc7DwNjYqX3OWbhlDotzKYSZy5ddy05ulQ3o+48t
         /4goJGdavQMBe4DFv2bDZknd66kxxylDHGMf/3QRRRdl59fXucrDDGLNiyLJkaHhpS
         3QnxQpgg6BBDc5JdjPwIv1ouA/kzD110X5gFZnS47conaVhIy2/5FFfYjnuSzSvmw4
         6AQkuGm5CtReUlzRdnlRNBajwYS9YQ+YCFzA1xdlAi/o+ij15M6Vgeqj6oEr1kbNT0
         jFa1PqFtqsU7Th3JPML54QGrPPWY/crqEoxQ/WW+LkMfgZFkbzoJ0rkHx1YnqZcsqr
         aZE+UEcj9C/9Q==
Date:   Sun, 16 Apr 2023 16:24:01 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] r8169: use new macro
 netif_subqueue_maybe_stop in rtl8169_start_xmit
Message-ID: <20230416132401.GE15386@unreal>
References: <f07fd01b-b431-6d8d-bd14-d447dffd8e64@gmail.com>
 <69c2eec2-d82c-290a-d6ce-fba64afb32c6@gmail.com>
 <20230416102058.GC15386@unreal>
 <1ea8c541-2f96-9a01-4355-fb0c98ddcdac@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ea8c541-2f96-9a01-4355-fb0c98ddcdac@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 16, 2023 at 01:33:11PM +0200, Heiner Kallweit wrote:
> On 16.04.2023 12:20, Leon Romanovsky wrote:
> > On Sat, Apr 15, 2023 at 09:22:11AM +0200, Heiner Kallweit wrote:
> >> Use new net core macro netif_subqueue_maybe_stop in the start_xmit path
> >> to simplify the code. Whilst at it, set the tx queue start threshold to
> >> twice the stop threshold. Before values were the same, resulting in
> >> stopping/starting the queue more often than needed.
> >>
> >> v2:
> >> - ring doorbell if queue was stopped
> > 
> > Please put changelog under "---" markup, below tags section.
> > 
> I know that this would be the standard. IIRC Dave once requested to
> make the change log part of the commit message.

I can imagine how it was useful before lore.kernel.org appeared.

Thanks

> 
> > Thanks
> > 
> 
