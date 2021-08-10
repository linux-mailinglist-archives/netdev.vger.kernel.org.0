Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8621C3E7DF3
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 19:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhHJRFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 13:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhHJRFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 13:05:20 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD674C0613C1
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 10:04:58 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id nt11so10847017pjb.2
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 10:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=P8oKNsd2zurKg5WRd2PSpvje8WRQUGMv9qPb4eTQAio=;
        b=f9qVTSkaw04wCs3I3H1OvgWqeCPWxvygxVL2GDXCOGcpNu1fjAOYY6+oFtJh+p4r7j
         rzaw7BYUzy1I2ye1HnE2VVc75oV0R+zXsJG2VHf6MUB4ijjnkR/vplWLcKmdeEXgsPcr
         yvf6dHi/rYjTdS50Y8s3FTLw6QQLZFEj+7z8KYfjlGxAz9jpfRyO7ue1Y+06cU3u8Djv
         JiYCZEh1sirvWFTl5pSR2ilhtvrA337Rlh+kSehpik1vFOJvHnYOQsRrbawvxjk3nvys
         /Jj9cFsf0QWkqrseVY1FDQnnp8eI4oKjVQHF9ovGdR9+1n8CiDBApuIyvxbMwpDXZMS6
         D8HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=P8oKNsd2zurKg5WRd2PSpvje8WRQUGMv9qPb4eTQAio=;
        b=lJTuyHEs4Hh6zBruLojXcnXVXQSFmgNF5nc8manMkfA0yGg0jS3HbyNOytmHSQpdzP
         dnzQ9QBomz4Dfep7AN/DPzHh5gNTuMuTKHhKxZtwo5r/SfLewNJ7xnvCMCUujs7abnZo
         DmCS3b6NcRgfCo4X7z3eydsziB5MWXXtuL+cmDtv7CArVrL/RfeG/7mVBkDb0ZreNz+N
         NvBraDkcRa629MOpS3N0I0Y+udWrIcQHy17EZqXsnoXGSBGThsvoHQ+902MiPSHMXJck
         SzFPGZPukFLNond/fDYUIv1KU1viLFqSUa0QhObcVpxM3+R/BDOpSIsMZIRc0PxcMaXf
         ZwJQ==
X-Gm-Message-State: AOAM531G6KpnAkKxUx6Ww1sc1Uwtr370yyRwSvBwttW+Tjb18+n9XefZ
        ytIndAkqMvjbrRR1KvAZpWU=
X-Google-Smtp-Source: ABdhPJzQSo16x9Qg/rReAdMo2aHWS/xDIsIcJm01NIxIceFvAi+PUyfYT95jSdDVyAdLCIf+gQ/yqw==
X-Received: by 2002:a17:90a:4805:: with SMTP id a5mr15664181pjh.139.1628615098294;
        Tue, 10 Aug 2021 10:04:58 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id fa21sm3664737pjb.20.2021.08.10.10.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 10:04:57 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [RFC PATCH net-next 2/4] net: dsa: remove the "dsa_to_port in a loop" antipattern from the core
Date:   Wed, 11 Aug 2021 01:04:47 +0800
Message-Id: <20210810170447.1517888-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810163533.bn7zq2dzcilfm6o5@skbuf>
References: <20210809190320.1058373-1-vladimir.oltean@nxp.com> <20210809190320.1058373-3-vladimir.oltean@nxp.com> <20210810033339.1232663-1-dqfext@gmail.com> <dec1d0a7-b0b3-b3e0-3bfa-0201858b11d1@gmail.com> <20210810113532.tvu5dk5g7lbnrdjn@skbuf> <20210810163533.bn7zq2dzcilfm6o5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 07:35:33PM +0300, Vladimir Oltean wrote:
> If I were to guess where Qingfang was hinting at, is that the receive
> path now needs to iterate over a list, whereas before it simply indexed
> an array:
> 
> static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
> 						       int device, int port)
> {
> 	struct dsa_port *cpu_dp = dev->dsa_ptr;
> 	struct dsa_switch_tree *dst = cpu_dp->dst;
> 	struct dsa_port *dp;
> 
> 	list_for_each_entry(dp, &dst->ports, list)
> 		if (dp->ds->index == device && dp->index == port &&
> 		    dp->type == DSA_PORT_TYPE_USER)
> 			return dp->slave;
> 
> 	return NULL;
> }
> 
> I will try in the following days to make a prototype implementation of
> converting back the linked list into an array and see if there is any
> justifiable performance improvement.
> 
> [ even if this would make the "multiple CPU ports in LAG" implementation
>   harder ]

Yes, you got my point.

There is RTL8390M series SoC, which has 52+ ports but a weak CPU (MIPS
34kc 700MHz). In that case the linear lookup time and the potential cache
miss could make a difference.
