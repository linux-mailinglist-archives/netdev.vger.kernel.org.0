Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8333D2F529C
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 19:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbhAMSoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 13:44:00 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60286 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728443AbhAMSn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 13:43:59 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10DIcNjg023750;
        Wed, 13 Jan 2021 10:43:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=LmOPinyKx8+8x52Th4DE4vt+lyMbSY2O2z3Pq7Ov4WQ=;
 b=MBrRSo97MoA0IaALi2Q5mdd8loBkX+gUGZBShyW4v4jTR4D3GTP4eZc3kZgJURK1y9Qh
 K1h5AVrQGEBHnNW321haB7o29qru8DLyMbzwLV/UD30SHzq72kaSxzy5k7n8nm6AB796
 o102NdaBhYNSI6fOsa6QRP43vj7zxj5yR5Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 361fppeqvu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 Jan 2021 10:43:07 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 Jan 2021 10:43:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NSH9zXf9bBQbtE+m8FFBz/ArvQWs9cGVmVVLhnEl/cwqlkbaNtkzMHN+/gQYv9W7wq4qDHBHC2mHVieeSti0pQ0v68eAdjwfIlMO9zZ/aYmpu86Bytl4USUJCPwWNCuIyLFLP6N9dsU/iEIpT1hz2HnQjBxGfzik7+Mtgft7fLCzWXYmQ+KmgjWsxNXZyRmNNSSORpFIn36ITOY71A6kRNBT5lvvy5vvWDQpcyj6aW95dXWcJPB3/1TuHy86Z/ERtsyfsJEom0VfmVlweNZ9Y4L1WcJzkoYsj42Gn8jOWYUlcxIhGodCFmVwZl8IyOjV3KPIubCpA4qlj9DTry/wXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmOPinyKx8+8x52Th4DE4vt+lyMbSY2O2z3Pq7Ov4WQ=;
 b=MhqIoZaD3v/WSGM4JeHXK7/povnvDTWa35uOFgMfNb7ElGNT4CFgi9HuG9skeZU6fUZCDUvI4K861v/RaVPF/7JKjAsElu2xj5Xwrv3G2F6g/YLhWoOSwCUmiN53NqvCD9vuQ/JYZY0gxOUs1TLMCariyvpT7+3bJJZVYkBzTlnLNiezQJq51NxE3jlXu3PSZkPA098P+j9wKXqeY7B+4k4xygDBlKngDP0vSQhFGFO1OZhSgHNbTJd7G+8j68iQT17k3lo8UIIKzlrK/IKJ+nvyfFiJ0Whn+G1AziGuLZ9FcXnWXCV1TVAqyq1m5HGHmVVw59RtAk+hSqMaJS9rTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmOPinyKx8+8x52Th4DE4vt+lyMbSY2O2z3Pq7Ov4WQ=;
 b=i90H2L5DAEFMPBA5oVLwjZO0sOQYjczT3D9LpraG7EChgEUlTkLGz7A7SDhga6JpW5ekpdwijAPkEYoWCHDYwcAw5yvNKJHPttY5FuqP6+hpqd0rflJY2hZXYZn8mfniHYOFGzzglkTtl5a0kSGNjGQ+8HiuDneduEXTZrizO4c=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14) by SN6PR1501MB2094.namprd15.prod.outlook.com
 (2603:10b6:805:11::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Wed, 13 Jan
 2021 18:43:06 +0000
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::65cb:e5a9:2b4c:ceba]) by SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::65cb:e5a9:2b4c:ceba%6]) with mapi id 15.20.3742.012; Wed, 13 Jan 2021
 18:43:06 +0000
Date:   Wed, 13 Jan 2021 10:43:02 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Shakeel Butt <shakeelb@google.com>
CC:     Arjun Roy <arjunroy@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
Message-ID: <20210113184302.GA355124@carbon.dhcp.thefacebook.com>
References: <20210112214105.1440932-1-shakeelb@google.com>
 <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com>
 <20210112234822.GA134064@carbon.dhcp.thefacebook.com>
 <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
 <CALvZod4am_dNcj2+YZmraCj0+BYHB9PnQqKcrhiOnV8gzd+S3w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod4am_dNcj2+YZmraCj0+BYHB9PnQqKcrhiOnV8gzd+S3w@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:31a8]
X-ClientProxiedBy: MWHPR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:300:13d::19) To SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:31a8) by MWHPR20CA0009.namprd20.prod.outlook.com (2603:10b6:300:13d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Wed, 13 Jan 2021 18:43:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c29f2e0-1f5f-401c-2dfb-08d8b7f310da
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2094:
X-Microsoft-Antispam-PRVS: <SN6PR1501MB209455B0C757A7F8318B005DBEA90@SN6PR1501MB2094.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CEUVeyw9zStnXgyR6JrxW4yWbXxdh9Chn2cVuGzG4yyYbcHOB+D7dplM9g1u5+hswAPDHDd0a2lCnOMtZlFoYpeAXl05Z49SY7tH60Xqgg74OxqLU0E/DcdZp67RWi1NqJ8TB9S/M46hKsd+iKKgDSDVm3rCPnW4LukeKYL3+v9Ajsq+dLoGY949Enu16LaW0ZUjAmZyuw0cV0wQ+/VzaBOmAeAdO7AVjVfm5HA4k/8/sgvgZZaIeZGdmoqJmxryL4jCZWt3S2IzmnmP2nQiK1U7wUJpGrGbxpeLBtNGVW2/AU9uoliq/M/OaZXzCY8abqkUaKzOuYs6/WWe3rdMpzXpinhCPEnRsHjOnStthxWSs1zl4lv3y4QroLsQWKoJyFbJtlcAYUVzxq7UhNwmuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB4141.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(396003)(39860400002)(346002)(2906002)(8676002)(8936002)(5660300002)(4744005)(53546011)(9686003)(55016002)(1076003)(15650500001)(66556008)(6916009)(6506007)(86362001)(7696005)(33656002)(16526019)(52116002)(66946007)(83380400001)(7416002)(186003)(66476007)(316002)(478600001)(54906003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FU2Bc8csHHMlIdJq2YbQqh2ujo4gJmRPMEnCdiFnC82TLLu9qux7Qbiqefg3?=
 =?us-ascii?Q?m+D9bCERgvBne7SQYoiwGUngBurXY+yxMib9WW2iuN47TsG1a2qGzgm3+WMm?=
 =?us-ascii?Q?44EIY2sLUtD5aYvtEE4Fg34NSR4wJzYAwS2pBLzlHnBLoKo/cteZus9Bvx/F?=
 =?us-ascii?Q?cp8MMYaAUuwXft9W/I/3ch5RuGX1rvT5i4lE+oSziQ9J/kdRgOaUwo/UwkW2?=
 =?us-ascii?Q?xTz1moaYUtXtmXo0bcnCQBD0HguvytHetdCf+QbS2QJce/D/Uw4henvNTiUu?=
 =?us-ascii?Q?9rqc/IX54xROuxokij3FzPc0ZMgHnya3iN4Bg+yoF6maxDs6iAPvS4x5gPCv?=
 =?us-ascii?Q?yoiT/0u4vYTVh2mEIA7ZT/TLr37Ph0q5G2wtKXheRkNdDd7QPlmrQyJ7Rafs?=
 =?us-ascii?Q?7KZK1HFmK9hZ7B9Wy+mLd6xM4Hawt7FehW/U1ozYC95X0GzWCBOLlgv856ZH?=
 =?us-ascii?Q?55/jydILOAryVV/r/8U7LXB7hkq71ZLZK8S3DljD8GYdGngD9YN9NhTmrilN?=
 =?us-ascii?Q?Dzi+j/6gWaMTA3TIYftA+NLgGa4eoB5jA5L4KWNZt9x+Osb6JQD8yKY7Qe2B?=
 =?us-ascii?Q?cJCmeBQT3VugNcBRFD7OpX+UvZoA1qT4TX64igZeERcHlbyFPqkDRx0eBLUC?=
 =?us-ascii?Q?h/NxtHOp92/8RcsaiPY/4DYY7tn+QmzQ4Ivzn1ICUF6+HC/RrU8Gv9j1hUMN?=
 =?us-ascii?Q?2iTg4DiJWlzmFXYGmECtloTzrTwwEWXaa1x/6epIxYgU9AfBGaoqYzR7n612?=
 =?us-ascii?Q?fP27PMD7bJuwolKVBpI6/Vl+S6/Fcb2lxj6vmI0nsMOrpdJv9fkEfHTH26oW?=
 =?us-ascii?Q?X+1Z/QCluA+D1Xb6NbEIbLNdm83LctK/HsJHMvNJDOR3LGCWllWuXsHb7Gg5?=
 =?us-ascii?Q?9w6P5mKMvoX0UzgiE34j3hxXdFL7xJF0ONC5WREb8EPYnhHU/SIhNzpmrnbg?=
 =?us-ascii?Q?KWYYGxFQdeRDG6RMX20hD01TDm2PZQ6QIu8TD5QBvdGu4GhIiqIfmqjGkSvW?=
 =?us-ascii?Q?rcN/5msOzUUDzjnF4xhOZkWBFA=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB4141.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 18:43:06.0085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c29f2e0-1f5f-401c-2dfb-08d8b7f310da
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qjb8Yr1aEiOsC4eYej8ahDoXHzL64ioNlji5+o4KoEi14NRbKPWv2EV/GX+Zcjy3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2094
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_09:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 mlxscore=0 phishscore=0 spamscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101130110
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 04:18:44PM -0800, Shakeel Butt wrote:
> On Tue, Jan 12, 2021 at 4:12 PM Arjun Roy <arjunroy@google.com> wrote:
> >
> > On Tue, Jan 12, 2021 at 3:48 PM Roman Gushchin <guro@fb.com> wrote:
> > >
> [snip]
> > > Historically we have a corresponding vmstat counter to each charged page.
> > > It helps with finding accounting/stastistics issues: we can check that
> > > memory.current ~= anon + file + sock + slab + percpu + stack.
> > > It would be nice to preserve such ability.
> > >
> >
> > Perhaps one option would be to have it count as a file page, or have a
> > new category.
> >
> 
> Oh these are actually already accounted for in NR_FILE_MAPPED.

Well, it's confusing. Can't we fix this by looking at the new page memcg flag?
