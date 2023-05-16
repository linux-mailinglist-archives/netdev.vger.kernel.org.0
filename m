Return-Path: <netdev+bounces-2878-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B311670463A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:23:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A0C31C20D66
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8219F1D2CD;
	Tue, 16 May 2023 07:23:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7C323D6
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:23:39 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1041FDA;
	Tue, 16 May 2023 00:23:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8nsiheXoTISNCxBkvlkSEm/a5217s6u5+GpG9uj6gcYZ7iAu6Ws1w7gEWO007eHmadQpD/0SyKjAaf/L9aKEv3Ulo/h2+vUBA2xEhU+z/QSM2+AELHabiht2X4NDSc+VVfylYXomBnoZKBt4oxBzPVzD5iJoR9Agwe8ot16//m99zhxCjwXVTcPlAwja4zED1Gp/jyD3powd2fsWImklv4lw5dWdt5WUBGH12J0Icw8a/I03t2tzJij6ueAmbPGvYshUfBNRhNoid1spWEQRtunAM6ycis+2N1ipV2rZ/R9eVeDMX+aXgfp85rNkdB0NhwSZJqxcAwXlc7OZpvtgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3geK7NR9lBIv80N4tnf1PAW2j9w6pm7HGbzbn1x4Zic=;
 b=gU1nwV9QjCTnUcxPoi8NxjBCsYYfqD7Zg61mDouzCtLntz1CS4XY+ZDuCynqx7X67eExPg485MECNg6I/zWas8vRv6TGQ/WGWfqmnv1BjBxOw4KbOa+fsXieF6lDKl/kIBmIn9I4ciROCjEk4Sl3cp4U2oivz6YmyLUs16eIvvqnky1xUfyecz6OFaQNMAvFFsNGas+OHqt6wzvOLVgWeC1n+YyeR1sfCBU5KBZM8X0l+vZW8Vj4EsMHu5Pa+n+8sVZyo5v0z2bljq+Qe8uomwSt5D0XruGWii7Z5IXqPICpHCSIE+CZqL7Hvbsy8NP4KNEtzLYFKiTv6IasH68LKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3geK7NR9lBIv80N4tnf1PAW2j9w6pm7HGbzbn1x4Zic=;
 b=BNdekOVVlaz9R3hbEVOdG+mChNnkfr77xvUBsYXGvcZ4t+MnqorDszEGMcMDB2pm79AU5hvVgwr28UzFJacbhdQf+MxdNAVhFWC7c24bp8Yj076FrNFYwbiAjM4+p/TjQAtzfYxDj/6Zs7qYkwDcPexGdVoqorxW5wwLqAAoX8Jhtb0lE0m+4UCJBmAhJb0U9XnOdne83af1leKM6she991Ot2npgQ1ihOjrQhtVeU7bXbd1dFDTbLzQElC9H5oJSyXHclxL0PWpN3+DGo9lbs6z149ic8pcnDFu00fLzyQbp4GXSLiknNbBBo2/IqBRu7dH836Wjdep5QFO64HCYw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA0PR12MB8746.namprd12.prod.outlook.com (2603:10b6:208:490::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 07:23:35 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%3]) with mapi id 15.20.6387.032; Tue, 16 May 2023
 07:23:35 +0000
Date: Tue, 16 May 2023 10:23:28 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	mlxsw@nvidia.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] mlxfw: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <ZGMvcIWSEVo/qyfl@shredder>
References: <ZGKGiBxP0zHo6XSK@work>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGKGiBxP0zHo6XSK@work>
X-ClientProxiedBy: MRXP264CA0022.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:15::34) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA0PR12MB8746:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ec9f390-28bc-4164-cc55-08db55de75b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RYLNSI+wRj9UKpTOSOlDJ3DfMPg+koN5HsIEPNwVrXxS1g4Mb9ROEo7wWhE8fXNcIuTq8ub8zHuVCqAORFMIMlymvLTa8lkFz1XVrW2V2N/jfoF6F/iWoe8oXO4Il5pj9rlSLUNWt3zEsGhd7QQPRE/H7G9MWs7s9DNC0OqnTaI6idAjbIkhVQ5cTLPI/lqkswnmcU7BrTEgbCLGZC+rVcHejX/rjjJkOaWdtt3d4wtO80jwPEWDZ0FJZALUyMe3LTGIug5wCkSnyoy9aInQRWpg5JkTWlbWSplIws37Hf1Ws2mKjiZ/2IG6cVlo3QDkwxf/y+U3Mu3Pm0IAf+Pc9KvXyLk0ZneDO787Ahis7cy3IZzYVvb3JL2nanVBMU24OeSbAb2yfAWaif+NogP15hr51pBSinwzYuLTWCeNPQJOR2UHI5omjQg9Ia6hrhxR/rj6ibG+Zh2d8JOg8j4nBfwa/XuDgg7+FGbNLDdwgi1XDHsPSoWb9ivQgFX0jmzt751XqMP4n/EbbxG0BE+RRlWy0l0SQsSJIyl/kLXQMFRsCnRzq5zL9JXZgGQGQAFA0EsXPZYl+RdqLTtKlMQBKlmHbtLnK8tC+EE7qPtxtcSVf9jOMnsNNWlxFFIwZ+6g8QOdOhcu9/zuYIWenlLIYw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(39860400002)(136003)(346002)(366004)(376002)(396003)(451199021)(26005)(83380400001)(4744005)(2906002)(186003)(6506007)(9686003)(6512007)(966005)(86362001)(33716001)(5660300002)(6486002)(8676002)(6666004)(478600001)(54906003)(38100700002)(8936002)(66476007)(41300700001)(316002)(4326008)(66946007)(6916009)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3Wy/JU54Q/OBbCvI1jzezvM6GDr564x//Xh1oKD9vBZ7dG9x2lwPXyrDsOXK?=
 =?us-ascii?Q?Hmht6PGeg5WXSZDrnfd44dMvN2/LVcEq6kk1P9PBoBMquMta3C06PP6jy+3x?=
 =?us-ascii?Q?PGqe+351tFdZwE7vF/Q6Wp/0n+X9nc6yQ7KkIxeWoiJZSLSONNFglPoy9XMu?=
 =?us-ascii?Q?2NDwnZEG/Spk5hvkVdWKaUw1eE+th3mwfxV+S8QHc3KFyxDcz7t3wjfbWggj?=
 =?us-ascii?Q?8gcbgu9lrrHgeX9jwFzYJyefx6QcaeEgAKVgR8OFEKCgWkJ9tvy5ufob6QVb?=
 =?us-ascii?Q?SxsPYrFXDT7bY2oeD2g0u8x0aUW0tYBOJDeQ9k0sNQ92l7lkYmBa31+PbR4i?=
 =?us-ascii?Q?qNgmPgE1OznQVDGevLGAyDAm3eFLhkydFnaupqXuCvUkbW1zkylDsM+DEhS8?=
 =?us-ascii?Q?47IOHPUzVkKI+kFLvd+Oz2kGyc9ugp9nx6NrfOLmKNbizjJGkTBZ+A7xBAEp?=
 =?us-ascii?Q?pvo6cXaMv7576/HUlzCyUCGT3Hx2xE7va98tgbKKvaphXZU5RHzsnIIrLjjd?=
 =?us-ascii?Q?owNsFfV13bYLsYpoPudaKIhdX+2zWAnZTJ8YabC+pUaOn4uzDuIoMiV+YnWA?=
 =?us-ascii?Q?J9Tr+QW4Q1V4aoYOOeUixpeFq+YYJIrVkUn7/dCej9+b3pWCKbbDnMXfXFl2?=
 =?us-ascii?Q?psZ7Is9SU8Ir7N16g5DoFKG/47HoSOcfIhDJ/VxT/oAnQ6aaW3d+22JR08x/?=
 =?us-ascii?Q?Ny/nFFiUEbl6IlPafvuvUOvrhtLYXXzvY0mwCJIzNUoYZBi63mvbOCzEIMmS?=
 =?us-ascii?Q?ullokCJAvpD86Dk1oc4S/tYzGzyve/W07TD6rFBJG6lC2M3y3FwAUpF5t63B?=
 =?us-ascii?Q?xtEUrU9rORg8pUhAUEiBSs6RPqstqqRmLGJCaYHj5+3CFqjN2b/hyCDiSS9+?=
 =?us-ascii?Q?2jpLVlYyFVtp7OQTASrhrwbaBs3FloTL6sRVXKLMEOf5wvitv5ngFUN+pFEO?=
 =?us-ascii?Q?0XL/2VARjfFTLOHAL2Tkccy9QTqxpn9phApT9vJmho4gi44VVshpgyZdPGi5?=
 =?us-ascii?Q?057o/DKhM0CTU1F5TaSQsS5xYB9h0lkm78GBJYt4esehPyBXdQDxZFwLsYA7?=
 =?us-ascii?Q?sUsfREolQe8ZUhiAqUDl7VfGnGRludMjbODvHoY2QOmGyJ15DUjv9LGWyxef?=
 =?us-ascii?Q?UZUCV39piOcjio5Souvl8653jf2qgPNB8Z4M02/fMi/Zdlo2mEQFHXCIEnhn?=
 =?us-ascii?Q?ffAX5KVjJY/OAQBe3nEochOXH2oUak73lORspMJYecbIr+vfi0wtGNK/Ma0i?=
 =?us-ascii?Q?Me6lcPCfZnfNUQgQSiNy9qlHN8m4/IV9R9MawJW14s7HHbwhMhAkeIBxLJSO?=
 =?us-ascii?Q?yscgzq/wtOUM/4IulkIMXlSSnZ7rcbITvPwuHIEVnJxbSHBGwizykev3GcmF?=
 =?us-ascii?Q?WfSODuKITrwsfc3RxsmauH3c87jCXCrVnuRUCWhp1opbeqslaYPyHekFu6rR?=
 =?us-ascii?Q?9Ab0Vh08gYT18RLJEe4El0kPcQsORuvqgnxbhr7NH0HHrWRh28lDsHYYEpgu?=
 =?us-ascii?Q?duVM6ZTw3QzboM3mxub83K/vUxuQTTguq5MEBwHEeCHlisR0iuJMFDdbBhWc?=
 =?us-ascii?Q?M/v/QnMtnhZXNBzRmVFp082ReRkP/e7IeM2WUTcT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ec9f390-28bc-4164-cc55-08db55de75b8
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 07:23:35.0641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Plt99/jNFRc2YzlQgC9Mk8PhUBGmg1y5ooijI8oIAFthZyjCE29nHxsLi9L9iW7ZAFoTFsbGrPciwDPQHllgiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8746
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 01:22:48PM -0600, Gustavo A. R. Silva wrote:
> Zero-length arrays are deprecated and we are moving towards adopting
> C99 flexible-array members, instead. So, replace zero-length arrays
> declarations alone in structs with the new DECLARE_FLEX_ARRAY()
> helper macro.
> 
> This helper allows for flexible-array members alone in structs.
> 
> Link: https://github.com/KSPP/linux/issues/193
> Link: https://github.com/KSPP/linux/issues/285
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>

