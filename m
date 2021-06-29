Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD313B6C21
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 03:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhF2Bsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 21:48:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56400 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229933AbhF2Bse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 21:48:34 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T1iAI2020136;
        Mon, 28 Jun 2021 18:45:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=l1ClqTCWMEB4DyPqbj3QSIPsYdqIadFiDMTvOFYyqLc=;
 b=rTW7MPsV5HOTEifQAq81jO8F79X3rBCiuMHwWAitZmI3QLLZJiAhTEHR3qYE33ZBXUNj
 jdlkEIwm7BLd5L7qHx8CLo0tepo8dHBX5kmhapUqkLzz8RS0FzKC9ucDztOVoMvDxX5S
 TL5oMLr+825VtgNqpx4+trWGKRlWAHqEgdI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39fgj7bwgj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 28 Jun 2021 18:45:50 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 18:45:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gv2hE3ft9xvRUFztSOUpqRAmp5/7uY1WriUIY5gBdNJOe/CwwWifHg+y7OFjexxgdkSRQm5XJfJjxMr0KJ1HUkYe4mwRzUDD+f69MZlU7PFZb38MhdIm9qQ4frmWJHJEsl/HGLLgPGn6feP65U/5TKqWnfxjRsfdK0x7Ktckti2XFE9vMIawmL85aumtoP3Z6qsTdxxbFNF7xSbJIYjBOxGrJ7gOMc4UHKejIxv9OWVP3Svo3CKVSxESt1HYsefTtngwHs6PH6C8B94UwV0gM4SPxmBm6b4b6OZJAV/wGAkvVC7gXVumNs9AJLDq5tJw8sMLDjYLB052qEyjvyFEeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1ClqTCWMEB4DyPqbj3QSIPsYdqIadFiDMTvOFYyqLc=;
 b=QnJdIpgjJ7ovQ5mgwkeg5avU/CszJoCM5BmBT1ea5V7swkFVzYdFhxXD7SlTuB06QfcrwWFI1KmRikteoyaFc77knf+DYbxg6ZQKEPpZfwEvj+2jDk7rJtfLROk39VQ4jfAdp20cNjUUv/Jjy8w67EawIcIGpQR6MTX9zQopNFzGLXqoPIQNhF2HS090sSih6zvwJqJMRi5o8IFM9pywWZAGRC9QBxf7xcz61dMVeG1wYgoU5p4cwSdNFF3JA/ABsRK8G3RbtEaLz3WPuoTUIXr1+rSWsr6S8hyUbwh03Cx5upXAupymZKwFAS3pFCdsMQWWmRq3NaPUh5rRGKGt4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4340.namprd15.prod.outlook.com (2603:10b6:806:1af::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Tue, 29 Jun
 2021 01:45:42 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 01:45:42 +0000
Subject: Re: [PATCH v3 bpf-next 3/8] bpf: Remember BTF of inner maps.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
 <20210624022518.57875-4-alexei.starovoitov@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <71642ba2-5fe9-70e4-69c2-bc2baaec5687@fb.com>
Date:   Mon, 28 Jun 2021 18:45:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210624022518.57875-4-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:b3c6]
X-ClientProxiedBy: BYAPR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::27) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1a57] (2620:10d:c090:400::5:b3c6) by BYAPR05CA0014.namprd05.prod.outlook.com (2603:10b6:a03:c0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.8 via Frontend Transport; Tue, 29 Jun 2021 01:45:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc02a199-da54-4187-6e90-08d93a9f9a9e
X-MS-TrafficTypeDiagnostic: SA1PR15MB4340:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4340E51824C10A6A1B6CD984D3029@SA1PR15MB4340.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uRM62gFLSFErYfeXAZO4HnWI8bkEHHQjt9reRiXIHtnSNIJ4TeHFk4dcQTHPgyK4HnZYXpZtrAbxo09kQn7npkosXX6uHIB1bKK8lZ7Y/oIT6P4dkVBVQkcJOe2qIr0nLI3gbAKDNypMe6YR0B94sK6akHrohZwTdKCNcprj+7bvAeBhsIB4z7nJOugYhIG852v3GxhNwMMckn4zYy/msB3g40hYFsoRPxUybvpcjDUQO/7LVLIvrD3U/8hYVZsxh6NEWJlikDjqp81B+9xH//QOmybyzHhlb55zlkSYlfAFGgq0RiUkS0DQrv+dgnT6uj/FuJpvZIHETeURqb6e9CCrXSh4MT/qJucQy3/BhLzhB209AbaP72nzhOJ4YFX3quJJBKDXoLqA3OkVCh6eJP50aQlAWbT4og7VseGAi1FZe2D6vEKGO2uEh1gYqytuHJDL9FzmilI2hyOt9r541/cj4yYKLrSLsz742yOnBrG4LliYiTVPnqiJ+PSeQIuCUrSI105NcNSDf6fldK/oB7Sl62hHNfbjb5SY4AEt7VRkiJiY3rnx2qq/lnbFDF8ZT2FPzUOeGzUDGdgFCgQjGokR6NNjVCkeWw36W2pjge4pJXHgcXS1ALCcc6nqEVtn2tddIAZPf7Xufk4EwHGLL8Dwyc4biSuxoUtJv+vaqdiUx+z9YM4yXXBnVG2Ast9BP4FF3cfIJQufU9fwVa1rjNE/xWyALF5/YCFUQXPuN0g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(16526019)(186003)(66556008)(66476007)(8936002)(4326008)(8676002)(66946007)(2616005)(36756003)(86362001)(6486002)(31696002)(478600001)(31686004)(52116002)(2906002)(5660300002)(316002)(38100700002)(53546011)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aldkbVpobHE4M1BXbm9WTE5jWUxsbUJEcWpXdW92WFM3Z25yK3hTQWJremZm?=
 =?utf-8?B?Tk5DUUQ2NnZtaXVTOFlVUWRVc0VLT1NTVHVZbE9qMU4rOUtKbzBTaFFmNlRG?=
 =?utf-8?B?dmY5ZHNQZkw1RDJ5ZENSaXU0elBxbmdSYVhxbStMUXZMamlYU1dWTkhGTmx6?=
 =?utf-8?B?TElOMFYwRk0va1c0amg4NTNtZDBlNUM3RDl0amtTRU5PL2s4MVgwd1JXRWhS?=
 =?utf-8?B?YW95d3FVNFU5WDNWRzkwb3BKeDhIeTJOeDNGNmxVbXJsWnIrQ2d0WXdxV01X?=
 =?utf-8?B?eEJwbGU5LzA4Zyt6dmdIWjJBeE04dmF5NzN4UExhdTk2Ni9meW14YXdqVVQv?=
 =?utf-8?B?LzBnVUJwcndUUS84QTBlSHd4WHBIUXJNeERxb3pqYkRQWEFBRU40czZIZ1k5?=
 =?utf-8?B?R2ZmUU5hOGcrWElPWVRhV3VFcGVkQU1nTHVXK2RrbkttNE4waWFBdGtqZm8x?=
 =?utf-8?B?UElOMHZRZGh6TG1oK2g5R0dIakdkbFBTYVduT1lkM2ZUcDhBOWN3VmplZ3po?=
 =?utf-8?B?ck5OWmlSUnBxQkxJT2Nac1JZd3NsVUJNN0VpZ1RPNSt3RnZGV2VrZ0FtUmJ5?=
 =?utf-8?B?OXFaU3d6Njc1d25Ib0s1Y2JGSFIxU0dNMklTdUpJNk9KTDhWekdxbDJ4MUV1?=
 =?utf-8?B?VWlkY3BPRkpqdDZKSVZBc2tORVVDSmdOV0FaU29Wcjg5dGNKZnVUYzhYcHp6?=
 =?utf-8?B?QnEwYzcwTDkrVVEzYWoxTHVMOURlQmRnTXphMGovQit5by9GS0V2bTF3Q28x?=
 =?utf-8?B?dGI5RzA0UjZwSnlaOUtNc2dJODJqU0lRMWJERWhZUE1tSUFEd25ySmt0aXZR?=
 =?utf-8?B?VXAyLzJTVDJKNXNoOXRQZkhrRGZHczQ0d3Y1c3lRbmh1S25jNTB3QlV0WkdV?=
 =?utf-8?B?L2JIY2JOeEVvTGVKcWRTblpaYmd1RGxGV0ZzbEdoUHc3Ty9Ya1dpaWJySUZq?=
 =?utf-8?B?NFJwblVhYXgzOHR4dzc2QUQ3ek16VkkxNEtxNXFXL2g4STFCNW1URjYzK3Va?=
 =?utf-8?B?Zlhua1Fva0g3RDVHYmlQOTlxZWVCa2x2aFpSbVpNSG9vRGs1TGpWd09lcTdy?=
 =?utf-8?B?RFFuUHYwcW5zSDhUbDFhS3l4aytudW5oelNaMUhud0V6S2ZER1kyWThIU09U?=
 =?utf-8?B?SUVCQTVBZjJiaHF4a3BhSmhWc0RTTU9icHFRVkZBY1BKSjRpdmt6M0ZaWDND?=
 =?utf-8?B?dXFWRkduN2JxMk5qVEZYVXFVUWZHV0xLa1hra3M1T0k3cEFZZnJ2RWpOTVBt?=
 =?utf-8?B?U2xFZlVCck85TFBPeWxMeW1kM3lLRE8yVTBPWWtSYit1amlTYlAvbnUreWFo?=
 =?utf-8?B?REpjampkZ055Yy92eWdnbS9Db1pocTFqenlNT2RmY1dUYmt4K2wxVHBxMEl1?=
 =?utf-8?B?bTFLUGdSQ295NDZWblVJWWYvYXVpeGRtM0o0dHI3bTFpcTVvNC9iWXgrYjg2?=
 =?utf-8?B?UXloWjl0MFNUNytDR2NYakpaOTRZcW9GY1U5L2dKVmdzWkVBam5iMm5ZQ1E1?=
 =?utf-8?B?eW5kVzNKSlEzQlNESmk5RVE0WmttZW4wM0FEYU9PdW9XZ2d5amlsL1ZiTW9n?=
 =?utf-8?B?Sm1ra0ZabnMvV0tVVmk1V041b0xIQUJRdnZ5WHBmSDZsWjM3UjExVXVQb0Vx?=
 =?utf-8?B?dG1KMjd2K2h1OStEY084U2pMZUJRNldGU21Hd1l5WWYyMm1xWHppeHorcWNn?=
 =?utf-8?B?K2ZnOHBLYW1UMy9HVk80dzgyVXNURXphck5FSTNFU0NQbVY4K1FPamJwUDYr?=
 =?utf-8?B?ZTl1amFiQVFTTUVkUHlqc2o5WmZpc2FscXpCY2drWUIzN0dTMnZBTlY5SmRH?=
 =?utf-8?B?eWpoTjY5ZUc1S1RKaThUUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc02a199-da54-4187-6e90-08d93a9f9a9e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 01:45:41.9200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FzL3nxgYcsnzzLsoygAndvqRL+I514sN8zc6zFbg5KXZYTRQRVqe77spN9ls7Q+E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4340
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: OIIaiHc4cPhZyLRy9maXdw2JNY_-8EKT
X-Proofpoint-ORIG-GUID: OIIaiHc4cPhZyLRy9maXdw2JNY_-8EKT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-28_14:2021-06-25,2021-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 impostorscore=0 mlxlogscore=951 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 phishscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/21 7:25 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> BTF is required for 'struct bpf_timer' to be recognized inside map value.
> The bpf timers are supported inside inner maps.
> Remember 'struct btf *' in inner_map_meta to make it available
> to the verifier in the sequence:
> 
> struct bpf_map *inner_map = bpf_map_lookup_elem(&outer_map, ...);
> if (inner_map)
>      timer = bpf_map_lookup_elem(&inner_map, ...);
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
