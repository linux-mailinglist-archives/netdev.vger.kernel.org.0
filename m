Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5683A6B1A
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 17:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234447AbhFNQAI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Jun 2021 12:00:08 -0400
Received: from out28-1.mail.aliyun.com ([115.124.28.1]:40862 "EHLO
        out28-1.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbhFNQAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 12:00:07 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08197881|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0568616-0.00167767-0.941461;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047199;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=21;RT=21;SR=0;TI=SMTPD_---.KS9PVcH_1623686276;
Received: from zhouyanjie-virtual-machine(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.KS9PVcH_1623686276)
          by smtp.aliyun-inc.com(10.147.41.137);
          Mon, 14 Jun 2021 23:57:57 +0800
Date:   Mon, 14 Jun 2021 23:57:55 +0800
From:   =?UTF-8?B?5ZGo55Cw5p2w?= <zhouyanjie@wanyeetech.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com, paul@crapouillou.net
Subject: Re: [PATCH v2 2/2] net: stmmac: Add Ingenic SoCs MAC support.
Message-ID: <20210614235755.6c1bd34e@zhouyanjie-virtual-machine>
In-Reply-To: <YMYy6JMSHm1Cqdt2@lunn.ch>
References: <1623260110-25842-1-git-send-email-zhouyanjie@wanyeetech.com>
        <1623260110-25842-3-git-send-email-zhouyanjie@wanyeetech.com>
        <YMGEutCet7fP1NZ9@lunn.ch>
        <405696cb-5987-0e56-87f8-5a1443eadc19@wanyeetech.com>
        <YMICTvjyEAgPMH9u@lunn.ch>
        <346f64d9-6949-b506-258f-4cfa7eb22784@wanyeetech.com>
        <12f35415-532e-5514-bc97-683fb9655091@wanyeetech.com>
        <YMIoWS57Ra19E1qT@lunn.ch>
        <20210613163452.1f01d418@zhouyanjie-virtual-machine>
        <YMYy6JMSHm1Cqdt2@lunn.ch>
X-Mailer: Claws Mail 3.14.1 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

于 Sun, 13 Jun 2021 18:31:36 +0200
Andrew Lunn <andrew@lunn.ch> 写道:

> On Sun, Jun 13, 2021 at 04:34:52PM +0800, 周琰杰 wrote:
> > 于 Thu, 10 Jun 2021 16:57:29 +0200
> > Andrew Lunn <andrew@lunn.ch> 写道:
> >   
> > > > Here is Ingenic's reply, the time length corresponding to a
> > > > unit is 19.5ps (19500fs).    
> > > 
> > > Sometimes, there is a negative offset in the delays. So a delay
> > > value of 0 written to the register actually means -200ps or
> > > something.  
> > 
> > Ah, perhaps this explains why we still need to add fine-tuning
> > parameter in rgmii-id and rgmii-txid modes to ensure that the
> > network works properly.  
> 
> Please try to find this out. rgmii means no delay. If the hardware is
> doing -500pS by default, you need to take this into account, and add
> the 500pS back on.

I think I may have found the problem. At present, my PHY uses a
general driver, and there is no specific setting for delay-related
registers. The default delay value of PHY is 1ns, which does not meet
the delay requirement of 2ns, after and the MAC side add 500ps delay
(and possibly some delays introduced on the hardware circuit), it just
meets the requirement of 2ns delay.

> 
>     Andrew
