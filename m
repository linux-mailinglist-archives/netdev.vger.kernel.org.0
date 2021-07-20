Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6B93CFA8C
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237220AbhGTMse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238778AbhGTMjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 08:39:52 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079CEC061574
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 06:20:30 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w14so28378272edc.8
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 06:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WWdVTBpkXpCkzjS8MZKauwExseyl+0vHSz3Ttw3XI78=;
        b=HYqB/RtMKvhnSct/pRiblvvLVjNZundUrBFnyuEgaqprWGrqqEoaAyCUhIu6gT6DFN
         g066L/ReLq/bpE1Sp+/+vJyKGz9k6Ey4aBsIqtrXgr2n/Y5gYPFfpQ/3DuLKNsU/5Q8O
         woN9aYsDvZ7p/3AlA0QL3FYYDgZZPxQgiVFpe1n9w+edX2hxAu7JXKRP5eDatqVca/18
         hQSlUSBJ/ZOAn3KvZziH+TSaUKyO7ob7BIYL0ye1lcaZiG0Tj2d+I3Nqg6zaBNz5LM8S
         YIuqpY/x9bBG9o8q80PfQs3pDnwVJ0Q79L6rrDj3gKHaTxoEeWJYfdre66l+IH4My6/X
         dQbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WWdVTBpkXpCkzjS8MZKauwExseyl+0vHSz3Ttw3XI78=;
        b=lhq8BtOjlYR0j0Fz2H0Yizij+qVnF+ZhTTFXi2theCUGFeCVgicC7afPNGzSFz4BwT
         lFIn6l+cLcl7uwSJmQN8NWQueWHs++uufPnUOTnurA/WW6hBYw14AWLUTPMaGtn1O8lV
         Dx8evWlBr24fLAu1Ork8KqcAhGFX9HrHuVXmIEZjyCn1viQ+SxlFHy69+Drme8kVk3md
         PL/m2gpNZLS3t9vh4Yscbc78hC2hjB0WWUal9F4J9G3GNSzFhEm6T0XQf5j+9cvh9Dlc
         M7svC+g+iIh61FXqY3WI80a9YiAIa0S+pfpuQmRcoVju7ysT19ZcqsiT7Nkg0Mx+6ftu
         XSug==
X-Gm-Message-State: AOAM533MyEGm0RzQNd1RhNZARbnLUG+ZS9w60K4BhwUvoKomwHoNBLeq
        Dnqhsgd3Z41AaKL8UawGLdY=
X-Google-Smtp-Source: ABdhPJy+XOIjH8dtsdCwlCAmwzymls1jFP54AZlkacuUWgCeVdswHRm5d79Rv2foaExkTBmz0jKyag==
X-Received: by 2002:a50:d982:: with SMTP id w2mr16990375edj.338.1626787228538;
        Tue, 20 Jul 2021 06:20:28 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id d13sm9269602edt.31.2021.07.20.06.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 06:20:28 -0700 (PDT)
Date:   Tue, 20 Jul 2021 16:20:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH v4 net-next 00/15] Allow forwarding for the software
 bridge data path to be offloaded to capable devices
Message-ID: <20210720132026.mpk3iq3z6vmmzxyd@skbuf>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
 <YPaybQZE8l6mRE2l@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPaybQZE8l6mRE2l@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 02:24:29PM +0300, Ido Schimmel wrote:
> Too many things are squashed into this one patchset. It needs to be
> split.
>
> The TX forwarding offload in mv88e6xxx is not related to the replay
> stuff and should be added in a separate patchset. This can be done by
> first adding the switchdev_bridge_port_offload() /
> switchdev_bridge_port_unoffload() APIs that only take care of setting /
> unsetting the hardware domain for the bridge port. Then, in a different
> patchset, these APIs can be augmented with a parameter for the replay
> stuff. It should be easier to review that way and require less
> unnecessary surgeries in drivers that do not require the added
> functionality.

Fair point. I will submit patches 1-10 and 11-15 separately.

> According to the title, the patchset is focused on improving
> performance, but there are no performance numbers that I could see and
> most of the patches deal with the replay stuff instead.

Maybe, but the truth is that it is not really the performance
improvement that I care about. The performance quote is from Tobias'
original cover letter, which I took as-is. I can build a synthetic test
for multicasting on 10 mv88e6xxx ports or something like that, or maybe
Tobias can provide a more relevant example out of Westermo's use cases.
But it would be silly if this patchset's acceptance would depend on the
numbers. This is one of those cases where completely different interests
led me and Tobias to the the same solution.

I don't want to bore you to death with details, but for some switches
(DSA or otherwise), being able to send bridge packets as they are (data
plane packets) instead of what they aren't (control plane packets) is a
matter of functionality and not performance. Such switches only use
control plane packets for link-local packet traps, and sending/receiving
a control packet is expensive.

For this class of switches (some may call them "dumb", but whatever),
this patch series makes the difference between supporting and not
supporting local IP termination through a VLAN-aware bridge, bridging
with a foreign interface, bridging with software upper interfaces like
LAG, etc.
