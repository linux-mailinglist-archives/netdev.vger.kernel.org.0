Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA7A4294A1
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 18:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhJKQcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 12:32:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19856 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232033AbhJKQbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 12:31:55 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19B9DxfM022422;
        Mon, 11 Oct 2021 09:29:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=eBxjwOrWVhjFCG1WOcEx4A/Nn7jB5bvKwWh/zC/S87M=;
 b=q2zdpG21FJgM+40H5ySMc8qbKhV2smAlYY8pgvcs0XWTh6QodZSOaumRVH1t4RnNOHO8
 wNHG7mMHLVV01j3zrCwU8DFzuIjFhIFqkSDHktIYUTJ4RF+/H7MzAPSK5z0PXw3GWcNg
 zmFYQx7Qpfzrvkm/A2MhY5zXAOYynLCU+Bc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bmghfue7n-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Oct 2021 09:29:30 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 11 Oct 2021 09:29:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FZpSS9uRzCOMY8PbIpiP9lFyQizWRycYGNpSuxaI+F39LxAOiJ4J7o0epJDb+IDDXDzbF+oLU2IhkEPDUBX9G39fNU6lcmc0D0O8EE7g6I/rhETgz129SDoXjh6L5N9gW82wLNA464dV/VPz77zQLAoSxAaWQKsTWH+uqEFWdeRA6Fblj1Jg2ARPcBdE3mXgiBUpHbj8gV3z2sZddVNumlDrGoncmBse/aOSFjCTfQvIMdMrmxmG/ZURQ9D+q8JGBZ48GsqNZQtw4BA+onK3QW8RJ8JqyQ24yonzhH8BkHNySZJFOVS7lAfKQfJ4jqaJF06gGpo0qMtiduLzkrEGEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eBxjwOrWVhjFCG1WOcEx4A/Nn7jB5bvKwWh/zC/S87M=;
 b=I+4c7WSTtRETm2wI+EjIn2OjBHatFTQr5Y15vRqzLEHrcFQIvR4Ki1MkkaZraOE1M5OkFYd3+U+fvtb5l5w3J1mFYsl9c6r39nlHhUkmOcURK+Fyv97yVhbGnpAWoav6AtcO7zIFMnk9IVUtZ6ErZQYVlKv5avhJUQ3on43rkUj1czkCZI7Yn9u+W/8NEFuRtfy4a9bQVB6hji9zr3cEuldlZrTv+ucDIKkh84owL3deAg27RGxUsPH3ZFZ7iwjFyf7S/+t06pkJlO6WEm+mSd4wVp6hkUawPdTNYRBWApXMlEhrqfl0bL1buSanTY+r1F8fni7rcxFCYbcU7/GWXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by SJ0PR15MB4648.namprd15.prod.outlook.com (2603:10b6:a03:37d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Mon, 11 Oct
 2021 16:29:27 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::1052:c025:1e48:7f94]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::1052:c025:1e48:7f94%5]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 16:29:27 +0000
Date:   Mon, 11 Oct 2021 09:29:22 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
CC:     <quanyang.wang@windriver.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Message-ID: <YWRmYk4hHhPf602i@carbon.dhcp.thefacebook.com>
References: <20211007121603.1484881-1-quanyang.wang@windriver.com>
 <20211011162128.GC61605@blackbody.suse.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211011162128.GC61605@blackbody.suse.cz>
X-ClientProxiedBy: MWHPR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:300:117::22) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:b876) by MWHPR03CA0012.namprd03.prod.outlook.com (2603:10b6:300:117::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Mon, 11 Oct 2021 16:29:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95830cc2-15c1-4296-df51-08d98cd44ada
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4648:
X-Microsoft-Antispam-PRVS: <SJ0PR15MB46483B839997233529F6F843BEB59@SJ0PR15MB4648.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +SRfDzOTF0RULvfFFoTh+X1NSlWknI6Hd+Oo+LXGhNmwdOnH5kr1DAnSR4PrOIWgtNBqiSc0rUt+f5wWtcXog2WssdlYX7uMnClMTkE1+jhm2FPk1lIq3jlFVZ2x99DtZcEeFdJqZNqpHFc7BIw+JyinhULTXTEXziYr4QhmaNLA46MsUeqhHvGPQKc/aCZYZV00o+zBb8zHO0O9eM8VpaqHDlhZ6R0NRbWB54jQAQADiziGWJG5qDM5GdGLhWZNutlq+Zx03NSGTxOSg1nlqG+tzi4EEE1/vyTCj0UtowK+25MOjGrE6+hhxnPKzYXbOZ+UCvBUAbaHjWyRt8LUDbuQs8wtl7UKCUmrcBbhR2JFc0D/z6GYgXrHk4OETyhMo+Mok3IRufcTMXA85vV+Hw4FnWv6zump7uyXH/JvLIVquG0Tb+QsbeL/zpBP8vp8523MGgMg0JaOdefuPR2UkIRw8vlzQ7WauUhY6n4ZfuSKJU5xP5tVBI4/STYJReL50q5QUxUrnQD2fDdUl2jEGZ1qWIOn3KQD1rk0Sb1nCoO2qtzCpO3lRzaS2+Q/VnReLxJDbi6cKDoASKDHVVExbKdiT5sjuBMPMSbSl9tImCr0CJzM/v8xdQvWiWiRHGf83rVLd9n9shu1O74U47DOHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(6666004)(5660300002)(66556008)(66476007)(66946007)(54906003)(6916009)(2906002)(508600001)(8936002)(38100700002)(55016002)(9686003)(186003)(86362001)(7696005)(316002)(8676002)(7416002)(52116002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mvd3SZBT185Ai38aYGdApm8aiPTeJ1jDTNi/3Bib97LLN9kwAIDrkrT1um9L?=
 =?us-ascii?Q?GU+o5kogdqq7NHaH7nI7sqnCgQHzGOUAlkRz3Zmx2wgjloKHSWZx06JZ3oXP?=
 =?us-ascii?Q?fznWdGszxG/brKKP9FTuFNoq+ebDt8wZEo1EliL2pe8ZdQ28GXY8vlgZ03/5?=
 =?us-ascii?Q?GtedsNFdcVeZiGM0RrRo5gDQUNVzaoJ2gzPoTtMKfbbPZxvHlPIlnssUGWT7?=
 =?us-ascii?Q?GRSWZGwnU2Ef2y9B+sFhIAre8mQaBUWLkiex6pPmqhi01IcdfYjFs2Pm3q4s?=
 =?us-ascii?Q?K+b0GW2TTgngdoAm4QihaAWPIzxuB+W0djCsQyFJ+oNdbtHGzr7mc5FdTXGl?=
 =?us-ascii?Q?56jz2dRMZdKJINyrXa91AdN1DL+KJKE7CZrQaOhIptXWNAdEYDKIxIxKdoiv?=
 =?us-ascii?Q?b4NaNAzgv4VpjORxhNRfFsuPHLPzQzrUPB7vL9aqkNOmAPh4XEvNcwGV4C22?=
 =?us-ascii?Q?7QpKJf5BUddMz+wSRHfMyPsVBg7JnVzKJHyHV53q9LmZZ5EgpNQQ4cG1qbs8?=
 =?us-ascii?Q?xws0h6n4a1KIa75kpnXs7hy5S26JwMgMk6BgO1k7gzdnjzc1xcTQt8CUwCZo?=
 =?us-ascii?Q?7hwwovkRnSHgNbw9GqntQtg4pU+eFXiOQHd1dMkEqYTMK75V2+W1kT4bHeg4?=
 =?us-ascii?Q?TPh5VL6ychJFYTlh0zVtofc8TWPoTSJneAoS+mpm+fj2OKDhEK2eA7jaNDoR?=
 =?us-ascii?Q?pXvbbGQmdz4CTCirUgiv7tnRwMCYifhXgLLDA/zw03gTiMUPrvxCYXzPgKur?=
 =?us-ascii?Q?UbHu4Z8CK1qq2XhQT6RkFZoOOS8TJSnJUdl3V/TqAQaWDqyBRhnEsWTnv2Nx?=
 =?us-ascii?Q?qKRLzkllcVPeRkxRZp0UfjKpktbs9SwM+JzcODYPYC4JaWpjl98jOoyJo0sZ?=
 =?us-ascii?Q?lBFL7fwwwJrBtBFFeP/pRROINw37B7T3rrGqAXZy8v8LMhIx4yAJVuMcDVOS?=
 =?us-ascii?Q?zU9dTqj9XcPC49axT/7lyKkYgbyaiWjuezVd7ke7xiJZ8vbBN89tIUl6TT8A?=
 =?us-ascii?Q?VOystm9su+H+4n/3U25KYWssIH17LKjOyj4WL65JhfIT/ERCJwDGDEEMhzTT?=
 =?us-ascii?Q?5VydaMmgoVoloUhq94AQpcqQyf+vgFlW7T9S+DEJgwKyP7tY1OhV6gZ+qSrb?=
 =?us-ascii?Q?POyLwlYdsou8pIWt+MBFHC3GBRXrz/pMh7PuaFTTBS+e4OHBJJjDXTgXonxK?=
 =?us-ascii?Q?OXM/5CthR1dcRt9aJYWf0qfBF+w8To/oBSyVKBMTwLeK/qKTD+k7rRp5tjaw?=
 =?us-ascii?Q?RLnO/nTE/7K5mxQt3Z9QwqudHRGHAsTvg82CeOWnzoJ2JwBNYGiqVu0ujm6D?=
 =?us-ascii?Q?vO9YS26G4wCFg3H1KplVQZBirAROTFZupZq48Ii4wnRZWQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95830cc2-15c1-4296-df51-08d98cd44ada
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 16:29:26.8188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hPceonMP9ZaS5EAUbKOp6cyafPXedJcOWOVFSs1vuuDpa4fGel9bkgzrpPTOc4LI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4648
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: tFoJpr9sMfw-1e2EpNa-X1akoTLX73X2
X-Proofpoint-ORIG-GUID: tFoJpr9sMfw-1e2EpNa-X1akoTLX73X2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-11_05,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 clxscore=1011 spamscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110097
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 06:21:28PM +0200, Michal Koutny wrote:
> Hello.
> 
> On Thu, Oct 07, 2021 at 08:16:03PM +0800, quanyang.wang@windriver.com wrote:
> > This is because that root_cgrp->bpf.refcnt.data is allocated by the
> > function percpu_ref_init in cgroup_bpf_inherit which is called by
> > cgroup_setup_root when mounting, but not freed along with root_cgrp
> > when umounting.
> 
> Good catch!

+1

> 
> > Adding cgroup_bpf_offline which calls percpu_ref_kill to
> > cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in umount path.
> 
> That is sensible.
> 
> > Fixes: 2b0d3d3e4fcfb ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
> 
> Why this Fixes:? Is the leak absent before the percpu_ref refactoring?

I agree, the "fixes" tag looks dubious to me.

> I guess the embedded data are free'd together with cgroup. Makes me
> wonder why struct cgroup_bpf has a separate percpu_ref counter from
> struct cgroup...

This is because a cgroup can stay a long time (sometimes effectively forever)
in a dying state, so we want to release bpf structures earlier.

Thanks!
