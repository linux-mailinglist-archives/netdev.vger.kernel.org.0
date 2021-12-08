Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762F546DD45
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbhLHUwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:52:12 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5890 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232827AbhLHUwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 15:52:11 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1B8GegZR030658;
        Wed, 8 Dec 2021 12:48:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=DM9VSO/qcOi3lN1QT1rYuFI5TOfqIcCPGW4AMEwmRK0=;
 b=EMuaMofr5I8Tij4/9Bv9QhpQBogG8iWASc/pnAoOz957jDZNtzfHjbGFGdXkEAHYlr02
 gaXNqgUYbFVNrv5Tt5zqQKUB9c1rB9Qrln92iORQG/1EseOPKCH+x4JBKP7csExhveZr
 s1lcEjP7FEwj0xqhaJr7ktpPQILk2Pb//Tw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3cu0ed1q02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 08 Dec 2021 12:48:23 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 12:48:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hm9Z0tg+qBLapOQ6uPBqE/Fj5dy/xcGY2Ibj8px2PufmZORd0Fy49pE5ZI2G5mIZpi2ZLjn7ZYo87y5Mb+JG/hlEUjNL14HFnl1ioNM5FBrvvJhZUrnH9I9yS4eAaK3xDc6DkNluObVd+h/inv/AiSuY1pwok0iXKSC63z4ptu125hrHPOTbgp6scsyCRfkjYQ/AARVHy6hW3OTCxGFCH65WBHedUBKjjzoTzsGGH66jrGYzxRbpYCTeluBHullW/za6a9jxEK7KcJiIGGduIHv+I+d8ltfw9vPJ840HFglewaf4zTReDrAzv/m4SnvIJifRXyAaHmgXtzx77IO1bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DM9VSO/qcOi3lN1QT1rYuFI5TOfqIcCPGW4AMEwmRK0=;
 b=Iob5+liTzlsi4xA5TZ+7R+YZEcjc7nP96kPWjSp8wochZBIZGY1rFjbbGgjBEcsXubOEydVo+PzJ4l9hy90er8niNqZHBKtooSYMIKqHdhpCPrPXWON8busUSkMOzjlSan9vo76CYEgUSwwPmAgGaBGJjgVjebrNe7f0fElbG+GZcaY0fX037p2Dzlii3Va7zrox3W6XE1L9PFEQpjmwxYzYspXCHjCPYpQF+yZjOtB0rIhTh/u09StLspI2JnQ2jWiIwuQ3NUpOWHrysgPEjJEy5TzulfUOQ//Oo5vgYcxY7MpJjzjoNZz+3883dtB5q1tISYalM2m+9zfxY4CyNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4370.namprd15.prod.outlook.com (2603:10b6:806:191::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Wed, 8 Dec
 2021 20:48:20 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 20:48:20 +0000
Date:   Wed, 8 Dec 2021 12:48:16 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <Kernel-team@fb.com>
Subject: Re: [RFC PATCH net-next 2/2] net: Reset forwarded skb->tstamp before
 delivering to user space
Message-ID: <20211208204816.tvwckytomjuei2fz@kafai-mbp.dhcp.thefacebook.com>
References: <20211207020102.3690724-1-kafai@fb.com>
 <20211207020108.3691229-1-kafai@fb.com>
 <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com>
 <83ff2f64-42b8-60ed-965a-810b4ec69f8d@iogearbox.net>
 <20211208081842.p46p5ye2lecgqvd2@kafai-mbp.dhcp.thefacebook.com>
 <20211208083013.zqeipdfprcdr3ntn@kafai-mbp.dhcp.thefacebook.com>
 <CANn89iLXjnDZunHx04UUGQFLxWhq52HhdhcPiKiJW4mkLaLbOA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CANn89iLXjnDZunHx04UUGQFLxWhq52HhdhcPiKiJW4mkLaLbOA@mail.gmail.com>
X-ClientProxiedBy: CO2PR04CA0135.namprd04.prod.outlook.com (2603:10b6:104::13)
 To SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:5f6e) by CO2PR04CA0135.namprd04.prod.outlook.com (2603:10b6:104::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19 via Frontend Transport; Wed, 8 Dec 2021 20:48:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8793d554-2e2c-4b38-a462-08d9ba8c11a1
X-MS-TrafficTypeDiagnostic: SA1PR15MB4370:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB4370A9BADAC420DD9C06DCEDD56F9@SA1PR15MB4370.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gdU+Lrs+bJo/YCXpmz4Wdb4n7khW11Nw+7eU//m4Z6i65zGOQEyvCtH+yvqTJgaRqmhyoQTgoHQpacxO0ukH/GMOgh0L7v3v7oN9lXymNvAoOLQ8mP34zXF53NCEJtuTGBLniJbgG2qutT/jRnmagkrTiDmyVEAhi2bIKSPHJr99jIExKYWc3NmLqIyltEP5mg4qNSjsMo/3HD9VTp+PwKR0xUxBqDhK8LOhMXLc/WOuxfvWsQYwqc1EJhXeZVi0rgzOHuz2ChDZW55Q19bqz4wBMtFegho3PDsoEWkjhObWSFvnYwXG1izrO8PlaAvTeO8+6mO+NXdkRRpP824reYtwfbM4uFnNNNzFzpskJfL0TYAOVrILxuWW+Lt5symx6p8hlZPI85Jkqe03ZEYj3uT/sv1kJr0zzqzcu+T5VZSdrxtvg0D9d0rjM1oQRsFpTaQjmA8rnhex8Q+qt3SFxzBydhQe07R3lO3K32IdUBMXvTFP+eEYQL8mW59pJYN1JMvSwPcqtTOPMsJ8Ot142KB8gPogGTYZj0Y1FKpqJhJAkS8lkWtlaCZly2hvSflMsX1goL4eyGSK5r0g0NbmDdNg6w/ICRx3xRIl/YtTKNj1k1yLKjFq4Sj5rNE4ixF25oY8gO84mSLCMqYD2/K6WQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(508600001)(2906002)(38100700002)(9686003)(54906003)(86362001)(8676002)(4744005)(6666004)(316002)(8936002)(1076003)(66946007)(7696005)(6916009)(53546011)(6506007)(66476007)(66556008)(52116002)(4326008)(55016003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z032JTeFRqM5Hw+HskjO0C+Z2bSX6u0vtEohLTt+dJ50H5JlWtSNRwCXUpfS?=
 =?us-ascii?Q?gWB77hVcFaL/hp3MgpUHki8RPRkwgbShosjndPGw6rjRd2GJRzoICG7rhcVf?=
 =?us-ascii?Q?Zih/WAT1Mk2PZf7cFnN5unj9RyODgTa730FyIqTwupExobyRym8P1f+bogFp?=
 =?us-ascii?Q?pm7X0MvMP4QAqCuA8FeNaSYT1fEmzi0qXckOYl6O272i1UIiI+nA8030NtXq?=
 =?us-ascii?Q?GNBsu86zyFz/fiIwgtYhWmwzThD3RUGnRtLpdPPQv6hRBa7QXs/877VuQvh6?=
 =?us-ascii?Q?oCme+ivIiAJukfMiuEboO3BTmXJtajAIJNTZ05sfeZSP8Jx+xtUoKIg2Bw3/?=
 =?us-ascii?Q?WardW0U3oUnFzfxFZyFDB6l+nIF283ZdmMKEVhmv91wkIqkjPYDnvk/b3GXU?=
 =?us-ascii?Q?SZHCyRfr1CdSnjibn+MAvvIFQkpB1kc4oFBvLs8lmoEURCE6EKmijwWRXQJG?=
 =?us-ascii?Q?lbfEJYqG5mowghHHo2lhbAFhLDRay28jmlIT4WlGyzqTwhaIWaJyOzcV+x7f?=
 =?us-ascii?Q?AH4fazM0Usgk6kmfNj7QS9rWz2R4KRs/QFvgKn7H5mOvqwU259sAcdGe2qFN?=
 =?us-ascii?Q?U/q4kFwoFvrtOh/mCb06FRdf2ooXHdlgPNn4Zj+6nBKiHLX6kmZAn+j2EggR?=
 =?us-ascii?Q?gnC/vfLsaQYcmDwtwBoPZp0OCr3h1bqB5jLskYPLb0bbJ8Vb/Vu0jSHojrna?=
 =?us-ascii?Q?3i2TPktUJx0XzvkR21TU088g//NLYmwVZCJVTHnJlaI1fAQNoWzJv+xpib2K?=
 =?us-ascii?Q?t9+nIv170W7yxUsp64Ur9e8+K5Wx2T26Nkxi4hN9bh6GUH1AEZ20J+mlczQS?=
 =?us-ascii?Q?Zpn26B0fjNNxoivaxMV4FqJ/HAToVm9HS7ezUL/W+AIs+yf5/x7Rvvt2RIip?=
 =?us-ascii?Q?3yg1m0Uda9tu5DR+mYLqjkiOq3lBtrsOUoDXK01oudprIvPb/wqQTTUqhiIv?=
 =?us-ascii?Q?4Ft8vsDpWWDpdJwEoYmQ1D4ek2+lX8rq02zsS48wDUSeEcxHfd93r53BnPCo?=
 =?us-ascii?Q?mNAVbdGNNKI7R5wYekQdKx2ZEXRix1S982SuaEasPi8Dqg2DibhC/dhEty26?=
 =?us-ascii?Q?FXtoqoLAZVsXHRvMlhgSWeLIWe7kFUJu3JTINPJXQaNHWhefTe0egnwOgKlf?=
 =?us-ascii?Q?GFqQ/SVIe3yPedKpiRcUnd7MnJeHGJ79S0VJNobdZe1Y7ppUoQa8d3CS4FEY?=
 =?us-ascii?Q?hsRCBj6sldVn4rW5sk+aCx8ckEcW7IVmpxGzreDy65s7DfCJptJj/ZheiClK?=
 =?us-ascii?Q?5RnCzHHmB//8CXADjynSITvFFeJ6m90FzlmPyLZ3KidmtAwvcZyPcGoRCttF?=
 =?us-ascii?Q?GR4++oNSVkO8OtTXAvGwaX8S8d2sOHz54Ab9FJmbxTP+vjkodv+bHLU8o3o5?=
 =?us-ascii?Q?atAxIkmPx+JHB1tg8nY3NOwjVc/FepzN+ZnxbXwwBXf1SIMkCa/6MbPUBJpi?=
 =?us-ascii?Q?1XT2w1GaqY9RCDW+ix2W3URiojbtMzxYrUX/uYaFjRF74+BLgeyGI+tsdIYn?=
 =?us-ascii?Q?xc7FYCQYoHo8ucbyPDBqoZBP8DDxECwEtnOe7Nv3PL3hJ+CwtCeurx7MPxGZ?=
 =?us-ascii?Q?rxkKApT80676arC8aoVHwG4zpyhAXzr5rYkxbYz5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8793d554-2e2c-4b38-a462-08d9ba8c11a1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 20:48:20.7851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M+700g/wsk6Pa82Ut1D2lAT3AOBQzkPEAR4bqMNTiVGxf8IFLw+0xcxEz/rMXhgx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4370
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: yUnXy1kJZK0ozs8ox7SeUJzf8Fz1B3Bm
X-Proofpoint-GUID: yUnXy1kJZK0ozs8ox7SeUJzf8Fz1B3Bm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_08,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1015
 mlxscore=0 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=378
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112080113
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 10:27:51AM -0800, Eric Dumazet wrote:
> On Wed, Dec 8, 2021 at 12:30 AM Martin KaFai Lau <kafai@fb.com> wrote:
> 
> > For non bpf ingress, hmmm.... yeah, not sure if it is indeed an issue :/
> > may be save the tx tstamp first and then temporarily restamp with __net_timestamp()
> 
> Martin, have you looked at time namespaces (CLONE_NEWTIME) ?
> 
> Perhaps we need to have more than one bit to describe time bases.
My noob understanding is it only affects the time returning
to the user in the syscall.  Could you explain how that
may affect the time in skb->tstamp?
