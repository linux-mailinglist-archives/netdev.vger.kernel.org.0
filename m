Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706E83B7ADB
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 02:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbhF3ALd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 20:11:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53388 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233056AbhF3ALc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 20:11:32 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 15TNsxkM004596;
        Tue, 29 Jun 2021 17:08:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=Dy10X6Y8vz9MrUep4YN3/0B5iH8icmzGacIzc05NVyM=;
 b=kToXRAI48DM0vpbKPWO23lDB0X3/KivBjnU4JfPhI7llvhaG739Gh1ITuWdqdlO/qmx4
 a5vUk7k79COF0aSqsTaSYF1Kilqrv9kPyydw0V6lVnJQwYFEnnEVL5j5MIoYgG0CmRlV
 21cvEKUEk+kmvVe0aOWD7MiNJaaCFjO8dms= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 39g0fcn4t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Jun 2021 17:08:59 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 29 Jun 2021 17:08:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aT8F1J1fI48/RrCVfEZP2V84+z1n/xcgkveMy7zy1eECac9K+KOUhGBefL4bcjiGYIrUnOw28bDZE6LSDThGeFVdx5+YsEuWLxSWvXXLSimluuJRLBdEQcDAHjIVv7O0YJ18cg78idjIm/CC1Bi6zEoqraHqiO4xV4nuGC5UshKbNwGj3uXVX705LEdCsGdALwMsIPrQsDBiOk6tVw0PlMb12F8TbSAMMJwlXyX+yPx59HNiGAvE683rlpK0PC0xCE8BSB3uMFNxTvT9ueVokKZDpf95Rve5cp59mPTOQIOGkoFadWr1YACSgiaD82c4i3EPquUDQFFYrmgxSQ6dmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jr951Kt505wY2CgLV1h1JimKSQU7jN2dq3aIwpMRP6A=;
 b=g0O/w5NcZr2p4S6OJaIbFiVIIgLSV8lrxs2vth7V5z+nysmCEsrwe7ussqP3RhaI5csd9FrwB8RGz7juG35/CAhX/G26NRchjKz1IqUXT9VifUqDPRozd+MshhjyluSUHDPUSIoLC2AOnwumMjPRuydw8sOaXGP89W+t1gYGESa2ZWCx7qh4VzHLysLE4XmwHrZdbg1ahlYggm23+pivADWBxGON256KoZhAgSn2YIZDIvoCLyQ/G0A3xxU/RVSVlE/nCsT+lP+v+4JHtVwRu1N3qJt5aarisxtxUd0Hr3u3TdABxYdgJEe/AMl6z/P6jBgGwS4NRPjYkLy4fdy47g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4821.namprd15.prod.outlook.com (2603:10b6:806:1e0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Wed, 30 Jun
 2021 00:08:56 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::803d:ce17:853f:6ba6]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::803d:ce17:853f:6ba6%7]) with mapi id 15.20.4264.026; Wed, 30 Jun 2021
 00:08:56 +0000
Date:   Tue, 29 Jun 2021 17:08:54 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH bpf-next v2] bpf/devmap: convert remaining READ_ONCE() to
 rcu_dereference_check()
Message-ID: <20210630000854.xfzf4rloihsiw2nf@kafai-mbp.dhcp.thefacebook.com>
References: <20210629093907.573598-1-toke@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210629093907.573598-1-toke@redhat.com>
X-Originating-IP: [2620:10d:c090:400::5:75f3]
X-ClientProxiedBy: BYAPR05CA0082.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::23) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:75f3) by BYAPR05CA0082.namprd05.prod.outlook.com (2603:10b6:a03:e0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.8 via Frontend Transport; Wed, 30 Jun 2021 00:08:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e408505-899a-4cf6-365e-08d93b5b40be
X-MS-TrafficTypeDiagnostic: SA1PR15MB4821:
X-Microsoft-Antispam-PRVS: <SA1PR15MB482166DE54661F3E119461B8D5019@SA1PR15MB4821.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lpg/Weo5+PeS69/KdbqvhKZ5RAwA1GqK3Zj1yONmP5EtruwQw6T+PpaBsL67Ncuutlex5AK4SNGM+3MUF8+bejFRhUAnTwMAx5xj02JRddEb2bz2gr/GwtNcf0D98PlPASrBHy2z802Wk53Cy1y8xHOpurNCGnYPcQjOKGNT7pHxXCO03u2ZfzBKql/vDPdUKW5llaLResuK8lFYVqiT9/6eGqpS+LYG2GA6DPREILBSvGrTTY8NpZZ9Vhbdg06quUc7bhDnoIW3xeZfVcwcMr2aURFohObJdBtXJvbO3/Vf0JnL8xPfynWK63FZU7iGAuROBmodd5tIl15tCxhCCeDZkunpAiHg5ZWSe9PYyEcCQPJsxiPLW/KYeK4OMoDIph+gWNMJFcR3QBm+nlwubDKUYjtVEtVj2qXn78eGI1zz/KARXewgXvpcdNQwUr+dNtNNIWHm09I3FwejOFy1Gi6qbAAuvbb2vYOT81pgmOBHw/eOgjp9atlGWCYveJW1/io+RSXKh1J9UJQOm239RpfcDpqDjXWttc+QPfanoJ0pJJDar9TERltcu2TsWEVjO7TO7pWQu4XHoqmh/0gQEbF/NqF53Lxm9LDwtrJDse2/c+D/dTjh/Jo06GuM+vRavMLvTH/rlgC5IsK5aDOrtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(136003)(366004)(478600001)(8936002)(66556008)(8676002)(4326008)(316002)(52116002)(38100700002)(7696005)(66476007)(66946007)(54906003)(6506007)(86362001)(1076003)(5660300002)(186003)(16526019)(6916009)(2906002)(55016002)(9686003)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?0RJfFBz77lLZKFHSzQjhtdszfiG26k+KX9F3NrdIbzexiECXlMHz2J3T3r?=
 =?iso-8859-1?Q?fcEbwSWA1W+ASViAFvAwNexzcEn4A2oQc0IvV+oR8ua7OmI4Al4/Mk9EHO?=
 =?iso-8859-1?Q?LnKTuyu5OD/apZZsn+GXpgST7DuRzCV/zInZEvkpGhifXBlHacK9aIlGrz?=
 =?iso-8859-1?Q?+YujuVwJ4XNCpN/9lW8yIQMcj+8amJvYvIvrNiQEz7V0ryyGPLGxcSSPlN?=
 =?iso-8859-1?Q?PbLHAv0Pnh6qWhvWizhDxG2sWhZzrAf4Lte/OJSXGU4G1dPOxLKraIUwVD?=
 =?iso-8859-1?Q?wu6E4/ATwllONthHRSmWKS/9OFoFVoTVxESbowIvKw7FX9cv1HWtiTwxKy?=
 =?iso-8859-1?Q?GJzZAB+FM2B4hD4kmuJj675F2yBqmucmgKC6TRq5EFVEVJEtW1SwzFJ80z?=
 =?iso-8859-1?Q?YeLfqBeAlT1L/LEQvDmmduYKZkV9bRk9V+WcNCUlo/UsbVbQ3OpSAKhSdf?=
 =?iso-8859-1?Q?R5z+F1ieEpNeUqapcviHNpQmqRtb6iWbovU1Z/syUcANTdToR5UtiRIgCN?=
 =?iso-8859-1?Q?Dcpe4auk/5mU3y5JugKJq0y+0vlIs6PjFsdjFiRygcPP84LazWmK4g1s3o?=
 =?iso-8859-1?Q?nK5bp3YYlxJwhFoKjthjQelvqOYhUC4RsASb5egHs9ZdNPF/LZyTTGlvTI?=
 =?iso-8859-1?Q?SFIze/VhrIInBxvFAeV81oIwpF2sg570AGm03ED67mj1FANT81l0m87DZn?=
 =?iso-8859-1?Q?S2GqITuJVbJPmf/iGv676b3RDAjxiHYqdyQLyvDoDI3WMs0AuLszBZuQcv?=
 =?iso-8859-1?Q?Nd3IJZ0YD5BVHLUd0OGuGqwdYrjcPoOeEKIClMa0DpaqW9oG7KwmbJ6Kst?=
 =?iso-8859-1?Q?HCsprRGGk3j70vL5mI9y5A2UCtg91In6Xicj/YwMYINwkeC/dzsxIGtRzs?=
 =?iso-8859-1?Q?pWjOqG7zCMg1XSLZFzJkcdk9wM9om0RwQeofxMI0Gh36MT5tNyMoF6U4IG?=
 =?iso-8859-1?Q?txzsu3p6Sf6wrebX3siSH5j+adQSOfPpRqhYE2JD5dfJ0tEspf/uBnyv7X?=
 =?iso-8859-1?Q?1UH00TYeGQyjB5KAH7naK1QzbYuNrMC/KDHxldIxHFxRNDWsfiUwo8QwGW?=
 =?iso-8859-1?Q?LD8XV0vL+pXabg0PXv8hwHfiF4sQtMhNYUA9yTgI0JftmEBUxGVg36bhP2?=
 =?iso-8859-1?Q?OySwFOHFmk3e1pk8qK/C5UoWzltvyEMBithXxxyM49Xa+pTdgeh7SRTrGP?=
 =?iso-8859-1?Q?nqSu1w1zRKzkZETELf4FjGeVPsjLwX0Zdmfsz1CVAtiy+zztASFHXdZ21y?=
 =?iso-8859-1?Q?nsRR+FfbMct3QQjfA3T+lP2cy+igUY4tepownnTIHKXTzP3r6/6zzOi9XQ?=
 =?iso-8859-1?Q?GFul4dbqFWmlX8FTkmurCgMzdAfHrIcn5QulN39/wt8ZVm1iM4pEgDYr0T?=
 =?iso-8859-1?Q?0ZSQEWwqFfAbDpvTKghcSKr6/W1ZuUJA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e408505-899a-4cf6-365e-08d93b5b40be
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2021 00:08:56.5469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qo3tVqC8UNNCiuIkFckD4F61TVHwFJ9TBCYqy7BeHzdi1DTS9yOpzajvzUC1W22Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4821
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: d0O_yTnKe4jCgQXbwMM1eBkV1N3p9NIz
X-Proofpoint-ORIG-GUID: d0O_yTnKe4jCgQXbwMM1eBkV1N3p9NIz
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_14:2021-06-29,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 priorityscore=1501 adultscore=0 mlxlogscore=923 impostorscore=0 mlxscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106290148
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 11:39:07AM +0200, Toke Høiland-Jørgensen wrote:
> There were a couple of READ_ONCE()-invocations left-over by the devmap RCU
> conversion. Convert these to rcu_dereference_check() as well to avoid
> complaints from sparse.
> 
> v2:
>  - Use rcu_dereference_check()
Acked-by: Martin KaFai Lau <kafai@fb.com>
