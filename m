Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5922F815C
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727475AbhAOQ6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:58:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60126 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726355AbhAOQ6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:58:19 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10FGk3GE004394;
        Fri, 15 Jan 2021 08:57:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qRuJ9xvKaholUp9MMIkVzlAbJV2RxggxJO2r0j1qmZo=;
 b=WTOOcJ+w5N3JX0IK4/ISidBf9c0w1v7Aixkq/+HyaXebQQAJp2Xt8FD9fWz4aS9IAxed
 I9kxXUL4a78PyDWLR2GYcqy6IPz35NJss7AuQjvLAge4Jl2WpXbCIUmfL1uznYitC8oC
 fC0F8RbzUMg8Gfk1U8+rEQO+g42YqpUut+U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 362tcc5c2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 15 Jan 2021 08:57:24 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 15 Jan 2021 08:57:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yh+tXKh4+HbLAGKsU6rLIxbrj8C688K4SSLEKIch/DkSEBCqtR9jsNbti1MJ365Lm5Sbm+Cbri1KA1KGjm9rQjWu0J1hlLOjV2KLOKhPceVmnB++RiM4vTwGFim3aBehvgIt3MywOCoE4A1kRk7M+UfCZ+UjrcSOhir7p5fMnDcfU9ghIXZlKxH56iVvP8Xs+0XNUYfM0VAYObwnwEOYn07tIhoVSLY38YE6Q8V45JtnDjg9Xzpa+9A2P46bTcvmwnUv2G9ciRbAhg74iC6UVYpaX0/IYuicYaA221eidQd1BPnAZvnGUtHXtjg2xAXBZGP7+3rWiazQxTGgxreB7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRuJ9xvKaholUp9MMIkVzlAbJV2RxggxJO2r0j1qmZo=;
 b=WzKfvFspQy9zFpMAsGyx3pgyD+Hmxpha408zsOAGcL7J2i3s9nnDu61K16Iyq6TBKkEK8nzkz3+LEfN0evQhSGjW+XCKoXH0BPL22lgHid6WnqIk2KxvuKi7R+DRKJDuWJhSQmeGusQV/UlXcL+qs0CEa+CHRfdia26O6wPAaQD4UuMU4iklhtKhD/7o14UICDqyH2yk82hX3EHhLP3+nZXwrkf8bXgZvuQCVHfQMjVvaiizft5SjQvk7w3b1BEWxHvBvZDJu8imJnahWeELsIq5YAwBF3Ct2NszT1EK9Amn4+JizUZwHKARZ2uD4RkJqMnKmVVqIwCvQ2PJ6OeekA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRuJ9xvKaholUp9MMIkVzlAbJV2RxggxJO2r0j1qmZo=;
 b=DNOZwodQeO+HPnM+XV6BoNuABZhpgKze5ODFlQocL/UgDGUyBExbcMjtMwZ6sZNz+FbxWBh4N9qTK15h3zIraQe//vl3U/zSMWtCgd6gFWwR0qf01h/BzmeDtDZGZsrPIv3iBv2PIHx4ouAEgYwr3vq4ANoo70XTvIbVd4wGex0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3365.namprd15.prod.outlook.com (2603:10b6:a03:111::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 16:57:22 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 16:57:22 +0000
Subject: Re: [PATCHv7 bpf-next] samples/bpf: add xdp program on egress for
 xdp_redirect_map
To:     Hangbin Liu <liuhangbin@gmail.com>, <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20210114142732.2595651-1-liuhangbin@gmail.com>
 <20210115062433.2624893-1-liuhangbin@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c68d7d74-eeb1-0a42-32aa-6013151d2a63@fb.com>
Date:   Fri, 15 Jan 2021 08:57:18 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210115062433.2624893-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bb30]
X-ClientProxiedBy: MW4PR04CA0181.namprd04.prod.outlook.com
 (2603:10b6:303:86::6) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1366] (2620:10d:c090:400::5:bb30) by MW4PR04CA0181.namprd04.prod.outlook.com (2603:10b6:303:86::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Fri, 15 Jan 2021 16:57:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c142dc5-7fa3-4fdf-d937-08d8b976a03f
X-MS-TrafficTypeDiagnostic: BYAPR15MB3365:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3365DF4011DFF705AF4D8086D3A70@BYAPR15MB3365.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q0w2EcVLAz0IuWpJeuu6HEHXuej8GQli5pcBBBCnY11oc7tEx1E+S71oLmEiiC/SCKfuGVgZri4U8gwm6dtJ8pv8HObzkAaSQP5zewegfTj1X4Idkto1YQIXUhpyeWTFC6IXWXDgfxWO7Dz6BEyPEKk9k7cQjnLNlP06CyonSArUvB1qzHx06q5z2pQLkykJkcl5xTfUt0Ku3k0hKGu094fC4fSFGISBykiPTR4Hoi5iihFYiAeqSr5NAjxvOpktC2J9WiRFLoTj2RAJpPnXfCPoIJ8NPGGJw9mGfyrK/N3kTf/yfw78wMvX30XHXrBxwveb8aCaAKRj+HndfIcUZiLjacKzCopfz1h/PvSUOnWSB4JT6KI4xoRmZpDzkfFUboDtXyyMcIy1QYxowSvBarUrsq0ho1hrIs8HBTiqaV2I1UYQzUZejJ/ud//mul5/kgfxqO+npzattKOWZXUm7xYxerr7KAvY8K+TBrPQDcs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(346002)(376002)(6486002)(52116002)(36756003)(31696002)(6666004)(2906002)(8676002)(31686004)(4744005)(316002)(54906003)(186003)(2616005)(66476007)(16526019)(66556008)(66946007)(53546011)(478600001)(8936002)(5660300002)(86362001)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?N3BYZVJDazg4aXlLTnJCa01JbjB2czhieUpWYUlBSjcrMHphUHY2N3NJU21R?=
 =?utf-8?B?b3A3bVN4ckIyUzhTRGFrMXZsK1U0Qi95U3ZqVkJacDFNWW1LaWNJbEdQQyts?=
 =?utf-8?B?Qm9FOTlHLzd5TG5lbkd1ZkNLeGh0Q1lUK05rbUxyc1FOMit2aFhRUHBXTURD?=
 =?utf-8?B?ckxZc2NCWkdvWlBqbjFFSnRDd25PdEdVbTFvTkpGOGZWRFFHR1d2TXE1cnFk?=
 =?utf-8?B?UHpBYWtHMlJ0T1lWOW9PNEEzN01hd1F2MU4vdjVmbG1NZ1BXYzFrOGZUMjBF?=
 =?utf-8?B?TDVPSmtUaFVoMk9sYkYrUlY2bGVVemI2TUI3TFJmU25aZWpnZjFnNnFjcjhp?=
 =?utf-8?B?cGlJUlVjZ2xMcytpdlAzTjZhOHVROXNzRUhGN1B4UzI0djJTekJtaWRxRnJS?=
 =?utf-8?B?TkNmbDRmZEVNQitTT1piZklWOWFFK2VnZERRdC95bzlta0Y4cUZyNmZUOCtH?=
 =?utf-8?B?YjRhMEtlK2Z0MmZaZ3FDdTk5NnNpQXRDOTQ4czdBSGhGRW91WFBtRXV0S0NH?=
 =?utf-8?B?c2REcFNKd3NFNk8xWkRXc0ZRVEswd0VjVmZ5Q3FKRS9yeWJzMXE2NnJYcGZE?=
 =?utf-8?B?UEl4NFVUU3BzNW4zMHRiNEhMbmFxbVY0LytNSFhwZGVkc0tHNis3MjdZVHNI?=
 =?utf-8?B?bTA2SjdQT2graFFHbVhKNkU3UXcvbnpCNXV4MmN3c3RnZHJyYk80Vy8ybHBr?=
 =?utf-8?B?R0s1YXJtZnBiM1pVRllwbXFmUDlRY3ZiZGVPSUpydTR2ZGFSaEdyelU3UU5X?=
 =?utf-8?B?L0NJbUQrUXBETWV6ZUVhZTN0d3ZFY1oybHVVbDNFUHN6NTVXeW03Yjh0MTNa?=
 =?utf-8?B?Z0pHaGhiK0dPaUhucXl0L2FyNytNOWxROGVBbkk2dnVsU0VqMGxmYTJTWHN2?=
 =?utf-8?B?RU5hNWl0Tndaay9NL295RmFyNE9NaDBJaXpSREZyOEd2bkdxaFc0MUhFM0hD?=
 =?utf-8?B?dkRaTVVQOFJNZC9ZMnNhMjcyc3NvcENWZFNUUEJWbVRqK3Y3Z25HY0NGSElL?=
 =?utf-8?B?bEhCajd1Yllxa2NGK1piR28vNVdhU0FyNEcycUR2T3F5bUpTUDRwMEg1enVo?=
 =?utf-8?B?Mnh4SDltTkdHNmhjK25ZUWVrUEZwMlJPYW1YZDFJcFQ4TEtCKzhBbjU4amds?=
 =?utf-8?B?Y3Bpc29hMDdCOExnbXY3N3VDUlQ3LzNCZTVRais2dE0zVDlLcUcwZEhLQ0tk?=
 =?utf-8?B?QXpYNkZ3MHdsYS8xZHJIOTFzYnQzT2RFcXBoa1VOc2Z2eUJEczVIUlptTEJD?=
 =?utf-8?B?UnR0KzE5cCtSSWtPMXcyOUhBaHd2Q3hQOVdDcHpDL2x4OHpHUXpVT2hxNzZx?=
 =?utf-8?B?b1pRTkMvRDhsUjNKbHNiczdwaXNuaWZFNmJ1c3J3Z3BrUWxTRUNNNDBsSS9C?=
 =?utf-8?B?R0tKUHcxU3Rrbnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c142dc5-7fa3-4fdf-d937-08d8b976a03f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 16:57:22.0002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3pDzKoJ5rJjVzV7gRwbgc1x6ELp+/YKnfNrnShFDeCO/a5opviTd0nnzmL8P+sTs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3365
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_09:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=905 impostorscore=0
 clxscore=1015 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150102
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/14/21 10:24 PM, Hangbin Liu wrote:
> This patch add a xdp program on egress to show that we can modify
> the packet on egress. In this sample we will set the pkt's src
> mac to egress's mac address. The xdp_prog will be attached when
> -X option supplied.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
