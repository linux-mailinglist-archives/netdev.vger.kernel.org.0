Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1F3660A09
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 00:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235927AbjAFXDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 18:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjAFXDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 18:03:48 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FE1E9B;
        Fri,  6 Jan 2023 15:03:47 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id u9so6838360ejo.0;
        Fri, 06 Jan 2023 15:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=laPbFbryd1xlQcDIQ7snFfBwO8xqn9PB54qQPKLgqQQ=;
        b=HiasRf1VmxesIeh8c+yINW7g5Vt0WCU9vX05gzdGTBie90jee4tVzIbTHFrZGZ+Kmm
         21TziMmtmzkw90eooU5uu8QV0XBPwk8jJr1DuRjvL6wAXuvLjNdf7fSFwtrG6PvswTPh
         dxZoh7j/ZvXkuxwXHFwkocF0lvnx4DfRgH0Db1BSRdIbeELjDtxi3dSP5BTp/4Yk85Jt
         iFuPiSHRCHA6k3TxBEoZ+LZpnBxsZ+1E4dLRfeSUNo8u5E5E1z4CafsDgwCTgCK4xelS
         /VrH5jxJnEBXRJ9WuxiHHn+1DXXvl1nLKwVM+tAIDaQMMT1Bh2+arW3zUOvF5Si26sWd
         0o7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=laPbFbryd1xlQcDIQ7snFfBwO8xqn9PB54qQPKLgqQQ=;
        b=UMYpSzWTL3qmkjJsbg/xakqgU5j/vR6MhXmkrUuxRHnZGkRLI8ZERrHU6HfGJftgX5
         EPgwjDKEagOgLzUDQMDhcOONUba5h/KQvJwpqurJ8o3wnUUNKeRRgyiltJhzJvSAM7yS
         9ioRFYyx+yJ1D7xEaa9kA5+yZA6Io+K3fQmtyI4Xe8dQjggZoEDbkhnw1g/ZujIEb66M
         UxyjcKwu4VZ8o6fPErXP8Sel27sGehL1nlgUmDlZNq0EQQgpbYZD3lgaH8DgDof1JuL8
         bdu3eUBUJZRn6eoHy77jF02l7ZJTYwGNLzuB5sk+4I/NBSeT7MC1xTWdKqD/r+CrHxfL
         ChwA==
X-Gm-Message-State: AFqh2komSGJ3i/8CgCe5g3KnDzmYW3Gx2HoDy9bpICNhXUHWLnsuzomW
        OwoRRR5Yd6GFz+0sb/LYvxY=
X-Google-Smtp-Source: AMrXdXs26LW9IzYhj1gxu/eCClo6uCn1CN/kGMCfwfNGkYa50nILlKXN+Um1Prg4bCSeqH0q8WnJQg==
X-Received: by 2002:a17:907:8748:b0:7c1:ad6:7331 with SMTP id qo8-20020a170907874800b007c10ad67331mr54570641ejc.27.1673046225466;
        Fri, 06 Jan 2023 15:03:45 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id vj22-20020a170907131600b0078c213ad441sm840681ejb.101.2023.01.06.15.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 15:03:45 -0800 (PST)
Date:   Sat, 7 Jan 2023 01:03:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <20230106230343.2noq2hxr4quqbtk4@skbuf>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <6ffe6719-648c-36aa-74be-467c8db40531@seco.com>
 <20230105173445.72rvdt4etvteageq@skbuf>
 <Y7cNCK4h0do9pEPo@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7cNCK4h0do9pEPo@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 05:46:48PM +0000, Russell King (Oracle) wrote:
> On Thu, Jan 05, 2023 at 07:34:45PM +0200, Vladimir Oltean wrote:
> > So we lose the advertisement of 5G and 2.5G, even if the firmware is
> > provisioned for them via 10GBASE-R rate adaptation, right? Because when
> > asked "What kind of rate matching is supported for 10GBASE-R?", the
> > Aquantia driver will respond "None".
> 
> The code doesn't have the ability to do any better right now - since
> we don't know what sets of interface modes _could_ be used by the PHY
> and whether each interface mode may result in rate adaption.
> 
> To achieve that would mean reworking yet again all the phylink
> validation from scratch, and probably reworking phylib and most of
> the PHY drivers too so that they provide a lot more information
> about their host interface behaviour.
> 
> I don't think there is an easy way to have a "perfect" solution
> immediately - it's going to take a while to evolve - and probably
> painfully evolve due to the slowness involved in updating all the
> drivers that make use of phylink in some way.

Serious question. What do we gain in practical terms with this patch set
applied? With certain firmware provisioning, some unsupported link modes
won't be advertised anymore. But also, with other firmware, some supported
link modes won't be advertised anymore.

IIUC, Tim Harvey's firmware ultimately had incorrect provisioning, it's
not like the existing code prevents his use case from working.
