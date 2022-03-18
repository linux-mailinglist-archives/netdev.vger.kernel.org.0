Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E8B4DE2AD
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240742AbiCRUmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240614AbiCRUmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:42:32 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01D129D264;
        Fri, 18 Mar 2022 13:41:13 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id qa43so19121742ejc.12;
        Fri, 18 Mar 2022 13:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VY2jqJ7MdFEyb/LRjoWT5lFVlR1Ldg3506BtYnGy55w=;
        b=OfylJsAkcB5MxPpvfPw0XinBillTwC20tBlsyVc4uRNfh9FrX/0VnaQ0G+g0e6m9cr
         qiGPJWhkS2VkSym1pwuH1bwcxwvhPTwDcSfpVkHBPCEBm/k/OBoW9ufGIR5y4zjxa7EG
         zPYo95BANDTgiONRtT+nksoHhcUGXOj+C41oeAdIb7En5oMujIxbeX1BoU60xQKRO3d3
         o47NTljilrX5aGxl5DGnFB4N9c8r/fX0ZzFm3cjtkn7v0wCQA010FDEOsDW1770uRHNh
         yavzuExNqAJ+s9shvWTPcF0O2MJKCNuy9NKd/Qc80Q6ttiQghbsUY+2yb808BtgtA9yD
         468A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VY2jqJ7MdFEyb/LRjoWT5lFVlR1Ldg3506BtYnGy55w=;
        b=xQpsR/0BUA84mz6MpumyPa3QAtYR7E1KpwAaLDzzCQ7+t3I69CY806yXb779tCFPWZ
         cILsa7O/s07PV6gFBwY2ZH+uQwEaixr6x7REO0H7DNRDDDaUqz2hFfpp97MqEvmUZLig
         5d5i75SoEUMYx/bed6aTfwkcFlJMrOivVPgvzcnNF+iIGbXJ0mZmRbLyLpkLPTMU1no9
         hidzbTkGiM61Cxk3Hl0wS+UDqUVWqYBuxoftppteITMfwK/o+tYE7lhSmJhSR6OIPkWy
         Go5CMzIvPzvSnAdTgYncYo+SJbnXhRf0Ta/b3Hj+awbp/NLL03+VlQ8mnJ98OmtUs3Ce
         uaNw==
X-Gm-Message-State: AOAM5316ZKg8XKYidVogBVgFX5TYj2L+WtLPzuJTs/N3knQsjibHvvpC
        KwptxDvwqjfCz1cL+/OK9XY=
X-Google-Smtp-Source: ABdhPJxas3d/KlPjD1fs0A9SCiV9Sz5M0ssFLUrfdqZRnpBHGKT6d4p3c3hDLO1d/kiXWY/pfk8O4w==
X-Received: by 2002:a17:907:9720:b0:6db:a7d2:d170 with SMTP id jg32-20020a170907972000b006dba7d2d170mr10999706ejc.187.1647636072247;
        Fri, 18 Mar 2022 13:41:12 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id b5-20020a170906728500b006db8b630ebdsm3982235ejl.209.2022.03.18.13.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 13:41:11 -0700 (PDT)
Date:   Fri, 18 Mar 2022 22:41:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marek Behun <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: Ensure STU support in
 VLAN MSTI callback
Message-ID: <20220318204110.6zmkoa56vxtmgswv@skbuf>
References: <20220318201321.4010543-1-tobias@waldekranz.com>
 <20220318201321.4010543-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318201321.4010543-3-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 09:13:21PM +0100, Tobias Waldekranz wrote:
> In the same way that we check for STU support in the MST state
> callback, we should also verify it before trying to change a VLANs
> MSTI membership.
> 
> Fixes: acaf4d2e36b3 ("net: dsa: mv88e6xxx: MST Offloading")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/mv88e6xxx/chip.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index b36393ba6d49..afb9417ffca0 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2678,6 +2678,9 @@ static int mv88e6xxx_vlan_msti_set(struct dsa_switch *ds,
>  	u8 old_sid, new_sid;
>  	int err;
>  
> +	if (!mv88e6xxx_has_stu(chip))
> +		return -EOPNOTSUPP;
> +
>  	mv88e6xxx_reg_lock(chip);
>  
>  	err = mv88e6xxx_vtu_get(chip, msti->vid, &vlan);
> -- 
> 2.25.1
> 
