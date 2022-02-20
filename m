Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3488A4BD007
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 18:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244312AbiBTRBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 12:01:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244309AbiBTRBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 12:01:02 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA544527E8;
        Sun, 20 Feb 2022 09:00:40 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id lw4so27165702ejb.12;
        Sun, 20 Feb 2022 09:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TPTxuh4Vn3Wk21m+2zq2knoFIBq9/5KpuAc0/s/IgpU=;
        b=Gi+oteDKpE6sN/9Hsca7UHA9OIqWGTaKXWRCQGLkOaqeuAydWcRQ0J8HfYMSHO6ET4
         ZodLoxkB5H0ulQA29jt0hXsnvEm8AC9ntVFGrPXngqAtWbS+XMvpxRw38XWLjkz37dXM
         iDz0XkSeAXgy+rTqtnKikfchXay7uNGIv/PHoloEV6A961VdEkTgqxVHI3cZciBhm0+C
         LeVf7zvruoVxGcd7nzXewJigiPvKDLNGCZVDlj/nC+XzZrwhc1qh3y2Z+ORbBQWJhjo2
         s1jFJ63UHya6Pzct8Xye+pZMXBaCK34s7iVvPJXI4+DLLxF3x1PbpQkzpq0FhUlay4y5
         m7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TPTxuh4Vn3Wk21m+2zq2knoFIBq9/5KpuAc0/s/IgpU=;
        b=XNfcyFVYtvmm9iHDhQCylqhAk/qhz7RLW2KKi7ZzY1fIfw+39flVPXa9TE7t6pymNH
         I7x+sFsBKhMMakGPglhj6qZY7m5MfM5QP1sQph5pMP/EXzYvptFXZl0cyjP8Pd7TXV5T
         VUHgYNHDRXYo8h95lkm75EG/XUr23u144t8v6JwAH8aTIQzADK4mXZhEC9ClW90wUEoO
         3YabPG0QnqswIiQC4frl1Zytv3IS2dcmxt2oPb8itfLgL1LSzz2Wq2wYtWKdZgYFlsv0
         uNvi9nIIOrwbUXnIzo8pGfoSx+Jig4nEwQ1XtIqbxdVOPCRoh1XSJ0Z1AO4uCgBzua+Y
         mIMA==
X-Gm-Message-State: AOAM532+ho2k81VOfqg/XkhHpl0WLf9mgp9HPcJKzKFEQzg+DRBWJU/i
        SJc71DDOVdQo1V09GWbDrS4=
X-Google-Smtp-Source: ABdhPJy0KG8Y38nvuqr1n99/mfQv34tO8f6GveDa9P6PerAd4tLTTVrG432k5R6oT9hXg9VqpHew6g==
X-Received: by 2002:a17:906:c344:b0:6b4:c768:4a9a with SMTP id ci4-20020a170906c34400b006b4c7684a9amr13256275ejb.151.1645376439048;
        Sun, 20 Feb 2022 09:00:39 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id b3sm4285272ejl.67.2022.02.20.09.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 09:00:38 -0800 (PST)
Date:   Sun, 20 Feb 2022 19:00:37 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mans Rullgard <mans@mansr.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Juergen Borleis <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: lan9303: add VLAN IDs to master device
Message-ID: <20220220170037.w6r6vaduop4mbryh@skbuf>
References: <20220216204818.28746-1-mans@mansr.com>
 <20220216235930.q2l3lr7p7pf5hozo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216235930.q2l3lr7p7pf5hozo@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 01:59:30AM +0200, Vladimir Oltean wrote:
> On Wed, Feb 16, 2022 at 08:48:18PM +0000, Mans Rullgard wrote:
> > If the master device does VLAN filtering, the IDs used by the switch
> > must be added for any frames to be received.  Do this in the
> > port_enable() function, and remove them in port_disable().
> > 
> > Signed-off-by: Mans Rullgard <mans@mansr.com>
> > ---
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

There's a problem with this patch.

CONFIG_NET_DSA_SMSC_LAN9303 is not user-selectable, but it is selected
by CONFIG_NET_DSA_SMSC_LAN9303_I2C or CONFIG_NET_DSA_SMSC_LAN9303_MDIO.
The point is that config options that aren't user-selectable but are
automatically selected shouldn't have dependencies. AFAIK, the
dependencies should be transferred to the user-facing options
(_I2C and _MDIO).

What happens is that if you make CONFIG_VLAN_8021Q a module, you get
this warning:

WARNING: unmet direct dependencies detected for NET_DSA_SMSC_LAN9303
  Depends on [m]: NETDEVICES [=y] && NET_DSA [=y] && (VLAN_8021Q [=m] || VLAN_8021Q [=m]=n)
  Selected by [y]:
  - NET_DSA_SMSC_LAN9303_I2C [=y] && NETDEVICES [=y] && NET_DSA [=y] && I2C [=y]
  - NET_DSA_SMSC_LAN9303_MDIO [=y] && NETDEVICES [=y] && NET_DSA [=y]

The point of the dependency was to force the LAN9303 driver as a module
if 8021Q is a module, but this doesn't happen because the dependency
isn't where it should be.
