Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F422F0961
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 20:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbhAJTrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 14:47:10 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38806 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726267AbhAJTrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 14:47:09 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 10AJb3Au028745;
        Sun, 10 Jan 2021 11:46:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=W6wikgOoX4ZxuVmgqlvNS/p+JzIpqksXyynPbkNecJ8=;
 b=J2z9HafRps1vxuEdZ44LxUcCMRODxf+LpMV6KUJO+w9yl5FsZQfbwMZJWqGCiF5Nk9Oo
 lxUDMn1QZk6W8sLlDHsGxk75TQTH37iIqI2Zh8T9YNgZMCUh+FkwzQgcXVnygb0NHeSZ
 vqgDT1KJnM/b+ZoqjLIYH+45Rwgj+Wj4sk8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 35y91rmj5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 10 Jan 2021 11:46:14 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 10 Jan 2021 11:46:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/ZUduMsh67e7dxn6LtjIMKO0+CepcTH3NFkUwNbPI811jXEXkiiW9T/ew7pDHQg2T6zgMVUM5/fiM6Z7olEPVIuEOqzHe3YTauMe2jooxy93Y4bU8gn/yMWmKLYMGmFQj8bus7JG/gpzW5LpNAwWGqYnJEF2fznOFkTYglXZGj+ftiLm81h1yqYHshfH90ItJHmSW8KX2HAW1Lfeg6FvOIRNSlMqO/jnh02nV2v5dWiC9wVaW3D4qz+ssT9bXEVbUI5tiA3YeYQ4nf86McV0Gq0DwurAnWhcNBCb1My1UsdNvEwpxGIZ8WTC5rjGMPIIiSo/0RErab+tYp6D+UncQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6wikgOoX4ZxuVmgqlvNS/p+JzIpqksXyynPbkNecJ8=;
 b=Z8zWO12N6T2ubaj+db/O41ktXvT87ExQejxdGsJky9owQrvkluqtIC7n9P2jwJAX1N/74BHQVKVGH0yXh2p8puoZLAn8IuAAcGUjrlEKbaKK/cMFcr1HTszybd4zMsTz01MuTVb/XY0G9EruLlPN6Ln+HS0mEYWLTtV5SWo9avcHrFVB9H1b//zZ7c4Tt7vv8GGwhNxlZD+KzeOXM4vUmNcmKcpCZ5X57gEEf3akpP5NqfxOj8ypNEkm4YJuEUEI98P4cC2pgUcH2vmpoCfHmahK+nxq8JeoZV73JlCZYTmRKd3wjYimPGj5GvObV7Y6OfkBksjFiI81+XRcIi7Nvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6wikgOoX4ZxuVmgqlvNS/p+JzIpqksXyynPbkNecJ8=;
 b=F70oFXQMUz2QoW7gIb67jj4AUBV8nhxaWlWRx/nLlpef8ToDelRbfbzTzHpFMujjxaBEcO9isdmx/SXF29MoQkUxliV2WFlqBaK1U5nqWlRYa6po54TcwFHDJO0rBwGgWa9aVM30do2Kp3z+D6M0CnftUaEoo5ayWVeUlX2i8CE=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB4290.namprd15.prod.outlook.com (2603:10b6:a03:1f9::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Sun, 10 Jan
 2021 19:46:11 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Sun, 10 Jan 2021
 19:46:11 +0000
Subject: Re: [PATCH bpf-next] libbpf: clarify kernel type use with USER
 variants of CORE reading macros
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210108194408.3468860-1-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b615adad-a8fb-3405-3b1c-7376e5b65d90@fb.com>
Date:   Sun, 10 Jan 2021 11:46:06 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20210108194408.3468860-1-andrii@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:8335]
X-ClientProxiedBy: MW4PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:303:69::17) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:8335) by MW4PR04CA0012.namprd04.prod.outlook.com (2603:10b6:303:69::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Sun, 10 Jan 2021 19:46:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 825156a2-425b-4874-16e7-08d8b5a06202
X-MS-TrafficTypeDiagnostic: BY5PR15MB4290:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB42905D34B3AFE65D1524CBFBD3AC0@BY5PR15MB4290.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:529;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aDnA2F835+sqrTd27GsgCgbNshRV/GJQJYVra0Xhp+yk1blA3E7nNcM8oZcV1Q3BHNmly9xxroHAKq5ZhJx0vwXQGy32UFd2Rq1wQs5zXyAHc6E+9/8ZxqholryHe7C0bEjVUk2qmEMwQ48Jp5Z6vqrp/RI1oHLSP55/f7bZRRt3UFwaakLElRRuKwowlpoAIwL0Vn8/YP+stTrAcQEgyLUWIeqUIBqj2MmGKvAHgQnVTadMH+BTSfrP2AWDRu/xbsiemg4u/eixsawqKqiEtuOwqdytC+1X4f76vP7fJFodNbrj3YWW5+Cbg3sKPomNhaVWFgnvJvcQ2yLk6OKOrpnUMlU1MvrwKYNcXOMY0zwiju8C74qDhojCEvqW2TVWltDisDkScFm+U7Ipz2jCX1qlInDTSFBpjSz5BedCCjZkOenOSa9gNObnpAe48QtglV7RP1zC1cWvx3MdBLQDchiYlOPGvA8KMcrslCrtUq0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(39860400002)(396003)(136003)(31696002)(52116002)(16526019)(186003)(4326008)(6666004)(36756003)(2906002)(4744005)(6486002)(8676002)(316002)(53546011)(31686004)(478600001)(5660300002)(8936002)(66946007)(86362001)(66556008)(2616005)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MUkvb3NaTnorZlRvS0hSemJZb2tuV2lNM29ZeXZQVmcxM2paTXNiZWlGaVB6?=
 =?utf-8?B?bzFqY0ZOKzR1T2FLQVp4VTVQV3RSckw1Zjc4WS96aUUycHR0ckl1RWdwQmYv?=
 =?utf-8?B?bGpaRkJZZm5HdXFPNDhwTEZpSHA2R1A1eEpMWTJjbXBMUG14YnZrRnQxTVZ5?=
 =?utf-8?B?SzhrZDlTM3RkbU9VSEV3QzIyS0NmbkJDY0lxeElsWFZyV0RzblJzZVdrRnd3?=
 =?utf-8?B?aGs4aWFtVmRnaDEwMys0TmMvcm9Mb3MrNEQ0d3MvdGkwTE5OZWZZc3h4VFlu?=
 =?utf-8?B?aGNaaGhVajdnc3h3ZjFNMkRTcWN0aWx3cDR2Kys3cWpJY3h3Rk5tRVBuLzhQ?=
 =?utf-8?B?R09PeENsK3ZOb2JxTndadlovaUhoUEg2emhOM2o4T204UEF5UW5aWGhjMWFr?=
 =?utf-8?B?N2s0RVFTRVJyME5BOVZuVGFDV0pvY0Fxc0VFWHZsblZNcDhsOWdOL0o3R3V3?=
 =?utf-8?B?ZU5NZG5CNTA5SjQ0T3B3c2dsWGZLTzNkMlRCY3ZKemZNU29Td1ZZR2plelhI?=
 =?utf-8?B?a2Q4Kzh3T094TG1mMk53YVFKeHJGWmoxQ2hUdXZ2MlRqZkZrTml6Z0pvZXI1?=
 =?utf-8?B?NlRXYjRJcEllNEdDTmFlVE9lUFN2aHZiKzYxd3RzdWQ1K3paaDhENXl1MW9j?=
 =?utf-8?B?YmZTcmZLeFp0WjE0S0RYNTdzdUFreExWV01GRXdzQ1JGVFJFVEtZbzJDNXdD?=
 =?utf-8?B?SzlKZ0tQVHRuVW1uUExKZkRwb29wRG83VGVmUWlWSTBlbFpxWDJtWDVubWc0?=
 =?utf-8?B?L3ljT0Q1YW5WNU9nd3ZWU2pHWUJpa24rL2JMYUI3KzNGbFlBV25lY3kycG1T?=
 =?utf-8?B?d0JkREhSWlhiejZmcFVmUHBJUldFYVdsZGorbUlZV3ZsUlBmdUxvemE0RjYy?=
 =?utf-8?B?Q2xDNjBsOXhEcE9ITlNZR1ZXbmhlQnBjbGtWY0o3Sy9ua2lDQlBwUEtyMkdU?=
 =?utf-8?B?NDhSY2RkM0dsUW1vc1g1VHRBOGJ6QWgwSlA1Z1Nwc1JWR2llNjB6cWJBVEg4?=
 =?utf-8?B?bHdCQ05wams4MjZGN0dIR3JVN2Mxc3dFVk1XckQ1VXdZTklaOU43cjBqT08y?=
 =?utf-8?B?K3FmVldDWnRWNmVxdm55Zy90b1FzOEFZWFlCUDg0N200UjQ1T09MRnlBYWhp?=
 =?utf-8?B?U0hiaG11SjhPU2ZyWVZGQ3ZxcTJaRzhLU0JrWmM4eWMvQitQT013Q2g4R3ls?=
 =?utf-8?B?NTJIU0N4NU5pNEdHRUpLU2hJQ29LZFFaYURZaG9FcFB6V05Eck04VGxkOElC?=
 =?utf-8?B?VGJjWkRFM013Q2pzdlRqWHBDdWxTckRVbkZaYzkwNVpUYVlkWHoyNVdXQzdQ?=
 =?utf-8?B?cnppYUJ2WjlxSjAxSFJta1NCZ0Vqc0lkTU16VXROWiswbEtISGFucTlNQkxP?=
 =?utf-8?B?cjV6ZmxhczJvSlE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2021 19:46:11.5674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 825156a2-425b-4874-16e7-08d8b5a06202
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Taf9RzySCf64hmiNhpm3cQLO+aJ1g2aVbg2qbBlzrZqfTNnK1wCnLLkZ64U2T25G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB4290
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 mlxlogscore=996 mlxscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101100139
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/21 11:44 AM, Andrii Nakryiko wrote:
> Add comments clarifying that USER variants of CO-RE reading macro are still
> only going to work with kernel types, defined in kernel or kernel module BTF.
> This should help preventing invalid use of those macro to read user-defined
> types (which doesn't work with CO-RE).
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
