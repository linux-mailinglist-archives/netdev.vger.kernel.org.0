Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E8C20ECF6
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 06:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbgF3Evu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 00:51:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48872 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729247AbgF3Evt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 00:51:49 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05U4nnW1017063;
        Mon, 29 Jun 2020 21:51:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=brd43d65+FxXY2GgGXvkPRlxU/cRRiBSL4F3Z2DP64Y=;
 b=kksM0DZL6zRacSwPL72QuwHr6MJD+G35GNKpY85cV3ib+2I1POTNAjhcNcJXmDGVSlGo
 W8+rEYb2VLntRTv2em7pmxE1t3Gd57YnFmLE2M+c9MFSTVpCut1HZ+q7VSEeQjL/0Kig
 VezwfrRVW6zqxeE3dyD3O081hIBI/njtPsU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31x3upjm6v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Jun 2020 21:51:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 21:51:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dk051A+wYb4f9WE1WuYy4pTcu9vZhNuXxqUi4MLSmWMBB6ZeOW21jCccAfs7zCrbnr8FcTzqqKyWr9v60lTN16M5OMeN3VFkNxo7Q8ZdjxRGY74RpMzuMzxrN3S3/MEsbyHCAL3rBI5myU6oJpKyOlG81yvGXTeI+eiJeRT9YFUqYEO0ujyIk8vEc0rZ6txuC/akSezIijdNMttT6zzPBvsyFNrmh4Zuy8FjaHLUaiUAjcKCLH/3cjMR6F/jteBtmIBgk/6x6weIz6exJFYMIh5eAng5zhTlHtv9HJaMRZ6SH0MTPc6wOHwq/7SnEwBkTD3Qb9PrDP5s96gOuPs05Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brd43d65+FxXY2GgGXvkPRlxU/cRRiBSL4F3Z2DP64Y=;
 b=jLpFRUtbjonJh5OftACIWQcnlaz/rXin+RbdKcy/ptbFE2EGYP+0ScL1jx8FCaBvgsD2s1SKQ7v2cx6pgf1pvnBq9xq0yjNECSMpVSezGpjJJcYZlVdwIOw77UWB8dsaWJg0g7s/u9MbGI6CH61pSNNp8Q5WCbmzUXbhjludGrQja4osmKe19jne2GuUCvHzecqRYrTPX3INXncPLWZ+h9xLrSOjwBA+NNZYP3LGdGOysfjKI9h+9XDBO56AlblNmorkccwBYulGq03OAsAfHhyfg7x3dETCVxb9Yf1Gs1RLoPdHtHO/yBkhFSomqKX01ZG6n15PJZ0/HQOTXeOHvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brd43d65+FxXY2GgGXvkPRlxU/cRRiBSL4F3Z2DP64Y=;
 b=E0SsPzrDcx+fUNgW+c2gLpRMY1O4MWANri4ZCFRW1oHgc2mPM4GSdCYSAW/9JNCxpW7MFtsu69DiBaU15yPvXe1PmOqD570M1MRM2sq/2T1DTsCHR13iyFKYdWuFZnT7QFaw8jXGBRFWQ6ZtX21AHnPcSL0HmarnmL9+7eA5k5Y=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4085.namprd15.prod.outlook.com (2603:10b6:a02:bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Tue, 30 Jun
 2020 04:51:32 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 04:51:32 +0000
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: allow substituting custom
 vmlinux.h for selftests build
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200630004759.521530-1-andriin@fb.com>
 <20200630004759.521530-2-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6177fc62-6c5a-0465-0f58-dd11c385b26c@fb.com>
Date:   Mon, 29 Jun 2020 21:51:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200630004759.521530-2-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0015.prod.exchangelabs.com (2603:10b6:a02:80::28)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::15c2] (2620:10d:c090:400::5:3f83) by BYAPR01CA0015.prod.exchangelabs.com (2603:10b6:a02:80::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Tue, 30 Jun 2020 04:51:32 +0000
X-Originating-IP: [2620:10d:c090:400::5:3f83]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d8df745-c07f-4354-2b1d-08d81cb14291
X-MS-TrafficTypeDiagnostic: BYAPR15MB4085:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB4085A86992253532746BD4DAD36F0@BYAPR15MB4085.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KNwXVGHHIrxsmpB2nukwTvG3B9PevcpBBfjGFeWpmUR+YOE2sEMyp95nnLRUzC632LtOSq5oE1r+Yh9ewupzBZvP9/ujPb7crcvBkhPyE3xzx3CqtVbjSF8YEHNVOqq3dPuxFYE36cgODqZEQHozLVVs0IByr4LSLj9qFiH7KDFQU3aWu5NiuNYHjqvKzuftsTTlXb6qw0XNlr454fDbOE+7/muTEtsm1nOuBnnCPQeOuNh5R78C+MlKzTzaFZU1diAzKr+gK+eKvkJynmbXG96f5I+hoaRfkXXvF9/Uq/uqYTrhlQu2140r7CKJ/iIlkcnNe8FdqkLLjwPDdjJSZLgOz1RV+V3Zh+wx9cKgpdvhVmz4kJ8VKmtDdo/gAyGQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(376002)(346002)(39860400002)(136003)(478600001)(4744005)(8676002)(8936002)(2906002)(2616005)(53546011)(186003)(31686004)(16526019)(86362001)(5660300002)(31696002)(66556008)(66476007)(316002)(6486002)(52116002)(4326008)(36756003)(66946007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: a9NLQcV8FYzLstFX2cH62LSggxb8FXNVG2R5yX4L1mJkyYNHlg59Teui7E2kx7nFGpMAEDDgPlESPNRCuhED0bbtUAlABnJGdnHyxJxbveFRQGcccTa4oCc8XhmzEqPRujs4DoyXdqApmQeY6F6MM18gwGBAnR9P036WIP+y2Yr56jb61D1aW/UVBsgZBwKN43xZrhQaou1OE8AuyqlUgGj+Mof/qXs4iHgmJO7eo5yPXZeqHeRcny5Dx5QGkhOMPXgmjUmUcVGFkhCJbJuI+Trge0+Yn/jbGKqEaCulNG6b9NhxscRbRxYSGgqDmYiujEnGGkeB2zrjdy6q3wpQmNzvrmtCUnJIuzZ8MqfhmYXrOMAuKZbzqgzkZgg5LLhgZvfd9eS4X6OViA3a3clLK4xYNEqo0EHVntxokwYIRsaOA1C3bQ5OHBNGzqK4Vf1tcmgMYzs8F6kxqn1V9FRBEvV58H9a3IqjFSExGm/wEXPxqk/v/g/u84Yih3XBeM6tZla0qNyns7yJk35qa6w+dw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d8df745-c07f-4354-2b1d-08d81cb14291
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 04:51:32.5713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 24rKRNaeg7sdywdiFx4Oxub7UyGhM34Ae5CgOHAyL32ya7Vg4tbR80ebZRp2/wPx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4085
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-29_21:2020-06-29,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=891 lowpriorityscore=0 impostorscore=0 phishscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 cotscore=-2147483648
 suspectscore=0 mlxscore=0 malwarescore=0 clxscore=1015 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300035
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/20 5:47 PM, Andrii Nakryiko wrote:
> Similarly to bpftool Makefile, allow to specify custom location of vmlinux.h
> to be used during the build. This allows simpler testing setups with
> checked-in pre-generated vmlinux.h.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
