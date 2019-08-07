Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCFA884881
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 11:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387488AbfHGJSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 05:18:12 -0400
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:55584 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727987AbfHGJSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 05:18:11 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id EFB30180A76DC;
        Wed,  7 Aug 2019 09:18:09 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:599:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3873:4321:5007:6742:7901:8603:9707:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12297:12438:12555:12740:12760:12895:12986:13069:13255:13311:13357:13439:14659:14721:21080:21627:30054:30055:30070:30080:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.14.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: joke88_46ef5e8f7f662
X-Filterd-Recvd-Size: 3395
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Wed,  7 Aug 2019 09:18:07 +0000 (UTC)
Message-ID: <e8054867214be2e12f1bbf2c21b62ac041b6cccb.camel@perches.com>
Subject: Re: [PATCH -next] iwlwifi: dbg: work around clang bug by marking
 debug strings static
From:   Joe Perches <joe@perches.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kalle Valo <kvalo@codeaurora.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Date:   Wed, 07 Aug 2019 02:18:06 -0700
In-Reply-To: <20190807051516.GA117639@archlinux-threadripper>
References: <20190712001708.170259-1-ndesaulniers@google.com>
         <874l31r88y.fsf@concordia.ellerman.id.au>
         <3a2b6d4f9356d54ab8e83fbf25ba9c5f50181f0d.camel@sipsolutions.net>
         <CAKwvOdmBeB1BezsGh=cK=U9m8goKzZnngDRzNM7B1voZfh8yWg@mail.gmail.com>
         <20190807051516.GA117639@archlinux-threadripper>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-08-06 at 22:15 -0700, Nathan Chancellor wrote:
> Just for everyone else (since I commented on our issue tracker), this is
> now fixed in Linus's tree as of commit  1f6607250331 ("iwlwifi: dbg_ini:
> fix compile time assert build errors").

I think this change is incomplete and suggest you add this
to remove the use of another const char * format.

---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 4d81776f576d..6b15e2e8cd37 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2593,20 +2593,20 @@ static void iwl_fw_dbg_update_regions(struct iwl_fw_runtime *fwrt,
 {
 	void *iter = (void *)tlv->region_config;
 	int i, size = le32_to_cpu(tlv->num_regions);
-	const char *err_st =
-		"WRT: ext=%d. Invalid region %s %d for apply point %d\n";
 
 	for (i = 0; i < size; i++) {
 		struct iwl_fw_ini_region_cfg *reg = iter, **active;
 		int id = le32_to_cpu(reg->region_id);
 		u32 type = le32_to_cpu(reg->region_type);
 
-		if (WARN(id >= ARRAY_SIZE(fwrt->dump.active_regs), err_st, ext,
-			 "id", id, pnt))
+		if (WARN(id >= ARRAY_SIZE(fwrt->dump.active_regs),
+			 "WRT: ext=%d. Invalid region id %d for apply point %d\n",
+			 ext, id, pnt))
 			break;
 
-		if (WARN(type == 0 || type >= IWL_FW_INI_REGION_NUM, err_st,
-			 ext, "type", type, pnt))
+		if (WARN(type == 0 || type >= IWL_FW_INI_REGION_NUM,
+			 "WRT: ext=%d. Invalid region type %d for apply point %d\n",
+			 ext, type, pnt))
 			break;
 
 		active = &fwrt->dump.active_regs[id];


