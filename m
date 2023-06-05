Return-Path: <netdev+bounces-8171-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 122E0722F2C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:05:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AC741C20D88
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DFAC23D68;
	Mon,  5 Jun 2023 19:05:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49406DDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:05:14 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319FC94;
	Mon,  5 Jun 2023 12:05:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0dTI/WPgS2aZe9n2lzmAuVF1wMMW9U1PrlX01tEvJdzpfWwOUfRIecNXk+GCUYJ0VbtI3D3EeEhnMKrc76pWaSok/g3tZP3aw8jOzkQsugdVWPwfM3LVdcR40FLyQ3dJHOS1jFhSTK2OcEJvfz8QnOlEhKc7b4MYB+03hHyAg8GOGcbiJ8t2qzs+bDqw6FHyYZVgqeJYJ/kKBs4hIZSTfAFbZFZ4eAl+fsqwHSRZ3ajqUv8ytsVhPKOc9iMsucMuDmppTh9gUwHLjWK+W0r//7cPidNQIUSukL5eopHaM+goKT6ChKTsQ+7wQzjvg9TNoRGAr0PG1e3ZBfH4orUhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eDgKUM7Yz7zwQb3s+0zwhXRjeTWbJDIi4J1m5Mon3Gs=;
 b=T7ErOmCJdxMUdPsOwR6RqEQHF7qll0jcyE6LZGYRc6fcxUYtujbzVTxKI8eW3nQj7fcPxs1m9Ne6c3INHZzg+8SdsQuxWf7hxp4jtgpBTgSiMwQnaloSozY6axzd4ZMep4CD/qGTbUhuEqK+UV42a4byOuV3scnkghHezcmCWaD8TpCfwsQ36dufBI5jU1jX3hQ59ggyO59jtw4+uDdMUhrLkZ1QhWeoHCnaUejQlc+2Ts7MdZ9mUPWdm2X3MNe9XvU51qvrshYsseVlyZtA41p5Z9CAxY5vFScepBj9v89GEqbk+MJ+4hgjcSk3kcMuqo41e1jhOJdyITgVYtaBHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDgKUM7Yz7zwQb3s+0zwhXRjeTWbJDIi4J1m5Mon3Gs=;
 b=pNWIGleWCAxFSVLsuzB1x5RAZPU7n8HwPIH4+dKubjM6521yr49ISbJSUi06xHlf+Eis99ZT+UiUNQTeGZ1WVqmSZ0Ibt+1/FtsMmJ8YHUAs1FPlHwHUlbRQ7XKqvCm4RO1Mi/9OiiprGJqX+ao2Zj+5wKSTVqwB513WWooDxFGh3BdRFFo9yj+y/4GSsMrhUiZcBZvRE7of4EVOeDSPgG1TPpuLX6RowW8OCTmeD5q6KcsrfWzEcrvzS9zubANVW8A2exT5SbAIOhsbtpMXDcw1bLSLWTOnVDJ3xCV8szAwHa++9j+9e2Q7JEsd5AKVJvmWfgSa8qiaFm1iW8+dbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL3PR12MB6618.namprd12.prod.outlook.com (2603:10b6:208:38d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 19:05:06 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.028; Mon, 5 Jun 2023
 19:05:06 +0000
Date: Mon, 5 Jun 2023 16:05:04 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bernard Metzler <BMT@zurich.ibm.com>
Cc: Chuck Lever III <chuck.lever@oracle.com>, Tom Talpey <tom@talpey.com>,
	Chuck Lever <cel@kernel.org>,
	linux-rdma <linux-rdma@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] RDMA/core: Handle ARPHRD_NONE devices
Message-ID: <ZH4x4GR5NR89X6xT@nvidia.com>
References: <168573386075.5660.5037682341906748826.stgit@oracle-102.nfsv4bat.org>
 <783511ce-8950-c52c-2351-eef8841c67da@talpey.com>
 <F0D9A24E-CFC9-4100-89E5-A5BDF24D3621@oracle.com>
 <SA0PR15MB3919D432A5401D3E459A83B6994FA@SA0PR15MB3919.namprd15.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA0PR15MB3919D432A5401D3E459A83B6994FA@SA0PR15MB3919.namprd15.prod.outlook.com>
X-ClientProxiedBy: YT4PR01CA0010.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6618:EE_
X-MS-Office365-Filtering-Correlation-Id: 084efd9e-08a1-40a7-80b5-08db65f7c61a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6sCMFLB/NeWmdoN4kaFxoo02TtNc71pB523t/Lhj6b21bPhCY46yZlz8AJ1OG2nxko0Kz43zoLuXd8yKua+flxL/k3EWCMMzXaPbJbxKAkX7iBBFtx2GKmayteofjXbhMfV2hXby5MiFOEAzLpa7V7hq1ymXTQTISr9nHacyraWjqUSDY4QHUH6kLU5GwKyVYIT0urCiOZ2X2Oohac7axd546xqkRQiueDdPvAYxhd+KqVkenGMdoteRwDeYYdjzkUcYgCPgpOcseN+/t/DzM244KsI6kFBGtugE6AUWf1eVlTJLqsUs/yWptbcctGOBvhGxk4JlSNmhwZ2Om2gL33eWPj3N36kKyAlTessRIdwlZrb6THs2PB+3KB2LnjMfTfRObV52RVh9JeYOag9EvimQKXTv6PW0gaPdxdcLyUuUOZMYPqsn+8NOQfK5N8N7mKHiaXBd0tpyslAYEFzCQ6p9Pd0SaJkv8CUjb3BNG80OBqGaQs5ggfD9jG26dXy+KResaCkTQASdY9OzUfMtLspFEAuhYmZNNuxnqC+aRF1tl/Huyio7INJWTcoYDAY4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(451199021)(54906003)(478600001)(8936002)(8676002)(5660300002)(36756003)(2906002)(4744005)(86362001)(66946007)(4326008)(6916009)(66476007)(66556008)(316002)(6506007)(38100700002)(41300700001)(2616005)(6512007)(26005)(186003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rrLb/d4/C/uF/CIkw9kRS41+4xzIEVnE35SruVEBTI4rfae1TTpweiK/2KgU?=
 =?us-ascii?Q?JvsQjntI9h3sM+MmEUrI5irA3GpRgG7SQ/JHt3EQ/x9XBX1lXIukoifpjJqJ?=
 =?us-ascii?Q?oz/HHy8NDe8Y9ih1eFJ28ZGMrNTZwu9fNaQOdD84afyUQ6bHG3MfUVXJTmPx?=
 =?us-ascii?Q?lOgR5VmwXlt4Tfl6711u8FuMgqVnADw0EH5qv1lM09aYEKV3DdApgBHqs8Rs?=
 =?us-ascii?Q?HFZuRFrlN1OtSuvy7F6Ap10I17DK2zihhp9u9UI6+djx4sdmdijKODzv5eYO?=
 =?us-ascii?Q?iwo5dwukA89q+1c0i7IX//Fre6mkFRDJzdlj7c0nu+SO6C0ZESb0HLpfBZ+t?=
 =?us-ascii?Q?hNyHzVu4V3hbvmmCTEQcoo/naiRTZme1XfhJmuzBlUtys3qSQXQ9DrgljLDa?=
 =?us-ascii?Q?Fy1aHPZCVaW1qiEjEJxezAHBeYT4GtbUuWoPSGqQAraSUAUhBWRi5QDdK1Io?=
 =?us-ascii?Q?DX5UwjMC7Ze9Lk+iJouBbfj6Dhmid/tz631SBGn313GYcTd6oOjtEz1FiXcX?=
 =?us-ascii?Q?yahnKiUA6BSb3VHYkLAzo/iEKJtq2L2JlOOs/mKPKO5NGdlmd3PdSyObkEVW?=
 =?us-ascii?Q?WT1sjUr/Lb6gz3EcEwwWCYutEjaEYDQK90zWIzhpZkymC+i1195QEmhAjtD/?=
 =?us-ascii?Q?ZhgF5cRT4Xpq6BXtCJb/eJYfnrlD9ZcIj9TUlpK3NYOqgAPXBeWNsLZA9HRG?=
 =?us-ascii?Q?NLl+gU+WF9X830tGb/u8Td3dmx7/6jSYWWkWdazBJc/qZfXR+XKhGgyshh8k?=
 =?us-ascii?Q?727WLE6UFf3lU3obF2LQyw2FH8vEAJUrWR7lSAwUlaCNGkjDZ1RgOnGcxaA7?=
 =?us-ascii?Q?bB7BIYVksqMqJHbSlfr/lwn46edHASWEXU3PU++ISCX+f2PpMqS/LY5VjL6/?=
 =?us-ascii?Q?7Rk1MrE/5HFFZhjb2RUiPEXgrwe76B5LFstmxZH9XL0Bgrhf5wJrVpUnbGGh?=
 =?us-ascii?Q?4xwGEDO1bGKjISOSjYOp3+1cmZbgPxCIlnvYs86DPHFScCsfWZ8keMAjTTbV?=
 =?us-ascii?Q?qSFwx1etR1GpvhDPm7al90MnTzyEeJu80bImp/beDA16mqrXLuGgqT0BOd76?=
 =?us-ascii?Q?ie195D0a3NvucJkMAgXjiSVXRWbrleS3yKQA+iD79DMD0OicqYJSkduZZ8FD?=
 =?us-ascii?Q?GNV98giiCEn/I2fPPm8442QXZiD7rrUgmPdT1rxcHLIpo4WjMf/QPB7ptOb8?=
 =?us-ascii?Q?MsRIamSKfNiOpZ+YleKEMTdPrDx9sLJ1O8Qlebmy4XDp92u7bPFhkGxcVlfR?=
 =?us-ascii?Q?+SujB79W6i5skDOPSQPc/ePFLIHYMQH8tDmAV+jc4nrkcaujNNUW+wtgIuuA?=
 =?us-ascii?Q?BtvvxVQ+kgGJNV6KNp0w/l5QLnV+G4HJFvSdyYn/ehCF25N+7Aw3HyULpSCd?=
 =?us-ascii?Q?HknCeZA3JdbfB9/gS7BfN4lMS/1+rE1YzNMJFoVj33mi8D+RekWl6iHwzzSr?=
 =?us-ascii?Q?LGzEAxkCYLzR9P+RsdOnIqZPwqAm/DNZz6WNnM1ymDXujD/FtKEI8v1tdJVv?=
 =?us-ascii?Q?jVJOsaCYTgd8ClU4TrIWfhpenssJEt6Q+YjgZ0A7o4rBNXVfK4nsUgBCIy2V?=
 =?us-ascii?Q?sOCWFa7mWgxTFe/Mg3SPWXO4doMfiLGwQrPkTIY9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 084efd9e-08a1-40a7-80b5-08db65f7c61a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 19:05:05.9569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /kOGc+nqWdaPf3rZSZ5hrlI38U4J+SejOoOIRRpPRjIjM6orfE6pDFOC2RIVRU1D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6618
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 03, 2023 at 01:51:10PM +0000, Bernard Metzler wrote:
> The whole GID based address resolution I think is an
> artefact of IB/RoCE address handling. iWarp is supposed to
> run on TCP streams, which endpoints are well defined by L3
> addresses. IP routing shall define the outgoing interface...
> siw tries to play well and invents GIDs to satisfy
> the RDMA core concepts. But a GID is not part of the iWarp
> concept. I am not sure for 'real' HW iWarp devices, but to
> me it looks like the iwcm code could be done more
> independently, if no application expects valid GIDs.

GIDs are part of verbs, but I'm not really sure how iwarp fit itself
into verbs with the mandatory CM and all. Possibly the only purpose of
the GID is to convey some information from the CM to uverbs layer.

Jason

