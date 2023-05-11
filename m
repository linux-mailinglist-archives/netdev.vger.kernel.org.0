Return-Path: <netdev+bounces-1768-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE6C36FF179
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:26:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F03F1C20EA6
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5209519E52;
	Thu, 11 May 2023 12:26:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A24B8F69
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:26:51 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2127.outbound.protection.outlook.com [40.107.220.127])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B49D10F4;
	Thu, 11 May 2023 05:26:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DheP46+xvz/XDzLF7MOVHTfGL8EvUeu5b8sLRrGrTC44TfaY8Ncg26RNE0FM8BVktnQGyJxe6f1YoPcAvqbozXm0ftZRJIRSA59uYOI1A0Wwcd15ONUIZW4KKIt3ZntkIPuU6jsKexa3fUOOXz5wRCJmgp5hZDsNQqnJ9tw5K4jJ/YJKNekJMyUKCV/vhDgoCjZCsvj2igk/hfiql4est0Ra8FaXiEVTxpm7SU0kWGT5XI9sv4LfW0bHGwgIxAkxl+JI4wMTlS0JIi28DDi5Y8JxTSkh8acoRNG/hN9kkUoWlnjF3kReH/OVv/EOrReF2VJX/mmkON7CJxPlWGG6Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fHP6NUwbsKiiB7G8w5qFLMRykgIbwR24WwCu8k62rJk=;
 b=K3zcqXvTw3p5+Ot2MIxJ6KSJxr1HN25axTRjktVN0HBQ1TpEgodV9G37wtNCnBp2VP9WGp3GzJ0xg6F7nf+q4eEXHLdfnPHPr5z9S+SZ0y7zV4f1D+BmACum5DK8HvE8Vl6yigQQ7dgxZzpiO1SchWkVz2Ro2PiIy5bRJBY0FXqZVGaOqceOt82LE7CHlB3LdLiRBl9LBpzzEgZCyxiTXrAt7bbtWF4dPYYzNgKmovRM09qsVs/eDSHBq2Tv0Bs97mTnmI4ZSf1dA5kEFPm0j0japayHe1IFJO7PynP+OM49X0BNOO62VO5msRyrH+6frboobUGVDEixQhcjFEgoJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHP6NUwbsKiiB7G8w5qFLMRykgIbwR24WwCu8k62rJk=;
 b=aN4vcssX6KcgoMd8Cchr74D1nVwdde/POVZbkwWESrT73c98hhEWlQIEn0H4pApIfJ8JlllZFrQng6JB2PXFihHVeofr4ZV7jdYAcdkf7K0mJC4uqWYLMvAMiycZm1EUKe17gRk66UkphawynvhEEnVxUE6SlfkQ2IiBEIBS7lM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5496.namprd13.prod.outlook.com (2603:10b6:510:12b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 12:26:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 12:26:47 +0000
Date: Thu, 11 May 2023 14:26:40 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yun Lu <luyun_611@163.com>, Jes.Sorensen@gmail.com, kvalo@kernel.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v2] wifi: rtl8xxxu: fix authentication timeout due to
 incorrect RCR value
Message-ID: <ZFzfAH+a4ivS3gXo@corigine.com>
References: <20230511031825.2125279-1-luyun_611@163.com>
 <d8b5f499-6778-34c0-1f12-9d0f6698abb7@lwfinger.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8b5f499-6778-34c0-1f12-9d0f6698abb7@lwfinger.net>
X-ClientProxiedBy: AS4P195CA0013.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5496:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c9b3868-805f-4625-230f-08db521afd48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	l35u3+d0lJfFzoPL4PsOoeVllnebZNWolf7fMfSyk/ORlgBzyLi2cDlO9GpArSfPXJN59x4IUvmxkiW21e8cQ2qnyrGqcbyCPuQhEc6+8Cib7rA6HPwhh7as05sZX8fV4Qsqd9yg9Lw+3QaA8X1hOQ+RpZea7UddpwAg+4H/f9Uy7g77AdQof69gfh+ygGpfHV/ofsEq7gSteoFtdK6ndw5Ywra0ThLL35uhReL4uaQHm7j97UXfMWbrRSOlDKf0hO8iJdf4DumyjI2lGpDMjZHSFRBoUC8k3ZVxpjFBpBpTr3IqfLrkfc4PyvzubaRFqazx0MrRGkFECJNRp/o6B3MthDZaFySMIQx7huWLpz8nbZdA6zhdmI4pZaooJDYXyWiiougDwDGYa8VejchgUlhg9OPVkIxr+BZTcmkebr+yhYpghsexr5jT/5HR0+6ztu1SNzL9jouvdne6JAk9gczF2NmDM0qTFxKBOdwx6wqcnK1iXcHi8ph1gSplWLZhhnf/T5CCwOGDZLvtc70N0f8/n066WGUcRj2cPMslyBj6XwpojI6/e4OyAPSdigA2Ltd0jH1fOIW/A18ECQ0o9+eZjrbOf4ehyXY/oNnRYNEKcKQDw2emKH0DMGCB2jXEgsIUzwMxH3Yx4V6mNoeocg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(366004)(39840400004)(136003)(451199021)(41300700001)(38100700002)(478600001)(6666004)(6486002)(44832011)(36756003)(86362001)(186003)(53546011)(6506007)(6512007)(66946007)(4326008)(66556008)(66476007)(6916009)(316002)(8936002)(2616005)(83380400001)(8676002)(2906002)(4744005)(7416002)(5660300002)(32563001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fFP4lmM42NZZVXx1hs6BEs/QhZJoScAAcZb/rlKHJNO0ASVA/38A1U7sXAEa?=
 =?us-ascii?Q?3Xfq5rhgTKz3diF9v7s/o7BO3o7ezWjXsThbCn6Yyg8oQqMxxn1Syd9YuisM?=
 =?us-ascii?Q?X/iF7tfXf23MgqJcagLN8nZ3IIzK+oa0qICR+yZR6OJkqaGjVdvZwxXhxG/P?=
 =?us-ascii?Q?MW39rwU1ez4JEa/AaqtMcHnhq1m9RuEgCkVKsF9YRRLK1rWsdiu+Ky9OB2uC?=
 =?us-ascii?Q?sqAuBx6QVsTtH7oDBOVUHNG4XZl75UoGhPWbEasx0ZR4PINn/N5uuf5c+hEh?=
 =?us-ascii?Q?JnaDo3eRN8sbcvzGwsOcHMMvd4sMDhvhO3KVMK5VQZyYMi1exOxGjn3+4cGx?=
 =?us-ascii?Q?aOEHdPX0/hVINQCQ0AcgltJ4C1dWLwPaL9rpKddP7VRd4NAbuVpcsuTuruBr?=
 =?us-ascii?Q?0ylHrqkRv91NMPwPddBOiKIb4ob/tK8d6fQB5B4qIyye3jBy1V2SncVcSFdN?=
 =?us-ascii?Q?j9IEnyZGKe8qFlhqaK93KdUcaDNXMvgTIt5SVYcto66GbENLz1TIJyq5OtzU?=
 =?us-ascii?Q?FkLpK30QIXPm/4D0O3WTjsf6kAqVqRlBVM43lUcJc1ho96xcvQAi+mR50Nbv?=
 =?us-ascii?Q?mjWMd/bcGWXHtNGm15pSdplJTTkZpRB+BeyPUoNCAjBIHvv+BiH4AhNdQFET?=
 =?us-ascii?Q?qPJypl+vm4V0jXMtXWMp/E+IuMgYe0IptT88EfJ0/uTJSgi3dqBqwwoSGgPw?=
 =?us-ascii?Q?sUW31XhKVHnztA0k7UyeAMZ7IzeZ9/qZvwK+yxAb/OxDat7olAZ3pnIW7bJg?=
 =?us-ascii?Q?8LQmgvVkuCkz9Jcz779p0mtuT/GRLdM21qg/flczYKaHUGtly71u/tMo/aw+?=
 =?us-ascii?Q?eYIIGHQ+x1i+JYUK9nUIUuK4gEcdort7cHnAvHvBWJb6uKfLAFnV4bKCbv6Y?=
 =?us-ascii?Q?cSwJ07Jyzs8OoC6vcaKvFHGxY0Ns9pvvn3lsRq9mv01Zqq5L3MkAv9JVpXg8?=
 =?us-ascii?Q?yuAhXsg/t1f8t0TVGnTPONYvfGWQL9Gynyq8oE5Oj2EjhFC28d7BH37inD80?=
 =?us-ascii?Q?R/Ixy1hv3HsaYKQdG/FBeqLnq5YfF/TMtkgAb9QU34uWS4nZbDSvdoUzmCn1?=
 =?us-ascii?Q?GRLwaMpwd0G6SvdCho4PXYCURsVuxf7HSyJX9ThmEc42CD1KV7pSFLk9b5eY?=
 =?us-ascii?Q?W1LjntTW7g/IqkwRhBqwKFYZstWoJ4jKmfo6NB5YGMHIGJbsuV0J08C/4oL5?=
 =?us-ascii?Q?hNzIhwDNz4aTUNZNmntCjii0rcc4HmIP+ix8XRbqvbmKArcl0PTHOulduReE?=
 =?us-ascii?Q?3BnOB699SThQ+BKOb32CmjbfPGG8Rvx934xcbsW7vY4VRA2mPsWp4x5X3qZe?=
 =?us-ascii?Q?9fv1NtkT5MxUrAKNjAiFqIRHMXZeveHagRI1e80io9Fczugp/RSWT0AmtldV?=
 =?us-ascii?Q?XajKRqDE6Oz9jifL3Ej4hZqHWI8mEKJCtGnK4jRV4KKkCikgotTUyo9vUgEa?=
 =?us-ascii?Q?3KJzTxuLuX8vu8eE6mHLPGOn6dl6jkYawGVnlIy/Tfbt1D3M9My54Rr8UmBz?=
 =?us-ascii?Q?ijjkglC5sqn3l9Os/ef/sIjLRMnfBkVFvF8CSAHhuWjUumH6eAAcwi/yFGpw?=
 =?us-ascii?Q?7GftLRgCREk8kGTPxOpMJgKxiRbOFGLrNfa87Nei9KwFJ47N/TXE2vqn7S4m?=
 =?us-ascii?Q?WvhTaPiEhqJZGFVU+mxUAG8uWDL5MbOTNDv/LewlQx1LyGaNaYjcWBymBRFT?=
 =?us-ascii?Q?NFzB4Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c9b3868-805f-4625-230f-08db521afd48
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 12:26:47.6472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1e4LCsPkJV6m7G1OwP6cyXSBcf8gOM1xfkmBUQnH67PjQvulGyELKadRXcg+n4NAU/M5z6CJP6qmQ/luDkK362LVCcvg25dXA9yzlNfj6Kw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5496
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 11:34:19PM -0500, Larry Finger wrote:
> On 5/10/23 22:18, Yun Lu wrote:
> > From: Yun Lu <luyun@kylinos.cn>
> > 
> > When using rtl8192cu with rtl8xxxu driver to connect wifi, there is a
> > probability of failure, which shows "authentication with ... timed out".
> > Through debugging, it was found that the RCR register has been inexplicably
> > modified to an incorrect value, resulting in the nic not being able to
> > receive authenticated frames.
> > 
> > To fix this problem, add regrcr in rtl8xxxu_priv struct, and store
> > the RCR value every time the register is writen, and use it the next

nit: s/writen/written/

> > time the register need to be modified.
> > 
> > Signed-off-by: Yun Lu <luyun@kylinos.cn>

...

