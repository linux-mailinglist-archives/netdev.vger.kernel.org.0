Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BED232C474
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241223AbhCDAOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:14:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65508 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235524AbhCCQGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 11:06:20 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 123FwVQR012598;
        Wed, 3 Mar 2021 07:58:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=5I340MzWvBtD3/O1VT5Cjp9Ni2xzATYtwTjxra5TfQg=;
 b=qlF4OmVuq/nVPT3ZPYXt6dqi931XE4tCBDSIHG+FmdiOmN/gYUKwQoRkM2lXRVWSDVU4
 8yglWlutQQFrJ9ZFVI4h9/7NSBEEE62fiXkTzgSZZtZLVLk6Mj18MX3ZL+Cmp3Svw/1Q
 d/eCT/fowDxwSYtPK+FxNDTL7Z1RoH+y5RI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 371k6prb32-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 03 Mar 2021 07:58:45 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 3 Mar 2021 07:58:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ecs/9XDhHuzshbnUbTXrCxGGT39/oSH3YvN0RoZgPpRZUcb9k3PcbbQFjtZlrv29qMaicctw8zWXAB0hnAHh6McvbIrzzmUyNQxrRDe5sWBBvjbkwheLSWOJ5+PjMsRsO0Rk3Aw50tbyJWmy9EeQfHD/8tcGoTSirDN2pyk/9J0ChENwN+bilXeKK7PWBbc9FBWNvHCA/8g4h1prq+olfNvlmUqlzqZ8goeHUqplBgb/2YOBBo9Bbz0T7clNfutnTS1nf949QpMQOmnhLJvyXkdqPcJN/CjgsnO7l42c60pDMzyaiu4Om2/SZCK/NcHf5PRC/mGy845Vc+o8Ds39xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5I340MzWvBtD3/O1VT5Cjp9Ni2xzATYtwTjxra5TfQg=;
 b=BiVF5dkwuSzRGjajnS+7P8q4XZfHSjKFbY1ndjm7b4risfM9WYZpHW7+ccA0xcd+KZ9k0zBXPIPDcUm9ekjKMbIjS3fapSViiX/tGRtboz1NA5uZoMEeH1U6YcW656/idJKRkTqt4GcGl+JYc/lFhe9Le4aNeMduEFmb4FUdfNqO5aWbnbfztQqYjXVxj1GXniHPQz2ggFUdCxN4mGZz5VzWDFi3PleeC9sNweYbXQXgZtoXvz4qak9y5s7pCsasKrmWtE/Wx4zunCdMHFenWGUa1mLDENgHO+H76nAevwQOF1GKOHECBepiRcRxsJfX+zzbSkNHDZmFds+AjosxsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4434.namprd15.prod.outlook.com (2603:10b6:806:195::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 3 Mar
 2021 15:58:43 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3890.030; Wed, 3 Mar 2021
 15:58:43 +0000
Subject: Re: [PATCH] selftests/bpf: Simplify the calculation of variables
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, <shuah@kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1614757930-17197-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <cd5b490b-8416-f0be-1e80-12efedba6a86@fb.com>
Date:   Wed, 3 Mar 2021 07:58:39 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
In-Reply-To: <1614757930-17197-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:94d2]
X-ClientProxiedBy: MW4PR03CA0372.namprd03.prod.outlook.com
 (2603:10b6:303:114::17) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::1a32] (2620:10d:c090:400::5:94d2) by MW4PR03CA0372.namprd03.prod.outlook.com (2603:10b6:303:114::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 3 Mar 2021 15:58:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 856183a6-2dc6-42b0-01b3-08d8de5d385a
X-MS-TrafficTypeDiagnostic: SA1PR15MB4434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB44341F766A1CFF03A4619693D3989@SA1PR15MB4434.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J+O97iPWynymPAtOCXcbaoJ8awzUxiEf24EOmayEj7+8OX/ZZUb6tG+k4hK+Tkh0BtrfhjL9n01Jg2ZVDvU2eHbkOX6xX+uf/EtwixeKc/lu/F0MEIL7GTlPVJ7ZfmsIXaCk+YM3qcNOW5NQO+KnB3qJVbbTJmVpVVpcpAX2EH8D2M5uqg3AVA+pJbcUyBDio3EJkV9jI9GaxWwQTH09C9Hg37VpE2JKFhxUds3z1JqwerSx7QimWZ+AseBawpUSi/nqTbUXgDR4Ew8A9om68502gi0nbN/s4it5oF8Vk1hCcRr/ks10MA4STOEcrf/xrg8HoCCE07WZT1UyhwpBqhoDXiOrC6Q7pos2aGKMZMAZZxPfT9phOvmZ++vAh5BHOC5JBbW0WTMmFBwjBF0rid7nxGlqiBn5FNIDks69KUlK+lILsxPPbM6tFt1MN6JWrooBRoqgTBe/v2Bwyr6oTUCM679TR7n1Edcj/h+uzwS61YmaOXgJHLYZ2l+aGTOIDnRJMWO0Ew9j/++8cCgh+XWS7GlgOXADHP/p2D9t3VtL2o/0NKCKNGIThesaG3h1c9oSHdpCYZm9Ja2LrnOlFs8d9R+oIm6a7DNhOAs6iQo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(2616005)(86362001)(478600001)(8676002)(6486002)(53546011)(316002)(4744005)(2906002)(5660300002)(52116002)(31696002)(7416002)(4326008)(16526019)(186003)(36756003)(66476007)(66946007)(66556008)(31686004)(8936002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L2I0d0lQazYxTnoxZGg4b3ovNmhYTlBPeUswUmFJa0g4YjRyWlEvN2NBTTBq?=
 =?utf-8?B?RzE0dDVUODY2VEhWakU4anFTRzE5UGtiOEM1c3BiYlhudENJQUlnMEwwb1h5?=
 =?utf-8?B?cjAxeVVRVW8vOVc2d2ZWMWhuMDJYbTlNWGowaGdlOGtJQ1BQZzdDbHR4NmQ2?=
 =?utf-8?B?anRlZlI4QXA1UUVjZWwwK2J3YXUyNFk0eTFDRFdCREVLS1o4QWpLNjRTL2Zj?=
 =?utf-8?B?YVYrYWMxRWZGMFhLd0ZNSnRZSGgydEc5MmxvNUVYTmFnczhEZzA3ZWlpaDNB?=
 =?utf-8?B?cGZHaGd5aWNYQ01DY0RqY2VkZUMvanpUMXZWNmgzeExMbFV5bXFCZnlLN1d4?=
 =?utf-8?B?YVB0T2tZZlUrZHlZTWZ4YzdlMkt1T05jN1kvdE5GWkRadjRUTG5ZTkxueThP?=
 =?utf-8?B?NnVsbUF3bWpjRW9GL1EwNGhvZXQ5RytzeWFMYnd1VE5HSzQxZjdCTHZ4eEs4?=
 =?utf-8?B?a0VqTGF0OVIwTERzUFZFNzZqRGR1SndzM3pHUTRmbFh5OTYwUkw0SGpIa1o2?=
 =?utf-8?B?bDRVZHk1QnlvNmg3aExGQVExQko5VEpUSU1CL29kREd6cWEyMW45ejNjRGhK?=
 =?utf-8?B?Tm1XTTdSM1VLckNMMndqelJGWlovT0ZJNHFBeElKQmE4WHBJUERZbHlZRDg2?=
 =?utf-8?B?YnRMNXJJNTFPSWlQYi8yM2cxOXVNc3VIQ2UzZmloc2U2ZVBBSm1WUVpyYkhs?=
 =?utf-8?B?VHlIUVBlR3dFSFJwcVZ3Nzd4bjMxMlp1OXpac1NmMW5GVy9BU2I3TFNpcWFK?=
 =?utf-8?B?L0JTRW54OHBINHl3K3U3Nlg4MUx2VXZiUlRGNjlvUlo0MnIzL2NZL084T3kr?=
 =?utf-8?B?U25Zd2hNdlpmRXZrc0tiOUVsV0o3Mzk4OFRtN2ltZjA2N2ZaSnJQYWVaMWp4?=
 =?utf-8?B?WCtnb1FvVmFSRmVVVTYyRVcrR0hPdUh4b0tyUW5vczBkcUJZT1BaOGZ0alFj?=
 =?utf-8?B?djd6QWtIUm1wcHVESXRrNVZOYTJQVDdIV3pBb3AwdjliQzE0bkRrejBZYnRF?=
 =?utf-8?B?ekZYazJ6RU9Zclo5NDVLZHF1UldWTnZUaElyUkZ1RHRiNi8xQTF2Ymd1R3dB?=
 =?utf-8?B?MVpJbXF6YVgvcXl6ZjN5RjRDR1Q0WUhZUFFuRzZpL1gzS0I0a0g2c3FnclRU?=
 =?utf-8?B?ZFJRd1VMRDhJaWdHRmtLSGNiRDV6VUIva0pmZndhUXdhRkNYVk5RTFF3a3B5?=
 =?utf-8?B?YXl0ejBuNlE0d21NUC84a2YxOThvQjF2NVRjeHdXN0U1Zk9jQ2Z5M0x5UTB2?=
 =?utf-8?B?bTdnc3pONkdGbFo1WmVQQ1JBTHplVWp4eFJnU01FMnMzOUlVWFcvenA0blo1?=
 =?utf-8?B?eVZEdVR0UU0zK1hYb2FXQjVlbms1dVVGcXZ3Qi9sdisyUzBUWVpQTnhzTzVy?=
 =?utf-8?B?eTFWZUl2NGRoNEVvbWdMeHBDSVl6bDlNMDFNZG5pRTZ2MHBmTGEyK0F3c1Qv?=
 =?utf-8?B?b3kyUjdwdDVrVStWZkN1cTFQQkxuK0taWWhMclZBZjFTTlZvNVhHSGh2dVJL?=
 =?utf-8?B?L2hSOVBFV0poWlN1QzE4WU9SNlNVN3JESFFDRkhvY2VtdEo1cHRkYkl6VFhQ?=
 =?utf-8?B?eFNvNjgxZlZCVEthSGM5VytFSXF1aU9FejBxMmpQQ0FVQmVxZ1gzMjN0RGZt?=
 =?utf-8?B?RkdMUGFXNUt4WWY5OW9NcDhrZ0QxYmxwWkc3SDR5cTc1SDNSa2NWYWFLenln?=
 =?utf-8?B?RG84U1ZLZnd2eXdGU3Z3cDZ2ZStFQ1JDL1RCMk8vNHF0dEN3bnI3WHUyWGdT?=
 =?utf-8?B?YVRvZmMyMjg1R0ExL2RJRkNCS2RuNzJwekhyamRKQnl6V1M2c1dvbE82ZkIx?=
 =?utf-8?B?cVhGTHRhNjY4WDBMWjM0QT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 856183a6-2dc6-42b0-01b3-08d8de5d385a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 15:58:43.3541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dKZC+jIiBAlpT2qHYkZnpB2EwskmLVzLYG5zuZ7l+k7kiELTYL5DN2UPi7XBfPgE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4434
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-03_05:2021-03-03,2021-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 clxscore=1011 lowpriorityscore=0 malwarescore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103030120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/2/21 11:52 PM, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./tools/testing/selftests/bpf/test_sockmap.c:735:35-37: WARNING !A || A
> && B is equivalent to !A || B.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Acked-by: Yonghong Song <yhs@fb.com>
