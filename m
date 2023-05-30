Return-Path: <netdev+bounces-6350-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3515E715D9B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:43:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB3231C20C02
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534AA17FFF;
	Tue, 30 May 2023 11:43:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4158917FE6
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:43:13 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2126.outbound.protection.outlook.com [40.107.92.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E19712B;
	Tue, 30 May 2023 04:42:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+NoS2WaN1N1QXSJ/4ubu9dBnzxevFSpD8kfmHEK7FTp7oxTgd/1NXEvoJZgiZda2LiuOis+G6Iz7ORJHcfLHuF71GAJ7+ua7BOKwc7JaUOnsSEtblSTA9+X0hjO8sbzI/EzXbdBmzoj+u9wotEjJHw5wAedBbAEVQexlSyAxuMrmCHTwdzjHwt9atq6nPMzCI9y7UOvvlPqxKb77MaPkgB4IdwSnlg8KcbpkVu5nn7v5SoOCKZsmr0umk0LB4nudbQTeM2XtQLlmlqhth96gTxgJwZr9DG6OuLgIvM4fY3RVIS/HMJlrSnAEpj7UnenC63/y5X9UmmZRmiEWHRuMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hg8vlVMUSwPX2shJDEAwoMsglbM1xXshnFwJuaLQUKI=;
 b=fwaC35Xn95lcimdloOny20qgfJoaX8XRzN8YOKl70fa56KzKlOms719gnV+Z00VW735SLyMUkdjELmUpStv1sVT5io1b09gaKMEXpCnUH2X0MDKYNC4lN+mJYtPoOp2kfUGTrFmKUKDZuJxX5i+X/pr/qzzN9n6F77qo9HHdGuc8If50e12lAYS/YhRVrReNLj2vO5XQus7NkHdUYxlBvDkiQO0BMopK0DUsLEHkxGRoaXrak5WXrAbWmaI2jFxDrj6tQwaEoxdjxUpwlPDcDE2hqjAT6s+FQotBq+WlYx5ZSeEuQ9cFEu50Y2E7jfJOqPlitS0EJEClyBjvc3HTeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hg8vlVMUSwPX2shJDEAwoMsglbM1xXshnFwJuaLQUKI=;
 b=L+zcAFw9xA+npDLHOxhzoSprV6I+cCBLrdY4eGxIEB7OFZXqkf87YISu7yhJUPFPVKfGz4KTK979l4NFs0GglLzZe17ByZ1lt17NTN7jzBklaPOFtaxnbo+79s9nASg0JR8cOWEt8VpvK7uwlWlKno0m/ldkWFtwb0YMReypyOk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5711.namprd13.prod.outlook.com (2603:10b6:806:1ef::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 11:42:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 11:42:49 +0000
Date: Tue, 30 May 2023 13:42:44 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH net] net: renesas: rswitch: Fix return value in error
 path of xmit
Message-ID: <ZHXhNH64lel+h/+R@corigine.com>
References: <20230529073817.1145208-1-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230529073817.1145208-1-yoshihiro.shimoda.uh@renesas.com>
X-ClientProxiedBy: AM4PR0202CA0009.eurprd02.prod.outlook.com
 (2603:10a6:200:89::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5711:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d58d7f2-157a-474e-f7ef-08db6102fec1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tvfcDUh5e46NYM25SBX2WxZzUiWSCbRfOeLxdsuR8soGditYOHe1bIzK9h4FZoMHXyGnZaXsW7VFjIZeeeZXdu576RFqdIm2/5LRyrH7aknxVD+pJJFLNiP8IWodpPYyKb5ZHkiZiU9e8cLd6Me2yN0u9ZW47bQdQ3RjD/9DB+B/yYbTlmhYv9hxZN2W+SpHy3Z8Mr3atah6XOn/NhZzJTD+tQRDixZ8YZG8ywSRPbyjrWBdfwFqZiIgHlt4Guq+ZaMHXAuegtQrPPCT/fissADxAlD94T/gTykBkT0X2QaKwKEpdYKt4nsoCP+a+Ua4nvcvjEuD7XOzKLXvy8vYZzYmkHZbtC9VTNpvyX1d3r40/hfQYL2uSRJVSnD5ufwRU9RFYGpRxd5fVZ+rQsVO4sPVTHg0HBlIml9VArF9aeekpYBDVGWtmgBSF3AWOXHNbdBkToVWpe6aY9dpuDKRfUoqQYR4DzfBkQRUuBQSK6h/oEeZoZOSFsztXQDmKmU5KHSEW6G5F5yynjUunC7x995+3xmCzdAKLzwHN+NGYU0pGGDFH/0Oi8aIk+bhHX8h
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39840400004)(366004)(346002)(136003)(451199021)(2906002)(4744005)(186003)(6512007)(6506007)(2616005)(5660300002)(8936002)(8676002)(478600001)(38100700002)(6486002)(44832011)(86362001)(41300700001)(316002)(6666004)(36756003)(66946007)(66476007)(66556008)(6916009)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDR3N1owTFA2RFBxMWZ3WDNaYTdyS0J0c0JGdlVOc0VJaXZpTHd0anZaQjZV?=
 =?utf-8?B?R1ZQWTFHTFlCY21OMTNjNm1wTlo3TmlxY1RGaWJQczVMcGhHZTBlWVRNUWdH?=
 =?utf-8?B?VTN4M1lzRDhtM01leVV5UUhoUXYvZ3FRaTNoQTgwclkwcTNVb3NLZlJkRU9Z?=
 =?utf-8?B?T3FaNUYyVU05K2FXdlAwSTVPZ0xqOEFtSVMraW84ekNSa3kvV2xKeGM2c1RM?=
 =?utf-8?B?cjBzczQxZVNrL0E1ZWlDMm1PbWYyc1JwWU1kRjFmckNTTGVDeWY5dkpQMVQ0?=
 =?utf-8?B?alhjeVpyaDFadEdoeC80cGdnMHpNeUxMQWxqWFk2Qkt3NlJQeU1DeHdHR3FG?=
 =?utf-8?B?MktLMzlFWnpRV0hIR3pnenZReTJCaU82dGlnVUJmQ0NFdmw2elA1N2RQamhO?=
 =?utf-8?B?MFgrT3hBelJuRC9nMlIyTVBQSWtmb3dMeFJsY2RKTmNTeUtDd3JyYnBrUmE1?=
 =?utf-8?B?YkRTVkNhcGh3VTU3SUFGQmZETUdXRzFMN0ZQUm11UDRiSk5YaXZVN1NKR2th?=
 =?utf-8?B?QWIvV1BwZE5qS0lVKzZxSU9GKzFoN294RG9GYXkrM1hZODFBQWNKT3BQWkJp?=
 =?utf-8?B?UnVha1FCNUMzRnJoZ2FPa3l5dE1Ta2ZsWXRxdkZZd3BsSzhwaTdzZnBSYnVI?=
 =?utf-8?B?R3hHbjh4SG4vMDNoelpzMWNqbkV1YnpZd20rbnVia05tSHFVcFZkYkV5Ry96?=
 =?utf-8?B?NXhuMGQ0SEJoeUU1djNkNnVCYm40YmlDVXhCR0FUM1RwQ2JrRktyUlBpSGlY?=
 =?utf-8?B?QXYzSk9IUXFoMmRaMkN1K2piN1FRMVlqOEdHdE1JaEc4enRZRDdLeGhMcEYx?=
 =?utf-8?B?dDlzR21WZEMrdE01dzg0eDhLQkdSek1RRC9DcjFJNmgzQzR3aEdDZmt1SWsv?=
 =?utf-8?B?QVExL2N4eGJYQmZvZHY3RVJTU2tKU3lJZEliOFk3emhmcnMxd05XSVdKREFz?=
 =?utf-8?B?ZGZ1UHF1SUxVUnpQRGU2VFNETGR0cmRmL2NEeHRZUFVIc0doamN3NlQzU0Z3?=
 =?utf-8?B?cEJGQnlLQmFiN2d3SVViK2t5Qkgza1BRWll0Z3BrWG5qWFVJYklId1dRc2U2?=
 =?utf-8?B?QUswTDl1ZmNDM2FGT1pIWkdTY2JiRnM5MndXdkFkSEkvNFRVdEV3UGgxS2Fm?=
 =?utf-8?B?ZmdDd2YrOERoek5FeXc3WThqZEltZEN3OXc2MGV1dFBMSURtaEdNbHBPZjE0?=
 =?utf-8?B?M2JFWDRycnl6Wm5oSExJbXlRcHF1cERHNm94TElxV2VJUWFxTkZ2d1RwajFQ?=
 =?utf-8?B?eGg1VGREeFRUZVNHUTlqREwwekVHNDI5a1JvSkRxWm10OWRwcHppNlUxNGgx?=
 =?utf-8?B?aEVDRHBYS3NzenJnR09tUEN3ZXBueXhucURxbDNHalVTeTFqRzhzWEhnSWhs?=
 =?utf-8?B?M3FGZ0FoUnB6N2dDMXI0cWE1eTBUVHBoNkV3Q1IrZ0Y4eEREQWZUQWJMVS9y?=
 =?utf-8?B?YUlLdXFVZGtBRFc1SlQxeHJoUXk3b3N3NW9lN0k3MjRmMDIxUkFZa2JNYk93?=
 =?utf-8?B?WlhsMFZ0bDZhaGp6LzlydjgxaFpwQ2I1RGUrZ01CRmcvenh2cERqc2R1ZWpj?=
 =?utf-8?B?Wno4WGJULzg2NGxSdlJnZ21xV3Y3WEUyVU9Vcm1NWU9uMEQ3UDFReXpXbzda?=
 =?utf-8?B?Wi9iS2tXd2V0Q0RaZWl4RzNuTm4zK2VMbmgxVmN3S0xwMElqaHlmUWhjV1RB?=
 =?utf-8?B?bkJjaEFKQm5zOW9jOG1FZ0l2U1k2ZE5FSGlSR2ZVdWtkejgrRnNVemxLWWpl?=
 =?utf-8?B?WThtNkI4U0hOOXI5UmNJaFlNelZjcjEvbTN3UWhzbC9qMmdIaDJ4TU9iTUxG?=
 =?utf-8?B?d1FlOFpVY1Npd3AvRERjUmU1UmZBUk11RHVRRVpvODg0ZWxqS2hwaHpGUXNz?=
 =?utf-8?B?Nkxmam9JOExlUWprTHozUnIwOG1IeklYb2U4eVZKUXY2dVNxOUNLcS9qTkNI?=
 =?utf-8?B?bnJMWWxya29QZ1BucUxSbjBwKzhheEs3WmtLdzZ3LzJxU2hENTMvOFQ4NDUy?=
 =?utf-8?B?dUxDNkZxN0VQTnZQa25rYisrVXpFQWsrQW16eHBRb291WDdzWE8rcHRiYnZM?=
 =?utf-8?B?K21kUmtYVEp6RXBsMGRoS0hVdWlpa3d6K00yQUl4OEplZkxTSHRhUitOZEtE?=
 =?utf-8?B?d1VIYmlKS1ZTYzhpTmxXSFp2L2l2WG1wMVRPRTFldTN6M21TVXpZRUwwVHpG?=
 =?utf-8?B?SExzaFJRcFZmTDRVL1hkMi9YZ2dMaUV5UFhmMkUraEtsd3hFc0UvZnJMWVhH?=
 =?utf-8?B?dFh3Y3h5eTBRZVFqY0J4TjBMdytnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d58d7f2-157a-474e-f7ef-08db6102fec1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 11:42:49.6369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rVdn55Y8Jndu1XNqFNuZ9ycUnr57crcEgBK7qs8peVClb3RC8sgOIiPdIPvRS4w368w2LBpw919RwhQ7aqKc2Icy02YvgmBj0xh8ASOkrIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5711
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 04:38:17PM +0900, Yoshihiro Shimoda wrote:
> Fix return value in the error path of rswitch_start_xmit(). If TX
> queues are full, this function should return NETDEV_TX_BUSY.
> 
> Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Hi Shimoda-san,

I agree that this is the correct return value for this case.
But I do wonder if, as per the documentation of ndo_start_xmit,
something should be done to avoid getting into such a situation.

 * netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb,
 *                               struct net_device *dev);
 *      Called when a packet needs to be transmitted.
 *      Returns NETDEV_TX_OK.  Can return NETDEV_TX_BUSY, but you should stop
 *      the queue before that can happen; it's for obsolete devices and weird
 *      corner cases, but the stack really does a non-trivial amount
 *      of useless work if you return NETDEV_TX_BUSY.
 *      Required; cannot be NULL.

以上

