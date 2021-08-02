Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82E73DD77E
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbhHBNo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233863AbhHBNoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:44:25 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D35BC061760;
        Mon,  2 Aug 2021 06:44:13 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id h9so15526948ejs.4;
        Mon, 02 Aug 2021 06:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zZ7rhldZ+cdc9EqfS9Eva0TvOjm8dfvenVKVtcg422Y=;
        b=IwbZ6B+pF47Xng1s78mPiBUYaQ5aBKg3wm/z8Zf+dRDnd9JHqCPeZeSzfgBLfgz3Pb
         kzwakyr7T0qbulvNT2eSNH0cuOZhn5PBMOTRHBas9FrrjhvKTAz868D/W8Ag3Toue/ku
         o6jkzQpVcaJW922zxSaKshF62ZnI7FfDbD4Q78D9w/PiMHRZHtdk1f0urAMDer7wxQYr
         pBn1MSW8X4mVo/0msyUj5KRWENimLDq9FJelqpMvGyyO4jz1HHrHKn6cZ9XMC/owXE6K
         WPXn2665pW5/qU+KKW/gVMGz12PC/DOytMgmM7lTJHIR6gCt+FoZ8HPe0aQXYlwXdqba
         l28w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zZ7rhldZ+cdc9EqfS9Eva0TvOjm8dfvenVKVtcg422Y=;
        b=t+Q9wpskjfzmUeUxtG9eK46aznexWPx1kb3xXjnJB2V+McXvHg7dftTLvCU8r9RnNH
         ZxXYMxK2pb6mI1A5wFYHJnRw1OufZKZzPfoOIWraWak5aDPI6O1ZVnWGLglK2fekM+vH
         ffPfggndKFclThV69b/QedrjE7OCpOF+jsXOyNSObS2LgPBKXLeg2+aQO4tcmnukk2j+
         /E9EObv+SksrOgo6WWxe8qYG6fXFPKWz8YBPOx9GMg3HLmB3/BrehRn1y0TLhYU+6PUT
         kUEL6TiiF3T8JMSvxkndfFlx9gZQnXDHcvjaHWRHrZi3iiNTCgmePhgzD/dNV2W3yKL+
         AGGg==
X-Gm-Message-State: AOAM533IBHQRRwGxDjfXU+9REYIzZUlNMZ8wccOoGJgd/GQgsJ01P/hm
        QQ4uXswvESCxl6DwIb0Q20s=
X-Google-Smtp-Source: ABdhPJwts+YudSRSXy9pRi3a8kYt31p4mHowDXQpv05buLyULTEyz+FI7GaE1wMik/sIkdeWkeZIfQ==
X-Received: by 2002:a17:907:9d4:: with SMTP id bx20mr15480021ejc.123.1627911851716;
        Mon, 02 Aug 2021 06:44:11 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id p23sm6267915edw.94.2021.08.02.06.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 06:44:11 -0700 (PDT)
Date:   Mon, 2 Aug 2021 16:44:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Woudstra <ericwouds@gmail.com>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [RFC net-next v2 4/4] Revert "mt7530 mt7530_fdb_write only set
 ivl bit vid larger than 1"
Message-ID: <20210802134409.dro5zjp5ymocpglf@skbuf>
References: <20210731191023.1329446-1-dqfext@gmail.com>
 <20210731191023.1329446-5-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210731191023.1329446-5-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 01, 2021 at 03:10:22AM +0800, DENG Qingfang wrote:
> This reverts commit 7e777021780e9c373fc0c04d40b8407ce8c3b5d5.
> 
> As independent VLAN learning is also used on VID 0 and 1, remove the
> special case.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
>  drivers/net/dsa/mt7530.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 38d6ce37d692..d72e04011cc5 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -366,8 +366,7 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
>  	int i;
>  
>  	reg[1] |= vid & CVID_MASK;
> -	if (vid > 1)
> -		reg[1] |= ATA2_IVL;
> +	reg[1] |= ATA2_IVL;
>  	reg[2] |= (aging & AGE_TIMER_MASK) << AGE_TIMER;
>  	reg[2] |= (port_mask & PORT_MAP_MASK) << PORT_MAP;
>  	/* STATIC_ENT indicate that entry is static wouldn't
> -- 
> 2.25.1
> 

Would you mind explaining what made VID 1 special in Eric's patch in the
first place?
