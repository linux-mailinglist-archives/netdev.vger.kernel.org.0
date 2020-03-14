Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68419185359
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 01:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbgCNAed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 20:34:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30866 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726757AbgCNAed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 20:34:33 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02E0TmtG029211;
        Fri, 13 Mar 2020 17:34:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=fqsP5QREo5tDD+5esS4zCWVFn8pU+x8zxQaJ7U0riNA=;
 b=K3+JBMPA/sRhkPhbw3ax/cBwLyqzHq+gntBvT6vDAltbulxkEcQ6yhMh0O1zb52DAUlF
 M2w1uHOySVSJZnCWMhW9OrBTAJX+dQYRi8mk44DDYxYU7+sZUGsmOidwo1Vbnnsx25Nm
 URU1wKsAKhIyxUMGG7ViRxETe789znvJKrY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt79q4nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Mar 2020 17:34:21 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 17:34:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1E5WiEQOCFZDk8l05I7KXDL6ThxI8Ufk/Kentv1LmDjTdAM7dIXi83K9Yu29vYHAVs46o4RhkKlfWCDur/leRBZsA5zZdSJ1/Pvel3sX2P3uK99mwn5VjBL39+Yta0JoWKSiHHSkHzSkNShlSKoOsbjiWmcWbdP0n50bobiTAq5ftIVvAXir/6y9RcNMGUj5qOPBQj1WnRygBLm57pXKELSWTsIKVD5/BT1tN9fhmR0Z7ftwV5IOnJEovVbd5ulVCpbj7vvT/ZVn4FH4jN7Uhcb9+9NajYzqPXNDS+HWlPZp8uAGXQMvGAIods9ABQkZAhv6e7Fkr9REoKlApljHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqsP5QREo5tDD+5esS4zCWVFn8pU+x8zxQaJ7U0riNA=;
 b=S4M8ExLI9M3dkXlmuWFiw18aFYXtKnvOBN8Jq6TBjgF2v+kAJmoEgCmf3PiWJdvGr2p5ZhxIfoQPGKpjvr0KekVxbrorAw0NLy881ScA1BvGoIoibZcF8vfxpvZYrFeNOKFz1O8C1zXz+NsQruH0SPls6tY7hHpIfRcPW9i3PvshA+Xkey/fLkA4UM2DczQNWv+rNnqwoZmKd8rupUAoWPm895k8v8MoiWkMdFC382s3RVkk9KSNqaYzUHY1eOu5e12c/q06IF9XxliI/3qS44gD+boL10lP344tGs2Bmx+fCwkXsTbH8rV17yusV5wyIzuj9eBZzKoqRWec8nelfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqsP5QREo5tDD+5esS4zCWVFn8pU+x8zxQaJ7U0riNA=;
 b=UJIeAX+CvTzTPdXnZQKKGAG4xJChvyEX2PIW69PjaccDQJCPLRtUPNoe3KgJZ2opMAdHyyss5KzJ1oNMocq4/scrF3TnClkDMexWO3p9GYFpQc4lKnj9oaWY4fkalSJGj+O8nHelqkMJoicS47JtyUL79KrbW8eieb1O/NahElU=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB3431.namprd15.prod.outlook.com (2603:10b6:a03:108::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Sat, 14 Mar
 2020 00:34:17 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 00:34:17 +0000
Date:   Fri, 13 Mar 2020 17:34:14 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next] selftests/bpf: fix nanosleep for real this
 time
Message-ID: <20200314003414.srdn7idaht7zlecb@kafai-mbp>
References: <20200314002743.3782677-1-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314002743.3782677-1-andriin@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR21CA0045.namprd21.prod.outlook.com
 (2603:10b6:300:129::31) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:ad28) by MWHPR21CA0045.namprd21.prod.outlook.com (2603:10b6:300:129::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.6 via Frontend Transport; Sat, 14 Mar 2020 00:34:16 +0000
X-Originating-IP: [2620:10d:c090:400::5:ad28]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98ec1126-9f4c-4297-fbef-08d7c7af6dcd
X-MS-TrafficTypeDiagnostic: BYAPR15MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3431D7BBE58A7A669425F89CD5FB0@BYAPR15MB3431.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(396003)(366004)(376002)(136003)(39860400002)(199004)(66556008)(6636002)(81156014)(478600001)(316002)(8676002)(66946007)(81166006)(33716001)(16526019)(8936002)(86362001)(66476007)(4326008)(6862004)(5660300002)(55016002)(6496006)(186003)(4744005)(2906002)(9686003)(52116002)(1076003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3431;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NJXYq9iyW9ARs2OTfKkDgohQ2y1zojSIrP799Za0Dr0xOMCYnVnOj0qCB4ZfVrnIjMANtkx5GAJQanJMST0Q8/ZLuuScEPXw8TgfG6IfwanHf2SzE4mM3IkrxQOtnpBGmgq3XZtLxnp/GmpB/gNaTu/UT8eXtZZTh3nwZdQgBhPCKOaLyl7Jz7hFvu3/qlCNIwQXtwFcPvhGa0luyLitdiys0vwdeGOtjo+C/TmzMIrqMKetAuPlm4crunApT+k3JuX6ZGToiliPk51Zl/WLnEBDdzoc+pyeUcpBqTQ1tJwJY37b+DVUY73fKITet7hzkQsRN6B4XFPitng5acHow9/yJsukRO+iFvR9Qis63dCXHeWTlnKJdvFVA/Ghfq26hO5trqpcsezDWWEgxXugSh6Jzae/ZBp9N5BK7rG9zITgIAWkJ835kCenAgEqYBU0
X-MS-Exchange-AntiSpam-MessageData: rYSDUCpL3lDjRQeOX1XmpATvksH72WhBzT3EOVFDIclrtGU3+M6kibVv1/QSrjkfJdaRSOnBtCoH7gZmseWD0VEUvIiQETjYCIs2kxumAjMez51nI0MeNmBPShbI6ZKTWTBJPku6VZQ0oF5DznNeaKsAxNqtu3r6k0+Y3qi1fJt2MbszdE8DuJvWot6mEqyF
X-MS-Exchange-CrossTenant-Network-Message-Id: 98ec1126-9f4c-4297-fbef-08d7c7af6dcd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 00:34:17.2973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7DN8SG6UPloJiPgjEq5oj4NSf9z8D8qbmIx7KLnvQF7UgDxDsdHNF1JddLILFr1E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3431
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_12:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 mlxlogscore=640 clxscore=1015 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003140000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 05:27:43PM -0700, Andrii Nakryiko wrote:
> Amazingly, some libc implementations don't call __NR_nanosleep syscall from
> their nanosleep() APIs. Hammer it down with explicit syscall() call and never
> get back to it again. Also simplify code for timespec initialization.
> 
> I verified that nanosleep is called w/ printk and in exactly same Linux image
> that is used in Travis CI. So it should both sleep and call correct syscall.
> 
> v1->v2:
>   - math is too hard, fix usec -> nsec convertion (Martin);
>   - test_vmlinux has explicit nanosleep() call, convert that one as well.
Acked-by: Martin KaFai Lau <kafai@fb.com>
