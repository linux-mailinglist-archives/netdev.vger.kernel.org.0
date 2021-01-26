Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB8F304D96
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732640AbhAZXL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:11:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52562 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394176AbhAZUp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 15:45:58 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10QKZFs5017460;
        Tue, 26 Jan 2021 12:44:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=JDesiCEwfaQhi+54Ll65bufF5YR6Rs9OA+bKmHB9nzg=;
 b=nTM7OdINsM87I7i1F+AZhlZh30HziE3KUA72btaMayMlhgZ1Sio1jRd1Ryl8SBMIV41d
 II69ssQoIOvMx5TLz1IaDv+FCRw3vYeH3h5jq18swvtLANFlthPzS6eLmbYpSVqzVQ/M
 IPRqPwn0x+lo1O2kKLVNTMD4vNQzn9PqiwI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36age83t94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 26 Jan 2021 12:44:54 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 26 Jan 2021 12:44:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TlylszIjXcddfw01YAGv1RtKtiJwhlZ5j8F2kuxCSiz0XXyXOX0YfBVQjICvPM6gbvtqtMcZYB8acj8DViBtnuOK7EwXmMVxz4TtY1d9mTW9r6TAHWZ5/RHwYWVDDYax+bJMuIlFSAh+ePBY/84zIEJrnzHFDAB/HxttnZGQEnyVpgs6Pb6STx4dW3PAD2bacpG2OHNk3ewyK5ErGzJkH/9civV/iZyEvN++bt2yKaim91YH0z+ZHFduxgmsoekI22kXaYWY5HyaKNUfWmGnD5HTjKMUnNQPUgDRCkMTQBUI9wS1ZN1RtfZ2o3IesiCHgOOqEUBeBErYH7nWozWKlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDesiCEwfaQhi+54Ll65bufF5YR6Rs9OA+bKmHB9nzg=;
 b=BcVNuHYmlgQon8du6g/QqXTFI/OCSIzlDZLJdbS89nsx85p33+JqumIT4FScXkMMAAMmY7wKubnZHR1FWZOXIjtDnD79zla88W41MtXf19x65545h/J0byXAIwp68KNVNWJWhoi/LIR6CeBQpBLM4L8HTtz/qUZWFvINRVory0SihZxq082MAV2ey+gjpM9+Uh26mV6Ey0AzoVHMYQTxHHnDosbbhK6SUvbjYQfjkchaOJHAH2lnhqXZRPnQ25HiyFej1M30uWfkOWTvl/4am3cwwlIzvhqsqeDB/q0oqE0P0nu9JFAsZ9TNC0Dj5pY4vcjtgf/ziN6V71IMWQhlaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDesiCEwfaQhi+54Ll65bufF5YR6Rs9OA+bKmHB9nzg=;
 b=iIN28y9gcm72emh8IdRyjdidtuO2cBcFlf1tfK+Qw2Fnf3yAog6fAMZX+t2qpC8EjYQOGmZaDHEJ+YeGVqf/zcaHh6LKdMDCvg3WMQ1JP9Br5hB49033HmqIxnlSU1N0Rd3oElnq3XsO7gzUm2G0WXk29X7vAADDXu0IHb3tPSE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB4117.namprd15.prod.outlook.com (2603:10b6:a02:c1::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Tue, 26 Jan
 2021 20:44:53 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66%3]) with mapi id 15.20.3784.017; Tue, 26 Jan 2021
 20:44:53 +0000
Date:   Tue, 26 Jan 2021 12:44:45 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v4 1/2] bpf: allow rewriting to ports under
 ip_unprivileged_port_start
Message-ID: <20210126204445.hkoi2e7zvlgowtn3@kafai-mbp>
References: <20210126193544.1548503-1-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126193544.1548503-1-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:694d]
X-ClientProxiedBy: MWHPR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:300:117::20) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:694d) by MWHPR03CA0010.namprd03.prod.outlook.com (2603:10b6:300:117::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Tue, 26 Jan 2021 20:44:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d61ccf3-39a9-42aa-3876-08d8c23b3b90
X-MS-TrafficTypeDiagnostic: BYAPR15MB4117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB411740AA07997676A7EC1464D5BC9@BYAPR15MB4117.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u+vSazZG1DCsIaqTq3Kkl5R1UJZxwSD5j5k6WaEznnq5X1tU8H0ije2S/HGGS+GvGW5vMD6CzP5/npLWIlMdMxoFSFbERJAPkxdaeI7D6P5q9T15WuwUTGtWnMKFX5gwYbdNKwy/xab51U+/ka81Ka7cTNYuPNobehUWumGIF0OvqBIop1YV55si5Fqk7I+0Afsdj64oFR6B5PvcidM1K6cpQXOg6YOIVQsigLQ2ABCFOuVlnp19bg0LCofoP22mLtCQ1uFg3Ha7Dwvh4//macG00nyTq2lQUwDIiokclkfI2B3pEp3NO7N/z75al/kGtHTX63CxQuyuBzzSSNhSj7ANC3vysBWV7u0WyHl9I37PAFg7tUdrfmHcnbNXa+PsSU+cfoCwiR0XKSlC7QNTsFKgeH5TZSLQcNgsXwpBBAqP5lB8JFH4I10yKCkrPYkPQqKKRGeZF/VT0eesFPekEAO85ltUsGOqUt1queSiYJ7d5TMAohIc2JAUew5kJBt2mHTxV1oPDTqwphWS1uOlTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(366004)(346002)(396003)(1076003)(4744005)(66476007)(5660300002)(66556008)(52116002)(6496006)(66946007)(33716001)(86362001)(6666004)(8936002)(316002)(8676002)(2906002)(16526019)(6916009)(186003)(83380400001)(9686003)(55016002)(4326008)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?53H2bG+LgzM+5UPq5I6BfdgT9ZnUDqFX+XQZ7p2uDlA082et0kdntEK8C8/v?=
 =?us-ascii?Q?obH6HIzkEsq5aFDfllKt/xAnzANhDd+f9h66Mz3DfkssWFywpAYnQdGAT27U?=
 =?us-ascii?Q?IFYkJjLOrAFKtsXCnqH2N9jFJRBSP0fYfDCE5m7LXUHsZ3x3G9zzaD5MlvgS?=
 =?us-ascii?Q?jzwGSo7mJt9Bu1W9IRQkL3OvHOe6ayBtZawaP0FfEL8pAIUKh0WwUDkvmujO?=
 =?us-ascii?Q?Zj9rKIfDDEGeE4msc7GZlrwYZ6tKow9PpBgvxAtfOTkRCzuILC9pNexcW5pq?=
 =?us-ascii?Q?5fcC+nhn+TNehZc3jfGDdB8/ABfEvrzxezcBlCZg5f/cERV6WvsCwmM0q7a6?=
 =?us-ascii?Q?x5OIN5tswkFAGXEMG4eiBjmG4X50/NOnkx/UnwAALKUllilNn4jBGN/usCud?=
 =?us-ascii?Q?R2Xh25iPxEueYgaz1lxXF/VLAoI3gu5k8A3e6UUgM7q8Foro551t9bDMnrcB?=
 =?us-ascii?Q?G20wHbftjtosiWHnYSVlynDnhboyyNJezQI6J0xHBfZfz+Kvyb29OiX32wU4?=
 =?us-ascii?Q?qHes8dFrGvCi5magR6YMXX8Q270yMarGB7BINyM50h/8+e10X9ZWcliETWrc?=
 =?us-ascii?Q?RE2J8SeW68o1jDgQQgbsoDXwTafY4m5GmXWvUGaqgzPCh94CMlKkpbNAH2ih?=
 =?us-ascii?Q?rIDHgc1LghoqUAcwtSXC32axComJAfd2bW0esxL9AfzlzDJn4m7UQ/vJZoMQ?=
 =?us-ascii?Q?btWOFnj6Dd5+vwa6sjClMzRpdlpR1Rs8Y2XMYo6uRD2AspQtumLU8anxyrMZ?=
 =?us-ascii?Q?aStS9W6cXhiwlmw5uJkwD+I0WeJi+F7oG/DiYIr0TTvnt6LRRS28gRkjaNn+?=
 =?us-ascii?Q?UUZ+ODkHWkFCLQXjRZjRGZ4DlUU0BlMBL/R/ghZVoNF9H/R0pC4IFP6mG77D?=
 =?us-ascii?Q?9/Zc1K/zefqIuor85tEKQXMkcl+Brh2i6wD5tvVjxrLlZl1x3xbq8wxlSl5B?=
 =?us-ascii?Q?d275STucXXemeHEYy9EsxjBSFSxs+NWRQk3tlmmLlyve8EZBwbTV8+MIASYQ?=
 =?us-ascii?Q?WtTGyUJpd2dYhCJv/5LA4r3wVGDIcEhofYEQ5c7O3xReUAuR02nmtdE8TdkE?=
 =?us-ascii?Q?NtiLK0kg0aXY7wecwpCYXHhZekz/wiVjugVMd8+FIawylOB1re0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d61ccf3-39a9-42aa-3876-08d8c23b3b90
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 20:44:53.4139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jkcgHdIPcGwobYg6JwGRJ1pcZkkSbISV+5ynPm4kyg+G8Cg0oNDNIFDD8H5zXkK2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4117
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-26_11:2021-01-26,2021-01-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 suspectscore=0 priorityscore=1501 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101260106
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 11:35:43AM -0800, Stanislav Fomichev wrote:
> At the moment, BPF_CGROUP_INET{4,6}_BIND hooks can rewrite user_port
> to the privileged ones (< ip_unprivileged_port_start), but it will
> be rejected later on in the __inet_bind or __inet6_bind.
> 
> Let's add another return value to indicate that CAP_NET_BIND_SERVICE
> check should be ignored. Use the same idea as we currently use
> in cgroup/egress where bit #1 indicates CN. Instead, for
> cgroup/bind{4,6}, bit #1 indicates that CAP_NET_BIND_SERVICE should
> be bypassed.
> 
> v4:
> - Add missing IPv6 support (Martin KaFai Lau)
> 
> v3:
> - Update description (Martin KaFai Lau)
> - Fix capability restore in selftest (Martin KaFai Lau)
> 
> v2:
> - Switch to explicit return code (Martin KaFai Lau)
Reviewed-by: Martin KaFai Lau <kafai@fb.com>
