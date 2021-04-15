Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA8F35FFA5
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 03:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhDOBdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 21:33:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40708 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229449AbhDOBdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 21:33:23 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13F1W2qc029296;
        Wed, 14 Apr 2021 18:32:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=hrqP4ItLSBD6Fk/xMqMX2QMSJ7TIueuEY3L8nAgfR+I=;
 b=kJkQDvL4AG86eIDSUSBW3CH14GPvORRlI0nunXETyijTQiYNO5nv2kIox3MG+c8tijMD
 VtYm3tkypeug3Cz611hcaaVNmd0UKE+7WJSm5tqIgUa0Ok8RhlqLzQybcND8fEWEBy8R
 6L7TlMjcdAZ2JHbOC51ysih2RDaU+Pfx0BI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 37wvny4wkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 14 Apr 2021 18:32:54 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 18:32:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0ul+REVEkddH4vPjhiOI/DagAhXJpVu33QDwXr+GwjuKVaHfA6STaDXW1wSgeXaE3S/FKjmGxtY7PV/hFBUbD27+FIaDatYP6MJkbiU5ZKolf10I7XeOwEJ8iCBor6L4gdfHqYV/D7eKMMDR2Qw9xbUJLDketBhPAe3B2AvNdTKmPQ6wZotpMAHXyA9KIwkuxUV8SSeSchEqJf67J4Jehe+XyvuhehTNvPz529lUbLtgcwc3Eclfd6APlp2q3l/oDy3T3CPNNDHqQqP2p6UJRrKyq3abDCVkJf+kG7HN89WLWdCutGsm9X0PuWqlP1hnb08Dvg5shM967o2RqRk7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hrqP4ItLSBD6Fk/xMqMX2QMSJ7TIueuEY3L8nAgfR+I=;
 b=H7lqdPSoI5uHMPuFQ6XJwY6zHSmY4EUGeMZdCXoRKphJr/MG4763a0sxSUO6fh+zSL5f1A4bmdLRTc2JfSjjG+Q+F0ca0+RoIKxb9ngt9jml+Y1UgSLQr22RKsCijIslzrCoo89+wGMOKP82rwuhY+a50lHbthP/WgJoDUghA/yzsCEJlEKag+6BvQ3mqeo0Bszp0QEaE4Ddxp7LfDcrRz6xy+e8BPyEGybOtLoghs7d5a3s0asymbGUwGOpJNWpXHfvOCE81ybrSk3mJja5dBnzSEZxJSz4+qhjMl2iyFsHcqYbe7V33RYI5GV6qtmJgYNr2/dDPPQHszM6mVEGAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: 163.com; dkim=none (message not signed)
 header.d=none;163.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3255.namprd15.prod.outlook.com (2603:10b6:a03:107::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 01:32:53 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4020.023; Thu, 15 Apr 2021
 01:32:53 +0000
Date:   Wed, 14 Apr 2021 18:32:49 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     <zuoqilin1@163.com>
CC:     <shuah@kernel.org>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        zuoqilin <zuoqilin@yulong.com>
Subject: Re: [PATCH] tools/testing: Remove unused variable
Message-ID: <20210415013249.acyqqgfyllj53d2h@kafai-mbp.dhcp.thefacebook.com>
References: <20210414141639.1446-1-zuoqilin1@163.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210414141639.1446-1-zuoqilin1@163.com>
X-Originating-IP: [2620:10d:c090:400::5:fd25]
X-ClientProxiedBy: MWHPR10CA0024.namprd10.prod.outlook.com (2603:10b6:301::34)
 To BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:fd25) by MWHPR10CA0024.namprd10.prod.outlook.com (2603:10b6:301::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 01:32:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d6b89a8-e889-4df2-e5b4-08d8ffae635f
X-MS-TrafficTypeDiagnostic: BYAPR15MB3255:
X-Microsoft-Antispam-PRVS: <BYAPR15MB325549603BF08B7320D3F6AED54D9@BYAPR15MB3255.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8+5F/ExxTA8AADzJt3J5yz5eFdtMy6pddikKyMGn+vHCBXmHT4sKeaHvwvLrxttn+IbaoaX14iVeQ3ojpSIFGG2IV0CpR9uz/JUpEsWXXubboK1lHfufWKO9gQjewk062tUem3VUPPGRc9wOWwdy888QOqbyBDlG6yZDZdmHXPaLX4coeG9nkxjhkQ3B5lhGl7+ErQ8o03+UPZO5qZYS8gGoolRV8HUQjVaxnSIv97SPcPlDXglWbzHr3OKhvrtBWFGUp1i5EfV0ynSak1GPE8ZdExunXROMzlR9gIb2sAten0t+PLZ0UDVdDL9ogpGxSP+iKiSArkq63Cxnqjm9VcUdSZOpONNMEZSGMcdG9imshpHG0EE3Pnu+U0n7RWPoxZRm6cLsVHtxjvdR4JVs98t+IKxXbIdjhrp2zfDjpOyy4dRc8DJ+eys4reKVgXkyN0h/v+jpdMeCLdJFQPcHiW25HvL85KEJcQWYztuoBh6T3McUKWfsItacQEo6skKWTpcjx5o1/RHo2XGbPJRvjG6Yhr+BLxWWqG2L84sXmPGBFC26PC2sXY4xX4uHxFY2cQoG/O5Th4GoOWKLqX8m2vMb0gA7puMP4uy3oI4k9b96iyuAk0uJFddLliynRT2RE2W/8oNpeWEwK86xSzRjxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(366004)(346002)(396003)(38100700002)(5660300002)(4744005)(8936002)(4326008)(16526019)(186003)(52116002)(7696005)(1076003)(8676002)(6506007)(6916009)(66946007)(2906002)(7416002)(9686003)(86362001)(478600001)(55016002)(66476007)(6666004)(316002)(66556008)(1491003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?byDaRkBkScy5fJABbVsCI1/ODCZwuq78RioAzFUlOvRniOJVhVf6bdz3PF2b?=
 =?us-ascii?Q?nu8QwWcIrlPlbr18EHQNfq4bvLQp8QUxhX4XWxO+kXvoyCaYcpppCu+QKfJF?=
 =?us-ascii?Q?uq0keoql9lN7XO3Mti5Ib+Upt9HsS8jvXc/ncYCOK6l89/IZRX0FWjWvpaVT?=
 =?us-ascii?Q?ZeLdkIz40pPXp0vy68AkA8KPRRoJIoTY0u3GnPRHPifxSOpJMsv/4PYsKQeo?=
 =?us-ascii?Q?fIVqKSl3jjOpM0KBjaF06SVxw9AwKO4Og0wbZEsnTGtqQU5SozzLsuwf8BZA?=
 =?us-ascii?Q?N3skJdvNdc115o/hMUlF5NJ2KO1dZ1SFGbFYcBM0ChmeTtx1c2vmTypUagPw?=
 =?us-ascii?Q?DgVpP7ODzfkOKFbwTIfrNdG1a09XReklcHMYptQRb7FWpd4NszvbP4OFUceI?=
 =?us-ascii?Q?DfaQTe5Uwd9WUFDj9FTc/wgaNkLXvYQiMLuaf+x3zvE6z+Cdj2e1V+pACbrA?=
 =?us-ascii?Q?/3NDjt/0it/uNgW9ZNDFSrZPhbDNq9jMWx30zH0AEeyC3HQLd/aPinsz5rIM?=
 =?us-ascii?Q?b5Rj8ylAlx6Ka30ReWOTEwOOuBaeeMHd+zdS1PD1J/qA3vph74OZiqquaJPS?=
 =?us-ascii?Q?EbJLZwyBqWDXCyi9LKJjPk4/SRXdoI8CQPdwHW4czcTRkTkXyxd/ClcKQxPj?=
 =?us-ascii?Q?CNnXaUMh4LqGM/B8diZLfC9vcsP4UytS5pefhW3Ld5mM/LWCUy+wLszR5Y4f?=
 =?us-ascii?Q?5rZ/M0yzxk0x3qBE6kkFxMnkt3DkKKtG9/dzY//jMrU96txZB4d43MP2QSyc?=
 =?us-ascii?Q?VE9tcXGrhgWOtACOKIBsTSfKJjhN/P34WlXxpMPXuNXmBAlMYcXyJ/gi5Owp?=
 =?us-ascii?Q?DkePbEaC8yjZPTLkLiuAYeh3jxnsZTy6IFxmc8SKPtAgFj0IcFzTFQqraPAI?=
 =?us-ascii?Q?+cR//qFSZrSm/rR9mwXfnmqGRKyw1CZJE8uz1X36f7b2bcRftcVH9Xn9fi1E?=
 =?us-ascii?Q?gNPKpOADeX+lPQKg+6mvaML4Yf784Y9pC4fOXBxdzekqQU5HBuk8wgvNmM0a?=
 =?us-ascii?Q?B+BjYJnYHJ1c+qhIF2iTqn1ITe109COJxb+FofqSmS+B1nXNsvlI+vEoShPz?=
 =?us-ascii?Q?PuoL3VLHd3NnBImZmZQQHLNb52EzlZGlQNaCV1d7vVJOQ4aS1oysx8F0EAEj?=
 =?us-ascii?Q?zBOxmSWxd5M5Ksn/4cfWMFty6kvbA0p/L5m6RT1Fl9rICTSkPqf2KSokUIlb?=
 =?us-ascii?Q?jMgjEQXxMq1Rxl6GD2wKmajvbb/T/RGf0iEuSJEGsXDsq7U8puL1US1jTduN?=
 =?us-ascii?Q?vmbLXJyfckMdzf2ChjLbOGk8zydpRbz9xZgG3OliQ8fyspP0JOTK2x8bTGn2?=
 =?us-ascii?Q?RSTS8tmv75JDEt6Zx3YeFprzK6MulTq3uQMp0s1rvgVY9g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d6b89a8-e889-4df2-e5b4-08d8ffae635f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 01:32:53.0616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3aGUmns9NZ70x6gxj0KMWb9pGvLhSx+OIF2m9aGHviXRqFazOcoyRTqYNfocz+jc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3255
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 42nR81k0jYs4VmsetSbc7o8XDFWn2FlW
X-Proofpoint-GUID: 42nR81k0jYs4VmsetSbc7o8XDFWn2FlW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_18:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 priorityscore=1501 clxscore=1011 mlxscore=0 mlxlogscore=752
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150007
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 10:16:39PM +0800, zuoqilin1@163.com wrote:
> From: zuoqilin <zuoqilin@yulong.com>
> 
> Remove unused variable "ret2".
Please tag the targeting branch in the future as described in
Documentation/bpf/bpf_devel_QA.rst.

This one belongs to bpf-next.

Acked-by: Martin KaFai Lau <kafai@fb.com>
