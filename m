Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4242A5AFB
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 01:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbgKDAWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 19:22:00 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35530 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729869AbgKDAUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 19:20:44 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A408N43014338;
        Tue, 3 Nov 2020 16:20:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=18s34da/ueGMFmi6/dpc+F3M40J9kevbe0COjHYj5HA=;
 b=FcsMlyAvYQq9t122xDzt/g2Y6E2PIGnOs+p5iTV4UrjfeeSKauFjBpePCsopBplyQVmu
 tvPhMLXo6mlE07UBumNWLrnvoqxaGXB1ZIHwvO4NsecSPVnJBYtAFto7LlC/FBthVovH
 lSwvugmxm12UH6bTHTkeZ4oEbIvFQZMavZw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34hr6p6wq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 03 Nov 2020 16:20:28 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 3 Nov 2020 16:20:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cfalobBvaUsmEQcOksUpehfsWwZ0d5TMM4GURSAzflEj9Lmq6poMFspiG2wc+DfVWaDOihBSezYEsrqJU7T584VmYyJz6by3UKLldkx0EmkyqcyE9QsSDk3BjMK/0yhYG1Tn9QgaUtTrTf0HBuNJ7hXGMgURzX1YwVF5L7ZtoYfFFuIhVg+CoX/RPuYTvz05A1oRgrs73HjCPgUVrAO0m83HXe5/AMFv76klqYReVNsLxTbnK43jxDeV0ghGE7o4/XNm8AkIshBenQCL+3YLnJMI5cfTswwVsgXtLZECbL1LxwfaRwycFtCMs0xhkgVwtQA8L8MDYcEn0eDZA+vPig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18s34da/ueGMFmi6/dpc+F3M40J9kevbe0COjHYj5HA=;
 b=jIO2kvRV8UmqFnLEGG0Pzf9qdoCPmO/zZ2CHNnvjr7S9QLcRpU06yzsEsKiRUVq2R5n4x3VTIxSs3PgpFjUAJwC0LecmYhufWUE5FBaROh3eXg9r3dwlONZPsAVNQ2EbboCvdLU356zvCDFoyczpbl5VBwQZotpSkVEOQpUkKLpbJgkQoiS+3VtzzVwqfrfzwwsi1FrhcZ4vjObcaci9Jx4oKzSztriPQme80y6iUEfEfTEN4H/m2tjguSeiJgzuai7WuJB1ZNLWfMVO9d+tQxv1fdm+s9bYhOg6jQrj/ZC599hpmmQZAncFlgMxKF3lJ/oZidlCa/mzNqmW8eEArA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18s34da/ueGMFmi6/dpc+F3M40J9kevbe0COjHYj5HA=;
 b=QwpdgYbcpQ11M/m0XH0tijNXY/6uhHtj4jDF2LImMIn3KA3offWKoRkaMpnaBWUW5y78x2lvZb/OyjMg2da4Tl94FUoLeql5pLmAIh/jA3kzA1UWK0nGzVrVfu4+UYDWOmPrGQAc6JJDkGzm7G1yXA+T8GlAoXSvTuXN1LbPF/Y=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3464.namprd15.prod.outlook.com (2603:10b6:a03:10a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Wed, 4 Nov
 2020 00:20:22 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 00:20:22 +0000
Date:   Tue, 3 Nov 2020 16:20:14 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, <edumazet@google.com>, <brakmo@fb.com>,
        <andrii.nakryiko@gmail.com>, <alexanderduyck@fb.com>
Subject: Re: [bpf-next PATCH v3 0/5] selftests/bpf: Migrate test_tcpbpf_user
 to be a part of test_progs framework
Message-ID: <20201104002014.tohvmzsxr2hhxjkt@kafai-mbp.dhcp.thefacebook.com>
References: <160443914296.1086697.4231574770375103169.stgit@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160443914296.1086697.4231574770375103169.stgit@localhost.localdomain>
X-Originating-IP: [2620:10d:c090:400::5:1da0]
X-ClientProxiedBy: CO2PR18CA0053.namprd18.prod.outlook.com
 (2603:10b6:104:2::21) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1da0) by CO2PR18CA0053.namprd18.prod.outlook.com (2603:10b6:104:2::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Wed, 4 Nov 2020 00:20:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e63d13f4-bd2a-44bb-8e68-08d880576adf
X-MS-TrafficTypeDiagnostic: BYAPR15MB3464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB34645A25C4EC86B5A6529ED9D5EF0@BYAPR15MB3464.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zBFs8wWiJODu/x+249UssHO5dFUQ+ET+txMAL7O96wagWwtII00TeIPFFpdx7H9YmaMSscbIvCDp3MbxvUs31u9JKBCEknpE6No6O0AGU9jV0QloUgD6XahEKcOPT4/47hXOSyfnvVZ2bKVILYkOYUViH88X5gF4Lq9LSdyMqlGO6ngY9Zxbqo27C0lPmxOeAt8JL59tbEWHeGQUN/yxKV58Z+VchB1/Ji3olx66l0n9fhlVJEXQAFeG5GbSW8a/sL3qp3QLPHDN2f1eVNvbavEIwNd/kmImdI06oMqDTMz3I5fKSRfnsYQjRH6WydHBLUXLHSNchuEbs2+4OZ2VMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(396003)(376002)(346002)(316002)(8936002)(5660300002)(6666004)(16526019)(478600001)(55016002)(1076003)(9686003)(186003)(6916009)(2906002)(83380400001)(66556008)(66946007)(66476007)(86362001)(7696005)(8676002)(6506007)(52116002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: V2wmmQKPfZo5Fuwdn/RGmptP3xu4D36Gz5wCbKcLpS6F27DwlaIPr88A0ODomagy1j62vmDRptou1vbsyrjHDz7w8X5NasQBlAXbV7p2VPLdReWI//nvL9mOuAvfAFzNbAVoJhcQy7DeuE7mWCbrnh9MokqXHSb7zuVgR5SXVxeSUtX0YYT5Y2KhB3FvkqHOyOC5XkKYqKVLKQCaQ9RShnslFq7TTITHLwCp+Aq/7zMFE3LPYN2SuFaTJ/FXGgM4l+wFIZjgho3HzvOarkReCGl7oxCzsKr5U8yMS46bW+pO2XWZRoav/ZOLUTYcI5YBnBd/VPQxp4w0k609paVwL1c/dLIcV2AsF3JAoE/r9Prc9DpU/M+gaxubHCJCn+nYjSKSBfGdogH93AOkBJ02vQY1fNSJNAwjIQrpbzg6zPsFVdRJLIlhPEHhUhpNSvsI/NrjlOdP8hLEnQvRmNOP5XUIEnUU4/9/74cl+usNOLjhlKFkc1fFN71Lg2jaWb+vlxiaAdH4lv87hAYW1DnvxiQS0jBseMwri+uqvd1O5BbmMu1xcbKRAoqJkPzULhI0WanRe9x78J8agV9eHvxHvm23fXzdkhmqfpO0qCZvmNOCeYl2vW1qV6d2CHxycum5iQp5MwzOJojF8m2upvCe+1tZiU+Y6uE0z/Ev9efLGTc=
X-MS-Exchange-CrossTenant-Network-Message-Id: e63d13f4-bd2a-44bb-8e68-08d880576adf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2020 00:20:22.1008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KUUrJKDhKdnTRLYr/06VvBszp+wGV0uB1e+a5hMNxN8zGR9HxHTRCTjPqdgBwKj1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3464
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_17:2020-11-03,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=1 mlxlogscore=928 spamscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011040000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 01:34:40PM -0800, Alexander Duyck wrote:
> Move the test functionality from test_tcpbpf_user into the test_progs 
> framework so that it will be run any time the test_progs framework is run.
> This will help to prevent future test escapes as the individual tests, such
> as test_tcpbpf_user, are less likely to be run by developers and CI
> tests.
> 
> As a part of moving it over the series goes through and updates the code to 
> make use of the existing APIs included in the test_progs framework. This is
> meant to simplify and streamline the test code and avoid duplication of
> effort. 
> 
> v2: Dropped test_tcpbpf_user from .gitignore
>     Replaced CHECK_FAIL calls with CHECK calls
>     Minimized changes in patch 1 when moving the file
>     Updated stg mail command line to display renames in submission
>     Added shutdown logic to end of run_test function to guarantee close
>     Added patch that replaces the two maps with use of global variables
> v3: Left err at -1 while we are performing send/recv calls w/ data
>     Drop extra labels from test_tcpbpf_user in favor of keeping err label
>     Dropped redundant zero init for tcpbpf_globals result and key
>     Dropped replacing of "printf(" with "fprintf(stderr, "
>     Fixed error in use of ASSERT_OK_PTR which was skipping of run_test
>     Replaced "{ 0 }" with "{}" in init of global in test_tcpbpf_kern.c
>     Added "Acked-by" from Martin KaiFai Lau and Andrii Nakryiko
Acked-by: Martin KaFai Lau <kafai@fb.com>
