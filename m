Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2CA578B48
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbiGRTzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbiGRTzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:55:11 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB6D2B250;
        Mon, 18 Jul 2022 12:55:10 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IGi4fL005109;
        Mon, 18 Jul 2022 12:54:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=EGj5aWn2xKRlCo4+vlVJnK82t1lpkCA0wBPqXK583Ak=;
 b=pUvjkng4cavw53EsovouzJAA637tP2x6Attt+ozeAI1+K+TyfY+3u75UJHDSED8MMCAx
 qlIQ/Gf7J+qKjghkvA4YJMVZEQHuEV6WjYuzZ2BCTaChzakb+91/XZ6RAVHaK6BEHfBA
 MtiSwCxsVWm0+XHfwNYX84B3zWALnblwah8= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hcpn66wu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jul 2022 12:54:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lH8aMoUt+3qlX/8980DQVI8TxD6L4fiLN5PQVO1tS52B3YCtB6VdVB8O8MbC9xWYALSAsIqEDIvUFXK8HVAppzAiyZPLnWDXYa/r4fCkMGgQzQDoj0RuiirJMDotGbWl/gsGA60ksPOs/7ZVBYqsrUfZgzDT10Tpz1USvtBi8ORmEhSlNzyYdAuGEuCRwzS61NX/0kAhKQklO5q98m8L+DaffrZu65vlr0e2iIJfrph4aYvtoX0uorN+JM+0gUbhPmgjo8WNtDAW5mLIQkC9CQhXcMvWU08t/S65tjX6TzmL7hc/omX7oG8s1S3VWYIBQdrCvyA1j33opJRBAw3V9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EGj5aWn2xKRlCo4+vlVJnK82t1lpkCA0wBPqXK583Ak=;
 b=k59o2cH3jr+AjT4VLjj+49lOA0fQEHZmN399wOe9BADH8pK7r5sRHY+V1e/Hc9bpg/APfcz8Au0WKir8Gjr0uDeFxHM2vLWxWOjLo2lfJjYTfSU6r73eRlC8adrMSdCCuRz+fx9eM5Gf9P1cy91aVO2RKxp+pSjkP4FhtpuY7fa+XpN6sQ+mJrHLh32e4zO9RbINzj+5VtHIUcgUa/ZAQL3NwzZUY6q2+0qtf+RzAz3zVtpvPwYlb6nA/7x7uLm6hHfAibrJa0t2/3Mx8AoEP40BK4gElJ9dI5QAmzkcK7HjzXbyfcGhegcSz7B2TRTOPKv/zFE8n9VHPFpwCQ0wcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by SA1PR15MB4657.namprd15.prod.outlook.com (2603:10b6:806:19c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 19:54:48 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::a88e:613f:76a7:a5a2]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::a88e:613f:76a7:a5a2%9]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 19:54:48 +0000
Date:   Mon, 18 Jul 2022 12:54:43 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Paul Chaignon <paul@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf v2 0/5] bpf: Allow any source IP in
 bpf_skb_set_tunnel_key
Message-ID: <20220718195443.igbutchwxu55z46d@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1658159533.git.paul@isovalent.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1658159533.git.paul@isovalent.com>
X-ClientProxiedBy: BL1PR13CA0180.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::35) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6985d40-013b-4835-55aa-08da68f75ec7
X-MS-TrafficTypeDiagnostic: SA1PR15MB4657:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2uerVqtA3S3xWIsIVSTXIDxZCG5NLu0qwPWitZRh51f5fwIp7RlbhOqTBewajgh+/5qs4m6VVAx/LmoFq40IMXRFR6vu0AY56aIibY8K/bag3zj8EBy51lEV/1gei0Jh5Q2j+C4HDKwD9Sl9/qtMAfwsEHheU3V7TcR2Av2/i+EFd/HCKT3F42+EAG9iWHLP9cVEDTcMnefpaJnj1Lwb4fFS5RYGug9YiP+v21EmWna55HY0WpsLw2DEUchYn7W0dhgX2Zjpk6ehNTEIWMxayVyGEm008gCMkM9AcKuFqs33E5EamNQ8bspo5m3/Y8zOOd1JxRIOP9SpfLE+XD+qOAdyi23N9b0U5b3X93CvAlZ1OXdxSQm+OkBQl3GWggjaBVLwK4FNkUOSCyg+ao9flENoUTBdKVOVqidgdMh/wvfkxyRfQYnWepP2LL0Fd+vG7XS0UxGHnd7X4dlm6YMDvJ9AMivO91mh/9zLpKNA4SPcyJonRYDTSy8etzyLn4Bth7yaz6hUCJAysGQGTFSG2X9n68R1hSkvO4Jw5e0CrmmWa6Zw9WDrkzPT5o4jVpxpaqiqu+A1h2Z800bf9VCZyPwi3vjxtHvm7sv9SwiL3PVP9+zxP75hDUjqjc/yrK/5LIcOV7bHLOorJ5njPDMfT9QkafZSA38L2RiyI63nRgLXC+0XFT5tAQmHvFaxUYz1RZLsWQiVBc76YmcyhHGFiKCo089m+QTWBXW9qRPVjnY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(4744005)(9686003)(6512007)(2906002)(186003)(6666004)(41300700001)(52116002)(6506007)(8936002)(6486002)(5660300002)(7416002)(478600001)(86362001)(54906003)(6916009)(316002)(38100700002)(66556008)(66476007)(66946007)(1076003)(4326008)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Oz+7yevEv5/HdiLiNb7SvMsczIXNqJZM/LZXZybzj8kBiz3ukYnTUycwPetx?=
 =?us-ascii?Q?IOwIoiF9UpFrY/v/ZVGxHOm1hqLChQzoUzsUCou1E5gMirift+lk9XtJ4NAB?=
 =?us-ascii?Q?HZdUEjis4DDGlC/OOjvaz1OQbx+dmjqgeg5V9U+vKymDF44W6p7yp0hl8gA6?=
 =?us-ascii?Q?f7evjOTxkrqmIz1UD0ceqe5ONoReeul4IICYk2Q5RZnK2uVw907nYtlJh9XI?=
 =?us-ascii?Q?iF67FimZ6+9cj5EJfdshNH6SDSs+38GquY5lfpDMA1KcGI1Z+kBASMBTTF41?=
 =?us-ascii?Q?/WgwzhA4HCmP1UpnQQhUYqBvvq7TCWMrk+sE0uvYh47RtJtKlSJBwXiswNi3?=
 =?us-ascii?Q?NRgyGNoz0EubeURwB5J0PL4usBKnlShyhxrGvSPlqfsUNkAa0fNKMDR26Z6f?=
 =?us-ascii?Q?rQA3iUOBk5lcRqYFFFT7grSbEBKuVCnp1nWvXWE2PeGtSVQwkJGbWtMNmvkc?=
 =?us-ascii?Q?6TF25NhukppEvZOFjRjNqkNlSq2I5DUckWATP02YO80lALAoUjt6RBjbSqKl?=
 =?us-ascii?Q?7cTmpOoOqdU0i0tnHM52qNZ17bk6OHfgywV0IWYgcbFmqhOld+XbRv9/rlRo?=
 =?us-ascii?Q?t9S16igapXraXZFnOTEFbCZ16KsCyoyhjVp5hYMKqvC5XDmGUh8A/7XY1acu?=
 =?us-ascii?Q?B7jDcrfeKTV/9Zt2yVyWauSqcbc3Em/UQdEpduNLf2I0eClpqPyWHYOT1Qmq?=
 =?us-ascii?Q?zMM8ukcyk+qhEtRlrLethH5ACENKpbCl2hDdnibEZaS5Ry2+TjJF49xagX8N?=
 =?us-ascii?Q?IcjBBT8+QCFKNoQ3SdhVTfHUcxt5LVCjvxbgAgR3a5//BBg53MGwXxvx1YL1?=
 =?us-ascii?Q?Q1zwuGAmRV6tqfK/tl+t3WBF/6JbN/0r0O6LZTT1arWq8jQLZo+hJd7y7bnD?=
 =?us-ascii?Q?K0mRlZV/c508NAjLqNSx8Z0Br+UniLNe+sWGGAPEQHXYUIHScFu7V+0AFiXM?=
 =?us-ascii?Q?pK3tusKlSXrueY7XzDEx95SPkHSq/AL3305U7U4hQDf880jsUKb+2Qr0WebQ?=
 =?us-ascii?Q?7VpScUF3zHkSCjXMmWPvNdq8BRU2nBj2kZ7NfMzEE/eU5mmGtJXXE9RC5wc6?=
 =?us-ascii?Q?ef+E1q4ektFGCrhEp2B37PJ8XlIRxUhemb5G7793fxHHG1V8W50IZ7wJ9Pgh?=
 =?us-ascii?Q?x1c0A0W2usVY5jamdaFauZ664HwMl0ONtoHb4D0bvVaJHYQ9pUQyES32Aptx?=
 =?us-ascii?Q?n+dIgxGKRlOH6gE1sjs1/3x4KbGLd2OJosoPv1BJlh35GTE2Vx5zgY2CgAJI?=
 =?us-ascii?Q?qTKX4f8K//6cusqH6wC0A4lCFD50w47NagfOkpk+49iAGK71yGsMOaGMz3Ia?=
 =?us-ascii?Q?H7zHovobEwW/Ha7ok/C1Rn0ntwdmZY4Ij0s+FuT8SL2Q8lCwPjaj4p7RT7dY?=
 =?us-ascii?Q?5Jfduy0+FMxHYnzW9nynU0RV13tm2rKabYPuWF+SgLqk/ooDm96ax0Z6Is2W?=
 =?us-ascii?Q?cVS9NtjdDla+Iv8qRh3TS8GEcc+RwfSLSfSG8wSZazjzE/GYoLzScu9g5dKI?=
 =?us-ascii?Q?ygcNw7KrFvXZlGk1bmReWU41Ox7gZuIf65jk6yMxkVnNyv89IW+ahe5Fudjf?=
 =?us-ascii?Q?TZ2/41iQvvPjf4o0QxppYkqPHZVyUR9gJ1g5i0TSeYBC4k8eZ4RT91VFTLIx?=
 =?us-ascii?Q?lQ=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6985d40-013b-4835-55aa-08da68f75ec7
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 19:54:48.4397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nqntPtDvmGzLsiNS59azBPHC49wHNc1/IijIrve7L2q849YXgezJv/xPMlHzwO7d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4657
X-Proofpoint-GUID: NqWOaTuXoKUEfyIH8dzM3KBilEhB5B2f
X-Proofpoint-ORIG-GUID: NqWOaTuXoKUEfyIH8dzM3KBilEhB5B2f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_18,2022-07-18_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 05:53:48PM +0200, Paul Chaignon wrote:
> Commit 26101f5ab6bd ("bpf: Add source ip in "struct bpf_tunnel_key"")
> added support for getting and setting the outer source IP of encapsulated
> packets via the bpf_skb_{get,set}_tunnel_key BPF helper. This change
> allows BPF programs to set any IP address as the source, including for
> example the IP address of a container running on the same host.
> 
> In that last case, however, the encapsulated packets are dropped when
> looking up the route because the source IP address isn't assigned to any
> interface on the host. To avoid this, we need to set the
> FLOWI_FLAG_ANYSRC flag.
Acked-by: Martin KaFai Lau <kafai@fb.com>
