Return-Path: <netdev+bounces-4595-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BD3670D7B7
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:39:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A07142812CA
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D7891B913;
	Tue, 23 May 2023 08:39:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896F44C89
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:39:38 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2137.outbound.protection.outlook.com [40.107.212.137])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EE0118;
	Tue, 23 May 2023 01:39:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKsxg11n06rJXi9tc9aH6ohEk2Uwzi08/ECZcBG1WGZs9G5q8DtK4/ITG/hxA4VorJ3KDMAn9AR0FhTt0Hwzg83CzfR9tjjo/Tpc7hxosT0XYwyZDHeoAAWXeciKfjmktkq8AwfhLy1GQRrGT3yECWRf1Ilr/H1CfEgc7tnKq3uTKwtreWGDTOES92FSehPmVtahmuP3kh12yezppIgEgdbK2Crax02UD79B8kuZrbual7PQmcRt2ngzznsyGBwPLyKz0f6lBl72UQO3z9DH9r54zCUAKdSQjKfLHEDMwKjbi6AqPSjcQ9qC1BpgRP8DuL6dAOstc2frYQiK6hyS6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5cbNjz4VQ9tz0bvHxjvT4Mq7CzATc+vNEqZAtIUn52c=;
 b=nCrUK+bqO6j/zbBp/vxr69i7P4p8LyYPVWFPhvYc/r9nQS6UHb9puLTYkBpD4WxDwZDRpyEVigfwzdKBZJmd0ovxcqyjVM1KhP9nqKoySXRVo2sfbxA3Q2XhSwk7R9FEl7Dybw1sx+4Jn/rPsGHhZBgQ9Jn1vVrYxE2ZXhu7mBEKpBE5dhOjFpPAV32btxFFr6vFOMFed+TtuHTGSB2PAHu2Rtnoabes27UxEg8u+BNPgxbQAZi2GoSbvT6LFFpgsHijC6KrHxgnyMwJEiwdl0Le38gn6pBTQcu93+MEVEW2D4J+H33LGVfnSKsJCWbMKwmpnh1DCjiFJ7rh8aTupw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5cbNjz4VQ9tz0bvHxjvT4Mq7CzATc+vNEqZAtIUn52c=;
 b=VeooVDrRk78j2f9fP5aTLL5urEfYBsk0ogzMhFRQwkl3L8paywJREJ08f9zaVg3NpitBPkZTrdHdIfXJrEHJw5CIDD0WThQs45YYjr8ndW611l0wxycc+txDC3smQS9XafxOJOnwBmAXyJIlYtFiDE7bnV77Z2JMmSDQQUbQSVc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by CH2PR13MB3639.namprd13.prod.outlook.com (2603:10b6:610:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 08:39:28 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7%7]) with mapi id 15.20.6411.029; Tue, 23 May 2023
 08:39:28 +0000
Date: Tue, 23 May 2023 10:39:21 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Rain River <rain.1986.08.12@gmail.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Ayaz Abdulla <aabdulla@nvidia.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] forcedeth: Fix an error handling path in nv_probe()
Message-ID: <ZGx7ufMyUexRAruQ@corigine.com>
References: <355e9a7d351b32ad897251b6f81b5886fcdc6766.1684571393.git.christophe.jaillet@wanadoo.fr>
 <ZGtAIJZ3QzkBJgHI@corigine.com>
 <f4296d23-83ce-4147-894a-3e5640cdf87c@kili.mountain>
 <ZGtNwCc8ogSlwtYV@corigine.com>
 <8dbb4087-db01-fbbf-4e96-a5b0e170249a@wanadoo.fr>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8dbb4087-db01-fbbf-4e96-a5b0e170249a@wanadoo.fr>
X-ClientProxiedBy: AS4P191CA0015.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::12) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|CH2PR13MB3639:EE_
X-MS-Office365-Filtering-Correlation-Id: b2333016-40a3-4f4f-f83e-08db5b693828
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YJHWxh4kbOdA2HFBhyCIWEYemEF+BdOrUp/JZMrfu1abw6xSQj2MIElzUV93V7550KfVw8fCbNh/B82GdnldU3nQXBIySZUc4LQq77zco1AK8uBgogJszTh/tJEVGjM1g77TPovDbszZteSh6WBV2HQEpj54qNuBq3xyeITtBI8vKXcbfjXHvtTzSLdMveDU5q2O5cc+KMaAypaCiOJRTyzRF26k3NYgefu+kWNL4rsTv/KuwdXdZHC2XLdq3P4RXLVfh5XJmG0Xht3IdGMk220pq+qKgDi69iIPvtRZTkLicF7inj719UpS50T1Al9edvGzngED1LsHaEnc35jJJltoojAI5MQ1oWPQ44nQP28/DoTIMTYuOWpjakC97JQo9CslKzPS0f29UC5rva2BUMOA70FKoglMUbAtBwELkHxBPKo6ITelgeU/+3ftYXmbwgjambr7ViA9k26cw3T1sbFHBCIfHbguSmtcPYhj2BdsMZP60LJoo12jsZZ382zJGj64huFy84WryEZkcp4mG2sgwpldz9xM6Ef4YkpetTmMbMr7FCUzn0dCK53BOk9L
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(366004)(396003)(376002)(346002)(451199021)(316002)(54906003)(4326008)(66476007)(66556008)(6916009)(66946007)(41300700001)(6486002)(6666004)(478600001)(38100700002)(86362001)(5660300002)(8936002)(8676002)(44832011)(186003)(7416002)(6506007)(6512007)(36756003)(83380400001)(2906002)(2616005)(66574015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VDZWQ05MeXp5cHV6d2tKdGE2MGtNV25FeVEvQTJIYy83Ym9ZMSs0RHd5K2o0?=
 =?utf-8?B?c2JINURVN0ZWZVE4clFINUdvRC91b21SYzUvS09EeFhjWGdGKys1M0R0aTBq?=
 =?utf-8?B?NS9MemZxYWZmS25QR2dYdkdKdm83MFZqTldaOWhoNFdkb0pCTGdsQlp6dHh6?=
 =?utf-8?B?UmVCTmk4czByRXFmeG5LRGFMaGNRM3lKdkxGR0VhNUk5SE9JYStldjBWbVda?=
 =?utf-8?B?aTdidXR0enZPckpmRkd6OFNRVzcxaE5yRnJHRHZBTEZGR3ptNDAwUDA2N01R?=
 =?utf-8?B?ajZXRDZ3dGJWenc5aGJMQzdnOWt6Ync2NGNPckRDZWk2cG9tTTcwcmxpRFdr?=
 =?utf-8?B?K0xEYkFjdGdaU0dUbU1Ya2RVN0xtcHNNMkRRNWNyUzlUZks2Mlo4ak9UdXpV?=
 =?utf-8?B?UnJlZXNZQ04xVkVUdFNFb2gxeWpVejArbHM3WnRQS0p1ZUZpU0hhdHJtTDZI?=
 =?utf-8?B?RkYwMlZVN3RpNVRNTjBMWWpxdTErTHVYbFYyMjgwWVllRzRjWjcyVjFNblJt?=
 =?utf-8?B?TTZPTVIxWFdibFkrNjRCakhRamd6STZJZUVFeVFIMHVYdlJGemdOcEtyeElR?=
 =?utf-8?B?UFhlQnRNRTl1ditlcENvYmZ5SDUydzhPWERNbUlINTM4SHdxblBlZHlVcjJo?=
 =?utf-8?B?WkF5WkJObjJPemhyRWU0UTNGQXFEcFBxcS9pSWhCKzZUbElhZVJhSjZ3Y0s5?=
 =?utf-8?B?YWh2WEtOSDZYS2pteVc1V0EvdDVta0lTbm03N0NwR0l4N0RGK1I3ZUtzMHp1?=
 =?utf-8?B?emVWWlZ5ZTA5WXZPZ043SURhK3RsM1FqVUdMeFBYR2tYeVJrVVlBeUhPOWQw?=
 =?utf-8?B?VHB0Y2tpaXpMcXV0Zk1MbU1aVE5zZ1RsUFNPanRSNUw4NmNYaUp2MnBvTlc1?=
 =?utf-8?B?REhON1VGbGlueUowekJJQ2lrUngwSENtb1RXVDlhY2w0K1dQUUdNdjhvZDhk?=
 =?utf-8?B?TExQeHliUVlVRWR5MXQ0ZWQ3L0VFdDhJTWh0Und3NmRmc25rQW1Nck9UaWFN?=
 =?utf-8?B?MXY2YkxieFB0U0xjSmgzU25zaGxLeDBiNlF5U3FBem81ODFvdXExVENKRW5o?=
 =?utf-8?B?SWhmQmtZcWo0R01oOG9CTnNnaWI2T2djTDRXOVFUQzlmS1F6U3F5MDdDUVRt?=
 =?utf-8?B?dzNLdld3YmMzNXlhdTViTXhneEZuVFBqNGMzVjlTWE1yQUhaVmlVM3FKUWxt?=
 =?utf-8?B?OFB0dG04SkxBK0ZJTUpZQldpRkxIWjdzcTFZWEtZVVRBNUZwZnZRcVRRK3JP?=
 =?utf-8?B?QjlWanJ2M3VNb1RZd3NCWG5JaW9vUUFYN3ZrWGxvdUtiRTdSeHNYR0NjY05u?=
 =?utf-8?B?SFpCQjdhOFlGUmQxdUFILzZwMUQ5WHhaV3hRd2t4ZnpYTEY2MTNKcUw0bHZw?=
 =?utf-8?B?M1UwSjBhaU5hOE1rTzBUUDhXRWphbktNTThzRnlWVFcyWU5DYTVYODBwWjJB?=
 =?utf-8?B?VzhzeVZ3ZGdBT0V4cTNBbW5IQjVkMHV1VjdMUFlwUzBiT004MU5mZnhGdG5B?=
 =?utf-8?B?UXlweHI3WjY2ZC9naU9uYlBmRTBHKzhwbEFvS28vaGQyNm9kU1RiZXVldGwv?=
 =?utf-8?B?VDN4WCt6MCs3ZFBja2NXSGJpdDB6d1lyVVNRUXorTjk0US9Ec1gvajNGZjlV?=
 =?utf-8?B?cXR1cVdHVm83elZ5cVZuTDh2RmtTYjFqSTBxVzN2enU3ajNpYU1JOVE2Q3V3?=
 =?utf-8?B?UURIYmpOS3FTR3ZQcnM2enpJM2lIWlRnYXdKWnhqU3A2U3BlSndQTG9NU0VG?=
 =?utf-8?B?RDJpYlZnTlZNU0htZUkySG1NRDI1b3Ywd2FmR0JTd3QxMm9taGE0RWlYYUdw?=
 =?utf-8?B?QW5DbVZjWml4VHJNVWlCd0hTT1ZUYzhVYUVyWkRvODlUbTk1UllSSFJQVkl2?=
 =?utf-8?B?a3JReWM2V2YyVEpqZ1FrVHV5a0Nhd1RkdkFtazN0Wk9qTWdlT2x4ZXdmN0pv?=
 =?utf-8?B?amJmYithemJicWNiMTkzRnBNWHhORmlJT0NGTExBQ1N5czRVdGF5cDRFeEtQ?=
 =?utf-8?B?cXE5L1pSOGFjMmtPaDRTcUhhdTVrMGEySFFjd2pJcUFCdDA0c1BOcFpROXhT?=
 =?utf-8?B?cGFqUGxGZWZRMGIydzdzc1U2eE5RZkV2OWhMekt5M2tMTmtKeHh5YTBVa0Rl?=
 =?utf-8?B?T1VGRWppdUlOUkpNaWthV2hIYmJmZzhsbnhCZzA4RnNoU0ZsZzVNZ0U3ZkRi?=
 =?utf-8?B?dkRZRUs5TWxvYmtUNktOQjFpdS9hSXlWNGxjSFBETTNrRFkya2VZaHRrOFJr?=
 =?utf-8?B?T2tzK2lucTdmOGt3bVVUVkNKTE1BPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2333016-40a3-4f4f-f83e-08db5b693828
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 08:39:28.1022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zFh+o0vcxrHOaelsJJe9eGtBYyGTeMbVYOlAjL9NWvC9fL89WA+uBiu5da91ViTWBZFsDHPJbCQT2tbmWFfhKTq89xsmZoaGGEHS+UlEl/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3639
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 07:13:43PM +0200, Christophe JAILLET wrote:
> Le 22/05/2023 à 13:10, Simon Horman a écrit :
> > On Mon, May 22, 2023 at 01:35:38PM +0300, Dan Carpenter wrote:
> > > On Mon, May 22, 2023 at 12:12:48PM +0200, Simon Horman wrote:
> > > > On Sat, May 20, 2023 at 10:30:17AM +0200, Christophe JAILLET wrote:
> > > > > If an error occures after calling nv_mgmt_acquire_sema(), it should be
> > > > > undone with a corresponding nv_mgmt_release_sema() call.
> > > > 
> > > > nit: s/occures/occurs/
> > > > 
> > > > > 
> > > > > Add it in the error handling path of the probe as already done in the
> > > > > remove function.
> > > > 
> > > > I was going to ask what happens if nv_mgmt_acquire_sema() fails.
> > > > Then I realised that it always returns 0.
> > > > 
> > > > Perhaps it would be worth changing it's return type to void at some point.
> > > > 
> > > 
> > > What? No?  It returns true on success and false on failure.
> > > 
> > > drivers/net/ethernet/nvidia/forcedeth.c
> > >    5377  static int nv_mgmt_acquire_sema(struct net_device *dev)
> > >    5378  {
> > >    5379          struct fe_priv *np = netdev_priv(dev);
> > >    5380          u8 __iomem *base = get_hwbase(dev);
> > >    5381          int i;
> > >    5382          u32 tx_ctrl, mgmt_sema;
> > >    5383
> > >    5384          for (i = 0; i < 10; i++) {
> > >    5385                  mgmt_sema = readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_MGMT_SEMA_MASK;
> > >    5386                  if (mgmt_sema == NVREG_XMITCTL_MGMT_SEMA_FREE)
> > >    5387                          break;
> > >    5388                  msleep(500);
> > >    5389          }
> > >    5390
> > >    5391          if (mgmt_sema != NVREG_XMITCTL_MGMT_SEMA_FREE)
> > >    5392                  return 0;
> > >    5393
> > >    5394          for (i = 0; i < 2; i++) {
> > >    5395                  tx_ctrl = readl(base + NvRegTransmitterControl);
> > >    5396                  tx_ctrl |= NVREG_XMITCTL_HOST_SEMA_ACQ;
> > >    5397                  writel(tx_ctrl, base + NvRegTransmitterControl);
> > >    5398
> > >    5399                  /* verify that semaphore was acquired */
> > >    5400                  tx_ctrl = readl(base + NvRegTransmitterControl);
> > >    5401                  if (((tx_ctrl & NVREG_XMITCTL_HOST_SEMA_MASK) == NVREG_XMITCTL_HOST_SEMA_ACQ) &&
> > >    5402                      ((tx_ctrl & NVREG_XMITCTL_MGMT_SEMA_MASK) == NVREG_XMITCTL_MGMT_SEMA_FREE)) {
> > >    5403                          np->mgmt_sema = 1;
> > >    5404                          return 1;
> > >                                  ^^^^^^^^^
> > > Success path.
> > > 
> > >    5405                  } else
> > >    5406                          udelay(50);
> > >    5407          }
> > >    5408
> > >    5409          return 0;
> > >    5410  }
> > 
> > Thanks Dan,
> > 
> > my eyes deceived me.
> > 
> > In that case, my question is: what if nv_mgmt_acquire_sema() fails?
> > But I think the answer is that nv_mgmt_release_sema() will do
> > nothing because mgmt_sema is not set.
> 
> At least, it is my understanding.
> 
> Can you fix the typo s/occures/occurs/ when applying the patch, or do you
> really need a v2 only for that?

It's beyond my powers to fix things in that way.
But I'd say there is no need to respin just for a spelling error.

FWIIW,

Reviewed-by: Simon Horman <simon.horman@corigine.com>


