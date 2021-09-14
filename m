Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F7240B596
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 19:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhINRIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 13:08:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13284 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229482AbhINRH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 13:07:59 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18EG3nDB009199;
        Tue, 14 Sep 2021 10:06:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=z3edpCP1mJkP8bW1OMjd5T9s3N9VWpyTdTjW2DHVkWg=;
 b=gy4ttw5hcKjNUDIDK6zGe4jO6KzfFpCwewKeRLs9JXlxfczIEqx77csu+8+PEi2iTOGO
 G6B8D/Jg4sCB9skonPApb4z6lZpT6E/PU/EvD3hVunKlkGqADQ3nNQALX7uOqP6rNl76
 xTmbRkpk1SSTjnHMglgZOKAsmoM32OobHn0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3b2hyqmt1w-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Sep 2021 10:06:18 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 14 Sep 2021 10:06:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzpZa+SAehXdUqPRLSpl9qrfOvHqrJqgCcl5bNmh0qz4CzWqx3+qQCFas8NAd3IehPLHJweKVDFNOO1T7g0jXV6FfQ8QyK3/gu5vmw9hoZuqvwhuoy3yXmNTv3ghf48bAvdSPcPsOwCkoSleH+OrCMoJLk8nRBaVcLIFky/2ywnYyCc9GELSv93AEZ1E7lcZD5522vN4UB4s2X/8+Jf+5LOKYuEusEjXDpez9Hrkt1VLtltCZ0DqgQHOpFJW+SFQkNbFSjAuavp4/DsFa8Mf7oUshCtKABI9H5/LkhbCDDk3LyaarFH3wYTYmxyPFVvGhn+RZd6RPJznMFW+27zDxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=z3edpCP1mJkP8bW1OMjd5T9s3N9VWpyTdTjW2DHVkWg=;
 b=T406KNAJ1Eq7XMLemJXTAQduZzk32MmvrupyTcO5lmSV7WGdymeE+HMtb1vNDd+akZ3dhL6gtDAk5yeEXdAafr+/GBBkW8wBblbLRoDUksgJ3sRrpDOt9K68pd6Cy/zoCwPyCzJr64d+B5M7fu78EkTwG02wcgsABfgPed5dOYFYavw1xX2daNPsxwBpTf+oJtiJdsP+mnWwkHcwz/OKSxN8G4bhgjZUkgnaotvlF5IuAvH9i5qvrmsU1OIxkJIHG8IIkAzAE5QzPcxGofmcvUG287npfUR4ONLOySZNnQW5v8VMO1h+dVLG7mkELnVHFJwnfloD+FUuGsGqNPI/fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN7PR15MB4174.namprd15.prod.outlook.com (2603:10b6:806:101::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 17:06:15 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::3c1b:1a10:9708:7e36]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::3c1b:1a10:9708:7e36%8]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 17:06:15 +0000
Date:   Tue, 14 Sep 2021 10:06:10 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hou Tao <houtao1@huawei.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf v2 v2] bpf: handle return value of
 BPF_PROG_TYPE_STRUCT_OPS prog
Message-ID: <20210914170426.zvdehrx5tdmgv2nw@kafai-mbp>
References: <20210914023351.3664499-1-houtao1@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210914023351.3664499-1-houtao1@huawei.com>
X-ClientProxiedBy: MN2PR17CA0019.namprd17.prod.outlook.com
 (2603:10b6:208:15e::32) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp (2620:10d:c091:480::1:c86c) by MN2PR17CA0019.namprd17.prod.outlook.com (2603:10b6:208:15e::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Tue, 14 Sep 2021 17:06:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56da05a2-013b-4d78-df3a-08d977a1f5df
X-MS-TrafficTypeDiagnostic: SN7PR15MB4174:
X-Microsoft-Antispam-PRVS: <SN7PR15MB4174CE92CFBCECA673F5280FD5DA9@SN7PR15MB4174.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kPwujr9xtQ8wUimFsGgp6FkIDSMp/rY5gHeIQQk7U++zlBhcZU0QHwQtTGJ10lqQEINlR69A1SVr4u0iose1KyHVxRAac07ucmdkbtb/TOpi/RhGTP5Mu/nvrO86a7m38mZ+q/eRST3wrwqrvvD8SjHf+EBRoGRLtIvDeZKjRfhpc06bUfHx8B0eU4WSGXvAbHU576JUFNpD3y5LRS1QJu/92scX2mwfoJiwCGIkcSqLgWyNkCGzLolsmlHVl5uRoAn6C5W+9KYNvG7BUZE6SevuTVX3+zbUemXLLV8gqJ2CSdzXU3bP0xYVYv0gc1S1Ss0kiF8kJlvuuUK3IwTGDdUwjEHEmVyGrJlupG5JY5SITfXPIN9odAIG0v6NiBIXVgsh2UHex6EMT2lWxr/evAwQuO5nug3TBV0cHASa5qHbWCjBIuH/np1D7DPw5tHZq9NMC/hFuabyF83Iyy/V7H1LgmwNgbsqIMPUIXnc2iD0eUsI0n2V9G+KIJip+kQQpFMOqxEd9Nynqxa6JnM5mGzPLoJhqDGtiskGC58xCpfeKjQwl0tq7r0CUgiO7qeuXupUZqNQABCIbvqCTHGREsZvU/ugpLLAOTo27IFpjsjv0sL0TYheRHNZ9hUJg8KgAGDHZu1RZzELS7Oeeu5mhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33716001)(38100700002)(55016002)(508600001)(4744005)(2906002)(86362001)(316002)(9686003)(66946007)(66556008)(66476007)(5660300002)(6916009)(8676002)(6496006)(186003)(52116002)(1076003)(4326008)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?deRpH3sO9phVNtdSOu2O5Ur2vGsAzfkjrSEvYBr1cf4/cKvBCeF6QgOliZxm?=
 =?us-ascii?Q?RUtxcRlRy+wp/+3nDp/8FBGykk+y5imPlsA3K819pgS6FS5bL5Yv5CkvCfFE?=
 =?us-ascii?Q?3dNOL3UA/bK6i+89nU9UsxCxzhWu7l0PZ20XB1qY6ZG1kaDCy5pINroOdCWU?=
 =?us-ascii?Q?C6Tp4afaWS6pYr4AbPxA1R8NRHAgZEEJ/AfPQ/U5CyqWJPYXTu0ElMI6DnmO?=
 =?us-ascii?Q?2mS3TlnHjiUlPAgfzfeZ4K0X0lmSrFVfe+gCEu/iXd6jjYr2r4+rCS0ecFwK?=
 =?us-ascii?Q?NQCx8vvB/e7cAlD9aYLJk4SYNbTkPv5ud/ZnG3nI4JICmLZzsEm0fNQdeVYj?=
 =?us-ascii?Q?JumLHjU5/Enl0mSVVCnc/JjdB8bV5AXa3Xa9lGsneWmO5hgAY3DpH4nclpWW?=
 =?us-ascii?Q?yMSOsf3QanvU+pI4BM/nyGPsdaaGIDAcAYhbakXaaEPcQtfgrcr04UZZ+/Dx?=
 =?us-ascii?Q?3DVDfMQqCt/i58EY7sVEWAk61TcFrDET6H/gCuOgIMBXIjpdeT2WXJRNvhNr?=
 =?us-ascii?Q?LlQnp8g+Nz8Mzod0WbtZk4EHcTZhJOwgDlNY5i9BMHarerH1j0fWMmoxfIpv?=
 =?us-ascii?Q?ua6ikNhWp7fYrlMl7xwuLP1K6ZyOBm3fGbdfrZpzzOrWXorqtmaF02wdGBNc?=
 =?us-ascii?Q?LL0FV897qLzDJ04iD22sK/PjUAWXXpLGvr4aqPq3j9g+9oUnQbe8FbzzQv1W?=
 =?us-ascii?Q?Tv7OAyxgjjsNYRnL+0UvUzEzEe6+p4sICFtfSTS9SJ7/BTjgbxqq3rUn77ed?=
 =?us-ascii?Q?z6D+ltllZCKm2EJ/fjJWq5RWaeyfvtvyiYoeAv5QPsN3nVmR/82xcEQTDutA?=
 =?us-ascii?Q?bk5rO1KjM7pdddrvIDCkZoGBTq8vCduHd4VcxwceI6IT3Uwy99diWzDKP9Vf?=
 =?us-ascii?Q?Wizpap+bPhyoy7zQKo99LuqCQL4OZRHauDy20S0xXRliOgx4uG1lctvuW3kJ?=
 =?us-ascii?Q?1ZW9CUmXZAAUH3IcNj9sEhtOuUo/aEr60aMxhL06Xzo9jVogTt1E+gTlhNz7?=
 =?us-ascii?Q?rpFmTAQO6tv3xNnuqV0pHUR/I+S11YOyT7uuXCD2VMT2Lb5ffaVkwN2pkK9O?=
 =?us-ascii?Q?2HB2CiqPKHwvks625xtrDnkX/pAGeeT5MKgqAtnXLEP9FMBUQT3WQmQTCrgG?=
 =?us-ascii?Q?0MHYIRLjQApK71IIqQ2x8vpTQ/uJDJYUvAwkgvJvez3o5GV1lf3HsSPTlQXX?=
 =?us-ascii?Q?acjrEGms7H7Wf7AKO/gXUEqvLWykmCol9XGGgrlNOm7uoZGSfyhJHlNrLDEL?=
 =?us-ascii?Q?ZGbV9xMmE3IzA198l7UTsixUvUXh2b75m7pSq+vYaLmDJIgN9dqzGw7kPsc9?=
 =?us-ascii?Q?VvdnQE7XYQmeuMrxhjyrTI6omlWCdGSwqpDGSFQeD+IBzQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 56da05a2-013b-4d78-df3a-08d977a1f5df
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 17:06:14.9439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eFDge25EnmgN32dfD4sE8xXJH1joIkxrgoqeu6AAeiVJUSPqT8KiDVPQx7JzR2sI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4174
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: pT_gfbzZhH7JMPuwUQaFfcFsU8eoMpXo
X-Proofpoint-ORIG-GUID: pT_gfbzZhH7JMPuwUQaFfcFsU8eoMpXo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-14_07,2021-09-14_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 mlxlogscore=392 mlxscore=0 suspectscore=0
 phishscore=0 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140099
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 10:33:51AM +0800, Hou Tao wrote:
> Currently if a function ptr in struct_ops has a return value, its
> caller will get a random return value from it, because the return
> value of related BPF_PROG_TYPE_STRUCT_OPS prog is just dropped.
> 
> So adding a new flag BPF_TRAMP_F_RET_FENTRY_RET to tell bpf trampoline
> to save and return the return value of struct_ops prog if ret_size of
> the function ptr is greater than 0. Also restricting the flag to be
> used alone.
> 
> Fixes: 85d33df357b6 ("bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS")
> Signed-off-by: Hou Tao <houtao1@huawei.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
