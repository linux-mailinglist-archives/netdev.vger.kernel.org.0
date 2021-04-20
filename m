Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059DC365676
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 12:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhDTKnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 06:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbhDTKn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 06:43:29 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829C4C06138A;
        Tue, 20 Apr 2021 03:42:58 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id p67so20315186pfp.10;
        Tue, 20 Apr 2021 03:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=rAebuVJ6btEBT7pon85R/SRbz6V9wKnGjMtPK8cJAjw=;
        b=VyYkFSNqDG672jZOt9bL8f+ef8QxZhRXs7DfwEV9bjxsgCsGU1cJjFxkjjCE36dSIb
         wSetS0c+Rq/5kt2dPd9tRJ/s/rNsgNdQvC7kC8F4yY2nzcXFnZn/BypGz3pjsHr+2dTH
         kpwU1s5uvcDgV41V7rc+W5fAumBPGkIxEX2HH3rqMXIS1PFjEIrprfyjoQOsyJvXNeOS
         Vwlap/4BFOBpbCJZ34k7b5mi36lJ+D7F4izj9ObZkJuXt2iMnCjTXPNxdRi/tBbNOgZm
         i/mQ2be+yEokfGAJ08xh3J+EVyOiYeFJ/YICvJ86UyjJwsyxL1eknPjq5IfSVyTxfwbf
         3YVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rAebuVJ6btEBT7pon85R/SRbz6V9wKnGjMtPK8cJAjw=;
        b=Spkdt8eAbrZMpRzTDWmBPAJtUvim1GCp1WlHLzuVE7Ee2QIOP0XBhMrkW3pBWQxPQw
         W+gBi1eIh+ibu/Y22DIH/HjntfrI6Yd+qb1G89DTlKu5i1aqdtGld4IDuFr9ODdcZHLM
         go+j80s4zgQuYhM7M21xvZxa5iwoNMy+BZoI7QzI+l5mDXCPiX/LMrTwLk6h++j0J4Ge
         xE1Kru6C9/ULscYxcbpqMiOnTPCrQOplA+uEPCH++q9pJGwUCLDeEbDCxPlWnRlZa4EH
         m/1WQtRqUQGV3oOiI8akekHQudtWZnu4PYIJHBg6zA8JTxe4/O94t0n1ocdDVa/aDPUb
         U16g==
X-Gm-Message-State: AOAM532hyc+Bjzri7BmY2cL+Io31dSOBv1qnx+S+txntQNBhPtKAjR2a
        jQzmjEvUxLQpxWCpsvYdffk=
X-Google-Smtp-Source: ABdhPJybvtgBx74WDvkzitupMUhaAHYuoaLw6MUunoBYa+3kPlOVjSBKSplR0GnjKer676lgi/TKrg==
X-Received: by 2002:a62:7e41:0:b029:249:287:3706 with SMTP id z62-20020a627e410000b029024902873706mr24291541pfc.76.1618915377932;
        Tue, 20 Apr 2021 03:42:57 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id n20sm2174463pjq.45.2021.04.20.03.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 03:42:57 -0700 (PDT)
Date:   Tue, 20 Apr 2021 13:42:40 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Arvid.Brodin@xdin.com" <Arvid.Brodin@xdin.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        Po Liu <po.liu@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: Re: [EXT] Re: [net-next] net: dsa: felix: disable always guard band
 bit for TAS config
Message-ID: <20210420104240.xdu6476c2etj5ex4@skbuf>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
 <20210419123825.oicleie44ms6zcve@skbuf>
 <DB8PR04MB5785E8D0499961D6C046092AF0489@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210420082632.3fy4y3ftkhwrj7nm@skbuf>
 <AM6PR04MB5782BC6E45B98FDFBFB2EB1CF0489@AM6PR04MB5782.eurprd04.prod.outlook.com>
 <20210420103051.iikzsbf7khm27r7s@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210420103051.iikzsbf7khm27r7s@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 01:30:51PM +0300, Vladimir Oltean wrote:
> On Tue, Apr 20, 2021 at 10:28:45AM +0000, Xiaoliang Yang wrote:
> > Hi Vladimir,
> > 
> > On Tue, Apr 20, 2021 at 16:27:10AM +0800, Vladimir Oltean wrote:
> > >
> > > On Tue, Apr 20, 2021 at 03:06:40AM +0000, Xiaoliang Yang wrote:
> > >> Hi Vladimir.
> > >>
> > >> On Mon, Apr 19, 2021 at 20:38PM +0800, Vladimir Oltean wrote:
> > >> >
> > >> >What is a scheduled queue? When time-aware scheduling is enabled on 
> > >> >the port, why are some queues scheduled and some not?
> > >>
> > >> The felix vsc9959 device can set SCH_TRAFFIC_QUEUES field bits to 
> > >> define which queue is scheduled. Only the set queues serves schedule 
> > >> traffic. In this driver we set all 8 queues to be scheduled in 
> > >> default, so all the traffic are schedule queues to schedule queue.
> > >
> > > I understand this, what I don't really understand is the distinction
> > > that the switch makes between 'scheduled' and 'non-scheduled'
> > > traffic.  What else does this distinction affect, apart from the
> > > guard bands added implicitly here? The tc-taprio qdisc has no notion
> > > of 'scheduled' queues, all queues are 'scheduled'. Do we ever need
> > > to set the scheduled queues mask to something other than 0xff? If
> > > so, when and why?
> > 
> > Yes, it seems only affect the guard band. If disabling always guard
> > band bit, we can use SCH_TRAFFIC_QUEUES to determine which queue is
> > non-scheduled queue. Only the non-scheduled queue traffic will reserve
> > the guard band. But tc-taprio qdisc cannot set scheduled or
> > non-scheduled queue now. Adding this feature can be discussed in
> > future. 
> > 
> > It is not reasonable to add guardband in each queue traffic in
> > default, so I disable the always guard band bit for TAS config.
> 
> Ok, if true, then it makes sense to disable ALWAYS_GUARD_BAND_SCH_Q.

One question though. I know that Felix overruns the time gate, i.e. when
the time interval has any value larger than 32 ns, the switch port is
happy to send any packet of any size, regardless of whether the duration
of transmission exceeds the gate size or not. In doing so, it violates
this requirement from IEEE 802.1Q-2018 clause 8.6.8.4 Enhancements for
scheduled traffic:

-----------------------------[ cut here ]-----------------------------
In addition to the other checks carried out by the transmission selection algorithm, a frame on a traffic class
queue is not available for transmission [as required for tests (a) and (b) in 8.6.8] if the transmission gate is in
the closed state or if there is insufficient time available to transmit the entirety of that frame before the next
gate-close event (3.97) associated with that queue. A per-traffic class counter, TransmissionOverrun
(12.29.1.1.2), is incremented if the implementation detects that a frame from a given queue is still being
transmitted by the MAC when the gate-close event for that queue occurs.

NOTE 1—It is assumed that the implementation has knowledge of the transmission overheads that are involved in
transmitting a frame on a given Port and can therefore determine how long the transmission of a frame will take.
However, there can be reasons why the frame size, and therefore the length of time needed for its transmission, is
unknown; for example, where cut-through is supported, or where frame preemption is supported and there is no way of
telling in advance how many times a given frame will be preempted before its transmission is complete. It is desirable
that the schedule for such traffic is designed to accommodate the intended pattern of transmission without overrunning
the next gate-close event for the traffic classes concerned.
-----------------------------[ cut here ]-----------------------------

Is this not the reason why the guard bands were added, to make the
scheduler stop sending any frame for 1 MAX_SDU in advance of the gate
close event, so that it doesn't overrun the gate?
