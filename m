Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D67611F3F7
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 21:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfLNU2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 15:28:41 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42500 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbfLNU2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 15:28:41 -0500
Received: by mail-pf1-f195.google.com with SMTP id 4so3358342pfz.9
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 12:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=XaEVbBb580dizOkGCrPl3aky5kExYp09pR6s9oLfxlg=;
        b=gV1zMRDtDbnkngwtuQVwVmMdqJd0MOI0fNpU6Ahcqv24gDsTZqN7er/XEdhNFOIG2s
         Xefw1oqnnTQsDc4ng5Cy8vViWduwKTiEG5+r2soBzQ+XgrMccITVnWoUgRcZEvMN0qhF
         SyHwqKAw1126RdW6AkgKomQJestodaeQcGWLNA8Bo1YfcUDcUzm+IjAPhyyqM5sSU/UT
         pJvQh3SP0tVr3+ISCV7EJ15wzggPTmxXP2qAuC9n5g29422zcnRupqNxkgq3N913afDE
         yXlkrVCfPIQ3jUx6d5ySjT1pE0hJJRqikGo7Tf4wmiA88gVODXzbye5eaUYDTV1LIx6W
         hQJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=XaEVbBb580dizOkGCrPl3aky5kExYp09pR6s9oLfxlg=;
        b=gq+Jin3aydFJDTfuqQq2WEHHdTSHwTfTr/0RUh0edcTezWOBkBUHh3VYcP+ybnjzbP
         lXtMc5em5S5laloJtB6B40ssTFrwYThjRHyUX5FMt5aNDZzfPSV0d/A29GefYqlCXHPd
         N9zXuEtQVR7RTs1zRwM3EAyeCSBjNZPtwQPhVeBS/tAzfksUhT5jA+2VXLvWDBXHGhfK
         SDnAi9fgz6ZHjETSeXbEWqiC5l4fd+i03ESUzP7I8oVJ7E0AGr0l/FRNJMyvoI2ZBv/9
         kdC7763Gd6l2EDnegJ0X3CcoR4CPmAyGox33InY0S8JRld+3VQC95WgdInFtqWDFM0YU
         fOaw==
X-Gm-Message-State: APjAAAVzIkcu0ADTHWjBuCg4pQNS9rCCYMNhRlhIdA1D0qnTeyciDb0v
        splWkcGjf0pPqNaJS13Y6c1oNQ==
X-Google-Smtp-Source: APXvYqz7r5mvCKhiJymgkgcgt9xu5gMGoR9VG64DTQi7xuM3hxBSuiZTj0eQuUJtNFn0EbRE+cxYuw==
X-Received: by 2002:a62:6342:: with SMTP id x63mr7050443pfb.103.1576355320580;
        Sat, 14 Dec 2019 12:28:40 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id t63sm16959694pfb.70.2019.12.14.12.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 12:28:40 -0800 (PST)
Date:   Sat, 14 Dec 2019 12:28:37 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: stmmac: Always use TX coalesce timer
 value when rescheduling
Message-ID: <20191214122837.4960adfd@cakuba.netronome.com>
In-Reply-To: <23c0ff1feddcc690ee66adebefdc3b10031afe1b.1576007149.git.Jose.Abreu@synopsys.com>
References: <cover.1576007149.git.Jose.Abreu@synopsys.com>
        <23c0ff1feddcc690ee66adebefdc3b10031afe1b.1576007149.git.Jose.Abreu@synopsys.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 20:54:44 +0100, Jose Abreu wrote:
> When we have pending packets we re-arm the TX timer with a magic value.
> Change this from the hardcoded value to the pre-defined TX coalesce
> timer value.

s/pre-defined/user controlled/ ?

> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
> ---
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index f61780ae30ac..726a17d9cc35 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -1975,7 +1975,7 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
>  
>  	/* We still have pending packets, let's call for a new scheduling */
>  	if (tx_q->dirty_tx != tx_q->cur_tx)
> -		mod_timer(&tx_q->txtimer, STMMAC_COAL_TIMER(10));
> +		mod_timer(&tx_q->txtimer, STMMAC_COAL_TIMER(priv->tx_coal_timer));

I think intent of this code is to re-check the ring soon. The same
value of 10 is used in stmmac_tx_timer() for quick re-check.

tx_coal_timer defaults to 1000, so it's quite a jump from 10 to 1000.

I think the commit message leaves too much unsaid.

Also if you want to change to the ethtool timeout value, could you move 
stmmac_tx_timer_arm() and reuse that helper?

>  
>  	__netif_tx_unlock_bh(netdev_get_tx_queue(priv->dev, queue));
>  

