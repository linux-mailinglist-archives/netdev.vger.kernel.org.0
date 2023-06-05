Return-Path: <netdev+bounces-8016-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D33827226CB
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:04:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DC1F2811F8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:04:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4861952D;
	Mon,  5 Jun 2023 13:04:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3F46D3F
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:04:47 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2115.outbound.protection.outlook.com [40.107.223.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E55A6
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:04:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgBfptj+0klm4eZXy8Qxbmi78jt9s6DdxBGLBfWkMQdiU1vkvlUEiEk6UR5mOTuSOyC8/LcAuWov4Kgn5CfVc0nmCGgriQKxiM6F+ZynldTNNek4+JBKkfuEExVLdTvb1Tk+zV6km5/34hp2TkUIcRIQompt7Ox73NFBzTSUOXzBfy3ns/gHlQw04UNIQTy8utxkY1e+Cwfn4eogPJh+8ozmac5CJSA5YcHPbzLwkpNsfTsoyShFaOuet8A5L4hmwJ3vngNZiBXHhXuNaFKrheKdKXTUv5H/pK59FvSe89DCtu1xlP5ovmdsGJuTl3C7hfm1UaZ31gd5slMIj1V/wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=erE4CjnL4KsU3OVQHBxWtxgN05MluxldV1OaxWxM+Gw=;
 b=ApxtPwBHyHkTqrdUNXpziBEPc8PbVnmvsGeRwRoVQjofeMmNaSe3x3riXVa0vmSdTbypUiW/wQ9ZLkMAGL90Jc84AxOVQHvFIxS+iMXMvMiU5kBhXm5ZnvWod3sEmKmZmIxxhl3zAuueiC1wGiPIXr++Do0BvB0wZ8yQA2s2yl4VChKncbez1pmQfayMFnsqpcEfKfNrHsaezEDFwqTeDjenp5JSvzhSKJre9uBxihOQS2PZ7HR3XPebCdttbm1nrAmsJDAw8KrIndr0ykKjxFuoLCL79Jm3wP7jNZavE9qEPfhqtFpIlD27pq4LB/2spwb4fiRhoXbVDrA38JDiOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=erE4CjnL4KsU3OVQHBxWtxgN05MluxldV1OaxWxM+Gw=;
 b=BXSoHAS3/Ybh9WE4WELpDZS2JAyhetijsBhYyTmW+dZ86423ikpQJYW6jhVhkuMs0fGy/eVKD0CivJyaSGchqpru+EdgPSWTrx1bLgDMpfy8U85sEBPHoujauevDfHv+SEuAuH4VNkixwkWLDw2MOY25ClgLOO9c3sHg6HNVEmI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4491.namprd13.prod.outlook.com (2603:10b6:610:62::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 13:04:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 13:04:31 +0000
Date: Mon, 5 Jun 2023 15:04:25 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	Linux Network Development Mailing List <netdev@vger.kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Benedict Wong <benedictwong@google.com>,
	Yan Yan <evitayan@google.com>
Subject: Re: [PATCH v2] xfrm: fix inbound ipv4/udp/esp packets to UDPv6
 dualstack sockets
Message-ID: <ZH3dWcEqlEy5twJC@corigine.com>
References: <20221026083203.2214468-1-zenczykowski@gmail.com>
 <20230605110654.809655-1-maze@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230605110654.809655-1-maze@google.com>
X-ClientProxiedBy: AM3PR07CA0053.eurprd07.prod.outlook.com
 (2603:10a6:207:4::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4491:EE_
X-MS-Office365-Filtering-Correlation-Id: d0ac9afc-e706-4cfa-4182-08db65c5670a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mW56Hr4Q3ElXZPKuxAV/bMPtGjZ04tPdeX2VEfPs1tOVKND7Z6CrEWnqIJbYSAiLlqefeQnygiApBqAqL7966QfN5QGAyo9sDH3sKWbJUpErhIKMCqvN6h1rrjGctzr1txQbIWOlfS53SugUXPu2kkT8vC1h5IEqnOVEBzMIiIXPydJyV0lJzVdkBKsIedyveIe8fC6O+4mb8o9wLyS35QAflZmhtvTta1S3gU+EnSwJCqhAj18D9a2Ih2PSElKChihYY/cITKwKjs+sI0opd901VzYKPBkXe6Pj/LIS+PHw4bg++z9x6DFlvlhOARkIqp5hpbTb+UwfCVzOMCXc453tGBqt14d56A3+PXWpjSaB9FznSCxdyAiyqn6MmSwyRdiet2sx7EvRJJv0BU9zHd7lj9SwlnplU7hl3uCt0PG270Twag6Dk/5t20DMpA05wPm2xOUttkAQUsxhQRfdLawkhzUIf8VWWS+B4U88fk/7kh2+8qI99uEhTL2kdZu+eROEPPUNlVoT+5Um8aWbbomZMRiqxRJWIj6f5iL8560NvyworHxKPFW6b9NLTt39
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(346002)(376002)(136003)(396003)(451199021)(54906003)(478600001)(6916009)(8936002)(8676002)(4326008)(66946007)(66556008)(66476007)(316002)(38100700002)(41300700001)(2616005)(186003)(6666004)(6486002)(6512007)(6506007)(86362001)(44832011)(5660300002)(2906002)(4744005)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3JaaVVqeGpCRmRIaHB2QTNIKzhEd0JYUlVEWFBHYU5PaDVJaTE3a0JPUEgz?=
 =?utf-8?B?WkdPdjl6dlRTWXNhbWRLcE4ybEdXWVJULytuT2N5cTlTVWZ3N2toUG9yVTJH?=
 =?utf-8?B?MDdCM1dJYW83VlBHZzdFVDhOTTBTbzJtdnBEbDhSUUl0Mzg0TUpHaVBRcjNy?=
 =?utf-8?B?TVZaWndTejVUVDc0c0wrTnBRT1RqRzFTaHNiSWhQTnp5T1hZYnZhTkVtWmZU?=
 =?utf-8?B?WjZ3eGhtT3FjUGpqYWhqbVV0cXpDMTl4c0o5dGU2ci9ZcE53Z29WTG9GczNU?=
 =?utf-8?B?R2MzVXJSNUY3czdkT1hzektQVnhhQTZ4RjZRS2VzOWpIY1VNUkNDKzc2OVRl?=
 =?utf-8?B?WkIwYmJoNGY0M2Y2OFlxT2JkZ2w1SEFDaUQ2SUN4L2hwMlUzSk1hTG9nK0pH?=
 =?utf-8?B?RVp5QXpDUGJYb0NMMjdBTy9iYjBYc1o3U0hYNzhLWGNOSnNtd0t2akFCTWor?=
 =?utf-8?B?OU9Vdm05c3BnMjg2U05oa282WXZvOE0wVGVqY1M3Uk80UEVaL1I0UEtyRXFQ?=
 =?utf-8?B?TXNIQk1zS0dITHBYb1NnUUROb09qczVQdWdkY0VhamJob2lHS3c5MjhvWmdk?=
 =?utf-8?B?RzhzQUVnZ1UvYXhjTktsZHBjWE5hOTljU1U1NytwUnFqTm5kYWdDWnBFUTdR?=
 =?utf-8?B?ZW56R1Zkd29KNHlJVkw5d00xL0xJLytxZEpCL0tJa3oyY2ZDb1JBRDJqbWVX?=
 =?utf-8?B?K1BZNFZBZkZYY1hXRjA0TFRPd2VLSFdMbUJSZzdPRHRmTS9aZEVDcUE2d2dP?=
 =?utf-8?B?b2M1NDJwZ0JmREl6VUxMSHlMZmpUNGZzLytyTkV5NVRNeW9YaVRPM3JGL1RC?=
 =?utf-8?B?dnVXZ0UvM1N0bkdvMmN2ZGt2dWdvaUhvd1pFYVhkRDRGTExpVkUzWmhmVkdv?=
 =?utf-8?B?aWNnbnhGeTYrNkpycmxHNVVFbnpwcUFma3A0Nm5lcGJNNWRwemRLWnRNT1hK?=
 =?utf-8?B?MFJpM2pKNDJnd3JacHdxRTJxNjl4L3U4a2hKVk5WM0RFQmNkTTFHWGlITDEz?=
 =?utf-8?B?dSt3Q3RENFBvRmNzOGJ2d1RrRjQwVkVQRVkvQjdtSVRFODRLeDh3aFF0Vm9N?=
 =?utf-8?B?cWd1YXd2M0NvNU5nS3dYNXFwbjdYekpqd0NYZ2ZodEJ4bUJiZHJIeWk0TEhY?=
 =?utf-8?B?aE9HYVNMaktUaDhVZHBzbVh2VVd2RHZVT1IrcW50QlREbTY1MTExNkJ0WDZR?=
 =?utf-8?B?UzU4bjByQWN1NzlnMGpleDFtSWFIcTNVdzlDWkFPeDQwdisybFVVQU8wMHVn?=
 =?utf-8?B?U3FXNmtzenZmTWdYWmZFZjg0YVdIMjY5UEZWakVUY2xjb2paMGNETXhmTXo3?=
 =?utf-8?B?eGZYb2wrTVVab1hkNnNObmRyMGNKYytqdmdzSERHYlhXd255cGNZVVlldTIr?=
 =?utf-8?B?eTBkVi9RaXEwbDNRd3dsWVBvSVRxTk50dmZWbFkrcUdheEpWYWFLZnVEUUs2?=
 =?utf-8?B?Z014Vm1nWmlWK2l2OTRKdnRBbWtKSEJpRTJoK1VhU2JmejJxZ0VLR0pUejFD?=
 =?utf-8?B?WUFKRmJyWkRNejREbHRoMkZVOUlnRERmd21jdnBrMFUyZDBhaHVnNGtKdzJR?=
 =?utf-8?B?YUs1QlhtU3VmVHBCNDVKajVCdDlMdm1ZVDVXcUVINmIvMXAyYnV3bnRwb2xh?=
 =?utf-8?B?QWRFa2RmUWlCdWdXbVpGSnBEMWxnMWV4MlFGTDlXTGJ2WDB5TjRNS0ZjSnRm?=
 =?utf-8?B?RTJraGpLYjZnaEcySTVUMXJ0eXIwTkphSGhsRVJlclFWNUkrVUthWkZkZ1Q0?=
 =?utf-8?B?OFZhTUJrZm1zTDEwcTN5Q1NSN2RpWGM4YVJYd29UemJQWlFhVFByUG5yb3Rp?=
 =?utf-8?B?b2ZRcE85SGR6NjVKZGRKb29lWEZTb3ZBSjNhV2tEMHY4K0EwU3hxRVpOUnNP?=
 =?utf-8?B?WGd1MjJNL2NpT2dHTjRwbFlEbE9oNUxBUFM0ZEFWaHFhLzlxdEVwNjMvOThX?=
 =?utf-8?B?WjNCUElqWmhpYzVzWDg3b0trZFJWS1FLNkZNaG9RRGN1ZzVkRmNtd3BzOVY0?=
 =?utf-8?B?RWZkRDN4di9lR0F2WlA1dTlLdVVEM25Ed0FLSU1PUXJkNG9FUkpNU3pLU1hh?=
 =?utf-8?B?WTk1b1ZXSGVRSFZvV2RpbVNmRkRNOVJMSzBoL3RQME45VS93VmRsVkROa204?=
 =?utf-8?B?aFhEOUNocGwybklpOHVkRVhDSFEraWdZb3dmYUxKUWdKTnRMRXNsWEhZbGEy?=
 =?utf-8?B?VU92clFjdnl4RkNGSWpobTJETEduc1VhY0paQ0NzVHNXVG50dTJQbWVIK0Nq?=
 =?utf-8?B?VVVieDR0eG9sdmZKYUk2cnZRWU9BPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0ac9afc-e706-4cfa-4182-08db65c5670a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 13:04:31.5887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MjDka4+3gSq8sVMzui0ojLiLJGDPt1SZNpLaDi2VbFxAlBWU9pPlLhn3RJsaATnIGxwejA7063Eri+GIPijdXhxuJV7xXG6rxos+9Czv8y8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4491
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 04:06:54AM -0700, Maciej Żenczykowski wrote:
> Before Linux v5.8 an AF_INET6 SOCK_DGRAM (udp/udplite) socket
> with SOL_UDP, UDP_ENCAP, UDP_ENCAP_ESPINUDP{,_NON_IKE} enabled
> would just unconditionally use xfrm4_udp_encap_rcv(), afterwards
> such a socket would use the newly added xfrm6_udp_encap_rcv()
> which only handles IPv6 packets.
> 
> Cc: Sabrina Dubroca <sd@queasysnail.net>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Benedict Wong <benedictwong@google.com>
> Cc: Yan Yan <evitayan@google.com>
> Fixes: 0146dca70b87 ('xfrm: add support for UDPv6 encapsulation of ESP')

Nit, which can possibly fixed without reposting. This should probably be:

Fixes: 0146dca70b87 ("xfrm: add support for UDPv6 encapsulation of ESP")

