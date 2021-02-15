Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE6131BB62
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 15:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhBOOuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 09:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhBOOub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 09:50:31 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA77C061574
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 06:49:50 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id q10so8348243edt.7
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 06:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7q6xZj5PR7KnJONP//XaWTv8W23i1cPWW20xt+K72xU=;
        b=rEneoNTYcPO57KGAf2tWl7Ma5vuVxjjmjYSb3IQF9/MTSDnEDXG/03KsxFgEGO+LtG
         VK3jWtzTWoQEIdBzsqydvMdYNGrn2rHWG9T/RRdXA9ZktHjvnL/wFh/H1rMIiaX093LF
         LUW+yWpfhMHoRUsAgHN/73I/Kcc1cbe12mtjfCW+rOmiPk1nqJHaeunbmnKTWHTMa/Nc
         ywz6h9xcH4xqmdp2opJrJixKudZ/efBMgPZbhVHxRPTD46C4eeWZ5eq3nH4vRv5EfwAx
         LMDCIIDcJomLQNwzI+REs7mkRY5XxoRWejxLwQUC/1jsSmK4A6KePFmpBfUMIhLLXH0t
         Tczw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7q6xZj5PR7KnJONP//XaWTv8W23i1cPWW20xt+K72xU=;
        b=qIoNXWaiXKvzSit3gJWxz+H7LMoHZkI2XICNqGfmtwmRapGxQCrfFytf9n0G2EGOgP
         5hDYeZqJ1LqVVlPL9Rj1YR1Km2sBDfmMlCmRn91DqZP98aTJjhVkwhnAFFvM3HMJXSxO
         u25QlQDYN533a2QXYOvBTMYUXGSCjUXj13efVYY4qq3JlEpfKHqQ0LRo2Z6wxsZKQbR2
         0nUQlhByR/7RajfU2xiZmAc0h4FOfSKMh3vF0vcjBEtzpIwTomZjVSktAWDmiU7YD8eA
         Ck6RmuMc1bE76+NIKGfsGJ4GyNoY2tvYpnqLbVTjumcvR3vAees5IHaKoukcnhTcQGVo
         2P8A==
X-Gm-Message-State: AOAM530aZXsp3azhE7dmR5LmO6Z7E97r8/5er6TjvtewRxka6S7pHd8n
        waXrvw267gzeSCGGlFxt9Ps=
X-Google-Smtp-Source: ABdhPJxcpYKOsDwORsJFpDq6nazm92oNEztsLqq9ibqPKrxo+Medpk8LSADRkeL2wj98MrsG2jQAIw==
X-Received: by 2002:a50:eb49:: with SMTP id z9mr16490179edp.234.1613400589407;
        Mon, 15 Feb 2021 06:49:49 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u5sm10734312edc.29.2021.02.15.06.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 06:49:48 -0800 (PST)
Date:   Mon, 15 Feb 2021 16:49:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@lists.01.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        lkp@intel.com, kbuild-all@lists.01.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 09/12] net: dsa: tag_ocelot: create separate
 tagger for Seville
Message-ID: <20210215144947.w4qybfv5ouvfa476@skbuf>
References: <20210213001412.4154051-10-olteanv@gmail.com>
 <20210215130003.GL2087@kadam>
 <20210215131931.4nibzc53doqiignb@skbuf>
 <20210215141521.GC2222@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210215141521.GC2222@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 05:15:21PM +0300, Dan Carpenter wrote:
> On Mon, Feb 15, 2021 at 03:19:31PM +0200, Vladimir Oltean wrote:
> > Hi Dan,
> >
> > On Mon, Feb 15, 2021 at 04:00:04PM +0300, Dan Carpenter wrote:
> > > db->index is less than db->num_ports which 32 or less but sometimes it
> > > comes from the device tree so who knows.
> >
> > The destination port mask is copied into a 12-bit field of the packet,
> > starting at bit offset 67 and ending at 56:
> >
> > static inline void ocelot_ifh_set_dest(void *injection, u64 dest)
> > {
> > 	packing(injection, &dest, 67, 56, OCELOT_TAG_LEN, PACK, 0);
> > }
> >
> > So this DSA tagging protocol supports at most 12 bits, which is clearly
> > less than 32. Attempting to send to a port number > 12 will cause the
> > packing() call to truncate way before there will be 32-bit truncation
> > due to type promotion of the BIT(port) argument towards u64.
> >
> > > The ocelot_ifh_set_dest() function takes a u64 though and that
> > > suggests that BIT() should be changed to BIT_ULL().
> >
> > I understand that you want to silence the warning, which fundamentally
> > comes from the packing() API which works with u64 values and nothing of
> > a smaller size. So I can send a patch which replaces BIT(port) with
> > BIT_ULL(port), even if in practice both are equally fine.
>
> I don't have a strong feeling about this...  Generally silencing
> warnings just to make a checker happy is the wrong idea.

In this case it is a harmless wrong idea.

> To be honest, I normally ignore these warnings.  But I have been looking
> at them recently to try figure out if we could make it so it would only
> generate a warning where "db->index" was known as possibly being in the
> 32-63 range.  So I looked at this one.
>
> And now I see some ways that Smatch could have parsed this better...

For DSA, the dp->index should be lower than ds->num_ports by
construction (see dsa_switch_touch_ports). In turn, ds->num_ports is set
to constant values smaller than 12 in felix_pci_probe() and in seville_probe().

For ocelot on the other hand, there is a restriction put in
mscc_ocelot_init_ports that the port must be <= ocelot->num_phys_ports,
which is set to "of_get_child_count(ports)". So there is indeed a
possible attack by device tree on the ocelot driver. The number of
physical ports does not depend on device tree
(arch/mips/boot/dts/mscc/ocelot.dtsi), but should be hardcoded to 11.
How many ports there are defined in DT doesn't change how many physical
ports there are. For example, the CPU port module is at index 11, and in
the code it is referenced as ocelot->ports[ocelot->num_phys_ports].
If num_phys_ports has any other value than 11, the driver malfunctions
because the index of the CPU port is misidentified. I'd rather fix this
if there was some way in which static analysis could then determine that
"port" is bounded by a constant smaller than the truncation threshold.

However, I'm not sure how to classify the severity of this problem.
There's a million of other ways in which the system can malfunction if
it is being "attacked by device tree".
