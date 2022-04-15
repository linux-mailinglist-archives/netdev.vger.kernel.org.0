Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3460A502A60
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351805AbiDOMod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354494AbiDOMny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:43:54 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98B2253;
        Fri, 15 Apr 2022 05:41:25 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 21so9848059edv.1;
        Fri, 15 Apr 2022 05:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PjAOnK4TaThM2zy9QVRf0RiQ0dd/kY5ZjwiE2UMge0w=;
        b=ZCBW3amw8qVo6miVAAhkjAXu/tGK59gJc9d8egCRoPu4Sd0hFyT0C+jwgcaB5brIhH
         e3m5jnX7gjDd7EHc1iTYxSigi/Sybz6qr1NMAfAL8T+68QljsXBr5DKYxXPZKOla4V/g
         rc3bEcnmrl1MSEEjxfq5/7z2ZkmxfWsNq6vo6YO78aULLZx1n2g7wcLYsmWPi3XfFsGF
         SJf9dzkmsUxiaNDzKVsjmyxCtrd6XveG7HvSjk66K6YIV0iEGElRh/osjgP2eMxYTe2P
         XdFcbxrCT5U/hHJDXL5v9DxIFI3iG6/zdSJjtkqtOWr85hZOH2M6HhFAQrL9V6c7KVPZ
         WCtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PjAOnK4TaThM2zy9QVRf0RiQ0dd/kY5ZjwiE2UMge0w=;
        b=kkZkAkxmVD71aFxrYfhmOF5Crl4dSvwUu2w3zD6MkEucWSG+pb2vDRik2Hyii6ELua
         gDGiwb+XadXhG9UAGpc0wRfEQzh+Py1U+OyaW3rzQUysRbJsa2iidReUlLT+w9ucYXXR
         y8lCsit4dVnNgK/rqbnisZ2oXiSfpOTq90y6O9Zib/+XT5p1xMr7F6KWXA28H5/4p/bS
         7wgADukzCliARnwfpKLSExx05sAUFu22GunWalFxDjQM4ssUO2LuUlhbHVeso2AelNgP
         DbHe3t/aj/PhCk6grETT6Y/He3XXCywiVI/2jSu0RnoUQ/ZH0lFInIaUXdRWj0+K8wmO
         yP9A==
X-Gm-Message-State: AOAM533Ke+7v5bzW2Ezq4SaElnm8wje0FJEr6FavzG4rI+6GSxgZHEzP
        x/r1ZlwVm5iEDC3+t01p9Ac=
X-Google-Smtp-Source: ABdhPJxVpxx3wHYt7tHVMVU6Szae55b/THeuz+OQ6KP+h2UTFsL4byiRseG/cNIQfA+XWpKXQMi6rw==
X-Received: by 2002:a05:6402:27c7:b0:41b:51ca:f542 with SMTP id c7-20020a05640227c700b0041b51caf542mr8170865ede.149.1650026484337;
        Fri, 15 Apr 2022 05:41:24 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id b5-20020a17090630c500b006e8044fa76bsm1693634ejb.143.2022.04.15.05.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 05:41:23 -0700 (PDT)
Date:   Fri, 15 Apr 2022 15:41:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next 06/12] net: dsa: rzn1-a5psw: add Renesas RZ/N1
 advanced 5 port switch driver
Message-ID: <20220415124121.pls4bhfwv3azpbmf@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-7-clement.leger@bootlin.com>
 <20220414144709.tpxiiaiy2hu4n7fd@skbuf>
 <20220415113453.1a076746@fixe.home>
 <20220415105503.ztl4zhoyua2qzelt@skbuf>
 <20220415142857.525ccd2d@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220415142857.525ccd2d@fixe.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 02:28:57PM +0200, Clément Léger wrote:
> > Most things as seen by a DSA switch driver are implicitly serialized by
> > the rtnl_mutex anyway. 
> 
> Is there a list of the functions that are protected by the RTNL lock
> without having to deep dive in the whole stacks ? That would be really
> useful to remove useless locking from my driver. But I guess I'll have
> to look at other drivers to see that.

No, there isn't, but in Documentation/networking/dsa/dsa.rst we do have
a list of dsa_switch_ops functions which used to be comprehensive
(but now needs to be updated again due to development that happened in
the meantime). I suppose that if you do a thorough job of documenting
the synchronization rules, you could add that information to this file.
This would be similar to how we have the "struct net_device synchronization
rules" section in Documentation/networking/netdevices.rst.
