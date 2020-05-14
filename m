Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167B61D3887
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 19:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgENRly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 13:41:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7972 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725975AbgENRlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 13:41:53 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04EHebbk019939;
        Thu, 14 May 2020 10:41:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=oT3KiW5RbKc+MF6INd/iCEuOvYulAGaVY0F89HjWlic=;
 b=VO/Um3sD+HGJYxxy5XYNOoWiFLvjCTNg9YJHVzdErqIS6PspwrAB5kmXrfG66GQFSOAe
 AbgCD5/NetKsAFASknSdHI/S3//fMaLBvdjTwW5oL4o9cSFIqWkRXrSLpdkQQ1FOoTlo
 IFwmEY7+UTcGa4RUQe5Rar4G2ZGlVYHP4ds= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3100xhcvft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 May 2020 10:41:36 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 14 May 2020 10:41:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QqyD1Niw1qp1UeSsLnBZGDTP62ByttiZYaz1BKvAm8VjIAl8bnZAaR9b2zPeWJcLrJJ/KFXE5h09lI2c7M5vti7rARhg07eFzwuMZuj7lOpr1EdBxM7M+TaNaVe0nW8NRKNK44qqfbpW6XSTQHechDBpmDjdpe3vEmyW1uy5JVR7rR0+WaMZkpd5F0ICCqAHnIbYWKBac5pXRy/ZmLacE22bgPoQ5q8S/alruwifRc/Xudlv0ymfXULKvFQXJfAypLdSDhhSo6OcVpzziL2r79lojk6pvJEGcb4QbeV22S4kRidMKPHnpQqRqOf7gGHPj2PyvC+7JCGMIAL4OGG/1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oT3KiW5RbKc+MF6INd/iCEuOvYulAGaVY0F89HjWlic=;
 b=mPIFRZI0TE3fI77HO9PlFMRy3tYWUuWrJe5VhGsXgqVboEJVRGAOfQup/GnNslvOZjd9A6bwMrN6QmBpj+o5rKUh0gBIqYnIojnKe+RLpvDygfFC15g0l+lDV2L54fMEZ7ZhKwpf1rLJazDMnYg/80hOG+vnvb6UoddsoyG54jiO16J97fnuJbtWLEJRmQmAbiSZPBzEVRrYH57yKLU9LmTadI49LB0Wu+PtGxwZCVUunFQpMrppZ+IhzxPWFD0eqNIX7rhw9PsedjX00rfvFWxSo7hVq1z1AWqHvOhhWyx8FUV41BSSHI5SojkJ77vrauN2T/pxJlpO4+6PybjdBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oT3KiW5RbKc+MF6INd/iCEuOvYulAGaVY0F89HjWlic=;
 b=QJsKMlaHvXRFUoQUNSZ0WlYU29TGj+H6qczaVcysnm6+CAGf9wbUH11OlAVhsNpWo/rf+zukU5FfzEdjhecopULun84kQ6mcXHm7hofx1qddbu2Pq3ssj4Wt14KJNMisVVpTi1CPSVveTwMVphZ5fXfB/yZtQPdeIwa9QNzoyM0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2855.namprd15.prod.outlook.com (2603:10b6:a03:b3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Thu, 14 May
 2020 17:41:33 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3000.022; Thu, 14 May 2020
 17:41:33 +0000
Subject: Re: [PATCH bpf 2/3] bpf: add bpf_probe_read_{user, kernel}_str() to
 do_refine_retval_range
To:     Daniel Borkmann <daniel@iogearbox.net>, <ast@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <torvalds@linux-foundation.org>, <mhiramat@kernel.org>,
        <brendan.d.gregg@gmail.com>, <hch@lst.de>,
        <john.fastabend@gmail.com>
References: <20200514161607.9212-1-daniel@iogearbox.net>
 <20200514161607.9212-3-daniel@iogearbox.net>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a831c339-1f30-30a2-b83b-4c7bc2500f7c@fb.com>
Date:   Thu, 14 May 2020 10:41:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200514161607.9212-3-daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0039.namprd08.prod.outlook.com
 (2603:10b6:a03:117::16) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:3bff) by BYAPR08CA0039.namprd08.prod.outlook.com (2603:10b6:a03:117::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Thu, 14 May 2020 17:41:32 +0000
X-Originating-IP: [2620:10d:c090:400::5:3bff]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd1ade1a-c9e6-494c-59bd-08d7f82e0b01
X-MS-TrafficTypeDiagnostic: BYAPR15MB2855:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2855D521ADF93C8643498C89D3BC0@BYAPR15MB2855.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 040359335D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e4vVa5VD3pLB/9GgwmvZa1vRcf4LYagoRHi2SKHJ7QtMTtaIuXkV9XubjyahtGYE/B/7wk77QSmKkdjFcVd78liSZPWicT3tnNPXd+efGdsjC/qFe0evc9TA4NG1i1VtlekAPvRX3GjfY2vW9GWR5FTkqGTbcTTrJWff6K69RuPdPmHiQcMKYcR0JPEdVFt4rtU3dumET3EnrlOdNdBqOK3sbreIdN3UyzjsJJLSXBlNBjsrMlTf7UaTLGhfrsl7y3/KM29JTqrXjeASve7PHdgtPiwH8bMctY4+ldtQ31tpRGtHqyeuKCY6YVK1u1YpMHR2RfoekKefukz4wMEhbMqMrcLtnhFz9j7WKRZbfz2VqSIx8nqI+CTpks//hz7OValJzDM5rBeUxFpOqbQK1p6YuthNKGzbkWwcnt6031kl8bTtBglLxxN/xPqATXAGzB1N6LOlW8Upb01dXA8eZge441h6bnlCEnD8KmrSi325lA31ON6ZkanLNSvrd0Gi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(39860400002)(136003)(346002)(396003)(86362001)(31686004)(2906002)(478600001)(6486002)(66476007)(66556008)(8676002)(4744005)(8936002)(66946007)(36756003)(2616005)(316002)(4326008)(31696002)(5660300002)(6512007)(6506007)(52116002)(16526019)(186003)(53546011)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: m+uHhknTHbNYMNRsNZb02WqcanjOKfL6Wiies2MDgvXQ7FXHjqtO7QDw0ZKcTKDEuMibFu1Qy8e9hNcUjcqUho7vM5+h2HqPFUgg+u6qN9GznCvaZ8gi4d7WbslRWJVrouemmYu8beLN8e2LuvPMJlAXdSNW/AmHq40pH6FY/F5o1gEV6DiIhBrkR8oCeR62aU1rWLiwEi6DKTaIolZUnZmumTuG3WljqbCsnBJ5DosYeKJvbXH6JAyE85oYwpiUZCKI81SIse+E6Yc00WwPA4vX790HRM6o7DFH83X7HPPKd7BWXypjua6S+Z0ztatEfBSH6m7VIoAp5IztUc/5TmAo+HeoeqouiYrbb3nfWzZmYmw/vKyB3sv8TEGUxW7ChrvXhTczihvVuys0rbgnMZNnVYIXjPUHcpVLerKy2tzpPVXwjUIkqpkgv9V9behDYcskOQbmLz5kdaW4Fay0egUb9g2iy21Ucnyti4kpJb6yNEa4W3UfSirJc1meJ5gn6UtNTZEB0CUQCsoavCJJYQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: cd1ade1a-c9e6-494c-59bd-08d7f82e0b01
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2020 17:41:33.5834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: im4j4QMZojQ5Hps0O+d7P2tbgwM+kUUMkuROhqpdb65O2WI7T5WxmGdHlN3h2TQu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2855
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_05:2020-05-14,2020-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 cotscore=-2147483648
 mlxscore=0 priorityscore=1501 adultscore=0 impostorscore=0 malwarescore=0
 spamscore=0 clxscore=1011 suspectscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/14/20 9:16 AM, Daniel Borkmann wrote:
> Given bpf_probe_read{,str}() BPF helpers are now only available under
> CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE, we need to add the drop-in
> replacements of bpf_probe_read_{kernel,user}_str() to do_refine_retval_range()
> as well to avoid hitting the same issue as in 849fa50662fbc ("bpf/verifier:
> refine retval R0 state for bpf_get_stack helper").
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Yonghong Song <yhs@fb.com>

LGTM.
Acked-by: Yonghong Song <yhs@fb.com>

