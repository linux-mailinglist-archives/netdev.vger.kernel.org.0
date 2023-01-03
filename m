Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1947065C3C4
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 17:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbjACQUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 11:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbjACQUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 11:20:15 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8E433D;
        Tue,  3 Jan 2023 08:20:13 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id t17so74945735eju.1;
        Tue, 03 Jan 2023 08:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zfi94AWNBKuZY0/RUI592SsfY5H/S43YqK9cJfxHwlk=;
        b=HVRvJ5mHZIorQrHjaETTJ9cWHxVB50V50Af0bHipldr0jt3ACH2XWmJ8j1KLk7M7E3
         kRNlecVPV78Qx/GG4RYgDC1Sl5XP62uu3fJFKepB4gF1awMujkKWCiGoAFVurLh1b8kq
         5tY62yw+lgP7rF4Z0qjBXMTpUR2EtJarcpTNdTx1L5vChTBtLijodKm99sRv9EyGhhmN
         K/BlSC7EQ7X3BIvti3cO07MOSfq+1e/J3XM1wZYr/joe4RhQNTjDyyItpgNCUK4Tch1M
         F10Nx4o92IktxBpAvr45DlcpRR/Kn5TeXvPmec2KMaHr84uva2Wvba5Hh/rogLMYYJ7H
         rbEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zfi94AWNBKuZY0/RUI592SsfY5H/S43YqK9cJfxHwlk=;
        b=z/8oWVerg1qMF0DvWmbDoHcFI+pLwq+jqnrm731A/CAfwtE+QUcREz9y/sDGBFDOCB
         oumyR3TuRg8jKH0VxIfn2Fj3EsjQ9RIikatT8ojrXd9ZL38b0TwjPL5YqoFWff7TUXAh
         2q89+PpnUEaPB6x93HO4kSJ/05w3t/CLdWmTfoFP13gSiHqIQ+Irdm1iHYh2PubKoE3D
         VIVUQs69Q2fh87mFJ9fg38XuQCRk1ht+CRBnKq5n7sQhexgAyN8u2Mv6Q5ikvJvYUyOC
         odcQ0TXQT0qDaI6Uxck+hdghYZ7dBhhctXPrTpX+KBUvEJOCdR/rve7fA/4L7nmeThuw
         5+Qg==
X-Gm-Message-State: AFqh2kpdzHM1vFwfkj8ljMjtBPZxXdo37FFslzPGaE2CwbTuFju0NQgx
        skSp7gskdpm66ii95AiPMPg=
X-Google-Smtp-Source: AMrXdXv5zpMo2gF+dqhm9M8us4GOLQdoYlmZq8Oh5NeW0IHa/REMSyTvHTzMxIprKOOFBuYQw/HXdg==
X-Received: by 2002:a17:906:185b:b0:841:e5b3:c95d with SMTP id w27-20020a170906185b00b00841e5b3c95dmr41382213eje.30.1672762812094;
        Tue, 03 Jan 2023 08:20:12 -0800 (PST)
Received: from skbuf ([188.26.185.118])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906201100b007c08439161dsm14150897ejo.50.2023.01.03.08.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 08:20:11 -0800 (PST)
Date:   Tue, 3 Jan 2023 18:20:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH RFC net-next v2 12/12] net: dsa: mv88e6xxx: Separate C22
 and C45 transactions
Message-ID: <20230103162008.7d7nypbdg6dyjtpw@skbuf>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-12-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-12-ddb37710e5a7@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227-v6-2-rc1-c45-seperation-v2-12-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-12-ddb37710e5a7@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 28, 2022 at 12:07:28AM +0100, Michael Walle wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> The global2 SMI MDIO bus driver can perform both C22 and C45
> transfers. Create separate functions for each and register the C45
> versions using the new API calls where appropriate. Update the SERDES
> code to make use of these new accessors.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
