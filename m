Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE6527E801
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 13:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbgI3L5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 07:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgI3L5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 07:57:11 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4B8C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 04:57:11 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id e22so1512188edq.6
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 04:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OhPAOFVD+oBF810acOneFFKHLt/2svGol3+xfPNIIGc=;
        b=SX7S5BhBtHRfXy7vaCEcReg+6OvyNUQchq6BO11lbTwHnyGUefzIv7nRnMzMNbsSKR
         pCCrsuh7mqbYggWGR2An30iH6BT8veb307Te+15ozNRGB4FS64T/y1bACG0cf9jD/l3Y
         Ctn1c+AsIZS9JVuGWSp5qZKnxxZbbElOYYhBBMJfjiXAkA/O+s9pkhX5oaHqa+apAyPl
         4JseFTzHgH/OScZVd81uuy4GdtnUY52Tl7PdKDe5YtDHYxkwV3wuWLLQLhOHJ1JAwsqG
         KPjtq3AS/qzPchB5DWZJsDWLAgLeb2sui58UISIxs2E5ocD1M3JiogmzKjfzd56uEGW/
         ccRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OhPAOFVD+oBF810acOneFFKHLt/2svGol3+xfPNIIGc=;
        b=S/F5/LAR/obprjZ0VoSXbWy8fBVkmPPgM7UPSiP+KsyrmVXlgnV6G++hueFHEfLHFz
         MjHFi+DxI5PhamADAY/bORN99d6RQYOQajh2aYXTcXUFTF3nfOP086Bs/n+TdhaRr8IP
         U71tG/thSmsLuBOEVYV8KjO1iSleWhwRd4EZMG/kmDG/AKWFzz1aPSS0Zwz7Z2YiJysQ
         24cti+SllzCCZaQ2XisHKp73WjFSu2Ee+Rnngl4DNITtAcdn3BP4GvmOcMornG3wWMY+
         YWoZ3c+rA9lqHoO+90Sjjq80fchkYP5yjQEk5TuFknEFy8xM47xfV/6DBmO4W2dMQoCF
         rX6w==
X-Gm-Message-State: AOAM532nQqPgIOYZyB0kHnNB5WNMvVSSE7x5ljT40JX+lCxQSbAEU74v
        52EQ8gyjhYt2d4Vc3EDY1vU=
X-Google-Smtp-Source: ABdhPJxtwwrK5r1kYDrb89gNS4vHLe5bTncIfmd5BEQuq8+hhTAVP3F9nof+uaQ3Zdml552291h3wA==
X-Received: by 2002:aa7:cd90:: with SMTP id x16mr2235767edv.302.1601467029812;
        Wed, 30 Sep 2020 04:57:09 -0700 (PDT)
Received: from fido.de.innominate.com (x59cc8adf.dyn.telefonica.de. [89.204.138.223])
        by smtp.gmail.com with ESMTPSA id rn10sm866118ejb.8.2020.09.30.04.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 04:57:09 -0700 (PDT)
Date:   Wed, 30 Sep 2020 13:57:06 +0200
From:   Peter Vollmer <peter.vollmer@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>
Subject: Re: dsa/mv88e6xxx: leaking packets on MV88E6341 switch
Message-ID: <20200930115705.GA12758@fido.de.innominate.com>
References: <CAGwvh_MAQWuKuhu5VuYjibmyN-FRxCXXhrQBRm34GShZPSN6Aw@mail.gmail.com>
 <20200930102835.4ee4mogk7ogom35j@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930102835.4ee4mogk7ogom35j@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 01:28:35PM +0300, Vladimir Oltean wrote:
> On Wed, Sep 30, 2020 at 12:09:03PM +0200, Peter Vollmer wrote:
> > lan0..lan3 are members of the br0 bridge interface.
>
> and so is eth0, I assume?

No, eth0 is a dedicated interface with its own IP. We have routing between eth0 and br0.

root@mGuard:~# ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq qlen 1024
    link/ether a8:74:1d:85:08:be brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1508 qdisc mq qlen 1024
    link/ether 00:a0:45:38:22:90 brd ff:ff:ff:ff:ff:ff
4: sit0@NONE: <NOARP> mtu 1480 qdisc noop qlen 1000
    link/sit 0.0.0.0 brd 0.0.0.0
5: lan0@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br0 qlen 1000
    link/ether a8:74:1d:85:08:bf brd ff:ff:ff:ff:ff:ff
6: lan1@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br0 qlen 1000
    link/ether a8:74:1d:85:08:c0 brd ff:ff:ff:ff:ff:ff
7: lan2@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue master br0 qlen 1000
    link/ether a8:74:1d:85:08:c1 brd ff:ff:ff:ff:ff:ff
8: lan3@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue master br0 qlen 1000
    link/ether a8:74:1d:85:08:c2 brd ff:ff:ff:ff:ff:ff
9: br0: <BROADCAST,UP,LOWER_UP> mtu 1500 qdisc noqueue qlen 1000
    link/ether a8:74:1d:85:08:bf brd ff:ff:ff:ff:ff:ff

root@mGuard:~# brctl show
bridge name     bridge id               STP enabled     interfaces
br0             8000.a8741d8508bf       no              lan2
                                                        lan0
                                                        lan3
                                                        lan1


> > The problem is that for ICMP ping lan0-> eth0, ICMP ping request
> > packets are leaking (i.e. flooded)  to all other ports lan1..lan3,
> > while the ping reply eth0->lan0 arrives correctly at lan0 without any
> > leaked packets on lan1..lan3.
> 
> What are you pinging exactly, the IP of the eth0 interface, or a station
> connected to the eth0 which is part of the same bridge as the lan ports?
> 

I am pinging the address of a station connected to eth0 from a station
connected to switch port lan0.

Thanks,
Peter
