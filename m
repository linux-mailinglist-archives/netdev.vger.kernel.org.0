Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79CCD6D0EC5
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 21:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjC3T1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 15:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjC3T1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 15:27:36 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88C0DBDB;
        Thu, 30 Mar 2023 12:27:35 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id cm5so7477407pfb.0;
        Thu, 30 Mar 2023 12:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680204455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=THXcfT1gL+QhHkNxKHFXSnGLhR291IgK2JOIaE2Z6qo=;
        b=WmGqWWMzTa4UZZyZupqoOaK6GO0R0gyuPF1w/NqQwOR3PF78xzpkBDkvwwgDoKpLe/
         TO8kQ7yjlIBI/KZP17rpKiGl91hhAscGFQWH8bwfzCwzF7hgA/t1yf2YQ/fuHiOp/Y4S
         m7R0idI3KheKtG2pQCctaTWNZDNuq+HWnorSSdiqG/ymH92rpMLkcGFTOyTtxfcqdxFI
         +HSWS3FP+TZoKgHMkZWokuQpZ/GTLBA5F8DvRGoeZUmx6bxve4cZDoFXog93Ecc/69uL
         FX3PpBeZ/ZID2bZIVnqkah/3XdryzZGiTLyPvI6m/Fr5UTO00wLm0O169i2aocSTk7oI
         jxWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680204455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=THXcfT1gL+QhHkNxKHFXSnGLhR291IgK2JOIaE2Z6qo=;
        b=iO3DPKMk5JD1rtOkLfPPz1N+EVnZKsVgcdx9Bqd1XbD5eHG5vTq4aCtfH4J195YPnI
         Go1y4NcoV27TapvxQ8fRuIZiqRUJbCxMjNeuy6NSqXEjsy5TiprbsvPZYb3uwN7Ika7s
         Okyb2lE5RteGph2m+FgC72/k0ooifTE5NbFjtwYSSSrpTmTxIXh3PShIUX9Ro3O7EGoW
         LeV7oLmllTsUarskciA5yhAnwJV2yPpQOUenJDidlDZgsgQOCH1RCJLmdpe3cqTfO6ke
         /mINdt12PlTzJSIyxEY/PNXIJ1b81QflhjgZSgw+3Z+ZBe/MHjFNJ8LKJTUk5qvRuupH
         OX+Q==
X-Gm-Message-State: AAQBX9cHYIgmXfs4aZB/xq35fw1eeaW4Q1f4tLcrJT/ItKI7YG/388Ol
        TBWzYzj53cDEYwgsi16S/XU=
X-Google-Smtp-Source: AKy350ZPHYj9WRFwCpKfZ1lGfBi7hLQFoLXN09dTmyyi2iU20kDBjCxBeGVka6HE068VChtsu0Cg8g==
X-Received: by 2002:aa7:96b0:0:b0:626:24b2:cd6c with SMTP id g16-20020aa796b0000000b0062624b2cd6cmr25705666pfk.7.1680204455073;
        Thu, 30 Mar 2023 12:27:35 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id j6-20020a62b606000000b0062d7fa4b618sm225784pff.175.2023.03.30.12.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 12:27:34 -0700 (PDT)
Date:   Thu, 30 Mar 2023 22:27:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <netdev@kapio-technology.com>
Cc:     Ido Schimmel <idosch@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
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
Subject: Re: [PATCH v2 net-next 6/6] selftests: forwarding: add dynamic FDB
 test
Message-ID: <20230330192714.oqosvifrftirshej@skbuf>
References: <20230318141010.513424-1-netdev@kapio-technology.com>
 <20230318141010.513424-7-netdev@kapio-technology.com>
 <ZBgdAo8mxwnl+pEE@shredder>
 <87a5zzh65p.fsf@kapio-technology.com>
 <ZCMYbRqd+qZaiHfu@shredder>
 <874jq22h2u.fsf@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874jq22h2u.fsf@kapio-technology.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 09:07:53PM +0200, Hans Schultz wrote:
> Not true, it reveals that I forgot to put it in the patch, that's all. As
> I cannot run several of these tests because of memory constraints I link
> the file to a copy in a rw area where I modify the list and just run one
> of the subtests at a time. If I try to run the whole it always fails
> after a couple of sub-tests with an error.
> 
> It seems to me that these scripts are quite memory consuming as they
> accumulate memory consuption in relation to what is loaded along the
> way. A major problem with my system.

I'm sorry for perhaps asking something entirely obvious, but have you tried:

kernel-dir $ rsync -avr tools/testing/selftests/ root@$board:selftests/
board $ cd selftests/drivers/net/dsa/
board $ ./bridge_locked_port.sh lan0 lan1 lan2 lan3

?

This is how I always run them, and it worked fine with both Debian
(where it's easy to add missing packages to the rootfs) or with a more
embedded-oriented Buildroot.
