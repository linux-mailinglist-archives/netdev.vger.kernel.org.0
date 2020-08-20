Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE4224C084
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgHTOXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:23:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54244 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725916AbgHTOXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 10:23:15 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07KEMMaH014821;
        Thu, 20 Aug 2020 07:23:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1iJsDIqF2kSDSS+6I7MDr/WfxcSBC80rZXaqK1/ljfk=;
 b=oacN6cGArQ/NjCZnYg/+mzJ6Tdo0ZUQmuJRPXhBuI89vyki7KMcm1F0Hbw2LPFwSTbJM
 AD0HkCagTheq1jcEvDgi8QPCnXzVKCKaTbIXp6+jfvPPLWLEaKzV5g8vxO3jMl8PUee0
 i2oVpWllmB38R6FC7L/VGEwXCN4OFlyT7wA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3304jjectu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 07:23:02 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 07:23:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X9dKWvea53pDXpMg8jVmxPtv+B0T2fMH/nlhj0qtJDaJVZJeT9nXmCPxc8Q/7P12Ai6suGdMOHNDM+KagTyF+MdjcEAoQUZ3Gb32P9rqsuKXCuyj1EULUVSrCg76h2IAaPdagSrI32qD7uMfGg34TZLXfv/ot3eljK4cNDJRkm7YT/VHSGrM0+7gHkIn2SHMwEgRd0S+1r0rA9i9dTn6v167/PTGzKkiPBjhYdbSI9f0T7ooLinaJEjH+gYerNBM84tnq8heHsXcsZgA97hgsWtxjGFGgy0vGn3QxEXQpigRNW3AuxpTHIHyw99n1AYHMLmNYCl6bGFFw2yaXjz8qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1iJsDIqF2kSDSS+6I7MDr/WfxcSBC80rZXaqK1/ljfk=;
 b=FOcd/ZWcbIqEswOx1wnGBLzbIUImWYhNgrBydV2vvc2FyLg9Bmc68wxg6WyTT7CmHnE9FZklrvVr0o4MTVYVpLcJBM9oNnJjxcDu4lGjwAU62IHp2t9MGsJZoJx7BC3PQ9IOmURSAT1cogL3N5RckNfu2bQgu/NZDCedFXw0bTHJc8jZOqxdxQIC1STlfMKO0Eyyfh0aBbuw5YW7OaN/rz2FFqAVkxYN4czUApJuG0zmjbyh8CVpyNCTr9+eWsjlpFA8nzz2987QYroXyV5V8OAL5Twir6OUcV3ITYAecOcd9I3H4AorvEl1AuTiahe8RyMGjRlEXG0qwf/mKjRzsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1iJsDIqF2kSDSS+6I7MDr/WfxcSBC80rZXaqK1/ljfk=;
 b=Kv4kSl/8mx7YZvHY4vpECnWvVVGI6dhOj5Etzk9cc90g2uwwQbvyhUbhpQrOeSg/HIkGtlZ1UtjTRE0/qBINoRPZnaJt8WOyzMeH8Fuy0ZMQIYO9+Y7MW1XDZ/wLdc7FZcjHwCqlDnuWYV9gkdjfmyAMNxAczNx3k8R4VmlPpAg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3047.namprd15.prod.outlook.com (2603:10b6:a03:f8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 14:23:00 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 14:23:00 +0000
Subject: Re: [PATCH bpf-next 4/4] selftests/bpf: list newest Clang built-ins
 needed for some CO-RE selftests
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
References: <20200820061411.1755905-1-andriin@fb.com>
 <20200820061411.1755905-4-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <bf153b84-6489-549d-d9ed-354801d6ab07@fb.com>
Date:   Thu, 20 Aug 2020 07:22:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200820061411.1755905-4-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:208:d4::36) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR04CA0023.namprd04.prod.outlook.com (2603:10b6:208:d4::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 14:22:58 +0000
X-Originating-IP: [2620:10d:c091:480::1:7ec1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a90aeaad-f937-4563-d694-08d845148a49
X-MS-TrafficTypeDiagnostic: BYAPR15MB3047:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB30470B28610AC08A01D23BB2D35A0@BYAPR15MB3047.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aLbR6S5DUeYABBBlgywstQIuvVqVVtpky8QxnSu2VxjYF0jo6pqU8six3PflLVL2ybn3NSoNEUbjymSgEo8aZjHTNM1WA8XMIaoe4n9ARYYC9emko2Nz9WcfU6BWYT0gLDgH4PGBiPBaxWNRLtiv4JPv1K/AQ/OtjmFYlUk1gWboV8vOCDCmo7ENrEUNrLGprUIjCm5HyrTHIbm59f1GUYUQSNTMahvtBFMqzu+N/CLBmKyI1y6dlV1CmwGX2R6BVF+hpu3uLBPux7MoMhNayG+0LJZGvXD2tc/AMC52yBrkXc5WFgacZJx8JfPP6lEp8bz9N3Xk236zARFqxgU1WpA3SoQui/ocpWpveWlA6fkm8VJ0czaCkNnS5S5UzLZw7chiBhVQvs/aji1kLqEiKBnxE+aSZYblcSVvkWg6nc4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39860400002)(346002)(396003)(366004)(4744005)(36756003)(478600001)(956004)(2616005)(2906002)(8936002)(5660300002)(8676002)(66476007)(31686004)(4326008)(86362001)(31696002)(66556008)(66946007)(110011004)(6486002)(6666004)(186003)(16576012)(53546011)(316002)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: q//4n1fD4MbJyE00Zacemo7Uth2FM2uwcVu9n/o7zLGrmZsFegL7qo/GP/EWxWQyEL6J5B2VhAFeZd8KWGBfXvG7Ndphm4OslkP9wJ7P1eCJfLa/PMridaFJjcMh1yscsOIHr83p/URj+S17S1fjTLVdSFcU5U3yY6EVMh4FwxsV7LpgOWsJ9GwTBDSb8xpdb5H7n5qenjYjkjoIHk5frDacf1a6hm3nD3Du1RQSFTw6GR+c876JARghUlY2frZSTO//n8dLHNiVPWNz3wPU0cgiO19Cgj2Nibu4kqwlMcN/PU1kgG4/Jc/pe/Y2RI6S1lZ/iBek1MiQ6XZp/A3OlbysKN91hN6HGY/CuOnL9FNaX4sJxndo3CgbDO2ItHRpYvUbNUrscPBXPVgFVzbEBilU6CWHUArj2FDZB1RTsjqiDzeiqVjijwfdUtLVuZxV3ta5auBc8oDGyoRpHzdoYmYNaXxCjMHexXJe5/bsX7rSQ8yCY33E8Ex11ggjJdr5A6TFhYPs7Q2jCXzh3iUF/pfhb2Jb4rCJ98FOLJN3kxC9YA8m2poe1vjtHDUxTzFcnYZIVOzwHxh/A3QrjqfOqHVF8EHRiHy/YB5/PLgDmUuz++bBZZYDgY5uGbNZ5RP7Lj3N/ag6azLWG31YcTnjVJBGbbEJiIWdR+9b7nar6TMKpyKPj8PNxmfkyFEpCMUR
X-MS-Exchange-CrossTenant-Network-Message-Id: a90aeaad-f937-4563-d694-08d845148a49
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 14:22:59.8780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zwHYA2wl7HeCt3LdcOqrNVaeNg1wFoQYYY5/PA9jM2Qj+Vn1ko0vxhV3BDNc1tId
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3047
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=948 phishscore=0 mlxscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200120
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 11:14 PM, Andrii Nakryiko wrote:
> Record which built-ins are optional and needed for some of recent BPF CO-RE
> subtests. Document Clang diff that fixed corner-case issue with
> __builtin_btf_type_id().
> 
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
