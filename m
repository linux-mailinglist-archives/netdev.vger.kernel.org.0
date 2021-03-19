Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035FA341A6A
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 11:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhCSKte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 06:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhCSKt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 06:49:28 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8D2C06174A;
        Fri, 19 Mar 2021 03:49:27 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id l4so8923412ejc.10;
        Fri, 19 Mar 2021 03:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=USGUDMEOdyCFP/W1EZM1oa+tosxHd73jkoeD7niw7TE=;
        b=CMAaLKHes3Tm4JPBbSs4OFt4YzVoWQWtN22gnAJrfOPQ4nGevyu57v6kl0G3D8aAGT
         eP7YK7wdkd3yp0mQgHHD2hhxB4wdyopzOg4qePwhOK86DJjedg2z0bW2sR6WlrZnAP1v
         FD0SzZjLfjiGEj9d8sTRVsztB1W/wolGNU2gZ1n9a5/PcLHibg9aSByn3P+I+6EV9/Jc
         0XwoRngoMwcfZbpDxv8lgp3i0mfutdx7L1k5BfjcX+yFysCaqjjtm+n8EKWH/gDMGZgu
         86UxLvO5EuutlchvGdwfLfEE0J8H5gHpvbfa/ozub1zE3X9S317mad1cd7+/kMEQXVTn
         IN2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=USGUDMEOdyCFP/W1EZM1oa+tosxHd73jkoeD7niw7TE=;
        b=SzTLwGlA/zzaNu636XBY+YjwBuGn241mjcDuTdxfaghlVVAgBObNzzmKU1SqnjmteP
         x8I8BDh+92oFDDMbbsZVe/uIB4CBVNsTGy9Pejnbov5aadA9gK7NBaDJ9w7Ly+b8pQcS
         ZVwwN/RLWsKA4OHjcoiOP3IXfpIR0ptkGb7Dnt2eSQrDd1lXY3aJmDNRDk/9Mp9otp4y
         Z1kwaa5/exvLvUHVcIY6nBg1Mikn4TjiZW+TAfK5QfUOSf2u9PdsE1BmHrcI1KVKev0C
         IX49BisDBgS7q8UBaLe5IWC353rrOOCjPO20iU5rpSoC9r1OpV4O1RRLvODipYy2XDYl
         bY8w==
X-Gm-Message-State: AOAM533oX+9QyKK9IuLrkXWsgBl0mQfFfj7U3+DF1gPMM8qF6fsHwwB0
        crcEypCebM3+zAknGXyEIgY=
X-Google-Smtp-Source: ABdhPJxL2HK4jUKLV+cCAee0smFcofY0ElAZ4n0BGG/dTnliytQ6P4DqO/WWVO18CL8g48HRpmm1Hw==
X-Received: by 2002:a17:906:68c5:: with SMTP id y5mr3624644ejr.371.1616150966614;
        Fri, 19 Mar 2021 03:49:26 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bi26sm3475613ejb.120.2021.03.19.03.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 03:49:26 -0700 (PDT)
Date:   Fri, 19 Mar 2021 12:49:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 14/16] net: dsa: don't set
 skb->offload_fwd_mark when not offloading the bridge
Message-ID: <20210319104924.gcdobjxmqcf6s4wq@skbuf>
References: <20210318231829.3892920-1-olteanv@gmail.com>
 <20210318231829.3892920-15-olteanv@gmail.com>
 <20210319084025.GA2152639@haswell-ubuntu20>
 <20210319090642.bzmtlzc5im6xtbkh@skbuf>
 <CALW65janF_yztk7hH5n8wZFpWXxbCwQu3m4W=B-n2mcNG+W=Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65janF_yztk7hH5n8wZFpWXxbCwQu3m4W=B-n2mcNG+W=Mw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 05:29:12PM +0800, DENG Qingfang wrote:
> On Fri, Mar 19, 2021 at 5:06 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > This is a good point actually, which I thought about, but did not give a
> > lot of importance to for the moment. Either we go full steam ahead with
> > assisted learning on the CPU port for everybody, and we selectively
> > learn the addresses relevant to the bridging funciton only, or we do
> > what you say, but then it will be a little bit more complicated IMO, and
> > have hardware dependencies, which isn't as nice.
> 
> Are skb->offload_fwd_mark and source DSA switch kept in dsa_slave_xmit?
> I think SA learning should be bypassed iff skb->offload_fwd_mark == 1 and
> source DSA switch == destination DSA switch.

Why would you even want to look at the source net device for forwarding?
I'd say that if dp->bridge_dev is NULL in the xmit function, you certainly
want to bypass address learning if you can. Maybe also for link-local traffic.
