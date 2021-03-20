Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED1F34295A
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 01:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhCTALP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 20:11:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61808 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230079AbhCTAKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 20:10:41 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12K04qEI027866;
        Fri, 19 Mar 2021 17:10:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=kJ62w46kF933nTaR/XUhmvzrnqGNxoW7PkqbY0LjON8=;
 b=idAK5/IZ/iALaetspWy9jQIDFL77sd/WZFoqrKrZBMswqyZspSE11YmjU0CufqxZsjf7
 OIIGZBOMwKy4zGBMlmlKCimd93zCM23Pwr4OufEsxF1vQZgntStnEGmrHbWrWmgj5IM2
 0cUzHgG74eKbdgkRsH86tMXuG0E9oSk/CiM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 37crcwvg1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Mar 2021 17:10:29 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 19 Mar 2021 17:10:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kqv40mw3SDKFXiIDFKUQQe/fSMxfQvzd2AJmwB2YF3O/qqVos3DCBDgwx4ZjTZn3i63m14oiSqNycFy9NWeN/te6BlnTscYxUPMZo6105CFXLfWx/zkwtVgByQUIkORSQFl2XOfO0XbDL75k6b4krTMxd6ItRrVY7BPkQJYwbPfaDm8yJ3/mhHXFvXKhiup8go4k9sG8Xz2lknaTATXzOLQ7Blm8JkE3aMEBweYq+5tzhdC5pGs8n9yBqDb9jbVT/djgT4DeT1hadyo1GIFlSDHOEAPA+LmTaQLYLl34GwEhpZTB2WGeRMZ1zRytoVpyWPdaejAqJ3+85nWGqR1Akw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJ62w46kF933nTaR/XUhmvzrnqGNxoW7PkqbY0LjON8=;
 b=EkbPQTRQDARwXscxNAtG7cDXcNZFdFMZ+Ss6tJq+HolabI1eNe0MASphFWwQOq/fLDQcFw90iCxfp0owXqrDN99SSKpLvJ8ETvxON/vZ/134YI5tCu+kVVtFMnXPALLid8Y993c6tbXoPtlqEFH1duhk8wxUGXKkhPsit+xE8wFndnfeJi+bggGrQeR6dsS3dfoHHozQq9cyvS0ts3SohaWEg9+hX007l9h2gHL3kfejXR8ad/dustnMEJUVgoAxrlWguM5K8XtM5t2JxsPFDCiq/Mr0h0r7zKrKphGsj/XYgSUYX1govYWMeTzTZdPZ72e1xmZysuSwBVkLKDVIww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BN8PR15MB3282.namprd15.prod.outlook.com (2603:10b6:408:a8::32)
 by BN7PR15MB2226.namprd15.prod.outlook.com (2603:10b6:406:92::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Sat, 20 Mar
 2021 00:10:24 +0000
Received: from BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::315e:e061:c785:e40]) by BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::315e:e061:c785:e40%3]) with mapi id 15.20.3933.032; Sat, 20 Mar 2021
 00:10:24 +0000
Subject: Re: [PATCH bpf-next 03/15] bpf: Refactor btf_check_func_arg_match
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
References: <20210316011336.4173585-1-kafai@fb.com>
 <20210316011355.4176313-1-kafai@fb.com>
 <CAEf4BzbyKPgHC8h9z--j=h9Fw+Qd6HSgCtvPvytO5nw82FJoMQ@mail.gmail.com>
 <20210319193250.qogxn6ajnzoys43h@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4Bzb2UuzbiiG7ArFtH4eskJMm7XvQiGA5H7gzH+y7K0gPHA@mail.gmail.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <8de72618-22fc-ba88-686b-301e46f40dd3@fb.com>
Date:   Fri, 19 Mar 2021 17:10:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <CAEf4Bzb2UuzbiiG7ArFtH4eskJMm7XvQiGA5H7gzH+y7K0gPHA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:343d]
X-ClientProxiedBy: SJ0PR03CA0051.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::26) To BN8PR15MB3282.namprd15.prod.outlook.com
 (2603:10b6:408:a8::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:c99:e09d:8a8f:94f0] (2620:10d:c090:400::5:343d) by SJ0PR03CA0051.namprd03.prod.outlook.com (2603:10b6:a03:33e::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Sat, 20 Mar 2021 00:10:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 759d5160-f509-4c6c-5449-08d8eb348f38
X-MS-TrafficTypeDiagnostic: BN7PR15MB2226:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN7PR15MB2226D9EF3C230E8AED2F3F2AD7679@BN7PR15MB2226.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EY/fLdVyx/vrW7fsY5GqCRD72//ehXQrqOduMmxleyat8cc0e7NBzVuVARvMTt11/MiG0lPiC9So/K1MTTgeAANIL6yNrzDx/dI3vm6Xw5B1XECUOkUJbprPenylmrTOvwPKVP1ELOmJUlcrMVqpUF171y8P/CKKfCHHE56znOx3v+4AgKLKz0FStyKalbBLe7Rj4lCzbA9IwUspKMWHvNacbQukrdSJrLYCLYi4Okg+KTQZXLCq96qJVoQ2ycyBofyucNGt3YBRgSfTqM+HhSVIcR/6u+nDn1WI4mwWZbEVdiJ9CeVTRTGkVhr+wsQbquKb/AKHvQQyixszQPohzHWX3vn15r5xVg3r13RK3xQw93iuscQkZ56Oe6ZYanZp1glfOwZz6pNZ/7gJM4qlIzGvs3e8c0mj1IJbpHLvYVeH/1YlKCYPm/J7M0iXoipSFKS4ZgO6nvIQ5eioY/Mff14oxgJcdC/WkEpOFCIhhKnPnYZXQxzpNYiP8U41Cuvsw5rbnGAjeg8M/vvckhhvQRUlo48SEa39GzKK7TwNqyZltp+YiajyMgvhTM0HlteUpNTE0WTlUs73XUY9Y8slVl4IvEkZVxEQHgg/k73pTM4avvPkMOumHNOG8KePDQI8IcrM6wVZHjymzf5UH5V2cRstfZLCzksLRWy+hqF8ed9Kvuwos6YTK/4mVbuK0Pe5LJFrukIDJ2F5GWP9TxVz6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB3282.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(346002)(366004)(376002)(8936002)(6486002)(16526019)(186003)(66946007)(52116002)(110136005)(86362001)(2616005)(66476007)(53546011)(38100700001)(66556008)(54906003)(6636002)(316002)(2906002)(478600001)(83380400001)(31686004)(36756003)(5660300002)(4326008)(31696002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZGMyMnhEOW9RSlkrVjlFOS92RVlndlp1MGNFZGdFaVRSWk93RE5taEkvMUdO?=
 =?utf-8?B?dGU0QTlMZDY0NkRlTXFQaFg0Yi9ndEJhTmFXTDdOZXdsTU1zbDlPUGlnY3Zo?=
 =?utf-8?B?cDdoOTFybkFCeElsYkk2djRxUEFSRk5teVBXaEIyWWwzQkVob3Y3TW9RWmNQ?=
 =?utf-8?B?WDlaL0x2c3NTeTQ1SXJNWnpFUjNqbE9KcnYyYmwvbXhSdVZjOWJPTHExYkEr?=
 =?utf-8?B?OWY5Ti9RYjZNWDZvR1NzbGVGTFRIdkhUNjc2VGI2U2treVVCYWlxdVprQXVZ?=
 =?utf-8?B?bWNYd2YrL2dwR0E0b24vSXI2eGV0U1Q5YVk5aXVQUlJRWFZxRGpHOTlGcWhv?=
 =?utf-8?B?VDFGaUFyRDM1L0Q0YTNBUFNETDNBdTk3NDV3TVZqcm9xT0paaVkvL0plYkRM?=
 =?utf-8?B?RGFrcEVoV3ZhM3dlb2Q0enpmSWw5SExTMFFPbHNoM1E0UldHSFVRU0Z5TWNi?=
 =?utf-8?B?Mk5CVGFScHNja3B2TVZFdTlXeUh3OVltemJRTFJZUmR4dFUra1JQT2EzMnFs?=
 =?utf-8?B?Q1g3Q3BxWVdlRnFaaFArSGVTTjNqSzNEZkdRdzF5SlZzM0xieENsUHkxRVdT?=
 =?utf-8?B?cHF3NDhqYjlKc3VxcC9qKzVKbUhON1lPT1VNWWxxcEJldnBqczl4WG5FR3NP?=
 =?utf-8?B?R2htSDEzaFFUSUl5WU15M09kUFFhMEVTbDRxMDF3OTdhU2VpN3JkcVBMNGxs?=
 =?utf-8?B?YjlOS0tmN1ZISlBJQ1QvTnk1NXIwcm9IVElOUmQ5Zy9oaHI0L0RBekQzNlow?=
 =?utf-8?B?dnp2NWd2YW1INkpVOWFGT05kNkJyNEFGTW5BT21HZEFsd1YxbkNYUkh2Y0pr?=
 =?utf-8?B?L2o5cHE0aXE0dHUvZzdwbEZNU1RVbXJ1WEFOTTBKREh0aTVFdG43cVV4N2ZY?=
 =?utf-8?B?dTdBSk5XT2xRazQrcmNUSk5QaEhHQWRtcjNnendKQTZ2V1lscGJoOGVSMjgv?=
 =?utf-8?B?OXhvSHRVdjNuQTZaNjJsUlZmbVZBZE4ycjlFUFhrb1l4ZjNVZE9lMnBvL2Qw?=
 =?utf-8?B?WlNqRUc1M0VRWkpCU1QydUZFd0gyUE5QYk8zRno3cmJLL3owM28rSzRiYUN6?=
 =?utf-8?B?N0hwODFTNlZxd24zcVkyNzJKSXBqaVpVUFd5cTF3MUJldFNRTVNyTVQ2KzRQ?=
 =?utf-8?B?akg5UjBxT2c1WFBrL2xNTWFuNHhvbDVUYW9rV0hhQXMzeG9PQk56R0Fva0Rp?=
 =?utf-8?B?eERRYUtwNVZma3hCVExnWnNFdzZ1ZDZ0eWYyMnRYb1hGTUhPeDZ6ZkRyeEZQ?=
 =?utf-8?B?bGN1NFVvTVp0dUo0K1lPejdxVldtdWFuSTQvL0F2T3N3WmFDRXlONGxFSEJ4?=
 =?utf-8?B?ZlVHUnRONlR6N1dZNEhTeVhrNVA4azFxV3F5aWp6TjBCczh5MndOTGU3Nkg5?=
 =?utf-8?B?dXJRYWZyamRRSjJyVXh5VHNIaXVYdUYvQmdyMGM1V01rWDU2VTBTbnVYcG1h?=
 =?utf-8?B?U0poYWUwemhIa25GN1B2N3ZYUTlUZ3ROLzB2bFVQdWV3Qng4OEgrWVloK3E1?=
 =?utf-8?B?SmRVV1FzVG1QUnJrWGFHcUVaMEZFclJuNkhPRkZXeWpmMnJPaVN0ejhDUXZT?=
 =?utf-8?B?SHhPNjBpTnpwQTM4M2Rwa2Rqa01IcTBMV3Z0Z2hEVGVxb0Y2QmNXTXBYUlJk?=
 =?utf-8?B?RlYwUVZFVm9tbEdPaEZKOVZVRXA5Ky9LUzUzdERuT0swR1NxcmJ4Q1l3Rm9F?=
 =?utf-8?B?c2VJZXRqZkNqS1ZNQTZNenkxb2ZIMGJpaWlkZis1b1Z6czk5MGt2ZE94SVRu?=
 =?utf-8?B?d3RqNWpMeWdIdG9tSVdGR1BONDQyNHp2UVZXN2I0M1RlZkJYK2hBWnUwQU5s?=
 =?utf-8?B?cUR5THZhUGtvN09NL01kdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 759d5160-f509-4c6c-5449-08d8eb348f38
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB3282.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2021 00:10:24.8844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g3zZry2pZoVjPSZeKS3JPfFxXdTBf6tE7x50LKfRzcw/thXRJFeQKIS4V8gcmy8L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2226
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_12:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 phishscore=0
 impostorscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190170
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/21 2:51 PM, Andrii Nakryiko wrote:
> 
> It's a matter of taste, I suppose. I'd probably disagree with you on
> the readability of those verifier parts ;) So it's up to you, of
> course, but for me this code pattern:
> 
> for (...) {
>      if (A) {
>          handleA;
>      } else if (B) {
>          handleB;
>      } else {
>          return -EINVAL;
>      }
> }
> 
> is much harder to follow than more linear (imo)
> 
> for (...) {
>      if (A) {
>          handleA;
>          continue;
>      }
> 
>      if (!B)
>          return -EINVAL;
> 
>      handleB;
> }
> 
> especially if handleA and handleB are quite long and complicated.
> Because I have to jump back and forth to validate that C is not
> allowed/handled later, and that there is no common subsequent logic
> for both A and B (or even C). In the latter code pattern there are
> clear "only A" and "only B" logic and it's quite obvious that no C is
> allowed/handled.

my .02. I like the former (Martin's case) much better than the later.
We had few patterns like the later in the past and had to turn them
into the former because "case C" appeared.
In other words:
if (A)
else if (B)
else
   return

is much easier to extend for C and later convert to 'switch' with 'D':
less code churn, easier to refactor.
