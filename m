Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CFA292A3E
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 17:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbgJSPVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 11:21:18 -0400
Received: from smtprelay0120.hostedemail.com ([216.40.44.120]:44846 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729538AbgJSPVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 11:21:17 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 4E940837F27E;
        Mon, 19 Oct 2020 15:21:16 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1434:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3871:3872:4321:5007:6737:6738:7576:7903:9040:10004:10400:10450:10455:10848:11232:11657:11658:11914:12043:12048:12297:12555:12740:12760:12895:12986:13069:13311:13357:13439:14181:14659:14721:19904:19999:21080:21627:21990:30012:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: maid96_3f0c95a27238
X-Filterd-Recvd-Size: 2972
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Mon, 19 Oct 2020 15:21:11 +0000 (UTC)
Message-ID: <859112e91c3d221dc599e381dbaecb90dd6467a1.camel@perches.com>
Subject: Re: [PATCH] wireless: remove unneeded break
From:   Joe Perches <joe@perches.com>
To:     Christian Lamparter <chunkeey@gmail.com>, trix@redhat.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        ath9k-devel@qca.qualcomm.com, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        linuxwifi@intel.com, chunkeey@googlemail.com, pkshih@realtek.com,
        sara.sharon@intel.com, tova.mussai@intel.com,
        nathan.errera@intel.com, lior2.cohen@intel.com, john@phrozen.org,
        shaul.triebitz@intel.com, shahar.s.matityahu@intel.com,
        Larry.Finger@lwfinger.net, zhengbin13@huawei.com,
        christophe.jaillet@wanadoo.fr, yanaijie@huawei.com,
        saurav.girepunje@gmail.com
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Date:   Mon, 19 Oct 2020 08:21:10 -0700
In-Reply-To: <b31478ea-979a-1c9c-65db-32325233a715@gmail.com>
References: <20201019150507.20574-1-trix@redhat.com>
         <b31478ea-979a-1c9c-65db-32325233a715@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-19 at 17:14 +0200, Christian Lamparter wrote:
> On 19/10/2020 17:05, trix@redhat.com wrote:
> > From: Tom Rix <trix@redhat.com>
> > 
> > A break is not needed if it is preceded by a return or goto
> > 
> > Signed-off-by: Tom Rix <trix@redhat.com>
> > diff --git a/drivers/net/wireless/intersil/p54/eeprom.c b/drivers/net/wireless/intersil/p54/eeprom.c
> > index 5bd35c147e19..3ca9d26df174 100644
> > --- a/drivers/net/wireless/intersil/p54/eeprom.c
> > +++ b/drivers/net/wireless/intersil/p54/eeprom.c
> > @@ -870,7 +870,6 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
> >   			} else {
> >   				goto good_eeprom;
> >   			}
> > -			break;
> Won't the compiler (gcc) now complain about a missing fallthrough annotation?
> >   		default:
> >   			break;
> >   		}

No, though the code would be clearer like:
---
diff --git a/drivers/net/wireless/intersil/p54/eeprom.c b/drivers/net/wireless/intersil/p54/eeprom.c
index 5bd35c147e19..233fa072d96d 100644
--- a/drivers/net/wireless/intersil/p54/eeprom.c
+++ b/drivers/net/wireless/intersil/p54/eeprom.c
@@ -867,10 +867,8 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 					 "test!\n");
 				err = -ENOMSG;
 				goto err;
-			} else {
-				goto good_eeprom;
 			}
-			break;
+			goto good_eeprom;
 		default:
 			break;
 		}


