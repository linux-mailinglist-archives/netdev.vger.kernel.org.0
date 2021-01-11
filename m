Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E992F2058
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 21:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391476AbhAKUEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 15:04:24 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37412 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391255AbhAKUEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 15:04:22 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BJwDO0030815;
        Mon, 11 Jan 2021 12:03:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=+AuMuR/w80WzGrG4trRETndnO0lV+6sBhHWC9D8aByc=;
 b=LgN39Va6CRwo37OBJWX97kODqIqyzS4kxszu3coDfhZAtLbjH7PjRmJ65X4oaxLx2E8M
 ByV1b82HU4Bv4gtZBGs4psCSVuFI4oTBjuZy87YWC8yuftGHF7+DJ5wNzi/rgStgGZcd
 xbXusRyYxtPSooyPeBqeZBGZWdtqj2P+6w4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35yweb6pn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 12:03:28 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 12:03:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iLZlIEqvXzuxZOa2ZlltudMHtYbeu1daf4GWOxrLgSmUIqW5w3+DexUGXxd4RZlt9oR5DDW0/4+4M1Mdbc+gELyupKl8PbaSjg4FPzZ4RiC6XD1nA4TOFmsJRvwF6elW4jVQbvLGwMBFNYS4FRoa8TXRW1maH7asSbeDd7v07hO2FLhW6gJJTKFbfUYS5yVaxutezA5DnMKZd6ESNqHz10ZFx9esGh4GUZNFmuJ9GC6lM5hjt8Prc10SbyqULCYTZ47h5vDW1cEQeWvGgZzTswyT0pmi0jMrK/CtItgFpz9hW0eelCYbSBuaSggBNAQdcLDN0648ZlFJ0Wd6awf40A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+AuMuR/w80WzGrG4trRETndnO0lV+6sBhHWC9D8aByc=;
 b=IouRfBHh6O05IVl7exPjU9x5OkITzBzLNGkeCB/QFw7sNeKFoMp4BCzPi66XA5oHdnzsHe+0fkz4TrMXcxNj8TW2VuvVVWut90ArBDhD9OlkdcqaVL27OTTSxxLE2xqX2l/dZhwTgqzHtnUSNpSWjfejOUE3lwsXl2ESYOXeH3y8XRZOsQRBsQhdUl3NWjlRwX+pC7EICkt4ISqT0HxBFZ7Y4hRRWTo1EqMIIyBRUgaVu22+5qc3C9/in+foyklXB8nkszT4yMtXA4Z7E8NBykD3ddtxQe5469Fx9DikAhhe35/SusVnyF2x6WOfS9ZL76OZosIDlgd70NvHlyX5YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+AuMuR/w80WzGrG4trRETndnO0lV+6sBhHWC9D8aByc=;
 b=hc6BMiy2uZoWs3gE+1xTS4qZC59iSJZ/A31w7ajtLLz4fqngxBt6Yo0Ewlki7qpWH0UUJTUAenH4Lum6ZfPe9u/FRtyp2JprcGbYbuSOgQCJcCLnDlKW5jLQWMfdalnxV7XArWpk+l2KVr3ccM1M+9dM8W9+q6MwGoQ6lo/hlUQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4085.namprd15.prod.outlook.com (2603:10b6:a02:bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.10; Mon, 11 Jan
 2021 20:03:26 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 20:03:26 +0000
Subject: Re: [PATCH bpf-next 1/2] bpf: allow to retrieve sol_socket opts from
 sock_addr progs
To:     Daniel Borkmann <daniel@iogearbox.net>, <ast@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
References: <9dbbf51e7f6868b3e9c8610a8d49b4493fb1b50f.1610381606.git.daniel@iogearbox.net>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <02b5fea5-2790-51aa-1bf1-862de6a9f271@fb.com>
Date:   Mon, 11 Jan 2021 12:03:25 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <9dbbf51e7f6868b3e9c8610a8d49b4493fb1b50f.1610381606.git.daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6450]
X-ClientProxiedBy: BYAPR02CA0036.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::49) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:6450) by BYAPR02CA0036.namprd02.prod.outlook.com (2603:10b6:a02:ee::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 20:03:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe12d4a7-569d-4b87-692f-08d8b66bf56a
X-MS-TrafficTypeDiagnostic: BYAPR15MB4085:
X-Microsoft-Antispam-PRVS: <BYAPR15MB4085E86C452B345A799BFC62D3AB0@BYAPR15MB4085.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V2yuX0XeGbdJv+4LFGIA6QB6j03oZC2zVl2LGPdpHicIJgk/ZeeMsnY0ceEYDCqe5Dtqd7OY2Wqwg/57AG2suzyw3mticzz6IqLMElxZ4liZaQ73Zp+JjbfSpAUu2dLhFWXddsz91GEDTaO4xsuS+giH9sEZASS7bOGbo2w0kZEPLZSnykcZg0YYmG7nOFWqvZpUuTYRNRhakLFHY6wRgapVbLmLm4phEHF/PZYzM+ecZPzSqvbv6EBc0jXBRgK7XWH9CjmqgnqojKSUZlV0fCvDzMT8E7DvrhuQzDB/DDHleC3RgGpdZPoHUXmqAZCqNAbg1OT8iM8S2dNKUZwpgxOzhAQTTWfFM19oK9yxE9ctqOMXlBaVMIucBfM8wfl18WnVTYFdycK+sreDf+ibZunZ+5jDOvWvOW4z4wCbM7L01f7yH0e9oOKN1M7HKIiQSLFKEpAHAdzy19zsa6qwfXAU3XmgK57jw9ImkBM52nk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(396003)(376002)(39860400002)(8676002)(6486002)(31686004)(316002)(86362001)(52116002)(8936002)(2906002)(53546011)(31696002)(4744005)(478600001)(36756003)(66946007)(4326008)(5660300002)(16526019)(186003)(66556008)(66476007)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UkNHa0NoTUROdWoyYzFOaUpMNE9XWk5Ua2duZk1VbktCVG1oZHA5R2o5UTdZ?=
 =?utf-8?B?d0pBd3ZDRVhFMTlIYkE3R1dUNzUvWmdtQ3liV0VzWncyMnRaUWVvVVk5WHd5?=
 =?utf-8?B?b3FRRHdTa0RPVDlxT1FBd3VzWVBrZk9BNUk1VHdLeXNkd3B1Q1hKcjVQRytJ?=
 =?utf-8?B?OUJLRHUwQ0dURlRGMmN2Rko2dVBOK1dXZmlSSGcyWVpqdU1TSHRuUlNCQjQ3?=
 =?utf-8?B?R2psNFByTVZ3aXdlcTdNSlVZVWJtTnVsQUs0T2w2RVJKemxXeUxhM21ENVdL?=
 =?utf-8?B?UmRFQzc4YVpuazgzMzkxeGxYTFhZZnlhZTBra3MvWjJjSE5hUGEvWmpBQ2Qw?=
 =?utf-8?B?b2svb0VMbHpJVjJNU2FrelFLVWxCWlA3aTdYc2xiYjltdHcwdUpPZXBSNTJi?=
 =?utf-8?B?Vk1NUWQxUkU3SVNGT2RvVUJmWjhMYzZBWGowaFpsZ1BmUG9WclBuU0ZXVVpl?=
 =?utf-8?B?QUZ0OGJBNkRxalN6cUxKT2Q4UnVMQ1FlNjBPb2FFcVBadU9ZbDUxSEtTK1RX?=
 =?utf-8?B?dGpKb2FmTndGampJRUFwcXY3UnBpeXpmMnhnT0VXYkt3QTROSDNJT2cyeDA3?=
 =?utf-8?B?SS9YSXJ4SDdzRHljd1JTT09QQnZHWGsvKzdhbjRta2dJUW1KdlBUcXFCdnFV?=
 =?utf-8?B?OVBBbGMrMUVDUVdSMzA3MmorMjNteHVjVzZCdlVlMUJkelVOTDRGdEFzK0Vt?=
 =?utf-8?B?ck4ySnROOFBUampLTUlSNXFHMGo3OVlncjVsU1pFT2JwWjNmRWN2Y1F2WHlC?=
 =?utf-8?B?aTZQS2pVNy9hN3ZGUGs0eHYxQzd0bWlpNXpZVjBJLzBjcXBWWjcvK1BVOWlp?=
 =?utf-8?B?RFdIQnhRdjNKMGVUbzRBUHNhS0wrd3kxZ0hReU5pTlVKeXR1TW9JSFZpNk1V?=
 =?utf-8?B?Rkp5OU9SbWkrc2Y5Q1VjeW5sZnNSVGRNdTVGcXZ3eDg1MTh1YzdDS1FLcE1w?=
 =?utf-8?B?K2VpVkZNVWlqUjUxZkNiTGU3WTZjK0hSTlVHQXhnaGgvSWdISUZ5UGVkeEdu?=
 =?utf-8?B?L1VFMUc4TWZHU3Q5eWU1cmRHT0V4c0k4bm5DMHRrV1pmOEVya3JkUFhiRXh6?=
 =?utf-8?B?QnhLd0pzZ0gvY1lwajl5QUxUYTdrcTNCVzNUUmIxWFJTRDhGdkdZWUw3NHJZ?=
 =?utf-8?B?SkxyKy9WQlZUb293RTBNcmhlTk5iVmMyb21uV1hWV3JScFFOaVBTdE5Qcmd3?=
 =?utf-8?B?SGdsdC9nSDFhNmg2bm9lazd6NHhqRXZRdis1RUR5S2tuZlJpYU1jSEtOOG0r?=
 =?utf-8?B?QTB4QkhSTmtnNUI3OXhqZkZIeVpVRHErK0ZaNW1zNkR5QkhSNE1zdEVHQ3J6?=
 =?utf-8?B?V3ptekpVOVJJcnFtL2FtSWswekdVNEd1djR2WmU5T2hpcGxYN0pOUTh3dXRG?=
 =?utf-8?B?NTMxTVpJUmxXYlE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 20:03:26.7063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: fe12d4a7-569d-4b87-692f-08d8b66bf56a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tv62Xqf5S6fYjcVkdCpRrexKBiu+nbjGgxHj3wND7x47j3y3L33eBmKxnmmfTi1c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4085
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_30:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 mlxscore=0
 adultscore=0 mlxlogscore=945 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101110112
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/11/21 8:17 AM, Daniel Borkmann wrote:
> The _bpf_setsockopt() is able to set some of the SOL_SOCKET level options,
> however, _bpf_getsockopt() has little support to actually retrieve them.
> This small patch adds few misc options such as SO_MARK, SO_PRIORITY and
> SO_BINDTOIFINDEX. For the latter getter and setter are added. The mark and
> priority in particular allow to retrieve the options from BPF cgroup hooks
> to then implement custom behavior / settings on the syscall hooks compared
> to other sockets that stick to the defaults, for example.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>

Acked-by: Yonghong Song <yhs@fb.com>
