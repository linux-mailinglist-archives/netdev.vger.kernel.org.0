Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F873814BE
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 02:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbhEOAuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 20:50:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56900 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230004AbhEOAuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 20:50:51 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 14F0mBiu010907;
        Fri, 14 May 2021 17:49:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=oV+nhItf0IjVtysAACs2dSiuNXQM9D7PXqb0BMjULro=;
 b=LGQcBeVvUzhecV3g26jqSeF8rXl5EY6xBqTaF6uo73ZTAM+ebf9Y0jPJ/Kmt3XndAYSl
 XYiZFrD35oEVE573TKYbyhPPbxeFlLWFZgkLs/U9OxwZPqWSXMs6Q897EMwz49B/ww9L
 bShLydLhNIQCXGUrbXlcCcltkjGDzaiRMm8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 38hsncue4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 14 May 2021 17:49:23 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 14 May 2021 17:49:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cuVacDWYMVOITLQ9JXnmoIk3jmtQZ1RsckWnOXma8Vxb+6krcGXpMd3uhRKmJGE3C1JaASAEr9znPXZzyJdJEa1V6mulRTXFyiPm9kHIJ4G0KW0tsu2uAQkhxjHGLZW/jVWe7mwpAodR8oGjO/hcZZkrmNK4rUHr+tXhBg2nSrnHw0bteiEGRYglUsjpfkUgSerCzxswUAoi7e+ql1UGtO871ZTdKEHamCu9A4lxqpJJ0626+xOFNHZ26R7tPDxziFh7bvyIMkrahPuczGYwZeyb2hiHeVKJrgLaPmvVrXwK7nYBkD1nW3NiWyi4I2u5Sz1H0e2lABNpbdp2E3fVzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oV+nhItf0IjVtysAACs2dSiuNXQM9D7PXqb0BMjULro=;
 b=HThrtOkmPlYmS7UWdgWC7UgbKiutxxAor4AUQfoo1GHG+oEyLMOx4cucg4H+dXBDle22Mt1VmIvKCGOYAMwFTP1nrMbafl87FXG+UuRUcWQGd+i819joCKtqGwBE2c6zQw091VUaXIlhT5UeMxPyQZnIfdlmiIH8Z//eNvwEwY7b4hJvqArrGmlBrLvKL1rW9vSKtLA98dwLT9r0PwkEQQpAloTXRzc5zgtz+6pWjQl/e9E2LEqNx9pO91mYCsR45O1+OW923vdt58xvB/oWTgbLUjlL/qTRpoDnpeAD0uXHQvM6gRFXqT7/NTkV3Y4n/z4bgzpMXiJL/iXEmDbtMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2408.namprd15.prod.outlook.com (2603:10b6:a02:85::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Sat, 15 May
 2021 00:49:21 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 00:49:21 +0000
Date:   Fri, 14 May 2021 17:49:18 -0700
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
Subject: Re: [PATCH v5 bpf-next 02/11] tcp: Add num_closed_socks to struct
 sock_reuseport.
Message-ID: <20210515004918.rhtnsbvowtp6mudj@kafai-mbp>
References: <20210510034433.52818-1-kuniyu@amazon.co.jp>
 <20210510034433.52818-3-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210510034433.52818-3-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:717c]
X-ClientProxiedBy: MWHPR2001CA0005.namprd20.prod.outlook.com
 (2603:10b6:301:15::15) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:717c) by MWHPR2001CA0005.namprd20.prod.outlook.com (2603:10b6:301:15::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Sat, 15 May 2021 00:49:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7c1e8e2-c68e-482d-543e-08d9173b46d7
X-MS-TrafficTypeDiagnostic: BYAPR15MB2408:
X-Microsoft-Antispam-PRVS: <BYAPR15MB240815A6920C1B5F35B50ADAD52F9@BYAPR15MB2408.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vYQyXSXlEEbAuZJcLYJnIAE0Jrewtzak4Bcgyi0ZYzQVItRDBguVA35R8LrWNWK7UTj0NbMgjBvvCq9lSmwkabCxhgfV4K8b15yWt0QThxheYP/F1iojMLuxTF1ixja0sI4f0G8fXXWg9KJX/ICT7vVeL0UFhv13o4SiUXolRK30VoMB/T3/lKZkYK3KkKM67QESVo6BzvFg+rIVzYwzj9avomRkSfs2mlVmlNbeHJNCr9EY7/rKSLALb73pbzIVWDr4FFiVElEtEWpm/241sN5OuEbhtGO8o9eBvPk3r9DgddiY1P8qWWiPps3UB2DrHRM64mcugTdFujhyaECCh0L7m0GnhQXodwPv5uH+ZW09yW4xWVjF8tWIQv321jxIb4CeLhw6GiYq3OyDsKNrNk17p16L2oN9OlQCOE4yn5uckQ3sV0ybkBbjhzkt8eRPEcay7vg3b11H8uKOOJChZLGz6v+dD/3tS/r6ErjeaxHHyAkX1LlqhQgWQey7XQNR/YRilop52CVPryeTlbyGoJFwoHStsD5z+nw35EpZXlEucagSc0YmFJlKC1KPv39HxYUvxVVCLw6n8MefIWYv4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(39850400004)(376002)(346002)(316002)(38100700002)(1076003)(6916009)(83380400001)(55016002)(52116002)(4744005)(9686003)(33716001)(54906003)(66556008)(66476007)(5660300002)(2906002)(478600001)(8936002)(66946007)(6496006)(7416002)(86362001)(8676002)(4326008)(16526019)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zToBk53RZA5nPInE85hX0wDX08b52/9NyFGSpc+sN0Oi6Y2SZkN3GqSGQBNc?=
 =?us-ascii?Q?RaV7RL5GcziK0Llz9T+tkspznefi0dxbZI+USAoo/+eP7SgnHab4z0db5lAs?=
 =?us-ascii?Q?u8ryWu0Q3nJ3p1Kse3pw321/udRD2p1XAyskBkFfwBYTAfF+PeLooBoyXcrP?=
 =?us-ascii?Q?ZC4NUxwFNrG10X4GmRKUp/xhCap+o4NJVXBErekI4F7EXSrLD+SUUZ6O/aGK?=
 =?us-ascii?Q?wsIH9Q0FzUm4h71yB1fwm3XupJlj35f9GfCBMfPjtiH+hlFrFRyN5hLkhNSr?=
 =?us-ascii?Q?wKTP83nwn2aI87JWTRldlgvhIUhfjAGsmHScRVgZKeamFlaCDb6fhZ3VpfWV?=
 =?us-ascii?Q?lUbUHkTd3bJE08GEeVz1KZyJIOyIyHZyv6pK72yFx+Tk16TOC4Vja0BLWdGq?=
 =?us-ascii?Q?j0QVs94B84OE9IUoRaCdrR1aH0G9vk/pjj/8fuR38fvok/4AveV4oB2sx8yf?=
 =?us-ascii?Q?JlhPk+M1TkKRHpC7yFYm7s4j6ViovcPpPucj9RmEBaeCAdL2r7sIIWJhs+98?=
 =?us-ascii?Q?e5cDt0ZTeO3fkRv7F6E+LJURVqJCzSinlI/2Vx/yTC0n/T//VbHz8HCR0DNd?=
 =?us-ascii?Q?qeci+lBCls3s3Ptm9LoeMw6pbRKyOqwChun/U6hVNgDVRlRkHaQ/jfW3YD/n?=
 =?us-ascii?Q?uyPu3MBmFgvmJMSC3g+K4zrP7a880H7rDDL09hvY0tJxtawP5gn15c4HvwXU?=
 =?us-ascii?Q?MLHSLrM329wlG88lNn9hQy/3sptZydSRVcxe7/bgpcdFlS3V6yL8pr/dV6TA?=
 =?us-ascii?Q?pMlbUKZcsPjSusp73zDCmlGcjzw+wXGrU4xAXMcns4VK2AJSP60bt6iWXsMf?=
 =?us-ascii?Q?DkYWVxb9+290ADgcDPSx8TTV9drivJrW9jzIrlTD0fFaLHW2+3Hza+Vn8iTh?=
 =?us-ascii?Q?bHDReMBsEK7Jfijg/jMfItOYxJqFCqlv9q/Ak0axbH8r0M8lVj2Eh4urKBHx?=
 =?us-ascii?Q?lT7V/R5Y00DO685RX37YNi7Gd2coVwEdGvXhvLXpa29EclRi0Ww2lXhrVJ5E?=
 =?us-ascii?Q?NX/TnwEb2f2l4JxDW9KjQtM1KYiSTJ56woc1dHACrXjekex3YJURdMVduKnc?=
 =?us-ascii?Q?W+MoDLF2HGOdEBUtZNk6YKu6RVA384kMXNnoxAo3lQwhXe0oox2jxUnDByWX?=
 =?us-ascii?Q?EITXEUwv2LazxbNg8kFql2nafPnN6dOUzp5oj0aOvk1g+Sh4Zpsd7nNs4Aep?=
 =?us-ascii?Q?l98ZoiQfAm7+WxQ6h+hvYY1vQL7+hBqvsVod99zj+DDQ/JMxZ5EG7LSFtS0o?=
 =?us-ascii?Q?AyUGHR4MjFHd9DQgaRqDxsGcxZVUjcNYpo3ZMxSmV84MJvMeCV7qBX7Qq7P0?=
 =?us-ascii?Q?28GTfvlBLvgbbyhCTdNvK+UCo1jV2uD9qOrgnR5LaPhuuA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a7c1e8e2-c68e-482d-543e-08d9173b46d7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 00:49:20.9721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V3aE+HHuGApXSg+DvF9ml7J7n7QNtX0bQjUpX7TWd5UeH3Sq/nvwPDlpwiSdVUfr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2408
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: ZbV_lsF4FTjBF2NJ87E1jGkAdbouvtgc
X-Proofpoint-ORIG-GUID: ZbV_lsF4FTjBF2NJ87E1jGkAdbouvtgc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-14_11:2021-05-12,2021-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 12:44:24PM +0900, Kuniyuki Iwashima wrote:
> As noted in the following commit, a closed listener has to hold the
> reference to the reuseport group for socket migration. This patch adds a
> field (num_closed_socks) to struct sock_reuseport to manage closed sockets
> within the same reuseport group. Moreover, this and the following commits
> introduce some helper functions to split socks[] into two sections and keep
> TCP_LISTEN and TCP_CLOSE sockets in each section. Like a double-ended
> queue, we will place TCP_LISTEN sockets from the front and TCP_CLOSE
> sockets from the end.
> 
>   TCP_LISTEN---------->       <-------TCP_CLOSE
>   +---+---+  ---  +---+  ---  +---+  ---  +---+
>   | 0 | 1 |  ...  | i |  ...  | j |  ...  | k |
>   +---+---+  ---  +---+  ---  +---+  ---  +---+
> 
>   i = num_socks - 1
>   j = max_socks - num_closed_socks
>   k = max_socks - 1
> 
> This patch also extends reuseport_add_sock() and reuseport_grow() to
> support num_closed_socks.
Acked-by: Martin KaFai Lau <kafai@fb.com>
