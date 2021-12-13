Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BC04729D2
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 11:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbhLMKZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 05:25:32 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:65029 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242212AbhLMKXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 05:23:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639391011; x=1670927011;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RW19rszBP6toUbDeC1RTtY+8YV4n8NBBlhMnFptQuwU=;
  b=yl3RvcKOWamkj9D0eynwoC70JxvShvWgd5bjOSIZJgA/2kOSqO15c9dx
   wvDI6KpCM/Pa4yCIoUOPRm5pw8BFXy0qRQJVHTlK7oDDbD3hD3pTPC/n+
   YuLQjdEJ+FsBSuu4YmWxa/cv5ITw4Wfrdpnf1j3NKnkl5ADA0e4Yxy706
   fxB7ePP1oSgD3a+cLk0AKhT1+I9r4KFASnKvUztrOcK8AY6qmQPemTx6q
   +hRn8JrqkM2SJOETFktdwE7UQU8qqQYJI12xnC4IT1+xtR8Nrs+VbFS1T
   KNeF2+VAxmrT28j2Aaytq6EGvBpuRbZxDGMgSkziNwldhYMLbNA7w+cB5
   g==;
IronPort-SDR: /5CJsChaOHgaInoE5fLrPx6y/v9MLhiY6SQy3jAJfsvXR7CpYHiSkVhADnurO9b9y0i9D2hQuD
 CyUj4SiFZ4loXQNxYEgA8E94tVFyifxY2kSB3H8raErHsU8cbQ/xPmX+0DC7USZQveydBwannF
 PdxY534HzVKTtlZYsDfJSoQirHVMKA829NSfdjrFYhrgnxhg2r+X6hoz1OMykbjjAMvhhIdSqS
 3Fn6I11julh7rnjC886X+cIZ3u1RoePM1IJDGr6DW7CpCxSIJs+nADazf5T/Jd1vVaDQuQpjf3
 0CoroNbzkxLuh3D/DSvhY4b2
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="146447267"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2021 03:23:29 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 13 Dec 2021 03:23:27 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 13 Dec 2021 03:23:27 -0700
Date:   Mon, 13 Dec 2021 11:25:29 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 6/6] net: lan966x: Add switchdev support
Message-ID: <20211213102529.tzdvekwwngo4zgex@soft-dev3-1.localhost>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
 <20211209094615.329379-7-horatiu.vultur@microchip.com>
 <20211209133616.2kii2xfz5rioii4o@skbuf>
 <20211209164311.agnofh275znn5t5c@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211209164311.agnofh275znn5t5c@soft-dev3-1.localhost>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/09/2021 17:43, Horatiu Vultur wrote:
> > > +int lan966x_register_notifier_blocks(struct lan966x *lan966x)
> > > +{
> > > +     int err;
> > > +
> > > +     lan966x->netdevice_nb.notifier_call = lan966x_netdevice_event;
> > > +     err = register_netdevice_notifier(&lan966x->netdevice_nb);
> > > +     if (err)
> > > +             return err;
> > > +
> > > +     lan966x->switchdev_nb.notifier_call = lan966x_switchdev_event;
> > > +     err = register_switchdev_notifier(&lan966x->switchdev_nb);
> > > +     if (err)
> > > +             goto err_switchdev_nb;
> > > +
> > > +     lan966x->switchdev_blocking_nb.notifier_call = lan966x_switchdev_blocking_event;
> > > +     err = register_switchdev_blocking_notifier(&lan966x->switchdev_blocking_nb);
> > > +     if (err)
> > > +             goto err_switchdev_blocking_nb;
> > > +
> > > +     lan966x_owq = alloc_ordered_workqueue("lan966x_order", 0);
> > > +     if (!lan966x_owq) {
> > > +             err = -ENOMEM;
> > > +             goto err_switchdev_blocking_nb;
> > > +     }
> > 
> > These should be singleton objects, otherwise things get problematic if
> > you have more than one switch device instantiated in the system.
> 
> Yes, I will update this.

Actually I think they need to be part of lan966x.
Because we want each lan966x instance to be independent of each other.
This is not seen in this version but is more clear in the next version
(v4).

> 
> > 
> 
> -- 
> /Horatiu

-- 
/Horatiu
