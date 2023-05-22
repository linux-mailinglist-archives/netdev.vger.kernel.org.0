Return-Path: <netdev+bounces-4303-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00B7570BF7E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:19:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C41C01C20A6D
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C21213AD7;
	Mon, 22 May 2023 13:19:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A72B13AD5
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:19:30 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2096.outbound.protection.outlook.com [40.107.244.96])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D4B92;
	Mon, 22 May 2023 06:19:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZxJKurRn2OJEPagcpiFpQs7R4rcYxDtKB2eoBeMpxaoEJgvs9wl46CFqWTtjyusNEGBhhLfRXmwDWXw7jDRVTyyTHEBPF9Ysf8gYgk6942I+OBqmA6/lr6HeET7Yb5vQVDxYyxaBG5Ace69NODM8I6tP9ePvGr0Nx6zJb1irQTrgeMDJMrdgxNiDr2NAeahTCzqqz5KLvdbZMeZSmxMge6kacktdEedyUh4BBHlqFBansfriSutIKjY02LLGck80fLunW7eDAySg9mkFSptzSTYNmOCJkGUnXXaf0CDGKCxNlGlXaleiqgd3WFil4fMl8pbE7dbXmSKcqz19YbAHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dICBjqiR1/9R22TWV/zsh8FphYGNBfaaRVM5UzZ6J/4=;
 b=MH3kB9S+PEQ4Nb0vQ/YcWL1fgc3GqHbv4qviIq/AJVrztfdaCy7Ll/djrJb7kO27O1hgAO6/48VQER9l84jkKQU5IqaNTWFre2TSBl0t8FTKpUwULDasBSg/hURFAzX5M7cvUNMHkeAngZzfLJ/y/+urZ5hVSRW/52Kc76qm7Vw8ytOenb2WS65KlxtcAV1INEwChJLSLj73VIlJ4h37jYOlX4vNkAmmBgaW/0G47VQTouJpb8JQ98PKfaLzPn2xWPkLvQwkMJFLvrc14cphxnYiCGVoNbl5Inld9DjDFJND5hGm46p4MJ8XWV1hACRmoudAep9Bjeyy0nYxuSUPFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dICBjqiR1/9R22TWV/zsh8FphYGNBfaaRVM5UzZ6J/4=;
 b=E9sVHwfGAH45XlykVHJvWiYKnovIi8PKYmRg//zLSiaW5zN0ZxJPMCdrD7cyXzPtO/XBKEiGJ1CfC27SA0W+n4klHt54Ai5HNIYk3CLzsqOhgLlfTITJwxy5loL73XgzHt9RuKaSKgfVGt1dVr+ZPtVgDMCHF/rshs4O6GPgtTk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4684.namprd13.prod.outlook.com (2603:10b6:610:d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.25; Mon, 22 May
 2023 13:19:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 13:19:24 +0000
Date: Mon, 22 May 2023 15:19:17 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christian Brauner <brauner@kernel.org>
Cc: kernel test robot <lkp@intel.com>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	davem@davemloft.net, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Leon Romanovsky <leon@kernel.org>,
	David Ahern <dsahern@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <keescook@chromium.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Luca Boccassi <bluca@debian.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v5 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Message-ID: <ZGtr1RwK42We5ACI@corigine.com>
References: <20230517113351.308771-2-aleksandr.mikhalitsyn@canonical.com>
 <202305202107.BQoPnLYP-lkp@intel.com>
 <20230522-sammeln-neumond-e9a8d196056b@brauner>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522-sammeln-neumond-e9a8d196056b@brauner>
X-ClientProxiedBy: AM3PR05CA0094.eurprd05.prod.outlook.com
 (2603:10a6:207:1::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4684:EE_
X-MS-Office365-Filtering-Correlation-Id: bd944fcc-a5f2-49e7-7a5b-08db5ac72986
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9Y9MkdxF8VQP8eTXFoyc7+emRot0hBoMcbRcAi5D/LDjC38ADqkPwRYXI3VMZzKHqVeeGzYqTcqPYv43enUjb4EGukZ46jkw0YQG2cf5m8QhvjZt/zsX+9qKGvAJedAFMF6JCfVfW3qsw7tmWrVxhRRomcZnnc3WlUapE4wxeoRbUgJGSgfhORLZjn949LrW/kgPvylSOe/7aegjvob1LYbbMjZeJWf+4w/XILCHhJHjPKssA3S+ocidu63kSXpGIpB+POkb+UftnGtI8G2zTTw5XN7taCq0aQoSHicX2+iB+P4LxH0VkJV70sbtmCmYPa3BJCkPSc7Ye8bdj35hemrQNegfk4wR2ygr1HrRaYH3OVSxJSyForO6z8eIWm2wZ9olz+xMRBYmwnoRG4gPJuqSUu9ySOikvFVzus8iPaxwBh+OTta3bDnQ5ueWFvN3IMMbXK9ApI2/A5rAUIP5/En/pVfmRQ5FqCHG11B169fORCuLLuOGaD/QINIgkchluGw1RU+A1Snspw1iCYxYZVWZkEoQRsGNKZHTaz7BIVfqdcYQ3OjnoGDRE9BXKgqumEajS+Ckn9+Yg53Sa3MaVg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(366004)(136003)(376002)(346002)(451199021)(54906003)(186003)(5660300002)(66476007)(41300700001)(6666004)(6486002)(966005)(316002)(6916009)(4326008)(478600001)(6506007)(6512007)(7416002)(44832011)(8936002)(8676002)(2616005)(2906002)(83380400001)(66946007)(66556008)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DNoynbyJ5vefavjP5/8wlopUrMZhxYB+5zC+pS3o1Vwmj8/ktPjSw1dqWmBz?=
 =?us-ascii?Q?yvT0j/hwYBlY748owHI/CfBfyU2ZnmEPE+K1vfajFSoYR6lQCgjAdRNoKjxW?=
 =?us-ascii?Q?vsPDEITWGBHAkasgWcaTpqdyR79VkIi1aDT/ZDP/pxsmjKwzyqhGBS4WPelX?=
 =?us-ascii?Q?n3JzEsmauvC705Q+w5mZbmUQ2dFDBjb5uMqYd0V/NOcdRULOWU5VbQMVXZm/?=
 =?us-ascii?Q?gaosKJJqVTJUSUqKcjf6De6jAf21YO8gk54s6NfvDUO2tIRdhhz4XPEYJkiT?=
 =?us-ascii?Q?F6ih8fj9JgBX1124+LnDLTdHkJr/zfupqed6TD228Odg8z33LjIjzjHLdAXI?=
 =?us-ascii?Q?zaSkHdUUZmgzrpDVh4dTVWdzG0gk1kFmCaLMIvEMkcR7G9LzL4ErugJS2o2P?=
 =?us-ascii?Q?+v35x1qeR2yQAoaIp5DoeEWQAyFsTHfQ6XpLjlmVi2V+yYvMENbvW0/XrjhP?=
 =?us-ascii?Q?5h3w1+c+mC0mZ/lYuTQvOng3BLbQ0E1u4VgMh2Ck727aPaBadE8F9O5p15RS?=
 =?us-ascii?Q?w/FBo/ZRlZLWI0A4FBOSmn0Vnxbx2qyHrGDZujSXA1/17h/bSpDTZvhcHvsz?=
 =?us-ascii?Q?T24TdEG30tjTuUJhodwHHtRyn9QSTFwL1uJoXspg8TCKAal7ss+3Bzd1ZWpE?=
 =?us-ascii?Q?An1GXWjg/IoDPjs1nU4y1e5oBwpTa6ncjQqb88DcyzUCE/pqoGLZEB7hwEUB?=
 =?us-ascii?Q?5BfA2T7mlmd3ACjgvzLQMZnd+NqgYqV48glwY4J8/tJXFjIMWvJzm4GGGa4T?=
 =?us-ascii?Q?R4Kl0wqD0fqwjHxF1EB7FrROA9QP6tuN43gsQERDBGngEUYVXvyx2KolAw6f?=
 =?us-ascii?Q?LrQUbxVfq5aaFZKiykA+KBsy+plBK/1SI+t6wKfX9Ss3aC4f3H8JGSr55fIq?=
 =?us-ascii?Q?rgeJNmUHs/ADMRDDabtvjU0asv3ScusAineGND1xPNFTXaCZwKl7FmbfHBmO?=
 =?us-ascii?Q?+c4zOnJO8LufpBvlH8DWe9LovwAB81SFM0fq2tIcwxM8pMR9oR9sh/ujUpF7?=
 =?us-ascii?Q?dO37NCtJV0MEptMckMmdQDXSHN9QnHV+zidlHmGv18osLanc/p1qxYLnx48y?=
 =?us-ascii?Q?yhC9IGjlqXBKVLWknp9m2jO/QooXXSu++wFBcDPY/pUMQwxUtf3MtOxaEoip?=
 =?us-ascii?Q?gNA4SvplQ+Wq7kMLGs9qXn9LX9W+EUC9Mz/bzJzDp7mSpSUNjdRopTW8kp+v?=
 =?us-ascii?Q?uW2f9BFgltpoP2Er6dDqMcNxV6ZE9xHzy5H7cCQsrbpi1mzlY71ZHYpZhZ8q?=
 =?us-ascii?Q?qtH96fn6RkS6wsJfFLoCsfEMQLpRXsloiF3AvnNnE3xYRSMandWlAplz6iBp?=
 =?us-ascii?Q?uHCiwMRSuSG4unGm8tvN/YlE2dKnaRKDWHVsDOrgdFd5M1eqLF2GIg4FzYRW?=
 =?us-ascii?Q?UjhAOelKu5gLZcZpQrCVuxHC12tuPO762G6jy0tKhFCZPQ7/VUZyDfTHrJgf?=
 =?us-ascii?Q?fW7lhxJFnyoj34RTLbXZpFexlsgAaoA0dbKMbWcN4I5ZPiHn8MmMNKdc8PYY?=
 =?us-ascii?Q?H191Sev5KdfoVB1yItQHIdjocoqdtADfHwgu56a/RDivB+X4AY4wIxkM0ZPi?=
 =?us-ascii?Q?zEMjCJ353C3f0hsAc4Uu2Uf30sX+vk9X8m/s/qvnQ0ZmkXenLU0s67ukAFP1?=
 =?us-ascii?Q?+vAP9CXEUfHDjjtV5TQzF3mXS6XuhWjX6ajhthVyQ6zJTzxs96m5cCDOVw2q?=
 =?us-ascii?Q?fJR1+w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd944fcc-a5f2-49e7-7a5b-08db5ac72986
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 13:19:24.6704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xKwM1vNdocESU4Wbx7emfnMU3RgWgeOMdfs8sgR/IMFpztoqkGlVmsu0GgOnWfJl8vuNoiuKi2Zefa1l27UzvsKsku/T7TCPKkaBADgQs3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4684
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 11:47:08AM +0200, Christian Brauner wrote:
> On Sat, May 20, 2023 at 10:11:36PM +0800, kernel test robot wrote:
> > Hi Alexander,
> > 
> > kernel test robot noticed the following build errors:
> > 
> > [auto build test ERROR on net-next/main]
> > 
> > url:    https://github.com/intel-lab-lkp/linux/commits/Alexander-Mikhalitsyn/scm-add-SO_PASSPIDFD-and-SCM_PIDFD/20230517-193620
> > base:   net-next/main
> > patch link:    https://lore.kernel.org/r/20230517113351.308771-2-aleksandr.mikhalitsyn%40canonical.com
> > patch subject: [PATCH net-next v5 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
> > config: powerpc-randconfig-s043-20230517
> > compiler: powerpc-linux-gcc (GCC) 12.1.0
> > reproduce:
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # apt-get install sparse
> >         # sparse version: v0.6.4-39-gce1a6720-dirty
> >         # https://github.com/intel-lab-lkp/linux/commit/969a57c99c9d50bfebd0908f5157870b36c271c7
> >         git remote add linux-review https://github.com/intel-lab-lkp/linux
> >         git fetch --no-tags linux-review Alexander-Mikhalitsyn/scm-add-SO_PASSPIDFD-and-SCM_PIDFD/20230517-193620
> >         git checkout 969a57c99c9d50bfebd0908f5157870b36c271c7
> >         # save the config file
> >         mkdir build_dir && cp config build_dir/.config
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=powerpc olddefconfig
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=powerpc SHELL=/bin/bash
> > 
> > If you fix the issue, kindly add following tag where applicable
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202305202107.BQoPnLYP-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>, old ones prefixed by <<):
> > 
> > >> ERROR: modpost: "pidfd_prepare" [net/unix/unix.ko] undefined!
> 
> TLI, that AF_UNIX can be a kernel module...
> I'm really not excited in exposing pidfd_prepare() to non-core kernel
> code. Would it be possible to please simply refuse SO_PEERPIDFD and
> SCM_PIDFD if AF_UNIX is compiled as a module? I feel that this must be
> super rare because it risks breaking even simplistic userspace.

It occurs to me that it may be simpler to not allow AF_UNIX to be a module.
But perhaps that breaks something for someone...

