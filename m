Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A9D3F4C59
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 16:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhHWOal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 10:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhHWOak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 10:30:40 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EAFC061575
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 07:29:57 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id g21so26487076edw.4
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 07:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uYEU1pDFCPEOWuHLFKOyuhxF+amyevSnsYRKna36Oic=;
        b=Hs8Swervd9wf4MrkFpoJQqFNEeQgWbTr5Wd0UgRfUwEsVGOuxd9PvqSlmRnmXt0UH6
         kPldpYcbifNH0ZVg8IyiPDpnlhK0lioFN1RpdHB56xX0pRLEoWZsI6xOhSABe8PlLJ0C
         j9HnsZGb7yTgmwzlDZENpoLiLDOQ9HotA8xKgeRmmqvgeMiimosGQ2/D648M8+osb5Ij
         /vr4cplUQTS3Dx3H2m/t0WElwno+cpAAiMH0jT16oFsXXrNhdRObyjxUPfDi3xAIIHlz
         DCFLSKPvBvOp0RBhckDHwlKcQ7krIkVmvtmEZxt38nVwCGdetN2zhNaijaD+ZPneBchm
         gHAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uYEU1pDFCPEOWuHLFKOyuhxF+amyevSnsYRKna36Oic=;
        b=QxCuLWuMDLI6jJ8i0CnDi3cR/D7AL8z3r3EtnVJA4rWagzLjseng82fdcVf9YWKO/e
         hK1U9KT8zj+ABpisY1WXDkVag//QkXa2mQniJDsrUzqnnPuaT72sdqmOBtm6T8YJLVYQ
         KXp7GdlvpM8teFbbH9L8nAth3WjUMtyW+d2fhzLCv39uzIklC07R2lQ3XqyPUiHMH0sA
         62gKnQouZwX8Uu8apZUmqNRaP5qE7FJqzlObp8CxPr8r/sWiPvRe0LTYvxnbWi7Akl38
         Ps08+bIKyEVXENl6Tlq/oTHm5Yh/f+tWXzeiQStuERyc6ehxSV13jhj/WmnvFDxEP8aF
         4TGg==
X-Gm-Message-State: AOAM531nrMMsaYJv/Q5ohjHw1VoS0YafZy4A55nxbrWkkPRIQ1wTy3bc
        S2rJb+SpKIeACGMTwK2IEbo=
X-Google-Smtp-Source: ABdhPJyOk8gPy3yrPkNrcZGJVAWXJyCVSm/BwbPjY/ShqoTfjykWTkFGJHfgOJa+JIPzMPUI+h1xeQ==
X-Received: by 2002:a50:cb83:: with SMTP id k3mr8623027edi.102.1629728996341;
        Mon, 23 Aug 2021 07:29:56 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id w5sm7654657ejz.25.2021.08.23.07.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 07:29:55 -0700 (PDT)
Date:   Mon, 23 Aug 2021 17:29:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v2 net-next 0/5] Make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
 blocking
Message-ID: <20210823142953.gwapkdvwfgdvfrys@skbuf>
References: <20210820170639.rvzlh4b6agvrkv2w@skbuf>
 <65f3529f-06a3-b782-7436-83e167753609@nvidia.com>
 <YSHzLKpixhCrrgJ0@shredder>
 <fbfce8d7-5bd8-723a-8ab3-0ce5bc6b073a@nvidia.com>
 <20210822133145.jjgryhlkgk4av3c7@skbuf>
 <YSKD+DK4kavYJrRK@shredder>
 <20210822174449.nby7gmrjhwv3walp@skbuf>
 <YSN83d+wwLnba349@shredder>
 <20210823110046.xuuo37kpsxdbl6c2@skbuf>
 <YSORsKDOwklF19Gm@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSORsKDOwklF19Gm@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 03:16:48PM +0300, Ido Schimmel wrote:
> I was thinking about the following case:
>
> t0 - <MAC1,VID1,P1> is added in syscall context under 'hash_lock'
> t1 - br_fdb_delete_by_port() flushes entries under 'hash_lock' in
>      response to STP state. Notifications are added to 'deferred' list
> t2 - switchdev_deferred_process() is called in syscall context
> t3 - <MAC1,VID1,P1> is notified as blocking
>
> Updates to the SW FDB are protected by 'hash_lock', but updates to the
> HW FDB are not. In this case, <MAC1,VID1,P1> does not exist in SW, but
> it will exist in HW.
>
> Another case assuming switchdev_deferred_process() is called first:
>
> t0 - switchdev_deferred_process() is called in syscall context
> t1 - <MAC1,VID,P1> is learned under 'hash_lock'. Notification is added
>      to 'deferred' list
> t2 - <MAC1,VID1,P1> is modified in syscall context under 'hash_lock' to
>      <MAC1,VID1,P2>
> t3 - <MAC1,VID1,P2> is notified as blocking
> t4 - <MAC1,VID1,P1> is notified as blocking (next time the 'deferred'
>      list is processed)
>
> In this case, the HW will have <MAC1,VID1,P1>, but SW will have
> <MAC1,VID1,P2>

Ok, so if the hardware FDB entry needs to be updated under the same
hash_lock as the software FDB entry, then it seems that the goal of
updating the hardware FDB synchronously and in a sleepable manner is if
the data path defers the learning to sleepable context too. That in turn
means that there will be 'dead time' between the reception of a packet
from a given {MAC SA, VID} flow and the learning of that address. So I
don't think that is really desirable. So I don't know if it is actually
realistic to do this.

Can we drop it from the requirements of this change, or do you feel like
it's not worth it to make my change if this problem is not solved?

There is of course the option of going half-way too, just like for
SWITCHDEV_PORT_ATTR_SET. You notify it once, synchronously, on the
atomic chain, the switchdev throws as many errors as it can reasonably
can, then you defer the actual installation which means a hardware access.
