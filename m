Return-Path: <netdev+bounces-8886-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47BFA7262FB
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:38:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0239428126B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:38:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D794414ABD;
	Wed,  7 Jun 2023 14:38:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65768C1D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:38:25 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8496419BA
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:38:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRl8C6RaST5i1OkIiBiO9ytfhQf9G+pRlbol74PWNL6wadA1Kvj0wBAaZ/V8nNAeGSxxkuTCaIe6VFMmjjgpRM0z4wpApcigrRNxBZ6dyzVIEfNuC+p1yy8AysPDons3KyBbRi4JhFx7bos51kqQXH36BPD5qiDS/IPasnIhPoTMlJJPJQ5pgdGtdTrkVqF4qHefHSqhLgGbyBU6jTZ/FB+RDFYzr/wAGfL53hw7v6/5UVFz1EhYghaYUOhOI0rQL+jGS8CZq+4cI9ihQgWItr4TupkcU3TgmM/EDGxK5e7iaWV4aOhcy6xKxOKPvXBkTV5vu2njY7E9RP/Wt5Z7VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oEJidJKuU0tIglLLpSPpPlZ1B24p5l/RFenWJpU2M3o=;
 b=UHyBHE2p1VqF49TTt9+G6oH1BweX5hjiUMMfE6cFORA6rwCB+oSzSubI/IFCAlOYEoG+gGGTfGMqu5bv3Tzfnw13Pbxp0bnQhXJ2Qh3d8VosHdPeV3fk8M+p4diAsF2aOIiPmJZmqM4w/4JLogr4XBpQEekKBpoDWvMrgsoihn8PGUEXJu/EOYCvG1A82++Vk5MUVDXgmnsG6+jzaFfmpTVnPZgqBTei5ybqu9GLiv8ciXMYxF6ZtLLo8O+LjPENkVEXUXGYVtiSEFIMZPEYgr/ACszb4LWGoF9QGGk3tvJKNxhJEFq8Revecf5XOTHEHp1NB9GDpcNtwi8Yag2RIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oEJidJKuU0tIglLLpSPpPlZ1B24p5l/RFenWJpU2M3o=;
 b=S5s9fgaRDW1TjxZDG7+cDzautRbxuv+d2muoi3XxMV7QkTK36YswJ03WLKgE4OFTWcBCRrx9wl+n3mnORxoKKHfFxYF4CkIrOnF+q57q4dmV/18ViZAcvOG4KVcoC/mob5A8BbQhE6nIVH3I80miWyIiScnPGS1upJu43NWGt3s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by PH0PR13MB5330.namprd13.prod.outlook.com (2603:10b6:510:f9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 14:38:22 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e%7]) with mapi id 15.20.6455.037; Wed, 7 Jun 2023
 14:38:22 +0000
Date: Wed, 7 Jun 2023 16:38:14 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Madalin Bucur <madalin.bucur@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sean Anderson <sean.anderson@seco.com>, netdev@vger.kernel.org,
	kernel@pengutronix.de, Madalin Bucur <madalin.bucur@oss.nxp.com>,
	Michal Kubiak <michal.kubiak@intel.com>
Subject: Re: [PATCH net-next v2 4/8] net: fman: Convert to platform remove
 callback returning void
Message-ID: <ZICWVika1vsWdJCY@corigine.com>
References: <20230606162829.166226-1-u.kleine-koenig@pengutronix.de>
 <20230606162829.166226-5-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230606162829.166226-5-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: AS4PR09CA0003.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::6) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|PH0PR13MB5330:EE_
X-MS-Office365-Filtering-Correlation-Id: a242d262-3708-4207-933f-08db6764d824
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Ic4cZxafbNp7LA0Ils0KPCSprcenaJ6073TP7sTulhVyZVed2me9g55eE6CVkY2KfAqmW89KCYtRQo87YNlYgkliQUCaEMV9c+8a0eI6tl4nItjh4+SGJy1BFJhmIJ1RmjxpzwbowvIII1Bp33GUeH/WoFmy0bPu7Ojs95Vr/tM/ESQ4VL/++UMATzlmj69XYfrhQOTZ09a8JIv08+XP7sckjXo5HQ9K+fP1yzjvCY2TBEazjIHWI1W6sGgylBDmdyP6dn5rKBRchPYIE4l9DihocXECmiUfe8s3cnPFB2IMznsA5VCepH6e/6q+EsOqYPHNfd+TZbgBC//GI+aI+OiXBe8T/y0Qihv5vmwRBaZu24gSUxN6IVkweYp/RfOOy4nvEn9yS3/olp8X3Mo2jmBeo6PLjbXYnpEDg4EgXkvtrI0uhRi0JLi3aZtuIhdwD6F8ze7+5n7esGc0Dt40DkH1nHBtdkxlo4iRmh6lcgpJUMUUODQ1lWeHjk6L/V1lCJysJrpgrmGavUDZEmzm5/1bAfegFstqHSHZW+dMWPxSFwGZDz3WJansID3EVUdQrx14bxgcStI3JSaKXIgNzmhTVJjxNCsmWI8v1rINUv8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(376002)(39840400004)(346002)(396003)(451199021)(38100700002)(6512007)(6506007)(36756003)(86362001)(2616005)(186003)(54906003)(5660300002)(7416002)(44832011)(2906002)(4744005)(316002)(478600001)(41300700001)(8936002)(66946007)(6916009)(66476007)(66556008)(8676002)(4326008)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZXpRaHJ2Zk1hUTg3YkdVUlMwbWJUQUtOd1o4SGx0NGtDUFQxY3orY3kzdDRP?=
 =?utf-8?B?U0l2aVdQQUVqTGt1M3ZyRlpEdFU1NlFIVWdDOUNyQmxvRGZ0NTdFNnFTY3F5?=
 =?utf-8?B?UTZQTEgxWWFjeW1PeW5RTXh4OHNBZVFqNHlCVlhjbnFGUVhkWldWeW9LOThQ?=
 =?utf-8?B?V2w5ZjVDWU1rSEdwK1VpRndrMWdjTFA1cUhtWXdJVGlad05PSXFPeHF2QVh6?=
 =?utf-8?B?OFVzZHZacks4dDQrYzlsT29QcnF0NTZiVzEwV3pXUFpRMW9kYUhaNWhVZnEx?=
 =?utf-8?B?Q3FUVjNrbzIrNldnNHp2TXJIOGdPUkJLbmF3eVZXbk9Mci9MeGVMSWg1VU1M?=
 =?utf-8?B?cm5RMkRFTjZDVVN1b29tRUhaV21lWWt5SjVEalZ3T0U2eWFIaGtKb08yR09t?=
 =?utf-8?B?QldES2NFUTZQNm5pR0NqL3BCMmNaeFNNVTdFYzJYYk1pb0IrZDc1ZDJQanlZ?=
 =?utf-8?B?RVFWVGtDUE5ZUlkzY2RROU5Ha3VtTmRyRFptQWZEeTdGOWFSUUlid0thcTcw?=
 =?utf-8?B?S0ZEQjh6bzIrSlJmYXZWOEZjUDE1ZG9LRTV0NVYxcXVDVVEvS2cwNFE5SWk1?=
 =?utf-8?B?MHdFS09EQyt2K05RT1JoMFBNNGR3aXBVODhHOWZ2NzBRVStoR3dERVNHRnF5?=
 =?utf-8?B?WGRTVWQrQTE5V3N0M3hwWTl3b0swRDdFRERvQW5Edk1qdFdmSkNFK3RTSEVT?=
 =?utf-8?B?SnMrVmRZblpBQlJ3SzQ3RitqL0haOVpOeGtzK2tJaGVXQWJ6cGhxVmFQZWhD?=
 =?utf-8?B?SFdLREFJdS9TZjJ5SWMzQVh4eEQwR3RYMzBRN1J2QnJFNVFoczdnY0RRd0Rz?=
 =?utf-8?B?NVU5a1V1cmVoeXpwYVNhRk9iZ2JiMDEvNG04S01vdDBodE50YWNNR2ZqNUZ0?=
 =?utf-8?B?dWl0QnlHbGoycFJiTit0cmxLbTBHZ0crMmFrNkZhaDRqb1QzOHgrQ3BqeC9G?=
 =?utf-8?B?YWFwM0p4Skc5cHVhdGFMQmRsN2pwNllOS1d6akU0REJWUzQ1K0hhaTN4WmpX?=
 =?utf-8?B?UzByOGZPdURqMU9EV3BUWmtlWjFjTzFrbXFqV0tiUElZcDNVTG5nbkFkYXpW?=
 =?utf-8?B?M2tsdnhCSGFodWptVUZRM3BhZnl5OU1EMzlBVDFJL05aZXBiOEZCanBLcWZW?=
 =?utf-8?B?UkZKSllBYUM3OUxiQ1VHbHdrYUR2RUNCMHc4OU1xMHNDeVdRRmxZTHpjVTF3?=
 =?utf-8?B?K3Z1VUpQS2FiRWNvd0lsMHV2aDc0c1ZyTFdpa2lNS2QzdmQwNVAvVVBEcFFo?=
 =?utf-8?B?U1BGNmxlbU9KZzJqblBudFZyNkx3amRXV2ZLRWZIOUtNWXJIZWFMY2JYY2N5?=
 =?utf-8?B?YTRIckduekU2SzZ2dkpWemNrZFYrK084U2EvNEhaRDBTUkFuaVpBSm5GcWxF?=
 =?utf-8?B?c1gwUGU5OXhPYTQ5bnJPdmpNZGJVUnNxaitKc3RiSnppczRzL0VhaUVjSlpU?=
 =?utf-8?B?TnNIVnMxeTdJY3NpSTB5MXJ4UmZEeHVhK0I5RWtMMG5sQXhlZVR0M2tZaEpt?=
 =?utf-8?B?V1VSaWszMzdKUDNuVkMwL3hNSFZUUlQ5WkRjQ0dtMVlhMUVkZktuM0d6ampa?=
 =?utf-8?B?SlRjd2t6dkVrRU1lNm5yOEVLZGFvci9aa0xTdHVHcUNGdXJXeTVkMFFJOWlR?=
 =?utf-8?B?SVp2R2dTYi9hejNMN2FrUFZXa1JBOVcvZ2VvT0kwcmNpNmV2SXEwQzJHdk01?=
 =?utf-8?B?UnllV0EvTXQxN3NqMmtqOVg0Yk0xaU5QbWU3UW00WEliS01yN282bFIvVmJy?=
 =?utf-8?B?bkdhakJOS2QyUUJHOHJTNkV4QjJhNDJBZFRQdFd3MEZRUjdhaVNMVkYyQlNn?=
 =?utf-8?B?Mnh2Rm9RRnc4QTBJUGFaREJOa2RUUFhBMUJ5R0RGV0VWVTJueVhHa3MvM3Ex?=
 =?utf-8?B?dmc1bi95dDQrbU9ybHM5YllvQTRxUXhxVTErYjZmRjNLVEpFU25JV3o5aWVm?=
 =?utf-8?B?dTVRVEo2YmRjSGdvdXUyV25wZGVCamVrTjE3Ri9zYk84dFc3OXpFd0psczA3?=
 =?utf-8?B?MkFhdmI0WWRCSzdUL3piTEFMOFI0QjVWRGpRblIyL0xJR2hEQjNCZlg0QzFs?=
 =?utf-8?B?SUhNWmVQQzE1S2RMakpERGNZbDU1Qldmc0Y2Uk9Id1F5M29zSEZ2MDlGQXkx?=
 =?utf-8?B?Z0dzTGJvdXlMNTEvK2wzQmdlbTZtNGxSRHM4TkpvSzBreFdrdzNsckJjZVNi?=
 =?utf-8?B?TmVpZzBPczQ5UzNsdjM5Tkw5aGw5T2RQdDVFbmR0L0Q1Y0doQUt0V3lDelp5?=
 =?utf-8?B?OSsyRnZZVVVHaVY4d1BNczBDMUtRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a242d262-3708-4207-933f-08db6764d824
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 14:38:22.5194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GML3GkMTHQ5L9c63C3Fr5jKwUhtxKpIyPWHbpfq35/D81fzE4aSDOJ0geDCO6o67b7n93vx136Ekf4Xw+UHtXHU3n2d0L2yibxSUjgcqOZo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5330
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 06:28:25PM +0200, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


