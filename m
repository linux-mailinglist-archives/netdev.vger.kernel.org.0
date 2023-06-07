Return-Path: <netdev+bounces-8738-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE87172576D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:22:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A6E01C20CCB
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF7A38821;
	Wed,  7 Jun 2023 08:22:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7AA79DB
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:22:06 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2098.outbound.protection.outlook.com [40.107.94.98])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7301988;
	Wed,  7 Jun 2023 01:21:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GPavvcWmk0uPkJcevt6+mhbjM/fUR18HQwrERVHKShvvGvdikKf29C0RTrbbVB4xL0w4hXhEl29Wkskru2NE9CIc0t6uDdHc+HKwjc8g1iGdaBOce/qawDtK1gvXSxyDMjV+PMfvskowDncQij/Gt80lrB7bMdRQSmTMliePN/wLAFD+23r4dbOqNYELa1C9hk5t7Ge4zgAZX6Obq/qbYNNQQPPw6yqQgLy32916qNwHoZpckj9y3WRTKXEMxlvw8eJsu/0Tfvn5gRxdFfv+opYWEFNbV0wHQ/7c602vZwSM7IpHL35pVwOEnQpZlmbgMY4CiJ30YKBmMEv5RTswzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ac6VM/voJRscAMNmU7QZr/vUjy/d9l5460n8THjvuCQ=;
 b=ZEMfXZANkOcEKikwZJzHWsOE2Qaw6I/VdCntPymNNftUOm5UUUyWXI+FJ7v5eG4G4FvqbRIQl7gXvkt70SfJYlhWYDQ86DOBC/cL7Qz6Erxwm67VsLpxkJsqaIslx6Z4ml4KEU0Lwh0EGrxdN63QDytcSlDXxSlptWS8m7ahNOo9Bx4uU/V5NsC7IKQuwA8IyGioBKC9ncnf2NCxgTG5D4OPyPpCu3zh4Zf5t7cPy97VnHppg61ff5JCb+Fd49FJEwRz9NwCbo0pKElg4pAJV7ReWvL/JTY5fGWhasth3oDXxQYXV2sLbYizgyMzXQaNyf/EJo2r519o6qiavQuEBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ac6VM/voJRscAMNmU7QZr/vUjy/d9l5460n8THjvuCQ=;
 b=awyOiT5JluzLSvp5bnZOdVTatoUm95W0uS1NYU5it+7vrKUIz5SHQnSr0s6Oow1NUqaldArUMsm66AJNaeOo0X82F37hUjB/sMBudNyGukVu7eE5rkg1dyBnq3yfvwF+8cMsc08UA8wvplIQIcRQfU92thxvlJwOdb7sO4rcn80=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB6053.namprd13.prod.outlook.com (2603:10b6:806:33a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Wed, 7 Jun
 2023 08:21:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 08:21:55 +0000
Date: Wed, 7 Jun 2023 10:21:48 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, mhi@lists.linux.dev,
	linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, loic.poulain@linaro.org
Subject: Re: [PATCH 3/3] net: mhi: Increase the default MTU from 16K to 32K
Message-ID: <ZIA+HMlUe7Dzt8Db@corigine.com>
References: <20230606123119.57499-1-manivannan.sadhasivam@linaro.org>
 <20230606123119.57499-4-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606123119.57499-4-manivannan.sadhasivam@linaro.org>
X-ClientProxiedBy: AM0PR01CA0157.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB6053:EE_
X-MS-Office365-Filtering-Correlation-Id: 38a980aa-2147-434a-97ab-08db673040be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8ChlPJ+6m9dRA0k11wMy1nOfJq7Kqg4U7djAsgWbsLie1DIwGtolWrgH9Cl+3a4kGf4+TZWAKClLVALVoFNlSJnRQ9FmPpbOPR/4+2S1fZ46s4sg7P2rexJjTdOcp8BO+Doil46l0vrq+2lvLP67CWvvQP3EXsGLWRUWCHWT0ll6Ux2Q3bXxIVlgAyVBw1cj9Jlee1aLnBH5bq0KZhPGEqRcQ2X8TJC9YJLZB8iv+HqFTpJIrMnH+FE/0SXGIZO4FashMuLD9Jg9ZW61fBmi1aB6CvjjS+4O/RMqF/nXDxsa1FIArPfpSgQRbW/oxfBSrYY5DaKxXr1D77oUJltF7a1jf1Ph1ccPjOL+1GtBmQVgUDyP0cxZgZTmC1lX9E2Rv7FXXzspNvHuMhpWmEiz2mLRAXxfW0dd/XFYp4fSAQY0MRTGp+BKS/QONRkvfNCVhneWM44sJStknL4pxA6OGdrnK+jKRYImnRqopVKnvQ2BWNjd84MN7/sajpf70hBAvYd/d/syXFiOGdyCIlU69prLdXmtTSUn+5bLXEKNwI4uYGmckPbxjXiTShpoquIXZwKcfTDGdvgP3PZapdjyeC1w7IR/Ql8ENLbsQn8Awzg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(39840400004)(366004)(451199021)(2906002)(8676002)(8936002)(7416002)(44832011)(5660300002)(6666004)(66476007)(4326008)(66556008)(6916009)(38100700002)(316002)(6486002)(66946007)(36756003)(41300700001)(86362001)(2616005)(478600001)(186003)(4744005)(6512007)(6506007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6C8tiKXoDk56e06J/kARpRGUPd0l7+YD6OLXgT4Z3KKd60mfZ0DjX1iNnA6o?=
 =?us-ascii?Q?uB66INLao7FbrzFXbnP+E1poVtSNzX5BTKGBgQchkatKrpNUvQ+EAv+yr1mC?=
 =?us-ascii?Q?FfkOCyn0Mk95OAz618NUqPX0O/T+Te8SF/5xSDsXMiDlF/4RXrluj+JoNmnO?=
 =?us-ascii?Q?chSWkqCWwKhmK36HRNj/QMYHClL8fWIMIaJoPpAgUXI8WwFTO2/+QQnZ01b7?=
 =?us-ascii?Q?9SDg/Hublp1uno2qBUQ7/FHgcvME88iEKUg/WVZ12MH5n9SCHuqvCC0sSu6z?=
 =?us-ascii?Q?PdRvjDxrH3lMgShrwDV+zPqMt9MoyLKaPg8l7yrNnDTqaBIMYhLnxXm67tiP?=
 =?us-ascii?Q?l7s6m5yLczbghteiM4WYa/HIk53gy5IvGEqAVXDI7k2f1WtHknakOzByIRKF?=
 =?us-ascii?Q?hosvJ7PoGOhrXNVEUWjw4ghmC9eufQrJXjLsencWzMjwiVjCxKx1oENTh7MK?=
 =?us-ascii?Q?SJ+TjMtctf8W3zY01suoZarWEw0CnzKZHY6Cyeopi30OtkesOvKQ8xyPOjJq?=
 =?us-ascii?Q?5oeIIWOooUNiXuafFIc4yjf4FhZrr2iJwEBqb4PPSNvknZT9PRtMEm3hTuAN?=
 =?us-ascii?Q?nGtaTIYQ6jkcjQKPKOquIx9msAbacEYXm42gOLFDJLy9TOMPF6X+7CajMVC1?=
 =?us-ascii?Q?6gXra9Zp+J/MbkFcjAA+Su7M4TgZf7XVWQ9kqwRuBjWv3y5gVT8My9r2EL+V?=
 =?us-ascii?Q?y454iRREodIkq0W+eLNYwGaKVmseZPgeNzt8xaSM+9mj2E4C2ryskO7bXNAT?=
 =?us-ascii?Q?LiStBFbeyHfHOkPQ+9S449HeOJ1ggM7JAC0+A2WGHZ+LhH7Q/3nxEYLJGlD0?=
 =?us-ascii?Q?I0hIJkpAt6ha6XrcQSQptVoDH2h25gH/6vfCxbbt7syvThalYysktnHZVuwe?=
 =?us-ascii?Q?K46sRuFsw9Y2ZHOc0vHWtaPiB7XJTX0LqsYZgqTkmUHOYKqjlYqdQDEvgOjc?=
 =?us-ascii?Q?F2WGW2bbZzO1squFTWHfIIBxMjeIC7h/fLix9p6y3OSqrw1wER2Wiftsmuyh?=
 =?us-ascii?Q?hkPU5pFyRYNI/qSsF994yl13KxlN0fxGKUvSlQolgmnFGj86yhWrLF33vE4z?=
 =?us-ascii?Q?cLKs43tu2V8Vc7NBXprxLAs0jI9R20rP5HkkI9W6QBl69XiPg1tIsgNoWGa2?=
 =?us-ascii?Q?afRYaBV9k7ItkUn9neNgXVppiu+vWpZe7aADXKiqYnQDPwHrHIB7hYAg82p/?=
 =?us-ascii?Q?VJXqJ56xwgzky7dJV8owe/ybd5BiL+n+iYyPnO08T6jEIV/JV1AlMyhfIpmP?=
 =?us-ascii?Q?yUHwxH1EEGZ/0DpeZHZFjYdI1QuoNFfUQxgZbzXRewNjh+mvHqXWBBHTcSj0?=
 =?us-ascii?Q?x9nDCe/lUmaK3AiGKPlxigHzwaKck1RVRIIu8v/dhrkOHTQeOjrS4KBjpybx?=
 =?us-ascii?Q?rf1ofmE/g/V4AoQgm/DyTMUBdRuxLfvcWRmMMbEc2h+Rnb/rQjqp5lxWpc7b?=
 =?us-ascii?Q?hagMjCQFa5b6uK0EsAUsiaxWxfOMw/FEOSEzpQNHN25p8ZJDXpqkd+fQpm3W?=
 =?us-ascii?Q?QFiJVJWSZELcCiGERFOSZGRL2a7g9icmU13JTBNlhPL6d97H3oqHiLUtxIGv?=
 =?us-ascii?Q?QDvz40ch3IL0HVYePvvV1LzdnkZFkYkqZxTiscKzyL3yUvMUvzxPWOFoAkJt?=
 =?us-ascii?Q?MbicxC6aZrDwxmy8NQkQ8/fhlzg1nhSKNbRt9E+JkKE4vxhqPHGLhoMxrUi1?=
 =?us-ascii?Q?QLaReg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a980aa-2147-434a-97ab-08db673040be
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 08:21:55.0257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zld5ihTfOyOLpAuWY1/uDyRO6AnTV+A9CLQncBXQdmvjRgKsQTViJAVbel5fkdYP4E+H4T4m7OfnVTtvNx5AJx4qOv16+mu35oGfgjniq0U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB6053
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 06:01:19PM +0530, Manivannan Sadhasivam wrote:
> Most of the Qualcomm endpoint devices are supporting 32K MTU for the
> UL (Uplink) and DL (Downlink) channels. So let's use the same value
> in the MHI NET driver also. This gives almost 2x increase in the throughput
> for the UL channel.
> 
> Below is the comparision:

Hi Manivannan,

as it looks like there will be a v2: comparision -> comparison

...

