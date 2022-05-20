Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB1852E808
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 10:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347376AbiETItZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 04:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347134AbiETItU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 04:49:20 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D969C3D2C;
        Fri, 20 May 2022 01:49:19 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id c12so9899185eds.10;
        Fri, 20 May 2022 01:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=IRMc7mO9nIDeOflTl9Xa+9r7kaQgstMDRI3MgnS2PV8=;
        b=S48eLzjy8Nqn+oUhXutVfWGCxydZuimj+WWfRkkDNQdVjTYRCZfJkYu5kmz2nZwHW1
         FcBsGGUaP8Jq26S5nnsU8WiXaTedmbS3C7ek8W7GLhHs2O1obar2deQxRF4VtUH0Iprr
         lthO2r6R1ryrmnRLnCCT6eM1fNE7wxVmLR6Gzj+HZqAS2xMxqQ57jtWqy/IlihMIghz7
         BiP+D1QxgXD/Gg28lGMU4fa/cn+9Ag7OCID7gPA8mpYaUtITx/dIres8oyKtpYDet+ow
         y1USCgpjRj/YtsiKSJ2nxkUm327bU2MYGQ3ncxBRr9mexXgkuYD1y3f357q1nxOTybI3
         zueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=IRMc7mO9nIDeOflTl9Xa+9r7kaQgstMDRI3MgnS2PV8=;
        b=xJJyjKDJ918TauF5aOE/xnHQUqX3LUJGxid+f3YxwHAJ/T8znOo3TSGag88I0Ji2F2
         0k5+6SFLGqi0s380Co4Q/WxQ9tTaYsZntROiMHvrzNKOQYSkPdt6WgqjzgVFbSAN/tXD
         h+X6KTd0twsCYOurqIHNDMqXGzxKnY7/uawG/x0FvHpZp0oQHzZzImEY8Kh+0Wp8Zj2e
         XhD1zw4O+WBL5csyL1qs1r9BB932F4AKDWPWfsJp7Z+uKGX+fmoNqjY077oViBHqaznk
         HrveetobntKx+K8JwbI6I4QSnIl7Iu0XC3C1G5Ugr6nLlXSDPXjjM+CVGsAUQJKt6d/T
         SMSQ==
X-Gm-Message-State: AOAM5335MNMGC2NlyLZs0eFeGCPHcscbjISNhSlJoWbZ6xkdT7kZUW+m
        7zQxevhMAT+BjqFwHSIgpmE=
X-Google-Smtp-Source: ABdhPJwDPCYYAPLBVXWQ+PXyQDognBixUCnSTK7VssPi7XBJxjUtobe3lt6FWTk14/HSeFtj/JQ5EA==
X-Received: by 2002:aa7:cc01:0:b0:42a:402b:b983 with SMTP id q1-20020aa7cc01000000b0042a402bb983mr9655631edt.257.1653036557645;
        Fri, 20 May 2022 01:49:17 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id h8-20020a170906530800b006f3ef214e4bsm3031972ejo.177.2022.05.20.01.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 01:49:16 -0700 (PDT)
Date:   Fri, 20 May 2022 11:49:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 05/13] net: pcs: add Renesas MII converter
 driver
Message-ID: <20220520084914.5x6bfu4qaza4tqcz@skbuf>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
 <20220519153107.696864-6-clement.leger@bootlin.com>
 <YoZvZj9sQL2GZAI3@shell.armlinux.org.uk>
 <20220520095241.6bbccdf0@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220520095241.6bbccdf0@fixe.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 09:52:41AM +0200, Clément Léger wrote:
> > Also, as a request to unbind this driver would be disasterous to users,
> > I think you should set ".suppress_bind_attrs = true" to prevent the
> > sysfs bind/unbind facility being available. This doesn't completely
> > solve the problem.
> 
> Acked. What should I do to make it more robust ? Should I use a
> refcount per pdev and check that in the remove() callback to avoid
> removing the pdev if used ?

I wonder, if you call device_link_add(ds->dev, miic->dev, DL_FLAG_AUTOREMOVE_CONSUMER),
wouldn't that be enough to auto-unbind the DSA driver when the MII
converter driver unbinds?
