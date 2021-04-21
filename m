Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818B8366587
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 08:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbhDUGiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 02:38:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20902 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235123AbhDUGip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 02:38:45 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13L6Jd3K023425;
        Tue, 20 Apr 2021 23:37:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=o5by0peAeYUbQ8CG4/fDjLhjYLsgfPs+Fm6i+E9ZQMI=;
 b=OjcUX8KhtzmmWgup50nr2g1eUG0O5+5avHxHo73tuyti/3QfaYfOq1nE5+LabkbCrX1Q
 AaLZJ5xKQU6gN/movdAlQfbql5scnbHHvNl8DaMDqbzHx0KNLdmMexWIVST8BdXNd6TH
 ZKu30Jo46V2xR/A1z4HHO2iPRtzy2o13bGw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 382726hxbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 20 Apr 2021 23:37:56 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Apr 2021 23:37:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XX6nC7L82jgiv10TBUfm4I9t0fUBBnsBZN8LnY8EKCQ/TRPZx5CYeAeM3jPvXz5Q6+rk34z7Y2/TI3jS43EfnWX5iuF7kLsGWAiDiu+Q9b6ygKB+8R75LATfvukVDtYLk8ksA0YQuzWANSYgO4caAutEDsdzq+ovMgRLjlB+Z+wBQVAIdS/Nw1pAAgw0+cG/S8F2/j6phcufHgu+S7b3qvCxgNVFFstcuyKtLu6tITebekNR/asf3Oc1NZPUlJuH0X4rPxvYWfMgfx97YAawz0pyeRzvya1iaMBcF1NSiTHE3fDZxSMrKz4pvJFIOSTk89ENB8hymPiMaKe5mQf6gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5by0peAeYUbQ8CG4/fDjLhjYLsgfPs+Fm6i+E9ZQMI=;
 b=AiP74eXDWToFJIJ2LZImFLG+SJ45mph5NdR8MsUrQX3WnbNrd4m6j2U5eK1ItOLuHUeJO7dpeLTNpAzw+cPzq/ZXKnsEnXYORlkiZ82Yq+NZK9l9GPudy4dZK1JoPgLum4b/A6XZawg2VSDcns1uiJZ0W2JBoVtKJgOuqMbDvxrmf7noxivxvT+69qd7STNPl8oe18nsyunvww3KZW6xKLm3sSIOAZiFLiTqVa6cVB/Or3tbu6iFiplLSJvs5zc3cQaznrjXAYJhqZyPiH2xCN8+Gsd8k3TLxrFzI/xFumV5z9vTN5c+TxBWH/VdkEq+KpyDDSE6yqtH0iF+o46Fzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4436.namprd15.prod.outlook.com (2603:10b6:806:197::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 21 Apr
 2021 06:37:52 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 06:37:52 +0000
Subject: Re: [PATCH bpf-next v3 1/3] libbpf: add helpers for preparing netlink
 attributes
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, <bpf@vger.kernel.org>
CC:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        <netdev@vger.kernel.org>
References: <20210420193740.124285-1-memxor@gmail.com>
 <20210420193740.124285-2-memxor@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b1648e8a-44de-3d9a-963f-4c79f42e4713@fb.com>
Date:   Tue, 20 Apr 2021 23:37:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210420193740.124285-2-memxor@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:d87c]
X-ClientProxiedBy: MW4PR02CA0013.namprd02.prod.outlook.com
 (2603:10b6:303:80::33) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::137a] (2620:10d:c090:400::5:d87c) by MW4PR02CA0013.namprd02.prod.outlook.com (2603:10b6:303:80::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Wed, 21 Apr 2021 06:37:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf4b40b9-c43f-463a-f8dc-08d9048ffd35
X-MS-TrafficTypeDiagnostic: SA1PR15MB4436:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4436AB96A79482A5653332E9D3479@SA1PR15MB4436.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HNEIDXxBHzJmYTK0B68lqPJ6kn5SCw1/cmYo+/s168vz5KP7f2pCSsFVLCRFZNxuh3TUvNxoUcC/hva9gQSfV0jDfN6If26bsGHmzFkhG3DI/RMg21k576oSzFZg7Pa0CCLKGRKRU4flKpHNCdxsKQnBNCR6qufSzOzn4fNAMeU1fDB2P0OPK2kSsk4/oo+hgWA10tj+gyckEu2w9kpGFZ2XN0Idw95JY6/ERriXCn2nskOGLZt+ZsKsTVUyQI8UyWS+UMEY7jpkRi4pwzDqwjUv4BTkslJw5Hyk9uISYm5HGXLKkvkO7xs7u3O8WAv+PAf5u9LMQCk82fPkUFdNAlibVlvgw4eYjVLIwuksPS2mQN5iIBOhhAnErsb1pDmbz44Ci+/Ezz9TV3KLNTSUQuh6nLuoE22kakAlwzYPZD6hdKB/atJTpAVM2stZ9C9CjpasHfZJuoB0q7wVjjG4a0jGAJHm49XN4MwM/mGLU0bash/GbWXEKKdj12AylSv+iGg4dbVFEnQXNYqkhZn9GBOaURpTpEvMAsqiiRT9xAxeoEsmG+0dtqY1fv7Nk+cZ7t6l/SowX72/hDDJTjTznr8M13o+Wq7LmhB44DFx9irPlzv+1+c0rCX79Sm93T2dZR3DDn5JnPNU2ylaAc6FaaXYNYfuvEFK4L+pZOCR+TUrM24hKq/DMaoGGycDlklj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(8936002)(66946007)(16526019)(186003)(36756003)(83380400001)(478600001)(66556008)(2906002)(66476007)(38100700002)(4326008)(7416002)(5660300002)(53546011)(31686004)(316002)(6486002)(54906003)(52116002)(6666004)(31696002)(86362001)(8676002)(2616005)(66574015)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y0JaL1ZOdlZZdy9vVzJQUUhMQ0p5aFVJL1lOeWx3NDYxejdJNWlna2NhTWxy?=
 =?utf-8?B?U09BUDhNMk5OSUsvQk1wWEN3RFNzMTg4Smo3Rnhhd1hQeHd4Z3I3YWk1N3lY?=
 =?utf-8?B?bGdSS1VYUktKeTVwS3lXaDU5ejhma3h6bWZJY1pzVEYxa0RQaEoxWEdJQVYx?=
 =?utf-8?B?VDFrNmJ4a3FqWmN5Sm8yT2MyUGk0NjdaYnIwR09xT1haT2JFaTJUUEVyV2R6?=
 =?utf-8?B?OFJESWR4dGJ2ZWVpOGhhZE5FQXFmRWtQT3RQSTFCQ2FoM3lrR0RGcENKZFVM?=
 =?utf-8?B?cUNtTXRGWlJibzRBZ2t3c3dncDQ1UkpXTGVJZEl0MGRuV3dzN2dZUWhqeGg4?=
 =?utf-8?B?TUhwTEt3WEdFbHFaZ2FEUTJiczFRaDNFM0FDbm0rZnlaKzg2eXBUaG84NTls?=
 =?utf-8?B?L0J0ZWZza3hwYTBJS0JlZy9PZGZqWDBTc0E3STBYV3Qrd1JFbWtPMTVlSHdr?=
 =?utf-8?B?TEF0NVJiVFMzbXZvSmdxV01QbnFwUWdnckR3MUM0RVNIdkRzWmxHRkhJK28r?=
 =?utf-8?B?ZDE1RE8yK1NMTmNiWnNwSlFDYldXeXFMRXlMQ2JudnkyZ2JvZUhJVk1sU0xa?=
 =?utf-8?B?QVZsb3B3bUJtZmkwM2xLZTEwUHZPc05HTzJTZVdsN1E3SDBGNzVxZTFJbHRD?=
 =?utf-8?B?cXppSEl4TkRoWkVsZFN3YU5FNnQrOU1ld2hQR1ppMmJVcm0wZTZiOXNmYTJS?=
 =?utf-8?B?MGRkYXVuWG9ETmNqWnh6dXJYV3d3K1NVVnlXWWRCb2loWE9wa3dDVE1nSklX?=
 =?utf-8?B?d0grazZrWHlnczBxcHJiUENyS2dEajV3NGJyWVFRdXI0R1JkR0h6TDVUZ2o1?=
 =?utf-8?B?M2R3aU93dTJBKzNPK1JrRzZBZ1ZNazVaRE1iN3dUcm9OeTkxT2lTNjNEcExO?=
 =?utf-8?B?a2JFbjVoeGF6RCtBWjc4M0hZazhJWDVCNU1GK2JwMWk5d3ZpSkhsZGcrMzFZ?=
 =?utf-8?B?ZUJWalBNQ1ZjNENmbjFpSFZKT21QR2VTNlVKRjJGcko2Q0JJeVVPeXNxazFw?=
 =?utf-8?B?V2g5L0dzRU9BQlpqYWVsL3dSSnBjWUVabk9xclYrY1NQMzBoZHhTL1poUzNP?=
 =?utf-8?B?VVRPUlJxb2pOdzJFSjU0SW03OGRBRXFzVGdRd2xSRUxmSGw1Ty83dkhITHQw?=
 =?utf-8?B?SjBnNVVmUzZWNm1sZm9yajJHYnZzZkUxMjQ3eG1VRGZUbHRFbjNCYTJqK3NW?=
 =?utf-8?B?N2cxTFRnU1QyUllNd2NZUXRwb21lb0dIZnY1SVpMNEZBNzN6T29QK01MVkgz?=
 =?utf-8?B?dnZqR3lNMWF5eTc3SHdsT21jOXc5L29hTUprZkRrd1dWUVR4UWVVazZoemh2?=
 =?utf-8?B?ZnlKZnhpL2FjUVdFOCtUMEo0VDd5SDE4YnB6cFk4aFExN2crOTB1TVZpRk44?=
 =?utf-8?B?amdKQWpKV1lWTzlReTJqcGUvQlF6SFRqM1hkRnA3VngzbWZMUTVxYXdvZFVU?=
 =?utf-8?B?ZXdFOWxNV0JSK3pxcHREbUN6d3RVdDBCVmE1c01jR2lwaHc2R0ZpSS9hRExT?=
 =?utf-8?B?d2ZNT0w3UGxRUm1uNzd5YzFqYlJMek5Wb1VrTGUyei9IQkRTUmkweHljLzFP?=
 =?utf-8?B?OU9iTXVFaG0xNkM5UlN0d2tRRzVYMXIrWHNxOWJ1bzFzU01hbmJxdEJFV2lp?=
 =?utf-8?B?K3dpcUpHRkJ2V3h0aHdPUUxxQ3U2dEllS1FTQXRDT3R2ODJXUElJdC9lWmFO?=
 =?utf-8?B?bUo4cFp0YzJsMDNpVkNWVCtEaU9NaFp3WDQ2U0xab1cyaENQZnVpdDMyRUk3?=
 =?utf-8?B?UjQvUWQ5WDhYL0JXOHZIWTdDODRYWGxFUzN4YVhLTFhJbGc5Y05aVVdZTFBV?=
 =?utf-8?Q?1TwCQsIZIrsgHwautOYdA1KnZOMj/sNSC/Oj4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf4b40b9-c43f-463a-f8dc-08d9048ffd35
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 06:37:52.7671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CcGHD6+nygXAyYEu8/sujWNAp43eJ9qRXfTvVSPPeKQT2T7gKXfDpBdWoxBF1GfA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4436
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: nAh7gSmu0lrmt8NCokjSnJE-QnuzBGc0
X-Proofpoint-GUID: nAh7gSmu0lrmt8NCokjSnJE-QnuzBGc0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_02:2021-04-20,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1011 suspectscore=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104210052
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/21 12:37 PM, Kumar Kartikeya Dwivedi wrote:
> This change introduces a few helpers to wrap open coded attribute
> preparation in netlink.c.
> 
> Every nested attribute's closure must happen using the helper
> nlattr_end_nested, which sets its length properly. NLA_F_NESTED is
> enforeced using nlattr_begin_nested helper. Other simple attributes

typo: enforced

> can be added directly.
> 
> The maxsz parameter corresponds to the size of the request structure
> which is being filled in, so for instance with req being:
> 
> struct {
> 	struct nlmsghdr nh;
> 	struct tcmsg t;
> 	char buf[4096];
> } req;
> 
> Then, maxsz should be sizeof(req).
> 
> This change also converts the open coded attribute preparation with the
> helpers. Note that the only failure the internal call to nlattr_add
> could result in the nested helper would be -EMSGSIZE, hence that is what
> we return to our caller.
> 
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>   tools/lib/bpf/netlink.c | 37 ++++++++++++++-----------------
>   tools/lib/bpf/nlattr.h  | 48 +++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 64 insertions(+), 21 deletions(-)
> 
[...]
