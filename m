Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 937D83157C
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 21:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbfEaTlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 15:41:19 -0400
Received: from smtprelay0192.hostedemail.com ([216.40.44.192]:36847 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726808AbfEaTlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 15:41:19 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id C6BDE1801BD6A;
        Fri, 31 May 2019 19:41:17 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:69:355:379:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1544:1593:1594:1605:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4605:5007:7576:7875:7904:7974:9036:9592:10004:10848:11026:11232:11233:11473:11657:11658:11914:12043:12048:12151:12296:12438:12555:12740:12760:12895:13153:13161:13228:13229:13439:14181:14659:14721:21080:21451:21627:30003:30012:30054:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:26,LUA_SUMMARY:none
X-HE-Tag: cork99_626698073144d
X-Filterd-Recvd-Size: 5611
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Fri, 31 May 2019 19:41:16 +0000 (UTC)
Message-ID: <b4cb2a0c12110b6e47900926551c81cd9652e3c4.camel@perches.com>
Subject: Re: [PATCH] rtlwifi: remove redundant assignment to variable k
From:   Joe Perches <joe@perches.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Colin King <colin.king@canonical.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 31 May 2019 12:41:14 -0700
In-Reply-To: <14372bed-6522-d81c-7d68-04adc0d71193@lwfinger.net>
References: <20190531141412.18632-1-colin.king@canonical.com>
         <14372bed-6522-d81c-7d68-04adc0d71193@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-05-31 at 12:29 -0500, Larry Finger wrote:
> On 5/31/19 9:14 AM, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > The assignment of 0 to variable k is never read once we break out of
> > the loop, so the assignment is redundant and can be removed.
> > 
> > Addresses-Coverity: ("Unused value")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >   drivers/net/wireless/realtek/rtlwifi/efuse.c | 4 +---
> >   1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
> > index e68340dfd980..83e5318ca04f 100644
> > --- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
> > +++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
> > @@ -117,10 +117,8 @@ u8 efuse_read_1byte(struct ieee80211_hw *hw, u16 address)
> >   						 rtlpriv->cfg->
> >   						 maps[EFUSE_CTRL] + 3);
> >   			k++;
> > -			if (k == 1000) {
> > -				k = 0;
> > +			if (k == 1000)
> >   				break;
> > -			}
> >   		}
> >   		data = rtl_read_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CTRL]);
> >   		return data;
> 
> Colin,
> 
> Your patch is not wrong, but it fails to address a basic deficiency of this code 
> snippet - when an error is detected, there is no attempt to either fix the 
> problem or report it upstream. As the data returned will be garbage if this 
> condition happens, we might as well replace the "break" with "return 0xFF", as 
> well as deleting the "k = 0" line. Most of the callers of efuse_read_1byte() 
> ignore the returned result when bits 0 and 4 are set, thus returning all 8 bits 
> is not a bad fixup.
> 
> My suspicion is that this test is in the code merely to prevent an potential 
> unterminated "while" loop, and that this condition is extremely unlikely to happen.
> 
> Larry

The function is also overly verbose with many
unnecessary rtlpriv->cfg->maps dereferences.

I'd've written it more like:
---
 drivers/net/wireless/realtek/rtlwifi/efuse.c | 57 +++++++++++-----------------
 1 file changed, 22 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
index e68340dfd980..db253f45e87d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
@@ -87,46 +87,33 @@ void efuse_initialize(struct ieee80211_hw *hw)
 u8 efuse_read_1byte(struct ieee80211_hw *hw, u16 address)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 data;
 	u8 bytetemp;
 	u8 temp;
-	u32 k = 0;
-	const u32 efuse_len =
-		rtlpriv->cfg->maps[EFUSE_REAL_CONTENT_SIZE];
-
-	if (address < efuse_len) {
-		temp = address & 0xFF;
-		rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CTRL] + 1,
-			       temp);
-		bytetemp = rtl_read_byte(rtlpriv,
-					 rtlpriv->cfg->maps[EFUSE_CTRL] + 2);
-		temp = ((address >> 8) & 0x03) | (bytetemp & 0xFC);
-		rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CTRL] + 2,
-			       temp);
-
-		bytetemp = rtl_read_byte(rtlpriv,
-					 rtlpriv->cfg->maps[EFUSE_CTRL] + 3);
-		temp = bytetemp & 0x7F;
-		rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CTRL] + 3,
-			       temp);
+	int k = 0;
+	u32 *maps = rtlpriv->cfg->maps;
+	const u32 efuse_len = maps[EFUSE_REAL_CONTENT_SIZE];
 
-		bytetemp = rtl_read_byte(rtlpriv,
-					 rtlpriv->cfg->maps[EFUSE_CTRL] + 3);
-		while (!(bytetemp & 0x80)) {
-			bytetemp = rtl_read_byte(rtlpriv,
-						 rtlpriv->cfg->
-						 maps[EFUSE_CTRL] + 3);
-			k++;
-			if (k == 1000) {
-				k = 0;
-				break;
-			}
-		}
-		data = rtl_read_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CTRL]);
-		return data;
-	} else
+	if (address >= efuse_len)
 		return 0xFF;
 
+	temp = address & 0xFF;
+	rtl_write_byte(rtlpriv, maps[EFUSE_CTRL] + 1, temp);
+	bytetemp = rtl_read_byte(rtlpriv, maps[EFUSE_CTRL] + 2);
+	temp = ((address >> 8) & 0x03) | (bytetemp & 0xFC);
+	rtl_write_byte(rtlpriv, maps[EFUSE_CTRL] + 2, temp);
+
+	bytetemp = rtl_read_byte(rtlpriv, maps[EFUSE_CTRL] + 3);
+	temp = bytetemp & 0x7F;
+	rtl_write_byte(rtlpriv, maps[EFUSE_CTRL] + 3, temp);
+
+	bytetemp = rtl_read_byte(rtlpriv, maps[EFUSE_CTRL] + 3);
+	while (!(bytetemp & 0x80)) {
+		bytetemp = rtl_read_byte(rtlpriv, maps[EFUSE_CTRL] + 3);
+		if (++k >= 1000)
+			return 0xFF;	/* Likely defect */
+	}
+
+	return rtl_read_byte(rtlpriv, maps[EFUSE_CTRL]);
 }
 EXPORT_SYMBOL(efuse_read_1byte);
 

