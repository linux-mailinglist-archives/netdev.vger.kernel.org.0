Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B47588FDF
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238341AbiHCP4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238436AbiHCPzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:55:38 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F49B6453
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 08:54:32 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id s11so10614782edd.13
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 08:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UNVDyDylr2RwublRPlCMPoU/yC/dqUJeARicvJmvpxE=;
        b=buTvY4E+44Vsa9olwjWU5pfNdnlWEXqZKMP6MDeoMEBRZ/Tyej2RLGmL4JOtowQ1oM
         WtCyqWEXtdN6ThKq7Qt/R7hgTX9D4FNLo5YaowSlGgv3ss9GJHHcZRGegoTovzZcFHbh
         A+efJdGb2gVCB80lIvpRtpWYO4GEFGdLHAioioA6aJ4HnM7g8mQVwSyK2s6W5KzdFXvr
         3tOmvNemv69UcFih2ZBzCcXaQbCWweKJKDbWy3+yp+DUzNl1IMLmB1m5/MnjQ0X564KY
         jXEjm+dDUtHxBd7SminCkMKcHGwcMt6eAWABXT3iGSkSf1BhInp90nbEF3sHdj48G+wd
         vtjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UNVDyDylr2RwublRPlCMPoU/yC/dqUJeARicvJmvpxE=;
        b=AHHD44xsw7l7Au6KlILkDTtFTsAISUneSyOKl1pnP8CxmhaJJe4lvsVbMzc31h7TYq
         pmQTPq3Z+6iFRRpAu237kcykqJL5RZ73q0sa+UWD+t8FJ6a0TPai7N/+TpCbPHZrdhg9
         TmB3Vgj4KezCBznI03O/WoSm29SOPx4S9VSARzRfUf94qln0eEjTPmft0D4NNsRjZbvG
         eHA6iD5trUnpg6ZRCPb7Px6B6EOYnqASX6r3Yc6zjmnfpAY+kG+lihzR/omRh7gKxjG0
         SBY1FyZGA8OoNCzt0dSkz/H/tr05DZSjvXiBule5eHiIIuZefQVs0WQnCFopb6dqNRLN
         9kgw==
X-Gm-Message-State: AJIora8BwqEnyG3HXB8p0R8JWEMX12xlZk+7gF1R8glc6COx4KmluRPf
        4hsTdLHalX+gg5r1cHcUMpE=
X-Google-Smtp-Source: AGRyM1sTUM6yWcrqiTrzVhck8puiZxkJthGvT2xTlwSDUTqcKVUCR5modnelxxMtFrY+Hq4SoTCRJg==
X-Received: by 2002:a05:6402:3881:b0:43a:691f:8e3b with SMTP id fd1-20020a056402388100b0043a691f8e3bmr26096156edb.217.1659542069962;
        Wed, 03 Aug 2022 08:54:29 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id kv22-20020a17090778d600b007307e7df83bsm3672644ejc.21.2022.08.03.08.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 08:54:29 -0700 (PDT)
Date:   Wed, 3 Aug 2022 18:54:27 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>, f.fainelli@gmail.com,
        Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: Re: net: dsa: lantiq_gswip: getting the first selftests to pass
Message-ID: <20220803155427.da5zqhnvmyhcxoof@skbuf>
References: <CAFBinCDX5XRyMyOd-+c_Zkn6dawtBpQ9DaPkA4FDC5agL-t8CA@mail.gmail.com>
 <20220727224409.jhdw3hqfta4eg4pi@skbuf>
 <CAFBinCD5yQodsv0PoqnqVA6F7uMkoD-_mUxi54uAHc9Am7V-VQ@mail.gmail.com>
 <20220729000536.hetgdvufplearurq@skbuf>
 <CAFBinCBXNnpz0FUCs1PnxAoPk2nTKoj=r2wjSFx_rT=vV+JPtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCBXNnpz0FUCs1PnxAoPk2nTKoj=r2wjSFx_rT=vV+JPtA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 31, 2022 at 10:49:35PM +0200, Martin Blumenstingl wrote:
> While working on my patches a more practical question came up while I
> was breaking the driver and then trying to make local_termination.sh
> pass again.
> At the start of run_tests for the standalone port scenario I am
> getting the following values:
>   rcv_dmac = 00:01:02:03:04:02
>   MACVLAN_ADDR = 00:00:de:ad:be:ef
> My expectation is that port_fdb_add() is called with these MAC
> addresses. I verified that dsa_switch_supports_uc_filtering() returns
> true, but still I

Unfinished phrase, I suppose you wanted to say that you don't get a call
to port_fdb_add() with $MACVLAN_ADDR. I don't see why that would be the
case. Try to put some prints in dsa_slave_sync_uc(), since that's the
path through which $MACVLAN_ADDR comes in. On the other hand, $rcv_dmac
comes from dsa_slave_open().

> > I'll do so if you have a specific question about something apparently
> > not mapping to the expectations.
> I still have an issue which I believe is related to the FDB handling.
> 
> I *think* that I have implemented FDB isolation correctly in my
> work-in-progress branch [0].
> 
> The GSWIP140 datasheet (page 82) has a "MAC Learning disable and MAC
> Learning Limitation Description" (table 26).
> In the xRX200 vendor kernel I cannot find the LNDIS bit in
> PCE_PCTRL_3, so I suspect it has only been added in newer GSWIP
> revisions (xRX200 is at least one major IP revision behind GSW140).
> Maybe Hauke knows?
> So what I'm doing to disable learning is setting the "learning limit"
> (which limits the number of entries that can be learned) for that port
> to zero.
> 
>  My problem is that whenever I disable learning a lot of tests from
> local_termination.sh are failing, including:
> - TEST: lan2: Unicast IPv4 to primary MAC address
> - TEST: lan2: Unicast IPv4 to macvlan MAC address
> 
> Setting the PLIMMOD bit to 1 means that GSWIP won't drop the packet if
> the learning limit is exceeded (the default value seems to be 0).

Yes, I'm not sure why you'd want to drop packets that aren't learned, so
I would expect PLIMMOD to be 1 if you're disabling learning via LRNLIM=0.

> This at least works around the first failing test (Unicast IPv4 to
> primary MAC address).

Not sure why "works around" is the choice of words here.

> Based on your understanding of my issue: I am going in the right
> direction when I'm saying that this is an FDB issue?

I don't know why the tests fail. I downloaded your code and I see that
you touch PLIMMOD from ds->ops->port_set_host_flood(). Why not just
leave it at 1? It's a global bit anyway, it affects what happens with
all ports that have source address learning disabled, it seems a very
odd choice to do what you're doing.

When you have learning disabled on standalone ports (by design), and
local_termination.sh receives packets on $swp1, a standalone port
(by design), don't you agree that the MAC SA of these packets won't be
learned, and you're telling the switch "yeah, drop them"?

> [0] https://github.com/xdarklight/linux/commits/lantiq-gswip-integration-20220730

There are many things to say about the code, however it's a bit
difficult to review it just by looking at the Github commits.
For example I'm looking at gswip_port_fdb(), I don't really understand
why this:

	for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
		if (priv->vlans[i].bridge == bridge) {
			fid = priv->vlans[i].fid;
			break;
		}
	}

is not this:

	for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
		if (priv->vlans[i].bridge == bridge &&
		    priv->vlans[i].vid == vid) {
			fid = priv->vlans[i].fid;
			break;
		}
	}
