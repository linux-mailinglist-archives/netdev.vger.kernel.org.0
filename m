Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D258D108008
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 19:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKWSir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 13:38:47 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34852 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbfKWSir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 13:38:47 -0500
Received: by mail-pg1-f196.google.com with SMTP id k32so5061357pgl.2
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 10:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=nDRorgsBSVXUioZFMrZk0EkNmQVKU+AZrP50cmXnyC4=;
        b=uEsVTv/IY5hG62Wu9vwmfYFRVZtJMQEmvbpSxd8EASyANasSlZHDLbnv19sgBybHPZ
         sLaFJZ4ptRzpx2pp8bzaDde5oUsHabEPhJbnYrt8i/cBsmVfH40RjfsGk4MNOWiUF9e0
         p8b0FNKNG2LJhSAXzZGlcy2QGKRkFwep6PbcXeYJxDW2ICh5V5aFtBne8QHoXwSBmeTb
         VOWx7vsReEMXwyuVr4A7IBBksaZ2w0+u512zQ3uiZgWpiuk+uwyT4RU+vS1D9XA58mGM
         j527Jxpoegjg53FzKsvTEvOfUlUWr1ykfKHB1GNaYEGCPObTDePqloRawIEjCkgB6ibX
         NWcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nDRorgsBSVXUioZFMrZk0EkNmQVKU+AZrP50cmXnyC4=;
        b=eR17/KW/4PV6a/Urf1NiMyst4b1AnOdmnf0g4fyXAtsYvNAC27OPOZAeYfD+OCueZt
         FeJjezwGTSWdcKk8qCuzdDG8SPZfT1Qmi82PbeMwcp0AgEggIokadz9BkBBYyJXk4yPP
         X8adjg26K3dXYp2pNENsn03DkCke5+SUEcuBoqFsp1KvpbeZexfhLCl0MY3IjARfS0WU
         BQJ2WD28GrJvlj9a3/9Ejz+68aKl6tXlLVSLPmqbEVBJlNOcVAfUtSYTCD81+sVrgcBN
         8aLxV+xqBQBSgwQarmXRtE2S+yFeuoQdjCCF8rNr3dkOz/+Tg5FMPYy/v2295KPrBd1Y
         iPrw==
X-Gm-Message-State: APjAAAXGnIJ7e47y1BCPvYBbmtH/UQ59HODtfuNaNcSI87uQrtRbEHq+
        1SmCfVq8ai94MYG3CECUtDJu+g==
X-Google-Smtp-Source: APXvYqz1czMH9OjFLmttmObRqksQ19SQZuwNAxgR+QJ3jRnmZqw4PC8qOzxHsQAhx9c2AwtLrQZJyw==
X-Received: by 2002:a62:6404:: with SMTP id y4mr24169935pfb.170.1574534326304;
        Sat, 23 Nov 2019 10:38:46 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id v3sm2350025pfn.129.2019.11.23.10.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 10:38:45 -0800 (PST)
Date:   Sat, 23 Nov 2019 10:38:40 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>, andrew@lunn.ch,
        nbd@openwrt.org, radhey.shyam.pandey@xilinx.com,
        alexandre.torgue@st.com, netdev@vger.kernel.org,
        sean.wang@mediatek.com, linux-stm32@st-md-mailman.stormreply.com,
        vivien.didelot@gmail.com, michal.simek@xilinx.com,
        joabreu@synopsys.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, thomas.petazzoni@bootlin.com,
        john@phrozen.org, matthias.bgg@gmail.com, peppe.cavallaro@st.com,
        Mark-MC.Lee@mediatek.com, mcoquelin.stm32@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [CFT PATCH net-next v2] net: phylink: rename mac_link_state()
 op to mac_pcs_get_state()
Message-ID: <20191123103840.76c5d63f@cakuba.netronome.com>
In-Reply-To: <20191122092136.GJ25745@shell.armlinux.org.uk>
References: <E1iXaSM-0004t1-9L@rmk-PC.armlinux.org.uk>
        <20191121.191417.1339124115325210078.davem@davemloft.net>
        <0a9e016b-4ee3-1f1c-0222-74180f130e6c@gmail.com>
        <20191122092136.GJ25745@shell.armlinux.org.uk>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 09:21:37 +0000, Russell King - ARM Linux admin
wrote:
> On Thu, Nov 21, 2019 at 07:36:44PM -0800, Florian Fainelli wrote:
> > Russell, which of this patch or: http://patchwork.ozlabs.org/patch/1197425/
> > 
> > would you consider worthy of merging?  
> 
> Let's go with v2 for now - it gets the rename done with less risk that
> there'll be a problem.  I can always do the remainder in a separate
> patch after the merge window as a separate patch.

Florian, I assume you asked because you wanted to do some testing?
Please let me know if you need more time, otherwise I'll apply this
later today.
