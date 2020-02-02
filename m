Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCE1614FE66
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 17:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgBBQvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 11:51:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9460 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726885AbgBBQvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 11:51:09 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 012GoU7X009223;
        Sun, 2 Feb 2020 08:50:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=EtPkO1zn2fMTnMO9paBK2XYnpgw3iHc0Y7IkafuPwz4=;
 b=TwbRO//dRMhKcJlypCPtFhpGYXmQccJ1Yu7amq+gvPYlIqGIU/rbnwf3EUoWpF1MvX45
 1BO/xv/c91W2QjCSYfOGvuYgJ/5/DTBRtwRRbN36Q19/zlkcE4dSdi1iCU10TnklkbsJ
 3doHUhmAHROkd4AHmKj9HUowtazGOo+cS30= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xwsrv94h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 02 Feb 2020 08:50:53 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sun, 2 Feb 2020 08:50:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dN0En/e6KLX5RCWpN5S2EQmu0rtGttbzvsHYxOtWWDB3ATSjahlkYhOfZqdolV7KYYX9oQ/5thSINFiTotDBwgiWTLYNjNISz92cFMHnHmljRwAgSO1iqbhD5kQoLQd6wVoWRCdwXotfau26tclAjhgFV6wOZR+TnfkfZ6uNVR5FolUl/BulsFzblNsRGjnglzB2GBFKU5QrmSPGk3TQG20cn0hcQIiA2A2hqRoUT83wioZ889KRPW1F+bf35C/gYiKrx1RVNo1PSfNohLRjxmLIV3GYaGqYCRWyrSZjd35Slswd6+2OHRsB73gd0HBUZnOeYJnnCDuXznW2si/ZRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtPkO1zn2fMTnMO9paBK2XYnpgw3iHc0Y7IkafuPwz4=;
 b=S09h0LGAVXhsOl4t2qUJ8UMO7VkeUnrUziMyb/qI6It13mI+GRims0wYiHMdm+M2aqGn6Z/VwWmAB7lto9HZwrfIzU5HLoiXLp+5WzgGx09xcujSRoiRtBTIqeswWqJ9o1k6RtsMEgtzyqXNPt5EExs0kRrZPsIbcpSmMJTaUsZ/jDv1kaEBzCn/iESxAvtQAHDsCX2lX87Itewpw1o3ILkA6cyiP1CPHKTAt1bFuMWVS9yeOrJKMaSmVutPdir8vJY9NGZqGboIn26vkOW4HKRjFt4SLjP49E5xm863cfN5wXZL58HmYXFAyaO5t0Av6tlN6HS9Bu9vrInVZJThZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtPkO1zn2fMTnMO9paBK2XYnpgw3iHc0Y7IkafuPwz4=;
 b=KRw4nGB18NeyyjL7+g5cjuIZDMcYIHu1VIUq4ope1AZ28qswpfulRrmszp62uBI7UMBQxYfhgDlUmJsLBksjUDS5SbvJROI787Wt3C1wk0w59VmKcFNLDIGRKy7RV3otZLJU6Da5VSIrnFoQsdRsHBhwI8llYjX6FKjt9qlnalM=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB2732.namprd15.prod.outlook.com (20.179.162.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.32; Sun, 2 Feb 2020 16:50:51 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2686.030; Sun, 2 Feb 2020
 16:50:51 +0000
Subject: Re: [PATCH bpf] selftests/bpf: fix trampoline_count.c selftest
 compilation warning
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200202065152.2718142-1-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b26f4053-898d-8bd7-6750-9c5838a3db02@fb.com>
Date:   Sun, 2 Feb 2020 08:50:46 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
In-Reply-To: <20200202065152.2718142-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CO2PR04CA0180.namprd04.prod.outlook.com
 (2603:10b6:104:4::34) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
Received: from MacBook-Pro-52.local (2620:10d:c090:180::7efc) by CO2PR04CA0180.namprd04.prod.outlook.com (2603:10b6:104:4::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.32 via Frontend Transport; Sun, 2 Feb 2020 16:50:50 +0000
X-Originating-IP: [2620:10d:c090:180::7efc]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd114fa7-0e1f-4e35-9460-08d7a8000fac
X-MS-TrafficTypeDiagnostic: DM6PR15MB2732:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB2732ECAE3F3783FF652C0388D3010@DM6PR15MB2732.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:66;
X-Forefront-PRVS: 0301360BF5
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(136003)(376002)(346002)(396003)(39860400002)(199004)(189003)(6486002)(2616005)(2906002)(31696002)(6506007)(6666004)(53546011)(16526019)(86362001)(186003)(66946007)(66556008)(66476007)(5660300002)(4744005)(36756003)(31686004)(52116002)(316002)(8676002)(8936002)(81166006)(81156014)(478600001)(4326008)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2732;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a3V0xjGo3AwH/uHg2JOoll5NMqOHsEqTYwsk01qFd7WdMthJFt0j8wKUu41ihb+dSdEfEkEpfogj/0NGJ8HNim78mL3e7ef4AzYRYUMfaHW/tBiJ5NxEJu5pKcnKvlaut+OE4nqkfiW9hNJaePWz3bSy2VpwKtWkYgC9cF8dg0/Rh/ux9tAvxWkd2HYbCTjonJ3dkdjBAcN2SCi60C7dbzc9qFy/SIJL3azpi9c45sO6S6HZt20FCOQjV0hJETwmihLyiyCF+GFbAFc3bfv7KBCeqE6iGc1X4C6ywlRZMx8FQrJUL+dzEhbKIfXU4Jp41W2pzS2fK/BmeH4H0HXcF4QTZxCxjrYtwpFZhB3eIS0sggUFTgeTrIADdDNhbx/hXjshmDrFq8b8ipmPjuB9COQv+Erk504/jpQZ2FRFCU4rXG8uxARM276F0bEqsZAG
X-MS-Exchange-AntiSpam-MessageData: +Wqs3nB+xdcwioyX9H1qfkfbxIlWYreFjIz5/J4BEngWcF5TXMGBh6/DLE/03LQCpMi2XUYF4/N1NI0rEXnmsHosWH9Zr4s9GB2xAeXRLd4Q0CqHrz3//UZ/FpyPiA06HYTittk/OZGQI7V9fWtJlMgGvOgecMBZeQVIcy2Ovgc=
X-MS-Exchange-CrossTenant-Network-Message-Id: bd114fa7-0e1f-4e35-9460-08d7a8000fac
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2020 16:50:51.4638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UyiIomru4ni481ubsUc8rDAuIxjsLk5Td5Pkj4zLbOTlWnduJXeGPeEt1fHwCMlo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2732
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-02_04:2020-01-31,2020-02-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 phishscore=0 mlxlogscore=831 bulkscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 spamscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002020136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/1/20 10:51 PM, Andrii Nakryiko wrote:
> Fix missing braces compilation warning in trampoline_count test:
> 
>    .../prog_tests/trampoline_count.c: In function ‘test_trampoline_count’:
>    .../prog_tests/trampoline_count.c:49:9: warning: missing braces around initializer [-Wmissing-braces]
>    struct inst inst[MAX_TRAMP_PROGS] = { 0 };
>           ^
>    .../prog_tests/trampoline_count.c:49:9: warning: (near initialization for ‘inst[0]’) [-Wmissing-braces]
> 
> Fixes: d633d57902a5 ("selftest/bpf: Add test for allowed trampolines count")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
