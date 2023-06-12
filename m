Return-Path: <netdev+bounces-10248-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D9EB872D359
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 23:31:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 232861C20BE4
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D84F22D75;
	Mon, 12 Jun 2023 21:31:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004B1C8C1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 21:31:48 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2066.outbound.protection.outlook.com [40.107.100.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647AD98
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:31:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHiQyKHkwZxXVI+zZtZdnO1XwPPBb5YmRa/Gtzkg/wCWiIB44De719YntfexbCMua8sa0ZPSxQiOa60lxRf86hVSyevSfbvQLA9n52zSyrGWWydqzy2hGt8n7jtVKt0fWM+tXR7KCkqMLOb6F/MdCjSdjoX+tZrwxtB8fvDGzM3dSh+Hqxe1flyMiEYo+/qR4rGk6RAnW+Ppfh8WV4OSWequMyuVAIrI0t6rovln7GDqYCpRdqmfTqBThp9QAEH6iR5XfugkYT2eF3GZnU4bVFzhLAeRKRvAdVT+NX1yPt4sJFJBvw0QT5eGfE8c7rpTKeFEIB5jNKTC0WeriGGBsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HhMwHM3dRPs8eOPcqyVufxoJcmn7NQqABrwQCps9oUo=;
 b=PVwImLOvmKSlHSEqtauC6aREm27WuBVDSdcwtB6pqRyHbghCHrpvc32tVEKykbeSocW/vsRp+r40RAdXQLG5BQAR1+zN0tfHd/mMMfTs2FYokRFvd49p1jYvl9tMv2d/goN7tA3Fgevw1CK9NnVv+vWRyiJ5Ogub4XhqStV5Rl33S7FGKQf06+FTsK7hNv3Po3n0GthmO8lrZ9FSmO8PGHcuuYi1CNVQLVbJS/9958YXBE2ttpvedV6dqi4xGEIwimVsyfH+Fkyn7GL5C89TJZ7+132K5MXR02HW0n5197/hxmmuLX86VQgZX5qac7U2H3mDwxA5qJ1HIBJMp7VK8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhMwHM3dRPs8eOPcqyVufxoJcmn7NQqABrwQCps9oUo=;
 b=Em+FQt8JoSSKg6eV39qcZ9oyrQkEWBG/jvbY1+3aIz6dVTwxnzLPcr0WjKLXml6HeglEIORkLRlYfdUY9hbZV7dBM1uNsE3MurgV12nPEyHyldr6dRO8sqeA4Eye1dnzpmxgZLRq4EadfLm3LSMcSpmR3ogSeBrt4WzFaeqGCtiKDt3FWdFzEGDbn5H7GlzMi3EMU/fpT4n3SBWXR/XGV/Li4/GMLrx+CTT3FmLztcSHpDd6EhrKdMX1jYStiGZHHNlNmSsdiVByledJCqcUcqb6nh+Jap0bW2g5Y4uLuCCXypsuFSHRrgan7JZMwGZmDMZc6M9QqLPAbs2Z2rZo4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MN0PR12MB5713.namprd12.prod.outlook.com (2603:10b6:208:370::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 12 Jun
 2023 21:31:45 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471%6]) with mapi id 15.20.6455.030; Mon, 12 Jun 2023
 21:31:45 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: "Keller, Jacob E" <jacob.e.keller@intel.com>,  "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>,  "David S. Miller" <davem@davemloft.net>,  Gal
 Pressman <gal@nvidia.com>,  Tariq Toukan <tariqt@nvidia.com>,  Saeed
 Mahameed <saeed@kernel.org>,  Richard Cochran <richardcochran@gmail.com>,
  Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: Re: [PATCH net-next v2 7/9] ptp: ptp_clockmatrix: Add .getmaxphase
 ptp_clock_info callback
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
	<20230523205440.326934-8-rrameshbabu@nvidia.com>
	<3154076e84914b061de4147bb69b5fd7c224980a.camel@redhat.com>
	<1936998c56851370a10f974b8cc5fb68e9a039a5.camel@redhat.com>
	<87r0r4l1v6.fsf@nvidia.com>
	<3fe84679d1588f62f874a4aa0214b44819983dc7.camel@redhat.com>
	<87fs70wh7n.fsf@nvidia.com>
	<CO1PR11MB5089C523373812F3AE708A3FD654A@CO1PR11MB5089.namprd11.prod.outlook.com>
	<13b7315446390d3a78d8f508937354f12778b68e.camel@redhat.com>
Date: Mon, 12 Jun 2023 14:31:37 -0700
In-Reply-To: <13b7315446390d3a78d8f508937354f12778b68e.camel@redhat.com>
	(Paolo Abeni's message of "Mon, 12 Jun 2023 16:15:29 +0200")
Message-ID: <875y7se5ae.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:a03:254::22) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MN0PR12MB5713:EE_
X-MS-Office365-Filtering-Correlation-Id: 040a9a0f-f22d-46ff-409d-08db6b8c6baa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WQXh1dyhQPCdyjuPfffg425Lu9Y+k3DNvtzEEQQs4XAL0jKkQdIbctFbB/XJZBzCFsm+DrGD5qNKToymDjSiikQYko2NEsNPZwQ8AhuNiquyz11l2niiKoRvTAZzJOh36Mz7zp0lrsPyrHDnVsW29cCRCTed1QSft9eb4bp+vZ/MnFBnXVv+2bAVXfvNoc2Fyybhk+5Oh/9GeJAnwsYQOlBjhMTJUVFoZ1faP/FLVxq30Qse6lHlzx+uZ/Gk0m04QsUoi/tjbZ7Y5M8S2lxsxcOm/SS5y/S8b9kAyWrOClcihdVWypNnL4Dpa5DTurlrceBzgucEmAwwKmLbqWqd7H+M5rExMz9sLxdWktYmffxl6yi4i2egGFM09lGUAjyz3JGsu+K6HbSEaqmWqoUjSSzVPb0jgyrHmIN1u+sSa12hssy3pzCZMwK8jmttvzEknT4NsnyEzZNj4wB4xa2usnD31IrW0V5XgdeKcAPeW2ED/gbZ9nVTzSyqcsa5pjrlhhs4Z68uaVZ+EUxjYVGk9j0M0gnaBDCEZ6I0Oz7BTv1LJbX+ljd7lnspm/Hj0SH+0FWQ8YtxXy2TAlITWL0RrrAPbQb/7jUkTKWeMBmj3AB2ReCfBUb6MJaf/eBUCQNxN2nMT1qqb3fZPmCzaAYoqd48EJw0IlKWBvugIe+vvYT4OKS+92E8xLdMlVKbhVRy
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199021)(6512007)(5660300002)(26005)(6506007)(186003)(41300700001)(6486002)(36756003)(2616005)(6666004)(4326008)(66556008)(966005)(66476007)(83380400001)(54906003)(478600001)(66946007)(8936002)(4744005)(86362001)(38100700002)(2906002)(6916009)(316002)(8676002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QNshH0kaXCSROLTPfiQiTsPzIbS3ju+H9MGB0PMP0KjFVwpc9zC8YQagz5rP?=
 =?us-ascii?Q?qTV5h2uwOx8OBpBwxMddXLqVz7YeN9Z/BkBcmcoSUcqRJfSt6a2xH0WHHZSv?=
 =?us-ascii?Q?0lBjJURzH8+nTRHHJ3TamLD5Sv2vjN+sEyACQwgjmQfRcmC2M+W4YpzjJwCZ?=
 =?us-ascii?Q?Ya0KQrS1xFjK8wmTA0iyFgQucn3XbujpN88125zRVZkkOsIGYhG04MzDgdQg?=
 =?us-ascii?Q?N4D6eB2VpY7vsAZ08XRzO3r/2dW+5dNYA1hyPnBhJB1S3h+vfNWoFIZIDpXu?=
 =?us-ascii?Q?nnDTPBDFEXiCcseCWRsUrDQ9oCkJafukqYubvjfHBp1YiA1+G7AvtOv0lHBj?=
 =?us-ascii?Q?LwImLFthyuORVhHKlk7D0+7o1gw6kbR/M6AMlyDEeFMsAu59XiTK+BhCML5g?=
 =?us-ascii?Q?NTtjj6Q2D35sn4EiTeo2MZdpBrXT5820d8jz5ZQZaWWU4L9LNcBoFN/eirQO?=
 =?us-ascii?Q?aqSR2btc5usJ3UqgC9ybC+ALrtipXlRXuOR/fx1nLgkKJP2zQFIcJBVRPkrF?=
 =?us-ascii?Q?c7xFQ92zgXuU0tfvh1xq3rs8ZSqDa/bKdV+PXqg2AFTi+My1e9xJ5Dp2Y/Nk?=
 =?us-ascii?Q?p6mRdJCALPb41eNsvaHc5auimwtmP+2yZJ0Uh7XC1kFIOWiabHr8OiK1iz1m?=
 =?us-ascii?Q?HWMGDktpEYMQP/Auky5eoUUo1RYS3kON6ozKC1wjt3XIFxUXYhtot5HuzXQA?=
 =?us-ascii?Q?xbPADGnbk/sf7wTJuXSp3XzmyPcSA1Kjt5ISvWvn7kMV6mbckIgN13YNYLG9?=
 =?us-ascii?Q?3D6PdQTzVdETfrtDORj+DHlilzdl1/D7MuiScX92wVEhl+dIiAMwwrI8biaG?=
 =?us-ascii?Q?RM5F2OAuPUamve7alm+c13VHs4PIVFN1l01JT5C6S55g1bH4YKEFPhH5Tj49?=
 =?us-ascii?Q?2PqjfGxoha+/1s4g2o2ZtDHJqlyVQawlpB/Ha8jm8QQ+y2NfkcinFab+gL96?=
 =?us-ascii?Q?a4bVQ7HAilKPgfISCrBs9xGSkxCSFZSlXCVfXF7RwMmJBndqKcMDoHVcYu+Z?=
 =?us-ascii?Q?6qvbfzgDw42RO9eGpIpQPDWE33Lqv7wn0EvC1Eg/Nmx5JLztgk+lFWHiHedc?=
 =?us-ascii?Q?NcTuSKBeyu8kc2U3D6J5s0agkXNfbsIvrqQW1lG7Nk+sBWUT1+3ndkBJjVb4?=
 =?us-ascii?Q?MSh6xnUK0q8Xp5PQc10WOqodhU4iXWn2zo5Z1xiTntuFKdDlYoF6V2vMc2kh?=
 =?us-ascii?Q?8RLHSqOuxy/DQTOWPoSdOusmYskA4Z5cbZPi3guKMfSo164pl/5ssDdJPJU5?=
 =?us-ascii?Q?94J9QA7st1zxBOmcE7M4vLGAf7Z2VxMu+q7FbcqK8kBx2X1yAGFWCKbqwfKs?=
 =?us-ascii?Q?FjvzaZQLhRTf7w8teIjhqGVSJEsszJYlNLMX/N8mK/WvU+EUfpGyUFo8Uhdw?=
 =?us-ascii?Q?IYw5SR2RcKBWTJwAz0VsY3kC500pRpVwtstd27psp0P0Wt/QN/HrPl8Jiq/o?=
 =?us-ascii?Q?lR2Eir4ZmUvIyUjkLDevOGkY7aBwHSBszuR3p9b8/x1VD+Wb5lUS5bFtmgRx?=
 =?us-ascii?Q?FFtB+Mn7jr4Y6CiXLGLaPvjTmcu00TIYjfPnDaICjuE/pIinWF7V/FVcdRo1?=
 =?us-ascii?Q?H49BzXgbnN5ybmOQpVftA6pFBs7lMhFfp+AxvS6/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 040a9a0f-f22d-46ff-409d-08db6b8c6baa
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 21:31:45.0493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RJ2VIpxP5l6HUcZGincMHzIl0gqQbai61ynNYJ/w/DDEuDzJRyO6h23GL6BQq5wrTi55F9enta6KMDjLbkzYGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5713
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 12 Jun, 2023 16:15:29 +0200 Paolo Abeni <pabeni@redhat.com> wrote:
> Given that this is general agreement on throwing an error, I'll be ok
> with that. Perhaps mention the behaviour change in the commit message?
>
> Thanks!
>
> Paolo

Mentioned the behavior change in the following patches.

Link: https://lore.kernel.org/netdev/20230612211500.309075-8-rrameshbabu@nvidia.com/
Link: https://lore.kernel.org/netdev/20230612211500.309075-9-rrameshbabu@nvidia.com/

Thanks,

-- Rahul Rameshbabu

