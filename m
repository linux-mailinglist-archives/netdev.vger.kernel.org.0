Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91DA3DF153
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbhHCPYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:24:08 -0400
Received: from smtprelay0095.hostedemail.com ([216.40.44.95]:46410 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236145AbhHCPYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:24:07 -0400
Received: from omf11.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 8D66218225E1F;
        Tue,  3 Aug 2021 15:23:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf11.hostedemail.com (Postfix) with ESMTPA id EAF2D20A29C;
        Tue,  3 Aug 2021 15:23:52 +0000 (UTC)
Message-ID: <ea10a82bfca380bf22856a99bcc695b3fae84152.camel@perches.com>
Subject: Re: [PATCH 2/3][V2] rtlwifi: rtl8192de: make arrays static const,
 makes object smaller
From:   Joe Perches <joe@perches.com>
To:     Colin Ian King <colin.king@canonical.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 03 Aug 2021 08:23:51 -0700
In-Reply-To: <4e1d8a60-0af8-97d5-b95c-7d91502825e5@canonical.com>
References: <20210803144949.79433-1-colin.king@canonical.com>
         <20210803144949.79433-2-colin.king@canonical.com>
         <e07dfde8aa6616887c74817bed1166510b5583dd.camel@perches.com>
         <4e1d8a60-0af8-97d5-b95c-7d91502825e5@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: EAF2D20A29C
X-Spam-Status: No, score=0.11
X-Stat-Signature: b9y4z9jye3c6ejeoj3inmzicfsiu3fwk
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18WLi5dSNuPqYskUZU1WA/ZcFH30DvAWhI=
X-HE-Tag: 1628004232-471034
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-08-03 at 16:15 +0100, Colin Ian King wrote:
> On 03/08/2021 16:09, Joe Perches wrote:
> > On Tue, 2021-08-03 at 15:49 +0100, Colin King wrote:
> > > Don't populate arrays the stack but instead make them static const. Replace
> > > array channel_info with channel_all since it contains the same data as
> > > channel_all. Makes object code smaller by 961 bytes.
> > []
> > > diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> > []
> > > @@ -160,6 +160,15 @@ static u32 targetchnl_2g[TARGET_CHNL_NUM_2G] = {
> > >  	25711, 25658, 25606, 25554, 25502, 25451, 25328
> > >  };
> > > 
> > > +static const u8 channel_all[59] = {
> > 
> > I don't believe there is a significant value in sizing the array
> > as 59 instead of letting the compiler count the elements.
> 
> I was reluctant to remove this as I supposed the original had it in for
> a purpose, e.g. to ensure that the array was not populated with more
> data than intended. Does it make much of a difference?
> 
> > 
> > > +	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
> > > +	36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58,
> > > +	60, 62, 64, 100, 102, 104, 106, 108, 110, 112,
> > > +	114, 116, 118, 120, 122, 124, 126, 128,	130,
> > > +	132, 134, 136, 138, 140, 149, 151, 153, 155,
> > > +	157, 159, 161, 163, 165
> > > +};

Dunno.

Maybe not, but I did have to count the elements to see if
it really was 59 or the compiler was adding trailing 0's.

OK I really did a grep to count the commas and added 1...


