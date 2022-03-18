Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14654DE2AA
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240731AbiCRUmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240614AbiCRUmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:42:02 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E525F2878BA;
        Fri, 18 Mar 2022 13:40:43 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bi12so19246660ejb.3;
        Fri, 18 Mar 2022 13:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PZyCMpbXfKil8o3Z7LdiohffBw1mFEblgosRKWLTARg=;
        b=bcF3u0G/qVEZaaZgoBtgSTK2n14JRWqFODRDZwyQIY0U9klMaQ7xZOvcLNoo8tMnZv
         vBd9ZJ+rE2AY7MmyOi/x8UfAx9v4/whrLVmYsA4PCVP1E6nsLoRGeax7hfmv0Xvwoyl0
         iwqQBgQKpIgGmNqs/BC1PXs7pLQt8OPB9wxJGp6RIB2Ztiv6kKePfjSWd7e5Vy6lNpW8
         MSbbKiWFtIBjDQ6x8LmLTTwlDdiQBpXUcuFt17bYixGlq2837Owk7/PFRc31H+kbaHmm
         jzxM6kZEIT3Ct1uctCcWGLkR6oTmmnvgOdEchMLbX4/DzNRL9n3d8Gu/WPZ0SzH4DYyy
         T03A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PZyCMpbXfKil8o3Z7LdiohffBw1mFEblgosRKWLTARg=;
        b=NgudLbKDAEOSDYr8E1ug6OiXTznQ4hD4FHJbW5yGLrxExQDfHS69fn2fZtB+cgGGlX
         ghZ+p4Dnr1cAoR63OT9qkeWVQeX70HFiFYk3DN0HO6M6k/FNXjR1v5Uo1JkaXRSM/usv
         j2LUmgRllffrJZm7CdqdZFpqVG4cf+fpvpkzdwk88BWfrS9JJ1k5m454s8MrO5eNwctB
         B55I2scWsTx0JcfYLswxaHJ1k8dtKXW5p2JTFICWvv7yTaB1ObBCUA4fDeDQy2zKiQp+
         YvSWtyPfBp04j15ekHyqsx5LcxD2VeGlk6YXju+j/Ci0EIwDVmnWqTWtcXPSBCyXAJK7
         XOcg==
X-Gm-Message-State: AOAM531oUVVgkYOOXCKpiwWQ09k7wywU3yHIbyDrdjzDQdpTiipsw2YF
        zFbMSVvzfqZzP0kbdwCiAo4/TED8qK4=
X-Google-Smtp-Source: ABdhPJzfI7MwoIStv+UoNapo2wR4fRHf8XJWE54djrMj8Gl2SyM226myvmwAmlyjs1Aa892yxmfaKw==
X-Received: by 2002:a17:907:7284:b0:6df:9120:d935 with SMTP id dt4-20020a170907728400b006df9120d935mr9351313ejc.276.1647636042317;
        Fri, 18 Mar 2022 13:40:42 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id b14-20020a1709063f8e00b006ae0a666c02sm4074178ejj.96.2022.03.18.13.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 13:40:41 -0700 (PDT)
Date:   Fri, 18 Mar 2022 22:40:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Require ops be
 implemented to claim STU support
Message-ID: <20220318204040.nx5zt2x37t4uzqwh@skbuf>
References: <20220318201321.4010543-1-tobias@waldekranz.com>
 <20220318201321.4010543-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220318201321.4010543-2-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 09:13:20PM +0100, Tobias Waldekranz wrote:
> Simply having a physical STU table in the device doesn't do us any
> good if there's no implementation of the relevant ops to access that
> table. So ensure that chips that claim STU support can also talk to
> the hardware.
> 
> This fixes an issue where chips that had a their ->info->max_sid
> set (due to their family membership), but no implementation (due to
> their chip-specific ops struct) would fail to probe.
> 
> Fixes: 49c98c1dc7d9 ("net: dsa: mv88e6xxx: Disentangle STU from VTU")
> Reported-by: Marek Behún <kabel@kernel.org>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

(with the mention that Marek's problem is probably still not solved)

>  drivers/net/dsa/mv88e6xxx/chip.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index 6a0b66354e1d..5e03cfe50156 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -730,7 +730,9 @@ struct mv88e6xxx_hw_stat {
>  
>  static inline bool mv88e6xxx_has_stu(struct mv88e6xxx_chip *chip)
>  {
> -	return chip->info->max_sid > 0;
> +	return chip->info->max_sid > 0 &&
> +		chip->info->ops->stu_loadpurge &&
> +		chip->info->ops->stu_getnext;
>  }
>  
>  static inline bool mv88e6xxx_has_pvt(struct mv88e6xxx_chip *chip)
> -- 
> 2.25.1
> 
