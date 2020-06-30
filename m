Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E1320EBDC
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbgF3DMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:12:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57680 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727826AbgF3DMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:12:49 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05U33ZVr014151;
        Mon, 29 Jun 2020 20:12:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=137hJM6nbkiqpYTeYulMxfZMjIg3l3Pnu/miHR9RMeg=;
 b=SO6vRZW2oapRFQiY0ZPLMrWHcoMm8DMrJ9unZ2XcIvP8lPcRlNj7lSnfSUPOm1CQfDFe
 liq4exmUZXlxdREkBUJzXQL9TV9bcTXRtE2f7xdhRoha2NmnjF5dKeCLnnoPiGthe8io
 e+SLh00THyLQVGllRiDZqAtZW0oMCwYckKc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31x3xgtbjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Jun 2020 20:12:34 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 20:12:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J2jbTpGRX5cNnlqoWqRwJx//f2Bakx7NrA8juY+G4Whmgg2tlDEl8z7THCbf5uTMrI1zj4iscy5L5MCwTYvLqY6ZOKdGy13XsdqU6aky5AvJKWD8m/rM1kdD0C5blTQ7X+Tj30GHjOd4gGqHoC6tFhuhBOSNR0B942qLWZxmTYgntzhIMnYVymEOAPYCuREw2xPxIlAh0n29cKzRh0ccMMNojssZgfMbeH98skmDUG+/9ZGADe3eQt0mhxvjk2D9raCh8tMk+quWoiizngKANIIzWORAGayC29dQXMF3JLcC8NUyEPt7Se1nwDDPAxyfd3nK9XT/WMAUnc/JxmOU2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=137hJM6nbkiqpYTeYulMxfZMjIg3l3Pnu/miHR9RMeg=;
 b=iB5jFfoB9PPQ30YjyMGdZ8sat3jO+jciOcEXR/j/IPGcwGXVujnKQ6lNpypdYzz4gxztRM3VfGRYCJo2PKHzDb2YxH+WFtekexLxe+tYxpI9wvuX2RVQg5PwOh6CV9FUT858ZxY/Ng/kHhSTviqjGTqB53sYOjLemOsOZ3ITIZa6XGCNtCyDxFVWd7dFzG3vwYvVfQALufFWko8cY8ZZxEMKGOmcYP9hgb9o9Hafwfp+tOI+pelTaPKVvDXjM1qWG+BPz4mY2NDKa51oFtJhrCuMuucO4p67QyMzZFe/1nHDsL66rMexn9Nf6vZuoYQ51DE1NVyYYxQtd4f8enKvTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=137hJM6nbkiqpYTeYulMxfZMjIg3l3Pnu/miHR9RMeg=;
 b=AT58hFCTN67BNfkx9ARa1QqQSF+upOk2F9fDv/5EwekXmV2gHn1EHxJOki0c12EX5FOtcyhWMAlaj/VIL+W/03qj3F8jUKms+llKKX/4ZBzDRiGUI02EM68sILLslRLfzt4t1dsmeol/KGFrX7yyvPeHpHLWzvJL2AVy9tu8MuI=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2949.namprd15.prod.outlook.com (2603:10b6:a03:f8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Tue, 30 Jun
 2020 03:12:32 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 03:12:32 +0000
Subject: Re: [PATCH bpf-next 1/2] tools/bpftool: allow substituting custom
 vmlinux.h for the build
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200630004759.521530-1-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <9a407c84-bd5d-7eba-6c23-0642a8d4b2f4@fb.com>
Date:   Mon, 29 Jun 2020 20:12:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200630004759.521530-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::17) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::15c2] (2620:10d:c090:400::5:46d9) by BY5PR04CA0007.namprd04.prod.outlook.com (2603:10b6:a03:1d0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 30 Jun 2020 03:12:31 +0000
X-Originating-IP: [2620:10d:c090:400::5:46d9]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98450566-ed3b-4ce5-525c-08d81ca36df2
X-MS-TrafficTypeDiagnostic: BYAPR15MB2949:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB29495DCDEEDCC45502741BA2D36F0@BYAPR15MB2949.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7lv4IGzifZarAMp+UOIzYt94FCAJNFw7pZBZpDwnOX34S7/jEAeHeM15uCJ7lIYN90e+QVVHpxIgoBiPwglVMKdkyzaJPYxvKWpP8fIlw9p8s7oStkxk6sGREopg92LLLH9OS99VXTux7rVkdEgNjgPtUHiVxc5dHA1wyO6PSl4irCMp/wck02F8elJBcTQmcZKlbpxp54FEhHTAd2zJc99WlBgzjOogvON36c9pHo3M2G/GPAUdzrkKfbfI3Cc6nmjn5tzPXGS73qmv86FCrzteqUS3/t4duXCPKtKehlJGW1X8MAhRdCi973x59jUfZOGnXpcvB9HdRGhPs36tHMfzM1lc+56dqTP1eet6XIMn+lBov2OtJzPPd1U8oxqK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(376002)(346002)(366004)(136003)(186003)(16526019)(86362001)(8676002)(53546011)(2906002)(66556008)(66476007)(2616005)(66946007)(36756003)(52116002)(31686004)(8936002)(4744005)(478600001)(31696002)(316002)(4326008)(6486002)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: i3Uyz1XDCzJSOdtw4kJj0NsDvEufba6qFP7QRP2Jb4dbfwUVHt7tzjqrhJ88omlZaYShuRVw4SnMgM7Uy9BdwBcUkJyvC7zXGU+c4GXAI56fiYjO35DexLMOitlrEjSVJBBtki9EsbmD/8BWCLHCpibgA/ED+Sc5q5m690Ttd0wuByzFcPAZxSPDW4N+eVplTnGd768qwsFcAsvt6GrJ+M9u4/STtx7pWWPkd3LcTW3YrF6nd8aaKjJ4AYEExuTxZ/lZSzFbNkQvUTU3OU9pG64s99x/Rnndz5aNjJg5yMq+7YS3TouVy3vF57b1jVhtQXNfP+lJNg6kdptgptgN/Uvav1PZ2wqb9dI2eXI7smvy2OPA4Z7JJ64O8Blo1j1cyAZGWFbiWbS5I6B+xgAF5QyOI0v8cX+A+Dz5Lczh8L2/ckuNL72EAMNaYyC5WrLwl34RUo7IWlyNa+xOqzkXN4b25EiUjaISPbg4+OuJk+yJwwWdnsZKu4G+U68fhjFoWHnvhwADsyiKA6/1TXC5Ag==
X-MS-Exchange-CrossTenant-Network-Message-Id: 98450566-ed3b-4ce5-525c-08d81ca36df2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 03:12:32.5038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 70lmkG0/TIbAHHtFVwdFLcLWPISAWGN+gjeTdvoy9Ht2/vCDCtJdTSGQFT/XCsxM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2949
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-29_21:2020-06-29,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 mlxlogscore=867
 bulkscore=0 priorityscore=1501 mlxscore=0 impostorscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300022
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/20 5:47 PM, Andrii Nakryiko wrote:
> In some build contexts (e.g., Travis CI build for outdated kernel), vmlinux.h,
> generated from available kernel, doesn't contain all the types necessary for
> BPF program compilation. For such set up, the most maintainable way to deal
> with this problem is to keep pre-generated (almost up-to-date) vmlinux.h
> checked in and use it for compilation purposes. bpftool after that can deal
> with kernel missing some of the features in runtime with no problems.
> 
> To that effect, allow to specify path to custom vmlinux.h to bpftool's
> Makefile with VMLINUX_H variable.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
