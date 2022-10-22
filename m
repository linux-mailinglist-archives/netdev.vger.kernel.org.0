Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6BA608D72
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 15:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiJVNjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 09:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiJVNjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 09:39:46 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3924D142;
        Sat, 22 Oct 2022 06:39:43 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id b12so15610983edd.6;
        Sat, 22 Oct 2022 06:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ONqnfeRbIJEBHcDA0JYek+JtscZ4zltaVyYcDCSC9kw=;
        b=fYrsxTBTWLXveezVAf3JTB5d1JyTHlrtLy9F2w+mCV3f9qlz4zaL6/KTHWUm9h/MaY
         ml7uAqQR7ELdaNdsh8CMrwhkVd2tVPYE6NutMYTX5/DbWGpLIxzkGkwQSfEL4IC7b+G4
         SvKMOXuG4rl0pJDR4qXG1aNtEM7afgMx4jmNbEo+5o9nOmH71LDVrrweaDE4lN27Mxe8
         /AmFI8FeeE1TTg2SGAzP6qrDDqejZXUWcSIds86ZMkEQdpwzyg2K4Cc+kMUIjGkGfFDi
         1gKAAyMnObim1Vzp8cBs3o667dOJYCsuMtSoeelmb9050ZwCvcYPWWS/k6FIBTPH1qSY
         doEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ONqnfeRbIJEBHcDA0JYek+JtscZ4zltaVyYcDCSC9kw=;
        b=kfpwaNXwHCjYuttEsY1rleSoy2AcrWGtmhUtsvqPkg3HWIVLueY99Kc03MU6dvWT4P
         YUvPMvoeNvE+4ORgZJAmrBSGRATk92vbqHL+EOKbNiyzgkaFEN8Pdhr4syF7XxdKSd7Z
         kyqi15mKWXavEeJhK5Q4A9Gvj2Zub1GQtxoEGQLtph3gfCE/VFSaUJEq4emKiW3uHFgx
         aOMfbAmwS4CKC0gnTedv9US6kBppPAQg7EqzzKnp5pvaIUd1IhcGyGJt3f+ihTyvA8uT
         CUg4dDUZyk+84UYgC6melTYyRxQeazXzgCBXsG7gVsvvGOQCxnSCs09NMK/hgFrDRhB8
         hX2g==
X-Gm-Message-State: ACrzQf2p6hCm4Vecq9mOy9+tt+JBTHNCupJgpgp39cdFxKsFt4yIAuWW
        mTc67ifRAYx5Lw9tjZDyg6c=
X-Google-Smtp-Source: AMsMyM4SB7mv6NPFG5Y2VSE+Th+55/a9uKkLQcMf9lcPuog1lmcinWHAY+7KZ7do0aDq5OVu4/Y4AA==
X-Received: by 2002:a05:6402:144a:b0:461:8e34:d07b with SMTP id d10-20020a056402144a00b004618e34d07bmr1085496edx.426.1666445982163;
        Sat, 22 Oct 2022 06:39:42 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id q11-20020a17090676cb00b0074150f51d86sm13083352ejn.162.2022.10.22.06.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Oct 2022 06:39:41 -0700 (PDT)
Date:   Sat, 22 Oct 2022 16:39:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     "netdev@kapio-technology.com" <netdev@kapio-technology.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 10/12] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20221022133937.hfrr7sxaq2zlbnoq@skbuf>
References: <20221021112216.6bw6sjrieh2znlti@skbuf>
 <7bfaae46b1913fe81654a4cd257d98b1@kapio-technology.com>
 <20221021163005.xljk2j3fkikr6uge@skbuf>
 <d1fb07de4b55d64f98425fe66156c4e4@kapio-technology.com>
 <20221021173014.oit3qmpkrsjwzbgu@skbuf>
 <b88e331e016ad3801f1bf1a0dec507f3@kapio-technology.com>
 <20221021181411.sv52q4yxr5r7urab@skbuf>
 <GV1P190MB2019CFA0EB9B5E717F39B621E42C9@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
 <20221022113238.beo5zhufl2x645lf@skbuf>
 <GV1P190MB20196AE55C37EB6B88B54CB6E42C9@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GV1P190MB20196AE55C37EB6B88B54CB6E42C9@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 22, 2022 at 12:55:14PM +0000, Oleksandr Mazur wrote:
> 
> > I hope the following script will exemplify what I mean.
> ..
> Oh, i get it now.
> 
> Frankly speaking we haven't stumbled across such scenario / issue
> before. But i can tell it does indeed seems a bit broken;
> 
> I think there are 2 options here:
>   1. The setup itself seems insecure, and user should be aware of such behavior / issue;

Be aware, and do what? Port locking is unfit for use if learning is left
enabled (in the way learning is currently done).

>   2. Bridge indeed should not learn MACs if BR_PORT_LOCKED is set.
>   E.g. learning condition should be something like: not BR_PORT_locked
>   and learning is on; 

Rather than violate the BR_LEARNING flag (have it set but do nothing,
which would require even more checks in the fast path), I was proposing
to not allow the BR_PORT_LOCKED | BR_LEARNING configuration at all.
My question to you was if you're aware of any regression in prestera
with such a change.

> > I don't understand the last step. Why is the BR_PORT_LOCKED flag disabled?
> > If disabled, the port will receive frames with any unknown MAC SA,
> > not just the authorized ones.
> 
> Sorry for the confusion. Basically, what i described what i would
> expect from a daemon (e.g. daemon would disable LOCKED); So just
> ignore that part.

But still, why would the daemon disable BR_PORT_LOCKED once a station is
authorized? You're describing a sample/test application, not a port
security solution...
