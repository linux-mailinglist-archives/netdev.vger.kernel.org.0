Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621416A2142
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjBXSNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBXSNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:13:31 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8F4168A0
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:13:30 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id da10so734633edb.3
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jCGKPWP75PhDWNzrQdgfwZ0I3/xuTZSe9X5l8XId1pI=;
        b=l1kFBjs9zzT5q12TpXj/AAtEQ9jkhpaLJ92YBnuRnFNqa9K4rqYBrJ4hBbudXMu8mZ
         I9wsc863zHQ1EjlduYuoqok8E80sszMp38Ls4v3EK1SbznjPF2MdZDpjdfiM50yvv7Qe
         zui0xhWibh2kIGxMxO8cx+KMfJEAlZtlBztQk70ADywzW17LsY0viTXmdmrGm0nkhs/N
         /kMbJdD7Zo5GBFz7ajIlYmM38xmW/uk6PYZTn0EdpdcJ7f4hU1pKkCyjSID3o705E169
         JjqsC57ZJb9KMRkkH1u7QopndOGbij/AKausFxj+nfTDcda0OuB+U7Lmb68HeFvA4YUW
         llbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jCGKPWP75PhDWNzrQdgfwZ0I3/xuTZSe9X5l8XId1pI=;
        b=IMzJ32GsI1EVJnxUi+/srMyKELrJK4kL5Yqh6YX1RP8+jR+3WU9sAzvl+L/nUhbAtG
         7AbFrxnTifOeEF82UbbnZOVXkzaA0a4ykSi5ZN4OI9tC78VX6YT5i7+ESvxoBmij8vHE
         5CUmOShQ80HiQqgaUn72gMI9rsWBlkfdmk2IdQ3TaskhcAVlMeL5PLPSoZC/SBm4XSY1
         AFqA2lvnmIo6brxD6QTkHSEW/8HGlrOZEmeKRoa56ZY/xbU7AYoPqLKq+fXRxcdfLgVw
         kWMaLWExe/eoSdQZA2Qu4HLvE65c1V35ttC4NOYeclj2/zikXcqhd/heCU0rjU7PgRZq
         liMA==
X-Gm-Message-State: AO0yUKUeSWfHXeesX5zS/Ru17QsLxqjKs/4DTfmlB61uqb6O392qLV28
        tmIeDQphcWU80lahrTK/CBg=
X-Google-Smtp-Source: AK7set8D+8MnpsxPL2ysOKpflFvuybeaDMVqLIF1hFpR+NziqSK/XTgaaIFO1JDjap85jkcIdTsmLw==
X-Received: by 2002:a05:6402:291:b0:4ad:5276:8ea4 with SMTP id l17-20020a056402029100b004ad52768ea4mr15392290edv.20.1677262408938;
        Fri, 24 Feb 2023 10:13:28 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id bw10-20020a170906c1ca00b008b133f9b33dsm11084061ejb.169.2023.02.24.10.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 10:13:28 -0800 (PST)
Date:   Fri, 24 Feb 2023 20:13:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: Choose a default DSA CPU port
Message-ID: <20230224181326.5lbph42bs566t2ci@skbuf>
References: <20230218205204.ie6lxey65pv3mgyh@skbuf>
 <a4936eb8-dfaa-e2f8-b956-75e86546fbf3@arinc9.com>
 <trinity-4025f060-3bb8-4260-99b7-e25cbdcf9c27-1676800164589@3c-app-gmx-bs35>
 <20230221002713.qdsabxy7y74jpbm4@skbuf>
 <trinity-105e0c2e-38e7-4f44-affd-0bc41d0a426b-1677086262623@3c-app-gmx-bs54>
 <20230222180623.cct2kbhyqulofzad@skbuf>
 <9c9ab755-9b5e-4e76-0e3c-119d567fc39d@arinc9.com>
 <20230222193440.c2vzg7j7r32xwr5l@skbuf>
 <e89af7bd-2f4c-3865-afa5-276a6acbc16f@arinc9.com>
 <trinity-c58a37c3-aa55-48b3-9d6c-71520ad2a81d-1677262043715@3c-app-gmx-bap70>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-c58a37c3-aa55-48b3-9d6c-71520ad2a81d-1677262043715@3c-app-gmx-bap70>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 07:07:23PM +0100, Frank Wunderlich wrote:
> root@bpi-r2:~# ethtool -S eth0 | grep -v ': 0'
> NIC statistics:
>      tx_bytes: 1643364546
>      tx_packets: 1121377
>      rx_bytes: 1270088499
>      rx_packets: 1338400
>      p06_TxUnicast: 1338274
>      p06_TxMulticast: 120
>      p06_TxBroadcast: 6
>      p06_TxPktSz65To127: 525948
>      p06_TxPktSz128To255: 5
>      p06_TxPktSz256To511: 16
>      p06_TxPktSz512To1023: 4
>      p06_Tx1024ToMax: 812427
>      p06_TxBytes: 1275442099
>      p06_RxFiltering: 16
>      p06_RxUnicast: 1121339
>      p06_RxMulticast: 37
>      p06_RxBroadcast: 1
>      p06_RxPktSz64: 3
>      p06_RxPktSz65To127: 43757
>      p06_RxPktSz128To255: 3
>      p06_RxPktSz256To511: 3
>      p06_RxPktSz1024ToMax: 1077611
>      p06_RxBytes: 1643364546

Looking at the drivers, I see pause frames aren't counted in ethtool -S,
so we wouldn't know this. However the slowdown *is* lossless, so the
hypothesis is still not disproved.

Could you please test after removing the "pause" property from the
switch's port@6 device tree node?
