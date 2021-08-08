Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08983E3CDB
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 23:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbhHHVKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 17:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhHHVKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 17:10:48 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC1FC061760;
        Sun,  8 Aug 2021 14:10:27 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id w5so1238613ejq.2;
        Sun, 08 Aug 2021 14:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kV70Em3N4KOCd6dHIIaiZADIw5HnAbPwuwCd758ehig=;
        b=uVRwDzIw9Wp8HLXzx0vQQ59PJVbg6lZ0rueUpSjOlIuc7YvndmzeD8IptEleYyvLRC
         oWkWRPzdMRaJA2Jw3qek0Wik+vcU5y7j3xpaB1jOPo/wwMT37ASsUfKu6eZNY/g43oaC
         wGT5f5P+hsvm4E2NSOjNOGEBP54PdfY1VFgK7NfeC2/LIZQ6CXg1E9rltwLe9bnFkSOT
         dK62WYLuXdDldfSHJcKwTUUCoawlmpoqUEK3hcCpmBzzWZcOzH22nBC+Imehxbpnv8Vp
         kz/WacaENGxbMxylWJ9kabzbdCWASqrZPSOU3VKFox9TE2qNJKUR8BnylRcf8wF+aPYS
         rBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kV70Em3N4KOCd6dHIIaiZADIw5HnAbPwuwCd758ehig=;
        b=h71u8JxAG3Lce0tmaMZ9s+RNXON1/0ezonAY5vnas5HQ2MmwO39hBOesbZFchrME/n
         5GETIWREps7yYEp3SUeNCWbnj6RPxQvp/QoTovMhTGeiRuZ2s9gjOA5WaKDIPWx4Y/DJ
         FEievp9E2IDLymDXTENb0f2qgSePa2Y6lH3ngcceFqb9wYvlh01QbN+su60ZC4lHf585
         9yg30U5mYtgTjITKHwIBUKrmuZkzhmE0sU/LFgIc7w8C0rE3zKkuc8bmMEVMstnm6naU
         pBHKD0TYXchrTveAYUUER3B01wNYFdKlFMa2oKWoRmQaTYK72uOVfPtmvXBDrrFOdbn/
         YOKw==
X-Gm-Message-State: AOAM532Qyw+/i5NCoZjO3lap3AZ/zeYlF+VtxMcbJbls9U7bFrhhG36R
        OS5qPfRuQIBe1fQARTlgtCQ=
X-Google-Smtp-Source: ABdhPJyso1dfHrgUkCBbNvCk6Ueem47W0B7uOYR4SQFzerekxjG0JLz5EBMeWRYV5pZdWk+24Ch7qw==
X-Received: by 2002:a17:906:3fd7:: with SMTP id k23mr2606589ejj.176.1628457026144;
        Sun, 08 Aug 2021 14:10:26 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id h15sm5250244ejg.31.2021.08.08.14.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 14:10:25 -0700 (PDT)
Date:   Mon, 9 Aug 2021 00:10:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Jonathan McDowell <noodles@earth.li>,
        Michal =?utf-8?B?Vm9rw6HEjQ==?= <vokac.m@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Nishka Dasgupta <nishkadg.linux@gmail.com>,
        John Crispin <john@phrozen.org>,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        Hannu Nyman <hannu.nyman@iki.fi>,
        Imran Khan <gururug@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Nick Lowe <nick.lowe@gmail.com>,
        =?utf-8?B?QW5kcsOp?= Valentin <avalentin@marcant.net>
Subject: Re: [RFC net-next 2/3] net: dsa: qca8k: enable assisted learning on
 CPU port
Message-ID: <20210808211024.pcqjfoxo5rg2umuf@skbuf>
References: <20210807120726.1063225-1-dqfext@gmail.com>
 <20210807120726.1063225-3-dqfext@gmail.com>
 <20210807222555.y6r7qxhdyy6d3esx@skbuf>
 <20210808160503.227880-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210808160503.227880-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 12:05:03AM +0800, DENG Qingfang wrote:
> On Sun, Aug 08, 2021 at 01:25:55AM +0300, Vladimir Oltean wrote:
> > On Sat, Aug 07, 2021 at 08:07:25PM +0800, DENG Qingfang wrote:
> > > Enable assisted learning on CPU port to fix roaming issues.
> > 
> > 'roaming issues' implies to me it suffered from blindness to MAC
> > addresses learned on foreign interfaces, which appears to not be true
> > since your previous patch removes hardware learning on the CPU port
> > (=> hardware learning on the CPU port was supported, so there were no
> > roaming issues)
> 
> The datasheet says learning is enabled by default, but if that's true,
> the driver won't have to enable it manually.
> 
> Others have reported roaming issues as well:
> https://github.com/Ansuel/openwrt/pull/3
> 
> As I don't have the hardware to test, I don't know what the default
> value really is, so I just disable learning to make sure.

That link doesn't really say more than "roaming issues" either, so I am
still not clear on what is being fixed here exactly.

Note that I can still think of 'roaming'-related issues with VLAN-aware
bridges and foreign interfaces and hardware learning on the CPU port,
but I don't want to speculate too much and just want to hear what is the
issue that is being fixed.

> > > Although hardware learning is available, it won't work well with
> > > software bridging fallback or multiple CPU ports.
> > 
> > This part is potentially true however, but it would need proof. I am not
> > familiar enough with the qca8k driver to say for sure that it suffers
> > from the typical problem with bridging with software LAG uppers (no FDB
> > isolation for standalone ports => attempt to shortcircuit the forwarding
> > through the CPU port and go directly towards the bridged port, which
> > would result in drops), and I also can't say anything about its support
> > for multiple CPU ports.
> 
> QCA8337 supports disabling learning and FDB lookup on a per-VLAN basis,
> so we could assign all standalone ports to a reserved VLAN (ID 0 or 4095)
> with learning and FDB lookup disabled.

And to follow along that idea, if you also change the tagger to send
all packets towards a standalone port using that reserved VLAN, then
even if hardware learning is enabled on the CPU port, it will be
inconsequential as long as IVL is used, because no FDB lookup will match
the VLAN in which those addresses were learned.

My point is, if you come with something functional to the table, present
the whole story. If more changes still need to be made until it works
with software bridging fallback, say that too. Otherwise, I think that
the general idea that "hardware learning on the CPU port won't work well
with software bridging fallback" is not strictly true, and that this
patch has a weak overall justification.

> 
> Ansuel has a patch set for multiple CPU ports.
