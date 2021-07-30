Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2193DBDFF
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhG3R6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbhG3R6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 13:58:30 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6FCC06175F;
        Fri, 30 Jul 2021 10:58:24 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id y9so12463968iox.2;
        Fri, 30 Jul 2021 10:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=smUmS4A5+CXS/HJDMygkL2oSX82xvdw6bpNEbjAr0g0=;
        b=K4VFhrT4ZJWkMoYBKLQwOrJwd4CM0g3hIDd5OGCuLem9lBMfphfAvJ8sDqq2luZ020
         BywmILMIBiR8Rz2Joh29r9XsMhNfuNo31ObvgSh15TRocExL6rhmDy5jw6JKiHpPMqIK
         guH6LxRqlIqMZ13SfQdrHJMSF3U8Qb/G3TsG39S+vXypP7bUicVKDv8sN8ntpRfN8f98
         nM9qh7xhGczJ9HRvB9VzmEpPZakz8rHRnMXEejEhE5QJvdXRml8XdGeWjzBgMW1zhb4h
         cqU6PsdF6Fs/PsU4gl2arfL7crgfRjDmBrfHDnrcVIWL/bDZNQ6LQG3webpSghf2XPFJ
         bW+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=smUmS4A5+CXS/HJDMygkL2oSX82xvdw6bpNEbjAr0g0=;
        b=mO3f6iqSevD/oshwTyNF0If6+9V0SumuxVckRRcPQu858noyjrLLDPS4h4HWl6kGVU
         jTOINiZRGjJz0DOmnfLTCFd+CMqChEXdw/sluMzz3IW99rzI2E/sbEVSMgtaczvl6Eh1
         ++eI3y4+UeWLaGasbecojI50XDqgK2jFhSFxpm9GgdbB5omy40bW/8Hxd+ZAXLDjPWvI
         9a1i01aqPjq2C1WlYT0fYqQ452Y0w3MZX+dIVBN615huApCxn/VK9T7jS5IaX6DDcs1Y
         La0Ie4YwV1WI6CPQIBNeSXxnrl5dyDNMoIVloCFToNRCR53xtwR0INk9AFH6EuDG0X6q
         IlCQ==
X-Gm-Message-State: AOAM530McmWSitecBxtHk2+eZlwp/z11xFJJgBQX26Qudav3bd6anIib
        S5JZYGcWS/l/yodM5JlYLT8=
X-Google-Smtp-Source: ABdhPJzUYNA+Nyqi5PlSkrfzgZvODSW95WRszog3RzVQePF0cdu1D8Hum6pg5yO1Z51aSH2Xmo6jtQ==
X-Received: by 2002:a5d:96da:: with SMTP id r26mr3316616iol.47.1627667904024;
        Fri, 30 Jul 2021 10:58:24 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id m26sm1448320ioo.23.2021.07.30.10.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 10:58:23 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 1/2] net: dsa: tag_mtk: skip address learning on transmit to standalone ports
Date:   Sat, 31 Jul 2021 01:58:16 +0800
Message-Id: <20210730175816.519109-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210730174135.ycsq3dhpr57roxsy@skbuf>
References: <20210728175327.1150120-1-dqfext@gmail.com> <20210728175327.1150120-2-dqfext@gmail.com> <20210728183705.4gea64qlbe64kkpl@skbuf> <20210730162403.p2dnwvwwgsxttomg@skbuf> <20210730173203.518307-1-dqfext@gmail.com> <20210730173902.vezop3n55bk63o6f@skbuf> <20210730174135.ycsq3dhpr57roxsy@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 08:41:35PM +0300, Vladimir Oltean wrote:
> On Fri, Jul 30, 2021 at 08:39:02PM +0300, Vladimir Oltean wrote:
> > Ah, mt7530 is one of the switches which has multiple CPU ports, I had
> > forgotten that. In that case, then static FDB entries are pretty much
> > the only way to go indeed.
> 
> I forget which ones are the modes in which the multi-CPU feature on
> mt7530 is supposed to be used: static assignment of user ports to CPU
> ports, or LAG between the CPU ports, or a mix of both?

MT7530 only supports static assignment, by changing the port matrix.

MT7531 also supports hardware LAG, but I don't think it's ideal because
its CPU ports have different speeds (one 1Gbps RGMII and the other 2.5Gbps
HSGMII).
