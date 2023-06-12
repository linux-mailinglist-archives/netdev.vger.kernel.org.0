Return-Path: <netdev+bounces-10246-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A23F72D33D
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 23:26:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8DCD28107E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:26:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE7E22D6A;
	Mon, 12 Jun 2023 21:25:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DEAC8C1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 21:25:58 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBA1268D
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:25:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OhEuIEBd81rc28Tv7kMU++lsidn/B1V4UB2tXzkTpkzHRIuHMowtd22J1a0tSgqRtMxdNqhC/tjhiwIPno2bmwrpuZzULs6ilh5PHJr/keWGuI8Gsy6o9CKe4Vc4ipBesnivhilGHMFR6FS1YORk3JDFlS6gFkkEMZY3ER5bVR4PrDWg0+s+8FwOq7XzC38gXztg1u2lDOT9YHsc8MOq2r+xzOa5rPFcmh32kaeDe/2kTfD6rmyVX1hYh4ADeYpUHRmqp+fVkPecGPY27fPPrAwTLZ3tqqcWqeXozCNEN5VKWYdZ5GOz8yj3D4iscrlpZ24xG/r0vJA10YoI7wjJaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghcJnYALq3hpkQ0Pa46EwktVYNJnX7LUgGs6TWRyvr8=;
 b=hicieW4PWihoM8y/VEPMANhBMXRx01sY7XROhu+2ctlKFvA151n8Fo3VuvV11ulI6F5FkD2moDSHA26/ZvxkLF/bC7eqJKTX9NYVnIi8An52CF9PwyZtIVONPvptU9l6PRlucsC/smd8z4M6whWPBD5KFwknKD3tckWFKio59UIurvomMjzc3e0oj5imW5mJqlQwcEvKma8MZonWrGN1vX65d5DSC0jf7jWpnshG7GsSHyH+Iz+yn5TP10sI5sbjQ6W7SEERqQt+0Wsd4OZSNcYGmNFtov2FWO8jNRD65YyaU4M3J4WmC6JQ0tjIa4wCvrMVdJkapNL2c8fY022UyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghcJnYALq3hpkQ0Pa46EwktVYNJnX7LUgGs6TWRyvr8=;
 b=FDH39BA+SLSolEzftIaOwq9wXqspgGupp1jTskEkq/rPaiztuH1Y2VWiVUtCJjFXsWuAtd9ei9o0iKKH5ADpnLGrQ/1S47MRD5UJYjbYg+iAOaCVbFXL9kN5BzSYk9zD1+Q/vvz5/lQxUqog33Tj6sKxP1kixB6X03BbwO+POjrvJ2M2oISnWoq1BsIXNGDST6LPa75gdKPRkPMRHBPYaB06e9h27g8Z9nCnEJijbMcIv8/KBWfuM/fiuXdxbbbFPD0pT1aWcrE0tptWRsgphX+UWyZWJnf4OzYWugjSWM78ssP5hgKgNcaP1TQXPvmtVoOXK6uffz5hqOnlYQZCEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by CY8PR12MB8316.namprd12.prod.outlook.com (2603:10b6:930:7a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Mon, 12 Jun
 2023 21:25:52 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471%6]) with mapi id 15.20.6455.030; Mon, 12 Jun 2023
 21:25:51 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: Gal Pressman <gal@nvidia.com>,  Saeed Mahameed <saeed@kernel.org>,
  Tariq Toukan <tariqt@nvidia.com>,  Jakub Kicinski <kuba@kernel.org>,
  Richard Cochran <richardcochran@gmail.com>,  Jacob Keller
 <jacob.e.keller@intel.com>,  Paolo Abeni <pabeni@redhat.com>,  "David S.
 Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 0/9] ptp .adjphase cleanups
References: <20230612211500.309075-1-rrameshbabu@nvidia.com>
Date: Mon, 12 Jun 2023 14:25:42 -0700
In-Reply-To: <20230612211500.309075-1-rrameshbabu@nvidia.com> (Rahul
	Rameshbabu's message of "Mon, 12 Jun 2023 14:14:51 -0700")
Message-ID: <87a5x4e5k9.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::32) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|CY8PR12MB8316:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cf04fc2-7590-419e-b0cf-08db6b8b98fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fSgT4xA+DRZxCw9wh2ME9imMUJ8lCwZgV3/7O6f3Sn0GIP1R0uTh5lUMh2DLxseJr01HmWw1bYmkBM7wj4vKkG5vadu+Kw0iJxdBUEiSGL/e3OwpIBXbH3dwgvVT/o1lRVeK6LEVwleIqdF+1B4G4Xh+8Lz8mqmZf3Sietpyjuzg5n3hq2jokGhNwGvZ3wlzAD9x++eAgl8a6usLaEVDhXsCGuYMlMrKL2aKs2L49yuWFks+RfPFyhwiNymc50rdqzEBVWghTIQqBsgo9aqOFYcnFLfRP1mm0llYzgdwKY/m2/5IkbSZ3APcUARPsEGeK//EPZa5fUuzEoQp+2do2pXAXru+ppbiP0w4CPtBgIt15ypeEnDlBSaPFnBzEJtcbOFvnBKxefFIhE0mns3GP+ieW0kvgU9cNlRZ5pyzL0dkHE0gSK/xO4mqyR+BLMzSEyVwMYl3Pro5YRf6eM2Y4Y+GYN0iLlALEXqe5RF3Lp3iDcz3yNAwIEDQnUEYZwPDbb759Rm2y/yF7j6UcFQZbFe53NutFCkz3EbLrZiqz8wep+cyIOdtbFhGl5WGydVy20yXuCqSLCIs+deFUY+OHQuO0pmGqyoVfqumelLxFXy0begAgAiniD7bNlre3JxThEqJii7UhJKf2gyrK/QRkLKf6DqtsSU7/Vziuo7uIqnuqqsaZgnoggyWqH8JzRSJ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(451199021)(6486002)(6666004)(966005)(36756003)(83380400001)(38100700002)(2616005)(86362001)(6506007)(6512007)(26005)(186003)(6916009)(2906002)(5660300002)(54906003)(8676002)(8936002)(316002)(41300700001)(4326008)(66946007)(66556008)(66476007)(478600001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6VgDsBDtTHObt9nQg/avbgV6AebsT4810lEgiAIzP+YgGimxsfY4ilB/ZjKy?=
 =?us-ascii?Q?AU7Mu8wFzrbhFPWHzKRTqnJj9yhGCtPgBC2V3tLxPXjwU9jDZsjouhWlwr+l?=
 =?us-ascii?Q?yJ2YPto2qrwxUCd26yPgJBkLJPCsKoKjNgeYI+kWAlBM44ykUKqCZtHe3bhx?=
 =?us-ascii?Q?ebISxnjc3kNen9FddaPuSLYm4DANz/jHrEqzld5R3Qr3LxA0G62AUv5t2mE0?=
 =?us-ascii?Q?wY6XnrrKctxgkD6nW3rRyTtZeW+wvDJoH+pqg0sAbPapxk+3rVLlSR3oZ8BX?=
 =?us-ascii?Q?DENSurM8fbSoiM7I9xsNSlimBdsEd128yU38Tdj3pAeJ/3AXCrEoX7cUd4WT?=
 =?us-ascii?Q?rYkPbNIpfPryAg+lw3cPCFwXjl4QGYO0UaF+9HwmHy99lCTE6/cviJEQtQm7?=
 =?us-ascii?Q?EmQeZvsFWkPauGg1bKjD9lo9/6nEFHfnexvf6/KNe1aO2GAYVewBT/nYO6Gg?=
 =?us-ascii?Q?ENxC50ASFBTbeceq/VNQerDf2c/9LZccnWnO46RZ+K7hGPoQFFVjB7wtjTWk?=
 =?us-ascii?Q?mb0h9EEUywouVg0uL5GIZNYeobYEhHGKr15luHJyPxS0yoO9rAVlWrrUeg+r?=
 =?us-ascii?Q?RHFH+/ZcDfeIbidfUgx8ZOdQV/gC1wT+2IvC2FYd0K2gMzG/jAJds35Q+nKS?=
 =?us-ascii?Q?iRCbfdiD/IEdwYtMt9qHAWA97lp0ljypZ/9Xaus3/kVkAoeFgTy2zFLXKqUF?=
 =?us-ascii?Q?tRtThxOt69pxy9PmRN3CnfeFgRvTl5vniCPjd421XCZ8JSG7tBuVzANvVuW+?=
 =?us-ascii?Q?0GnarrMFSASqCdKVzlyy9AMhNN7tKnZwlThRbsxKHXfTtO/PM3f78oAJyQzg?=
 =?us-ascii?Q?17Ok7oLwAUYr/7lV6HPUM4R2n6m30oteNp/tAFnLTPq3QJPPzx8wi2PHmSS3?=
 =?us-ascii?Q?bHE24XqXESiAzJxAbKOUczrX3kbmkxDwzAfg2pOj6reQMvgIW5coQv7Uznhc?=
 =?us-ascii?Q?FopGU8SbolgkLWlwpi3hHldkI8NBCZlnUydyROOnFjxh9PG8on/QKdD7bqc+?=
 =?us-ascii?Q?82m6S5wuN4bo3a7jIbBvLPKXMYHFlqw809bNDMDRTRHhtbPl67GslQAEylqW?=
 =?us-ascii?Q?7vpq1tt7L9G/cK/2GXo93UxQvJrz2W4DtHA8bGVD/PSVyxc/sq4W8S1wcf2k?=
 =?us-ascii?Q?nmyywQQYGOyBGI+z1YIQeYc4eowa4r7RoABm5yyN4QRVSt8qZd6Tqb1xvYMj?=
 =?us-ascii?Q?PwbHypeyVzgDXpuDyDObHMjnkgKFehhWz9zF4W5+tqTnA1dtLs5b9EDlce/N?=
 =?us-ascii?Q?HubLPaKBqjuM+QPQjUAeHXXmwMDP+pQ1e6Zr50NRvVgfZ2Pu4F++wVvs/dmU?=
 =?us-ascii?Q?r9EbxfbGcrtPsje4iMNAY4KU1RXEPUI0+y3twvTZyrwMOWmyKkrGlJGw7DcG?=
 =?us-ascii?Q?fdiYNwK3SGYmo8UnT0AI9ZOCnO++FPNQWXqbYhriv8Rfq1icpZAflNKfXH9M?=
 =?us-ascii?Q?8pOonVQkMiXE9Qjg4T9yEh0tLHLJLKdabVswBFI3j6s3pnJOJhOk7G6m+vcm?=
 =?us-ascii?Q?jWqJRKnU7sKcC63jAjPhx5N4Mrg+QRiIBHJ3CMt5CBRUlWsNaCYhyiKJV4rx?=
 =?us-ascii?Q?b6w4Gphko4vu48K7/UnpYBEAsCDr1kqkKPZKaFmt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cf04fc2-7590-419e-b0cf-08db6b8b98fc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 21:25:51.5952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: obohtJigN8wY3cdneNkXtJd/xVGu8XGqoQUWRny5zZn0mPV1WFOyprESc9O6q9Zu/fx1BM9Okw1X8AQYpoucRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8316
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 12 Jun, 2023 14:14:51 -0700 Rahul Rameshbabu <rrameshbabu@nvidia.com> wrote:
> The goal of this patch series is to improve documentation of .adjphase, add
> a new callback .getmaxphase to enable advertising the max phase offset a
> device PHC can support, and support invoking .adjphase from the testptp
> kselftest.
>
> Changes:
>   v3->v2:
>     * Add information about returning -ERANGE instead of clamping
>       out-of-range offsets for driver implementations of .adjphase that
>       previously clamped out-of-range offsets.
>
>       Link: https://lore.kernel.org/netdev/13b7315446390d3a78d8f508937354f12778b68e.camel@redhat.com/
>   v2->v1:
>     * Removes arbitrary rule that the PHC servo must restore the frequency
>       to the value used in the last .adjfine call if any other PHC
>       operation is used after a .adjphase operation.
>     * Removes a macro introduced in v1 for adding PTP sysfs device
>       attribute nodes using a callback for populating the data.
>
> Link: https://lore.kernel.org/netdev/20230523205440.326934-1-rrameshbabu@nvidia.com/ 
> Link: https://lore.kernel.org/netdev/20230510205306.136766-1-rrameshbabu@nvidia.com/
> Link: https://lore.kernel.org/netdev/20230120160609.19160723@kernel.org/
>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Richard Cochran <richardcochran@gmail.com>

Sorry that this submission did not correctly target the net-next tree in
the subject. I have been submitting to other subsystems and forgot to
target the correct tree in the subject of this patch series.

-- Rahul Rameshbabu

