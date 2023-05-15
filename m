Return-Path: <netdev+bounces-2615-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F27DE702B73
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:27:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89AFC28124B
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77D6EC138;
	Mon, 15 May 2023 11:27:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6567A79D0
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:27:03 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2121.outbound.protection.outlook.com [40.107.237.121])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D3519BA;
	Mon, 15 May 2023 04:26:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cwyRnKj8e0hWSiNXSFIcntCVtcHwbgMN6QXQQqX5BSGRPcL+KD7Jlgq99Bj/gdxY4lXeOlh0GTvif1KBkwzU9jsmtRU+LSwzagSP2uDgXZAtcVZF9JGStN3lrlCdeRBkmYee9zF5DThiqRzPZ31J1p5RMIMfUfAKCxom3XRQH/pj0gF4WTxJ9YH4caZZnsQh4lldUiNPhJjpJG/ILk/9yEVGuATSFXvfkn/aWKkAz7Qyv20IlP65enp0CYlVBfGvndhS8cy76j+/BN1IDHwn3UPfzi5BBp2UFspydopf9IxvsqIhKDGC4Aay4FYq6LC1kYR46MkrdtX2RqAKLfOOjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IFTGTMjDkzPUOR7q3wlf2s0/wAUcWrnX9Vx3kWrZfjI=;
 b=ABUhCQPH/mKj2aHbIFOigRq/oiaJO5yrrsPLHNxeel510zjWivA+O+fnvtxshLgV39TYfyGRGgb7fkFnKmZsZHST9zKdMts4u13t5JkLbZKsegSd0m1DiJUYXuA+tcawWn5bDj+RxLn23gMSCnv09LDPx/e2pY0oe/fUB1yTEPH/PgKzNZ0ugCf9dGp/IClVXddLej8V7gSjsArR2VGZUa1ZT3zZvPSe/N/ot0/eqqSM+C010KWfe50FRLi7tLcqFIwFmRxPXbuPakNBgj4hFR8t5FuAz2iuFxB7qyj2nm4HBjbU+GdOMOs/jc0z+kFdbbktM2RRe0DD2P0I2TR2LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFTGTMjDkzPUOR7q3wlf2s0/wAUcWrnX9Vx3kWrZfjI=;
 b=TXw7/pyqxNjJgp2KIql2kdPVReoKwg8pnJqTGOXMvTWIArnjKBGYuSau2LiAb6f5/Ez8KJhfutyJINC2av9Yva8yIOPOjy6tFroj7z370H104BazErkLGo9c67IvNbEJh/eFtA5UgeQ6WJhIMGhqokCwGdzwo6ty2dITyI3yZb4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5760.namprd13.prod.outlook.com (2603:10b6:806:217::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 11:26:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 11:26:49 +0000
Date: Mon, 15 May 2023 13:26:40 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Kalle Valo <kvalo@kernel.org>
Cc: Daniel Golle <daniel@makrotopia.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Alexander Couzens <lynxis@fe80.eu>,
	Sujuan Chen <sujuan.chen@mediatek.com>,
	Bo Jiao <bo.jiao@mediatek.com>,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	MeiChia Chiu <MeiChia.Chiu@mediatek.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wang Yufen <wangyufen@huawei.com>, Lorenz Brun <lorenz@brun.one>
Subject: Re: [PATCH] wifi: mt76: mt7915: add support for MT7981
Message-ID: <ZGIW8CHEX7iBJqgr@corigine.com>
References: <ZF-SN-sElZB_g_bA@pidgin.makrotopia.org>
 <ZGD192iDcUqoUwo3@corigine.com>
 <ZGENDwGXkuhrCGFY@pidgin.makrotopia.org>
 <87ednhn97d.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ednhn97d.fsf@kernel.org>
X-ClientProxiedBy: AM0PR10CA0011.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5760:EE_
X-MS-Office365-Filtering-Correlation-Id: 36a12dbd-4d54-4ab8-7e53-08db55374664
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7uhL+t7Bdxz6P9AWCnnIGu4pv8bqnbMliMD/ot6OJKRxR8duNuxemMnsrwvS1OJ6RjIbirJnucig55EeSztOxd1p13lA/iWXvJRuiL8CicGisNPcx9BU160gmwIeLC2IugF5yreP7qCcz06h9JT6NYBPBNlzBqfpsxEtsXkcZC81rb+FTpNoI7/BRdIjVDsolSW3WYF91OhDF/VnYpG8xSymusWdO/1Rc7Hx6naBnZ6X5vLVlSuuYathP7YCR/yGGLzuxsY+wj0jT1AZA2luPgWPkJgpeAPe71yJicsEkvG3jmtaZq4Pz5tAmfpr3RSs1BC4sWxo08rINyH64btIzyA3AekjgBiozsYVTP5jOiUX0R89fDjixVHwuI9CJNvZeSQT6KJ8pYyE/9D3khiZ7dRtWiAVoG1ZwsQBt5tSZccIb5FUj7kHNUHH+y7RUlEJ1He/WT2vyi5V65T/LC5WHlF/hxbc3Rk9W3fW177sFyioB3suX+PuPrg+QSWlGHaxxf7KgB82dgnQ0ac325PpHLWeuRTCz3NsBrw2Ma1lRoMJDQJLhFc/CJ0h69u+n98/
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(39830400003)(376002)(366004)(451199021)(6506007)(6512007)(186003)(2616005)(8676002)(7416002)(8936002)(2906002)(83380400001)(38100700002)(66556008)(66946007)(66476007)(6486002)(4326008)(6666004)(316002)(6916009)(54906003)(478600001)(41300700001)(5660300002)(36756003)(44832011)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2VGwiLw25i1K/ov73vQk5px5gG3g9AWRAd4B9FGO2vuJ3Gvzj4Hps8gmsS02?=
 =?us-ascii?Q?lePvbAvNWDiBmaDV+MPEQe4mWqi1zrK4SxRi3FPz7DZw/3lF525ng3b7mmgv?=
 =?us-ascii?Q?Y0R7VEJjNfbXa51RCp7WhjRdBdsEA8euFM24vOrqbnx68XlsmUNAXPG9iO98?=
 =?us-ascii?Q?9qP/aFkhiJ7T1AwXZxZeQS8HPCIxUux4c1XFK6vGfOlXy9e3Ig3hKjAkgje7?=
 =?us-ascii?Q?yKk/6BzuliovrsiVtfv4OMmjROag50Jj2xx1HFQB1xATWRZP/+EutktSQ3Fs?=
 =?us-ascii?Q?wqVXc+vcNbiUFjdLv3oT/fEukIn+LBIvB7Ng+9HL7n9fXQi/W3x/VkVXqRbW?=
 =?us-ascii?Q?6Z2om3JT969Irjv6khZfbiHV94zrh8DGK9SQrtduh5tkQlmnsG9DZu/ioCk+?=
 =?us-ascii?Q?oFdO2LNRIgiT43QVbgPOejoaNNo15/UDVRkjtkIFqr3s/kOGxXYce4nAAhlk?=
 =?us-ascii?Q?hpxgboAcEQPU4Brn+wMiK4eli/EHaQsucz9K5CMMpZl5IHCxo8bhDeRwy67G?=
 =?us-ascii?Q?Y/U5oPktaOxXj23+gOjokbTs+wFzbarXNi+AEBWFOcDn4s3Pugm61Cxh9O3Q?=
 =?us-ascii?Q?5jIReXABlLYajaW0Z977GDkZUZI9z1Enw4KFyrH/D6alcwz6cayUvUBZQT0Y?=
 =?us-ascii?Q?znaeDMEa0yrKYuc5WPNXmPocMVpzwMPIJrxNylyIwjHN60vG/MKbRjHD6+GO?=
 =?us-ascii?Q?QuSrLBWOR8MS1Pe91v7Z8evmvl+Gj2alOBaCzWKfpB8aFhd02wmzL65s9aZP?=
 =?us-ascii?Q?lI7iGZSTdo0Vy9Xi/XhKC4esDVWZIM4uG9oyL+SClz3gJ+TjGYkC+ioCRgHf?=
 =?us-ascii?Q?LfVfxBVIMM95TaENMBubLPyEMSQDrGZfGryctl0IOjO1uarbXg3usNqu5vj6?=
 =?us-ascii?Q?SVVhHZEyMgg3Az+iQDLDDl+wCnv6FIFzlovqy4FWdrpVX/T7JgNnkIjc1NVN?=
 =?us-ascii?Q?Mf6Y4Uzdk1A+8PEm3DbBq70rauC1IM/Gn6VJRJ8hiQk6ttKxASSHCTOZY6IV?=
 =?us-ascii?Q?VXaHExJScJNSrX4lfsS31UenZXrB4priMb4Mn66z0gPGX5ykg28WUsGKZ5J8?=
 =?us-ascii?Q?vK389JlyCv6InJCTjh/sp71SLp37WFxuMiFMAj8YP38/PKd9fQQklaOplaCf?=
 =?us-ascii?Q?lcCt+0H1L+0J1bIWxHgOFeLyE2RmbOo34bZJ51U+/jj5eokebBWA7Z7+MH1d?=
 =?us-ascii?Q?mN5GSCxze5GyShwd+tJ9jNQ59btRwRVcXI1OBODzPfrMVvsqLhNV0PXW+Cal?=
 =?us-ascii?Q?a0q8JcsDyvDC1ghaaoOJMF3Gb4+Vf1roFxc98qg14BMt6oQsrVamKmXibgUp?=
 =?us-ascii?Q?iGIZCsne5gX7urhHLJK72j7+DeViQJ9b+hixaaAkedfyM2gEiHlN3yabLn/H?=
 =?us-ascii?Q?encQhX0vd03gEkS9naPRNDbMwffiuBxhcjUz4/PKquAUhG1D9+bA5twRpHoA?=
 =?us-ascii?Q?N0+HOR0V/cIizYYpdf1m9p3ZW/XPf8jeI8EQMnY66BT3GL5fwAq1CW1y82Vy?=
 =?us-ascii?Q?Iu1PyUSBuarU5HXNdULX28oclyoL7wx5qh3Z9olQhZIJWqb5A3MSeIgb52DS?=
 =?us-ascii?Q?x/nBeyTAn92A85Wu3Oda6EpbQk3JezTLRLvtY26w55/8H0iXTRdLp6JNMWJl?=
 =?us-ascii?Q?6iwwFkZQCvcym3LJwRyd9/lcBLFOgGhyV0NVMtlSCaZQBd5vjmCs+BmMalxL?=
 =?us-ascii?Q?EI65hQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36a12dbd-4d54-4ab8-7e53-08db55374664
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 11:26:49.7604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2/zfjoR3Zx8+cMkccgPCS1elSxK4qMleYfknvrHRrBNcC3LfLnqEsAUSAxYaO0vn8N5wqGVaC0JFri4SodGBnvYL0gN9uBg2XRtpaQhJ6GE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5760
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 02:08:22PM +0300, Kalle Valo wrote:
> Daniel Golle <daniel@makrotopia.org> writes:
> 
> > On Sun, May 14, 2023 at 04:53:43PM +0200, Simon Horman wrote:
> >> On Sat, May 13, 2023 at 03:35:51PM +0200, Daniel Golle wrote:
> >> > From: Alexander Couzens <lynxis@fe80.eu>
> >> > 
> >> > Add support for the MediaTek MT7981 SoC which is similar to the MT7986
> >> > but with a newer IP cores and only 2x ARM Cortex-A53 instead of 4x.
> >> > Unlike MT7986 the MT7981 can only connect a single wireless frontend,
> >> > usually MT7976 is used for DBDC.
> >> > 
> >> > Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
> >> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> >> 
> >> ...
> >> 
> >> > @@ -489,7 +516,10 @@ static int mt7986_wmac_adie_patch_7976(struct mt7915_dev *dev, u8 adie)
> >> >  		rg_xo_01 = 0x1d59080f;
> >> >  		rg_xo_03 = 0x34c00fe0;
> >> >  	} else {
> >> > -		rg_xo_01 = 0x1959f80f;
> >> > +		if (is_mt7981(&dev->mt76))
> >> > +			rg_xo_01 = 0x1959c80f;
> >> > +		else if (is_mt7986(&dev->mt76))
> >> > +			rg_xo_01 = 0x1959f80f;
> >> 
> >> Hi Daniel,
> >> 
> >> 		rg_xo_01 will be used uninitialised below if we get here
> >> 		and neither of the conditions above are true.
> >> 
> >> 		Can this occur?
> >
> > No, it cannot occur. Either of is_mt7981() or is_mt7986() will return
> > true, as the driver is bound via one of the two compatibles
> > 'mediatek,mt7986-wmac' or newly added 'mediatek,mt7981-wmac'.
> > Based on that the match_data is either 0x7986 or 0x7981, which is then
> > used as chip_id, which is used by the is_mt7981() and is_mt7986()
> > functions.
> 
> But what if later more changes are made, for example a third compatible
> is added? It would be good to add a warning or something else to protect
> that.
> 
> And I would not be a surpised if a compiler or static analyser would
> even warn about the uninitialised variable.

FWIIW, gcc-12 [-Wmaybe-uninitialized], clang-16 [-Wsometimes-uninitialized]
and smatch warn about this.

