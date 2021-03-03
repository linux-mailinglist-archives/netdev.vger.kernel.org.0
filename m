Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2600332B3E0
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840252AbhCCEHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3134 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239160AbhCCAq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 19:46:28 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1230UR5f021106;
        Tue, 2 Mar 2021 16:45:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=GIATf0dy1Gu3DjiiEQ5vhfmvEzfycs+khfaTdGQ0zGw=;
 b=orVXD4idv2+LARwwvhX5J7b1pM/qQTd9baLEBYZTZBQ4j99RxBuTNfbK7Wftq++3ygUg
 jTGTf19RFDlLrsfJRkS0kfRvjN/RuWGVfc02ICJ3MpIalxNwnOE8VflAKxKloqubxOv6
 LJ0O4YAJS7ud5o+quiHJMzIatiXzDrz2ljc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3706m7y6v4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 02 Mar 2021 16:45:28 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 2 Mar 2021 16:45:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UFqpYPfUS/nGCL/aiuGpjZOfykbhenIcPoP7qBFwJNdx8YoiRcOPW26GWk+xzjsTYjzDLR4r2+oRQRFGB86vy8t6vNzZkNwZFN/Akx3zI9KNVErifcluWPpvJpB/jjEs6u/xt8Ft8EkzntHJTQDy0219LbZ5IuHUEW722onwm5wqWs06wCGrGKJ9sQEjften6PXDd494idbp3Q6DwM2kC1bgJ/4bU/joitWFGyE/HZIKuYJS5xqWCtU9eKaz/QEDP7Zt0CZlvr5knizrxD3M/pssBH5dJoC1EsO9rKNZo5HyS7GwmfR3IXXnicIYYuihL0K/nx/4ho3UBNzXIXolqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GIATf0dy1Gu3DjiiEQ5vhfmvEzfycs+khfaTdGQ0zGw=;
 b=SlsWb+rfp5S+lHm2UuTa1rvrmo//qYAW15R7682HlRsB47g3PhA8rjlJ30MaRt/YJLEzwza9vBSjb/YWoVrnde3bs6pOPiA5bXkAy1aTYJEBdmivaL4U4ymWG1/7DIOZ/jCdN3qij2SJ7nhFqTtTeeQgFdv4dss8IneamqyGTdZVf3RyRb3f+wvANxVjcm64tFHcYyBMsFvV/OaK4NmiOpyYobGWaFMtPQHrROB/JQwxyPf7tThfyiAfyA1+kqWItIZtx8Pp7AtuZJen9qX2fa4OeuVWXFvdaResXa5f7QY26mmoav5Kur1xuS0k09i8tJSmnIvstauz/p/lepvgyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4435.namprd15.prod.outlook.com (2603:10b6:806:196::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 3 Mar
 2021 00:45:26 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3890.030; Wed, 3 Mar 2021
 00:45:26 +0000
Subject: Re: [PATCH bpf-next] tools/runqslower: allow substituting custom
 vmlinux.h for the build
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>, Martin Lau <kafai@fb.com>
References: <20210303004010.653954-1-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a51cb264-c22b-e0a5-7352-3452c7bf3bf6@fb.com>
Date:   Tue, 2 Mar 2021 16:45:23 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
In-Reply-To: <20210303004010.653954-1-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:1b00]
X-ClientProxiedBy: MWHPR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:300:ee::12) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::1a32] (2620:10d:c090:400::5:1b00) by MWHPR04CA0026.namprd04.prod.outlook.com (2603:10b6:300:ee::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 3 Mar 2021 00:45:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55712728-5771-45a5-8f6d-08d8dddda2e2
X-MS-TrafficTypeDiagnostic: SA1PR15MB4435:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB443564189ED201CD10253EE0D3989@SA1PR15MB4435.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rGXxOWaf6QAJPbayjaRQj0uuAY5V/P8PYJVgiFFz3mKX61RlzKA4/X+itSNh9YNn+e3AKEokY+zZEp83yUwL9rsG61pt6SBgsx/na+AU2DprDoWad7DyVgU8QeGrGKqsvqvs5e8n/Whj0sCirGOgHBnKwjb5vmsEjkl4avr/XoYNakxDPvjd2oi3tsObcBSAqobI1Q5PtsrLP7h08F2ROy7oikmIB97K1oj+sK3IZYHdKsWJlsOJ9zzYU6OqIeItllBGBvLhRFQ/DjD0E7XgoFnZrLQ/aONCdEdtSaQo7+TZ+JCUaNu9jcQWbAtUqnNiIfwOUUfiEnNhRYQ4jBVMv2aanml6/9aDpcaxt8cp09jxy1+l0kEPXnmxcpyzDvRM/ekCCGBIlwK2Ja0Dr+YhpjRauTA4FcJmOGq+dAbStm1OMr/J7DcGzl3ERc0EDbsRbX8clupDUK8s/KAN/grTV+idOYZ7uyu6n2TKZj8X9bGh0qlWossVX8CDEeRKG+xqA/tomvLYcp3YQN2mNT6fM3QtSuN91kRed9jHkbf/Zaf4ok1PYifdV78oTyywQHN9wlAhzryHg9k5DGFAXvVIoGytssVZK8ryAQ9eIkDm1Yw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(396003)(39860400002)(136003)(36756003)(6486002)(53546011)(4744005)(86362001)(31686004)(8936002)(186003)(16526019)(316002)(478600001)(52116002)(2616005)(31696002)(66556008)(66476007)(66946007)(2906002)(8676002)(4326008)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MHZCZWVtdG5JNW5IVTZGN3JsN1BmYi9NdlgxTTBQTU1lRXpKT0hHUllGOC93?=
 =?utf-8?B?dExkcGFWc283NEZrUUpDWjIwTjFVQ2wvckx5OFZTaUZuWmJqMjNtTWNqTDZ1?=
 =?utf-8?B?czlCVHkzaTdQTm1wZk1SSGV5MlJNN1k2S3I4Z1U1QkcxSlJ1amk3N1NROFli?=
 =?utf-8?B?d05JcGdpa011Wk9uVm5HWEtRSlRYWGJsRWk2TWtzUmRuTDFOTXNtbGhPV2FS?=
 =?utf-8?B?ZmVVdXFKdzdVWXFUY1h3b2pGNWZ1NXM1SllGTzltRSs3RFgwaHppbUJ3SGtP?=
 =?utf-8?B?bERDcFhlMEcvQjY1Zm5BQkpSWnlSbzZ0M0JZUkU3QXo2Z1U1S2pnMTFIRDlC?=
 =?utf-8?B?RGtDVG11R1dhckJXUll2VTBBUVhkc01yWlg4dUNCRHlvc3d6N1VJaXZGK1VQ?=
 =?utf-8?B?cVlvSjUybXhUV3Vsd3VyUTJDNDZ1L09Nd21NcHE2UkIvelFhZjN5MHo1Wmc3?=
 =?utf-8?B?UW1rQy9ZVUVMejVuQzZ0QVJ4UC9tdjdLMmcvM0VFeE01SEN6enBLb2g2QzRG?=
 =?utf-8?B?dnorWkozTFdZa0lKZkpEN1hDVnRjemVkL2psY21KcmVVUFRMaTVYaDRqTDFo?=
 =?utf-8?B?V0srb2p4dTNxMndvYVdGVVp4ZkoxbVVpK0kwOWRPb3JZNW5sR3c0OXlDNXpI?=
 =?utf-8?B?V3RmdlFpOWtTMlp3bnR1RTVoV0JjUTh4cXAvRlViamlJdHNlalFhTzZWeGx3?=
 =?utf-8?B?bVRETEdDWDN6STJ5OVpva09IYXkrWlhuZ1RFalJ6eUtGRVlHZUN1M1E2Wnl3?=
 =?utf-8?B?bVdYaXZvRjQvVzRuUmh5VnI5SU5NVm1KdUZhOUZ2eHZwWnlhaURzQ1M1Rm1v?=
 =?utf-8?B?VHhlM045TnUrTlRyQUFlVEJzTU9rSncwSGRyZzRjUEl2aS9sbEV0NnpEZGky?=
 =?utf-8?B?MXBhd1g0QUFyWTIzUjJIVmVxYnROREtiMVBuNThWYUpwVU4xUGh2TUtuMDQ5?=
 =?utf-8?B?eEdRVTdmMWV2YkNnMzlaNXBTVnhOMlMzOThxSTlwd3l0TXNES3FySXZHYlo4?=
 =?utf-8?B?VDRKMVRPUGE0bnRlZVJNWnptOUdWQnI4dkFuQVhJS3BscDBORUVyR24vUjk2?=
 =?utf-8?B?S2l3emxvSkNKTXl4TGJ2U0poZjhFZEV5SEMzZXd6OTBHNFYvbWsxb1ZoWkZQ?=
 =?utf-8?B?YmhHY3loMjFRaXc4TnNqNnFpaWRMOGVOV1ZEUWIzRVNrNFoyRVJieXQ5MVVO?=
 =?utf-8?B?aThnMEJXMUt5NXFVYzRMNFd4MVl6Sk1LbjRpVVNNeEZiUjA4UEFHRUY4dktH?=
 =?utf-8?B?TTJzTWhwQndFN1c0aWZmU2tqaG5Ub0ZJTzliYmJXckJFU2hhNkRaTWpjSWZS?=
 =?utf-8?B?VGlKazdSVndlbGVOd3pGWGI4bXRuQnQzdGp1MGtscjNBWFovdHZGZEd5UXdU?=
 =?utf-8?B?citpMXdld1R1OG9HSXVpNWtLaGU3cS9UZjE1TWRoWWJic2ZCTCs1K3Vzd2No?=
 =?utf-8?B?cWROMHdxaXNBT3JMd1dwMDdLS3JreDVSbUdLNnYvaVNUZWtvMlJCQ2lrVTJj?=
 =?utf-8?B?R1ZYMXhCSVBpd1F3QlU2RU1ud0tMT1dKOEUvOW5yV3FTemp4L3RIZFFOaXF4?=
 =?utf-8?B?ZmxiaDRidUV5cVMzUUVURUkwRGw1SjEwYzFmcGVZL09aMjVLYi92NDFHZjl5?=
 =?utf-8?B?WmRjcmJSL0FxNVN5VmM2YjFJZWtGRmxwUzV5ODQ5emtPUFhYUjY2Y25XSXRi?=
 =?utf-8?B?RmxjVGlHL2d3NnQ0T3ZudndnRGovWmQ0SWpsNDVlZlMxUk9mS25LOGVjcVNF?=
 =?utf-8?B?M0VzWkRoMklJQWxJSVpJWDQrT3g0bXhPcGxqMFBFamRUbFhCVWxkSHhuNkd4?=
 =?utf-8?B?YUtHQUJxbEhLWnVWTDRMZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 55712728-5771-45a5-8f6d-08d8dddda2e2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 00:45:26.5821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZbR5nSJOcHIhjokcI5VyOAk6kePw2JfZ8UdaUlPyp5VL2XACazbAuCvgWIyWHY3d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4435
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_08:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0
 mlxlogscore=854 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103030001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/2/21 4:40 PM, Andrii Nakryiko wrote:
> Just like was done for bpftool and selftests in ec23eb705620 ("tools/bpftool:
> Allow substituting custom vmlinux.h for the build") and ca4db6389d61
> ("selftests/bpf: Allow substituting custom vmlinux.h for selftests build"),
> allow to provide pre-generated vmlinux.h for runqslower build.
> 
> Cc: Martin Lau <kafai@fb.com>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
