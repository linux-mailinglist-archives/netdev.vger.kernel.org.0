Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984B14659A4
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 00:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353758AbhLAXLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 18:11:49 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22122 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343909AbhLAXLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 18:11:48 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B1LchUx026351;
        Wed, 1 Dec 2021 15:08:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ONT9od2zryHjZ8r4PfyiYo3uprMiyfiaYDv7dNZ2NE4=;
 b=APa0Zxdb9nBJq52FKmSVNzmwqWjh7069LMsNzcuwMldas/FMb3uolbRvIMc9AhRYJQo6
 kQxV3c500sF9dK0NC846JIClytZzqQjZm3nHzvpMyrFzp7NJpJooe3lDQmeB/6mIB7P8
 BgNCzuDyOPyHmrY2e2WM1w7LO1J5x+vcvAQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cpd6atj8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 01 Dec 2021 15:08:04 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 1 Dec 2021 15:08:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/IMk3YNdAGIj2l0Wvfcj9ptROyGTsJp5wzwuSNiFGnkfGFTPV2F0HhfqYZ1Xi6d7F8CALepYb94xOBtMT2t6j/t7w3fcn3a58al38AhYCsOyDs/aWgX4tGSX54JDOgpJlYUmfCwHnbfMp884pAm9qpQF/EBfD8tv7sqfWtNjuK7ZPnngb40dSaS7Ee1+9SoVp15NyFs/NMuH2tlHVclzfo6vfY9Av0y883Vrejvdon72YeMeoo0yGRv3TbWCZf2Viy2XsIl1JHckf8qVsyXS0aWPOS9pJx7AZc/LZmBYMxsn1gQPwdn1YgQuMTC80CSTWW06fRfs0IxXI4+BW1PUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ONT9od2zryHjZ8r4PfyiYo3uprMiyfiaYDv7dNZ2NE4=;
 b=fCmDkolMeqv9sYhOadHjiYd3/baf0K8X8OTRL+m0l2FQetctykVZkI63t0UFHg9IjB/oOnqkG2LDTbWxQ4Jpfq7ASjsFEocna9b2xmjPHhaANm8MbDqvmIUIHjWv8ZREW4JE9NaeHEx4mPvVtOWUg8di3CWo+ukHM/Q5IFOECz/xPRV94wK9kj5Vs0ZHknC7Py+61jlkp1/iEEGEGhhqsdD3hevdC/8YZ1CH3t+vgyakXeAqYzQ4zGYe83dcNVqEBsLt1lOojT0LiB1VhIhHzty0ZkfHOTJpoIA5NM1Vefm0cA2kRuw56pmeK/RWZKkpKx4ukJ9aNw1HP9hT9K1UaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4570.namprd15.prod.outlook.com (2603:10b6:806:199::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.15; Wed, 1 Dec
 2021 23:08:02 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%7]) with mapi id 15.20.4734.024; Wed, 1 Dec 2021
 23:08:02 +0000
Date:   Wed, 1 Dec 2021 15:07:57 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC 00/12] io_uring zerocopy send
Message-ID: <20211201230757.fuhnhgtbx5o22wgs@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1638282789.git.asml.silence@gmail.com>
 <ae2d2dab-6f42-403a-f167-1ba3db3fd07f@gmail.com>
 <994e315b-fdb7-1467-553e-290d4434d853@gmail.com>
 <c4424a7a-2ef1-6524-9b10-1e7d1f1e1fe4@gmail.com>
 <889c0306-afed-62cd-d95b-a20b8e798979@gmail.com>
 <0b92f046-5ac3-7138-2775-59fadee6e17a@gmail.com>
 <974b266e-d224-97da-708f-c4a7e7050190@gmail.com>
 <20211201215157.kgqd5attj3dytfgs@kafai-mbp.dhcp.thefacebook.com>
 <66dc5bcb-633d-efe8-0ccc-dcb97d08769c@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <66dc5bcb-633d-efe8-0ccc-dcb97d08769c@gmail.com>
X-ClientProxiedBy: MWHPR12CA0030.namprd12.prod.outlook.com
 (2603:10b6:301:2::16) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:785f) by MWHPR12CA0030.namprd12.prod.outlook.com (2603:10b6:301:2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Wed, 1 Dec 2021 23:08:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c9da206-2e49-4cdb-cc37-08d9b51f6c72
X-MS-TrafficTypeDiagnostic: SA1PR15MB4570:
X-Microsoft-Antispam-PRVS: <SA1PR15MB4570D53D9AF58AA9669F71A9D5689@SA1PR15MB4570.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v7tKsbjGGUm6m6K1pDZ2Gogzv23qpcsE3du4YjEk9yEYU+4vqa3nCtq9RHXVuQ6FBHVwWaFCf3+a1Ch2B4rD7HAwJTUpwLML0oy46zeldkWsUDjySVB+WisFneIxrD7aOV+YN4ZXGVgsF+m45eAMoQAH6yO2IEh505yCgFpO84orkmNaM2Kdy1PvRc/B6/0Oi+AUzE+cAVT2BetmnUJJ5x/rYyaLG8QFeC1OiMGwXNNUbgXo9EQxq8qGc3mWbOWNFVmbPpdfv6vL7XMkjDqYKS2UIRodu4iN4wKhNTz/3bLsIbfQaS+deGhwlhdzoSC6ORFuiT7cRMN+Zh4fo2f6SFhAb1N3TAvOtpDeaCwxcZAA2E6IkFeZZQ9U4CVpKZd4TL/KUfETmT1s7HuSsnwZS3nezU2Ex1R+2maKc9AvMJuTeXPv8V7H+y73GHxM2QLIA85vngP9gDbWFks9H36c6JnKXJdYrRua1OVAVCA3Guncclld1yu3XY86RwlmSmpteD+KuH4gUz6CuKbLgCZ11vGvTa5YiEakypXWgKnRqJMjYvzPGPKJhsuIS/wFNUpXj4OeaxWcltNPLBOgWw2TxfvWpJQ88w9L/nKMI5e5L3OyOpVu9fE0o+DbOzomcsupNrs568BMmzL3JpT0Iq+QXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(2906002)(7416002)(52116002)(316002)(7696005)(8676002)(8936002)(38100700002)(508600001)(53546011)(6916009)(6666004)(5660300002)(1076003)(66556008)(9686003)(186003)(66946007)(6506007)(55016003)(86362001)(66476007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6mWCx2Qy+Of4E0AgWamaZMHfNZXi+zOOgkMbUjkPSFdak+/ch3ccC8hEvbSt?=
 =?us-ascii?Q?lVEhFUnHp41qeDMaF4P2zsR3BD14nMotvuZXjzhubFopVkSWPE8DhegmqNmc?=
 =?us-ascii?Q?DbtY80REXqG0IBKgie9B8eEafFTYS2sVRlx+SpZdJ9w0Gfca8YCi7x3hw/kt?=
 =?us-ascii?Q?ysbQlQ1dOAjyaCXEFRuEhQe4eVD5Ne9H/3hyRPECKgccw8dhPsmokurc9AUa?=
 =?us-ascii?Q?XwCtmo3gvQNG08xB8d9OyxiDmKwA6iIT3I9EWHppDFzbqeQw3k0Wn9RCxkX7?=
 =?us-ascii?Q?6nIploBDkpyD4V0vU6vexlIo6o0UMOPTrLeKy3EuRLyzjn/trM1BU3fgaapd?=
 =?us-ascii?Q?ToypVEg1ZQQ23yodnl/IxBBJelfU0pm/+Cn3LFum/z+nKUYqsIyZZdESdI17?=
 =?us-ascii?Q?hCNcf2boz9So2ziORh45OSDP+bZYiMD5mi27PJLOQ0X73SKIVlEb18WlPyra?=
 =?us-ascii?Q?qT2DfmHxsds0zPrnYifI6sPGuv9ykJYv2YcnFe/FfVPapO8ubMKFdfoc+XJ+?=
 =?us-ascii?Q?azB7Ck/JcBcW/E7RKRwERZuCbpiCOv1g5gtPhn+I+/c4fc4uDXQqYtBYbasx?=
 =?us-ascii?Q?bCLzYDmK3maJahP5oDFSorosjUvxpeMUcJOFXK9iDFXZf2cLAKcjllhGaGo5?=
 =?us-ascii?Q?oQkclfQXHvJ9zMZPLm4FRV0MH83ldHm8V8d5IbVXFPOmM2oubkxXzr36EgVD?=
 =?us-ascii?Q?ptoylteIa92TvUnsPd/MiJwCbG6IFmU86C1UElmcCSs3TNQ00q3kIszb6JWc?=
 =?us-ascii?Q?urTptDI4BDQyRhqkkwG7ZDbzPuxgfY2NHoy0vzodYuyx+r8XMoGpiLuEOXbM?=
 =?us-ascii?Q?ZGB0Ne/L2jUb6s64p8bOgtc89gowouMbNKPgg/l880TT5zUlQEo17BekzYBH?=
 =?us-ascii?Q?CQVFfThTT9KQgluMlbOp8ATwSVGS3fVp8UGfL02YQcqHJJbQDzthJYISlpFf?=
 =?us-ascii?Q?Y1+NBwMm5ym632DPwWUO1zXf0pLltjLkcdhEJs+1PrOTQdPXP59aZRchRDMM?=
 =?us-ascii?Q?snxqtlcKQ5EPdVo26YbPM+NJvUzoz5fwzXTuxj2frsgUyv8nLZATajTR7sGh?=
 =?us-ascii?Q?lo9HQ/swlA619TSRmAQlUIdD1cWUI6cfgV9x/U7PMcUAJy05T4a7hXu7N337?=
 =?us-ascii?Q?B8PJD5mwl0DQkdTBZu96wV89m4gXSlxLweQZNJDbJUtkHrwsEpJObRSSKb4n?=
 =?us-ascii?Q?lKRL/QAg2tNqOShyycPzHDjO7TIdrdp3gHLL2z1w1wa3HZZRZKjMfqztpSEL?=
 =?us-ascii?Q?Lzwe7Y5TVB3v685qwMqBeou9FZSsPBizSe5ky/8ogtVNsUBj5LZtz3aFbXn5?=
 =?us-ascii?Q?eA90RA6xLbsRXuQaiLonFltSMrYLav67ooCon3MyybQqgt/hKGPrIV9hHyTO?=
 =?us-ascii?Q?nrMNlvbhP7Kxwg2vFMz0jpWOH462sxSU6MAdj+bt1mBK92oFQppsgG93qDXL?=
 =?us-ascii?Q?RofI3vtbin5bv56l0E5ltO2OlE+DeK/ejNrg6gqwi2ZMx6gODogNDfDJDWoF?=
 =?us-ascii?Q?RACU7f3jIkj4mLgpAxrgcJAdue8CWO7q7FbxydaEBAktWzmUv8pXGilv9wSm?=
 =?us-ascii?Q?zkdCu3/2x+O6gUKeKp2FBoFLzv2FPZ+mGjXd9Mbd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c9da206-2e49-4cdb-cc37-08d9b51f6c72
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 23:08:02.0002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K5ufBzqbKgpStkMhG2ULYgcg9nhMrmpRZJsId/FN1vSUn86er7As7k9gyzWBuxP2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4570
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: SU45K8Gaih2nBGhMPlqaTfpLUZYXh6Ge
X-Proofpoint-GUID: SU45K8Gaih2nBGhMPlqaTfpLUZYXh6Ge
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-12-01_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=263 adultscore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112010121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 03:35:49PM -0700, David Ahern wrote:
> On 12/1/21 2:51 PM, Martin KaFai Lau wrote:
> > 
> > To tx out dummy, I did:
> > #> ip a add 10.0.0.1/24 dev dummy0
>               ^^^^^^^^
> > 
> > #> ip -4 r
> > 10.0.0.0/24 dev dummy0 proto kernel scope link src 10.0.0.1
> > 
> > #> ./send-zc -4 -D 10.0.0.(2) -t 10 udp
>                      ^^^^^^^^^^
> 
> Pavel's commands have: 'send-zc -4 -D <dummy_ip_addr> -t 10 udp'
> 
> I read dummy_ip_addr as the address assigned to dummy0; that's an
> important detail. You are sending to an address on that network, not the
> address assigned to the device, in which case packets are created and
> then dropped by the dummy driver - nothing actually makes it to the server.
Right, I assumed "dropped by dummy driver" is the usual intention
for using dummy, so just in case if it was the intention for
testing tx only.  You are right and it seems the intention
of this command is to have server receiving the packets.

> 
> 
> > ip -s link show dev dummy0
> > 2: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 65535 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
> >    link/ether 82:0f:e0:dc:f7:e6 brd ff:ff:ff:ff:ff:ff
> >    RX:    bytes packets errors dropped  missed   mcast
> >               0       0      0       0       0       0
> >    TX:    bytes packets errors dropped carrier collsns
> >    140800890299 2150397      0       0       0       0
> > 
> 
