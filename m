Return-Path: <netdev+bounces-11012-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7262473115F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:52:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19656281516
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1663820F2;
	Thu, 15 Jun 2023 07:52:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014F2635
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:52:17 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22292D45;
	Thu, 15 Jun 2023 00:51:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UoedrooL5GT2Gjrb60X8JVTUemmn4WFiPC+9omc5GaGyvpW82sabgs4xsjmYaXitpsSS+RXmjsHUfodPQ2mny2/bgx6Hxksfzx9glGv8FpkvdvufPYxJ0fxNmOafDtC1l++xJ8wCcJ2sD8+H1uXv+j1n2nceErrJ1gzwLOgk/07or2KEoOWlyjjHKmgT3hXzzF+ZFkuLgCgWQiwtFfiVIflftX5kXBwn/abomDJlKmAdVn3ZEyaAIP847RGD10JPQuVUj5c7KDVPIerG8FiFdGrbWXOSpc/M31O7ubIh+CO9HxpZAv96tcjIrzciynvaiNn0iXunMdkKzfOT7O8aXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QMYPXHylG49iTJetBl+AtmFdYtl8RLnAuWHuhYopLAY=;
 b=NX7zTSP9Uv30DFMlNkuAZ2QNA4ybob4awcV+UBotmEm/8yYRvfUCMnoBk1UpJeqsmBN5L/QmVEndwBEKKNewJpKPS6/h8SwHEYAqJuxxQ5RDP/SvR2ekk9DZm4Wk/ZtNBag2AuBAgG5R89dpeF22DIH43MFa6ovEaGg+pTQ/CMhIO1pu7gHiia09Mh01y++0GZJO6g5LRs089oWO6aPpInrwIOYrqWkO3tDi/yfh2fhskIME6CMr5xuz79b58HSdLWMJ7zaL0HBFLfu/UtG9NGFRACQj9zzGQv+OGQSOJRXACFntCe07P1v+a3W1qHTQxxO4dQC016WIEauIew5D5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMYPXHylG49iTJetBl+AtmFdYtl8RLnAuWHuhYopLAY=;
 b=GnxuPmcsdHlO0DmQ2qhD4HHTF5BlfyqhFZnIRc/MWln8NV8tCk98MQATxKxC8iasSs64au6IDtl05xN08Q1bx0HJMlOq921RPkBFSoRgUDImOUyF5LfWLo8LtW6uU/GphS1Ub+s96EQGFM3P0XW4AdNh2lbr8n3qMfLQRvbV79o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3702.namprd13.prod.outlook.com (2603:10b6:610:a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Thu, 15 Jun
 2023 07:51:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 07:51:11 +0000
Date: Thu, 15 Jun 2023 09:51:04 +0200
From: Simon Horman <simon.horman@corigine.com>
To: HMS Incident Management <Incidentmanagement@hms.se>
Cc: "mkl@pengutronix.de" <mkl@pengutronix.de>,
	"linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
	"Thomas.Kopp@microchip.com" <Thomas.Kopp@microchip.com>,
	"socketcan@hartkopp.net" <socketcan@hartkopp.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"marex@denx.de" <marex@denx.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>
Subject: Re: [PATCH v5 1/3] can: length: fix bitstuffing count
Message-ID: <ZIrC6DpjjtmpIsI9@corigine.com>
References: <PAVPR10MB7209CEA1F5AD12B2E5C8ED86B15AA@PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PAVPR10MB7209CEA1F5AD12B2E5C8ED86B15AA@PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM>
X-ClientProxiedBy: AS4P190CA0018.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3702:EE_
X-MS-Office365-Filtering-Correlation-Id: 6acee109-1a55-43e1-12e6-08db6d754946
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IK7qoet019nlw/Dx+cYno71+BNa98i69V1+50vxTeCe26xml/EntCbmQfovx0tvtbmRzQfA9hla2IIqLuiFXHpSnfaMLGUOWrlH5m8XYEPhSBzr2DeAPIR9LrdKY/5G9P5xnfoDT27uXLYcrhATb9kA+hs3K72Mwd9PmkrnGJWFliVeEoxKHgxcuGRqmXSH6lRE6iEAhIFdffQoRgNEiyT5he/Z9Ho8DTPxEvb8kIImod4jqb7CRsWv5zvRG7EEwtXzGL4cRuaB7LYQNOWeeVWE/0YYwxEpBnBTXhJcpegFZqn5L+XZXRiQkavnHnXgzP2RKJpArqJaJaSSNEx0CPdrYlnuRTekbbbAdVvbUapv6Thfjy/ccOSLQDOLrl1kvPs2K2gi7/VAxg5ncuQbgtpzAVvc32EKCavZQniaGUh8/2q1/mZIWKfuNr2FkKnXOmSpptjAzLUEgWXnvNWxyE2V/HorfFOBmBRTyrzlpvTnSotnNxhBz3vfsA5yDynwC3MgSW/3XvmWLuuZZ8qQCpcCKVXVsZtaRQh2rRjiyeApGjq2yJOAGanFNp4TWd1k6utgf1ZA0vAX7cq5TnmviLBEw4biZ2MaCxQxvf8BbYdA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(39840400004)(366004)(451199021)(478600001)(6486002)(6666004)(38100700002)(83380400001)(2616005)(186003)(6512007)(6506007)(36756003)(966005)(316002)(41300700001)(66476007)(66556008)(66946007)(6916009)(4326008)(44832011)(86362001)(2906002)(5660300002)(8936002)(8676002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DutMtJ1rRv1/BeGK9/p0IQxR1LGnv6W9zoWYiat3WXhMT8zp1b7ioS/PUk5C?=
 =?us-ascii?Q?KcI5Vke6/L5boiDKOYxZ6ywrF+sdDbAZ13RmoKKprRfR7nsDtuimm04TBZGJ?=
 =?us-ascii?Q?fZ9kuyKzwAnmR4IRlbczeRsINMKXJUCfIqz7WoKDIUQNTftWw/3vmF0pFTI8?=
 =?us-ascii?Q?5jw5LQR1sFW9QPYiF7/NJyIG4q8G3Qv1LcS5H20139LOQr9C4GSQIHnDUA5n?=
 =?us-ascii?Q?WlvKET5eReLWvwSAfrw33S13AgdH2h1Q/GFjvtWx0KNHK3W7EEVjPfH0NEaw?=
 =?us-ascii?Q?9JIUznkoFznJk/6SLNaKu+j33V2eBTCMbhzPpYlYRSPlFtdAD7lQzeF8g1us?=
 =?us-ascii?Q?xUonDqYUX4I30mhQxAZbUockzv25GxEvz/M2uy7RlzxSqb4ZKurBkb90b1nz?=
 =?us-ascii?Q?jLkGAg6kciEe8r/bMy0OsUXWlbeJDQKlfYjeZVpN5L46VUnJ44HCxNOknIaj?=
 =?us-ascii?Q?MKjuSeOr/xkP0bMiYHlMFImpD4uVbrvC/NHTZv6hyb+T/kktk1rlzTE4ub4T?=
 =?us-ascii?Q?Xbe17gLGuKea03iSnVN8jdygpENyseYyvDVC+hiztCAtO0H/iZgH6HAIdNEh?=
 =?us-ascii?Q?mDLn7zyOm3PIvXekr+b76azIa4s9KDRURkZZedOfI9suZktkSXKin+ehgkuj?=
 =?us-ascii?Q?c7LgwwS+Wl3pv1mnMMgpoxFyDpXeBzU3ejXjUrhCZzdp0jJ71Slg5VawkOJN?=
 =?us-ascii?Q?7zA+Fzg58nIPDsI+gKUbHfJodVKeQtxAYZbkSta9V5dU11CSX7utKgT0PSbO?=
 =?us-ascii?Q?Q20d0X4WhxhBndq4ttQ89sHffbYmqPDnz5ZJfNpGWX3AAN98X/hFggeFACxF?=
 =?us-ascii?Q?ZT7Ito9z6dxVg8A7d9f8SgBS1Gz3fO54OSY4uk8M9eesJdMn41bbmg2Tpgd5?=
 =?us-ascii?Q?iN5Rb3/VaWElZlGmFic5+TUFPlXUbpx9eFbaBj0fPqXDI2OiWykktYO1zybl?=
 =?us-ascii?Q?h8d3gmYTRv+jGZPNUoEY2zzb8W7KpbrTNwMS1gJy0f5yymHBJBFg8N+1Etz+?=
 =?us-ascii?Q?Ds53pQyh72cclXkB1d7DfhfQjZoTVTi+M35DL0U8qJ0Wa6kseVKXAC/boMgC?=
 =?us-ascii?Q?3gQO30DtyssAJC7BXBVOnoB5GdxynJJFd2se7CwCCPaNRLXUHetkkkfn2kXK?=
 =?us-ascii?Q?pTsx9DPA0x1pRlc/U8NUEQF46eDcphK2M864AVittsx5b5IXqJb/q7cF6uh8?=
 =?us-ascii?Q?chFA6dYJDaTZJsaqBq/rM0xvJKNt9NGSGfsif8IJOGKup1GOlqPHjTYczDB4?=
 =?us-ascii?Q?uGBGJOPC7rUJrjYY7x39oDoXsN4yKqSgDOR6tkeUIct//WU+nb+tqJzfSyEs?=
 =?us-ascii?Q?3puHgKCjDA8R3psrqjEA0Op45I6gTBDGrRsrY2kfEV5jA7WoXkOjpLGTrXP+?=
 =?us-ascii?Q?UrJQojbK+S+t52+AvMVE/NxrBaKbVYeSNwHCbcpm9HDc+/jaWQiUbQ55Ym+A?=
 =?us-ascii?Q?hVjH3BUlXgY+J3SEluN0GFouxP2qyZv1mcC3EG3DRZ//h8CjNofXNNPwcNa7?=
 =?us-ascii?Q?NpKn4yZgy95EQQ0g40ucWsGltJOWwedxkr6RYXaQOKLSbZTyzq7qlXtazzmD?=
 =?us-ascii?Q?ETtu335rekCxiHopWllwiRY3gth4VfX9OV0CXw8Z+hhi1lgLH4Ja66S4nsY1?=
 =?us-ascii?Q?ECg2jtllPVqnRiC6ymVWcfXXI1bvWcmLknSzqh9jnlh+kiA+LYDSdsenuAoh?=
 =?us-ascii?Q?IYADSg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6acee109-1a55-43e1-12e6-08db6d754946
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 07:51:11.2487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A+sxIibjrBPR3nPRRI1sgYd+jdReJb6OP+bNd1+zL45hVBeS8UwxZFVtc1M/r1pO84JR8KC/uVSdAAs63EihumtAGe488b4TzhLthFKBXtM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3702
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 08:40:42PM +0000, HMS Incident Management wrote:
> [You don't often get email from incidentmanagement@hms.se. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> **We apologize for the delay in delivering this email, which was caused by a mail incident that occurred over the weekend on June 10th. This email was originally sent from vincent.mailhol@gmail.com on 06/11/2023 02:58:08
> 
> The Stuff Bit Count is always coded on 4 bits [1]. Update the Stuff
> Bit Count size accordingly.
> 
> In addition, the CRC fields of CAN FD Frames contain stuff bits at
> fixed positions called fixed stuff bits [2]. The CRC field starts with
> a fixed stuff bit and then has another fixed stuff bit after each
> fourth bit [2], which allows us to derive this formula:
> 
>   FSB count = 1 + round_down(len(CRC field)/4)
> 
> The length of the CRC field is [1]:
> 
>   len(CRC field) = len(Stuff Bit Count) + len(CRC)
>                  = 4 + len(CRC)
> 
> with len(CRC) either 17 or 21 bits depending of the payload length.
> 
> In conclusion, for CRC17:
> 
>   FSB count = 1 + round_down((4 + 17)/4)
>             = 6
> 
> and for CRC 21:
> 
>   FSB count = 1 + round_down((4 + 21)/4)
>             = 7
> 
> Add a Fixed Stuff bits (FSB) field with above values and update
> CANFD_FRAME_OVERHEAD_SFF and CANFD_FRAME_OVERHEAD_EFF accordingly.
> 
> [1] ISO 11898-1:2015 section 10.4.2.6 "CRC field":
> 
>   The CRC field shall contain the CRC sequence followed by a recessive
>   CRC delimiter. For FD Frames, the CRC field shall also contain the
>   stuff count.
> 
>   Stuff count
> 
>   If FD Frames, the stuff count shall be at the beginning of the CRC
>   field. It shall consist of the stuff bit count modulo 8 in a 3-bit
>   gray code followed by a parity bit [...]
> 
> [2] ISO 11898-1:2015 paragraph 10.5 "Frame coding":
> 
>   In the CRC field of FD Frames, the stuff bits shall be inserted at
>   fixed positions; they are called fixed stuff bits. There shall be a
>   fixed stuff bit before the first bit of the stuff count, even if the
>   last bits of the preceding field are a sequence of five consecutive
>   bits of identical value, there shall be only the fixed stuff bit,
>   there shall not be two consecutive stuff bits. A further fixed stuff
>   bit shall be inserted after each fourth bit of the CRC field [...]
> 
> Fixes: 85d99c3e2a13 ("can: length: can_skb_get_frame_len(): introduce function to get data length of frame in data link layer")
> Suggested-by: Thomas Kopp
> Signed-off-by: Vincent Mailhol
> Reviewed-by: Thomas Kopp

Hi,

Some feedback from my side, in the hope that it is useful.

I guess this patch-set has had a bit of a journey, email-wise.
Unfortunately on it's trip the email addresses for the tags above got lost,
which by itself leads me to think it should be resent.

Also, I think it would be best if the From address of the email
was from a human, who features in the Signed-off-by tags of the patches.
But perhaps this is also an artifact of the journey.

It is also unclear to me where this applies - f.e. it doesn't
apply to the main branch of linux-can-next.

Lastly, I'm not a CAN maintainer. But I think it's usual to separate
fixes and enhancements into different series, likely the former
targeting the can tree while the latter targets the can-next tree
(I could be way off here).

If on the other hand, the patches in this series are not bug fixes,
then it is probably best to drop the 'fixes' language.

