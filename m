Return-Path: <netdev+bounces-2428-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21FA3701DE8
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 16:54:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0365281089
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 14:53:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3DC46FAC;
	Sun, 14 May 2023 14:53:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1CF1C33
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 14:53:56 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2123.outbound.protection.outlook.com [40.107.92.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CB110C;
	Sun, 14 May 2023 07:53:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dN926IkbrOK8N0Kvyf/7X3iZCNnKXBB+Zyz9LW4WvQIpxEpRCmjdltEpqz94ddwqqhtE5X8ksrS0gT2yNeQ59RNNpOKInRrCS/kuo+Uj6Onsa9L+1VSLvS589ss4T7d63tn0Pon8h09KKlmkU9wG/1eskmP1TLQ/nHN2pd8hppOdKwcOvG97whYBPspOGBTxPnjKbGa06iinjCX4j5ivpYHPzYXnMp8ngGpHIU2T2RwQfxjuiQdoRDDZM8x3yo5cWnynN6Cm1vNDyssD13D1b93JdLin5G5btDFNIMFjRQuxCczPzRuBitCnasJtGEGpdgDGc/ycNV7DlkbUkFzAnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qMREUABHnaPWngenBShsQc3oR+mUksp7gIghNXBzQwo=;
 b=dWBeS+r6MAv3LpOsjmbf0H7qbWnyCulRKn+PLVBBefdUpHRlgBnyavZkUeDTJQBZ2DMcovTwL3PFFeCXA7aC2PW/fZprD1kam8UABlX6rj5qKzMyPDemjIbrPOtGQyF1ql8AyqlwvP92bVv6XgRYcDbMOJ8EN08Ue8a8YEjTLEcBLrlyeyE9ZGu7pBF5JJlFAC3XFR2gXHi3ntJ22Mql99xOvm3evakke1lItSQpnvQs4y4+TTo59hsqQH2AOdp9n0enYE7x2PAeagpGdKwnBViYDdlGnU58q2bp1u/qo4B/N78+gxKo5CD6gA+9fpK3TDH8jr7UgzP1sNBscdZcIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qMREUABHnaPWngenBShsQc3oR+mUksp7gIghNXBzQwo=;
 b=EzCHWLXJUJv2UKYVzC+ucPNWeAsTn3ArCt7YXNNb/U++vLhSld2EZN/SF4IG86YITiCTuCOKxT8+kWBQoSCeBekccyAPApaPsjudVmjjITFTMzgJdFPah4cAUlFlRiRLk0jN7C4V3IfPiok9/jyLCmAIP1lyYBg+Da8KuL7WqE8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3690.namprd13.prod.outlook.com (2603:10b6:5:24e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.29; Sun, 14 May
 2023 14:53:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.029; Sun, 14 May 2023
 14:53:52 +0000
Date: Sun, 14 May 2023 16:53:43 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>, Kalle Valo <kvalo@kernel.org>,
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
Message-ID: <ZGD192iDcUqoUwo3@corigine.com>
References: <ZF-SN-sElZB_g_bA@pidgin.makrotopia.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZF-SN-sElZB_g_bA@pidgin.makrotopia.org>
X-ClientProxiedBy: AM0PR02CA0136.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3690:EE_
X-MS-Office365-Filtering-Correlation-Id: 441c59d8-3042-40a3-1434-08db548b0860
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	g7layZOEY94D6GeIg0AOF0jSu13zG7tWuYrpqWbaaVuP+LWwZvu4eAmtwGbYM2AghfYSw6M54KTKQUa2410YxjzJ/L0L0pUTtTjAOnM0w2mEiwnCOx01cBdNDQJMM5+OAOqYdQHtL/Xd156V6krw7kaneUYFRuZC+Zv7Df4s833/y7riqq6aMI9wZ67JTs9AdRt9S0sPgBV/3ojxdNNsmn7v7aCprkAxmeuAHLllT+ShPZ+fyfxlFtcbz8rOTISLWkD+BBgJwg4qfgLZOxav1JXgtIqZC/ENr32HBG09GVzrhbqoHnrOTMMpD3GOSd/y/LKZfEEj3k9Prx/KbJlFJB5dwgAMuDCNaDqy2fpuFgA5ZBGfrujX9mgKX0sV8m5jrIPRFuYkvzzu4K3g23eLInk5BpbhBs9FWQLsocdaGzwINGmggBGbM8B2o/gM+wV+gZu3geu1Oewa8eJoPI8DwjmM3WTmHMNBsd9/Y7DacZyjIf4XvOH4H9jrl5sypjnUv2mdfU3a5kPbLiFp1qtPGAdkB92iUJbwnNm6Ctci9GXmjuD6kUguw7HXMXORNfWN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(39830400003)(366004)(136003)(451199021)(66556008)(6916009)(66946007)(66476007)(4326008)(478600001)(6486002)(86362001)(316002)(54906003)(36756003)(6512007)(186003)(2616005)(6506007)(41300700001)(8936002)(8676002)(5660300002)(44832011)(7416002)(6666004)(2906002)(4744005)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fdATbZspMpbMzBv2NDt0pATp7UmmpPJe2KtS0XB9cR9GeGWdEZhTYeizAxY7?=
 =?us-ascii?Q?eb0CwCR7ogFTtCHyJCikx2Zde7dqmGaUq8mfX8b8c/OvhGG6ol5jDS+7UV/p?=
 =?us-ascii?Q?h+mjxE9SbVvUoEMqNZsTa+KPHJTVkKG0S6Tpl5XEbkChG6DOTEq4WDDK3K37?=
 =?us-ascii?Q?rNHoq3wcrKFgk1xxuxjtltK1CsQcaYbsYmm42/G9hdWSzvqvaZFave4a87oK?=
 =?us-ascii?Q?qpt6Mqp8RhQ7GG0DdVrBRkCi8QmExbz165uzSaQU3EkDCWvs3Y2wuQYTi9eJ?=
 =?us-ascii?Q?/1Xh2n51wMDwA/llA47QZJ3Royo36+V8xONcbLpm5Xgm39Bx0LDBxGv9dk1I?=
 =?us-ascii?Q?A9hj06ZrvbzdtXbZkfiLDUIdvrI+6DQGtRXuhLJDF+xGN6o0A3y4anuKimqy?=
 =?us-ascii?Q?af0CjZlJI/+iih90NiE5/BPGl2hPxcChM43rcKA5E+YErF0UFMFE/5lX0bNR?=
 =?us-ascii?Q?OGe+tlsWJKNYhjFP0qPyQTv0d6uf2kjNci9nILntX5H22jZOdniXHHKrSHv3?=
 =?us-ascii?Q?NdLXIU3gvLMstBE8YzNQJRYkJd7EFWmKDBmzjhw0kd3Zcd8QiygxL3xWHToM?=
 =?us-ascii?Q?sAV1qN23Xpr3L8K2ZHcSfNCVzEhIBOojntwOFiTVddMpKCyIX1f6FXFP9NV0?=
 =?us-ascii?Q?EtMI6EAVeR7LjUCHs/snCgOGNoe4h4vnwIz6HJUotO0ZwTJ+izOMvB2hoy2r?=
 =?us-ascii?Q?M/POduZdAEWRQf4WxKjLOYUt5c0U3tdpjq3teAbnSRup11bE0wpsYn02jEDJ?=
 =?us-ascii?Q?yRGpDBGoyDtsj64GGpI/rpp6ySGd/8hOH/xRzanmAxjG30ts39bHkELed1+h?=
 =?us-ascii?Q?CNUdTWk9NB80dpWe5eIX3vBE44oiDoU3Q4VqAB7JQl519UERFHmjgoYiqOvU?=
 =?us-ascii?Q?Rqc+vGpk+vEoSIbcXi118uCvGv0zJWNDBLKEWBlIkOlivf5xJj4NCraC3iyT?=
 =?us-ascii?Q?hIivjJzxiI1m+h0fVKRNkto13i91Srv/dtwkEk2PYcxkLHgrQROHK+ohmhn5?=
 =?us-ascii?Q?l3HwMIK5Nsa5+jsEGCe/op6qMBkh7ANxhH1lDvsOX/3oBSEJTvm+lrKlovXB?=
 =?us-ascii?Q?PrP37SUZG07PN7QYdToViU9vqzXD9TD6z5/Cw2Tf95uCI/HvZKm058js0ybf?=
 =?us-ascii?Q?E1PFQyQGU2xsSNsWtHyaUhgge2g5FEg5+m7KWBDMAskvDtMXjFWRH5zl2c3x?=
 =?us-ascii?Q?CEYwXVt1ymhcuPUUxiRmm0KxeFei5Th7UksR4cvGSHP/tDID/lX2izLk9ai9?=
 =?us-ascii?Q?J6CgkvOEVzA13BJ9n36oLYiTEKHlflAbDD45NxSBzdLX44sadLIQgbIADH0J?=
 =?us-ascii?Q?P7TRxYJOM5PIziXwSwmKJu1judkqLyV6WNKsgbFjjE+sCdmzRUIxuH7DyUoI?=
 =?us-ascii?Q?ogJpa0ieEf4ehzNL2mFe3OYYgtHrdGmo5i5EJ1tFGo6tvQWCYzfPh8fseNXy?=
 =?us-ascii?Q?93hs2lSlQWZVIFGFis+XP2OBAPSF4Mar8PVPSkeojs4OVGfdhJhYRgZUszHq?=
 =?us-ascii?Q?6haJK9kr9MefD2xIoYQ9QsPmDoiyUsrSsN2/f33YGEwW4iBVVHktKPSBZ3Fy?=
 =?us-ascii?Q?5dkW8oF9qizqGGsnU/nJ/9YtWktSM8Zkj7DRdrWkVA1PYchp7XTc9LEu7GRY?=
 =?us-ascii?Q?Q8VyU669XR+5HAyO+mG+aA4JYgR1N1bGFqgKEC5zbX4StGoudW+nReTknQDc?=
 =?us-ascii?Q?vWNExw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 441c59d8-3042-40a3-1434-08db548b0860
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2023 14:53:52.3084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SHKVQTvLysa47nyCDqwc21RlVRA3uKNdGNHZ82w3BpYakrucX79sTvgKpFBu6RIyX0uNHTZRjSk86dxhcrIYXc+Ml1g6NuqQSQb2zpdAYcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3690
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 13, 2023 at 03:35:51PM +0200, Daniel Golle wrote:
> From: Alexander Couzens <lynxis@fe80.eu>
> 
> Add support for the MediaTek MT7981 SoC which is similar to the MT7986
> but with a newer IP cores and only 2x ARM Cortex-A53 instead of 4x.
> Unlike MT7986 the MT7981 can only connect a single wireless frontend,
> usually MT7976 is used for DBDC.
> 
> Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

...

> @@ -489,7 +516,10 @@ static int mt7986_wmac_adie_patch_7976(struct mt7915_dev *dev, u8 adie)
>  		rg_xo_01 = 0x1d59080f;
>  		rg_xo_03 = 0x34c00fe0;
>  	} else {
> -		rg_xo_01 = 0x1959f80f;
> +		if (is_mt7981(&dev->mt76))
> +			rg_xo_01 = 0x1959c80f;
> +		else if (is_mt7986(&dev->mt76))
> +			rg_xo_01 = 0x1959f80f;

Hi Daniel,

		rg_xo_01 will be used uninitialised below if we get here
		and neither of the conditions above are true.

		Can this occur?

>  		rg_xo_03 = 0x34d00fe0;
>  	}
>  

...

