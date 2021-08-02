Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8423DD77A
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbhHBNnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233956AbhHBNnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:43:50 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50573C061760;
        Mon,  2 Aug 2021 06:43:39 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id h9so15524441ejs.4;
        Mon, 02 Aug 2021 06:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q3LMLHUiJgMv1kBej5JGB879UzZgEmTMwjmj9nvqpWc=;
        b=gHbazKLYudEs+w+lX0U7K9hhRGdnhsn/KcpXhThORDMW3TyJSP3iStfdLH4IZcD/KE
         dWtA8BrrCZn8gGZ4PS8uDQdZIiHbJLYKoGJ6J2h2u2H2ML+69vEb1Ir0m3Vn14v16SkR
         TKrW5qITrEz9rIvsy5UqEEURLSEredQJhscto4GzmdZ7xQAyEbE8tU+FNVhmh3ML7iUc
         rq6IVBHpcBMisSS9yeOZO9xmcYujWaH/X3hEFGbBBVQ0fWK+3muiSFTPtUMyJSrxEmiV
         4YZ2pNkIB3VO7C1lghjUihRb1VoUWdXDZoIs2GyL/2B9clA6NDLezCKwtqQjDn3iB9rY
         cPJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q3LMLHUiJgMv1kBej5JGB879UzZgEmTMwjmj9nvqpWc=;
        b=meZrvhM8Kqf/7YFDWcXB3JIy5tKYzqZykHBeKKPo90XNtH5L2OGv2ZQXBCNiP4aSa7
         MAqDv+46Rr9r+eialB7hKrkepnwKdLYdwPfFqLuYZx2o4cfJI6pKOMYGrqj1kHGTKLNN
         n5XobwD9mQF1+5fCtwvasYAR7/Vi+AdE2B61EY1Wk1DhR6XWO6UZ19J5FhGmcAf5/NkO
         AQATSsL4ie+eGeoNGVCK2a7rrIxBRUDyrgFoEp7qdGS2abri2C7Y6XyoRC84boUuJ1MT
         AA3+ZqqsCmgBcOzLy8I57S51r+DgQ6lsm0nuiVOn2V7zmL6pH+RDxMlM991FGpJGU+bG
         GEtw==
X-Gm-Message-State: AOAM531pODrNRx7sZSeGwrhQsKdTA0O0+dnL1zXNLJ75m36IvNnL6UgJ
        dUYjcfmkW935OBRPUEtRNUc=
X-Google-Smtp-Source: ABdhPJw6vCmkFlF6kE0P2ErCDImL+4aRsa1VJAzRVkcEAF3Ce6rnneVKlUR57hGKi6X6whoXtcRaRw==
X-Received: by 2002:a17:906:314e:: with SMTP id e14mr3596232eje.165.1627911817933;
        Mon, 02 Aug 2021 06:43:37 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id b2sm6130288edr.16.2021.08.02.06.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 06:43:37 -0700 (PDT)
Date:   Mon, 2 Aug 2021 16:43:36 +0300
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
Subject: Re: [RFC net-next v2 3/4] net: dsa: mt7530: set STP state also on
 filter ID 1
Message-ID: <20210802134336.gv66le6u2z52kfkh@skbuf>
References: <20210731191023.1329446-1-dqfext@gmail.com>
 <20210731191023.1329446-4-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210731191023.1329446-4-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 01, 2021 at 03:10:21AM +0800, DENG Qingfang wrote:
> As filter ID 1 is used, set STP state also on it.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
>  drivers/net/dsa/mt7530.c | 3 ++-
>  drivers/net/dsa/mt7530.h | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 3876e265f844..38d6ce37d692 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1147,7 +1147,8 @@ mt7530_stp_state_set(struct dsa_switch *ds, int port, u8 state)
>  		break;
>  	}
>  
> -	mt7530_rmw(priv, MT7530_SSP_P(port), FID_PST_MASK, stp_state);
> +	mt7530_rmw(priv, MT7530_SSP_P(port), FID_PST_MASK,
> +		   FID_PST(stp_state));
>  }
>  
>  static int
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index a308886fdebc..294ff1cbd9e0 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -181,7 +181,7 @@ enum mt7530_vlan_egress_attr {
>  
>  /* Register for port STP state control */
>  #define MT7530_SSP_P(x)			(0x2000 + ((x) * 0x100))
> -#define  FID_PST(x)			((x) & 0x3)

Shouldn't these macros have _two_ arguments, the FID and the port state?

> +#define  FID_PST(x)			(((x) & 0x3) * 0x5)

"* 5": explanation?

>  #define  FID_PST_MASK			FID_PST(0x3)
>  
>  enum mt7530_stp_state {
> -- 
> 2.25.1
> 

I don't exactly understand how this patch works, sorry.
Are you altering port state only on bridged ports, or also on standalone
ports after this patch? Are standalone ports in the proper STP state
(FORWARDING)?
