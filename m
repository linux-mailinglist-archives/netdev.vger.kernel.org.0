Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49E56CA2DA
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 13:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbjC0LwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 07:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjC0LwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 07:52:13 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8672D4E;
        Mon, 27 Mar 2023 04:52:11 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id b20so35074626edd.1;
        Mon, 27 Mar 2023 04:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679917930;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=reW1DVwM1zk8Q9iqp1u3bB31mlwrsAJaRz6RuSIoXIU=;
        b=M1zZJS7aR62kTdJ1jkufI//A+r0KrxQx24PFXrRWBX2xnMPE6tABYKqI2H4s2xqk3u
         lx715LjMHeL8JxddEDtGvf2MqmMZJu6/KNdO1igiaFxZyAKXsKvr02xlpfrVKi8TevBp
         QR9RxKgUwi/MVBJ1Axaj3wUOgXnTbx3ATx3JvSxb7YnmtnYvKvq9MCSEU+5gtUju8znz
         gjDAS/0UoZyMaEr1mmzJnF0mhrczZe+NnIt+99HuglMce8Q5Zattl2b85mo1jKFyfBOO
         rkOXXjLLpDbqJTJ0hIeVxNAszfJyAi/5uEwHLIePTh+Q+hEKTm+896smc6GdIy8TqZA2
         1j3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679917930;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=reW1DVwM1zk8Q9iqp1u3bB31mlwrsAJaRz6RuSIoXIU=;
        b=D6OM1Zi6k6nPPIxloeJYYYjVWh5RMMAkGgqFNEZDlSAl5D4fv4h8HCh8e1kq46gZUy
         qvLs9B69xumxt82e71w3yV1V6YEbyu2SLB425nOgIM+KjQEIfHNKa2CB7ChwTGTDbRTc
         NgUdt2HVWjsyvq5fZEjNrUUoxbEmlNMvXoXcKwugPdIzXhANeTECo99QqWF5j/5hBG0A
         fSJRZwapD1iWdU+BC6+MUrOikeitKpHZn0+RgtOsyFgICzjeyX1TlHc6oUFUK8iNZ5CB
         sLCslAX/utQLKjcZckNjYEDfOSBeSQYR+wU78qin3ZKMBANpT9E3Y8JMCsIxDSDytt7b
         W2YQ==
X-Gm-Message-State: AAQBX9c+4AkR+WAGQ1izFK+HL1SrIrPkDSPUW9SGrlBe/oMoNoR58XAN
        Dt9h0CXdIdimv5zCcdk9VSI=
X-Google-Smtp-Source: AKy350bLfbg96/HAe8yX3pMOfueGxTBs/7BRBWdpqdBgFhAsQdsRhKDSQbhmFu49387GoBMY7YjoZQ==
X-Received: by 2002:a17:906:7090:b0:885:a62c:5a5c with SMTP id b16-20020a170906709000b00885a62c5a5cmr11379251ejk.46.1679917930144;
        Mon, 27 Mar 2023 04:52:10 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id y4-20020a17090629c400b0092fdb0b2e5dsm14067388eje.93.2023.03.27.04.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 04:52:09 -0700 (PDT)
Date:   Mon, 27 Mar 2023 14:52:06 +0300
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
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 2/6] net: dsa: propagate flags down towards
 drivers
Message-ID: <20230327115206.jk5q5l753aoelwus@skbuf>
References: <20230318141010.513424-1-netdev@kapio-technology.com>
 <20230318141010.513424-3-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230318141010.513424-3-netdev@kapio-technology.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 18, 2023 at 03:10:06PM +0100, Hans J. Schultz wrote:
> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
> index e5f156940c67..c07a2e225ae5 100644
> --- a/net/dsa/dsa.c
> +++ b/net/dsa/dsa.c
> @@ -626,6 +626,12 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  
>  	ds->configure_vlan_while_not_filtering = true;
>  
> +	/* Since dynamic FDB entries are legacy, all switch drivers should
> +	 * support the flag at least by just installing a static entry and
> +	 * letting the bridge age it.
> +	 */
> +	ds->supported_fdb_flags = DSA_FDB_FLAG_DYNAMIC;

I believe that switchdev has a structural problem in the fact that FDB
entries with flags that aren't interpreted by drivers (so they don't
know if those flags are set or unset) are still passed to the switchdev
notifier chains by default.

I don't believe that anybody used 'bridge fdb add <mac> <dev> master dynamic"
while relying on a static FDB entry in the DSA offloaded data path.

Just like commit 6ab4c3117aec ("net: bridge: don't notify switchdev for
local FDB addresses"), we could deny that for stable kernels, and add
the correct interpretation of the flag in net-next.

Ido, Nikolay, Roopa, Jiri, thoughts?

> +
>  	err = ds->ops->setup(ds);
>  	if (err < 0)
>  		goto unregister_notifier;

By the way, there is a behavior change here.

Before:

$ ip link add br0 type bridge && ip link set br0 up
$ ip link set swp0 master br0 && ip link set swp0 up
$ bridge fdb add dev swp0 00:01:02:03:04:05 master dynamic
[   70.010181] mscc_felix 0000:00:00.5: felix_fdb_add: port 0 addr 00:01:02:03:04:05 vid 0
[   70.019105] mscc_felix 0000:00:00.5: felix_fdb_add: port 0 addr 00:01:02:03:04:05 vid 1
.... 5 minutes later
[  371.686935] mscc_felix 0000:00:00.5: felix_fdb_del: port 0 addr 00:01:02:03:04:05 vid 1
[  371.695449] mscc_felix 0000:00:00.5: felix_fdb_del: port 0 addr 00:01:02:03:04:05 vid 0
$ bridge fdb | grep 00:01:02:03:04:05

After:

$ ip link add br0 type bridge && ip link set br0 up
$ ip link set swp0 master br0 && ip link set swp0 up
$ bridge fdb add dev swp0 00:01:02:03:04:05 master dynamic
[  222.071492] mscc_felix 0000:00:00.5: felix_fdb_add: port 0 addr 00:01:02:03:04:05 vid 0 flags 0x1
[  222.081154] mscc_felix 0000:00:00.5: felix_fdb_add: port 0 addr 00:01:02:03:04:05 vid 1 flags 0x1
.... 5 minutes later
$ bridge fdb | grep 00:01:02:03:04:05
00:01:02:03:04:05 dev swp0 vlan 1 offload master br0 stale
00:01:02:03:04:05 dev swp0 offload master br0 stale
00:01:02:03:04:05 dev swp0 vlan 1 self
00:01:02:03:04:05 dev swp0 self

As you can see, the behavior is not identical, and it made more sense
before.
