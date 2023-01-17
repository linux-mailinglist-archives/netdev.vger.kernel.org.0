Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0EE6670E3D
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjAQXzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjAQXyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:54:44 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3774ABCB;
        Tue, 17 Jan 2023 15:08:11 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id az20so60013761ejc.1;
        Tue, 17 Jan 2023 15:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZqG3eRlHUbK1Lyl7ksi3Aw/n8LhVJQ09Kf9OQGt9voM=;
        b=ZxbOGkUgPd0sW7VsqQdDiiEezFqOj9G5epZuy25qVAeqJo4VqKuLhaIPdKMzhI4z49
         p7zUZjGRsXHV8muavKDc+qsjH1FkBmWBjW+cqLq/8GvqNU/upQ1x+F5Jp0DS/UQubeEc
         Ac4pdDjxJ5+Rbs4rzkL6WHY3Tpy6HeGJAgAD5JIRBPG5U2Ky+kVUXKioILZsLd1X8STR
         5WGXAL/RbSZkGtOsoqpI0S4xqkIrGul9Gr3ihrlJ5WzcxZx44Wqff26av8mbjq5i8SDN
         WP0YICTHvV0Ho573spiFUOC0blUJaCDC4sjx0e1IQk1UaOFuCmdvVJKufiUSoXFeYeaX
         FT7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZqG3eRlHUbK1Lyl7ksi3Aw/n8LhVJQ09Kf9OQGt9voM=;
        b=XlRnDcmfCOwxwBDI6uBGYfnFrVFxeSl8BQgFJ4tsl692yp7Du/AGjvxokoaqTfqlKi
         Og/MQ2VuiubiHqHF7ifll38HN6OzJSegHkSh0vpA2tAVbdbiqcnuSqDNUt+Un/C7wIdU
         b2tRPsZ56SGCciV8f5EoAUcs440J/gRxcNjyfZZ6rtRyNUPUGsK02mSH5K5IcKggGsIF
         fGXs6bzVdPrU7w48JFHFJTz0BAP4SscrRIX+kPtgVa4Vmwb1V3cvwz4cH33tqcwgd51X
         4unKQ6DDfVAoyAc9nu/lsYfO2E81R+Fr7setTLKK/gArq7P9bGjQiudfXY6V742Nj3Fv
         9rPA==
X-Gm-Message-State: AFqh2krFErSzLSruLZoczLo1LdsYDwlhvrggn5+hAkzPhXN79JzqI3fv
        lEBp4oqat2r92awHZ4ExQvU=
X-Google-Smtp-Source: AMrXdXsNsFKUYz2t3yHJIzHFLh/nyECIcVDxNeg65wxo6D6FxRXy0K+cvrA+72ZPq62T6qBGsedr5g==
X-Received: by 2002:a17:907:100c:b0:870:e329:5f3d with SMTP id ox12-20020a170907100c00b00870e3295f3dmr4810199ejb.19.1673996890349;
        Tue, 17 Jan 2023 15:08:10 -0800 (PST)
Received: from skbuf ([188.27.184.249])
        by smtp.gmail.com with ESMTPSA id g9-20020a17090604c900b0085ca279966esm8773118eja.119.2023.01.17.15.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 15:08:10 -0800 (PST)
Date:   Wed, 18 Jan 2023 01:08:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [RFC PATCH net-next 1/5] net: bridge: add dynamic flag to
 switchdev notifier
Message-ID: <20230117230806.ipwcbnq4jcc4qs7z@skbuf>
References: <20230117185714.3058453-1-netdev@kapio-technology.com>
 <20230117185714.3058453-2-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117185714.3058453-2-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 07:57:10PM +0100, Hans J. Schultz wrote:
> To be able to add dynamic FDB entries to drivers from userspace, the
> dynamic flag must be added when sending RTM_NEWNEIGH events down.
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---
>  include/net/switchdev.h   | 1 +
>  net/bridge/br_switchdev.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> index ca0312b78294..aaf918d4ba67 100644
> --- a/include/net/switchdev.h
> +++ b/include/net/switchdev.h
> @@ -249,6 +249,7 @@ struct switchdev_notifier_fdb_info {
>  	u8 added_by_user:1,
>  	   is_local:1,
>  	   locked:1,
> +	   is_dyn:1,
>  	   offloaded:1;
>  };
>  
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index 7eb6fd5bb917..60c05a00a1df 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -136,6 +136,7 @@ static void br_switchdev_fdb_populate(struct net_bridge *br,
>  	item->added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
>  	item->offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
>  	item->is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
> +	item->is_dyn = !test_bit(BR_FDB_STATIC, &fdb->flags);

Why reverse logic? Why not just name this "is_static" and leave any
further interpretations up to the consumer?

>  	item->locked = false;
>  	item->info.dev = (!p || item->is_local) ? br->dev : p->dev;
>  	item->info.ctx = ctx;
> -- 
> 2.34.1
> 
