Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B0357FEE0
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 14:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbiGYMVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 08:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbiGYMVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 08:21:50 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CA912A97;
        Mon, 25 Jul 2022 05:21:49 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id l23so20266052ejr.5;
        Mon, 25 Jul 2022 05:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G0PeCq1InDOkHOrNdVXPwB00U4H1K4rkSaM7X/6x/yY=;
        b=Qc0ca/A2Fx6A0ywOqLmxQVOBwGXF22OUlBf9l2K1xV4siHvmXO7NgFNEA+FoO06JvH
         N1dNju0HGfWElAx7YhsO22pH5/P0gYAmSAxyF/6k7olhAGdGqLT8WdCh/Cl276Ydg9Jl
         QDOhzRFb3UtkTJvwaaZR5PLrTyyzLNdFdw2pJmgFdfjAAjtxc/qrSBKT5THtEqUvSyeS
         VR1NKqgYn7wMTtgPRcnfAYKjcIWfAlOjqCnv7ticFaiOZLsQmFneGBJhCgKzrKZynA+w
         Ugn3YJr2tcntbKq8XQcThtfwG+BZrVPEW5lrDniByuDnu94fVv/cxG5abmvJ+cbmwLi1
         WVtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G0PeCq1InDOkHOrNdVXPwB00U4H1K4rkSaM7X/6x/yY=;
        b=RH0zq/JGladV97p27EQv9IXo3pfF0uDV1rd4CQjaJ58ZJTLFEtqR6Tw+3j0PyDWewo
         tc/dAruyL19Nro6nEk4GWSyLXbKmIR2KKpx6aq88oAgPsNOvqpvhCLazWZ4SVotum9bM
         o31o0DQFclkuBeXd6q1Esnq/t44ABIVXA6wI5RXPWd1rbXJcGWFTocE3LRd+Uc4BkPbF
         wKYzbe2+ZjW2Eao9Jo+6PXc95lyAba0fb5Sp1JRLnLl4MBImUZdOCZSpGlEdxnBX4O5b
         PCHT2S3jPxWcb+ZPl/S+4pVzOEwDjaNtgcVuPPe2c/92BtgWQv9GpYrr/FlZbbXaMAno
         eToA==
X-Gm-Message-State: AJIora8wCtqOnbyxrvB9/7akaZ+mWErd0XXnY7yu84pmPtd+98OaSqWE
        k06tawyn52QcEkTvnyK/pAg=
X-Google-Smtp-Source: AGRyM1stnfooI8JCARcglDL0Mpaxsa/lEzBkf0Yq4zwLyMiM1tz6HnrbKPjfSZRKe/NLBhziXcQBXQ==
X-Received: by 2002:a17:907:86ac:b0:72b:87f6:75c2 with SMTP id qa44-20020a17090786ac00b0072b87f675c2mr10140367ejc.667.1658751707293;
        Mon, 25 Jul 2022 05:21:47 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id kx19-20020a170907775300b0072fc952b57csm2468145ejc.55.2022.07.25.05.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 05:21:46 -0700 (PDT)
Date:   Mon, 25 Jul 2022 15:21:44 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>
Subject: Re: [net-next: PATCH] net: dsa: mv88e6xxx: fix speed setting for
 CPU/DSA ports
Message-ID: <20220725122144.bdiup756mgquae3n@skbuf>
References: <20220714010021.1786616-1-mw@semihalf.com>
 <20220724233807.bthah6ctjadl35by@skbuf>
 <CAPv3WKdFNOPRg45TiJuAVuxM0LjEnB0qZH70J1rMenJs7eBJzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPv3WKdFNOPRg45TiJuAVuxM0LjEnB0qZH70J1rMenJs7eBJzw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 02:18:45AM +0200, Marcin Wojtas wrote:
> I can of course apply both suggestions, however, I am wondering if I
> should resend them at all, as Russell's series is still being
> discussed. IMO it may be worth waiting whether it makes it before the
> merge window - if not, I can resend this patch after v5.20-rc1,
> targetting the net branch. What do you think?

I just don't want a fix for a known regression to slip through the cracks.
You can resend whenever you consider, but I believe that if you do so now
(today or in the following few days), you won't conflict with anybody's work,
considering that this has been said:

On Fri, Jul 15, 2022 at 11:57:20PM +0100, Russell King (Oracle) wrote:
> Well, at this point, I'm just going to give up with this kernel cycle.
> It seems impossible to get this sorted. It seems impossible to move
> forward with the conversion of Marvell DSA to phylink_pcs.
