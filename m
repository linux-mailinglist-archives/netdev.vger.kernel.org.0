Return-Path: <netdev+bounces-6744-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 972F3717BBA
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:22:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53573281336
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC451D313;
	Wed, 31 May 2023 09:22:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DC7D2F9
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:22:17 +0000 (UTC)
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3808129
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 02:22:14 -0700 (PDT)
X-QQ-mid:Yeas44t1685524789t455t56494
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [183.159.96.128])
X-QQ-SSF:00400000000000F0FOF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 10707911515186658702
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
References: <20230524091722.522118-6-jiawenwu@trustnetic.com> <202305261959.mnGUW17n-lkp@intel.com> <ZHCZ0hLKARXu3xFH@shell.armlinux.org.uk> <02dd01d991d2$2120fcf0$6362f6d0$@trustnetic.com> <03ac01d992d2$67c1ec90$3745c5b0$@trustnetic.com>
In-Reply-To: <03ac01d992d2$67c1ec90$3745c5b0$@trustnetic.com>
Subject: RE: [PATCH net-next v9 5/9] net: txgbe: Add SFP module identify
Date: Wed, 31 May 2023 17:19:47 +0800
Message-ID: <046e01d993a1$0b8f51e0$22adf5a0$@trustnetic.com>
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
Thread-Index: AQFlCTXCD0V13/nxYaH3lJLB+zCPMgFguorBARt7XSgCWWopnAJhtNzYsCNyvSA=
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tuesday, May 30, 2023 4:41 PM, Jiawen Wu wrote:
> On Monday, May 29, 2023 10:06 AM, Jiawen Wu wrote:
> > On Friday, May 26, 2023 7:37 PM, Russell King (Oracle) wrote:
> > > On Fri, May 26, 2023 at 07:30:45PM +0800, kernel test robot wrote:
> > > > Kconfig warnings: (for reference only)
> > > >    WARNING: unmet direct dependencies detected for I2C_DESIGNWARE_PLATFORM
> > > >    Depends on [n]: I2C [=n] && HAS_IOMEM [=y] && (ACPI && COMMON_CLK [=y] || !ACPI)
> > > >    Selected by [y]:
> > > >    - TXGBE [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_WANGXUN [=y] && PCI [=y]
> > > >    WARNING: unmet direct dependencies detected for SFP
> > > >    Depends on [n]: NETDEVICES [=y] && PHYLIB [=y] && I2C [=n] && PHYLINK [=y] && (HWMON [=n] || HWMON [=n]=n)
> > > >    Selected by [y]:
> > > >    - TXGBE [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_WANGXUN [=y] && PCI [=y]
> > >
> > > ... and is basically caused by "select SFP". No. Do not do this unless
> > > you look at the dependencies for SFP and ensure that those are also
> > > satisfied - because if you don't you create messes like the above
> > > build errors.
> >
> > So how do I make sure that the module I need compiles and loads correctly,
> > rely on the user to manually select it?
> 
> When I changed the TXGBE config to:
> ...
> 	depends on SFP
> 	select PCS_XPCS
> ...
> the compilation gave an error:
> 
> drivers/net/phy/Kconfig:16:error: recursive dependency detected!
> drivers/net/phy/Kconfig:16:     symbol PHYLIB is selected by PHYLINK
> drivers/net/phy/Kconfig:6:      symbol PHYLINK is selected by PCS_XPCS
> drivers/net/pcs/Kconfig:8:      symbol PCS_XPCS is selected by TXGBE
> drivers/net/ethernet/wangxun/Kconfig:40:        symbol TXGBE depends on SFP
> drivers/net/phy/Kconfig:63:     symbol SFP depends on PHYLIB
> For a resolution refer to Documentation/kbuild/kconfig-language.rst
> subsection "Kconfig recursive dependency limitations"
> 
> Seems deleting "depends on SFP" is the correct way. But is this normal?
> How do we ensure the dependency between TXGBE and SFP?

Hi Russell,

Could you please give me some suggestions?

I checked "kconfig-language" doc, the practical solution is that swap all
"select FOO" to "depends on FOO" or swap all "depends on FOO" to
"select FOO". Config PCS_XPCS has to be selected in order to load modules
properly, so how should I fix the warning?


