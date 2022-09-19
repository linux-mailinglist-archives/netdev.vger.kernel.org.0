Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F0D5BD79E
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 00:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiISWtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 18:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiISWtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 18:49:33 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03EAC0B
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:49:28 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id sb3so2024220ejb.9
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=TdQgZepfSKT7JscoXS8u8PgKbm84jBTYyMxoLil2oeI=;
        b=YYAergeh+CMn2t3vmYUcP/PoZtwroosbngrK6yFMEVUWMXNnjVWFuXJIcg4/biOmip
         R4gwVtmJPF/a2k8oEIVdW1sBq32lUP1m6ELU5CSYXu67MZbQ7ec9a1piq4iOTlXAo4Pi
         V/dAbIqVcRMs5t9Y7ouwm1IZCqH+fDiJzV4zEj3RPZIHzJhHKRNz8A7qR3w3gpFiuKmB
         s7230046nL/V5kbA+zVW6ke69n/fErmMVCU5W7cDJnRZZzgv0vOP4S+gpTVB0lhP0Jcw
         /Al9mALkArtSoMsxzNW2xqVKgrlnoLX9LKYme40F9k0WAf4ZBOKqfblc6xRy+dncnsuT
         lqnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=TdQgZepfSKT7JscoXS8u8PgKbm84jBTYyMxoLil2oeI=;
        b=1NZc1zTk8Be+d7HNaoNcwZ1SRn/CJgR6T5SVrkacjAoF4A2oQM+7GNLfYOY73BM6wI
         B9CF3FmRArVR1SvgUlDausLl4d9dkn1TqWu/7b1cLewYFzqIN0wTbPh60w2VeFvDjGk7
         9nDNrZTbxc4hAJ0pR0SnaUUxxDHTz2o8q/itDMYcIT1jGAb5i4H3t5UMuSv8HAm17neB
         lJJq8ocdO2mc+Qz84R/wuNvKgN0dSZIvtdVI+QtSQ5t2DUyxKMxYpxkrZn7cZ5hHXRTN
         zcy2bETM7OFWiVffIZTkK7djF81BSc8BNRTQAwZ62UwDIevOemuZ5PVkmY3HQMP61QKE
         1HgQ==
X-Gm-Message-State: ACrzQf3cevRZtIM3pkQPOdtzxAdp7oMscDeecWX1Yx0jboTfeJtq+IOd
        mBzo0JZIgNQ5M77dG8DoU2M=
X-Google-Smtp-Source: AMsMyM67KHr3n0RW6YQ00xPyzdC6UCdzv1RL8B/7aqwBPj9bAGkMc/sd384aUb6tEh+fP1g1+kUPEQ==
X-Received: by 2002:a17:907:2722:b0:77f:c136:62eb with SMTP id d2-20020a170907272200b0077fc13662ebmr13977608ejl.522.1663627767147;
        Mon, 19 Sep 2022 15:49:27 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id d18-20020a170906305200b0073d81b0882asm16256678ejd.7.2022.09.19.15.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 15:49:26 -0700 (PDT)
Date:   Tue, 20 Sep 2022 01:49:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
Subject: Re: [PATCH net-next v14 5/7] net: dsa: mv88e6xxx: rmu: Add
 functionality to get RMON
Message-ID: <20220919224924.yt7nzmr722a62rnl@skbuf>
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 01:08:45PM +0200, Mattias Forsblad wrote:
> @@ -255,6 +299,15 @@ int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
>  	chip->rmu.smi_ops = chip->smi_ops;
>  	chip->rmu.ds_ops = chip->ds->ops;
>  
> +	/* Change rmu ops with our own pointer */
> +	chip->rmu.smi_rmu_ops = (struct mv88e6xxx_bus_ops *)chip->rmu.smi_ops;
> +	chip->rmu.smi_rmu_ops->get_rmon = mv88e6xxx_rmu_stats_get;

The patch splitting is still so poor, that I can't even complain about
this bug properly, since no one uses this pointer for now (and when it
will be used, it will not be obvious how it's assigned).

In short, it's called like this:

static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
					uint64_t *data)
{
	struct mv88e6xxx_chip *chip = ds->priv;

	chip->smi_ops->get_rmon(chip, port, data);
}

When the switch doesn't support RMU operations, or when the RMU setup
simply failed, "ethtool -S" will dereference a very NULL pointer during
that indirect call, because mv88e6xxx_rmu_setup() is unconditionally
called for every switch during setup. Probably not a wise choice to
start off with the RMU ops for ethtool -S.

Also, not clear, if RMU fails, why we don't make an effort to fall back
to MDIO for that user space request.

> +
> +	/* Also change get stats strings for our own */

Who is "our own", and implicitly, who are they? You'd expect that there
aren't tribalist factions within the same driver.

> +	chip->rmu.ds_rmu_ops = (struct dsa_switch_ops *)chip->ds->ops;
> +	chip->rmu.ds_rmu_ops->get_sset_count = mv88e6xxx_stats_get_sset_count_rmu;
> +	chip->rmu.ds_rmu_ops->get_strings = mv88e6xxx_stats_get_strings_rmu;
> +

Those who cast a const to a non-const pointer and proceed to modify the
read-only structure behind it should go to patchwork arrest for one week.

>  	/* Start disabled, we'll enable RMU in master_state_change */
>  	if (chip->info->ops->rmu_disable)
>  		return chip->info->ops->rmu_disable(chip);
> -- 
> 2.25.1
> 

