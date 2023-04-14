Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E626E21AB
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 13:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbjDNLGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 07:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjDNLFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 07:05:54 -0400
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BB21BEA;
        Fri, 14 Apr 2023 04:05:37 -0700 (PDT)
X-QQ-mid: Yeas43t1681470298t808t23419
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FL9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 8627864248020985095
To:     "'Wolfram Sang'" <wsa@kernel.org>,
        "'Jarkko Nikula'" <jarkko.nikula@linux.intel.com>
Cc:     <netdev@vger.kernel.org>, <linux@armlinux.org.uk>,
        <linux-i2c@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <mengyuanlou@net-swift.com>
References: <20230411092725.104992-1-jiawenwu@trustnetic.com> <20230411092725.104992-3-jiawenwu@trustnetic.com> <00cf01d96c58$8d3e9130$a7bbb390$@trustnetic.com> <09dc3146-a1c6-e1a3-c8bd-e9fe547f9b99@linux.intel.com> <ZDgtryRooJdVHCzH@sai>
In-Reply-To: <ZDgtryRooJdVHCzH@sai>
Subject: RE: [PATCH net-next v2 2/6] net: txgbe: Implement I2C bus master driver
Date:   Fri, 14 Apr 2023 19:04:56 +0800
Message-ID: <01ec01d96ec0$f2e10670$d8a31350$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQJXy8bYFbRwx/PFgpvJPX7PgyT97wJCMZrbAk6D9c4BtpNb5AI7nLSFremgdRA=
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, April 14, 2023 12:29 AM, Wolfram Sang wrote:
> > > > Implement I2C bus driver to send and receive I2C messages.
> > > >
> > > > This I2C license the IP of Synopsys Designware, but without interrupt
> > > > support on the hardware design. It seems that polling mode needs to be
> > > > added in Synopsys Designware I2C driver. But currently it can only be
> > > > driven by this I2C bus master driver.
> > > >
> > > > Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> > > > ---
> > > >   drivers/net/ethernet/wangxun/Kconfig          |   1 +
> > > >   .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 153
> > > > ++++++++++++++++++
> > > >   .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  23 +++
> > > >   3 files changed, 177 insertions(+)
> > > >
> > Looks like your use case has similarities with the commit 17631e8ca2d3
> > ("i2c: designware: Add driver support for AMD NAVI GPU").
> 
> Yes, can you please check if you can't use the current i2c designware
> driver?

Hi Jarkko & Wolfram,

I read the i2c designware driver code, and found that 'dev->ss_hcnt' can
only be obtained by i2c_dw_acpi_configure() or calculated by clock rate.

I don't quite understand how to get the clock rate. I tried to add a software
node of clock with property ("clock-frequency", 100000) and referenced by
I2C node. But it didn't work.

Can I deliver 'dev->ss_hcnt' via platform data? Or how should I fill in the
software node?


