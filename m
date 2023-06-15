Return-Path: <netdev+bounces-11188-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1692731ED2
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 19:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C78DE1C20DFA
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A1DF2E0D3;
	Thu, 15 Jun 2023 17:19:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876F32E0C6
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 17:19:24 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2124.outbound.protection.outlook.com [40.107.94.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B307C270B
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 10:19:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epEoebpKGGfxU0MGx6HYxRlVuGXbt+lfUmRyOjwNKrsvowepSwmXr0tAQK8EoABzNmcFCWNzIBhsQ6zCJ8QD1YoI5IMnZ5k3dKU8X0uUB/6izdMk8QY1PYM6vfiqkhaHkgh4rST9lHHny86+ki8DZ+jOh3CmAOFHfWl1OBBFxl+IWOMMygRqbmtpUHKCvjXFMhGDH1greWiy6ddeT2q7SYUs5wfbYOQ2k/0k1dSPDEpgTHgK5sIkb5TW3u8xEKVuIfMRSdSqfU8zqP/RvxupplL2/zE9AqbuCoEBLxhkkOUUlLuMtsI/6cQwj+aIQpgcKZrlJ9vMelZLQvDIwmc+cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zN4ClXe8wjzoyYNLIs9u1HgfhYfBCZ6Qy8fSkb1/drQ=;
 b=RCnZUoSdfmph6Wk6hfJKzO7gujOgx3ss/Nx19CwO8ZAN9jsw7K52qCn3rHDiHeBtBxpEsvSPMgXBO8lTZI+xTR57QR4FXWLPoVSmX8Q+KYv//hHEuisTWDicCuZpaPsI93ZSW5AgRrRnUVcAPuSByBZ0ce3jQTy5K0CuqS/PrgpnKMQLrZuB+MZtsgZs1oX7HENQ4plQOTL5/00yYn0LQyr8NOrP/qpu2d/ZbF+J/qRCWtEN93+FjqaMb8XL83YUwg8puJlfVxoHMfqXaQGxDa8On7snRYLxXyNd4gZ86lfxKjxH2ZKBCp0BzkynXbOvrXX/O7yQigRg+mZlFNpO4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zN4ClXe8wjzoyYNLIs9u1HgfhYfBCZ6Qy8fSkb1/drQ=;
 b=dQqFe4xrVAj6yXnZkFqIDMnIU5JHOEzJ6J7SrCn2q6J98YiVIh1N9kjcaWSHtWBErxNznMRiEPOZv7Ty79U5uu/zu0mLzunR8OpiYr1bNwbtHGwHcZW83aSqYmyRQR9VSW6s9oATtQFdT9AMlK2nMvdjP14rAmiIMQFlqRtpUIc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA3PR13MB6420.namprd13.prod.outlook.com (2603:10b6:806:39b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.10; Thu, 15 Jun
 2023 17:19:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 17:19:19 +0000
Date: Thu, 15 Jun 2023 19:19:12 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	donald.hunter@redhat.com
Subject: Re: [RFC net-next v1] tools: ynl: Add an strace rendering mode to
 ynl-gen
Message-ID: <ZItIEFg29QA3XdUD@corigine.com>
References: <20230615151336.77589-1-donald.hunter@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615151336.77589-1-donald.hunter@gmail.com>
X-ClientProxiedBy: AM0PR01CA0142.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::47) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA3PR13MB6420:EE_
X-MS-Office365-Filtering-Correlation-Id: f707610c-97c1-4149-7db4-08db6dc4a722
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TqMDXrn9ZksqOKawHhh8+oGHG0y4SZ+DJ0cqyfvaqFD6PWfn1qK32nq74GdA+GRAnu2S61parpyMvqOd6V86eodyzna4a6Irs3JUf20F8gP9tnOF0+wtkpAfsH7/uMj33FJWC7P5kILceJLPteYP5JE67lNu1FnviHKCY7WEssoLraI65PLSnfUJrM9GKO7DGZuWE7VujuYx8IGkvQscYy7dgJwUIW8yUrvVHI1VUufGRg+ExHtuu0TPSadpR2c1g00DADmsBUZsO8Bmqc7k4EvOwvX1cmwX2soF2PoWs3rkmVt4bkVtySQ+mtHn5IDmoho8qEP6YX24iZeiiE3zcjAmf+SJEUdO1qOR050aVk/HDc2IPcB0LNOR+7wIcVudDpvnlZKWKDd7KHO/ylNN3Pk9X7yKSybF2q50/FZa85LVOc0+vEVdx8tbwGO89MSOaZ0LQ4RHTdHCyfm9MMXTH6DkImuVIjZqb3dTMcYrQwOssQMMa0axxUPYJJKK0RVUyKBb7tT4oequVAaV9sU+0I1lewzvuA0zNykKNadEsBc6LQD56Azmzb47sWgXoA2Y
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(376002)(39840400004)(451199021)(54906003)(8676002)(41300700001)(86362001)(8936002)(6486002)(6666004)(66556008)(6916009)(66946007)(66476007)(316002)(36756003)(4326008)(478600001)(6512007)(44832011)(5660300002)(966005)(83380400001)(6506007)(186003)(2906002)(38100700002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K/pbmw+b/lu2n12h+6FtU9dg4cW5AkjGW0YZIMOybLI2ONaCScDwlCCX3ou8?=
 =?us-ascii?Q?RtPdVXTQwQry80AospPUN+lAdNAmoiyhnkJVYDrCOODmZ6amduCNRP/ALASg?=
 =?us-ascii?Q?mGG+D/4releE4doQotFe7svakRmKAg5K7iM9Z7ZQwyNYsozwHrx1aTOz3hp/?=
 =?us-ascii?Q?kiqlwwGtng7D8lKJC/sx4UPqYoOAdHdbcn865crSslvpZcRvCf38vZA6jpD1?=
 =?us-ascii?Q?21CPJUOUXScf5y/LDV1b8WGu71KFNMHKlBQ2f70tOXuJXQlC9Mfz5rI56etM?=
 =?us-ascii?Q?NCG1oO1VbAjqgVZhHE+hZ6xDAtzZgc63WS1DwDq/PTMlNYMbk5FfZ1JL1Rc/?=
 =?us-ascii?Q?VD90FicZRwbZVoYJ4i9FViShFGnX2N/ujDUfDOQrtS3HFL1vx16C8LTJZiBH?=
 =?us-ascii?Q?6uV3ZfxJPEczZ2eq5mLEqyPzyV2TAeUaoivZRozY7qKMBgUyu3llK1rmzKBT?=
 =?us-ascii?Q?GCnezkdhsfpXxIy8/ygjQ+ubx63vX6ddc5tsjlJ0jT8Xua5wgiplc5OvKXoy?=
 =?us-ascii?Q?uZ7W0GEvORmkU0A0dSX2F0ZEKEPiOX/0XNsPmjZsen05mu9L2IpJtv+U1jOU?=
 =?us-ascii?Q?KFhcAXhr9fEIno9LOCe8az8OAKZB3ZVLiAvs3rgxnczL8qfPD5iEuKdU4to9?=
 =?us-ascii?Q?6GIV3+iaCHmXNeVOirFD7nF3ZrzSoLzYXNpw/EdZYHVPih9fZ1xHqV6aihez?=
 =?us-ascii?Q?KQP2OhTyhAY1OpAMx81kSyeGHl1uXULBIKn5rG46TxgcJhBWqttan50rjxu5?=
 =?us-ascii?Q?BsharQAd0La+S/Z04j8KHc3Bn/zealMUtnvgrTOoVVcmf0hCptKjZvIEUYFF?=
 =?us-ascii?Q?GIQZfit8rOzit1LOynNMx25pYsBO1j/S+FXRQc8CCC6oiWSKW2Mjc0a3BEM3?=
 =?us-ascii?Q?AtD5bRYdNme+HewhY1GrXTdQW3nzN1yTfZ2/Gfp8DgEq/UtulqhXj88ZyO3y?=
 =?us-ascii?Q?AEg+95/71k/nVZu6UKgYRhGxhjq3/3MRZVjPD9gJnqv0Mnh2tXIturxyKhk1?=
 =?us-ascii?Q?D9N1EYI7YJYqNo1jRv+AlO5VLPSWC+D21r0MjCQyYHBzxTD5AN3X6PyQS3X9?=
 =?us-ascii?Q?Jrf6reyiFXcew4iM0Pw0VQJWVj9x1XNEy5XzuAtar+LAJMQPzcksb2RUh8qD?=
 =?us-ascii?Q?GcOQolVoos90bLOcVGQYCGW9NYlH06TcnETU+Nhw0l5DUhjABvkMVzzvlnQc?=
 =?us-ascii?Q?v2u0vwh/HPjNsZ7jrxHx4xNtchIxW7HEN2lA4MJ465WNiPbaaE0X09tpCyQQ?=
 =?us-ascii?Q?YlwNCi6cmCtz0zI9ddbT/Da4K7UAqeeEqg4xtctGvd7R005aJrmU7CdrsjGY?=
 =?us-ascii?Q?fAOTps3CygFAjMdVV+derB4rQOCudV29OCpQ4YzKOI7soxtl7x/DjtnJKQMB?=
 =?us-ascii?Q?JGGh+0FddAc8IlkR6JG7SWSiGbTIm3irk7hUUWAClFZbiEj8t0NlOd4RpEhf?=
 =?us-ascii?Q?Po0KotRK2vT2d5L/e1KziBDsW8pu361BAXfCUoqznN9qT4TvEwGTu3K6R1KP?=
 =?us-ascii?Q?pA0JeMUUqjs8v4lLOzdVxIXmXNtNbvaNJ1aJdFBUL9wrYUYOIu8Sw1ZjhIA6?=
 =?us-ascii?Q?xZ3yv/2uzq8cD6mBTC3OJeabqnN3ICifMfyZhWBUrEyVV4gLWupYz1jwwPjT?=
 =?us-ascii?Q?UHE6UMEDztDxzbbU3HoKIlK9FPa99Rd4AkyBfQc93XgQ7184Oeuxb8MnK/fS?=
 =?us-ascii?Q?rVBp4A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f707610c-97c1-4149-7db4-08db6dc4a722
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 17:19:19.1053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SnzNPjJgIc8DBP/0e9OK4hoGSaILOcWDCJWnbCkIZbCUSOR1yEHoP7HWNYncSEG3uFShip/wIn8wF+QxZEn4ngRdWrRxhicFItxbWzq+cUI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR13MB6420
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 04:13:36PM +0100, Donald Hunter wrote:
> Add --mode strace to ynl-gen-c.py to generate source files for strace
> that teach it to understand how to decode genetlink messages defined
> in the spec. I successfully used this to add openvswitch message
> decoding to strace as I described in:
> 
> https://donaldh.wtf/2023/06/teaching-strace-new-tricks/
> 
> It successfully generated ovs_datapath and ovs_vport but ovs_flow
> needed manual fixes to fix code ordering and forward declarations.
> 
> Limitations:
> 
> - Uses a crude mechanism to try and emit functions in the right order
>   which fails for ovs_flow
> - Outputs all strace sources to stdout or a single file
> - Does not use the right semantic strace decoders for e.g. IP or MAC
>   addresses because there is no schema information to say what the
>   domain type is.
> 
> This seems like a useful tool to have as part of the ynl suite since
> it lowers the cost of getting good strace support for new netlink
> families. But I realise that the generated format is dependent on an
> out of tree project. If there is interest in having this in-tree then
> I can clean it up and address some of the limitations before
> submission.
> 
> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>

...

> +    # C code for attibute set decoders

Hi Donald,

a minor nit from my side: attibute -> attribute

