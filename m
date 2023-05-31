Return-Path: <netdev+bounces-6755-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE854717CF4
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:13:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A7651C20DB5
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24BA613ACD;
	Wed, 31 May 2023 10:13:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135643D64
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 10:13:28 +0000 (UTC)
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73AEF12B
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 03:13:23 -0700 (PDT)
X-QQ-mid:Yeas43t1685527903t560t14403
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [183.159.96.128])
X-QQ-SSF:00400000000000F0FOF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 14749073908177250109
To: "'Russell King \(Oracle\)'" <linux@armlinux.org.uk>
Cc: <netdev@vger.kernel.org>,
	<jarkko.nikula@linux.intel.com>,
	<andriy.shevchenko@linux.intel.com>,
	<mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>,
	<Jose.Abreu@synopsys.com>,
	<andrew@lunn.ch>,
	<hkallweit1@gmail.com>,
	<oe-kbuild-all@lists.linux.dev>,
	<linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>,
	<mengyuanlou@net-swift.com>,
	"'Piotr Raczynski'" <piotr.raczynski@intel.com>
References: <20230524091722.522118-6-jiawenwu@trustnetic.com> <202305261959.mnGUW17n-lkp@intel.com> <ZHCZ0hLKARXu3xFH@shell.armlinux.org.uk> <02dd01d991d2$2120fcf0$6362f6d0$@trustnetic.com> <03ac01d992d2$67c1ec90$3745c5b0$@trustnetic.com> <ZHcXvFvR3H8Vmyok@shell.armlinux.org.uk>
In-Reply-To: <ZHcXvFvR3H8Vmyok@shell.armlinux.org.uk>
Subject: RE: [PATCH net-next v9 5/9] net: txgbe: Add SFP module identify
Date: Wed, 31 May 2023 18:11:42 +0800
Message-ID: <047f01d993a8$4c4465c0$e4cd3140$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFlCTXCD0V13/nxYaH3lJLB+zCPMgFguorBARt7XSgCWWopnAJhtNzYAOnc7CuwHDLfgA==
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wednesday, May 31, 2023 5:48 PM, Russell King (Oracle) wrote:
> On Tue, May 30, 2023 at 04:40:36PM +0800, Jiawen Wu wrote:
> > On Monday, May 29, 2023 10:06 AM, Jiawen Wu wrote:
> > > On Friday, May 26, 2023 7:37 PM, Russell King (Oracle) wrote:
> > > > On Fri, May 26, 2023 at 07:30:45PM +0800, kernel test robot wrote:
> > > > > Kconfig warnings: (for reference only)
> > > > >    WARNING: unmet direct dependencies detected for I2C_DESIGNWARE_PLATFORM
> > > > >    Depends on [n]: I2C [=n] && HAS_IOMEM [=y] && (ACPI && COMMON_CLK [=y] || !ACPI)
> > > > >    Selected by [y]:
> > > > >    - TXGBE [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_WANGXUN [=y] && PCI [=y]
> > > > >    WARNING: unmet direct dependencies detected for SFP
> > > > >    Depends on [n]: NETDEVICES [=y] && PHYLIB [=y] && I2C [=n] && PHYLINK [=y] && (HWMON [=n] || HWMON [=n]=n)
> > > > >    Selected by [y]:
> > > > >    - TXGBE [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_WANGXUN [=y] && PCI [=y]
> > > >
> > > > ... and is basically caused by "select SFP". No. Do not do this unless
> > > > you look at the dependencies for SFP and ensure that those are also
> > > > satisfied - because if you don't you create messes like the above
> > > > build errors.
> > >
> > > So how do I make sure that the module I need compiles and loads correctly,
> > > rely on the user to manually select it?
> >
> > When I changed the TXGBE config to:
> > ...
> > 	depends on SFP
> > 	select PCS_XPCS
> > ...
> > the compilation gave an error:
> >
> > drivers/net/phy/Kconfig:16:error: recursive dependency detected!
> > drivers/net/phy/Kconfig:16:     symbol PHYLIB is selected by PHYLINK
> > drivers/net/phy/Kconfig:6:      symbol PHYLINK is selected by PCS_XPCS
> > drivers/net/pcs/Kconfig:8:      symbol PCS_XPCS is selected by TXGBE
> > drivers/net/ethernet/wangxun/Kconfig:40:        symbol TXGBE depends on SFP
> > drivers/net/phy/Kconfig:63:     symbol SFP depends on PHYLIB
> > For a resolution refer to Documentation/kbuild/kconfig-language.rst
> > subsection "Kconfig recursive dependency limitations"
> >
> > Seems deleting "depends on SFP" is the correct way. But is this normal?
> > How do we ensure the dependency between TXGBE and SFP?
> 
> First, I would do this:
> 
> 	select PHYLINK
> 	select PCS_XPCS
> 
> but then I'm principled, and I don't agree that PCS_XPCS should be
> selecting PHYLINK.
> 
> The second thing I don't particularly like is selecting user visible
> symbols, but as I understand it, with TXGBE, the SFP slot is not an
> optional feature, so there's little option.
> 
> So, because SFP requires I2C:
> 
> 	select I2C
> 	select SFP
> 
> That is basically what I meant by "you look at the dependencies for
> SFP and ensure that those are also satisfied".
> 
> Adding that "select I2C" also solves the unmet dependencies for
> I2C_DESIGNWARE_PLATFORM.
> 
> However, even with that, we're not done with the evilness of select,
> because there's one more permitted configuration combination that
> will break.
> 
> If you build TXGBE into the kernel, that will force SFP=y, I2C=y,
> PHYLINK=y, PHYLIB=y. So far so good. However, if HWMON=m, then things
> will again break. So I would also suggest:
> 
> 	select HWMON if TXGBE=y
> 
> even though you don't require it, it solves the build fallout from
> where HWMON=m but you force SFP=y.
> 
> Maybe someone else has better ideas how to do this, but the above is
> the best I can come up with.
> 
> 
> IMHO, select is nothing but pure evil, and should be used with utmost
> care and a full understanding of its ramifications, and a realisation
> that it *totally* and *utterly* blows away any "depends on" on the
> target of the select statement.
> 
> An option that states that it depends on something else generally does
> because... oddly enough, it _depends_ on that other option. So, if
> select forces an option on without its dependencies, then it's not
> surprising that stuff fails to build.
> 
> Whenever a select statement is added, one must _always_ look at the
> target symbol and consider any "depends on" there, and how to ensure
> that those dependencies are guaranteed to always be satisfied.

Thanks for the detailed explanation. I'll check each of the required options,
and use "depends on" whenever possible.


