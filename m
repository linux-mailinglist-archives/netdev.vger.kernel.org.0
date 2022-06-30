Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6A156191E
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 13:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbiF3L2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 07:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234843AbiF3L2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 07:28:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3087DDEC;
        Thu, 30 Jun 2022 04:28:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3E45B82A1A;
        Thu, 30 Jun 2022 11:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DA7C34115;
        Thu, 30 Jun 2022 11:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656588484;
        bh=NIK2828kMHCRILpoHQ9phPRN0eeJFygUQc2X+t1mCWk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rgJ51x9kOVYx445VJUF7VaC/Jwm2Lg5/K/NB2v1yrzFM/dFHleNub+TYe1DTMvzn7
         0FowU6Rj43HUsq3ebVVSGLTcYy3vpL8x1L0JTCiNE2hUdnfH9+mOIGdxdRcBO/kcCI
         Kmc4QAqZA44g2JmZdWl+yb7fPr9a9VCXiYyxFPrA=
Date:   Thu, 30 Jun 2022 13:28:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Meng Tang <tangmeng@uniontech.com>
Cc:     stable@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guo-Feng Fan <vincent_fann@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: Re: [PATCH 5.10 v2 1/3] commit 5d6651fe8583 ("rtw88: 8821c: support
 RFE type2 wifi NIC")
Message-ID: <Yr2Iwn53KqdSSU6V@kroah.com>
References: <20220628134351.4182-1-tangmeng@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628134351.4182-1-tangmeng@uniontech.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 09:43:49PM +0800, Meng Tang wrote:
> From: Guo-Feng Fan <vincent_fann@realtek.com>
> 
> RFE type2 is a new NIC which has one RF antenna shares with BT.
> Update phy parameter to verstion V57 to allow initial procedure
> to load extra AGC table for sharing antenna NIC.
> 
> Signed-off-by: Guo-Feng Fan <vincent_fann@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> Link: https://lore.kernel.org/r/20210202055012.8296-4-pkshih@realtek.com
> Signed-off-by: Meng Tang <tangmeng@uniontech.com>
> ---
>  drivers/net/wireless/realtek/rtw88/main.c     |   2 +
>  drivers/net/wireless/realtek/rtw88/main.h     |   7 +
>  drivers/net/wireless/realtek/rtw88/rtw8821c.c |  47 +++
>  drivers/net/wireless/realtek/rtw88/rtw8821c.h |  14 +
>  .../wireless/realtek/rtw88/rtw8821c_table.c   | 397 ++++++++++++++++++
>  .../wireless/realtek/rtw88/rtw8821c_table.h   |   1 +
>  6 files changed, 468 insertions(+)

How does this meet the stable kernel rules?

This looks like new hardware support to me, right?  What bugfix does
this resolve for 5.10 kernels?

And for newer support, why can you not just move to 5.15?

confused,

greg k-h
