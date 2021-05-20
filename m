Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC718389DDF
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 08:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhETG3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 02:29:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27764 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229534AbhETG3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 02:29:05 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14K6PDJT031782;
        Wed, 19 May 2021 23:27:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=B+TfmFcoq/qai1+aSphZtuCC26LzcMAgAuGUuYptPVM=;
 b=Suw8l/dBZMEIWbpKzFZJN7E5RbyspDdQnbM4TIV2FvF/3qbfVas9hory3TrqN/1gdfAV
 qlv6j7Puu+kdX4LZlsgFCL4XtiMYyAg8L7pr1+m2lAQifohEQf3bR+CDP/pOeSu3piwg
 H65EI/NvL9wYP4QxOyrt5/7hWrMOfPle2G8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38ndsw15tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 May 2021 23:27:29 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 23:27:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNL8ctiVefZRDgZvedTDjV6lxjNvalBRuVnCobB4SjNzcQu43DiqEfGrJm6LMEUzZa8tGo8RWQ7B/XJDrTqBwrGwZoZtxtbnh9mTWb54iNAIw3gnU8QNqN8vkIx15ODP0Sz0XWh+EvqKrmE6kMKGP1e36qq4I9cAE27HO9Y522TS+kKYx7Ij7zl/9mKB/DfRatZwhMvR5k3xCCmLcHtjP2ZYJOgCfciVyyh3B8DZv+/kG1R0xFbHF5qQFwsSTUQUVHIQWGtPOT8mrjpkeF7HKgTPxOQsUJS+nzm+62Q9zCmOwKDcu9kyS7CsNrzC6rTWHvq18gRf9n1nSMhXsig02A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+TfmFcoq/qai1+aSphZtuCC26LzcMAgAuGUuYptPVM=;
 b=CuxQ+ciFhseSseUoRAsE1r5rDIVZ6UU5ZBbFD4Y6p02xEXgQ9nh5Y4fGPAntzCIcJDfdWMkWmT1zWReWLcmwGxg7HGmeQiPogYRZO9/O74UZ7bAEklqRyX+YwqdHym6L64nv6nS77vNs0c6IDeqXSujiIL04AdizoQCVJlJomqmB5j5s+DLGt009/EzdmyPM6OU/p+rYWUeE/Sjf6TMvUy9q+8eMXp/C5go5IPfW3PjyQD3pHy9HCyBEyB5HX3RWnhIFhNU156ZBWEckQo/DoKDHPagDXT7AtlkMjMSXKfKAZLjEOLyjUgajg4hEMVmArJBRSLudDobHnoZfI4fKmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2822.namprd15.prod.outlook.com (2603:10b6:a03:15b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 20 May
 2021 06:27:26 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4129.034; Thu, 20 May 2021
 06:27:26 +0000
Date:   Wed, 19 May 2021 23:27:23 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 bpf-next 09/11] bpf: Support socket migration by eBPF.
Message-ID: <20210520062723.nora2kagi46b47lr@kafai-mbp.dhcp.thefacebook.com>
References: <20210517002258.75019-1-kuniyu@amazon.co.jp>
 <20210517002258.75019-10-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210517002258.75019-10-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:1f3d]
X-ClientProxiedBy: MW4PR04CA0211.namprd04.prod.outlook.com
 (2603:10b6:303:87::6) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1f3d) by MW4PR04CA0211.namprd04.prod.outlook.com (2603:10b6:303:87::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend Transport; Thu, 20 May 2021 06:27:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3035cda-7e49-4026-6c3c-08d91b585608
X-MS-TrafficTypeDiagnostic: BYAPR15MB2822:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2822FB497E73605A2FAB6D1BD52A9@BYAPR15MB2822.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QLrtHHAh6CJ8HGQopsDhbiN3Ou0Z+NobsoEzIHWSh5RtefSnDiPoQlBJOrUxhi7nFZV4O/0RA8uFJRM0e//neKXpmu2oReXlMlu+2cyr4pbbBWeUrPjrAU1uPnGJ4WTbyme/s9Hcz6WKf9vM23xbBkXiwFjVh17fHSxgjJ48ZJsKghCRNCEmq/KkIbfY+W9kCduLUCDLpF2w5/M6W7yKspkdaOiL4f6eIpkLc1kUuXIhB9cLzNoI5OiLcWEgjAduCPgj5InQcZi7UpG7II5aIKUGMRcW2D2PMeR92AOUdXsoW8ZU/BGzKvFpqYnTdK71ttr8FHB5FtAIpLHDacQAIWnefnuDK4AXaeWeyYT9Dfd062v4HbVp0MMjsE5RMU+/ZosW6L0bMT0QVJVvXgGYyFSnh8GM0eiC/i4HdlhYRusIBlsbgjAnqs2ipc6yYsz8AzEJo/1e7Sp/oUYAbUHe5AMFaNhg6J4hHv6xh4OBFVIDHbOHjOgKZi/0dMiDVDODs6Hl9voJlcd7svFkGbVxit2FuSYcsPU5CY9pM2A5Vs+yq6naa3fIYq+DQE4H80kgUEBeR/rELyCU24F/Sh6c+LqYj/XEo5yhhjxkbbR14Og=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(86362001)(478600001)(5660300002)(16526019)(186003)(55016002)(38100700002)(8676002)(1076003)(54906003)(4744005)(7696005)(52116002)(316002)(6506007)(8936002)(9686003)(6916009)(66476007)(66946007)(7416002)(2906002)(4326008)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: DvzKCP5qnUDBOpbNHV/G5MmNOWObdeZXjdh09tWaR/MAf4yehdWkUV2NRDq6vNKtmoPiNR92jgCI1Et01d0HeWenfu9W7BDrr2aWhwskbxRVVJyMmBy8Hfzg+CbRU4p2QQYaVj+gkVFyeQ1O9tEoXwMHWExWTl/60kI3UXQXFGD2IdG4oGw3iJV+W5wG6tLXrmdTiwl6GyX4i2IHnTngMzLEwXbIsNbMm19jFUVxB6gPQnHpKmtGsiKeTfnPqENcIUWY6d8ehGzC3Vb6sexDZVhYCDDOn6+JillmCKR7b8nsQaHjIh3GySxZ8UZU8ZpRxNRroIYss44Yj5LxcekAl+tOTaJ+U0QfL4uyc4xXK6rS+yvgDqvQq22jswJQcMUVv6l0AUXPmNzSNMxw5PRBxWsHWXUqrqmWb/u8NCnYbncj5XbGqgiN6c06T046qfn7QB9NK1M1alTdrQSWy1Bwnj1Mo1ytiJNPK3lRBgKk8MYeRvB1czsJXJY+pzJYh7O8ZFm3Cf2sufAJaDrOvVnJrnCtV0zZ/MrttqfHp7mIfvqkSKgJz1NNjHN8x68A5putnM+lHxnvDZNrLlANw8/m+jvwO/sgew+XeX5ZCfQj8yW22ThCGcS66lMBdi9lFbnbAFdzN2YlhngGhROe76pRBZWbABcbM/r1JJy9zP4O/EnNiW3KU4+Q1OBpUhz8wnTlLF0fXdJqzF8P2Om2i4gxrUV9bOS1lwXpGcZnAbN8t+Ud0igrq8mw0o+ivXSb61uOyDGk3tu/lHHNve/rMKrlew==
X-MS-Exchange-CrossTenant-Network-Message-Id: d3035cda-7e49-4026-6c3c-08d91b585608
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 06:27:26.6289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dt8zYBgRMnkzO56pnoUS0Z1cqx9vJwAR+PJAcpIT7gH1Mhc4wEJv84uTUXj/y5v+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2822
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: sPRyZ5XDB1QmJdDkQPB5DdwtV-CQ2qpA
X-Proofpoint-GUID: sPRyZ5XDB1QmJdDkQPB5DdwtV-CQ2qpA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_10:2021-05-19,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 spamscore=0 phishscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 mlxlogscore=658
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200052
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 09:22:56AM +0900, Kuniyuki Iwashima wrote:
> This patch introduces a new bpf_attach_type for BPF_PROG_TYPE_SK_REUSEPORT
> to check if the attached eBPF program is capable of migrating sockets. When
> the eBPF program is attached, we run it for socket migration if the
> expected_attach_type is BPF_SK_REUSEPORT_SELECT_OR_MIGRATE or
> net.ipv4.tcp_migrate_req is enabled.
> 
> Ccurrently, the expected_attach_type is not enforced for the
nit. 'Currenctly,'
