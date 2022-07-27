Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA175832E4
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 21:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbiG0TGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 15:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbiG0TGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 15:06:35 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612A752E71;
        Wed, 27 Jul 2022 11:37:46 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26RBlcBC026350;
        Wed, 27 Jul 2022 11:37:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=civvcPvljPYwtK7rw4I0LMP4KIc2AdTXYzxhR41kLqM=;
 b=qPplrtdnF0DbQtVRe6lijd+8VQxzppZuY+kVVSisXtLrqGqdJtT4MzBvTNZErYmLURkb
 Cv2dSrnlu0CU6dc++Eqsnm37vqPLKaroNlL/2hGiV5xTRJb4hpNBXs93YTn1s8osvKno
 g5gqnyJN9adjCbovR1+C4/hXcxweteORvzE= 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hk4stuhnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 11:37:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K8QMs8v/0Q8FOYGe6hA/ASq1LEkb77yhWb0ydBejUMBY+VZr4ukmF8JZeThBtCbGGVuYfdVpjw4Ei9bS7Fwbl/MWgk+4b0Obf/eeHnCOKau9FQ+jIx48PLn53qqeDccdd+bsdiSM/Kh+ga14E2eVteO9Tjig7P0mHq3IgEtbh4fqQOeVkYKrdLQJrAqjeVIy8MlGkY96qHncTNEBCHr+wMxdWXI8wOIZrPoLzADdHmWawhrGY2LcCjf2DwDuYn56xoiWBVE0KwFmCu5y05uua870a3FTk/mva4JzyREatRHdHht5Vj4B7e7zL17tPjhOjfX9yii2lGTa9e5BgDlWaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=civvcPvljPYwtK7rw4I0LMP4KIc2AdTXYzxhR41kLqM=;
 b=PNLwAkqj+VSvCwxqSkbYZuy3AxYqONIfel0pNrYpmDjiOQLub2xtX0n+bcoVJiTNAq0+NPJPLgzgcKp6ltpmKVUrJt/GEZSXCZpxoQ0HZhouf/XMyXCQqFnfIyygyzKSR+VXDwv4BGoDIXFlZ8CySHAHaYfcMrg/iXjvwDMZxPokAKdUJTHJcfTA4wnOCH/EjXlFfV85Iohrzj6bS1zq2xTh24o2B7TF6wISg7kFccw2wxaB4DhrnqwNGGRt62iOSotfuv9ScoOSzvAZM8mCFtUX8nECYEQWs3nk1VtUuN9iPsaZYe9exLxMJax+6ZZb3tXYX1y1TxLG19sUVxa4lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by CY4PR15MB1479.namprd15.prod.outlook.com (2603:10b6:903:100::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Wed, 27 Jul
 2022 18:37:03 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a%6]) with mapi id 15.20.5482.010; Wed, 27 Jul 2022
 18:37:03 +0000
Date:   Wed, 27 Jul 2022 11:37:00 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     sdf@google.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH bpf-next 02/14] bpf: net: Avoid sock_setsockopt() taking
 sk lock when called from bpf
Message-ID: <20220727183700.iczavo77o6ubxbwm@kafai-mbp.dhcp.thefacebook.com>
References: <20220727060856.2370358-1-kafai@fb.com>
 <20220727060909.2371812-1-kafai@fb.com>
 <YuFsHaTIu7dTzotG@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuFsHaTIu7dTzotG@google.com>
X-ClientProxiedBy: SJ0PR13CA0134.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::19) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb181f6b-0287-4c59-a4fc-08da6ffeffd4
X-MS-TrafficTypeDiagnostic: CY4PR15MB1479:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: emvPEuHscszqObNA5PJJMJRTJ9MCqklEKj2BpjnfB2RxgiobE7wYO5iq6ruQxY9smDIjlPf6kq8NwhVjNoL2QUvuKdTotKs2aV6cql74pMvyiPH3S5PBRpqo2acQrRxMrR+S0OLoSS28RRqsgh3r9BQb5HxbKy6sCWNUWNT0VLPuLpZNS0vNtzdUz1reZe1FFc3Ftu+r6OfSlv3bdBrBMQxa0iM3gfo7KmSuiI01A6RHhknNR8/m/zCQuU+5Li9K+m7Bd4LvzxcOk+1f4LxQd9cTFlByVNrLI4JAnG5zA5U+40IQvoaN1+JX/k+URcztwLeOWHUuW3Z9yRXb1LPLJE3mhayohe5oPpcdlI3gkzarye1/U5BLc4hHrqAMsM/ClfWWBRPlYfE+nV3wINJUCjkaFbY+I6a2C/zHEjJPL71uEmahMvMCQ71ozmDEVdcA0EjyoE2VmxsygGc5pwYDCVu3aU1AnYLqvUXlCnQjTgftMsYMAQ/rDA9CCO+kidT/q/NXA/MATdqaVqDXwSuVMDnPxFaONf4stu0KY8PpP8TU9lTQuuzFs3ImTfPHADCrFYc3UGSHORnT5iTGccoXDHSpCsDZMOM/RAdolyCLQE9RldYzygRThNIEzH6g7Dox1o0+NFz6HRr1MXqQQZVQ3Sk8gUF1onnZzL4mX41qlL9urFMV+GA2QssB3c8nyXCRSLQHGwOrbw3BHwZR3fvsLuTSc5HWoyJIf5ZJJppJPMDdcvrg4SFJSDSULGrRXZBX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(38100700002)(6916009)(1076003)(8936002)(7416002)(186003)(86362001)(66556008)(5660300002)(66476007)(8676002)(6512007)(478600001)(83380400001)(66946007)(6486002)(9686003)(2906002)(41300700001)(4326008)(316002)(54906003)(6506007)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nSw2xa/2H4r89xzcEqWGRVkbbIc3+c+EerzdBq02y7R8jOica+SC945pzUA8?=
 =?us-ascii?Q?dwp3ijb5y+jRYXp9SEOk4lmUoGqkMMEW44NdHGCHAspz7wu14Hk6hCvPljky?=
 =?us-ascii?Q?UPFXDWEal4zMbW074IkRngOqHFfJVUD26w+7RfVvUGJtDxE6cxdaEJdevd66?=
 =?us-ascii?Q?PJg/SJPR6iUsUJlNbNMuH1bNG4bH2TjeT8+410AJzI6k1NcDmppidTvQNeuN?=
 =?us-ascii?Q?FnSWP1HTYoLcWIbNC8a835OZqaSiICAJ/fXs7lexYPpUd4ish32qOPfak3Qx?=
 =?us-ascii?Q?H9fdzj0BZVdIa0VMjmQGVv6oSXiUX9xHB/5qqN9CH/GEqNfkezZ+43aFIxum?=
 =?us-ascii?Q?swBqDZIrBkZif6B7Sn4jT9XK6r+0a52rTWlO91lVXKktUKHwDmgWUUqNNKqn?=
 =?us-ascii?Q?8aIV264hPtLQjM4wtW1wAItVBCfGC0/f+JyuJgkfPftoMoBMOj6ydsAb0Lj5?=
 =?us-ascii?Q?GfUg9JZai1H1H3ckn9u6oqattjmy3UAVeuHXBPxkVOJFBooRPT9CF4ZSqYF3?=
 =?us-ascii?Q?Vt6a1p7KS9SxmB1hqbE+noSzRuE3+JxxOfgEkKQhEAmRJuEalWBbNwZsXX9I?=
 =?us-ascii?Q?0tbgkL9/UQjakLzTMn1ich+VW6qvWF6QiKS3RID4FAlz0SjTKGKfG7nHj3Ar?=
 =?us-ascii?Q?hX302A1n7YijYCjCdNnfTQWjVCGiR4myRLvmPau2Y9ooO2pWGvNvuR/Q9ENV?=
 =?us-ascii?Q?RO53Be/EjLxPbucoQt2UX3tL1p9RgpH6Ax+WFrZrPvo90TVnmzGv8G5vFc7N?=
 =?us-ascii?Q?qgnVQ5Dr+cA1p/y7D4AuioLYFhyxy83cgrdIY2hT6HBO4QHLRXDo6bqyFZAp?=
 =?us-ascii?Q?48wje9fsVj2oU1TD32oL4o1inbR/WGHdC1tGOcSDc75D5vG8Z/6rp8JvxoO5?=
 =?us-ascii?Q?tM/9t1RnrPHsPNXM0Jk9oW93ffQi5tynD0gq9pILjXah6BkL5uHzn5Dlf2mo?=
 =?us-ascii?Q?4R79d6HmJCyDRSmLkxZ4kBSudwAC7ymSt75Q6wg0JLL4rThOd8rj/8JkmOUS?=
 =?us-ascii?Q?M2Vn7dKd8uNQxO2BZH0GifnIs8L3HkXJ8Q44pqljPlu1YQb8lv7gePWFyAu+?=
 =?us-ascii?Q?SevaFHaElktL0yGYXirhGMXVLjb5U1dWXz8HPXYjroAfYAnkXIEx8iVSIR6P?=
 =?us-ascii?Q?rNzLCMmZ7YntXM5XnRbDhdGzmqD/VbVv1iybFaQg2KsE90BTn0GStobn//EH?=
 =?us-ascii?Q?SetSFwULV5SLWuB4VHaI/Tcjr0FKNKeCJYHolJiyP/ocpnx2Ux8vpfvKkcRl?=
 =?us-ascii?Q?pCqBnqSDmpR85XcKz9JN/0Pd+2ytES5N9Zi0MFPbVLX6aNfBsAp30bFNqb5l?=
 =?us-ascii?Q?XYAWy/52MvIFeu0G/vRVh9n1zK6t3d5cksbIBg4kSMpgnkTemtPcY5TiPgw8?=
 =?us-ascii?Q?A75LdSyz+IT41wfRwuKiagXgPQgcHl82VuFsYWibdJ7nUnllHc8rb9xYmpjb?=
 =?us-ascii?Q?8UCj+1SAC1g9bftqy0i0e3ATvIWfHBIIJz6Dj9REHs++I8dYxekBUv3Mz5c0?=
 =?us-ascii?Q?rLowLOQBNRx6ygImkwCo0/yVGXemxsXXYctR/9HYTep5/LHS7OQyNGhUsQyf?=
 =?us-ascii?Q?nYph+SOkM9/OU3/RkrlBz3rgRX7gHZTQ+Gs3h4pJwrb+B/MW09DA7DMDDBv4?=
 =?us-ascii?Q?Dg=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb181f6b-0287-4c59-a4fc-08da6ffeffd4
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 18:37:03.3348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: on8UC3tScqRJGYAw8iKrad53RWnAXshn0dE8qq32cn9jwds+lQNhOBWLO4EXa6vP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1479
X-Proofpoint-ORIG-GUID: QdRiz0F2c52juRU7HNctsjrvqhAoh8Hy
X-Proofpoint-GUID: QdRiz0F2c52juRU7HNctsjrvqhAoh8Hy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-27_08,2022-07-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 09:47:25AM -0700, sdf@google.com wrote:
> On 07/26, Martin KaFai Lau wrote:
> > Most of the codes in bpf_setsockopt(SOL_SOCKET) are duplicated from
> > the sock_setsockopt().  The number of supported options are
> > increasing ever and so as the duplicated codes.
> 
> > One issue in reusing sock_setsockopt() is that the bpf prog
> > has already acquired the sk lock.  sockptr_t is useful to handle this.
> > sockptr_t already has a bit 'is_kernel' to handle the kernel-or-user
> > memory copy.  This patch adds a 'is_bpf' bit to tell if sk locking
> > has already been ensured by the bpf prog.
> 
> Why not explicitly call it is_locked/is_unlocked? I'm assuming, at some
> point,
is_locked was my initial attempt.  The bpf_setsockopt() also skips
the ns_capable() check, like in patch 3.  I ended up using
one is_bpf bit here to do both.

> we can have code paths in bpf where the socket has been already locked by
> the stack?
hmm... You meant the opposite, like the bpf hook does not have the
lock pre-acquired before the bpf prog gets run and sock_setsockopt()
should do lock_sock() as usual?

I was thinking a likely situation is a bpf 'sleepable' hook does not
have the lock pre-acquired.  In that case, the bpf_setsockopt() could
always acquire the lock first but it may turn out to be too
pessmissitic for the future bpf_[G]etsockopt() refactoring.

or we could do this 'bit' break up (into one is_locked bit
for locked and one is_bpf to skip-capable-check).  I was waiting until a real
need comes up instead of having both bits always true now.  I don't mind to
add is_locked now since the bpf_lsm_cgroup may come to sleepable soon.
I can do this in the next spin.
