Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6395716AE56
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 19:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgBXSIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 13:08:01 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22436 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727438AbgBXSIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 13:08:00 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01OI4hxN014869;
        Mon, 24 Feb 2020 10:07:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=C/5nFL49WHRy6D6ZaiZmPy/VIGUOoloVeYR46uE4pFk=;
 b=StpnugYMmQrw3fmThtYlgnRU0I/ffmFNlh1qr2icTAUteJWhbm+rM1t9o/iG6JSyC5ee
 +WM2RACDOfjs/ubrrREpe6sixoFyO4tFjcEdtfQ/AD5i55z0uYIelvR3UUmJFM7aQcIr
 wD214r/YWMMPzoBAuddg8OhcpQBf9XWF0NU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yb2pu916r-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 24 Feb 2020 10:07:58 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 24 Feb 2020 10:07:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S7KQQ2QclJRAuK2R8Xn9Yk0VWCym/EVcEiYWMOYmXiwSWq/W4AFRLtDVem/2e51b57/t2xseNmKO+a002b4EbGvLyqEEgiXV6tRrEO3Dlxhhl/rJyeJktJBAOy5ul+iJr/I/kE48xy0RL0G0Iwt/kDCzWiAQz+m8aNBjCxoZSr2wIpkeEMfD5BBTxA33jz2ucpRTWzjlPJ/u5HJgKvPH5XHjiH0UP4WnHJnrB74MRY0YfXKVNgbtIoF1r7DZHaLZBishmzXyK97xZet+bbJGVcpn53uy7sYaAx7rgkJzVDWCDtnGzsXS1FeMZCp95h+/sIg3lL2bxdOQ1ggmHbVuJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/5nFL49WHRy6D6ZaiZmPy/VIGUOoloVeYR46uE4pFk=;
 b=NERsFv+zMVZ+gIFJDQkxPNiDBbXuhSl9raGiyUr+ZN4ghMDjzSG8LQSMKDMIbyaj/Hq1Bn1xNPHmMXDUifC6xtm4nxbKw1psKDaNi6HWmgx8572DqEVLqxjSGhOpB09LZLhinuKvruDdpT6k9CR9QgytvgIPqCg8vK55vNCVqrdNY8JVE70DKik4qd7HQ5UA8FBYh7XtwX3cm8/yrz4uwoOmDcLWAdncKkYJZhYM8hQ/JDEiHWzSBxyq/wDWgv7rxUTuwq2so3kIkmOZSzvpwtMZKRhS7EPzmhydGmTwfzl4NgExr6dFSgnrj1Mib2D2/m8e9hfkBRK1ZsHF4PCu3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/5nFL49WHRy6D6ZaiZmPy/VIGUOoloVeYR46uE4pFk=;
 b=JhkF4nkwPY7nXQd4p8jzn5Vqp8YpdHV/vMJLf31KWGndb37sij7hB3Q1mO8Lcyl1LWX+WUIpOPkji3IM+y1cMo0meCsuLrM8L9KCdb0i/o9RTMzsFFH/qpsQrelionPyDRQAe/jhM45ziHHUkXmkjIK9GRLKvlMDAU+QNBPdLKE=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB3190.namprd15.prod.outlook.com (2603:10b6:a03:111::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.22; Mon, 24 Feb
 2020 18:07:57 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2750.021; Mon, 24 Feb 2020
 18:07:57 +0000
Date:   Mon, 24 Feb 2020 10:07:54 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@cloudflare.com>, Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH bpf-next 1/2] selftests/bpf: Run reuseport tests only
 with supported socket types
Message-ID: <20200224180754.jg7xijof3n32ywjn@kafai-mbp>
References: <20200224135327.121542-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200224135327.121542-1-jakub@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: CO2PR04CA0139.namprd04.prod.outlook.com (2603:10b6:104::17)
 To BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:500::4:bf41) by CO2PR04CA0139.namprd04.prod.outlook.com (2603:10b6:104::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Mon, 24 Feb 2020 18:07:56 +0000
X-Originating-IP: [2620:10d:c090:500::4:bf41]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92252ebc-dd38-4b1a-ded7-08d7b95479ba
X-MS-TrafficTypeDiagnostic: BYAPR15MB3190:
X-Microsoft-Antispam-PRVS: <BYAPR15MB31904632B464BFFE0189DDF9D5EC0@BYAPR15MB3190.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 032334F434
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(396003)(346002)(136003)(39860400002)(366004)(189003)(199004)(81156014)(81166006)(8676002)(6496006)(316002)(5660300002)(52116002)(66476007)(1076003)(66556008)(66946007)(4744005)(8936002)(478600001)(6916009)(9686003)(55016002)(33716001)(16526019)(186003)(86362001)(4326008)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3190;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N43DVxGmUbBdCj96pZrvZHbUMZihiEMgAw98SSDaGmQm94gtRsS01WzLNhkmvodrr5l+gwwZPcvaCmQ2eUzeBZ1aJZzuS5GhXqbx5AyTA1Lx7x44l/fgpa4Q63YAX2ja9VanMPSAnARCJH/6qGbpxB/YQ0g3VR+LMV9IQUrmJxYChxZF+20K4KK7LVqwF8oL5bbCnX/NFRx2n27VsVdDSY/ZXZ/6w94NpxNHHDHKRv55x4NTIXa3wKTJGv9iZ5KAm60ujpL7yh5bzJZowVozbzf0A2iyY6FkmaTsMOUqiVKneocOA4acEojt976RoFIXL16Un8ETyO47EYBLWJF2rK8drjgUY8X99aaoh6vNcosYyyE+VAg+yY296vIlejBm7xfOopzX2/ak8ZrG719GWunnEHdDr/lUaUiUyikSE8AVUJpGD9ZA4QxAUxRLdwX3
X-MS-Exchange-AntiSpam-MessageData: XfMzSamjZSH/l+jvm9Nml2FWbw8NVQnl/1oS/24iqobSgEOUETTs32FedF9avgF8/YbKfWCaoMnwvjTKQMc6owS1baySzwgFxyIJlUUPGG+ZGCmP58jsbHivcFha4rRcR8BkbvR4+bqH7nh87XIl1Q0BryAwpMNc++TxuQoOGH9jevKYUf+jvSS01FLCnQoc
X-MS-Exchange-CrossTenant-Network-Message-Id: 92252ebc-dd38-4b1a-ded7-08d7b95479ba
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2020 18:07:56.8215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vt4/wTvVufgUiMgQc9U6aYyViFPoanARaadzF7kRcvVQM7tcrmjz/nSk8p2I+nc9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3190
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_07:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 mlxlogscore=919 spamscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 02:53:26PM +0100, Jakub Sitnicki wrote:
> SOCKMAP and SOCKHASH map types can be used with reuseport BPF programs but
> don't support yet storing UDP sockets. Instead of marking UDP tests with
> SOCK{MAP,HASH} as skipped, don't run them at all.
> 
> Skipped test might signal that the test environment is not suitable for
> running the test, while in reality the functionality is not implemented in
> the kernel yet.
> 
> Before:
> 
>   sh# ./test_progs -t select_reuseport
>   …
>   #40 select_reuseport:OK
>   Summary: 1/126 PASSED, 30 SKIPPED, 0 FAILED
> 
> After:
> 
>   sh# ./test_progs  -t select_reuseport
>   …
>   #40 select_reuseport:OK
>   Summary: 1/98 PASSED, 2 SKIPPED, 0 FAILED
Acked-by: Martin KaFai Lau <kafai@fb.com>
