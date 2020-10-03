Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4616282091
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 04:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgJCClz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 22:41:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1604 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbgJCClz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 22:41:55 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0932dE7B027310;
        Fri, 2 Oct 2020 19:41:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=nvyq2R1/7DweWL+kvcy0DqVtbOJXbzaI6sVlGk6TBNE=;
 b=hhdsHK1egZ5uDeBeJD2GZo9kZjJvvFzDz5yyEa6vNJsQdtyl+zZFbEUOKh7kzacArKK/
 DeYCoNT9G1645DLj7k4Fsv3U2sKR3H/E/0dqmrssphfJgrd4d1EoqDoLJUecYg26bDjr
 8QffX9rj7/j+L9ix9Q+inwx5/HSeUeHgEGs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33x0n24qun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 02 Oct 2020 19:41:40 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 2 Oct 2020 19:41:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyeEKbGSxqXN2BQMZXQaFIyOivmBYtN+pHzKOykxQ64r5Odtj0eboAUPhb5E+YxyePcTkARzhtW1kVVlsJnlZ0MGWu1e2O9E2SRYnp7Je7MxU+qxCZxzZ2ozsW66IIbVLEf7XgZfHTTEUKyODmOD5Mi3Pv4EoP+LfNt6wAOj4VouU/kYv177NX+um2hLi3k1pkvGC6zVaDCrbyEdpUr6kTw/2+W9QysR8lyj7EFNJCS30qk0ZAnoc/vT49N8ZyJTful50F6u7B4Q7oRDvmWj7GwJ88crbe25sqX+ZG5Dml5RtimHAD8FgwwQ0HMzh5hb78mUF0VgV1Rw4sgwPaSJ+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvyq2R1/7DweWL+kvcy0DqVtbOJXbzaI6sVlGk6TBNE=;
 b=C0ekNl2C1GG7aHXLYFVrQ5HfAMWy+e6HhmgJkT4oWuhIooxOVM9EAcuqMjxsjQvVX3HV6nVyD1DkNCUumKDiWfpopIFpQEZOJF4U6EgY4cZUiRowhVXwAvnFjt2sxB0DRIB61P3QtqF1o4HtJ8r8E1GT5dktLzU9mPnRFUS70+WG2tzpKvP+lw0NFY/aElsW2CkaY+T5GkD6Ib+R52Jlog+skAwO+qlj8ky34COqtlPKD6RLk8mrCVj8veZ4t8PCxyW75x//sP4b+MNeswXYDCc14T99Dddq1s8x6Ndf+Zdn2w5O2aAqK60915838rzXaObmI7qSr/qc2QfZPK27SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvyq2R1/7DweWL+kvcy0DqVtbOJXbzaI6sVlGk6TBNE=;
 b=JW39eemGP/ZWKjlpWGos+5C9wKOu5mIx76mS0hl9ErZWKyzpwCdLD6247j4+G1hhyqLVlGGaC7IBVsHrjqF5oMIPiJaHTpMXzu58bBUQPwcGi5vlJRWDvUEm0OG/NVBVfkCwA+1EB1mPHyzCqUg+WDdxHY0w4MTVurMdS6+WWCg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3094.namprd15.prod.outlook.com (2603:10b6:a03:ff::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.39; Sat, 3 Oct
 2020 02:41:38 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3433.039; Sat, 3 Oct 2020
 02:41:38 +0000
Subject: Re: [PATCH][next] bpf: verifier: Use fallthrough pseudo-keyword
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-hardening@vger.kernel.org>
References: <20201002234217.GA12280@embeddedor>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <3673ee00-3bdb-fb02-f379-849d5881d3b4@fb.com>
Date:   Fri, 2 Oct 2020 19:41:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <20201002234217.GA12280@embeddedor>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:7e45]
X-ClientProxiedBy: MWHPR1201CA0003.namprd12.prod.outlook.com
 (2603:10b6:301:4a::13) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1836] (2620:10d:c090:400::5:7e45) by MWHPR1201CA0003.namprd12.prod.outlook.com (2603:10b6:301:4a::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Sat, 3 Oct 2020 02:41:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 343b7627-5a97-4fd1-9466-08d86745d9b7
X-MS-TrafficTypeDiagnostic: BYAPR15MB3094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3094DB85A4E750A00B9E58FCD30E0@BYAPR15MB3094.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:747;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qG8hG2UqOy0ZVTrsSwIrOSzEIBCHnMnh6Mu4lEVemgDI6KiwCxl7QUoY4Ehr5v5EUWWOQ77VYx0tb8psXG8Z83RNrqGcLkiMDSE5FoXo7OJREGoZTK3TI7LS09QlaFnIBCovGEC3g9dcq+jV7Ix8cIRR5N5gBhpWvmsHDkMtkqD+d8nXmNdNAXKIrjqfydKo2Jw/lmyTyTUE4yQ6igTS30/avshXcYcFRnGthgYUujg9DpwoisMEC2Sy8fJmrUq/xZVH0L4ydwEuFL4VJJF0PIcRIWKFChuOYsm9nZOb5A9G+TYhWc96vYxaK1BHZwaWZ067KDKEtCvsu8qnpA6BYPZ+UCEfuE1e257BjgQKLZ48+BC5U0kLeRqFAlTZPmCWI3pTOdFKbnc4Br7JKxPP5cOKMTWAPWa48zIdv22EUFkFgNqr+6rBKnEDYAMAjp5Yt6aFPONapGqsZuTKL4gmHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(346002)(136003)(376002)(83080400001)(86362001)(6486002)(52116002)(31696002)(966005)(2906002)(478600001)(36756003)(2616005)(4744005)(8676002)(8936002)(110136005)(186003)(5660300002)(4326008)(31686004)(66556008)(66946007)(53546011)(66476007)(316002)(16526019)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: EemoctjEy1miUQnMmyrIGpXGL9EeLHGTzPiITL3CgIA9xXz7WwnY5wGUZs0SSvpboAbx73sDCrrHaQvg6SpGptZa7fyo1Cp4oorb+Tj+4HhVfCAwqn1dVXzBV4NIB9S2aDamKAZrT4kTf/7Nu/CTxR1qIJgiDdWlife5kzIZPyLTMQvg+9ASZm0KJ1LoNA+hkPcgGzRorMMoQX/XUtZv+J/xsOVJ78JgWDwuK61/CYmR9a17ddmtjVFOUJB8f/5mSxErWJTshp8hsVHZ8Qzy4qS8CnTHOnjls5KOlPHKSbD7YhN9VeUjJxaEfumjh/cALbNSZj4Yjjd2pCrMGqfsA+BtkF3clSJbD3UepnIyS1ZQdJfpi9qg9zwd6JFVYi+kG7do7Xtyvexp5PLfhsx0pVOWCFJTc3xhcJ5Pxow5tjwE9HqgP8rw9NkwNqcXlD/rUxNOZyleREKxtShYI16+psILGx/AnDqSPLdhx89s7yBagxLBicYp7zJ8S5HHEuZ0cbWXx2RbGR/ffYRxnc4x9nNCcfrW96rVrcD5tYpuyBxxha0/Wl4Hz+fO3gUgGklV2i2geUz1bG6RT/FbZ5ScE6fYX3LteHlXMumdbdf5Qa+2j3ZzuRCdaAeTTM0rrh4+bCBxbUNHCi80FdojS3ACkguZKxuBxA/cRxA9DBwAmdw=
X-MS-Exchange-CrossTenant-Network-Message-Id: 343b7627-5a97-4fd1-9466-08d86745d9b7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2020 02:41:37.9294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z4xeLt8Z/9voag4OVlnJ3L/jXjNMsYTmUK/GdoiEX7mwjpU1dHC7ntqC7uGzDVfW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3094
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_14:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxlogscore=590 impostorscore=0 mlxscore=0 phishscore=0 bulkscore=0
 clxscore=1011 spamscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010030023
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/20 4:42 PM, Gustavo A. R. Silva wrote:
> Replace /* fallthrough */ comments with the new pseudo-keyword macro
> fallthrough[1].
> 
> [1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
