Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AD655B169
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 13:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbiFZLHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 07:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234282AbiFZLHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 07:07:06 -0400
X-Greylist: delayed 182 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 26 Jun 2022 04:07:06 PDT
Received: from mail.as201155.net (mail.as201155.net [185.84.6.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B29E037
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 04:07:05 -0700 (PDT)
Received: from smtps.newmedia-net.de ([2a05:a1c0:0:de::167]:59818 helo=webmail.newmedia-net.de)
        by mail.as201155.net with esmtps  (TLS1) tls TLS_DHE_RSA_WITH_AES_256_CBC_SHA
        (Exim 4.95)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1o5Q3a-0008RK-2p;
        Sun, 26 Jun 2022 13:03:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=newmedia-net.de; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID; bh=XnI9Q3by0BUUWFODoPrHJkxlZ4k9cfSKEiKhN+gic24=;
        b=U7TcO6sQLVTGcG5hcmhwRI50yvKgjH1IPdo5PZUKh09HU2GT0Z5nzS3qk3131WVWaw1x2L0IWENtAfuSDeDCMwr3rRE0TH7NDCmX+AhXxSuELRK8wEoYBl3GseFhDF1QWdM1Ie+xCkF+011vzW7cb5OqSqV6qU/OyGq0XrGegTk=;
Message-ID: <458bd8dd-29c2-8029-20f5-f746db57740a@newmedia-net.de>
Date:   Sun, 26 Jun 2022 13:03:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH] net: wireless/broadcom: fix possible condition with no
 effect
To:     Praghadeesh T K S <praghadeeshthevendria@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     praghadeeshtks@zohomail.in, skhan@linuxfoundation.org
References: <20220625192902.30050-1-praghadeeshthevendria@gmail.com>
From:   Sebastian Gottschall <s.gottschall@newmedia-net.de>
In-Reply-To: <20220625192902.30050-1-praghadeeshthevendria@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Received:  from [81.201.155.134] (helo=[172.21.254.4])
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1o5Q3a-0007e2-HQ; Sun, 26 Jun 2022 13:03:58 +0200
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 25.06.2022 um 21:29 schrieb Praghadeesh T K S:
> Fix a coccinelle warning by removing condition with no possible effect
>
> Signed-off-by: Praghadeesh T K S <praghadeeshthevendria@gmail.com>
> ---
>   drivers/net/wireless/broadcom/b43/xmit.c | 7 +------
>   1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/b43/xmit.c b/drivers/net/wireless/broadcom/b43/xmit.c
> index 7651b1b..667a74b 100644
> --- a/drivers/net/wireless/broadcom/b43/xmit.c
> +++ b/drivers/net/wireless/broadcom/b43/xmit.c
> @@ -169,12 +169,7 @@ static u16 b43_generate_tx_phy_ctl1(struct b43_wldev *dev, u8 bitrate)
>   	const struct b43_phy *phy = &dev->phy;
>   	const struct b43_tx_legacy_rate_phy_ctl_entry *e;
>   	u16 control = 0;
> -	u16 bw;
> -
> -	if (phy->type == B43_PHYTYPE_LP)
> -		bw = B43_TXH_PHY1_BW_20;
> -	else /* FIXME */
> -		bw = B43_TXH_PHY1_BW_20;
> +	u16 bw = B43_TXH_PHY1_BW_20;
Can you check if this is a possible register typo?
>   
>   	if (0) { /* FIXME: MIMO */
>   	} else if (b43_is_cck_rate(bitrate) && phy->type != B43_PHYTYPE_LP) {
