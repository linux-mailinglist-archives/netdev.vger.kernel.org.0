Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE16181041
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 06:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgCKFx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 01:53:59 -0400
Received: from mail-vi1eur05on2082.outbound.protection.outlook.com ([40.107.21.82]:37057
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726160AbgCKFx6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 01:53:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLqG8exrZXxbauFrGf3ljltSuyt2RzpcTr7+g1dhc3ieTjTLKdKyLgqvHxmhBEvbAhsT1dxJQKPcIFqps4aKASrfhQqNw5ADifgiyyZYn4I87ZFz4Pp+lEogfYCb2Mmd6tVtC2Q95VtpzJdpDrja7vO10XQ7UGBBMU3Rbyp0JPd8+cx9WTM+DnQY3Tr5ZucdHsGHONwx1dj/zjRfAGlWZ6iiO7gj2teZQt1UAK1CuMP7mcX760QHO+XGjznkofi+lbvlddEAQB6FR7b8ig9Zu6/06wnjm1Mz7/o7Xr6MfmjTiCEfVZYoo3Ti5aMBubHMuZ4EOjaScD40hP4k/LHq5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=87rttV+1yuEH2RahdK7TcjO1im8BnWFwYQfyBBFsx+0=;
 b=jWQmtd63OXavTKgdLeFOGMimav1WFx2+2e+b5UbOBHCJmyDzLYX/SRiduT4LdwlrSS6b/8sNx+gHLlOAONTwl6OtLkE1RDaxx914gKeZsjD1i1qo9cpQhGsmGWgGPcdwA4qfT0T70vdhaFOSeJJvzliGwl1aQRtl66XCIB9BaIeZkg9rMd0zRCv9q+iA7oxnAZ9iNX4CpHmlnxQKxSe9evAb3cuuKfJSjkITO1uG2XLBmvg6DSd9xzacDMIZqY7VnbroHqIVHOJacfxKIDUrsBPyPm1R9GGiSAwBWjPG0nLxzcWYkKewGKWhCagM7odU97QtY1PVbEZEpc6vZGr/iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=87rttV+1yuEH2RahdK7TcjO1im8BnWFwYQfyBBFsx+0=;
 b=h5NCiVzsguVrBiOKf6QqVXNDKQ21L1WiI9wlr34sO3DLz1IdY+Oi+W3r/ZBvm/EzHcaZq15zENbOvObgkDmnLXNA+KjHjB1oS/poRp8p1X4cYfbUEkJNIywbr7h4qV/YoWDmK8zce+pAMYhB/iUPanpdJ1jnPbbcFFMwAQGPrgo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
Received: from DB8PR04MB5643.eurprd04.prod.outlook.com (20.179.10.153) by
 DB8PR04MB5802.eurprd04.prod.outlook.com (20.179.9.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Wed, 11 Mar 2020 05:53:53 +0000
Received: from DB8PR04MB5643.eurprd04.prod.outlook.com
 ([fe80::e1be:98ef:d81c:1eef]) by DB8PR04MB5643.eurprd04.prod.outlook.com
 ([fe80::e1be:98ef:d81c:1eef%2]) with mapi id 15.20.2793.013; Wed, 11 Mar 2020
 05:53:53 +0000
Date:   Wed, 11 Mar 2020 11:23:39 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     dan.carpenter@oracle.com
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ajay Gupta <ajayg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net] device property: change device_get_phy_mode() to
 prevent signedess bugs
Message-ID: <20200311055339.GA22511@lsv03152.swis.in-blr01.nxp.com>
References: <20200131045953.wbj66jkvijnmf5s2@kili.mountain>
 <202002031247.fhmzF9z1%lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202002031247.fhmzF9z1%lkp@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR02CA0079.apcprd02.prod.outlook.com
 (2603:1096:4:90::19) To DB8PR04MB5643.eurprd04.prod.outlook.com
 (2603:10a6:10:aa::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0079.apcprd02.prod.outlook.com (2603:1096:4:90::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Wed, 11 Mar 2020 05:53:47 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e5b4970f-1d53-4c77-6f34-08d7c580943e
X-MS-TrafficTypeDiagnostic: DB8PR04MB5802:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB58022965533541FB586A6464D2FC0@DB8PR04MB5802.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(376002)(366004)(199004)(956004)(8676002)(1006002)(4326008)(966005)(44832011)(9686003)(7696005)(6666004)(52116002)(6506007)(55236004)(478600001)(55016002)(8936002)(81156014)(6916009)(81166006)(66556008)(66946007)(66476007)(16526019)(186003)(316002)(54906003)(1076003)(7416002)(86362001)(33656002)(5660300002)(2906002)(26005)(110426005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB5802;H:DB8PR04MB5643.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6IOVktekxdlG08PF3bCr3OjxPwh24/AOps4wXQ0ktCUtSFXHFK+MDHbd5j/IAR4OWrShfAvh4zYiH3wusoEHzAkFPkTthYH0IT9iB2sn0I0FXsGBgHznFrrVN0Sbfn2oQUVpwZXsT2oqhwXrYbumrck6BK4R97GbVa6A8uX/XMFoOJPemNiuRnvR+uGg3xYmoU1uSXYaFO0noIZGAqUPxS7ZD2pZqa/tQSzne01a6JCUmHNLq9F2/u/kQh/O4t2yBif/FVQSxtkAzLlhY+ZDK5yuWT7gw1UJcOhZNhEejRjdQ6TAj+nipf/ONym2jFO/SvFvNbsKx7w3mUjnIaDrWs2H0h1goxtCQuoz9GD5gcQGg2dWSnAWHWZwkCXCIn9GHjbMQWWzzg1IzYlldf9D/5tk9tJHFUwKx7jNRgTQgDea4hsrUigrPaYAlvBQ2AH5cPOaY2YRHKfh4YYlvaLuUcmUq99JKwvsCcV4WpW7dNIsM9cQ1gp9TCrtejSBsmx+t7Y9iAotr0zHZRA2YYFkV+jqCu+8vdDc/W8H1JTzwOjMaErahMKBOFXFBAadwb17
X-MS-Exchange-AntiSpam-MessageData: ojdF8xquXkdcER073Fu8K0vbCkFu52sl/NnolF/pR6nNLJBmqR4/gAQ45xeH7r5FnLVR6GE9nmF84kcMY+pa5Yc0axoBf08eVjGjovLegqW+t+yhQJHjojK0T/NKcvuXSDr+cQYAru9XNm4QScKLiw==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5b4970f-1d53-4c77-6f34-08d7c580943e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 05:53:53.5866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8jxq6DdOProjWeYYcPbQUkttCu/lqTfTgp8Db0+MfqNWmdNsUp5AHoPkll5dZ2JoRIBbvsaOWkzIc6TZHaYG5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5802
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

Do you plan to send v2 of this patch set?
https://lkml.org/lkml/2020/1/31/1
I'm preparing my patch set on top of this. Hence the query.

Thanks
Calvin

On Mon, Feb 03, 2020 at 05:11:49AM +0000, kbuild test robot wrote:
> Hi Dan,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on net/master]
> [also build test WARNING on driver-core/driver-core-testing linus/master v5.5 next-20200131]
> [cannot apply to sparc-next/master]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/Dan-Carpenter/device-property-change-device_get_phy_mode-to-prevent-signedess-bugs/20200203-043126
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git b7c3a17c6062701d97a0959890a2c882bfaac537
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.1-154-g1dc00f87-dirty
>         make ARCH=x86_64 allmodconfig
>         make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> 
> sparse warnings: (new ones prefixed by >>)
> 
>    arch/x86/boot/compressed/cmdline.c:5:20: sparse: sparse: multiple definitions for function 'set_fs'
> >> arch/x86/include/asm/uaccess.h:29:20: sparse:  the previous one is here
>    arch/x86/boot/compressed/../cmdline.c:28:5: sparse: sparse: symbol '__cmdline_find_option' was not declared. Should it be static?
>    arch/x86/boot/compressed/../cmdline.c:100:5: sparse: sparse: symbol '__cmdline_find_option_bool' was not declared. Should it be static?
> 
> vim +29 arch/x86/include/asm/uaccess.h
> 
> ca23386216b9d4 include/asm-x86/uaccess.h      Glauber Costa   2008-06-13  27  
> 13d4ea097d18b4 arch/x86/include/asm/uaccess.h Andy Lutomirski 2016-07-14  28  #define get_fs()	(current->thread.addr_limit)
> 5ea0727b163cb5 arch/x86/include/asm/uaccess.h Thomas Garnier  2017-06-14 @29  static inline void set_fs(mm_segment_t fs)
> 5ea0727b163cb5 arch/x86/include/asm/uaccess.h Thomas Garnier  2017-06-14  30  {
> 5ea0727b163cb5 arch/x86/include/asm/uaccess.h Thomas Garnier  2017-06-14  31  	current->thread.addr_limit = fs;
> 5ea0727b163cb5 arch/x86/include/asm/uaccess.h Thomas Garnier  2017-06-14  32  	/* On user-mode return, check fs is correct */
> 5ea0727b163cb5 arch/x86/include/asm/uaccess.h Thomas Garnier  2017-06-14  33  	set_thread_flag(TIF_FSCHECK);
> 5ea0727b163cb5 arch/x86/include/asm/uaccess.h Thomas Garnier  2017-06-14  34  }
> ca23386216b9d4 include/asm-x86/uaccess.h      Glauber Costa   2008-06-13  35  
> 
> :::::: The code at line 29 was first introduced by commit
> :::::: 5ea0727b163cb5575e36397a12eade68a1f35f24 x86/syscalls: Check address limit on user-mode return
> 
> :::::: TO: Thomas Garnier <thgarnie@google.com>
> :::::: CC: Thomas Gleixner <tglx@linutronix.de>
> 
> ---
> 0-DAY kernel test infrastructure                 Open Source Technology Center
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
