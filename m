Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85F5A1568D0
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 05:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbgBIENN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Feb 2020 23:13:13 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55322 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727550AbgBIENM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Feb 2020 23:13:12 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01949FJ3002625;
        Sat, 8 Feb 2020 20:12:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=4THmbJc2Rb6HjUeqonMzFOF+KVnxn4/f6YfXcRY3A3o=;
 b=Hup0ZtMi8XmeToAisk/d7eQhR3bVUPLNlVhtaCWvgD0AtIYnC4vKEtNHu0lFrdkMTYBX
 AT8BtPxt/h2wV16WBnAnqUMfo2WZTE1845zqCKuUMuKQM4HlYtgb89NskTuTKHOrz8ww
 YMUDb8uJdLJ/W+cux25+KsMRWmcu2spNRmI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2y25pmgms8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 08 Feb 2020 20:12:57 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sat, 8 Feb 2020 20:12:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=km7Jcz0wkCOhi2LDHzuZEh5KfErAPFgY6BJiOB6ptAjwP5ddwNhipqaQzYQr7CJrgQ4m1jstPU81aAIU8PsinllDnMRLKvPRdwUUtaA7PjL6it6L2MRq90pcDMBDjYfAbwF5mGOYGaWXDC9jeyD/YEgGdMMLeP1ANQmNUV114JLnX+g6SkpOnSt8XAw4tvOZURb9OPRzIUciPj2bI+U/njf6n7tB2ZhvPRdPZqzoXktJFIJY3iKjb0TspVKmZbHaWyH1wEjTpXd/ZMNp75OqFPuDWcNQhvBbkoni+EDtPzoWTXHaozMjOueokLuJd+qdSqAws1jwfBqpbhTnB+2gUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4THmbJc2Rb6HjUeqonMzFOF+KVnxn4/f6YfXcRY3A3o=;
 b=STaTMtBFML3vZZ1M6MCZpBy/489UnmS0PDUf6SYWgD/2cO0d3/pzW6DHkEye2ZK6v4eXf4ioZZo636J4JtBsco+f4nyrWIz+WlkPJS6ck4r0PZLWmdvsKHZEstIjz8JVwZb1yEUo70oxHHuhLS5e7qZ0MqCKnNBuaXQ/fULnOqtDAgWWlfXE6pExJ/dmXtqnvupoOKizJ5AD/HqKKshZzUw3ECuYmuPRtYBOVzLpp4buyt6b6lCA0Wic6Nn+o7PuPF2EzoNOCBxrJ3hlUXs5j4cMdXft4nEDeKD2mgPAw1TO+ClCmT+Jm+evi3/X0eeAQonzKxhrKnWmV3Y0PeNLsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4THmbJc2Rb6HjUeqonMzFOF+KVnxn4/f6YfXcRY3A3o=;
 b=Omt5K3sxbttOAadaWHe2npgXwGRvT8qFqsZDx7+gm436y4JsfBwQPTWodx92KrGdSulWkwdjEXvtnaCr1HG0Chw5nZetn6l8OycoYYjti/FFsiVk6eZtcpXTKkt5bjg6rbFlKkHEncvW2vSsk+qSWNybopkkIL4szDOwhW4sL2w=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB3706.namprd15.prod.outlook.com (10.141.164.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Sun, 9 Feb 2020 04:12:55 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2707.027; Sun, 9 Feb 2020
 04:12:55 +0000
Subject: Re: [PATCH bpf 3/3] selftests/bpf: Test freeing sockmap/sockhash with
 a socket in it
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
References: <20200206111652.694507-1-jakub@cloudflare.com>
 <20200206111652.694507-4-jakub@cloudflare.com>
 <CAADnVQJU4RtAAMH0pL9AQSXDgHGcXOqm15EKZw10c=r-f=bfuw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <970fe43f-f5dc-b2cc-7c5e-4889fb1b051d@fb.com>
Date:   Sat, 8 Feb 2020 20:12:50 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
In-Reply-To: <CAADnVQJU4RtAAMH0pL9AQSXDgHGcXOqm15EKZw10c=r-f=bfuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR13CA0019.namprd13.prod.outlook.com
 (2603:10b6:300:16::29) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
Received: from tinayen-mbp.dhcp.thefacebook.com (2620:10d:c090:180::2f03) by MWHPR13CA0019.namprd13.prod.outlook.com (2603:10b6:300:16::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.13 via Frontend Transport; Sun, 9 Feb 2020 04:12:53 +0000
X-Originating-IP: [2620:10d:c090:180::2f03]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a569a5d7-0875-4d5c-6a64-08d7ad1656a2
X-MS-TrafficTypeDiagnostic: DM6PR15MB3706:
X-Microsoft-Antispam-PRVS: <DM6PR15MB3706A8BD76C46592135AD5F3D31E0@DM6PR15MB3706.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-Forefront-PRVS: 0308EE423E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(346002)(376002)(136003)(396003)(189003)(199004)(36756003)(2616005)(31686004)(478600001)(6506007)(52116002)(186003)(16526019)(5660300002)(53546011)(4326008)(6486002)(66946007)(2906002)(66476007)(8676002)(8936002)(6512007)(66556008)(81156014)(316002)(86362001)(110136005)(31696002)(81166006)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3706;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PRs0xDdxt6kWzyjjP6aVz5Gtnm7ikFlHtdkwBTEzYW4Zn7VSYfSy1zav+VxDoHDBpnrvEFAN0XfVJQdyZ3L9PhOtUC325yzVwFquI1dDCoji3kwvcXkdkA3qY6dtx1lKA1IuLiKkZ1Rkvu/xoRGqhyRcAFMxN0etxoxyWv9O6VHziWbFRhVlRuqLLxwbOCMBniemh+BXsupyIObThaPnTA/OBE2mXzkJ1Kl3mBvZM2BLA3Tu8pct1vqYqQqquLKb3mOWuETdjLQ6o7hfguLsFJCkl+xtzIs3dq2AwV1nRpwbLBeYH3S1zbOgSCIbg72AO8IZ53ICIGH9viHQWktJDJ0oNSPbIZWJLvlmfgXbR0xkaNeBQ9FUtyNmHKI1Lw5kqAFF7JSSIOrtvFNY6N5agCpLVXLvQkhq2HrA331W4EA06BP47+5IUrXFGl/6VDtu
X-MS-Exchange-AntiSpam-MessageData: yQ9dA3VFPkHYx0fuCwJuOmIzzoXpzvfMMAb2qiU63QjNRwTZMQweThTX29GHDEZVH333rcsHG+ib9W3EaeMZMn9TXSKSwIe/Dj06MqUm8X7y3VjY7MkmcGIo7aV1MYH6mjJcDUjQX+n6X19dRsUGkrUH/F0Yt5cOgwR+fLOfsjM=
X-MS-Exchange-CrossTenant-Network-Message-Id: a569a5d7-0875-4d5c-6a64-08d7ad1656a2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2020 04:12:55.3783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DlVOQwm/Xz2RzEJaI1h7WMCc6y96eV++EmetvMmU66K3saWl1NB4Q6DH3yjbiEek
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3706
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-08_08:2020-02-07,2020-02-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 phishscore=0 mlxscore=0 clxscore=1011 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002090034
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/8/20 6:41 PM, Alexei Starovoitov wrote:
> On Thu, Feb 6, 2020 at 3:28 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> Commit 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear
>> down") introduced sleeping issues inside RCU critical sections and while
>> holding a spinlock on sockmap/sockhash tear-down. There has to be at least
>> one socket in the map for the problem to surface.
>>
>> This adds a test that triggers the warnings for broken locking rules. Not a
>> fix per se, but rather tooling to verify the accompanying fixes. Run on a
>> VM with 1 vCPU to reproduce the warnings.
>>
>> Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down")
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> 
> selftests/bpf no longer builds for me.
> make
>    BINARY   test_maps
>    TEST-OBJ [test_progs] sockmap_basic.test.o
> /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:
> In function ‘connected_socket_v4’:
> /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:20:11:
> error: ‘TCP_REPAIR_ON’ undeclared (first use in this function); did
> you mean ‘TCP_REPAIR’?
>     20 |  repair = TCP_REPAIR_ON;
>        |           ^~~~~~~~~~~~~
>        |           TCP_REPAIR
> /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:20:11:
> note: each undeclared identifier is reported only once for each
> function it appears in
> /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:29:11:
> error: ‘TCP_REPAIR_OFF_NO_WP’ undeclared (first use in this function);
> did you mean ‘TCP_REPAIR_OPTIONS’?
>     29 |  repair = TCP_REPAIR_OFF_NO_WP;
>        |           ^~~~~~~~~~~~~~~~~~~~
>        |           TCP_REPAIR_OPTIONS
> 
> Clearly /usr/include/linux/tcp.h is too old.
> Suggestions?

In the past, when such situation happens, people typically sync to
linux/tools/include/uapi/ directory. This probably will work in this 
case as well.
