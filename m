Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4872ADD0B
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 18:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730995AbgKJRgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 12:36:25 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19854 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730669AbgKJRgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 12:36:25 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AAHQw1I004564;
        Tue, 10 Nov 2020 09:36:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Ux7Kg6Hbyp6FL6+amQ7aVUuqzq1Qc9aXeaU/JXruyps=;
 b=iiKfwY/tFr4FMqNIMi5dGXnhS6Q7qh4ZWi/qrCVSTfyGV/wVhbHM8rodXtJBuGOEMUvJ
 H1tStDEIiY+cM4XMwfkI9oN+XXs8GMkgnMGs3aidAp6UWU16M/vkEAAHmUuxppEXf+Og
 A5fRghcKwHHSB+Srm6JbKJNuMpm1RojmldY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34pch9uv6h-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Nov 2020 09:36:11 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 10 Nov 2020 09:35:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDzAh30wxMNqtTetUsGDIVmlv2eArcMUOYnTd9kyN8xVtjI0C51K60q0O84TIJuSkihVvBhfs0dEwmF9YiErqSIg5p/MUB1npQjVN49iIq8Udpm5FZSvLsMfjgSmT+t6nJIG/ejNJMKlUlApQT5k6GSm1M+DdyKCa+4GBibeDMcGLp0UomBBKQ6zxvfOIK/ATpTnr6mIRPGPXmlRE4vH7vU6SKf9anj2q53L38nDZxoAtCFOydgr3ItR8pZtnoC1S+pkzKLHrXvFXk/UIBmv2urzdZv+tQfYvAF4uI08ouYBjrbNjUVdtdlJbOO0YnAxFhVH5lmko7SUxLyznLON+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ux7Kg6Hbyp6FL6+amQ7aVUuqzq1Qc9aXeaU/JXruyps=;
 b=KaxNZJ9rqwF974A19emVHD6SooTpmcW1xTa+YZmqXO/QQHihpMKNCc5ZGQK7epmh2RQAZX6sJ7euBb+JF8D3YPRWPtBitrl6VTrc+nABGK9TLCZ4DEDw7mrHz8tK2LauTWd5a/19ZtiLmVbIpIYb8V0rpxbtJCfODcfHtdMBzoMwf8yKJGc0hVp/1qftXCjcTP2YnZ7FzqxJRN/9OMMp6lW9K5V3l8eiIn9yD221CpEVFfWzVndnkZKCLozCeo65fJF8IPXBso+6eQBw7AQeQ64khGhe5ZCqzCa51doe+XooikdaWNFvZJ9qrJwzjADsgIAKBCTUKckEbgG6Ggw0cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ux7Kg6Hbyp6FL6+amQ7aVUuqzq1Qc9aXeaU/JXruyps=;
 b=j5hxA9XRPxkoN578ewvpSssXs5pIeB/b+dzx7X/hFyiDPtycrfAxAV+Ygb21psqQBt5GJ2Yj2UH9EFQqVkbFFZqPAqhYcxPygW0T9ptT8+Avr/WPzA/7nzloCK27pwXJHANjzsHMl2XOkslXHPZSVQNBvIHAxUhv9+s/40YraBA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2887.namprd15.prod.outlook.com (2603:10b6:a03:f9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Tue, 10 Nov
 2020 17:35:56 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 17:35:56 +0000
Date:   Tue, 10 Nov 2020 09:35:49 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     <bpf@vger.kernel.org>, William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCHv3 bpf 0/2] Remove unused test_ipip.sh test and add missed
 ip6ip6 test
Message-ID: <20201110173549.i4osogbqr2pji3ua@kafai-mbp.dhcp.thefacebook.com>
References: <20201106090117.3755588-1-liuhangbin@gmail.com>
 <20201110015013.1570716-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110015013.1570716-1-liuhangbin@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:b389]
X-ClientProxiedBy: CO2PR04CA0199.namprd04.prod.outlook.com
 (2603:10b6:104:5::29) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:b389) by CO2PR04CA0199.namprd04.prod.outlook.com (2603:10b6:104:5::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25 via Frontend Transport; Tue, 10 Nov 2020 17:35:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2fbf783-f42d-4f04-6dbb-08d8859f1415
X-MS-TrafficTypeDiagnostic: BYAPR15MB2887:
X-Microsoft-Antispam-PRVS: <BYAPR15MB288710127ADEC5EA752C5EB2D5E90@BYAPR15MB2887.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ExybHVIUWnanQ4Z5HPkndTxyobf21N1PNMBLc3LQbB9KYR+tK2+Iozz0WAwZityam+eNhtPfM1q/787DI5E6rLN34rj39g56rG6Fb3AYCOqFQ/QMBjtavf/Rs6Vj9xwcr3Bhze7xmQ2etEEN4THvAwq2HDH6ciz2iLrFIpweCl1ruEki8GaToQ198p6G83yByBm/uDMinOnv+MPtNnUtbUhEM00fvM0dQpdwx8ruNnyUPs5Agno3hQ+25WQ92tL2NkgLg6hqiv0UMdVNDJrKxUlhRg5GdXPIrtUywuQYTmNT7OEwGf0Vhm1KcEqPe94U
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(186003)(8676002)(16526019)(86362001)(6506007)(2906002)(8936002)(66556008)(6666004)(6916009)(4326008)(478600001)(5660300002)(1076003)(66946007)(66476007)(54906003)(316002)(55016002)(7696005)(52116002)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 6OsBCPOa2hXRJpuRSQgGJHm9kWiPO1bFnL6J8Zt3kK1zKgs4Wou/1A8utSKuJG9S2Ctl0xg4yZnsa1TkOC3aUpgPZvj2IfCSkWtWrTcwNkYlxNa96ZDWin78FOQDZ5VPr8f9/tORl7n2LM7+4Si8pCS6+gwC2O/VWSkEGWm3HuugUzD9w4agAg9R1aT5Q17LfoQKjBfGYSK5RdenNnPMf81zcFvSZ/mPFxS2XP4IKm/HG9ZNqjEubY77ySCzK1eI1P47Gc8QXTG0pl9hFuK8iWrWfZGbsz7P47zHTdF7PcYs7vM10bCUhgSF/IhZyUED+v9D+aG82Y63wPR/em4+XNu8o6UJR3FfZOWwxWa28IfRVfchRS94FdNwtKoYfAu7QyA/4X5RabzB+Ulsc+tylZbSkeDst+18uVM2AUUnbO/eTbDvYtgYMe7xrLhi5kxif/CDgAYWoANBz3WTQye2+iMNajnQI+zTKMWGGZAFEqGalhecf/WbDXb6hp67tJsPbb5d7LhOVzaK3tfjzDgmVms+dTh1Kuna72XI2UOSfWvzWj6IaGX3144bTbjJyLF0O3uLJFiEe5o52AEl/M6K7BuFpAT+9192r5F8mk/f6EMx5f9OTPT4TaZrXqNSTCGkfuK8jAf33IE5e3sIg8HbpybCX5OiDpL5gTL3vV/fibT7XSfQ77X3DxQgEO9a5Pd/w74e7sN7T/U7bDhFbPO8cjKEC80PxxdTLyV5x/H45XdW+z6d9KpZFsIQXZ2jPT6htI01pxdNAuW4miaZXuqOelWAPJEeRVRtps7yNoxMv51TN8fUFWrxHVGhxNHI/ZonP6AlSaknjOfr92HQCYDd/3s1yrBLfJkNbbDYFEE8U/jhXVe92iB4ziflvfEX6MTvF470hWdHqaeUlmfv4OiMIUWLDGBR8JGxJfYAdtkYn64=
X-MS-Exchange-CrossTenant-Network-Message-Id: a2fbf783-f42d-4f04-6dbb-08d8859f1415
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2020 17:35:56.1625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rXwjk3zMTSGN/++xpCvkJNgxLIK0s+t1529zSg8w5uEAhT2/HW9YBe1D2hmQW417
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2887
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_07:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 suspectscore=2 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100123
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 09:50:11AM +0800, Hangbin Liu wrote:
> In comment 173ca26e9b51 ("samples/bpf: add comprehensive ipip, ipip6,
> ip6ip6 test") we added some bpf tunnel tests. In commit 933a741e3b82
> ("selftests/bpf: bpf tunnel test.") when we moved it to the current
> folder, we missed some points:
> 
> 1. ip6ip6 test is not added
> 2. forgot to remove test_ipip.sh in sample folder
> 3. TCP test code is not removed in test_tunnel_kern.c
> 
> In this patch set I add back ip6ip6 test and remove unused code. I'm not sure
> if this should be net or net-next, so just set to net.
> 
> Here is the test result:
> ```
> Testing IP6IP6 tunnel...
> PING ::11(::11) 56 data bytes
> 
> --- ::11 ping statistics ---
> 3 packets transmitted, 3 received, 0% packet loss, time 63ms
> rtt min/avg/max/mdev = 0.014/1028.308/2060.906/841.361 ms, pipe 2
> PING 1::11(1::11) 56 data bytes
> 
> --- 1::11 ping statistics ---
> 3 packets transmitted, 3 received, 0% packet loss, time 48ms
> rtt min/avg/max/mdev = 0.026/0.029/0.036/0.006 ms
> PING 1::22(1::22) 56 data bytes
> 
> --- 1::22 ping statistics ---
> 3 packets transmitted, 3 received, 0% packet loss, time 47ms
> rtt min/avg/max/mdev = 0.030/0.048/0.067/0.016 ms
> PASS: ip6ip6tnl
> ```
> 
> v3:
> Add back ICMP check as Martin suggested.
> 
> v2: Keep ip6ip6 section in test_tunnel_kern.c.
This should be for bpf-next.

Acked-by: Martin KaFai Lau <kafai@fb.com>
