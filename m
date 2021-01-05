Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A652E2EB3B5
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731028AbhAETw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:52:26 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2716 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727923AbhAETwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 14:52:25 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 105JiqMH031307;
        Tue, 5 Jan 2021 11:51:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=z51xaWa67o+04YiVXH7Hd7iRkePzGilKXzEdFDkjZr8=;
 b=b+mUAIgiuTHD6uLPxYWCU+LECUsbv4D70k3iZnuusDIQxKQoDmPGI9bh4/8IjU1P4zyH
 PyStgjWLrZoxfqU0XQhwTdSxwXeZ/lP8thyqqt5arU+nWGNCtYxL7DpAdyKVQSN2K/vu
 tG/LPRVaWMobcutON13xoeAQwc6MHsc6I2w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35u9cpb3ny-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 Jan 2021 11:51:23 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 5 Jan 2021 11:51:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNdBhxWpgj+vbeHbjTuhBf2E5+RULAMhhE2usBVN8c8axvMATGaMMnZ728/5T0l0UO/1FJMlgMBSOXH8ID8E1yA5XU0gOqRAb8jvVnT9UsEHlXgCTQ7+f/V1CEK9kPx0wxu4Bvqj7LGrVNiyCakHpNvXgt02/qRBh7d49Ox3ABGE/8ICPFvW3ZtHYjIs+yuiFb0hU9w9Oy607SftTK4Kop1WZn6w0h9sAGfoVtAFjHI99nRYKfZsbgloRkr0SzsV4/MxVCfXE2tAuah2Pu+I5/ZyrnsbBeB3pEy/VA8cGJyTz5KLGm4pPDBF01aSyyMszwBTF7dvCSaIjf/9FGTX/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z51xaWa67o+04YiVXH7Hd7iRkePzGilKXzEdFDkjZr8=;
 b=OD4GYExpPCkejf2mYe9fVjZks/JA9OOQLh+B2NXJxL363w7dnyhrY+TJtXcTE2wa4QuDU1lHJsiXLVK3oMznNgoGnsgnVK3VQ01S0IId1JZGfUOzMXfXm4BWXKWjOQN4vY1vnwvtNpSn3Bl8JJ3D6gEVh0YR+Zq7dJVk8XCk3fvW+SxegnVPb7F8P4a8AF8PON1bSXWyYGwmawTnX+4AFcr2a8FDYJ+Ffbf0Iab6W7ssMwXPUsEiE1MnXFkFCX/xMpS2bRX3pjyWP7Bxb3iJlbo4I7IKXLNiXCBBDi4ky5p2xCD+W5XhBKwbthfCP45+dChkH7FLSkTa3/Dj5f9usQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z51xaWa67o+04YiVXH7Hd7iRkePzGilKXzEdFDkjZr8=;
 b=UWzDo5tZCpq4ADVDcrrl5pbEiSzfko05MCk/GM0NwqoJCZFNT06R2XOibRel7/y1MmRZ66ZdI99j/MY5hgELmWtB1wSx5SUIOxmRxDElD/eeaWQn6TG68GhIYYMIojtQFFctYFISm1rVUjhYUnTOOHy/5cPQxciLVwODZNzKLv4=
Authentication-Results: mess.org; dkim=none (message not signed)
 header.d=none;mess.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2373.namprd15.prod.outlook.com (2603:10b6:a02:92::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.22; Tue, 5 Jan
 2021 19:51:21 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7%7]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 19:51:20 +0000
Date:   Tue, 5 Jan 2021 11:51:13 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Sean Young <sean@mess.org>
CC:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        <linux-doc@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH v3 0/4] btf: support ints larger than 128 bits
Message-ID: <20210105195113.lr3mc5ma2rvej4r6@kafai-mbp>
References: <cover.1609855479.git.sean@mess.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1609855479.git.sean@mess.org>
X-Originating-IP: [2620:10d:c090:400::5:66db]
X-ClientProxiedBy: MWHPR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:300:117::31) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:66db) by MWHPR03CA0021.namprd03.prod.outlook.com (2603:10b6:300:117::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20 via Frontend Transport; Tue, 5 Jan 2021 19:51:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8c5befb-b06b-4f15-62ba-08d8b1b34646
X-MS-TrafficTypeDiagnostic: BYAPR15MB2373:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2373952EBF06EA6B29D173A5D5D10@BYAPR15MB2373.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kNTO2rizg3HHeKXulrHl+5ZfzNXVmkjDpv3ufTyBV0+4d6SQBSD+3ZnszPs5dV8xdIEydJztTI1QY+OrdJONq1f5FMg2mZq1IX7x9t2lptz7gPXXTXve2Eypdxdt+Tgx1kKRbZkXexlECc8BqbOpvdT0CBdkYNNZOD7torvLud9hQGm5wpvsJE8UmAyB93+UnTnW4qlq6pn0+hjdTAi2ogGHwKw6xN9ewdoXiwYlCkm402KfdgXYxzDjdddLisB2JOyhXcNFI3IBGNjBhdtJWY/F9DEu0/rRQjBmJuYhpucIXydQ5F7GEg0prrIvx15iVCoA96fN7QXhAhRBSKgwBlHNJ0MKn4EvH/w06If5TgVZgQ0Du4B563Jvw4wqd9izegXY541dCCsg43thpBgceg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(136003)(346002)(366004)(83380400001)(8676002)(55016002)(5660300002)(6916009)(4326008)(478600001)(7416002)(86362001)(4744005)(8936002)(316002)(6666004)(1076003)(54906003)(66556008)(6496006)(9686003)(52116002)(186003)(16526019)(2906002)(33716001)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nyfcAHzN4apikCppiyPSgKRUqFEbIy14uErZwH4fdnq6nugDZJ/X1S/FQ4Io?=
 =?us-ascii?Q?a+CSrzd2V1InLgZ7f2cgOsTtPcQGU3FHrHO7ZWYxVaCQnDlJxV/w9jUPoZ9z?=
 =?us-ascii?Q?eq7P2ikOj9M/oBzscmPC9qkpnVkQg/Uq+CWcsQlSc0/l91tEbaB0aZbqxXKe?=
 =?us-ascii?Q?hQdR1zyHshslO/havXEwtD0LDc+9CoxzP1HijbQOBXS0goeVZY+ylR7ukNh0?=
 =?us-ascii?Q?t6RRZF/eOkidQ0A9uzUYix6aUv9N86oxODLaogXm4R9nKPHJaFXS8Y0vV8JS?=
 =?us-ascii?Q?v68h24AHoexS6amMWt+IQBxgKmNoRUYYTqIkDtcGrP2sqRM0sA3rvPVI0shz?=
 =?us-ascii?Q?YgCCkK2hiuGvDjm/qAgt3g+W0Jez9pjF8ZDqnLegtmEEtfEoYg76qyT0FkjS?=
 =?us-ascii?Q?Xqe1CvIbujcYcuT6855Q932vk967grXrBd0KqGsZFTOjqcI6XmjnMO8GA8CT?=
 =?us-ascii?Q?NU0AchA2gmSyg/lfJ5XdO40RI4/RTjp/SAneukRgxocaeignD49Sy4XefCje?=
 =?us-ascii?Q?YcH59kpJMJ+Cmd1jqmvoeyn+Lbbwevq4RaGK527jsHI3bxQASl7vQLoTRMdE?=
 =?us-ascii?Q?yoH5+QhMA84xhgvtE+a/8IfDwFuSSp2lVwougWr+95A0joXCkbH0MLj6ogHN?=
 =?us-ascii?Q?BQ9gO7eRdgGPBIETYqmNVcXFY1abKxvzro1b1JegvVsKjJ6g3k5/AfJ+JE8I?=
 =?us-ascii?Q?9Jc5cNXD6YbqopcI7OEkVc/0/KZVmqfhnRjNGIzs32yTmPD3/dHUclb5cTbj?=
 =?us-ascii?Q?oDyICTPgolFMhZqCP+lpCQC/A0/DBXqleSH9rKphnSHzGiF4pimstTIZbyXj?=
 =?us-ascii?Q?rTVbWNQFZ7ZU14k5DdndU0nxUc8S0jZGWPm/NJkDTgDUnnrhuwIE6RJo4Prr?=
 =?us-ascii?Q?YIpPNLlJ07Yjg01BKFpdY9+UKJ7YC/0qi6CXwQG95QAwKsjfgNB1jOVRYTkd?=
 =?us-ascii?Q?Gu+mY0XEX4SixB9prXpsCb8yEPHl05oTqGs0/fv7cCcBsf6DDqwDGy2OJ7MW?=
 =?us-ascii?Q?p5QADfODudIv0ug8GBUhjQlpxw=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2021 19:51:20.8375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: d8c5befb-b06b-4f15-62ba-08d8b1b34646
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2xeWM0Rk8fMcSnBeuIrh5XhFva4dGOMcSHgVk7fmpYBQ20XZAExRJlpRp0sjfeqx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2373
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_06:2021-01-05,2021-01-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 mlxlogscore=832 mlxscore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1011 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 02:45:30PM +0000, Sean Young wrote:
> clang supports arbitrary length ints using the _ExtInt extension. This
> can be useful to hold very large values, e.g. 256 bit or 512 bit types.
> 
> Larger types (e.g. 1024 bits) are possible but I am unaware of a use
> case for these.
> 
> This requires the _ExtInt extension enabled in clang, which is under
> review.
1. Please explain the use case.
2. All patches have the same commit message which is not useful.
   Please spend some time in the commit message to explain what each
   individual patch does.
3. The test_extint.py is mostly a copy-and-paste from the existing
   test_offload.py?  Does it need most of the test_offload.py
   to test the BTF 256/512 bit int?  Please create a minimal
   test and use the test_progs.c infra-structure.
