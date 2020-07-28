Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB212310B9
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731839AbgG1RS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:18:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12270 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731684AbgG1RS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 13:18:56 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06SHABR5002577;
        Tue, 28 Jul 2020 10:18:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=jJVrF25GzqvPNmqPlof3Z4s5tQSQJw2SeXVqaKCduX8=;
 b=ifvCELfQr96UvIcl19/zTfqszQ3fWr0sIuzJLCsKwCF2/AuRylJ9MGfUQkGkvzd+O2I7
 tj5mm/Ia5LrkaCvEVcty0Yr53N01m+PJBFcR/Tc1h7mbRqzFhc+bWQn1t3xxUPsY1OyM
 dYkkk1q/by0ogAmVMPme5ETJgNEtzcwUMGk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32j13ynx8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Jul 2020 10:18:54 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 28 Jul 2020 10:18:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KOVEfoGk8nOUO6vZDxY+ebD6kWQhuUL4m9m45Fc9MemSNkdmEydXGBCyVYecksQc6iK2SVRJXZ5n7StUKNWXM1PHQRjzNLyDqRAR6ObBuuRO3K4QDk+Xe/BX9V1usnVRWNRly2718ahtvky1A6yJlUA9iiYidrvubjh4w8iyvr/tqHhcKrJ0habrb5k/UEJOfHXNlvj+7zmH1Q9CZoGjcW51JqY2pS5M8wInKiMYyQ7rf7rpao8vuTZ3KwIz3MWL5YjIkZ5RBgLOz2rXurxScCp45b9UOZUoLfLvNNJE+Fm2ta8U0cGCKzUU2AWR1uMUPxv1UvWg9eslxKiq+JmwSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJVrF25GzqvPNmqPlof3Z4s5tQSQJw2SeXVqaKCduX8=;
 b=nSb+j8GeWzPSJswJ9/56XLuhjzyJP6xmS5QUmzpsQB6JQWoo/yW2ER8fW45OyvwI6/jvVO1jD21nD3t0f55eQrNt0GNWGusshy8svxU90YuI6MoN5E4lF1hy80V9JBReGshiLSzZp5o/iikSZCgbJi/TkrH543vtmwFQ5jXl9C7esuVnKc5LVDmQi1hp6JddhmjU36jyYDLdS59UrSemJXGrxC/wCdkDGHuGGKqcr4CMp4TJkGKuySs7Y05lcdx9KTw+DCRJdhGf+T4TGWHuVBd559H4NE3TRMh+rDmtFQCbz1T8dNBKGg6vYoc9qGPE5scP93L+VZCDVyIUDU45Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJVrF25GzqvPNmqPlof3Z4s5tQSQJw2SeXVqaKCduX8=;
 b=HurZL1wOdHICk2x5TLdeaYxEOnosbJ2ItKXf1qKJ242chVZdpIPaDsczULcQOyS1Kg5rTUYSBXn9xblew0pG5BYS0IgEKZpldK9HjOM1mi4Wyk6YQppEH7AI5UcNsHFzhRMBGpBiu3rR93IVI5RF7DtFSwtnkbDMSOEq+Ow9+Hs=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none header.from=fb.com;
Received: from MN2PR15MB3582.namprd15.prod.outlook.com (2603:10b6:208:1b5::23)
 by MN2PR15MB3551.namprd15.prod.outlook.com (2603:10b6:208:1bc::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 17:18:49 +0000
Received: from MN2PR15MB3582.namprd15.prod.outlook.com
 ([fe80::e9ef:ba4c:dd70:b372]) by MN2PR15MB3582.namprd15.prod.outlook.com
 ([fe80::e9ef:ba4c:dd70:b372%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 17:18:49 +0000
From:   "Chris Mason" <clm@fb.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        <netdev@vger.kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC PATCH v2 21/21] netgpu/nvidia: add Nvidia plugin for netgpu
Date:   Tue, 28 Jul 2020 13:18:48 -0400
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <A2C3C5F0-D86F-4D0C-8402-822063D2C6D1@fb.com>
In-Reply-To: <20200728163100.GD4181352@kroah.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
 <20200727224444.2987641-22-jonathan.lemon@gmail.com>
 <20200728163100.GD4181352@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR02CA0023.namprd02.prod.outlook.com
 (2603:10b6:207:3c::36) To MN2PR15MB3582.namprd15.prod.outlook.com
 (2603:10b6:208:1b5::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [100.109.110.153] (2620:10d:c091:480::1:49e3) by BL0PR02CA0023.namprd02.prod.outlook.com (2603:10b6:207:3c::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 17:18:49 +0000
X-Mailer: MailMate (1.13.1r5671)
X-Originating-IP: [2620:10d:c091:480::1:49e3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db2038b5-917b-4556-1c13-08d8331a4b35
X-MS-TrafficTypeDiagnostic: MN2PR15MB3551:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR15MB355189C4EAB870BBB4B703B1D3730@MN2PR15MB3551.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mdXuWIthmtkcGj/VO86xzLbWFEtu0+FWpjz4any5FbKZXqNqorEnWTzRmdiOZqOWn1JjdD+yJysL4fG4m9HiTCgfMxh6cFcePYnHfe17BlLMJfZx49eDWNogyNkyqt/zpAaNdeyh+QipuL9k4cgZ2pwLzLv2PhCNXwCxZVzlRVE1SgN8VJHZv6E9pI8Fh6o3Zj86NigaTUKKt4Eloqtn9tsiUOXmFlJrG0BL1QpoLd9gMBX6jov8pI7s5mAHqRl0ydoOeUCUwe7cFDDs2rvO6do5uW9sMNzy3fJUQgYW+Idxt0HiQoLe0dmiTq7KK/Vmq1Te/E2kcaCcTWpnDemtgVIXn+McCgNsoWQWgOTZANS2lSixHsAY5Re1/WsXSh/b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR15MB3582.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(396003)(366004)(346002)(39860400002)(53546011)(66476007)(8936002)(86362001)(83380400001)(8676002)(33656002)(52116002)(66556008)(36756003)(316002)(186003)(2616005)(956004)(478600001)(5660300002)(4326008)(6486002)(66946007)(2906002)(16526019)(6916009)(78286006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 6mKzVcyaNUtVHhIqZQraWicVco2lJLfrEbYy12GAiFisf//GzkVSDznnLC9R5IMaVFeHAwT9sK9CvzyH4o+IBb/OhyDm/yOaNO1eKVxD4W7ohx9WA9by0iim5jticqpzTTdBOdnHp8DeVKeVw0LClXWyvc5Ah/VNHzhL3rjnpFILbUZnYlES34abKgXB8hHtckaPfzu8TJcDERrcjMk5zE9KwG++vGrlHnpqVFNP8o63RTeTW94Aw/wGsEIthp9Ub+gr58L+I/Ixu0zkb8ljjfNlCwsFKuiuZZanz3Gtrkjs5jGnqLSySLOwt7J+JVx3CKsl4bZFCdauB6/iEDCW+MQIE4G8+kgkLLZ0eUtLDzvHKHti1H1Lem2r+yLHYIMhBKqFHfGFU1j+E0d6Km2rXGrwwebuDUaeB1CdNftjnolPaz78nz/tSc01Jgr/iAEmy8XSP2kxkuqBwuNVYbdgVFavRM/YtwR2a5kBvLKnKJxyjPCTFxq7lMh/qNcgq/Fz9ElTZYeU0qvfHy6AK8d/cQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: db2038b5-917b-4556-1c13-08d8331a4b35
X-MS-Exchange-CrossTenant-AuthSource: MN2PR15MB3582.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 17:18:49.7932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qi1ldCjgwyNfF9BOxYi89C1LRGBkiHLYWRARv5+GeBcoZMIVK6yjvJO624BUgk1A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3551
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-28_15:2020-07-28,2020-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=951 adultscore=0 bulkscore=0 mlxscore=0 clxscore=1011
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007280127
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28 Jul 2020, at 12:31, Greg KH wrote:

> On Mon, Jul 27, 2020 at 03:44:44PM -0700, Jonathan Lemon wrote:
>> From: Jonathan Lemon <bsd@fb.com>
>>
>> This provides the interface between the netgpu core module and the
>> nvidia kernel driver.  This should be built as an external module,
>> pointing to the nvidia build.  For example:
>>
>> export NV_PACKAGE_DIR=/w/nvidia/NVIDIA-Linux-x86_64-440.64
>> make -C ${kdir} M=`pwd` O=obj $*
>
> Ok, now you are just trolling us.
>
> Nice job, I shouldn't have read the previous patches.
>
> Please, go get a lawyer to sign-off on this patch, with their 
> corporate
> email address on it.  That's the only way we could possibly consider
> something like this.
>
> Oh, and we need you to use your corporate email address too, as you 
> are
> not putting copyright notices on this code, we will need to know who 
> to
> come after in the future.

Jonathan, I think we need to do a better job talking about patches that 
are just meant to enable possible users vs patches that we actually hope 
the upstream kernel to take.  Obviously code that only supports out of 
tree drivers isn’t a good fit for the upstream kernel.  From the point 
of view of experimenting with these patches, GPUs benefit a lot from 
this functionality so I think it does make sense to have the enabling 
patches somewhere, just not in this series.

We’re finding it more common to have pcie switch hops between a [ GPU, 
NIC ] pair and the CPU, which gives a huge advantage to out of tree 
drivers or extensions that can DMA directly between the GPU/NIC without 
having to copy through the CPU.  I’d love to have an alternative built 
on TCP because that’s where we invest the vast majority of our tuning, 
security and interoperability testing.  It’s just more predictable 
overall.

This isn’t a new story, but if we can layer on APIs that enable this 
cleanly for in-tree drivers, we can work with the vendors to use better 
supported APIs and have a more stable kernel.  Obviously this is an RFC 
and there’s a long road ahead, but as long as the upstream kernel 
doesn’t provide an answer, out of tree drivers are going to fill in 
the weak spots.

Other possible use cases would include also include other GPUs or my 
favorite:

NVME <-> filesystem <-> NIC with io_uring driving the IO and without 
copies.

-chris
