Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12783144559
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 20:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgAUTrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 14:47:20 -0500
Received: from relay-b02.edpnet.be ([212.71.1.222]:40773 "EHLO
        relay-b02.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729031AbgAUTrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 14:47:16 -0500
X-ASG-Debug-ID: 1579636032-0a7b8d6ce022f8c60001-BZBGGp
Received: from zotac.vandijck-laurijssen.be ([77.109.89.38]) by relay-b02.edpnet.be with ESMTP id F17EWZrY6NujMrjn; Tue, 21 Jan 2020 20:47:12 +0100 (CET)
X-Barracuda-Envelope-From: dev.kurt@vandijck-laurijssen.be
X-Barracuda-Effective-Source-IP: UNKNOWN[77.109.89.38]
X-Barracuda-Apparent-Source-IP: 77.109.89.38
Received: from x1.vandijck-laurijssen.be (x1.vandijck-laurijssen.be [IPv6:fd01::1a1d:eaff:fe02:d339])
        by zotac.vandijck-laurijssen.be (Postfix) with ESMTPSA id A3C57C6ABC7;
        Tue, 21 Jan 2020 20:47:12 +0100 (CET)
Date:   Tue, 21 Jan 2020 20:47:11 +0100
From:   Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        o.rempel@pengutronix.de,
        syzbot <syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>, linux-can@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: general protection fault in can_rx_register
Message-ID: <20200121194711.GD13462@x1.vandijck-laurijssen.be>
X-ASG-Orig-Subj: Re: general protection fault in can_rx_register
Mail-Followup-To: Oliver Hartkopp <socketcan@hartkopp.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, o.rempel@pengutronix.de,
        syzbot <syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>, linux-can@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <00000000000030dddb059c562a3f@google.com>
 <55ad363b-1723-28aa-78b1-8aba5565247e@hartkopp.net>
 <20200120091146.GD11138@x1.vandijck-laurijssen.be>
 <CACT4Y+a+GusEA1Gs+z67uWjtwBRp_s7P4Wd_SMmgpCREnDu3kg@mail.gmail.com>
 <8332ec7f-2235-fdf6-9bda-71f789c57b37@hartkopp.net>
 <2a676c0e-20f2-61b5-c72b-f51947bafc7d@hartkopp.net>
 <20200121083035.GD14537@x1.vandijck-laurijssen.be>
 <20200121185407.GA13462@x1.vandijck-laurijssen.be>
 <a04209c8-747b-6116-d915-21c285f48730@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a04209c8-747b-6116-d915-21c285f48730@hartkopp.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Barracuda-Connect: UNKNOWN[77.109.89.38]
X-Barracuda-Start-Time: 1579636032
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 2374
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: SPAM GLOBAL 0.9757 1.0000 4.0624
X-Barracuda-Spam-Score: 4.06
X-Barracuda-Spam-Status: No, SCORE=4.06 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.79488
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On di, 21 jan 2020 20:28:51 +0100, Oliver Hartkopp wrote:
> Hi Kurt,
> 
> On 21/01/2020 19.54, Kurt Van Dijck wrote:
> >On di, 21 jan 2020 09:30:35 +0100, Kurt Van Dijck wrote:
> >>On ma, 20 jan 2020 23:35:16 +0100, Oliver Hartkopp wrote:
> 
> 
> >>>But it is still open why dev->ml_priv is not set correctly in vxcan.c as all
> >>>the settings for .priv_size and in vxcan_setup look fine.
> >>
> >>Maybe I got completely lost:
> >>Shouldn't can_ml_priv and vxcan_priv not be similar?
> >>Where is the dev_rcv_lists in the vxcan case?
> >
> >I indeed got completely lost. vxcan_priv & can_ml_priv form together the
> >private part. I continue looking
> 
> I added some more debug output:
> 
> @@ -463,6 +463,10 @@ int can_rx_register(struct net *net, struct net_device
> *dev, canid_t can_id,
>         spin_lock_bh(&net->can.rcvlists_lock);
> 
>         dev_rcv_lists = can_dev_rcv_lists_find(net, dev);
> +       if (!dev_rcv_lists) {
> +               pr_err("dev_rcv_lists == NULL! %p (%s)\n", dev, dev->name);
> +               goto out_unlock;
> +       }
>         rcv_list = can_rcv_list_find(&can_id, &mask, dev_rcv_lists);
> 
>         rcv->can_id = can_id;
> 
> 
> and the output becomes:
> 
> [ 1814.644087] bond5130: (slave vxcan1): The slave device specified does not
> support setting the MAC address
> [ 1814.644106] bond5130: (slave vxcan1): Error -22 calling dev_set_mtu
> [ 1814.648867] bond5128: (slave vxcan1): The slave device specified does not
> support setting the MAC address
> [ 1814.648904] bond5128: (slave vxcan1): Error -22 calling dev_set_mtu
> [ 1814.649124] dev_rcv_lists == NULL! 000000008e41fb06 (bond5128)
> [ 1814.696420] bond5129: (slave vxcan1): The slave device specified does not
> support setting the MAC address
> [ 1814.696438] bond5129: (slave vxcan1): Error -22 calling dev_set_mtu
> 
> So it's not the vxcan1 netdev that causes the issue but (sporadically!!) the
> bonding netdev.
> 
> Interesting enough that the bonding device bond5128 obviously passes the
> 
>        if (dev && dev->type != ARPHRD_CAN)
>                 return -ENODEV;
> test.
> 
> ?!?
Did you consider my hypothesis I sent you (at 20h22 tonight)?
I don't personally understand all the locks around networking, but your
observation acks my theory of race condition.

> 
> Regards,
> Oliver
