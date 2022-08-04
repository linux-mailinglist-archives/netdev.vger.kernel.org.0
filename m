Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B18658A120
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 21:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbiHDTS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 15:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbiHDTS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 15:18:26 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2762D6D553;
        Thu,  4 Aug 2022 12:18:25 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274IJ3xC029765;
        Thu, 4 Aug 2022 12:18:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=i56NZ58okUJ5b7YPD4vcm0QpBidWB4Xtt784vMwYQp4=;
 b=MJBgKAqcri526sbGrUOmwqqSPW4MikElR5vF+fj2TBr+cYiK4yBVPDXbydaXgZyww2Xq
 WhAdxRZVJUWbMYtxsUgIzks5+JKSRWNKQ3PVga+WanOHXRyvpEUxa6QgI7zg7of+1Chy
 npgXFLm/6yUSuundIH0ZpypnrXF5H60PdPM= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hrb6nbx1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Aug 2022 12:18:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3RXo7RqAFpZue0zsJqXgTX46/5F+rmsAmMUGTHZsdcytcBSs0kI+2Vi6wtxLC+rDSzDcyaMX7sDXjLjtiitAQ5dQKrrXJfhkm8O1tuWiMxQbZFg6fUEY9LlQbsTWLeg65uazoQT6g4Ecz4n60wKwGaDjNAu/b7HnFFPyvvMSiFElQfWACu2HXT43BjOaL/BlqZPf2G/HSI/fZdoENBzMkLXzeDZYoeDsdzlln8UQEglJWxUo94aiRdKJHNyV7TNmvYM8z9TGpkQzV7PV4ziLrz1qa+D4rUH+Ny5WRZIKprb9UbNTaQUKsczI7SBhS4F8rfIjzP9KPZDeU+gK7UUGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i56NZ58okUJ5b7YPD4vcm0QpBidWB4Xtt784vMwYQp4=;
 b=dRuhlLzUVU2BN4LmkW79wi6GQbl5uYrivWICl5v6kPIpmSlQqKmsCAckG/NdoHxQ4OM0AjYkW6U2qvRVlbQbFrivD3lc6ackxx3RHBbl1cb2seOTGq73siNVUemHfDcyoJgullpCvyKTQVrS0j1ac+HGicBO7qQf4XICqmRDYTShWJmp2xPNL2c+vu3FlmO/+aytHb09V0lZvSk3ZoWVfU1XLY8fCq4o4MNDmVR0cIBYRI60QVUYTs9lCqcNocrleAjt6GN0rzP6BkRr4reRvXIAhHqreCDgzJognEujpsPImIaH6LMhsBsqfJw02RMcPTyKei4U42qNctJ+jDMhlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BYAPR15MB2358.namprd15.prod.outlook.com (2603:10b6:a02:8c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Thu, 4 Aug
 2022 19:18:00 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:18:00 +0000
Date:   Thu, 4 Aug 2022 12:17:57 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 bpf-next 15/15] selftests/bpf: bpf_setsockopt tests
Message-ID: <20220804191757.nouixc677ksks3kl@kafai-mbp.dhcp.thefacebook.com>
References: <20220803204601.3075863-1-kafai@fb.com>
 <20220803204736.3082620-1-kafai@fb.com>
 <YusFLu+OvcAIq1xr@google.com>
 <20220804000417.gmaqry4ecgjlpcvf@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBsaXW4atjU984B1rjmK1OqUYNZZPDYFszDUs+O=ptju2Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBsaXW4atjU984B1rjmK1OqUYNZZPDYFszDUs+O=ptju2Q@mail.gmail.com>
X-ClientProxiedBy: BYAPR08CA0060.namprd08.prod.outlook.com
 (2603:10b6:a03:117::37) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef7d6be9-7d4d-489f-33e1-08da764e0b5d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2358:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kX7l7s9DpHFzA5em2JNcZ3pfAf0UfGcC4eiNRSd0QN1zVTZ4aLq/wx20kRSCbWtjC6udFXoqODQRSRzXh7YICXWgV6/uJwZrxVI9vYuWWyj5NsaNXwJU1JC4JSvyKIgwr0jKQ1bSmGZ4WTAzxZJ++5WbOZGkqy1gi9BM+3Cg8vO21saZ3a1XoWFLdQMZKlRbZ66ZmKCxbi70I4RNlmDuVfkhDxbkxfIHRAI/JCujUQfoX3tYIxKHARA4QV/WdpwFIZ6Qk0OqsRDPBIUuPaJ5SQXMl+GwpUgOzKtubpDzvNEnSb7cb1aDDyycd+uNV5dkogCzAicXq30fV9P/Li76D/U4CrRJNby6gXWT5jKt5tvJuNLmR7y1w4pjDdw1KaOjIulnBGxvCsfCeak2FoPbflaV0hvCyBMqexiXcLmRWy3QIY+inBFcDf1AqgtGwEA9hqD9bVSAHzW4M4gWo+Ve2nENLj1xGt7KCjBx2rBmm5yB5MjbjHj7uH7CdRjK9g3CGXxAQ1n/7iB8KRaCdIW21v2RRV2AGCBp44/ZRyMVSzKgA9K4jRoqt8yspXMNFkOLinSraStjR8r+oOSW38KUdulxdM+dZL40Oe5lC08igPaIin7lflcdRh0QcWg7qju7QnbHRHkcaKGtaislEwsoMXK8fUsTYlIkf72tIPp6Z0ZPq1VE1mw13soBt3GqBVGH/23eOT7gVZFItiAawcbvBRgG2ICdzuyC6H6gVtiq68J6MQjAcLpkvy7Yb+NQUw1V
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(186003)(52116002)(6506007)(1076003)(6666004)(9686003)(2906002)(6512007)(86362001)(38100700002)(66476007)(66946007)(4326008)(5660300002)(6486002)(8676002)(66556008)(7416002)(8936002)(54906003)(6916009)(316002)(478600001)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RGp+BB0yui2jZCkMqf12Hk7gfJVaEvo8cYbQoTJkcwO28A/BBE6J/3h3lJ10?=
 =?us-ascii?Q?cV2YiBL4LEvHQlffEBp2SJXAT/C4R4cP+xQghv/cynsz4NuHkZlO+qvfsUUc?=
 =?us-ascii?Q?NClAnpzDY90YsRW4V2NVUlhfYuZWqFuGRpr8V/Cgy1j+uXR6f7XNApO3KK7p?=
 =?us-ascii?Q?eH02UCnMTB0sHfhUUcUdOX4/Q+DgBa3YHroThDyTR+rWGZKwP5Bhf2nBHDhr?=
 =?us-ascii?Q?Rs5rrqec0Gk+DbixAthYgRZLbpMgTwE0/YQpBXog2rcqhODqjnHBsRK7lJzC?=
 =?us-ascii?Q?2yJ7yDZc+0f/qKjsZqnAK0WPHujv7XYo2UWp3/lziNDHjC38qX12biNN2Tad?=
 =?us-ascii?Q?w8Y1Gm73BSVCEABmN2PS9rhdv6vHTDTprBZafspJVFaNTohfs+frRgiFE64q?=
 =?us-ascii?Q?lMibTX1Yw46Hu7NQBCS0giCGU2YR6U1A94SH08SMifGplUoC83wxmll6l0G4?=
 =?us-ascii?Q?yUJ5LJ5Nd3wl+Kxf9K+MADYJ4zm6HjYVOqpR92KQ9JWX03XlIbpcP7XGpIzR?=
 =?us-ascii?Q?LkQCKHuL5EDHNn++7dahBCLQ/o+9GRRcy+jiNN23SMS46pNau6hpbTcUPp/8?=
 =?us-ascii?Q?2mMqE2HnJj0rcpno8mF4CPKfqLAZBvooij9xsGag8JT3yAAeD3Ki9Xr0qpuu?=
 =?us-ascii?Q?CGLp7kk8agxQvVa5OGsHhDkHgqr1xC00FjDjLeW4sXNTvsYL9+9zoqD/m2Wh?=
 =?us-ascii?Q?cm+OMWUU4AGn9Pbews3Fr2ObEWwJbxLzKZEF7TwjfkZUFOH4Nm9C1xG0jYhB?=
 =?us-ascii?Q?p+AHwezNj22b3mkHdlQ8hEq+IrlYLJCQKlxD/lzUOtjBTD6qictv01VKmuqU?=
 =?us-ascii?Q?PlJygZc8FrZB20pUYVXV0+vnHShqyoXl8kRX4qmhlsXA60a33NFYs2yJKrAi?=
 =?us-ascii?Q?xTeuqrgQ8LEgdt/5eGxH+u67CrapzhF41GUNXB61uPmZ6xyAFrFioJHDHpp1?=
 =?us-ascii?Q?38ibLP8jxDYSVyvidGh5K5PYQgoq8suxmV9o8G9an1YLjp4nVrO6F2JEhV++?=
 =?us-ascii?Q?SNDsYSMXXyUJl0RX6hXhUJzR45tVTBOGRGpxH4kgdEOA18GemR3gycF2PLWh?=
 =?us-ascii?Q?zne/qb/dtjmJC+StQBtZwdoH5rRJWw7VNzcXNpmNBE7cIZvcUPnrz0UpnaHO?=
 =?us-ascii?Q?H4XoCFb85xtC6lJ/96PG3fAR8TZLl56ADPvZukV4C51ahr1AtkvTYZt24AFg?=
 =?us-ascii?Q?RtSh1ZjA2w4LYdp2KaIfrUepNIPqB1ejGA5SCqK4SKh6O4LVbZY51se3Qy7E?=
 =?us-ascii?Q?63bd0eQ5dzGxsEj+Za12fDqkHYigEugJoq6GnLF/CDhvYw7yntu3qcJKuuC4?=
 =?us-ascii?Q?IWKBf6acX2u0KrSw7j7ZXaSapcy9u2WwSfG1va0zOIAdfu8TtkAIjw4TA7VI?=
 =?us-ascii?Q?qXBgkfUGv1pghkc4wbhhO1q7Ggy2VJ2EmIZgAtX+kBG8xKHXk7/2D8L3W7zf?=
 =?us-ascii?Q?YfdVOErxxhL41h95FKPn7hPKFzmptQlknbqLsCn45ZglxnrQcumY14BAckpp?=
 =?us-ascii?Q?44xrOWN0qF1EoGFuIkvsozy/3yNRSZ5DpRFi1Fj+8i3X4caj8RSWuFOJqUPt?=
 =?us-ascii?Q?TpPYMLv+IjQUqFNZ2SZ1MonuXhOT50IRXQsX2Pwz?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef7d6be9-7d4d-489f-33e1-08da764e0b5d
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:18:00.2154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u3Zol1QhWtc0uhg5ksVBIpON9ZpqBLMVpp5Z6BESv9tUI/CuCG/tGhtTur1/8y6L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2358
X-Proofpoint-ORIG-GUID: z8W7dOTHSqoCR1YIe9RdyXYEe3J4XV91
X-Proofpoint-GUID: z8W7dOTHSqoCR1YIe9RdyXYEe3J4XV91
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 04, 2022 at 10:03:58AM -0700, Stanislav Fomichev wrote:
> > I am planning to refactor the bpf_getsockopt also,
> > so trying to avoid adding more dup code at this point
> > while they can directly be read from sk through PTR_TO_BTF_ID.
> >
> > btw, since we are on bpf_getsockopt(), do you still see a usage on
> > bpf_getsockopt() for those 'integer-value' optnames that can be
> > easily read from the sk pointer ?
> 
> Writing is still done via bpf_setsockopt, so having the same interface
> to read the settings seems useful?
Make sense.  It probably will have less surprise to have a
symmetrical optname expectation on set/getsockopt.  It will be
cheaper to add to bpf_getsockopt() anyway once it is cleaned up.
Asking because I just don't have new use case (adding optnames)
to bpf_getsockopt() after the bpf_skc_to_*() helpers were
introduced.

> > > > +           case SO_MARK:
> > > > +                   *optval = sk->sk_mark;
> > > > +                   break;
> > >
> > > SO_MARK should be handled by bpf_getsockopt ?
> > Good point, will remove SO_MARK case.
> >
> > Thanks for the review!
