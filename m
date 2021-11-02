Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E47B4434AB
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 18:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbhKBRll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 13:41:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47934 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230214AbhKBRlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 13:41:40 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1A2FTLcr015785;
        Tue, 2 Nov 2021 10:38:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=9/erfujbGCfd7q6CTu1JJdOPYj65u07uNY93mcW0KuY=;
 b=hwffBtEJtNIAZmX0pQEqSyosHzqcqNK2M+QfGSdJXdvbqJuyXYdgKGAhZ9rQ379T//rC
 FdRWv6qhOjWPln2igf5chutmH3PV0UHuarYzGPHC1IeINsYcJ1d2aITFMbq26kjYP4CE
 dzHFchPW/DvYK5EjR3Ml9FKqYmEMiMwL5GY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3c2xy6vhvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 02 Nov 2021 10:38:43 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 2 Nov 2021 10:38:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hdeO/ls1K7N5pD/GEa9Da9bOXLHH+0JLUtQglM3BqrRrgjEyd44QgFzC0I/xNv8sSlbKJlo/K5ob/vHSlYPLhUGVndrhl0o60REWvloCf/NIdvF70ztLsQTrif3aaPULwn9NqvpPuLFohEsp7M35MivGP7xIZEwaBKS7gs6p6l4Esi9++AhHQrAJoK0GHlpR2R8mbwWyDGvT6H/CmwaasGa/+BvPQdxaplh9SsBu5RKSs4jhHoP3SjTq6/khib2nChKltt12xyNoJv7uixmRXylWYGQEIkUTc+60SrkqP6o31nTOh4MN4ON4LkP4xdzoDX/goGavc7WnG7DrliusVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9/erfujbGCfd7q6CTu1JJdOPYj65u07uNY93mcW0KuY=;
 b=laQL66hVhzknbRxJXEQRWix7VUbjnlwGCMhZP8//7CYMlmMwp2cv4z4V23JfLwZ2HyVvQPybAVlNihf374gJfWdQM74DIEA6fA3PF1gua6WKS8QL6tq2qLlTOBLAfFaeCGFEFKbMpzaUudPrOZvYIEmCmZo09JJac9GzRPM0SBW0A2Ulwb21tYM6Nzz+8U4ilwMOp4gnlb+V3ejAPdF0R+DsBG7iTS1afsqrl5sNUPnWLJlTsHwcPmYW4RkfpA5bn7GgmcdERdGaBZcfuP/9byJDPOztk1kmvSaFCJ/rZUJjcpn0YG9S6xc8TNYXsCYcuE1kc7XqwsTJN+s1r2+L+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4497.namprd15.prod.outlook.com (2603:10b6:806:198::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Tue, 2 Nov
 2021 17:38:41 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 17:38:41 +0000
Message-ID: <fe303090-89c1-ede2-c656-582a189f05c1@fb.com>
Date:   Tue, 2 Nov 2021 10:38:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH bpf-next v3 2/2] bpf: disallow BPF_LOG_KERNEL log level
 for bpf(BPF_BTF_LOAD)
Content-Language: en-US
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20211102101536.2958763-1-houtao1@huawei.com>
 <20211102101536.2958763-3-houtao1@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211102101536.2958763-3-houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR14CA0023.namprd14.prod.outlook.com
 (2603:10b6:300:ae::33) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e8::198e] (2620:10d:c090:400::5:2e35) by MWHPR14CA0023.namprd14.prod.outlook.com (2603:10b6:300:ae::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Tue, 2 Nov 2021 17:38:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 788820da-11fa-48c8-bdd4-08d99e279c64
X-MS-TrafficTypeDiagnostic: SA1PR15MB4497:
X-Microsoft-Antispam-PRVS: <SA1PR15MB449725D5006ED4732C4E1179D38B9@SA1PR15MB4497.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cXb7o/Pr3Xa/YDX8BLm8F6M9LJAPpNgHz4EIZOtywojcQQhxJz9LryEUvnLSpCWoj+s3tqZ4C9b5uuMcUuOf8C+lFGEkxN1CAVcIWXLAIodMeNJfWj9lL6GNKZdt0mIPBDl/0WlFJZA9r1P7jWxZn1KbCesEO3/4SqQZwagZzitnor/tzOnLHZjxnKIMrN0KsInsThhLuZI3Xrq15l7fNPIXjqfIKbOzhGU+MYGYVMYGJnE0sOMTZSvikh1IPel7d1lhrlcqtdNmY6WE1rwetqFIGx1Jcav+BNsZDoime/Hfb2xVKuC53UtLZRRlyJtLayOhsMCu39GS8CeyVoYHKYEV4CSBVtfkbNVbxEvVNhwPgOC5HT5kW9CP3Zmk+1Mjq4lx+cTyf/n4j29WSpFov0zfoU+vxnq6xeypdQB68psK0kpFAp5kFQC5lYqgg6qsP1ixVZM3a+o/r23ADlTYCLbcArbM7/dnoSzeA3kPLz+NmjXNQpZTc9gZ0khJEP0Gmc6eGdmcciOU7QFptwLb129jGxb1Gj/M7GEi0/uCqMZxjjB7ICTD6RgjN6yUGFPPo9iBB/aEK17KcU0B+a1tRWG3srYMCe0G0y14KN8BKYVtiKUnCVZWVgitfc5KTYo48KQjNxoAE1WOlijAPXrpAucrZ0vWNW2uJQ60Yz0pE02z0tqmHUCXypwAXQyy1kMf0UgwZmmiV0CioDIvcabOIZm+N/jZ3tD1kkbZ04k6UDTCe4AnDnCmnU8FPKq6Acnh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(86362001)(8676002)(53546011)(66946007)(8936002)(316002)(31686004)(2906002)(110136005)(5660300002)(6486002)(54906003)(52116002)(38100700002)(186003)(31696002)(36756003)(66476007)(4326008)(66556008)(508600001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V21vOHVkNDR0M3QxMnVhdmtZK1pvd21ZR092YlhpdDAxY2MybCsxRUN2eGox?=
 =?utf-8?B?MzdHanR0ZUE0dXRaTzJxdlhuZDhZaURhY2RmT0Y4RkNFUTNrV1dPRUVGamt4?=
 =?utf-8?B?QXBYSjBIMGt5MTZhb0pLcmIwVGl4TW56V1ZIVmlxcnhKQkdoeDRBZmI5c29q?=
 =?utf-8?B?RGVEeDArNWt5aTQ2RDdpSUVCc0prcy95RnVNMk53d3dqa2wvZXVTL2xUbWgv?=
 =?utf-8?B?Y1ZBZk5WbnhqVk1ERkltY05yMWtSUHA4VUYxMFBJN0pxemFxMGVvME5OcDBk?=
 =?utf-8?B?dUhacTBacTFKNkxBcjZTOHQ1RE5pU2ZoeTI2eWFUNWdBTWNzLytUWVh3SEJS?=
 =?utf-8?B?R0NzSEwvVG1vRmhFbzk4NkU3aUpnWW43NXRtalg2ODBxOUNmYThOU2tpVVdT?=
 =?utf-8?B?QXBWQko1UlZjL0hxZHM4bkd0RktQeVM0S1lUSjVob2E2UmJNVDBMSkU5R2lh?=
 =?utf-8?B?Z1Nmd3JBZm9mQ1ozQ25GdkdHVXYzc21JdlVDVEptbVZrMzBYTCtxT0RuRjdH?=
 =?utf-8?B?T0NORDhlZDdKa3RzUi9IWmRCZnJqemFEc1ZnRVRCellmUUVld1ZkS2dZODhw?=
 =?utf-8?B?R2ZrbDc2TkI1blN1N1dCNGxqR0MrTHE5RURhVFZZSFB6ckdSeE9ucnA2YzZh?=
 =?utf-8?B?bDdvN3VkTkJlZ2p4d0s4SmZsZ2xNYmJJOEZOUVJQVUxnZVRiMWhqaXE0dUd0?=
 =?utf-8?B?QU12b1RWWkViTzJJSm52aGlEVTY0ejV1bXQ2YjJDUXpmWmtiY3NFN3RMMEdS?=
 =?utf-8?B?NXc3WDYxaXpiR0dCL2k0bHJmc1BzZys2ZVQralV5WnNoY3M5MmxhRm02MllZ?=
 =?utf-8?B?WW5pV0tucnZiOUdjYUtKMUoyaklWOGUxT3d4TG1tbVFYb3hTeHArMlRuYVVD?=
 =?utf-8?B?aHUvdktDdzVheHo4emtYOU9VcGRCRnoyV0VjUWcycTlsV0gzeitDWHFDaTVM?=
 =?utf-8?B?RVBqNDRHYVgzWVF2U0dJdkpyZXBqSm1nUkp0MitsbndQLzIzRVV1WGxTb2FH?=
 =?utf-8?B?TC93UnBXalgvWDFzNEE3cUVZdk1mUjFsSWJPVURoTXJkbjZydTRaRzJxRkpX?=
 =?utf-8?B?QjNSVlFScnpUdm1WbHRIcVNpWnY1cEdhK1g1dzRwSERzRjYySUpwUmYzTG5V?=
 =?utf-8?B?dFBNd0djTHA2ek9iSlZDbHhncFNTbHNmbUZZaXNiNXlxN3pManR2dGp4a3hI?=
 =?utf-8?B?RnF3T09lYTAvQXdOYXlNUmdKempldDEwbHk4eFBPSmhMQ1dxenBnUGxtUFBZ?=
 =?utf-8?B?MzBrV3g4ZlJDMWFvd2taTjN5UkdJVFJJb2k0bE1zYXV5WXdQMm85RkFycERh?=
 =?utf-8?B?TU1ZRnRFZlJuaU1lU3huK2RwSzZjKzJGSWRQS1ZVOE9CWVlYQWwrR3FEeUpi?=
 =?utf-8?B?czhvZ09sQVJER3VBVjZYNnJQbUJmaTVTUUdIVXVvWFkwNjYybVdxTXdwS20y?=
 =?utf-8?B?ZWJkRm1FU1FTOWorR1NadGZNTllsTENaUkdQSGh1Qmd4eVhTRUE2bDNIWXpB?=
 =?utf-8?B?R3hHcVhnWVVaQkNPbmxUdVVIQXdIS1dHTVNGVDZBS09tenZMR0ZsNUFHdUFa?=
 =?utf-8?B?dXJQcjBFZDVOclZXWTdzaHBZT3NvNlEzTkZIaW9JY245TGVSNmNFR0ZwRmhr?=
 =?utf-8?B?cDRQUmdHalRudWZRZ1o4Sm5mOVdOckdoNXB4TVZ3UTI2Qjg2bThXNzUzdXRL?=
 =?utf-8?B?eTYwaE9SMG1OY1JtanZlTDJJbStzZnREdmdoTzRURlJ2b09aS1J2Tk1CU2w3?=
 =?utf-8?B?V0srbC93QnpFTEJyemh6cXI4Y1lmKzFmOW5aMHJxZEZHNUJkMGJpdVE5R1Rh?=
 =?utf-8?B?QUswUGZDU0hJbnlqcktEQUdTeE5FSnU4QUtEenBXajF5d08vejJ1V0dnYjN0?=
 =?utf-8?B?bzNoQk9TZE9SZlhxL3RRUGlKcm5ublhuRlpxdlBVUDhNOWE0ZGE1dlJXa0dI?=
 =?utf-8?B?eCtZMm5aZ1RJVE5paHVOVmUwbmdRNnF6SWxYS1U3YncraDl0YkEwaVg2bTNj?=
 =?utf-8?B?ZVU3UldvTFJ1eE5EdzMvNTNvM0Y1UHk2NEF6bUxMSlRVWkFXUTFjQzY4N05H?=
 =?utf-8?B?QUFCTVZQQzQyTDJneVhKU2Z0ckZvWW5RUDFFUGtSbkNXeDZaTXl5NDB6YzBy?=
 =?utf-8?B?MzQ3Y2V5NHZRbVhtN3pNSlpsSTdjc0ZNdHM5TTE3Rm80UkZuN002Y0hQcm5p?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 788820da-11fa-48c8-bdd4-08d99e279c64
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 17:38:41.6085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4R8Oe74ObNY5LnGgIqObEYGCj9k3iV3JROjVMdj13BhCl0Ha1n9m/h7olt4qr7xK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4497
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: p0IIFGL17s957sS_Hnymcctv3pCxJlWX
X-Proofpoint-ORIG-GUID: p0IIFGL17s957sS_Hnymcctv3pCxJlWX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_08,2021-11-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=812 mlxscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111020099
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/2/21 3:15 AM, Hou Tao wrote:
> BPF_LOG_KERNEL is only used internally, so disallow bpf_btf_load()
> to set log level as BPF_LOG_KERNEL. The same checking has already
> been done in bpf_check(), so factor out a helper to check the
> validity of log attributes and use it in both places.
> 
> Fixes: 8580ac9404f6 ("bpf: Process in-kernel BTF")
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Acked-by: Yonghong Song <yhs@fb.com>
