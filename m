Return-Path: <netdev+bounces-7212-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 789DA71F153
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:04:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E99181C20E86
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22E8848237;
	Thu,  1 Jun 2023 18:04:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC7C4701D
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 18:04:44 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CBE8E;
	Thu,  1 Jun 2023 11:04:43 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351E49O1022517;
	Thu, 1 Jun 2023 17:59:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2023-03-30;
 bh=mz4E83hQpPHqU4pY7XJmjrT3C70Gs/zTF31EIP2EIVk=;
 b=Ja90KGsGiXM/ManLpD5yF1vBIGKSBdLoWFm4uP6NySQwBU5Gd9mElPzLEhLWA/mNQQ7M
 sjsaJcOpR210S77wGUXMEvSHToXzkfV2D5V1S4Xd1OreCIhD2e3DHn13UxNcmh73Mt0G
 iU22LnitNiH5aQfydpy8RrQZSjMd5OTOGa1gbSOYqZnQ++XZLHFziRKFRMwOcugLBND0
 7a0NMHmpY/nRaouwCgBb7A0MTcDXPat6jm7DdNARA3JPYv7/LYDkOs0ezKlSzeyD5m31
 M/qFI3VhgjIAxRaGlMsL75AtuOFhdAea6WTWdGjhw46ZgMro5+bUgqDTk4zrfKgv1858 6w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhwwh9fa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 17:59:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 351HNgSA019750;
	Thu, 1 Jun 2023 17:59:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a7sj7h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 17:59:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BdSt3mYXNAtAj/jyhnOg9fGhXPhAuAI+VFscj2ll5KELE+3rLdVEfNXmb9fFOGQPTny3UyKAYEHOwHXkfpVm5E2olNOQlWYZ6a7kN+IbO1JXRoToFrBnNSIsGzciOpSuL892BT1lQaSR6j9VK96XQ0P04IKsqFNJb+zJNCXA6ApnvzG2G9z0IZlXGzEogFMcjxL/sNAf660Otx3RAdBunugN0sNM4FoDfYT0MUa+qaZgh6m83SWMOYioSBbYTR3wPVsQjTP4ZdJ9Rf0dwUZg3cC4I1ZAiTsr3SRJITVYjuMJEIsgWJsr8F7A5VuYh5TZrRoiyGQvOP1/sEEZQGyKPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mz4E83hQpPHqU4pY7XJmjrT3C70Gs/zTF31EIP2EIVk=;
 b=hTRBrWlTQpxsqmldrU7aYX+1GGbYruI3qrRRE6I0kvds8uVqWOYJ4AuCflS18GDWEG4xzWNug5GoxBXPC5PIR9vL+TnCvZrTlhJ0LnYPhvUHS4GczVDacJPO8+OnVweTIRSL+1gwZCzVKQn9TX7DJFq3U73/vjIN690CUWzPA1Itge/exhVis1vBRmZhhlI3dtvAApQdALd2s72Iq070nxTDo0de42nG4V8YQ8QUihIXg/lC+DQF747rbqywfSBaIeAWkHHf4YHLi8Icom2SeC3ey9cYXhZZ+EXyCSKGk7lgZJUfLt3CQpiZdCMheUhegla7kZp6YEDwollfQRlvNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mz4E83hQpPHqU4pY7XJmjrT3C70Gs/zTF31EIP2EIVk=;
 b=BvQuZHxiyBm1cDJjyrSPV4v7l10HjmRDriYTQUYdGKu+mNkx8Rx6c0TYsDVR42Q4Al4ufkdLsDknSLtyXIaVykhc6rdEl4Hwwx4V7VeNOC4CVEA/q7wCmnV7JYGjKfavc9NdNbURCdymBBCoFG0jZRZvl5cMrR4CfYth6djqDCc=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by IA1PR10MB6831.namprd10.prod.outlook.com (2603:10b6:208:425::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Thu, 1 Jun
 2023 17:59:13 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::998f:d221:5fb6:c67d]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::998f:d221:5fb6:c67d%7]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 17:59:13 +0000
Date: Thu, 1 Jun 2023 13:59:10 -0400
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc: davem@davemloft.net, david@fries.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, zbr@ioremap.net, brauner@kernel.org,
        johannes@sipsolutions.net, ecree.xilinx@gmail.com, leon@kernel.org,
        keescook@chromium.org, socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v5 2/6] netlink: Add new netlink_release function
Message-ID: <20230601175910.k2qdgidki7saqp7v@revolver>
References: <20230420202709.3207243-1-anjali.k.kulkarni@oracle.com>
 <20230420202709.3207243-3-anjali.k.kulkarni@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420202709.3207243-3-anjali.k.kulkarni@oracle.com>
User-Agent: NeoMutt/20220429
X-ClientProxiedBy: YT2PR01CA0008.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::13) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|IA1PR10MB6831:EE_
X-MS-Office365-Filtering-Correlation-Id: 8caa66a9-90f6-4f51-0c6a-08db62c9e899
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	vWT11ZMPtTGb5ZaajfY/RCYBp4RvyivWkBS+lnyIAPWDbaX4VX2eKJ3bbuS+hxmiFRJkwPM9u9gL9NH2xUM+WEFtp9VfZyoSPPTH92wNJsxmtVosBSF/qZfu5pNp6ZFRqxl/N6/xbl8JfA3h1UCL3GSLVresQ30qkMsDaKa8GDrcNbbGLvvA2oheuYmjPU9ZNn2oLqNZMiZ/YxEtYlZTtcJ4sRiIQQSErL3tE85ni6WHK0NuhcgtgQcJI1GgKS+5BQTKT/OZg7w2sL7SuSOnpKHpU5T6wEt6q3jUrj6ShLDTYZjj7jADyWRuYPCwU8awTF88dNyaQMVoLks8VtFUb2Yo4Z+Hv10YypyHXnwA+2Z5kRn8wAvPhoinQekU79pbVG4ap6Kf/Ey6QTWLmXifBpZzGzft0cRId/wBh3bPjuLgwzyj/hpBF5S2RtrZaH1BVTptZHY0MoFrtSRZkb9BRxH0tgHhfQrrVzVad9yT6KJ9KUQ6VFfhSv6eU3gWtIdEpEvY+ApU9+R5eWCds+A5BcoYNey2ngmjvsKwWXywXHcVW+YGWT++0FSaxSRhhQvA
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(41300700001)(5660300002)(7416002)(8936002)(33716001)(8676002)(6862004)(6486002)(38100700002)(478600001)(316002)(6636002)(66946007)(66556008)(66476007)(4326008)(186003)(86362001)(83380400001)(9686003)(2906002)(1076003)(6512007)(26005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?grxGTObONEShzcwS/sOW7nVwgN7MjyMmrlVTJWdilWRzB4mlU8NLv3zlWnSK?=
 =?us-ascii?Q?cCuaddLT/yA4i+ivnUm9iXBTcm2O/LK3UZYBgICYDpqxOhNAAsFKMDeioL1U?=
 =?us-ascii?Q?Ibqg2S11pZ8q3l0ODSK41oBvCNbesTU8f0A06LUXA8kB+2NpU0Ne+DCN3bJS?=
 =?us-ascii?Q?/o8+fhtWYR3+xDcztluBlo0ZvMW8shfQTMkMh93tA/bmcPwlw6rnphaNRh3v?=
 =?us-ascii?Q?hWiBjzuMSh7X74eb5iTlP7o2y0QtqyEV3MBI07Rh89x5FNUi8I7S30kIaVzW?=
 =?us-ascii?Q?AosgqxF+OVRexXCDYU4v1gklXhDG7NUupf7XI7jCnRZn0SBPSO3u4V+0pWvj?=
 =?us-ascii?Q?E+fiKb9Obmrk9WGYR2io+dnb4LcHPg0oIKSFWWuq0brQKh/1Ss15xutBrE2o?=
 =?us-ascii?Q?CXGG5WACJHl9VmoNfeuJ/cg9oUFjs6k7K8BjucIaJmTmiyAJxLExrmdaSmR2?=
 =?us-ascii?Q?CmwcvLysvYI8HxIkC2eSDmRliXbpPXYnppW3/lI9zE1j6rl5YAp2/5pz++PD?=
 =?us-ascii?Q?RFZOusdHz1jB/tjLrzilQI+NSFRFvGag1lguCdd1fGQ6HdmqYvChu+gBl+Fi?=
 =?us-ascii?Q?cpsQA79wsHWjyROq3PwC8IwPPKOgbE4meDMEsD76rDGCHmC1BQ6/a9aurlXb?=
 =?us-ascii?Q?yMQvcu8JOnQgKnCgoXG7qarmpfWoDJ5dD0AjcsCsVnrUiGpxaGnoYD7stZZb?=
 =?us-ascii?Q?qE4p7ExYOA0goyLLVLNFKu2aro6VI1RQ4pT4b5PKqts3KidMYhTeoXucLfxC?=
 =?us-ascii?Q?BUmrV7n3uV2Sj7/WfRzbLUB9SvSCsj9SOLFiRBH7vYnRcu3Mqsv1IBde91AJ?=
 =?us-ascii?Q?s6T0lZX3JY3ua6P9ORqiN90S45Vt8ZmzwpuT6nCa4kX/03bZc7S+CHUJpCYM?=
 =?us-ascii?Q?R77qRTKm88oiVCf6NLiqGs8JK/2lQTmr1yLY19z1OhhvubyP54TCPtUIDtgM?=
 =?us-ascii?Q?o8eZ08VCy+jMl0UP+1PSzqktiAbHTS1BvELDX102tKf43fepqThEZwYfM5Xs?=
 =?us-ascii?Q?bPhEa4D09IGnISRC5k6hx2BBsqbYgZxcOS0/hnkvyFiqOWX1g0jJmGJAn6Tm?=
 =?us-ascii?Q?sebltjigj4t9NHOUt6Nk4O+meSzBE7gYjqgTtsQb0ICCHrnGUIRgiJmJMEf7?=
 =?us-ascii?Q?JWoNfVmOTWPkkyG4wPbT/IzBiBlEMx3U0eV4Do/oFGqpBajQd6Ldg8YQA/bB?=
 =?us-ascii?Q?omqziZYjnuUcXfY4HmCczpM8HF6CPe6bh202IbdA+ZMwqKloLrK/a61EL3Tf?=
 =?us-ascii?Q?STA47S7DpWxKdsteWaLNRz7sHRRf1XutYozGf8nybyfvDtwhZT/YD50w+vrU?=
 =?us-ascii?Q?Now+rg7fwPoxs5XHQiIH/9ivu24Xgdbwiky/oyo2zkVDbEYffaSFoAvDnnsf?=
 =?us-ascii?Q?WsBOcamdK1mFFKuNuwtDul4L3+tqNQb87hDp5Jtzaq367l9TCnHkqzb3zz+m?=
 =?us-ascii?Q?B2OHs936cbbEx9wRxgTcFoq/79NvFEWiCL6akFBBBjx8uJ44iO2t+u9n+GqO?=
 =?us-ascii?Q?S1NzHlJ1KB2qRF/dHkJ2OltOWp3PX9RnOwyHPRvl7tQgRaJ20MSQSd8XL1HV?=
 =?us-ascii?Q?t5Whu7I2YR2Cajbd/dx2TB1REYlYd2jHBWqOg4Ti1C+x4cH3oHE9QzU1LQX2?=
 =?us-ascii?Q?Cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?tjc7sBGNGO6hsVFJ8qJszCajF9oUEBDB77V5mVMeQb5ABk98GCk/aRKn5vnD?=
 =?us-ascii?Q?G6VuICNb9xgk3nR+sILhhihCEg2YIvUeeAmWWwKS4OdpULxd/KVWGQJ+HOZj?=
 =?us-ascii?Q?TeFQjlY+XlDUQMkS91yadUK0HZmmbCmbPvuBjmaz8AvBqvXiFWgfH8F1FeiQ?=
 =?us-ascii?Q?8ivQRFO+Q/Z/bJ93GyeAVVI6htYos0AFrCKHrPF86RL5qwsg80A5MI5zQeWj?=
 =?us-ascii?Q?S48BZfUxntVQMaP4NW2aE+advXqIjpiYUr3ryzlw8t2loyXjkziDlXUUAMgj?=
 =?us-ascii?Q?rZBg7QgPMp9kYklaIXBS3liL04mD/monmbZB7cr/qNqiuB5GoRubUSB23+xx?=
 =?us-ascii?Q?gUuS56Tl6AVzte4ZEvd1ZWcnNyPMRxxwCzuXzCg8m2iW6fv0V20HGQEQ6Zo1?=
 =?us-ascii?Q?zr37Mky/mtVLR1nIEzs1dgbLnjS19WvIjnNL2+KgzFuBLR9XMYqf5srzjRHD?=
 =?us-ascii?Q?7AFbhrnQEPwRE1P9RsMjvpFpcy6Z/K2UIZ6GakTmddEWFsjYCRtf9PhlMscN?=
 =?us-ascii?Q?DEYoDWlTGGc3fvTWf0MXbgG2BQ2S3S1pP5oYntS3Iu14tEGJ7N3aJGa0RsyC?=
 =?us-ascii?Q?GUWLbPDCB4DH2S6LxFsrO0ob6HfKGlF6x70KsYtvkbPXgWrKXqgRjEm+qjj3?=
 =?us-ascii?Q?tLd0L6fGVKo6SPWssE4w7pZRfCdL0CpfHFRNo0joV7hlxA1wXzAOP/lTCfqf?=
 =?us-ascii?Q?jFtBh0MXZN3lMlmISQJt2lAHjP0gLoALFjxi4Sl8FbqoroNdo9X0PDHXtATh?=
 =?us-ascii?Q?sB/JVSD34hznTxAIDjhX8wl88N9FeXMOcdeQsr+g+Kj/xQnTRomMNy44w6fg?=
 =?us-ascii?Q?OETHaeaTbmLxojt8NQZtNSkdNHQ/2emlW0wsrQaIEPYh0bHb4mWwa6fB5JZv?=
 =?us-ascii?Q?r4/D6H+8OFcxR7eLNBCGelOuZ4IRn2V3OFH27jur5bozlJOyLhtrPcfPo4T5?=
 =?us-ascii?Q?TIOYcy8NgTyaKT+LXlNskvGmWMy+z36ASBtlpy1z9pqpk6UQn6lDvrKlbpwA?=
 =?us-ascii?Q?x/z8ftG9qcwFRJDUByoAAb2R2/65PJiNph7sMtZqWw+vbNk/bjnbVuc3Zpaz?=
 =?us-ascii?Q?0Yg60FWBsvjRt+T+ykPPIt3CST42THj5CQww+kOQJSnv+6F01JI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8caa66a9-90f6-4f51-0c6a-08db62c9e899
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 17:59:13.4819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KDn5GuEYoWM9/EaGimC/Yhx8PskoX+MPfOJimPi4fkBRYD5CJP0e3lAOn2AqxNNB1pzLIl5pxjQle59SyZQQ2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6831
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306010155
X-Proofpoint-ORIG-GUID: uNNUPv63FWh994ZkCjB5NNDXb4Y2JRWr
X-Proofpoint-GUID: uNNUPv63FWh994ZkCjB5NNDXb4Y2JRWr
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

* Anjali Kulkarni <anjali.k.kulkarni@oracle.com> [691231 23:00]:
> A new function netlink_release is added in netlink_sock to store the
> protocol's release function. This is called when the socket is deleted.
> This can be supplied by the protocol via the release function in
> netlink_kernel_cfg. This is being added for the NETLINK_CONNECTOR
> protocol, so it can free it's data when socket is deleted.
> 
> Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  include/linux/netlink.h  | 1 +
>  net/netlink/af_netlink.c | 6 ++++++
>  net/netlink/af_netlink.h | 4 ++++
>  3 files changed, 11 insertions(+)
> 
> diff --git a/include/linux/netlink.h b/include/linux/netlink.h
> index 866bbc5a4c8d..05a316aa93b4 100644
> --- a/include/linux/netlink.h
> +++ b/include/linux/netlink.h
> @@ -51,6 +51,7 @@ struct netlink_kernel_cfg {
>  	int		(*bind)(struct net *net, int group);
>  	void		(*unbind)(struct net *net, int group);
>  	bool		(*compare)(struct net *net, struct sock *sk);
> +	void		(*release) (struct sock *sk, unsigned long *groups);
>  };
>  
>  struct sock *__netlink_kernel_create(struct net *net, int unit,
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 003c7e6ec9be..dc7880055705 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -677,6 +677,7 @@ static int netlink_create(struct net *net, struct socket *sock, int protocol,
>  	struct netlink_sock *nlk;
>  	int (*bind)(struct net *net, int group);
>  	void (*unbind)(struct net *net, int group);
> +	void (*release)(struct sock *sock, unsigned long *groups);
>  	int err = 0;
>  
>  	sock->state = SS_UNCONNECTED;
> @@ -704,6 +705,7 @@ static int netlink_create(struct net *net, struct socket *sock, int protocol,
>  	cb_mutex = nl_table[protocol].cb_mutex;
>  	bind = nl_table[protocol].bind;
>  	unbind = nl_table[protocol].unbind;
> +	release = nl_table[protocol].release;
>  	netlink_unlock_table();
>  
>  	if (err < 0)
> @@ -719,6 +721,7 @@ static int netlink_create(struct net *net, struct socket *sock, int protocol,
>  	nlk->module = module;
>  	nlk->netlink_bind = bind;
>  	nlk->netlink_unbind = unbind;
> +	nlk->netlink_release = release;
>  out:
>  	return err;
>  
> @@ -763,6 +766,8 @@ static int netlink_release(struct socket *sock)
>  	 * OK. Socket is unlinked, any packets that arrive now
>  	 * will be purged.
>  	 */
> +	if (nlk->netlink_release)
> +		nlk->netlink_release(sk, nlk->groups);
>  
>  	/* must not acquire netlink_table_lock in any way again before unbind
>  	 * and notifying genetlink is done as otherwise it might deadlock
> @@ -2117,6 +2122,7 @@ __netlink_kernel_create(struct net *net, int unit, struct module *module,
>  		if (cfg) {
>  			nl_table[unit].bind = cfg->bind;
>  			nl_table[unit].unbind = cfg->unbind;
> +			nl_table[unit].release = cfg->release;
>  			nl_table[unit].flags = cfg->flags;
>  			if (cfg->compare)
>  				nl_table[unit].compare = cfg->compare;
> diff --git a/net/netlink/af_netlink.h b/net/netlink/af_netlink.h
> index 5f454c8de6a4..054335a34804 100644
> --- a/net/netlink/af_netlink.h
> +++ b/net/netlink/af_netlink.h
> @@ -42,6 +42,8 @@ struct netlink_sock {
>  	void			(*netlink_rcv)(struct sk_buff *skb);
>  	int			(*netlink_bind)(struct net *net, int group);
>  	void			(*netlink_unbind)(struct net *net, int group);
> +	void			(*netlink_release)(struct sock *sk,
> +						   unsigned long *groups);
>  	struct module		*module;
>  
>  	struct rhash_head	node;
> @@ -65,6 +67,8 @@ struct netlink_table {
>  	int			(*bind)(struct net *net, int group);
>  	void			(*unbind)(struct net *net, int group);
>  	bool			(*compare)(struct net *net, struct sock *sock);
> +	void			(*release)(struct sock *sk,
> +					   unsigned long *groups);
>  	int			registered;
>  };
>  
> -- 
> 2.40.0
> 

