Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B6633C75E
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 21:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbhCOUDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 16:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbhCOUDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 16:03:14 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6F3C06174A;
        Mon, 15 Mar 2021 13:03:14 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id x7so7279436pfi.7;
        Mon, 15 Mar 2021 13:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4Go4PTA7wIYrW2Nafn8vquSQ2REdIl3hiShJgeKtl+8=;
        b=jXJF+bq3kVD20zt2PHA264DWtOpqLhyzr6Tn2V19Mi1t6d59kZ7wqpOP/oGlHMLBUq
         6ofsQYTDy9dfpiy3agJspezufFdcKOYPRLum9E3oYmuh/EDom0qsgHDoOqVt5RGpydwL
         LpfL8rMj3Aq2AsBS4PibK/Te3w5p1Zkj0J7w+j89DdoECMDVGEIjkvJAOK8eRfWphuEm
         KfOVhip/fdfEW6G9mjkRGxE1uQi0FcDMknvIvobXEWR1EDaxzURoilAHwYau2kKf7PLr
         WKi6Kzgg95N8Fpzu0Zztwp3TEfnm/esOjYLVUovwfOSZmgKxMXDC5ueJd8w2AgPutaJc
         9PUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Go4PTA7wIYrW2Nafn8vquSQ2REdIl3hiShJgeKtl+8=;
        b=KwDRYPMSbybtrI6oy46DYiM0KxsCGne6T9QpHsBR72SW5B2MIi8xkvGx4WCeim9KqE
         Z0aJMxUlXfUfcoQfSKLYnEg18c2OEHSHwnzu4HYs7R7t1ildFchOX9EnlCl8l60iWV4Q
         aoKGAZ+GFggQAR0SBjwn1FajF0GAPZuGN1Xw4j8hfd/sa/ysK5ucnSidmnDUvZTkIjTQ
         E8/harDuB33zIFGV8UxRlr2OvPNKrofyikgEhxY+m5xbJE65oxvtH9JAw7aR0TCHr9Q3
         V6b0ttBhnukQhQtI0OLM7m43/06CHO8+xU7lhOTdOrj8kYtkHtlhN0W1t+UWwnzPIlKc
         x5CQ==
X-Gm-Message-State: AOAM533reTUkN+V8ZiZ0EDEG3p/PcRax2/6ApI24WsiGPy3xNRaTssHP
        VuG4jWm8G/f+7TO94TK2Yz24f2X9pXw=
X-Google-Smtp-Source: ABdhPJzRDLUtvo3tFtmTJYpTgjzZmWysMq4AB+CfaFho70CldVEH2zBVzppudCPfxABSy1hAwV0vlg==
X-Received: by 2002:a62:ddd2:0:b029:1f1:533b:b1cf with SMTP id w201-20020a62ddd20000b02901f1533bb1cfmr25393858pff.56.1615838594083;
        Mon, 15 Mar 2021 13:03:14 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i14sm459765pjh.17.2021.03.15.13.03.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 13:03:13 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: mt7530: support MDB and bridge flag
 operations
To:     DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>
References: <20210315170940.2414854-1-dqfext@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <892918f1-bee6-7603-b8e1-3efb93104f6f@gmail.com>
Date:   Mon, 15 Mar 2021 13:03:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315170940.2414854-1-dqfext@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/15/2021 10:09 AM, DENG Qingfang wrote:
> Support port MDB and bridge flag operations.
> 
> As the hardware can manage multicast forwarding itself, offload_fwd_mark
> can be unconditionally set to true.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> Changes since RFC:
>   Replaced BR_AUTO_MASK with BR_FLOOD | BR_LEARNING
> 
>  drivers/net/dsa/mt7530.c | 124 +++++++++++++++++++++++++++++++++++++--
>  drivers/net/dsa/mt7530.h |   1 +
>  net/dsa/tag_mtk.c        |  14 +----
>  3 files changed, 122 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 2342d4528b4c..f765984330c9 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1000,8 +1000,9 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
>  	mt7530_write(priv, MT7530_PVC_P(port),
>  		     PORT_SPEC_TAG);
>  
> -	/* Unknown multicast frame forwarding to the cpu port */
> -	mt7530_rmw(priv, MT7530_MFC, UNM_FFP_MASK, UNM_FFP(BIT(port)));
> +	/* Disable flooding by default */
> +	mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK,
> +		   BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) | UNU_FFP(BIT(port)));

It's not clear to me why this is appropriate especially when the ports
operated in standalone mode, can you expand a bit more on this?
-- 
Florian
