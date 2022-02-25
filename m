Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E034C4414
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240322AbiBYL7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240336AbiBYL7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:59:41 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBB324FA0D
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 03:59:09 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id s24so7074021edr.5
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 03:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A8MOvybH/XG+/ItdrKiakVlozyRPMn5roF1Ns/R0IR4=;
        b=YYZgel2OY3Q1YNuI6aov7VvUbQVQjGZUU9Wr9cwp5qq+AzLAKKsbb41GErDx2HT/8P
         LmvyOU4yCaMFna1ZZ8ShIcIAELTs2e0u2VFkLq8Xri9xpSUkcoZxZtWOXoRElpDUX++4
         ionHyK/ip0hDPI3O/jZaoJkUya2YqTeyoCVQ4pZiea+J5fH9qB165/PiK4KlXsRIUg/O
         R8W6jgol0bnN1X3xcNYwN/+qc0Yo9khBzKFoeB+GY0k9DLdLagXPVsl/FTc/KnDBb8fa
         Qydili07xYbGUVAITknWr1z/HzBTpwryDDdx4KXYq/alZRVeiTWzQ1zETcFbVRbm7xSd
         O2og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A8MOvybH/XG+/ItdrKiakVlozyRPMn5roF1Ns/R0IR4=;
        b=gYlgLFF9oa/1U5lYfd2zjnytce8fCnMwwK6e7Xc5GT8e8j5FnawCnZa3eGw/1/+uy9
         +UmTqE5XuWHzKG7EU0JJveh+IDMNCKlvpGBfFj8UdxNoCujAw2IhGKl1p9FzSPR2Z6++
         C7peYl7a03edOHKUH3nckLNtzWvFTE976zykweLUygBRChIGv/noT1bqfDfOQcc9Bo75
         uTPqb7DNbN29q23MyP/CaiNVy6LY9KnvL4win9RizuoLjRQnjW5t+uzwfWC4A7gt1D3J
         PTjrHblwlIcE5L3ImUQA96s9wbdzjc0QP1ohUqGe7kbPC2TP2+s+l0q0eqS9pliCFI/D
         DORw==
X-Gm-Message-State: AOAM532ZSOA4nbvLKE4NpFfotkass9vEZYe5tdkxoanaK22NHFrJ5D+e
        9rI2tG5xKmJM4R0LqmuiMuY=
X-Google-Smtp-Source: ABdhPJxW+JPZPRqIaxSb2IKywdzhrM/rnGeV2GhOXyui9VQcnKJc+8gi/5HiScu9L9KRttoVLw2exw==
X-Received: by 2002:a05:6402:3715:b0:410:a415:fd95 with SMTP id ek21-20020a056402371500b00410a415fd95mr6854496edb.288.1645790340208;
        Fri, 25 Feb 2022 03:59:00 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id q7-20020a170906540700b006d5eca5c9cfsm916373ejo.191.2022.02.25.03.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 03:58:59 -0800 (PST)
Date:   Fri, 25 Feb 2022 13:58:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/6] net: dsa: sja1105: populate
 supported_interfaces
Message-ID: <20220225115858.6hwi4e55fjkgqzs5@skbuf>
References: <YhjDvsSC1gZAYF74@shell.armlinux.org.uk>
 <E1nNZCc-00Ab1Q-Kg@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nNZCc-00Ab1Q-Kg@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 11:56:02AM +0000, Russell King (Oracle) wrote:
> Populate the supported interfaces bitmap for the SJA1105 DSA switch.
> 
> This switch only supports a static model of configuration, so we
> restrict the interface modes to the configured setting.
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>                                Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

These all appear on the same line, can you please fix and resend?
