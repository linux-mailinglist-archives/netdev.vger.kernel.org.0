Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818753A4C23
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 03:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhFLBdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 21:33:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10258 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229622AbhFLBdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 21:33:45 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15C1OCku026978;
        Fri, 11 Jun 2021 18:31:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=c7YdCcNQGZP1KkdUd/StNbz/gcYjOo69bTK8q1GjN2M=;
 b=QSwLXGQ2e6/tnU+tuCxe330f73Ho9KOLaiaexJDcZfbM/mo/x/wYIJ7jY1y/NMDexWXB
 CAXKZFQPbCGiCxzk3qBNRPR+v0BIL+6tML7PIqCGFJbTCH4YEbjfR0X2d9OScwE7xgt6
 /p6vV6MR4IqF0r/hO4/IEByKo0X5x+mmIm4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 393rrc8r46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 11 Jun 2021 18:31:22 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 18:31:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hO51ACUzscuHBwnPSDHM+JstpC4gg5sHdrE6fUXgihZGB0OsRUOux7qWT/r3FJimPp4v1hjG8KvltUkgdhMqmVHNJlNg6isTuNI2o/dDwT9v9iLUq3vyzU8nEv+/gS9RCfVvFG7tFs2l3O/vSQQ7rZ7f3VZUo9GOey4/iZJrlaxaq+hkiv2+A8AbvYJobQBNiCcFFRzg2iXhk69veKuV9mtLgyk3movHHEHhyLxRgIYAKxSB0G/9TQ3EqTKMobik4bDMsVPdtMHp4F/03fhoFXSYkGm4+Q3bFzIFE+aX+cOvCd6p+3sgrkVePiFL4MK8vcFfD7ElgViTIGlVJO6j3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7YdCcNQGZP1KkdUd/StNbz/gcYjOo69bTK8q1GjN2M=;
 b=XV/anfGirwgJW4Zciwi7YTiH10O+w8XLCWlZhC4WeNnvNKBiQOAnDc1GyoAH3FL33R8XZJNsvNl99YNTGBsEl4Ykr8Z5qF8Sbup4v4FA22ii/5J5IV0HZ4SxABPxP4k5d4xocf+Mu4BZQRrUi3IsnBLXWUfaS+tv4/hrsrIHQX9H9u6P9hSL+6QSxmQvciqb8cB+udH9BiTMUhyVVZzZAwuCUCNr1Fq/FyR864/hSuFzWLRia8eVsG276CocmRA+/wEc1BZd2A/xOTFjkLfQGvKUioq0GvQQjnt2WjqxTJYXC7LCOnLYD3WrL56XpDO1g4O6+TCn3Wn0pO9F712u2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from CO1PR15MB5017.namprd15.prod.outlook.com (2603:10b6:303:e8::19)
 by MWHPR15MB1181.namprd15.prod.outlook.com (2603:10b6:320:30::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24; Sat, 12 Jun
 2021 01:31:18 +0000
Received: from CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::9136:4222:44f7:954b]) by CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::9136:4222:44f7:954b%5]) with mapi id 15.20.4219.022; Sat, 12 Jun 2021
 01:31:18 +0000
Date:   Fri, 11 Jun 2021 18:31:15 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Tanner Love <tannerlove.kernel@gmail.com>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Tanner Love <tannerlove@google.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH net-next v5 1/3] net: flow_dissector: extend bpf flow
 dissector support with vnet hdr
Message-ID: <20210612013115.dakuf5q3wx43zpmh@kafai-mbp.dhcp.thefacebook.com>
References: <20210610183853.3530712-1-tannerlove.kernel@gmail.com>
 <20210610183853.3530712-2-tannerlove.kernel@gmail.com>
 <20210611064912.76eoangg4xgyb3v5@kafai-mbp.dhcp.thefacebook.com>
 <CAHrNZNgDfpWEdVK19cZ5CLK5T3RbKQSWPVx20e5S-_+zGJ7n=w@mail.gmail.com>
 <20210612011342.2aywi36zfe6a5qh5@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210612011342.2aywi36zfe6a5qh5@kafai-mbp.dhcp.thefacebook.com>
X-Originating-IP: [2620:10d:c090:400::5:1216]
X-ClientProxiedBy: SJ0PR03CA0128.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::13) To CO1PR15MB5017.namprd15.prod.outlook.com
 (2603:10b6:303:e8::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1216) by SJ0PR03CA0128.namprd03.prod.outlook.com (2603:10b6:a03:33c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Sat, 12 Jun 2021 01:31:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8ba5138-ba6d-4b9d-08de-08d92d41c70d
X-MS-TrafficTypeDiagnostic: MWHPR15MB1181:
X-Microsoft-Antispam-PRVS: <MWHPR15MB118150E635B9EF1130C7C7C1D5339@MWHPR15MB1181.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JS8tI0qdGqAJEzYyYW9NpgE+KKnXvRXAt5RCPwAT3RqbB4bSD3idgw8Y6hy5ffW8Uw+GNd2cx+GnA54Q/EJkJv0Q9C6TaP1Y9K5Nh8LVaBzuAhXvGPMzxlb6KEV89u0j65SY7MrsQLMMowpJ2P8vC1+ev8LPWiK9UBtotz1SaeHJJC6V1ppipQpDdo7s8NYi6QOaHgBjMBNovuspzjyMDSzOU7QTR6wnZIh0wlXToMgYJJg+xgaR46aAWos46RCXRNTnW9oq2k8RRtOdQohzzfuMeieSizmhNDLpnO9bV2S1vHRjD8f6ZryF51yfSkLRkBKrHPjajXr+x17bGmdkIW7W8b4B6zHBKGrjL5Bsi+bj6upNSXtvpWCdUo74FPTwcbxT3O6B1UVKo7akQhoGYLwvMowdqdbuJyajMHvcEVZJM1z5m4NJ9Qp0pL6nwz0IUFNpOHXE9/MN+ZTKXjt7ExWNdyI/EUPFUYPvphZW5eZALrIYVBr6yOpK56X/aI6StOnrj4CW/iRzE5ynUEO4OMtcjLtAkuyXQhygXQSkGDUvOy6hpxERljMbcA1PxiikEH+aW91lTJyq/EARL9IrUJ1lNps88oho+qv3AktKGy8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB5017.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(52116002)(7696005)(8936002)(6916009)(55016002)(9686003)(2906002)(8676002)(83380400001)(4744005)(66556008)(478600001)(316002)(66476007)(38100700002)(4326008)(186003)(1076003)(86362001)(16526019)(54906003)(7416002)(6506007)(5660300002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1jF9svKfRWOAfW+k8DN/VRcM60+IFPip9dwLh7BEWYBMUW4kSibSYxOP1Ln8?=
 =?us-ascii?Q?m+1eObIa4b+gcANb4+hMAv81vvXqnPR31oBoqPMEwkuV0ewhvjrd85pDoAag?=
 =?us-ascii?Q?fZ2VEGmbPIpnoC5QGW5udZ5WltOJq1cEQwcGBatp04gYGIuxuFtKcLNX5An6?=
 =?us-ascii?Q?AY6siqWc6ozJEqNB+fGRyYgiyML2EawtZv3RCP9jzqdwAqyZwz97GB/GiBLx?=
 =?us-ascii?Q?qeeugrh6qLUnVfLc8K2AFuf0u1MEq8KJ2ZG1DGTk49j9pDp4pR7qfrj6sNt/?=
 =?us-ascii?Q?2z6G+o628Awaro9QP7+RrVoDw/EsJuY0xEnlSMqHmd7qNl/wFbZVieq8fDy0?=
 =?us-ascii?Q?KhCHY1gnlBNArJPSDe+ZBVobkFSkO4jMYFF0bDz9NT4TQGxXN3IsjDquLyX7?=
 =?us-ascii?Q?RRtiVyUTWHfAgR74u2GRwKZ7+9xZMKvuPmSqu0NZEOTD+5mi+Zvo6kq9yAq5?=
 =?us-ascii?Q?cSTs+gdiSLTbXBWZowqIScFNESHM6soQXec2HLvPZ083i6IJt8XftgwE6qfv?=
 =?us-ascii?Q?P4al70a/Qqg8QH5vRi2rkhMnmvN+LEdU97B7g3QH+zkqq9T3CzALnxW5nnW5?=
 =?us-ascii?Q?xeizWOGBdS92uggH9mawrj2FyK27JQyBGxfCNI370F3zxym1LoobwTWeNF83?=
 =?us-ascii?Q?oqXcyCa2zDuKDWoB3o7h1On3yfaWo/+HeN+C/J3ayzDuOoXrlc3ooUoe52Vz?=
 =?us-ascii?Q?6+8tK2/iOuwMQJqA7e2jQ8M3yVB8V8OrcoH2Z1Y/2Zwq0bsvNykkbVym8S3S?=
 =?us-ascii?Q?fSGIYbfPxNm2uQqq31wj0u03Xa4fIbAEvs2N9rLjhAwpml42WY3O73jTFJIJ?=
 =?us-ascii?Q?Yy099Mem7S41dotYXcn/iRBzGoickq5nfWaFy2awv15sNFV5Cz75AOXGobb6?=
 =?us-ascii?Q?8oDSNQBJN6SvASU9ZRYBpuIQqaGDxRmeG2KPqZqRfDTP/vxqjitwdCeslBFi?=
 =?us-ascii?Q?GBASg16+r4sJMe0pjhQ5q2VFa3d2QKE9tL7ZA4V1tBC4j9QJd3eOniXGXZpM?=
 =?us-ascii?Q?8hP3POQd/nHwR5OLnM0DLVo34cE1ae1EvWyZgTTZwxCZnkXuhJcxQ0dtr1m9?=
 =?us-ascii?Q?dLwFMrUVeK61bjk89tpffxNiN80yIJihsVW4DGAJUlUgC/So4L/RoHq7Flt8?=
 =?us-ascii?Q?3PJz2+aZK2q4esjQoZKrFP8zjJOgj4tBFsCF8wCe17WgblNBV2klgxpwiDdw?=
 =?us-ascii?Q?y1XCsibrth44zn68q3UxTCIa6yqN76q5cSt+ogQDJyIeP+DfeTf3xTBeiqGz?=
 =?us-ascii?Q?oT3huzjI7FErT3dbEHiGgKQEvkCMuh4vTxFysf1GNL3b5Nc25Sp7VxSpd93B?=
 =?us-ascii?Q?qOJJE+0rmuw5H+18NSHSp1cKEOMgK3OagjDKAOgQZpMkSg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c8ba5138-ba6d-4b9d-08de-08d92d41c70d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB5017.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2021 01:31:18.6584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ymDrRkFu9hSubKNQiq+2UeqtatkeBHKwBgwJQShWYQF8QovHg8iIC6ziiny4UUs/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1181
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: pye4DEdlUuPiA-2R_BH_m_iWTJurIFjH
X-Proofpoint-ORIG-GUID: pye4DEdlUuPiA-2R_BH_m_iWTJurIFjH
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_06:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 suspectscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106120008
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 06:13:42PM -0700, Martin KaFai Lau wrote:
> On Fri, Jun 11, 2021 at 02:07:10PM -0700, Tanner Love wrote:
> > > A nit. It is a good chance to move the new BTF_ID_LIST_SINGLE
> > > and most of the check_flow_keys_access() to filter.c.
> > > Take a look at check_sock_access().
> > >
> > 
> > It's not clear to me why it's preferable to move most of the
> > check_flow_keys_access() to filter.c. In particular, the part of
> > your comment that I don't understand is the "most of" part. Why
> > would we want to separate the flow-keys-access-checking logic
> > into two separate functions? Thanks
> Right, actually, the whole function can be moved.
> I found it easier to follow from flow_dissector_is_valid_access()
> to flow_keys's access check without jumping around between two
> different files.
The verifier verbose() logs can be kept in verifier.c though.  I
think all the -EACCES cases can be consolidated to one verbose()
call in check_mem_access() under PTR_TO_FLOW_KEYS.
