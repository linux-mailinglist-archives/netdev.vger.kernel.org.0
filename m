Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082A742A367
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236194AbhJLLif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbhJLLie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 07:38:34 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DE7C061570;
        Tue, 12 Oct 2021 04:36:33 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id r18so80037570edv.12;
        Tue, 12 Oct 2021 04:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Cv09Uzz4AMtrdLJZ5UZjOHd8Tiq6ImxAlIz05CK9/+E=;
        b=j5cuUb7Knk/rorV2lZi5Nfo2fyNSQ/i/uvK0eKwXmLappUMuLpS+WAGlqScNr5RZ7T
         OIzOcHTxt7DQbrXra+T1c3f+2tJQu4BKTmgnQYYE8D2W1NXQOsDRfu2cZvrNb20khsQ7
         qEoDVWYvLXIi97FGu2wqZ03eKHBTeTUfVOhGPt0Bg/6AQIQLGnwmUKp3n+UBUvWwuLBV
         Y6jTUUj47O5sNtm1Cg6YhDKc8m03S0rkd3KWLT54UnDugjm4BJBKNskHe1aTxEwCDh92
         lpDenkFBT4eMVwTp1yVvFioTMj2ELsUOSJTOWtLWFGqA5pczMz35CPTX5ElJCDG3SPi9
         3s9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Cv09Uzz4AMtrdLJZ5UZjOHd8Tiq6ImxAlIz05CK9/+E=;
        b=Pvscit3TOWNTIlJ5L4h1lQiM1kiXzrF1NdQy7zQgT3Sm2Z1qxwhYfSdM9Ckxib02uz
         MZBPTw67KF3hBX/+Bji4qtNQ6gRVTfT0ClBwsYX6nCLajHXGND8oJ1+piw4nsQcHD4Dp
         +dDXWDzq1eRVQWt0d+ztWWAJdgIeuQf5XjBeiSIoNwRmPonpAgerZWqEPdMoT+PgCERt
         y/nK1xSusJOAaoIJxLkRer5oiwDobzJ5/b2HaTpRjTsOIoLS7SNA1QdrfxDeIBuLwjlh
         IvF1y2GJJTJptUZ3TWprJAZYsRld0gXq59clZ4SgQi2cM65Xl0+1NG+8usC5nGsaBhYT
         0Z4w==
X-Gm-Message-State: AOAM533eByTaW4wdF0tPGUTPJdlnN1U5RB2QjmlKr8r4ncH+faA786MY
        1iRG1zq9uqqtNMOehmEXArA=
X-Google-Smtp-Source: ABdhPJyrQ4Q5v01yQ5nxsqBMaCaX35lvdjY+e6ybHR5kzLZWQ2xp/Kaw0qkCPTYF0NmeCqpOj3KgLg==
X-Received: by 2002:a50:9b06:: with SMTP id o6mr50396874edi.284.1634038591578;
        Tue, 12 Oct 2021 04:36:31 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id l16sm4715224eje.67.2021.10.12.04.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 04:36:31 -0700 (PDT)
Date:   Tue, 12 Oct 2021 14:36:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: fix spurious error message when
 unoffloaded port leaves bridge
Message-ID: <20211012113630.f4memvtchrgxswti@skbuf>
References: <20211012112730.3429157-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211012112730.3429157-1-alvin@pqrs.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 01:27:31PM +0200, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Flip the sign of a return value check, thereby suppressing the following
> spurious error:
> 
>   port 2 failed to notify DSA_NOTIFIER_BRIDGE_LEAVE: -EOPNOTSUPP
> 
> ... which is emitted when removing an unoffloaded DSA switch port from a
> bridge.
> 
> Fixes: d371b7c92d19 ("net: dsa: Unset vlan_filtering when ports leave the bridge")
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---
>  net/dsa/switch.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index 1c797ec8e2c2..6466d0539af9 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -168,7 +168,7 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
>  		if (extack._msg)
>  			dev_err(ds->dev, "port %d: %s\n", info->port,
>  				extack._msg);
> -		if (err && err != EOPNOTSUPP)
> +		if (err && err != -EOPNOTSUPP)
>  			return err;
>  	}
>  
> -- 
> 2.32.0
> 

Ouch, good catch.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
