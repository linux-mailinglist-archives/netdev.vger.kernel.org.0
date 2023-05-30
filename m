Return-Path: <netdev+bounces-6479-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 209FA7167DE
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:51:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 242CB2811E3
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B0E8271F3;
	Tue, 30 May 2023 15:51:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F8C17AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:51:19 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20731.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::731])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DFE10DC;
	Tue, 30 May 2023 08:51:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U1rg2UTmhvWCMrIWfsu2bi54JQJQ5Yc2aXO66Gd2zBqDfFghOXm0QqURskY9X7SCtpsnISla/He2vRY/rvdBOvrDhOMS1E7ON30F0YEELdqO69rGoTtMvdOfd4CBl98xwkV3rboH7o0/fNFjcQfeJmDH1gYRD/5FuowbHTCutqpvPmc+EQ6u1Lk+2uL8x/YkwPdm4E0Wkyv0tvoRYtbEjtPGzQLcRwTLrfa36mz7mphygfaJd8BRo2XOUy4pxfiCPOt7dU6iDElJSxM/HRG3tO/ATyK003UWwHE3O7Yaf97EGHan5MFED88+8xKw8my/3zFDoXI+N8rglCR6LEoX5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hHGwTEJGDoptGTTSNvnDTd1LTLZl3fJ3KBk1CCQp0fE=;
 b=F2ULGBKsl746PkQocCibUuDhMMMsl07Tm/v7dknQBzV2C4Dp44Ks0oPfLWwAo3KxutrkxYxIIXQbYKssWx2WArqNjvo5q0yKRJmky394qPZKWPZ9pq+AXL0w9AIltWc9Nx0iOqcoAOM4ijpjYJF3qFJshSM7O3bosD7IB72QrZ1AdexLegt4kEpK6kJ/b8gk/6z2eWbNBD3AcvfcB0e+yfc+P7YBagcb55hMrHaIwTgpJPPODIhAQQPGQd17L7U3GscdtWCKa9Vqr8p6C0ECyR6Zgm5COMgOz6Dyf4bOqm6Zv6z6Ybd13R6PE5mYyw4qBv8JI1js6wJsR2V9SERo8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hHGwTEJGDoptGTTSNvnDTd1LTLZl3fJ3KBk1CCQp0fE=;
 b=A+WykMXjoSPgWhPQESCCJe8hYxMeUx0sOXRlSJFAmqthTp0AnNuf3m3TUuixVvxswbQKmofNGmxcxsXYTgK8ob4BMwrRMB0b8x8mygt4mGgcwp6o/ar6fOws0UaXo5E6Db4iBJkwfGF0MdXhow0UZ1zDuUTPmFweqGRCFEshYgo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3872.namprd13.prod.outlook.com (2603:10b6:208:1ef::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 15:51:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 15:51:13 +0000
Date: Tue, 30 May 2023 17:51:05 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
	Thomas.Kopp@microchip.com, Oliver Hartkopp <socketcan@hartkopp.net>,
	netdev@vger.kernel.org, marex@denx.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] can: length: refactor frame lengths definition to
 add size in bits
Message-ID: <ZHYbaYWeIaDcUhhw@corigine.com>
References: <20230507155506.3179711-1-mailhol.vincent@wanadoo.fr>
 <20230530144637.4746-1-mailhol.vincent@wanadoo.fr>
 <20230530144637.4746-4-mailhol.vincent@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530144637.4746-4-mailhol.vincent@wanadoo.fr>
X-ClientProxiedBy: AM0PR06CA0079.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3872:EE_
X-MS-Office365-Filtering-Correlation-Id: a99aa63a-1a13-40cf-d6cc-08db6125b225
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	L+qlKB7nS5ysZecxkO4rLQZelXJbNNmC1RSWUcg1hHWg9Is000Dqjvm/U39VEphoEQ/NmNVdlEkyiSTyKTot5l2AzCbvqP+gjdId+LeC1YjG8Dsg/2ziq7fJzkhuII6ETcw36n7tvNhYlKUP89GWeEzxG2k/b9ca7hR2IIWXKtoU2La+GAkKVd/VnrJ2cPJxLEu3u2zgcA2riMP4jD/e0+iOKPgIJcyr6/ekqNYVGe15NU1nZafnt/0am8ISd4pHeD17AfK9Enwi44oQma2/wGf1n3ECbxM1xchmNQLH/A4nUJZikoXMHrrR6WKas6GxD6GIeenPIzicXqJ6tj7Vm0iFs/TgCIvKYb4mbufYQTAcQygzq32R0eiA9UBY0kU8QuWJeXlRXfdSwhc4PI/7tVUt+7m8/jtjCvqMLlvc76mpBrhMfxjBNihRHYKC2yYJvS+/bUvjZLOUSM6qSGz/0Fd6iWRMJ/Vx5T4xyBkrTYfLx0jTyCiJHo3nTCYe3a9xXqRjUdGeP/ZyC3PawOhI8WXciquISU2XQIgt1ryviecPxxGs2EEkM1tIKOnr0uAv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(366004)(39840400004)(376002)(451199021)(6916009)(4326008)(66946007)(66556008)(66476007)(86362001)(478600001)(5660300002)(41300700001)(6486002)(8936002)(8676002)(44832011)(54906003)(6512007)(6666004)(316002)(6506007)(186003)(2616005)(83380400001)(2906002)(36756003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eBHw3gzkYvWy5cWbiXLSCOaCWso3bQc0VO4JgdNSgzD4BckLNxQY95aQaVxC?=
 =?us-ascii?Q?WBFksaoBedpHYr0fOeAojS/YXWkclefEZtmKEzGnxWAYbL62C4Bk4boftaAK?=
 =?us-ascii?Q?Ns6f6+Ybd0J8jI6md1wY/w5pIBgF2QSSdkywbzzYubVAqeXy2Z6ckmKfuva8?=
 =?us-ascii?Q?GyYo8ovDaNCr1kloiGAx70XQkGOYDfUwc/wAZP3fo/JRCutDwKYIk1FF0l++?=
 =?us-ascii?Q?wHSAGZEfpEY8NxLTVB9srOIkAWJFwRKAOTn4ZSzfQIRquV4ALMEYpX94WKEf?=
 =?us-ascii?Q?MB3Vnb9hYFEK9y0lifsMG6FPqE6B0NCCMoNk/Eek8FDc6YsMQCHdmdpSZdDF?=
 =?us-ascii?Q?Exl4FTET1GnYa4dCC8ee3HnOedR0SjksRNhdjHDFKZxYkVdnaO67bCimO7p7?=
 =?us-ascii?Q?ahcNgq7iUwqLGQcFCJB0GWeoZn61rv162eoQWtdofDxEB2CqKA5bkERepRE2?=
 =?us-ascii?Q?HiYUCud0OW87F/6gFMsUILAan94drcZzTBfrYxpbPdFX4aE82ccNImxUIexD?=
 =?us-ascii?Q?QmSMXFalGhuxr2z5Z76QlS/NzVIoy7pUMT6ti0iffiEMW5dmMXgeuHUvKgNm?=
 =?us-ascii?Q?gftH/WbIP66ENHAiqkm5AOzipSUbvCiYIWdP7wT6r9bYrKbyglHZ1LyLUo9o?=
 =?us-ascii?Q?7enbezVkHHyw5CWiptevd9NC+HKVDbdSkBikyuTsaWCiKKBfD4KVvhBLzEsh?=
 =?us-ascii?Q?FilXe1fRj6nL7lSwY08415brLK7FXpDG3JdDbzsoepFf3A4DL+AVhQO0l4Ng?=
 =?us-ascii?Q?X6enLA+rZWQLz9uNLArt0UPvL/gmvO286wcxw5TpnHUSSY6kWMczB/5lJ18n?=
 =?us-ascii?Q?1LwKpI2Xc+oTrxpYutNcf/F0egXqNvBuUzp7HWtyoP+J8BtkhVyaoc0Hoihq?=
 =?us-ascii?Q?/taO0j5+/qhm4MaN69+ow+jYnSFnZE92fozsp85civv0j5gORxCq2xGH0F6t?=
 =?us-ascii?Q?4Uh9FK0RM1VPT7Uu0RgHlUtJ3VtxNXEFKqa+q+5XfubZCmHMTgHC6GLl5oFe?=
 =?us-ascii?Q?x1KoS6dGMyVLL4LZ3qy39s0lzCpCXX22jgNAYEP5Uqg/rSRpXfy1vyRYKEUy?=
 =?us-ascii?Q?VBcJNYPmb8+cKycGrWwXyJzmY8mJvJGl856b6uJDzpllzly8bMwPyUaHk+uy?=
 =?us-ascii?Q?GWtWLhUt1eUMi8+f8PcvnHmFVXJM6KmnVt5ibVQ7aQvDRtdoPfHYQEFlNgOe?=
 =?us-ascii?Q?2hmNPrTxzDydT+SsnQdxwhPhqEi+PEXUpcC1gQMJKxmEp7Y3SCfpSaF/H0M4?=
 =?us-ascii?Q?TWkcoBnBI61U0AoYlsqLLoka7VDvY8bPkrDJ6Grae/QNPB4Wkn2hpjDCHrL4?=
 =?us-ascii?Q?wAH7T42jJpO7xLoW022njHtGbeTksjaGezVU2Gid3hR3d0BOk0CU9TNQvENm?=
 =?us-ascii?Q?ZAyQGBl9MTw1/kTVAYK2XhRvFe/dNlv9GXdWQ77Mq8e3XIgDMOOHSF9+5UJO?=
 =?us-ascii?Q?CLtRhp+eAdaSG10sXmvww39jvofjLaLa7BQ4m3tQt98Wsdehb8nGcxTzmVo7?=
 =?us-ascii?Q?CAo7RCRBWYQ65XFSRrlBlpDY2Yz37nSsoe2LiJQnNpING9Jh/GK2+TUfH/P/?=
 =?us-ascii?Q?67RdRxIJdVOow28O0FFUqL7ELExKCXGujNhVfvWDB1oLD43IO0lGlOFo0+Nv?=
 =?us-ascii?Q?+4jtOwJLOfCkEyl8veeBtccLtim483elrqexIMJ3ckK1m7JVKGX4kEbE/1Zf?=
 =?us-ascii?Q?o7EDTg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a99aa63a-1a13-40cf-d6cc-08db6125b225
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 15:51:13.4983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4oVp0uSfKcDXpVEg9iAuan/xzgMQn6PeZfpO5IpwZf4SWbxPsHwHMeFzucyeDT/wQJ5FnWLqPSRB0gWSHayDtf7WiS20X/flpKPMpaSrt68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3872
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 11:46:37PM +0900, Vincent Mailhol wrote:
> Introduce a method to calculate the exact size in bits of a CAN(-FD)
> frame with or without dynamic bitsuffing.
> 
> These are all the possible combinations taken into account:
> 
>   - Classical CAN or CAN-FD
>   - Standard or Extended frame format
>   - CAN-FD CRC17 or CRC21
>   - Include or not intermission
> 
> Instead of doing several individual macro definitions, declare the
> can_frame_bits() function-like macro. To this extent, do a full
> refactoring of the length definitions.
> 
> In addition add the can_frame_bytes(). This function-like macro
> replaces the existing macro:
> 
>   - CAN_FRAME_OVERHEAD_SFF: can_frame_bytes(false, false, 0)
>   - CAN_FRAME_OVERHEAD_EFF: can_frame_bytes(false, true, 0)
>   - CANFD_FRAME_OVERHEAD_SFF: can_frame_bytes(true, false, 0)
>   - CANFD_FRAME_OVERHEAD_EFF: can_frame_bytes(true, true, 0)
> 
> The different maximum frame lengths (maximum data length, including
> intermission) are as follow:
> 
>    Frame type				bits	bytes
>   -------------------------------------------------------
>    Classic CAN SFF no-bitstuffing	111	14
>    Classic CAN EFF no-bitstuffing	131	17
>    Classic CAN SFF bitstuffing		135	17
>    Classic CAN EFF bitstuffing		160	20
>    CAN-FD SFF no-bitstuffing		579	73
>    CAN-FD EFF no-bitstuffing		598	75
>    CAN-FD SFF bitstuffing		712	89
>    CAN-FD EFF bitstuffing		736	92
> 
> The macro CAN_FRAME_LEN_MAX and CANFD_FRAME_LEN_MAX are kept as an
> alias to, respectively, can_frame_bytes(false, true, CAN_MAX_DLEN) and
> can_frame_bytes(true, true, CANFD_MAX_DLEN).
> 
> In addition to the above:
> 
>  - Use ISO 11898-1:2015 definitions for the name of the CAN frame
>    fields.
>  - Include linux/bits.h for use of BITS_PER_BYTE.
>  - Include linux/math.h for use of mult_frac() and
>    DIV_ROUND_UP(). N.B: the use of DIV_ROUND_UP() is not new to this
>    patch, but the include was previously omitted.
>  - Add copyright 2023 for myself.
> 
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

...

> +/**
> + * can_bitstuffing_len() - Calculate the maximum length with bitsuffing
> + * @bitstream_len: length of a destuffed bit stream

Hi Vincent,

it looks like an editing error has crept in here:

	s/bitstream_len/destuffed_len/

> + *
> + * The worst bit stuffing case is a sequence in which dominant and
> + * recessive bits alternate every four bits:
> + *
> + *   Destuffed: 1 1111  0000  1111  0000  1111
> + *   Stuffed:   1 1111o 0000i 1111o 0000i 1111o
> + *
> + * Nomenclature
> + *
> + *  - "0": dominant bit
> + *  - "o": dominant stuff bit
> + *  - "1": recessive bit
> + *  - "i": recessive stuff bit
> + *
> + * Aside of the first bit, one stuff bit is added every four bits.
> + *
> + * Return: length of the stuffed bit stream in the worst case scenario.
> + */
> +#define can_bitstuffing_len(destuffed_len)			\
> +	(destuffed_len + (destuffed_len - 1) / 4)

