Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC1C66226C
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 11:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbjAIKDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 05:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbjAIKCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 05:02:54 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004C01147F;
        Mon,  9 Jan 2023 02:02:40 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id u9so18773609ejo.0;
        Mon, 09 Jan 2023 02:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=631yiMfd/HSHyv7vF2uoZkf1bP44ApXazpR4vBm2RS0=;
        b=FK/6LiCca2iJVfpTUna4Ww6HscuDHHrb0lOds2yd33X2MBsF/BH4Wc7PQPwBisKShr
         I8VO/kU7HFssvgkbvUFCoXm30lO5msX4+rqYLDj2cXu0JkkUAkeiQRwMMku4NIghMpcS
         hOeh//p3hVDZjrvjYfNpHaHPoAm8cZcyqvU1z9pBJZwIp5LiZZEwRNdmW8WW55CFfERJ
         Y59m8Okr/Frg4EZTfmRVIGSDG/WtE3fyX1FMz+wB3gZqdxyw7xY6LdWd2xSiK4TtvlcX
         WEZ/CoYq6TBFB4nwbO275ChseLUfZS+m3sMIpeDHIJ5K31xg8xXQBRrXiGRvSNTSYezb
         d9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=631yiMfd/HSHyv7vF2uoZkf1bP44ApXazpR4vBm2RS0=;
        b=eOo8Wp2pK2A3Z01gL+cBfPDHGscG51MF5kyk6FaB+8tgBBf2W0QPsfJ4OCp1S9JNio
         IJS9/H8IXzfZsMU8nFjkU0Lv2dsETFK5WNjE3t5NzpAha3+upRHSsMNCvjRHPym7H4KP
         rblDeF86KugCVRXF07d/2n+24Bs/TOzfbKI5OISnE6jEIIigrYIWhB++GMK02GAkgAdy
         wnyiKjEBngORMLn3EcvTVpDm7bZjkZfZ3hDjvBOEha2g8Ixhu/oBVi17CRQCINWKw7v0
         Zf0h1Kizw0l2Vly+kHJ+89IUhNQHmld1eWAHMOK9HMa0CZSRVkE+6ZNTfKmcbQIM0kIY
         VaEw==
X-Gm-Message-State: AFqh2kotBC9nLn+e7vg/wrd4ZvJfciTcJe4OzGHGIYtKfEfbfM488m5I
        ixgJHwG5ES8aMbx2zi5JPFc=
X-Google-Smtp-Source: AMrXdXvmdUPw+XJr6Gr9gFazADBm3h26Wc1cWSNGAb3b3Rq+z3ppk+8NS1YvXcORhB5AikniA0/7hg==
X-Received: by 2002:a17:907:6f09:b0:7c1:37:6d5e with SMTP id sy9-20020a1709076f0900b007c100376d5emr35230503ejc.2.1673258559272;
        Mon, 09 Jan 2023 02:02:39 -0800 (PST)
Received: from skbuf ([188.27.185.38])
        by smtp.gmail.com with ESMTPSA id b21-20020a17090630d500b0084f7d38713esm94403ejb.108.2023.01.09.02.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 02:02:38 -0800 (PST)
Date:   Mon, 9 Jan 2023 12:02:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v5 net-next 01/15] net: bridge: mst: Multiple Spanning
 Tree (MST) mode
Message-ID: <20230109100236.euq7iaaorqxrun7u@skbuf>
References: <20220316150857.2442916-1-tobias@waldekranz.com>
 <20220316150857.2442916-2-tobias@waldekranz.com>
 <Y7vK4T18pOZ9KAKE@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7vK4T18pOZ9KAKE@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On Mon, Jan 09, 2023 at 10:05:53AM +0200, Ido Schimmel wrote:
> > +	if (on)
> > +		static_branch_enable(&br_mst_used);
> > +	else
> > +		static_branch_disable(&br_mst_used);
> 
> Hi,
> 
> I'm not actually using MST, but I ran into this code and was wondering
> if the static key usage is correct. The static key is global (not
> per-bridge), so what happens when two bridges have MST enabled and then
> it is disabled on one? I believe it would be disabled for both. If so,
> maybe use static_branch_inc() / static_branch_dec() instead?

Sounds about right. FWIW, br_switchdev_tx_fwd_offload does use
static_branch_inc() / static_branch_dec().
