Return-Path: <netdev+bounces-10631-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2634972F761
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:06:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1281281310
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 08:06:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AD52A41;
	Wed, 14 Jun 2023 08:06:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05647F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 08:06:20 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2123.outbound.protection.outlook.com [40.107.95.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66971FCC
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 01:06:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YrkmEbk6Kc4mOfeyosCOGeTidlbmVzqjxMbhE1aUBczhPykyUly3gABdI1mk9C0O25f7QB4fEdz8epTpAElrK6WDCkP9F69Es3f+eSnMipB+5dC32UsCsi0Mhuj3pEz517JJlNX2c04i9RAyAzuoGSCRrFRALuu+M9I+1/s+Xi8pZi6KiAUlkO2nt0QKT3v18lWG/9a+HoZZQNzTtIXR4Bx8dx1WMEgCC0JNcIqB/01svyWXA8gO3UDYhIAp6akBRUGmieJf37kHkPXCYqo3OKa8inRZ3Gsv0Pn4KK5olFYkLAZZ/KhBzyQjbSMh8+5R587m/OJpesVZmiGSX2Q3zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kNJZEkAGLwPSNINnD8BliCI1k110PDyquSDyqUi0jdA=;
 b=C6bxnAVaFLyizKToMBA2AS0cc/lDqGGEkFO46cqJnCY2Up/y9cj3E66N6ojmiahBB6wwoO2fmI/OCyCH6yJVMR/eoZQD7ZbnbVDLE/2XgJWv7LoSKohQXlI9GQSjxM7vAM1UOfb7CpOVKBWoPROKNnyNe9m5Dmwp/0SFWvdEO6Jvov97ZCksjCON9+tqsqPMGw+fGawpYgw0ucd2guibpDFfWB9txEzt1+4KQF+Tv01snUTacJQAmkqgImPuIIp0X2XKoRIci2OyKoirQKI5sQea5qftf6DkgoaAMhA0ThXzuZp9brYxvJJqz8ooo/tvykaBj8k2/9me9slBT80Q6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kNJZEkAGLwPSNINnD8BliCI1k110PDyquSDyqUi0jdA=;
 b=YpmN1oAkmGeSjOtnAfmTTXmO1tmQ1Ll5XoSyuZ8ZURcaRIXpuTnW/isx8U/V1jE7Dq2diIxK9UnkjMruJ0NURhrgrs44nMuNtAcYFgMOB+FtBfheNWzGBGFF9+fKGgdZD3nW50rvAWna39L4FYhJ+sDxWyNPogSPdr20pc078AI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ2PR13MB6451.namprd13.prod.outlook.com (2603:10b6:a03:559::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.22; Wed, 14 Jun
 2023 08:06:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 08:06:16 +0000
Date: Wed, 14 Jun 2023 10:06:10 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
	przemyslaw.kitszel@intel.com
Subject: Re: [PATCH v2 iwl-next] ice: use ice_down_up() where applicable
Message-ID: <ZIl08oBdRZa3RG10@corigine.com>
References: <20230613113552.336520-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613113552.336520-1-maciej.fijalkowski@intel.com>
X-ClientProxiedBy: AM3PR04CA0149.eurprd04.prod.outlook.com (2603:10a6:207::33)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ2PR13MB6451:EE_
X-MS-Office365-Filtering-Correlation-Id: b4229877-70a3-43d5-3bb2-08db6cae3a9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8v07DZz3oEtc4a9t/67hA7HMT+Bto0gu/ppnpF31lDo6M99avqHTgPQboJhReqpsBKEaIZ7G/Knl2+sz+XvNPnkutny34Xzq/aCYXb28rXiJEpctAhiXyXjwE83VkNC6Z1dnWN9r8jtGK128IXiwjfStuo0KTSSSeqhZVa9JhhlGqyvR07JOURh+mNVOk8ernZ9+SY1CoyMeWQ2vjqlLvozaC209+wh4shldv9aWDFbcjgsreTcBD0/r3dAtgvNOyFXIi699xlJhENb2EtMKFVoFI3aSxBg+KiT0+IzvwHSplh8m5jOI918jHb+Fsv+8S0HPnhq19Wku930x7iF3R2dMp8iDqD9Ol+Owv3/SkI23Yuimi9MuYH06B7BHisvk4pthgQSCKH+i+NbzC/u26wTKWVqhIxNaJMlaAKrm2+JwLM0jk/iRpVEUEQJpu0ipIZG6UMgE5iZa02meOF8fCwwcbgjt5aRs3OLEPKAAWDztitx150q8DXw4B9YQneYLPQoRRloIhDl1ix4JVZXX+pUtdQ8UbNQ5shc2QnuQbCBXZnNuBxFW38lE7ny+Uuxg
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39840400004)(346002)(136003)(366004)(451199021)(5660300002)(8676002)(8936002)(2906002)(4744005)(66946007)(66476007)(66556008)(44832011)(6666004)(6486002)(4326008)(186003)(6506007)(41300700001)(6512007)(6916009)(316002)(2616005)(478600001)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dVoNJkTNb1LYlSnYWt/sUNkkXxNV4FPUX29bf7s+LhHgXrqrcf4FncZPi31F?=
 =?us-ascii?Q?58K6e4RAaeDr7Svq62e3MLF2XfH2gMdkZOxWMInKpFlB2OupxvEyOR8+LFhU?=
 =?us-ascii?Q?4cdCb7gl3ncdzCJSEa1nZ55QmVTSbaNfRlkwODHN3ofZ7+SfPaKBUVPLCx4T?=
 =?us-ascii?Q?DvwrFW83ebGlfy2EFaWlohOu5WBNlITU+p7JpA0BqiFKo22FLQDTP37yNRxu?=
 =?us-ascii?Q?mC++O/ZhRCDKP0WxOoRA0MlFzteSVkGy5RaXJuqsOB+JfHm3qTn6pGbcHhgv?=
 =?us-ascii?Q?wXM0Oy7dgMmGt7Vteg5HukJd4uH3RkNvhleED1j//hFMIc0CTxurx24Vbq9d?=
 =?us-ascii?Q?LFqM/1fSvkHifHkzSxrlvzShkx23ORILsqTSoJ2UFgSDrVO68jy7JhTziwXT?=
 =?us-ascii?Q?yYv8mcv6x91PhvoEAW3LUJZYLLaSb9enpgblmeN1NSA0B+oTv8+TXER85pLB?=
 =?us-ascii?Q?GjLCXQkEviIgaBCbivtIs5b5LdnOxruUBSWJ5tyysh8tCdmhXKiM5RnS0bNF?=
 =?us-ascii?Q?JHNg0RRFRF3CJ7Vg3H9WLL2ppa74mWGQIfRUPbBdaO23BXc/b/aHYMP6oK97?=
 =?us-ascii?Q?khm92dkCUU75wwoeF7iLiVLvQCYgFGdMefXFsaA0kuaYVwD3k4EGk5OhCp3N?=
 =?us-ascii?Q?IJtluVW3V/uRkcvfJsMfztlQjKV8BtMZb0VBr1BUZWreU2r8BlxM5CC6QTtd?=
 =?us-ascii?Q?PTLvpwxMLCpwDr133gGVbMsL5vA2cYpXZzA01ciNdVXvg7Y5/HBfKAHQ3pzy?=
 =?us-ascii?Q?PpY89HXRfy/0XAVopu9T1wPKVv4lsYc8sz9f41AmYvK+Dw89ObX9xrA96A7Q?=
 =?us-ascii?Q?UFEEpxrRJ14HkWecL4GesN8nrRIylmEUBgMXHFkZMiASHpMaxjaO3Zk11Wks?=
 =?us-ascii?Q?FhHa2viE7wZIr6IsV548vJ7t7tyT3ITRlpgsoPauNkZcB1GBtcE5SjXXj5H2?=
 =?us-ascii?Q?xVfwovCoJ74NKfwl877xST3LXfPSsQbCP+9olY3mi1ahSffBQa8NbylcBVk7?=
 =?us-ascii?Q?590s8dRfqrIf91DyjTglmD/3LyxYSWzP6DLAswbYiBdE7qagF3ZYFiGPaM/S?=
 =?us-ascii?Q?1qq9frDXJHDaMYYvSJk2h5DR+pNs+anSEEMy3KCm/q3oK+I9oDREs+VmZ6ZA?=
 =?us-ascii?Q?gizVceW8a4Z+liJ61s5kXc0u9euJzIil72k0j4LxotKEHKQQn9g44tnLoTEF?=
 =?us-ascii?Q?2M4evDH1Erb6CUxasgmkVZEAd21f35X1OCVFVN1MffY6PP31IrKe3zUGWpUy?=
 =?us-ascii?Q?qgPk1teTNtivJQGhNEJ3V9Dwwl8rGXjUiyj4sHSVY3mv5UgVYMyDSwcNmKOO?=
 =?us-ascii?Q?xuQJaKz/NuNbLVGkRM+xnftaz1sWP49l0aBywHJ7qscOgzB4nFuZwey9Sok4?=
 =?us-ascii?Q?vy54v7/xOtA7aehsot8RtYoaN8tT0yP3p/YbK22vrvrhDMEFwYvpeiFkt0sS?=
 =?us-ascii?Q?kTBd1ljst6Ba1zmgtfeGnR7Ee2XQFgeBfB2FoBTdmx8Z4sHlsQlSy76IS59i?=
 =?us-ascii?Q?pHvlMi0Ua4mmJ7wePvCrz3hTNTfOppOLokNQgKoD6mVfn5+oYZZJ5HblYZea?=
 =?us-ascii?Q?Al9XnSRwjUKSgeKs5bFFzfboozNMexmoEVxwcf1X2ujoXaAfYY4Am28tZHvk?=
 =?us-ascii?Q?A8wcbxKrgL0vDzgkPSs3pe++VNCcEDu6LvYWV3JGtAhXEoFRes6y6BCoc588?=
 =?us-ascii?Q?NlziJQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4229877-70a3-43d5-3bb2-08db6cae3a9a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 08:06:16.7310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ThuV+AsHN7+db51kKYNzoJ8YMIUyBIojLxt0npyOXDvCx0tyED6t6nT1lu+jWraPrqCZFrktzXS7YNrzpWVu+rdlRnOXSc72TOxWfFlHKbU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR13MB6451
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 01:35:52PM +0200, Maciej Fijalkowski wrote:
> ice_change_mtu() is currently using a separate ice_down() and ice_up()
> calls to reflect changed MTU. ice_down_up() serves this purpose, so do
> the refactoring here.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


