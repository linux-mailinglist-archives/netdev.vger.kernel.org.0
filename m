Return-Path: <netdev+bounces-4658-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B83570DB4A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:14:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D398C1C20C23
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC8684A85C;
	Tue, 23 May 2023 11:14:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99334A840
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 11:14:32 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2123.outbound.protection.outlook.com [40.107.243.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11816FE;
	Tue, 23 May 2023 04:14:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYEsRy5/XznWNeSaedKrCe9ql75i0WJFLHXsiBZ8uw0zJnuKKdX0LzFj4bxhKi+0TJeUJxdrgJaPCRQslHKo0epQ6r+mrRsz2ABh6K3jZ3bOrVrtp0N3WjayLFxK2Oky8+iCY4qjdGOUFYmTzg30C2lWA099pRnoMRyhKads2spHZ8s9lCtaiMbMI8GwPPGQWeQB292i0KxtscXwRBQkc7Ck0RO/xWwAfS4eLGRJu7+x5s08Bnl47A+u2VHUqTGgCDztTGcvsXC0GsxU4mO2XLvlhxZ5GHNHtOu/eY5v+0fx6v72VCzBZFBUnBwO2sJrs7cvP36CSQd5NkbTqhFRWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cCMiR8gRFE9eWLmb2wHEnrWR3ygxP/xh4XkXzN9aPAQ=;
 b=nkPHnZeJ7X+O/AsNW60grc8YrNZS2LVJk/qF+3NOtiaawoDCA/oshfgFNMvH3F9vE6vOv9LgYXw0mW5U3kJzD6AL9iWP3KjcoVuwGbnulmMVlPp0xkEYu57KP6961mYCzcIVMPjWxWl32LhF4G4iNgNAWCmrLNBUxAjlrvIUxEcTGSlHf80VNv7FOyyVNnZot9Tf/BDKy/EWbK0nSDhpSsTorbRx61oBu5GWKHImeprXzT3ALxh2L3UoyIECCZMnpTPMAL8Z2cnorW7HtsMz9gv0BOMspLQIYf6eXCW79UM9K3snJQeySS2Kmguufctz7ICZgCsJIuN5bFr7oE5Rxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCMiR8gRFE9eWLmb2wHEnrWR3ygxP/xh4XkXzN9aPAQ=;
 b=fwa5CEsiwnjyQ7BgeHuO/gKpxIZQJesVoIgUO2PWFNT9J6LjuQcbf6+ZN32ni10ooy2jkFXXabVEtmjI++lJmjaKSqeCrSGU+LJ7uxW6GlD4wqMePj00UiQyJ/vDKIkFVwvq4toXcv+/q6FtuddIwnu6x4IukeeUXumHlMGU82g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5237.namprd13.prod.outlook.com (2603:10b6:8:f::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28; Tue, 23 May 2023 11:14:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Tue, 23 May 2023
 11:14:27 +0000
Date: Tue, 23 May 2023 13:14:18 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
	Thomas.Kopp@microchip.com, Oliver Hartkopp <socketcan@hartkopp.net>,
	netdev@vger.kernel.org, marex@denx.de
Subject: Re: [PATCH v2 3/3] can: length: refactor frame lengths definition to
 add size in bits
Message-ID: <ZGygCiGflvcvi787@corigine.com>
References: <20230507155506.3179711-1-mailhol.vincent@wanadoo.fr>
 <20230523065218.51227-1-mailhol.vincent@wanadoo.fr>
 <20230523065218.51227-4-mailhol.vincent@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523065218.51227-4-mailhol.vincent@wanadoo.fr>
X-ClientProxiedBy: AS4P189CA0044.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5237:EE_
X-MS-Office365-Filtering-Correlation-Id: c241c8f8-24d6-4a02-d93a-08db5b7edf85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Lyxek7FWe01b/8+drsOYQaVCDkfZjxpedNnObbwJs4QL6UziAB1/H9u+uGKIw03uwCCxTHulIVWW6N4kcFLrosC9cddrNQw5d4nGB2mJzfmvsIuxue0VP5V1uJCzqOBVtfyuH7W5p7kRVzRP9ejq5VVHI2Ma1B4mfPECH6G5tvp4yVSEHAenysLwcNR0TCaD/loRuhdkElmFqsHSHrdLjHRFM2eehPwgMh/61ioLggQ0p8YHcUS1onJBNabKduUDvo3hzLe/RIMWy5HL/ccF+q494jE9Hf0nlqb7IfZ6MajQURt+b1yUT/78bxr8lsF5eTM6Zl/G7rI73IECbHKOKsdApzwL+6p23MSpgkFDifrmWxpqUGCI9MCwQAZR+t1LrM0nqcGYRBr/QXw4wtb+6vhc+WqXtk9GkiAEtmf+V91e3Cowp9qzFAvPmcDvG34Su1hLv7557EqW8TOqwAW5i1J5nIiRqh21Dnxb9sTKafdrYXlM+D2m3CbPviGqHNhpttNFFo+ss5K3E7UApnPFvK+rO/BM5zG+Z2SqFiNowNsVv3VbHhPChjSkBgDV12Nd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(136003)(366004)(376002)(346002)(451199021)(8676002)(8936002)(44832011)(5660300002)(186003)(6512007)(6506007)(2616005)(86362001)(38100700002)(66946007)(6666004)(41300700001)(478600001)(66476007)(4326008)(6916009)(6486002)(36756003)(66556008)(316002)(54906003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EErRxCGJNPrX0BWKwqI/HyWCi/h+fIBZ/jp5CgBR/y9dKDxHYEejuxpK7QwH?=
 =?us-ascii?Q?+Q6JIntchqyBHfiUYHuDLg/BT23e2YiGwYhzWZ8rlLj5QtZb7OYGXUa+z2A6?=
 =?us-ascii?Q?VgLc3WYmnSAg1j4p3GmQR5ekL734Keo/YRIZTA9YSKDZLLNkNPh7CnmV/KKz?=
 =?us-ascii?Q?ry6MQuJJoM9Eo1Jg0NolOxNSH0SPQi0XMLrfQG7JrDBCOtcFHs2g7ZvXkJ99?=
 =?us-ascii?Q?jlcsn2IvRayFidlpfs67DDhSWUbWzm0NorcZwqNKf534DyTMNxfSx+GgGsfg?=
 =?us-ascii?Q?uxXUzCLnITx1eSRzsnpUWQc9dacPwVokdR+gnY2gamX3kSzc1R3xBmoFcOUH?=
 =?us-ascii?Q?b/MOIBjOHx1c8JwGaMVZBxUwX414/9qc51lwrFcs5+2FR7nmG168Y9WU+cQI?=
 =?us-ascii?Q?OyTLtIczMLEkas2/CUCI6oifxltWJfCYgRdcx7Ud9ToYTQB07AVHsHWIxCIW?=
 =?us-ascii?Q?NwRerUDHK8f4DKeKkpvOem6UfNximqwx1Z8Tg7sFemR5WyhScyc5XdzGb/AB?=
 =?us-ascii?Q?hN7kuH/xlztJKQ6Iy9uyJCDISyLvR48aB9dIxN+Rtl2YjkjUYxwp3xyZ35oj?=
 =?us-ascii?Q?0MA9GpuM3ufKQDqcz/g5HoUrbWH0W9JwTOvhBHPDoaYRcx/XMxu1GxPyI9WH?=
 =?us-ascii?Q?5VXHSBsYFUDR9Q/yRtoxPVcHp78foFL37yzJXFXUNj3F/ayYEm8tynG6DI02?=
 =?us-ascii?Q?1SAAsiuaD50T9H2fpylT9CknsEkjXNCmFsGcPZr/J2Q2UW1jhB5sQKQ/gL7i?=
 =?us-ascii?Q?AeVNR5zYLx+3x8pxsHyXAelVL01UFlomheegEy50IgVvgGbC65sJtDUGw6vS?=
 =?us-ascii?Q?wvBu/ZDNvKl5zxE86okVZJOGeWg7SBGTdjIjCodk3dhbJ5dkIgAjMC74jLxt?=
 =?us-ascii?Q?f5PvVVgGfyh/v4vXVmTptHMWiH/ob90rCHX/HPz/TKQo9HSccfWSCWabXstN?=
 =?us-ascii?Q?Il56LnIAjiw6a4eLzSJvWPFTpYciP4VFetvTqStVUY8j/zs89zu7GUklnhpZ?=
 =?us-ascii?Q?TTMp/fnOa2WfpA8wYHrOM69XltHPefrdU0a6rSu6VyZbNFmLX8Qi/uUFlaKC?=
 =?us-ascii?Q?QQXJyf7LCfdxTyJQG+Kgm8wrNDBrKYbzSu8QyOYl12m30YBS0ZrsTuP4rti8?=
 =?us-ascii?Q?OLBhE640eMTkr4/rBqrg5zN1Ge30hswjeUlT7z0GHiGR2jvYcn2l3sLDEEqW?=
 =?us-ascii?Q?le79ERqhfdIH2I8b3WeFNqX13Gv1HW+PKlX3V2O3A4KXtFi1H1zzxoRR2D15?=
 =?us-ascii?Q?bxWoyuiHBAPpR6HPbgQKqkSTK117YCXvEuKlKKK6vm9obOgIv/2/CoR4nJbK?=
 =?us-ascii?Q?ysDplSKWk9u2qcE4BUIw4dKUJFSjOsWvoPXSus/H1+69+CYKJBNw7+fhJR2T?=
 =?us-ascii?Q?Fo0PoAFobJsWwhdTerDF1IkfXIrI0nSCx51eOFut9NVzrSDwtT5qYxs7vZrU?=
 =?us-ascii?Q?t/t5fGnX92Bf8UkhoEuED2rDjFnL8o6Ydk6GzDgmXGhTuDoZ7cT8UsWxEeVZ?=
 =?us-ascii?Q?4rwgIhBBCEi4KglX6t+9DjSBErGPpnxujRticJTCZ4O35/L8A1ZBnGqbr8ux?=
 =?us-ascii?Q?ybm2Js5t8MVMUut4/LqHa8oOMPP/erp2L8q9i29um3spX8rchFlCTnXaKCQX?=
 =?us-ascii?Q?b+nN4mBxuHCKEdjcYxeUi6qEszGU3vl+QVgT7itic/p91Wy42tpd+w8/VsfZ?=
 =?us-ascii?Q?Ln7vAA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c241c8f8-24d6-4a02-d93a-08db5b7edf85
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 11:14:27.8514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pc+8St9VZxH6QQd1n/IUQCelFE3QlDH2hcXRkkkAAj8TqM8F6ebqEyO0ZtnbaPgiPwKWTOtNjZe6l+kBnMAlUCW5YZIhV1XDejfXJnYPrAM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5237
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 03:52:18PM +0900, Vincent Mailhol wrote:
> Introduce a method to calculate the exact size in bits of a CAN(-FD)
> frame with or without dynamic bitsuffing.

...

> +/**
> + * can_frame_bits() - Calculate the number of bits in on the wire in a
> + *	CAN frame

nit: @is_fd should be documented here.

> + * @is_eff: true: Extended Frame; false: Standard Frame.
> + * @bitstuffing: if true, calculate the bitsuffing worst case, if
> + *	false, calculated the bitsuffing best case (no dynamic
> + *	bitsuffing). Fixed stuff bits always get included.
> + * @intermission: if and only if true, include the inter frame space
> + *	assuming no bus idle (i.e. only the intermission gets added).
> + * @data_len: length of the data field in bytes. Correspond to
> + *	can(fd)_frame->len. Should be zero for remote frames. No
> + *	sanitization is done on @data_len.
> + *
> + * Return: the numbers of bits on the wire of a CAN frame.
> + */
> +static inline
> +unsigned int can_frame_bits(bool is_fd, bool is_eff,
> +			    bool bitstuffing, bool intermission,
> +			    unsigned int data_len)
> +{

...

