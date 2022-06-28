Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0AEF55E99D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347011AbiF1Ohp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346842AbiF1Oho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:37:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E402CDF0;
        Tue, 28 Jun 2022 07:37:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 564A361AFA;
        Tue, 28 Jun 2022 14:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610EAC3411D;
        Tue, 28 Jun 2022 14:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656427062;
        bh=8IhwuHf6kLvlJEYrB32nyTk/crpQ/pfgGZRB0YohMio=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZahUBiu5zdhLOZVShpBvz+nFxHnAqAJcObDKJEtatPRJN57dH/pnaloFHG9XP2BKg
         MSD777Kj9eH38plJTFrNNFCzvwX88oofsrKMN7YFzjsUY+uyUyblCNb4/x1uYJKxay
         wB8XUh2RfMOGYLovd3V5z8QwVdLCRlUwd6ebUJnQ=
Date:   Tue, 28 Jun 2022 16:37:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Meng Tang <tangmeng@uniontech.com>
Cc:     stable@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guo-Feng Fan <vincent_fann@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: Re: [PATCH 5.10 1/3] commit 5d6651fe8583 ("rtw88: 8821c: support RFE
 type2 wifi NIC")
Message-ID: <YrsSNGN6fDMtGufl@kroah.com>
References: <20220628133046.2474-1-tangmeng@uniontech.com>
 <YrsSJLqq/ZoKw8MP@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrsSJLqq/ZoKw8MP@kroah.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 04:37:24PM +0200, Greg KH wrote:
> On Tue, Jun 28, 2022 at 09:30:44PM +0800, Meng Tang wrote:
> > From: Guo-Feng Fan <vincent_fann@realtek.com>
> > 
> > RFE type2 is a new NIC which has one RF antenna shares with BT.
> > Update phy parameter to verstion V57 to allow initial procedure
> > to load extra AGC table for sharing antenna NIC.
> > 
> > Signed-off-by: Guo-Feng Fan <vincent_fann@realtek.com>
> > Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> > Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> > Link: https://lore.kernel.org/r/20210202055012.8296-4-pkshih@realtek.com
> > Signed-off-by: Meng Tang <tangmeng@uniontech.com>
> > ---
> >  drivers/net/wireless/realtek/rtw88/main.c     |   2 +
> >  drivers/net/wireless/realtek/rtw88/main.h     |   7 +
> >  drivers/net/wireless/realtek/rtw88/rtw8821c.c |  47 +++
> >  drivers/net/wireless/realtek/rtw88/rtw8821c.h |  14 +
> >  .../wireless/realtek/rtw88/rtw8821c_table.c   | 397 ++++++++++++++++++
> >  .../wireless/realtek/rtw88/rtw8821c_table.h   |   1 +
> >  6 files changed, 468 insertions(+)
> > 
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>

Sorry, no, this is all good, my fault.
