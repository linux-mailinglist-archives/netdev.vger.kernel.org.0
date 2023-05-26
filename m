Return-Path: <netdev+bounces-5597-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BDBFB712382
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:26:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1757A28176E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:26:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D0D111A2;
	Fri, 26 May 2023 09:26:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4479D523D
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:26:51 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2117.outbound.protection.outlook.com [40.107.212.117])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC55095
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 02:26:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/hh8HVBqL70eXSt//VWpKnB79lkH3YylhEBtEyvofdc703QR5yjDrI8EVpQBytNbvdlRkZjRab85yLzdm3EH0hyXCTrfao+L6E/6yNXqHlfOl96Z/bzdtTRIrVFiLmEmB3iu/f52w9lIAvHcfRj5NbMvjaT5vMF3ZBtfWL/PFZA+z6XjMTXMwYpbsix1IAHqnXIzZiLFEcTQkFCE2kjg6ITDE5R5768RpFi3Hy1ByCcRckjFPbxdaNPnqhlWQ+dXCn2AsXfRPACuJrrlAEjWnU69Z4lB3iPp/r72If4Q0MSzqij6QAoAGi1wgslMGT2WXdL61KsUJBnVBZEpjCunQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CjkadY7XuZg0xMwFeostvX4YcZnv6yEhbZA9/zDp4j8=;
 b=OgP8M5QRIeosATWLCe04XIdDiii9jITDqempKdLuHbR+ee3ON1MOKfCw+u46YK1R2fDkx6+5/RO0pY+9d4SG0mtEjS8O+ur6OlNEI3EZ+MtDn9YG5kY5vcxC+eeZI4qPK5eXZROkWGPzLzGMO1235eeveYSeowO3gV+yFX1ZefhqZFJT56aKsr97GK6TRqviQJn0jFRf8mskjdILdOmu8ueTXtbcotPy/JRJaUTaatV0AZ9NrG/bPLJf/BU9eWc8u4PXgwWIjdc90Vp4gavqyOf0SOpFva/tS7OLqrWUNbet4cYulGFQer1y/FC1WZdo43Eldpkx8Iv9nbS2afs2Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjkadY7XuZg0xMwFeostvX4YcZnv6yEhbZA9/zDp4j8=;
 b=OobbME4wqcFB/A1/pihuzeTRey3vHS+z49Rorm+78TvnkUtLH6dAIoFDtk8Mfc3Uj4odxAe37/sdzZIHS2qj0evmYIzl+b7CveuxlOmpTl4wmE2gfyzWNOhJxdByRtF+vsYVRBBFQSt+1ihsKFrHzq6r8dOp1R0cIIf9gEgXmwc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5197.namprd13.prod.outlook.com (2603:10b6:408:154::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Fri, 26 May
 2023 09:26:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 09:26:47 +0000
Date: Fri, 26 May 2023 11:26:41 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Pedro Tammela <pctammela@mojatatu.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, kuniyu@amazon.com,
	dh.herrmann@gmail.com, jhs@mojatatu.com
Subject: Re: [PATCH net] net/netlink: fix NETLINK_LIST_MEMBERSHIPS group
 array length check
Message-ID: <ZHB7UezB3+NcYn10@corigine.com>
References: <20230525144609.503744-1-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525144609.503744-1-pctammela@mojatatu.com>
X-ClientProxiedBy: AM0PR03CA0021.eurprd03.prod.outlook.com
 (2603:10a6:208:14::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5197:EE_
X-MS-Office365-Filtering-Correlation-Id: 410908bc-069a-4ebd-cfa7-08db5dcb542a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XI5Q96NHlWLSOXv1/6ZTNPCUEhSY9v+Jvg7BsfcrrWC9d8+e7tqD5sKBHISEFJKjDqUy/AaMVCNEaZp8DQRuBwQWdTlgJ0jk+dr0E2RDkAW/uh0wjfpxv2hHG/A1antyoPdoIbpryUoTpSyZOnD+MteDYvmUC4Hy5/euy/oUfrUPhmZaKmHaE6R7RGyHlwL7cHjDTv46XNeaOwMo5S9fkuBK/h54kvakx3ooS+og/Do+GCGKgLrtc5KMr87r5hWaX+XKCYq8wwUilYiDQQivrxO1fJWBEboTPvGP0xb0i/KbdSND6htCkvo5+Xhdy/PVAHeoC4C7OEOyiwIRgdcy04SU0h8C1DSYJE8aq0LPEPTN4+tEi+uypBNe/rJgmThFBEMi4mU+JVxWQDLTmJ4cG4gJzcDyAmXC/C3Twrnavr5MCyYopsckZqCuY+xluwkQKxBt4eVcLSVJOK8ThV6TDfXjDCSD89tAL0742mgHtM1edJpiRivcg4jWacpusiOaoNZWf4VsygbKrw+biO8EshYnfR6tBBBOv+RAzn+4o8wnLgr3lUh0xsX55XQ6lVmQdHToM52uzttVXcdhYwQe/wDGDCyLkzLPDYy2webhsso=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(396003)(136003)(366004)(346002)(451199021)(6916009)(6666004)(6486002)(2906002)(8936002)(66476007)(36756003)(66946007)(8676002)(66556008)(41300700001)(38100700002)(5660300002)(44832011)(316002)(4326008)(966005)(478600001)(2616005)(186003)(6512007)(86362001)(6506007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wBE2uRDFOObHd2qS7UPJNNWbA5QHyFQwueazlbi+CCbaEcJgremIs6v3tTam?=
 =?us-ascii?Q?AUHmMFy194hzdKO14cIOG/xi0HG7pSPqhK2xrU+zxlg9IPpLqXOOFegww6bc?=
 =?us-ascii?Q?sGEP6xeSJ3j2cF2E4l/iraQ2qPEUiZl52I9bt9hgBmmFRO++P+iZ+3S+5evS?=
 =?us-ascii?Q?lADpQEka8Z38O11GEGh9sl+ogLgGk01mMzlRkyJHdzrYJuBDXZChuAzanJH/?=
 =?us-ascii?Q?CpKCt1DGWTB1hujrBaILkrOD2dg6dnugIxzHBV7B9H7+p8OSfK0XyV44v07Z?=
 =?us-ascii?Q?Vh/YynIZRKpzOuoZC6LJwTBzEODemMzuwdqn0oytphFnJKq9pw7E5Xnnu1Bu?=
 =?us-ascii?Q?MYq8O9BE+rpQBTcMTu4zv5PtG2rcy/Mh7OyX0xADBiveT8G5HvyP8inQMzUz?=
 =?us-ascii?Q?haZkZaIfB1eAE3wS++7fRV8HUqoH6FITuo4O0jkilLFXbk1CzWh6y4EzHqQo?=
 =?us-ascii?Q?0b33aMrjF7iIF4v3G6nNR8WZTqtezWYQ2P1601mz8/Zsfeln5+/SZGnaHxFe?=
 =?us-ascii?Q?H+hA+xNm2wo88sbLTZQXLzFSsmNzBq0yFTLnEQBGBEeMjeDnKy8eYjHZZ8Q2?=
 =?us-ascii?Q?aG5QmaPcQmUsZ+QzZnjSwtP7sR1qFw1WQZPNGDG89Pv+gmaHBYxfLrFpDwIK?=
 =?us-ascii?Q?wJQY/dtGoXqmZiIIBxo9oSW0Bx+y/Tr4uJuRQy07BCY7T6+krJzIbHyCxLos?=
 =?us-ascii?Q?8u5XjTdxK/1v846Nxovo+4nsdwt6wUhB7Kcdj3Kqd8dRsNLzJINfBGINd1Dr?=
 =?us-ascii?Q?4ruBZ05NQ46vrSoPhFnVYf28GPKteCX90RUJwRIEbOaRQxbayXYC2dgFia1B?=
 =?us-ascii?Q?hWmvmewKtNrpkE7TvZCDhS1BmuCB5SyvYCpcLrqIry6C1iLT/OLqLbry9wRP?=
 =?us-ascii?Q?eTzY0RqTnvQW5kuKQRVGxOpcLMSk+OZroSoP21CGseLKs34AnGQGkjDXnKL/?=
 =?us-ascii?Q?CYaPlbx8tOl2dY2tFtWjKLW+gFJ7Tv7LqkjfUpBpSSusA7Ngiau30VL3ZoJi?=
 =?us-ascii?Q?I/ujHOYLhrNWpV2qIJPhXkQhSSYGgBsT3fPwVCZKria/xLon06F2jwBNYFVL?=
 =?us-ascii?Q?ma8QVCRFz6aQvIoRo/PDze6Fq6eGFVz1eQA+DhWRh3O5f1L82QI90ZxHCrzX?=
 =?us-ascii?Q?KGtHut6u4x7nWiV/+uJJE8qHKQOr+APsvRWz/hr9BHimf5u67HEpS5mqbvPT?=
 =?us-ascii?Q?xpNc7YgLRniZaUi7uAdr6MSkQa2vUYUpGZ02aGNosoewUmyhKI67s7U0FWo9?=
 =?us-ascii?Q?9V/LgUBgleG9lIB5HYAlcRkxTOdlnFZc9osytXkwz3PfugGuSCWwmmngIcXT?=
 =?us-ascii?Q?GBoXCg9XB3J912KBBv6CPau7N08RP0qz74Cq80PsptNrEhu3c9ymlLQxBhqw?=
 =?us-ascii?Q?Vd3M8kYYy/yntpyipIExlbV3Xno1w1CpAiCyRa5+PSse3jGAa/LCrVybTYDq?=
 =?us-ascii?Q?E68ihY1qajz+0TwoPvfjPkcBegRq75OoB0Qbk5c3vHP7Hw/EgS23E3Co84++?=
 =?us-ascii?Q?Tab3H839laUQ7f/GzC/0JnIpHJ/8ezxUvnA5fBpSbJWWC4Xgo3fv5rKA+cl4?=
 =?us-ascii?Q?wjambrjxYexjYuUIGTS/2pBaCVV0XucZWSa8k82ZckSCfc+DRtD1q2l1hlMH?=
 =?us-ascii?Q?M12rMP0Xp61ZzaOwUhbF940Rm3E2eg7Sqno/adOsNl1mLBcKI4k3zCDv0xzJ?=
 =?us-ascii?Q?cdLayw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 410908bc-069a-4ebd-cfa7-08db5dcb542a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 09:26:47.6162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mugRVx7ddfqtHeePG2CjCL1Z10g3r3CvAAiXQ1CS1lQkrcz37KkplJ7hkXYxWZjDtna1NmELvBJ0u7xymxoCQo7V1xPWVNRau/bnx9nUynU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5197
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 11:46:09AM -0300, Pedro Tammela wrote:
> For the socket option 'NETLINK_LIST_MEMBERSHIPS' the length is defined
> as the number of u32 required to represent the whole bitset.
> User space then usually queries the required size and issues a subsequent
> getsockopt call with the correct parameters[1].
> 
> The current code has an unit mismatch between 'len' and 'pos', where
> 'len' is the number of u32 in the passed array while 'pos' is the
> number of bytes iterated in the groups bitset.
> For netlink groups greater than 32, which from a quick glance
> is a rare occasion, the mismatch causes the misreport of groups e.g.
> if a rtnl socket is a member of group 34, it's reported as not a member
> (all 0s).
> 
> [1] https://github.com/systemd/systemd/blob/9c9b9b89151c3e29f3665e306733957ee3979853/src/libsystemd/sd-netlink/netlink-socket.c#L26
> 
> Fixes: b42be38b2778 ("netlink: add API to retrieve all group memberships")
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


