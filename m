Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D15F15AD44
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 17:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbgBLQXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 11:23:13 -0500
Received: from mail27.static.mailgun.info ([104.130.122.27]:63748 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727361AbgBLQXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 11:23:13 -0500
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2020 11:21:35 EST
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581524592; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=zJskcSQLL84R/a3/Q1iH01qdPucMx4GgSmjyfRstz9w=;
 b=xc868N6qgzqBgU26P9ZBOT44nJf/7pHpGVsc9EQ1qPp3rPSrG2OSAnlR17u/g2X5jPuWU1Db
 7qK8kjpZbSfQ6dCe8CZJO4RdgdHco4esoMJuyIeWbmVfgXNfSC1f3IBPDs+t7zLxO1fud4SN
 hBheP+iOaJqy6F40cizRUF8Gxcw=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e442670.7f2b884a3ca8-smtp-out-n02;
 Wed, 12 Feb 2020 16:23:12 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 218B1C4479C; Wed, 12 Feb 2020 16:23:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 365C5C433A2;
        Wed, 12 Feb 2020 16:23:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 365C5C433A2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw88: 8822[bc]: Make tables const,
 reduce data object size
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <4ba111ba18f14f0630cc550b58dbe5dbc82a48ac.camel@perches.com>
References: <4ba111ba18f14f0630cc550b58dbe5dbc82a48ac.camel@perches.com>
To:     Joe Perches <joe@perches.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200212162311.218B1C4479C@smtp.codeaurora.org>
Date:   Wed, 12 Feb 2020 16:23:11 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> Reduce the data size 2kb or 3kb by making tables const.
> Add const to pointer declarations to make compilation work too.
> 
> (x86-64 defconfig)
> $ size drivers/net/wireless/realtek/rtw88/rtw8822?.o*
>    text	   data	    bss	    dec	    hex	filename
>   25054	    672	      8	  25734	   6486	drivers/net/wireless/realtek/rtw88/rtw8822b.o.new
>   23870	   1872	      8	  25750	   6496	drivers/net/wireless/realtek/rtw88/rtw8822b.o.old
>   53646	    828	      0	  54474	   d4ca	drivers/net/wireless/realtek/rtw88/rtw8822c.o.new
>   52846	   1652	      0	  54498	   d4e2	drivers/net/wireless/realtek/rtw88/rtw8822c.o.old
> 
> (x86-64 allyesconfig)
> $ size drivers/net/wireless/realtek/rtw88/rtw8822?.o*
>    text	   data	    bss	    dec	    hex	filename
>   45811	   6280	    128	  52219	   cbfb	drivers/net/wireless/realtek/rtw88/rtw8822b.o.new
>   44211	   7880	    128	  52219	   cbfb	drivers/net/wireless/realtek/rtw88/rtw8822b.o.old
>  100195	   8128	      0	 108323	  1a723	drivers/net/wireless/realtek/rtw88/rtw8822c.o.new
>   98947	   9376	      0	 108323	  1a723	drivers/net/wireless/realtek/rtw88/rtw8822c.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Acked-by: Yan-Hsuan Chuang <yhchuang@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

d49f2c5063fd rtw88: 8822[bc]: Make tables const, reduce data object size

-- 
https://patchwork.kernel.org/patch/11368195/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
