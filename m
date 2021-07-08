Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9763BF406
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 04:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhGHCjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 22:39:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31706 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230195AbhGHCjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 22:39:37 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1682UFCu029620;
        Wed, 7 Jul 2021 19:36:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Z1cg8+vZfR9szlze3wCMfGO1+FtIRLwvMjgPjK0DBL4=;
 b=Gr/ewvF9HI431IhrC0t7otmGq8NoLd9vFW95k5WcrT01egM22yW0X2iNHOVw0wxOW5z7
 qplNO8HJ8y9NZzvjttgdtd2+dBS7SA8A/TlJpcnUyB/XK8BdSyZCaweJ3p4ku9nL9++e
 nS78DjuOiKTNcnA7+eHG9I0wjj1VHaeTMl0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39n5hy6c0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 07 Jul 2021 19:36:41 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 7 Jul 2021 19:36:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eWG9dbJQhALfTgDA1JpbobG9GOF3/JKhRu5JGLVZfwT9aV9wrPMpQHHznm/6VBzUJ9NZEA0oggZqKPzaEg3eUiYYWe4AIHDGTsm0QvfRESZgkyVxhdR1R2IjdwgBdAFA6UlaMfFuXTd5jwrUyrMk8nilrwhinyqJZSVTygk71YcMWjXrL6jp1ju6DKCh/oOTu4z5O3iuyVUnJqr+TsyNy4nRoDjspTmoR01S0ElFydDHEueSzW8vrgt4hQF5fY1HMkXlLw7mXpTxngfGtc7t6rI5+ZVq6ZYtNILdF45jIA2xIxuqDm1cIo1104uXh59D1hGqsPPFqIyEQpoZMnpHYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1cg8+vZfR9szlze3wCMfGO1+FtIRLwvMjgPjK0DBL4=;
 b=aWfjAzAhrRxqy2ehO/A7A0XIHYDk+xqH/Vzzyf0jEvIYidh214IG0+4VvpV4RI63gkPcv1hflOHadr62Z/IXhy5AYFFs8FauKq5/j+Ny2awFPkWLLE5t4tLPhXyOWW35lV4NCyrEMiZX6n/dLgwrfGhs6g3TSaJhHl1JxTlGUBsuRanmVJxFGdsjYvcsZOGG2PVRB96M/4iqPIJ66edpVceFy6MxGA6GQgLdwo5dOJt8NpjUk0fdvb9b59EKko4gzHHXw1HAmJ+gnaxp0sCG9cfXS2seND3mURWtn4ITRkyu2Sx+tG9yVozIVw1KDfBz5cukNP6zdiudwc9Bf/9TGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: riotgames.com; dkim=none (message not signed)
 header.d=none;riotgames.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4870.namprd15.prod.outlook.com (2603:10b6:806:1d1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.32; Thu, 8 Jul
 2021 02:36:39 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4308.021; Thu, 8 Jul 2021
 02:36:39 +0000
Subject: Re: [PATCH bpf-next v8 4/4] selftests/bpf: Add test for xdp_md
 context in BPF_PROG_TEST_RUN
To:     Zvi Effron <zeffron@riotgames.com>, <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Cody Haas <chaas@riotgames.com>,
        Lisa Watanabe <lwatanabe@riotgames.com>
References: <20210707221657.3985075-1-zeffron@riotgames.com>
 <20210707221657.3985075-5-zeffron@riotgames.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7ce4c576-6aa3-2b99-45e1-17f5720b20b2@fb.com>
Date:   Wed, 7 Jul 2021 19:36:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210707221657.3985075-5-zeffron@riotgames.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0263.namprd03.prod.outlook.com
 (2603:10b6:303:b4::28) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::19cc] (2620:10d:c090:400::5:c77f) by MW4PR03CA0263.namprd03.prod.outlook.com (2603:10b6:303:b4::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21 via Frontend Transport; Thu, 8 Jul 2021 02:36:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e79102d-582a-48e7-6eb2-08d941b93697
X-MS-TrafficTypeDiagnostic: SA1PR15MB4870:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4870C76A43CDC83E842765B4D3199@SA1PR15MB4870.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K9DyF9Gt7cD5TS3YBlcpNDjQFjUe99qXXoYXV7zao6KnVCIiufQ0EcUAzpPFN0rgUcfxo4Zo1ANT41jXqtDdVViohrzTd0Qd45VR2Dpkcfhwk+FIVL2i3EHdyTlqXfTt4zheMnSZDwB+zySn/sm3ZnDxOf8h2ZzY5AnTl1Qa9E7lrfdoq8aKXrz5QrMkbmSp8Szo3kcrnhpizglj7xA3ioXe3skkOloWH6ZCqMzJBwIqTpgW2QmwWuwXYY/b0DgQLmMitAoqmtv+2FM+4i667zafyK1yxVw480LYmgcL7l2yKB5cyMlm9W0plHg0sEIKhrk5R4b4+xVGbB4VeYDwctc6Ssfvjg3CXAF7BWOWuqEAhgFXLWA4xbp8Digm8JregoEsfdxlBwaXIEu8WbFY+5pypyROn2rQyWzcBjZmafykoKOSBPEdwxyAtyRyEERuKWvXKR1VJ3iU3iGHP9+J/KxaDRJNMfyK35qxRUFOMrA6TvoZouS7ixYJqfdTCSOkBy9NTya8OTM430AWSGaLTJB2l1lisr8wf/mUeaZkrrnrbNGWdDAySvHmGdtKxx7cqmvfBkYu8pD+Vf5ElT5sQwDovGrrld3N/jOjm65J1Up9lagLuEGoCCayBvRwF7sw7B/RC2tf/f/2oZjJjkua4ihNk8tu8A603HixIEzEFbuzB0RnVvvhll3uOWEkpQmUJeDteIXwJ7AcptwiN0mHSvCHvTGCzbdcvZuFP+3iWVA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(31696002)(4326008)(83380400001)(316002)(31686004)(54906003)(2616005)(478600001)(8676002)(6486002)(4744005)(186003)(7416002)(38100700002)(52116002)(86362001)(8936002)(53546011)(5660300002)(66556008)(66476007)(66946007)(2906002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bStwRVVPS05QUjIrSnJOaXAxQW9XQjArTUZNcDVORnl3NkxqRWpncHNmVk1Z?=
 =?utf-8?B?Tk5qREJGdG1sa0Z5Tit0WWdCWGVtdjF5VnV1VVlZdXJVcGR3OHVmZ1ZOR3Y5?=
 =?utf-8?B?anV1cGNKb3E1Y1dQZnE1VW4yYWZGMlR5aDlyMzJTVWViVHdIcFRuWDRzNlQ4?=
 =?utf-8?B?cEZjeEQrWDhXTGZRbENvVlRvSlp4S3B1RXEvSjJSYUJXakkydit0bkJsbWZU?=
 =?utf-8?B?M1IrZFc0aU9hMEZ6MmwzaXdTUCtMMGZNb1E4ZVdIZTc0WFFKRndIQlRLVXRW?=
 =?utf-8?B?anpIbUxRVEJmQ2VmNE9oZ3pQejBmQ05jQUdYdmhUT1dJc29LOU5aL3Z3Unh0?=
 =?utf-8?B?R1U0cGFmbHBzVVBvTlNYSGp5T3N6cTFhVlRyVUZvdCtId2pORjVlRzVMN3BW?=
 =?utf-8?B?c3YxZ0U0MXhUK2xNeDNyTVQ2L3d3WC9BQ3ZaQ1lmNzhPVGJmc09KS094dzc0?=
 =?utf-8?B?a3MwMUZzZ3RjOHFrR213QU4yaTZNSEdKK2pnYTVYQnpUSWZmTEM2d2h1c2h6?=
 =?utf-8?B?eWlsWDdodXBBK2VJM0dBcjYreTJGaFlxZTJmdGJWTHRzcEhtWkpRbWQ0UUFu?=
 =?utf-8?B?bzdlT21SM1ZBNklrU2plcDE1N09UZzlWSEhudkcvd0NpZHVJeEp4ZGRiU0hP?=
 =?utf-8?B?Snk2blEyemFhbVloT2YxaTR4NzVHSmdKOTRReVkycE9RYm0wTWJZMWZiNnpB?=
 =?utf-8?B?MnozS2dVcktsUFdRQU9iOUN0UUM5MWp4SXU0WTZVbTZ2SDJVM1g0VGgvTHFI?=
 =?utf-8?B?SFdMNndDZ3BwYUVMRkV6SytqL2ZhQkdtblZPVVl1dWhrSTM5WXZSQ0VWOU9u?=
 =?utf-8?B?L2YrMk5HTjBWdHZlenVrWnRWOGRlWUZYcWx0OFVLZ25Lak9mUVhVVkJObG9k?=
 =?utf-8?B?aGFpSUlwc1RKWk1wVUdYOWJLL2tvZjBDV3lYeU1mMkZIVHVzaEpIY1lKcU9n?=
 =?utf-8?B?cGEySFpxVzh1K3Nya0VvQzVnSE9jY3huVnF3Z1lIT29XQThUbEgzNlYrVEhU?=
 =?utf-8?B?d1BWNElUSU0wZGtLUW9jVk5zNytCaGFGalpMQXZyNUxxaHFWbUV4ZFV0UWxi?=
 =?utf-8?B?NGlmOEpBV1FKUHVnOUpuZ216U1QvR3d6QlZxTkUwVmtGV3BXVXpzZmptY0Fn?=
 =?utf-8?B?V09IRVY2TURnNHVlRUpvRGRCWDVqWDRpZmljOXZwM2x0Z29KUTF3OFVVRHZZ?=
 =?utf-8?B?NVJqdUlldmlTcVBGa2N3dXBqQUJGYkQ5TGQxNVE4d2hGU3hjRjA2Szhwbk5m?=
 =?utf-8?B?UFR3eEUrS2k0RkJsR2RobzRKVnVidkx5ZnVKMmUxUmhtL09ralRKWmZ3QTdU?=
 =?utf-8?B?RHRqQnlsbk55REdpbzV3SnRUK0JmM1ZJVFo4SVliV0Evc0EyRVFLekMwb1M1?=
 =?utf-8?B?RzgyYzFQSExNSzNBdW0wOXllU1JmRnlBd2crMjQra2E3UU8yTGlQQlVsY1No?=
 =?utf-8?B?RXBJS0VBU3N1UmlhVVd6akZyaTY5L2dQUEhnWTJCSHN0M2FqbXhDVnVvQ3U5?=
 =?utf-8?B?UElUeE83WmNGM1ZkM2J6WW52c3J6OGdXTzZBWXJsRVdqUXVIYXRlYjIrVEJC?=
 =?utf-8?B?eldpaFNFODNiOGdyeG9DN1VNZnRZNm43eG1MOHhDbDU5QVR3V3F4VHl6NEE3?=
 =?utf-8?B?QXorTHFLUEtGQi9hZklRUHU0ejJVbXEyMDI0VVRoUW94V0Y3ekk4ZktwU2FZ?=
 =?utf-8?B?VEdmdk5DTHdrOWFuM0ZQN1VoZnhHM09TZEJqb3h0WlZ0b3o1QnFtVnQ5RXdK?=
 =?utf-8?B?MjRVOFB5ZUw4WlFYWXFsMjBEL3p0ZzZwQi8xbUdBaHpicTN4czQzRWdldzFP?=
 =?utf-8?B?V21nZG5TNEp0Z3lkSklsQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e79102d-582a-48e7-6eb2-08d941b93697
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2021 02:36:39.1704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y4qksZSvphTf5HXBq5mth0+htx5KmqGHjLCyQxVqOOAo/c7Vg0sWd805tOYYfFMU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4870
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: oEzxQodJe5KmiflNB-8YePR-ARbdr1M4
X-Proofpoint-ORIG-GUID: oEzxQodJe5KmiflNB-8YePR-ARbdr1M4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-08_01:2021-07-06,2021-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 suspectscore=0 spamscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107080011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/21 3:16 PM, Zvi Effron wrote:
> Add a test for using xdp_md as a context to BPF_PROG_TEST_RUN for XDP
> programs.
> 
> The test uses a BPF program that takes in a return value from XDP
> meta data, then reduces the size of the XDP meta data by 4 bytes.
> 
> Test cases validate the possible failure cases for passing in invalid
> xdp_md contexts, that the return value is successfully passed
> in, and that the adjusted meta data is successfully copied out.
> 
> Co-developed-by: Cody Haas <chaas@riotgames.com>
> Signed-off-by: Cody Haas <chaas@riotgames.com>
> Co-developed-by: Lisa Watanabe <lwatanabe@riotgames.com>
> Signed-off-by: Lisa Watanabe <lwatanabe@riotgames.com>
> Signed-off-by: Zvi Effron <zeffron@riotgames.com>

I didn't see this patch changed from previous revision, but
my ack is lost, so added below. Zvi, next time, please carry
the Ack if there is no *significant* changes to the patch.

Acked-by: Yonghong Song <yhs@fb.com>
