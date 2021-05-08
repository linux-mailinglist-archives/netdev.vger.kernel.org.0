Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305673772F3
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 18:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhEHQa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 12:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhEHQa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 12:30:27 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B36C061574;
        Sat,  8 May 2021 09:29:25 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id b11-20020a7bc24b0000b0290148da0694ffso8770245wmj.2;
        Sat, 08 May 2021 09:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bVRDKdENJWxwkNST3ljV2kIRILcgjQXziV66z6KKgCY=;
        b=ZiI/JOTvEn+ecPiFOfso3KJEoQOEah2HHuaCQ/ocWmQA0WS4aGN/8Ta+Da0l9C+zid
         u7hKI57zWP+miStmYdLrtHkszi5lzWOjsKGODIVAZ3fUF71FFFXEU6O4uAryxTVAmFkV
         RiOP6cQsQ7JEZ6ulT93eBEfWP5iXGHHoDvhiAfQU95LiHv/TL+GcQG3ud3vnSFXxz3gv
         k1Q3Ul3nwdcoJXrg9zEMwWRE+fJZeXLWM1eVOSbBnck6nmuxEaHBNYSbuUAYPtyXof+j
         azK60STmJx6S66G4XlGO5KBc/yrLdPKn6RNS8nNKdNTIl52+dR1F9u80b8o5RN90PLND
         YPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bVRDKdENJWxwkNST3ljV2kIRILcgjQXziV66z6KKgCY=;
        b=GfxNK+IRZ/QK8FcpxnLfrF40cx7Fvb37h4MO4/HN+Xr3Tp3rgRbxOISE972pqdArGH
         ZVZ7rBPVGEmUfwaWcibuANWGb/Vs3NVP2O9FYFYnYz5AxLKpHlV5BKapWI06X5QiAxaP
         03cca1+MtteHoxdjzOnb3tL3qmml+4/nvlWdv54wKOZdbsFg8psMUiR7ZozaInAFJB2y
         RjWQdW3LwT2ZFCx98Dm48t/NKbQCF/Y5GY+ryYhefqBpLXf5Pjola2BydMRzrb1CpsPk
         tBdwYshdCBcta7W8Oc7DSc2bqbXj3R7W2iIAF36l+LCPzit0/P1nt3rukm+1J/QuJ/Zt
         KR3A==
X-Gm-Message-State: AOAM5312P4+IsMtpc8/6M+dswi3XXaDelu7CyNwU2ASqO2xZ44ky2bah
        +S6aQThwJFW9gBxU6X9LfvtqzoFxqF4Eeg==
X-Google-Smtp-Source: ABdhPJyve22KTNe+xKecFcC1Wj1YJLJ4a5qZ3nPGVsQdQkAh/HS6W7HyK4pDYuHNk82evR1pl0gihQ==
X-Received: by 2002:a1c:1f8d:: with SMTP id f135mr13689499wmf.109.1620491363779;
        Sat, 08 May 2021 09:29:23 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id k6sm17802377wmi.42.2021.05.08.09.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 09:29:23 -0700 (PDT)
Date:   Sat, 8 May 2021 18:29:21 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 26/28] net: dsa: permit driver to provide
 custom phy_mii_mask for slave mdiobus
Message-ID: <YJa8YYSA21gUYhIl@Ansuel-xps.localdomain>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-26-ansuelsmth@gmail.com>
 <086f92b8-8c91-f618-f5cb-9df18f890f13@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <086f92b8-8c91-f618-f5cb-9df18f890f13@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 08:52:03AM -0700, Florian Fainelli wrote:
> 
> 
> On 5/7/2021 5:29 PM, Ansuel Smith wrote:
> > Some switch doesn't have a 1:1 map phy to port. Permit driver to provide
> > a custom phy_mii_mask so the internal mdiobus can correctly use the
> > provided phy reg as it can differ from the port reg.
> > The qca8k driver is provided as a first user of this function.
> 
> Why not have qca8k be in charge of allocating its internal MDIO bus like
> what mv88e6xxx or bcm_sf2 do? That would allow you to do all sorts of
> customization there and you could skip having patches 23 and 24.

Oh ok, I will implement the internal MDIO bus directly in the qca8k
driver. Was thinking... Should I keep the extra mdio node and move the
documentation to qca8k or should I handle all of that internally?
To me it looks cleaner the direct definition in the devicetree than the 
port_to_phy function in the driver but as you can see extra checks are
required to handle the new implementation and still supports the old
one.

