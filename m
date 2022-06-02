Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59CEB53BC27
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 18:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236782AbiFBQKx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Jun 2022 12:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233936AbiFBQKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 12:10:52 -0400
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B2E7D21AC5F;
        Thu,  2 Jun 2022 09:10:50 -0700 (PDT)
Received: from smtpclient.apple (p4ff9fc30.dip0.t-ipconnect.de [79.249.252.48])
        by mail.holtmann.org (Postfix) with ESMTPSA id BCA13CED19;
        Thu,  2 Jun 2022 18:10:49 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH v2 1/3] Bluetooth: Add new quirk for broken local ext
 features max_page
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220524212155.16944-2-bage@debian.org>
Date:   Thu, 2 Jun 2022 18:10:49 +0200
Cc:     Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kubakici@wp.pl>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Vasily Khoruzhick <anarsoul@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <78EC62F6-40D5-4E18-B2FA-DA2EB9D67986@holtmann.org>
References: <20220524212155.16944-1-bage@debian.org>
 <20220524212155.16944-2-bage@debian.org>
To:     Bastian Germann <bage@debian.org>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bastian,

> Some adapters (e.g. RTL8723CS) advertise that they have more than
> 2 pages for local ext features, but they don't support any features
> declared in these pages. RTL8723CS reports max_page = 2 and declares
> support for sync train and secure connection, but it responds with
> either garbage or with error in status on corresponding commands.


please include btmon output for the garbage and/or error.

> 
> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> [rebase on current tree]
> Signed-off-by: Bastian Germann <bage@debian.org>
> ---
> include/net/bluetooth/hci.h | 7 +++++++
> net/bluetooth/hci_event.c   | 4 +++-
> 2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index 69ef31cea582..af26e8051905 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -265,6 +265,13 @@ enum {
> 	 * runtime suspend, because event filtering takes place there.
> 	 */
> 	HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL,
> +
> +	/* When this quirk is set, max_page for local extended features
> +	 * is set to 1, even if controller reports higher number. Some
> +	 * controllers (e.g. RTL8723CS) report more pages, but they
> +	 * don't actually support features declared there.
> +	 */
> +	HCI_QUIRK_BROKEN_LOCAL_EXT_FTR_MAX_PAGE,
> };

Can we just call it _BROKEN_LOCAL_EXT_FEATURES_PAGE_2.

Now with that said, is Secure Connections really broken? We need that bit to indicate support for this.

Regards

Marcel

