Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA94E183DEE
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 01:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgCMAqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 20:46:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62280 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726898AbgCMAqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 20:46:45 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02D0eogK015096;
        Thu, 12 Mar 2020 17:46:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=wcy9XuNUCJ8m5GO2G+Rs/fpU8iNQzJEWf30p2+F5jAo=;
 b=B9QDmHUIVX0U/E/BtHxao1IWDjWn6Ky/q8lzPKA5jwBmAuTBqAn4dMI75XsFHqhJsuZp
 EFvco7wbVTi8NK5kUbjmoXn0t9JpQk6HNViES5fd+4vCMRAzwm2rU5wNsjzr3f1rUAcO
 cPw2v9ZRNElhlQAIK9xQRVLK/V006jo5Y3I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt80sndg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 12 Mar 2020 17:46:32 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 12 Mar 2020 17:46:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dLmHuxhK+NQglIKHr75PclSMLf2kQyv6nbt6PeR7QWzC7ZgkClMOqNWACe+BYAhVP1e4tmEtGbqkcp8SrtAL+kkGu2NU+JX6i6frwdolESklherRZnDfBcmdEdBxM7/TkUToo+HVRxbkikxMzgf1VltLUBBvSXfNn0bAc84bQ0P4hvie8KeShPYRyctXI8cCY8Hd52aWoH30X4lSlpst8Wn6XFy9moHETjHQQuCmva3bZmq345TpMT4LXAKvs0wCRzVz+K0GEKNWcQPSSGDyvcC3xwR7pk3mSv+WGU6BmPE/ZsyvuYMp/DMhFOQzSHBTckvOCszy/W6US1TpKOEYOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcy9XuNUCJ8m5GO2G+Rs/fpU8iNQzJEWf30p2+F5jAo=;
 b=FFaSA5ZamgJ7qrm8EDjZQ63U64qugOTJbV278+DGqqbdm4cBAspzfk1TVTMQiRwfGrJqMQ45FEWGfn2zSwDJ3LGijGK9SsCjikvLfx7HbL7OsCJxtX/pgNQfjfp8FsIgT3zwGvKKiOt+fpY/WbM+Rn4e9VH+YqUvYGqHuinVcbJTbCTQk8izL+UOV9vpuCK2vvZKV32D+ayJ3tGyN3QZIaMobgpzy4vdDiUGa0beTyiZ+1kQ7JiC+lWym29VRc5UazDW3Cl4PKxvU6fF1i3XBnzTG6sreZew2e1LUYITywfcegGbBcAL7bf/ALcf4t9V52kNP/3fMfIIBQ5PqwM34w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcy9XuNUCJ8m5GO2G+Rs/fpU8iNQzJEWf30p2+F5jAo=;
 b=jqB4AQQnDFZbY7hSXsNu7lfZy8RtGN9ZT12ZGferCKoWfsZ0znfGPwN6/iGEqms0KxIPzedeN6wthfSGOk98vlhXRa9evx831PCUmI7WC2MYUad/vGCc18mwH3bgVcsGoXqT4hPYPDwqxhEIkOif3BNhoS0rmCW4tyGh6eWoD7o=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2616.namprd15.prod.outlook.com (2603:10b6:a03:14d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Fri, 13 Mar
 2020 00:46:29 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2793.018; Fri, 13 Mar 2020
 00:46:29 +0000
Date:   Thu, 12 Mar 2020 17:46:26 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH v2 bpf-next] bpf: abstract away entire
 bpf_link clean up procedure
Message-ID: <20200313004626.3w3ndom5gogplvrx@kafai-mbp>
References: <20200313002128.2028680-1-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313002128.2028680-1-andriin@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: CO2PR04CA0139.namprd04.prod.outlook.com (2603:10b6:104::17)
 To BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:fd85) by CO2PR04CA0139.namprd04.prod.outlook.com (2603:10b6:104::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Fri, 13 Mar 2020 00:46:28 +0000
X-Originating-IP: [2620:10d:c090:400::5:fd85]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2774a7c0-1a7b-4ee4-8397-08d7c6e7f7df
X-MS-TrafficTypeDiagnostic: BYAPR15MB2616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2616BCC19887F27FA41C4276D5FA0@BYAPR15MB2616.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(136003)(39860400002)(346002)(366004)(396003)(199004)(5660300002)(6862004)(6496006)(186003)(52116002)(16526019)(4326008)(66476007)(66946007)(66556008)(9686003)(55016002)(1076003)(81156014)(316002)(6636002)(4744005)(33716001)(478600001)(2906002)(81166006)(8676002)(86362001)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2616;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v0GPUgpiL/HroSarEera+qWur/KQDpj5dlvWQK47FSAqZLDYm5aBkfgpNwI2NUBlFUg675oo5oi/qFIbjK4klquZLnWw3YCh/JEecclLm1zQR7rRp1u4An27SCu9hWhasL8fO4VArsoApUPSToXYod+wqYbI/bWVsRsEeZr+UR8WmCRoFoLefe6v5jMdJfvW1mPz8gzZl/L2skOoFk4yr1+aOJxVwaB1e8ByGhjCZZdYj/+ou1oz6jfjbYjFP/7dZF/YJUKoe2fiB8UEmS8dSR415iiprYMEqy+gwmGrrKX2iNT9QQ/NKh0STUl2vNCxFABXCfjj14YgLIvbHoHCWnznWG6GuC3x9Bo0+kyEES9tErq72H/ntHLgo1vQZdA9uWqfTGFAh5rYkewQgMPLvrf5eSYFKvC54fiIde6l2MEolmuYdpJf2kUACiI9Ejb3
X-MS-Exchange-AntiSpam-MessageData: EqICpdzl70FdviUGUaTGucveeL41F0dR0Kc5q+fo3PwNFwyC5C9qyscXE4bajImkCd590MgUdrw7eeSnGY9GFQ9mxSp4mnb3bR7ay7PvRaaLMYwNQWbQ4mQOpqoOiedmFJ1IdALYPBJjQMg7WfSf3IUU3s3v3+PkpF7da0Zv9G1ydEKDztfU338Ah9KlisoT
X-MS-Exchange-CrossTenant-Network-Message-Id: 2774a7c0-1a7b-4ee4-8397-08d7c6e7f7df
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 00:46:29.6758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nyfbHhjV+pqoJ7AorA+rqm0ptz8fTU96AFiK1QCCssQ9W5POA9jmS8nhmSWVWcPG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2616
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-12_19:2020-03-11,2020-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 clxscore=1015 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxlogscore=498 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 05:21:28PM -0700, Andrii Nakryiko wrote:
> Instead of requiring users to do three steps for cleaning up bpf_link, its
> anon_inode file, and unused fd, abstract that away into bpf_link_cleanup()
> helper. bpf_link_defunct() is removed, as it shouldn't be needed as an
> individual operation anymore.
> 
> v1->v2:
> - keep bpf_link_cleanup() static for now (Daniel).
Acked-by: Martin KaFai Lau <kafai@fb.com>
