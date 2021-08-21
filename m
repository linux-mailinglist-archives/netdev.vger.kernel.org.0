Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212163F390D
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 08:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbhHUGjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 02:39:10 -0400
Received: from smtprelay0040.hostedemail.com ([216.40.44.40]:60072 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230375AbhHUGjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 02:39:08 -0400
Received: from omf06.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 30C2E2BC08;
        Sat, 21 Aug 2021 06:38:28 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf06.hostedemail.com (Postfix) with ESMTPA id A72232448BB;
        Sat, 21 Aug 2021 06:38:26 +0000 (UTC)
Message-ID: <26432fc6c0afbd2a17619bf17c25d77dfbd6ba35.camel@perches.com>
Subject: Re: [PATCH] rsi: make array fsm_state static const, makes object
 smaller
From:   Joe Perches <joe@perches.com>
To:     Colin King <colin.king@canonical.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 20 Aug 2021 23:38:25 -0700
In-Reply-To: <20210819125018.8577-1-colin.king@canonical.com>
References: <20210819125018.8577-1-colin.king@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: A72232448BB
X-Spam-Status: No, score=-0.82
X-Stat-Signature: 9jyqhky7owqidfg78pank9cf5x9si1eb
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX194m+IktJXozDKaIBjkIauE3xQZZLgErZ8=
X-HE-Tag: 1629527906-454354
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-08-19 at 13:50 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the array fsm_state on the stack but instead it
> static const. Makes the object code smaller by 154 bytes:
[]
> diff --git a/drivers/net/wireless/rsi/rsi_91x_debugfs.c b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
[]
> @@ -117,7 +117,7 @@ static int rsi_stats_read(struct seq_file *seq, void *data)
>  {
>  	struct rsi_common *common = seq->private;
>  
> -	unsigned char fsm_state[][32] = {
> +	static const unsigned char fsm_state[][32] = {

why not the even smaller with a defconfig

	static const char * const fsm_state[] = {

>  		"FSM_FW_NOT_LOADED",
>  		"FSM_CARD_NOT_READY",
>  		"FSM_COMMON_DEV_PARAMS_SENT",


