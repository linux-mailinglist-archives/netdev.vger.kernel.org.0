Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0005246AFDC
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbhLGBjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:39:24 -0500
Received: from smtprelay0085.hostedemail.com ([216.40.44.85]:45274 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S245126AbhLGBhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:37:04 -0500
Received: from omf16.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 85202180C90A1;
        Tue,  7 Dec 2021 01:33:33 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf16.hostedemail.com (Postfix) with ESMTPA id 0575020013;
        Tue,  7 Dec 2021 01:33:31 +0000 (UTC)
Message-ID: <4687b01640eaaba01b3db455a7951a534572ee31.camel@perches.com>
Subject: Re: [PATCH 2/2] wilc1000: Fix missing newline in error message
From:   Joe Perches <joe@perches.com>
To:     David Mosberger-Tang <davidm@egauge.net>,
        Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 06 Dec 2021 17:33:31 -0800
In-Reply-To: <20211206232709.3192856-3-davidm@egauge.net>
References: <20211206232709.3192856-1-davidm@egauge.net>
         <20211206232709.3192856-3-davidm@egauge.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.15
X-Stat-Signature: 8bqdyedpz4yoww9akyuzxcqrgq4dq96r
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 0575020013
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19KqkTmYMT9AtNrzFXMDk/6tAZEH4UH4q0=
X-HE-Tag: 1638840811-253715
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-12-06 at 23:27 +0000, David Mosberger-Tang wrote:
> Add missing newline in pr_err() message.
[]
> diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
[]
> @@ -27,7 +27,7 @@ static irqreturn_t isr_uh_routine(int irq, void *user_data)
>  	struct wilc *wilc = user_data;
>  
>  	if (wilc->close) {
> -		pr_err("Can't handle UH interrupt");
> +		pr_err("Can't handle UH interrupt\n");

Ideally this would use wiphy_<level>:

		wiphy_err(wilc->wiphy, "Can't handle UH interrupt\n");


