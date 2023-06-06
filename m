Return-Path: <netdev+bounces-8281-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E0D9723857
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:04:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 867941C20D93
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD0355663;
	Tue,  6 Jun 2023 07:03:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF9353B9
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:03:59 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2096.outbound.protection.outlook.com [40.107.223.96])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9811B8
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:03:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0wcn++kz5s5kaG6kMb9d99I7kvuKvWn8FG/VooG/f5LFek/SLakyY/Od6fFWwGgppGgjKGKjiDSZRIZvbDIeAS5Bes2Fnzo5u+HZKT9hNCuvmb3VCr06yvfPuR3HzSAX0gJ0eQEJLsKZ0k7RDN0vS5K0rHXntSdWtHmT9zemus4SHF/PQianXjBSTBgxWQLQHzkl6aaL1FKS99LXczjg6LC1kMrJBv2uFl/7plUphCe58tUxgbBs2ETwPgjyV8ba8zf719EFyxjBr75E9mWfzm4y0huqBcenJyf9miS0BIc20D59N2nUvGUVd1nvcfUo5W94Jbi0m4rgf6/pa0UfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U++0qlq7KDGahsXeq7m/ahTNgGtfJGUZYnRr3grtEQY=;
 b=BUYCZikJCBl9fRmFRO2XG8AqIT0Qd5ICT4jB45NksnlNG4zPvf0RNbw+0bpjH6RI53H9BNcuWlIkN3xj7qcWSxsEruQjyJmHCji8QMDSeUZWnZH4f8FPwmqsBvfLjj/d9CvYF7yBmmOTtKD17dxy+98cgzmJGQ7pY7mZ+EanECpiS8jx9tAklUPOjQ5/QSdFFJafyllNkNDi4s6PN78s6FT5ulltzV2b19HBQhqaDJqoc7wuW77KN/uMy4hQm8LqPIKpOSF3K5fLeVRt09DZ2sGaZXLTTMw8ahzCzKzwbB3IlaZ2FNpalcLhszIGjOEARKDiBT/lMIEiZPieBa70oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U++0qlq7KDGahsXeq7m/ahTNgGtfJGUZYnRr3grtEQY=;
 b=gfxst03sSmC20f0D0qnR7km68/4kl9WE9CcXj5EsMToqqeoEfJFiv0UQ/eNOLNfRSqUHsMkRs0xb3dx/sHGwCktGYuAIy4t4jIZlG0tgpKhOL0yeIzgVwnHdgCgmqVG/BlJ5p5IpKZDejhs9I5EfJmkFxS7mvP6Xt/+aYu1SXPw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3876.namprd13.prod.outlook.com (2603:10b6:a03:22c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 07:03:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 07:03:54 +0000
Date: Tue, 6 Jun 2023 09:03:48 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: Jakub Kicinski <kuba@kernel.org>, kernel test robot <lkp@intel.com>,
	oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [net-next:main 3/19]
 drivers/net/ethernet/altera/altera_tse_main.c:1419: undefined reference to
 `lynx_pcs_create_mdiodev'
Message-ID: <ZH7aVIieVCXngfZm@corigine.com>
References: <202306060325.l3TVneV8-lkp@intel.com>
 <20230605132839.1b604580@kernel.org>
 <20230606085233.41db238a@pc-7.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606085233.41db238a@pc-7.home>
X-ClientProxiedBy: AS4P190CA0023.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3876:EE_
X-MS-Office365-Filtering-Correlation-Id: f68ba9fa-6f2b-42ef-7cbd-08db665c3039
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	z+XoD37drIHWnXGlyup+OpQ7NO5FlM2zQzYPXAX+12UDSMLyoRvo3IiwnsDPjrcgIbc71infFT83k5e2+nugKlZqfE8LaYtnKvUx8ijT4vxlD+2N3/eojLaoxdSQ2tJrgMaG5RBZtOb/eiqZBESObwroJ9r3kdctcDqBJmWZ9/QjPxlsrbUVcXAobiZEwf/c9yxGG1rRuhTydgVN9qbjLHGITiiWzRXsu/jfKE5YNYRTUkjgvXMRV0B0z5oY1PsWGtck8g/ys31NyTE7byj6sBrxAMCdLPP2SyRJHNFza655K5Ql4cRjZMK4pqmX/Y9UWe4b6OagI9Fn3/nvCS25jLWFaajydIEUjrm81zpc8TW0Q0UhI3l+FHTex7GAlTx0BVWX822JZLUD+8Rt9w9NGiOjaBu/y9PPsXpdIv3s4CYdgY4LTsy2/c6TroM7gxEgs8H3aQ6Wi2MeQPbkDnbfVNkHNunj3a0cqz2YAqQpqKS0AQb9LZO27JWpgEOO4BzAWyad0ZgAd3iAika3+UY+UgtlbQS5H1h/tg26rFRWND957r8e5y6qCCXwoWNG6mh7hX4MqYMyyM3QF6KFKa+ATQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(39830400003)(346002)(396003)(451199021)(6512007)(2616005)(6506007)(44832011)(316002)(83380400001)(4326008)(66556008)(66476007)(6916009)(66946007)(966005)(6486002)(6666004)(186003)(478600001)(54906003)(36756003)(2906002)(5660300002)(8676002)(8936002)(86362001)(41300700001)(38100700002)(81973001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qPlzGSDL8LMyLN+N8FTbOwtVjCLz34riFnKx8YSSzA0r8DhLYjs5ySbjAJHc?=
 =?us-ascii?Q?iMwmHIFfA1aHbT3PmXNX7b0bAGnByQuhPL3EY7pscSOXChhWvnl7230AhOwH?=
 =?us-ascii?Q?Xl97bg3XpYawQOcvhQmZduBbFK+ZaO3adpO3zDDaAGT4gbJSkpR6WwR++pH7?=
 =?us-ascii?Q?bPRV+MGegAJoMDFGZ/ljkFumv1z53yv1EXlnVmohKdGJ25PTkaJLoTfp9zXF?=
 =?us-ascii?Q?WUet/FBDfxUtIs9DA4/qWSFW20C0oxcj+MoQBZS+D7glKtauLffsnyuSwIsQ?=
 =?us-ascii?Q?WCk687a65zNW8R9lbGI/LmVztx+82sgz88mEg06Sh3BSqTvJV6SRwHQB7Gnj?=
 =?us-ascii?Q?tBY/SfbVXiFVIoZs7t0D4IWWKuk9eNKqQ/xBF4vebACA9xVvLUCE3n7s8aHt?=
 =?us-ascii?Q?EE8hK5NxP4+HocBkq5KALojRE9eP43wlVWMz8DvoPPOszyzrvQiVSPROmd6P?=
 =?us-ascii?Q?9/al8TBxmAurWO/Jjg9iBp8snQGyxa++Oz8RbaSATUs6AlEBCE8kEtDGMc7k?=
 =?us-ascii?Q?XDYzlUQ8l+EOpr7jPAvBWrM1oeedEy1AqZJ70EufUnmdWieFKYtre/3i8qd5?=
 =?us-ascii?Q?cwFwV3F41dVaeK/UyPVJ1NJWEyfJNrtS9Q3/L3X2OeBP5b/tjoEi0qfcWv/j?=
 =?us-ascii?Q?nQDlu/w3PEWYNCo2O6dwxqFP4vW0PsxUiR9Rs4biNLJH+VwO4a8yie4uRWR1?=
 =?us-ascii?Q?6wY0vCVhK4zjgie+VPTFykWGZFrUHhBpcv6eCstsUkZpQVcPyAHlc3B/c66x?=
 =?us-ascii?Q?wY2CfHassuJUmKqjLpa1RdyrQlRCKjNhpfU+AjwFI0Wi+9X6mVWY3IRFHNgO?=
 =?us-ascii?Q?woJt7z9qrSFq4ryL74kiSULxZFUphwxzc15cjzGm+/P/TaTN00kn3TzZFpu4?=
 =?us-ascii?Q?Mx9rYDhS5zIot++Y/f71YxmPeC6DCcM4FckRURmeo4uMFTj5atILd/TB11X9?=
 =?us-ascii?Q?6oKeC7vwTT0cqFVYd0ggQjkCrndQkOj0mf4NkMqZewa+LlJvs0g/3JuJOWLp?=
 =?us-ascii?Q?QMsjeBLDCyz6zOoNIlGZviDbqheauKY3EZZ1DF9cKZt/mCjPYo2R8kQ0gaa7?=
 =?us-ascii?Q?Gj4L+gwYavfDgJ1n3VXOJzT2Ef3gGiQb0U5LAKeQzkz/VDuMjsJ4rCalBMX/?=
 =?us-ascii?Q?9FXewYv9CDV0Nj2zMJ3va5KuzmMFwaNQ56tWaPU03BhoHUlaCLtj9epAoL7B?=
 =?us-ascii?Q?CfquptjxRsxyjRX4awzlJsg1pMwWDD07TlPojvItMKHrMuG6QitRkGRdp2Nz?=
 =?us-ascii?Q?4CLYxjgpQ/65Xs7GhjRTyDNLPjwQo4GrXwjVqFJ65eVk6UJcAmemgGdSAJWE?=
 =?us-ascii?Q?uT9yBf+jZTkZrlCLfh2bmOa0ljCiq4ODcCBke/Czz/IWA/Q/dCYqIg1Qv4WU?=
 =?us-ascii?Q?xDKjofx/SBWNInz2SuNF66ViMGYipilkwrNu49iv2LPJ+/pKGFcWxQY9n/z5?=
 =?us-ascii?Q?T+yk9oVCTZ1ygJIq8OW88ZaHwFSpsRmXCkxz3q3W7n9YJvid4wfOxEfHvFYm?=
 =?us-ascii?Q?M80+OP73mjRg0pey/bjEje8cET9WaNbAG+Zged8Go3VFe4L7NLxamDnwDkz5?=
 =?us-ascii?Q?Ak32ZYIa24zH5pXJ11iNl4DWU05Ke9kJDHM/N3dABHKaAYm0XgKnzi9VuIKV?=
 =?us-ascii?Q?glzuMXjRLaZCOUNDQA1Wx9Gl4ixUQkDrOsuetzaEROy7YYNeYaa8wMOmxi3r?=
 =?us-ascii?Q?8Yb+2A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f68ba9fa-6f2b-42ef-7cbd-08db665c3039
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 07:03:53.9366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SMZqLpL3E85F2peNY7FG8PG9nzZMWrrI8XhfGscJSjTdq96cPSgLrhs2dvTBfce6cFotFfmtSSki7ZScBGJ6hfmhf5rsqnyIez9Wvtrk/rM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3876
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 08:52:33AM +0200, Maxime Chevallier wrote:
> Hello Jakub,
> 
> On Mon, 5 Jun 2023 13:28:39 -0700
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > On Tue, 6 Jun 2023 03:17:47 +0800 kernel test robot wrote:
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git main
> > > head:   69da40ac3481993d6f599c98e84fcdbbf0bcd7e0
> > > commit: db48abbaa18e571106711b42affe68ca6f36ca5a [3/19] net: ethernet: altera-tse: Convert to mdio-regmap and use PCS Lynx
> > > config: nios2-defconfig (https://download.01.org/0day-ci/archive/20230606/202306060325.l3TVneV8-lkp@intel.com/config)
> > > compiler: nios2-linux-gcc (GCC) 12.3.0
> > > reproduce (this is a W=1 build):
> > >         mkdir -p ~/bin
> > >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> > >         chmod +x ~/bin/make.cross
> > >         # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=db48abbaa18e571106711b42affe68ca6f36ca5a
> > >         git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
> > >         git fetch --no-tags net-next main
> > >         git checkout db48abbaa18e571106711b42affe68ca6f36ca5a
> > >         # save the config file
> > >         mkdir build_dir && cp config build_dir/.config
> > >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=nios2 olddefconfig
> > >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=nios2 SHELL=/bin/bash
> > > 
> > > If you fix the issue, kindly add following tag where applicable
> > > | Reported-by: kernel test robot <lkp@intel.com>
> > > | Closes: https://lore.kernel.org/oe-kbuild-all/202306060325.l3TVneV8-lkp@intel.com/
> > > 
> > > All errors (new ones prefixed by >>):
> > > 
> > >    nios2-linux-ld: drivers/net/ethernet/altera/altera_tse_main.o: in function `altera_tse_probe':  
> > > >> drivers/net/ethernet/altera/altera_tse_main.c:1419: undefined reference to `lynx_pcs_create_mdiodev'    
> > >    drivers/net/ethernet/altera/altera_tse_main.c:1419:(.text+0xd7c): relocation truncated to fit: R_NIOS2_CALL26 against `lynx_pcs_create_mdiodev'  
> > > >> nios2-linux-ld: drivers/net/ethernet/altera/altera_tse_main.c:1451: undefined reference to `lynx_pcs_destroy'    
> > >    drivers/net/ethernet/altera/altera_tse_main.c:1451:(.text+0xdf8): relocation truncated to fit: R_NIOS2_CALL26 against `lynx_pcs_destroy'
> > >    nios2-linux-ld: drivers/net/ethernet/altera/altera_tse_main.o: in function `altera_tse_remove':  
> > > >> drivers/net/ethernet/altera/altera_tse_main.c:1473: undefined reference to `lynx_pcs_destroy'    
> > >    drivers/net/ethernet/altera/altera_tse_main.c:1473:(.text+0x1564): relocation truncated to fit: R_NIOS2_CALL26 against `lynx_pcs_destroy'  
> > 
> > Hum, if it doesn't build without the patch from Mark's tree, I think
> > we'll need to revert..
> 
> Hmpf that's an unrelated error on my side... I've sent a followup
> fix a few minutes ago. Sorry about that.

First, sorry for this mess, which I feel partly responsible for.

Second, can I clarify that the patchset [1] is intended to
resolve the build problems we have seen over the past day?

[1] [PATCH net-next 0/2] Followup fixes for the dwmac and altera lynx conversion
    https://lore.kernel.org/all/20230606064914.134945-1-maxime.chevallier@bootlin.com/

