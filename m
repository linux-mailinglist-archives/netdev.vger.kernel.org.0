Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A48843A63E
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 23:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhJYV5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 17:57:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10222 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231258AbhJYV5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 17:57:43 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PLdbpj015234;
        Mon, 25 Oct 2021 14:55:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=CueM+OuNUjHJRPMmnKhqdmj58ljr0pkdLdWd5+rRhEA=;
 b=UE+8BVnZZwJenW9jiHJXlhey3tOCgJc3Uj36xLiojWjivKlI6V3kFFCn/Af+dlKL5Rbn
 RXQhmEvZuUYTQhiG7ZB7ZwA+bNGQb+TnmPBvDwcfYATYjV16JGiAyGJFuvDuCh1NrrNW
 +TMjBxlFzekQwZNHoB+uELzrxylcDP5XVwc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bx4e8g6na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 25 Oct 2021 14:55:17 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 25 Oct 2021 14:55:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PxusTyq0vVcLeyrwdANqSMHMxDOSO8ovv/qhEtIRhUqukElyCqGa3QuB2bNIfmGtgynASrLvRjMb8AzEUzNEj+XKoFkm6lV7gRc6hOZK7EeKW6HSiTMiAQeTQzvEy075ROW6riBVFp+Sb2vBj1A/Sxr2OFrcU4W0VL9FjngNtpDEAnm/sgZxvyLu6eIIS0VUbKUmEX2JhH1c2yi6UwnB0T0rSSQPCm+Jtb4dyBvFBJHpwhJWH0mOVRbgyMYPCWI/booa9pz5vC+2rND7lvl/BybP0h62r8cJ6rpeDePeqn9+vtJHJ7vTntFFNPfT27mBiRRyqXpiM/wxkahLp66b+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CueM+OuNUjHJRPMmnKhqdmj58ljr0pkdLdWd5+rRhEA=;
 b=K8Mz7joWxf9J6N0/7DIVfAMvIFhpj2V6u/W1oNQT4FsXD26i8N6qVIPdb5Udm9J8SAd3yybf06wVxsgvsiij8hluYbFEqNP7lPYgZod7G4BtJ+i2FxYDmGOohgGQixZkcV6PgwiG8Y0qV9QemoDHwsKwApZ1tyxC8eP+BUUBkRaZjiRsorVzhQOGNwdP4QUsHWJhAQRr0USK0leG7BkXNsHIA43q2Oaj6FeMfYGraB1yX/CGNLiErUOMXFveHYpnNCpSuZmDu1gP6A32qI1dwaFPemZhBYdWk/3cDWQBbxo9XzwUIDFf4Ulx6pwEWmJuumvvtsPtgxpPGELhwuONwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4569.namprd15.prod.outlook.com (2603:10b6:806:198::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Mon, 25 Oct
 2021 21:55:16 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%7]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 21:55:16 +0000
Date:   Mon, 25 Oct 2021 14:55:11 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Azimov <mitradir@yandex-team.ru>
CC:     <zeil@yandex-team.ru>, Lawrence Brakmo <brakmo@fb.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>,
        <netdev@vger.kernel.org>, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH] tcp: Use BPF timeout setting for SYN ACK RTO
Message-ID: <20211025215511.mv2bitcvwhriefw2@kafai-mbp.dhcp.thefacebook.com>
References: <20211025121253.8643-1-hmukos@yandex-team.ru>
 <b8700d59-d533-71ee-f8c3-b7f0906debc5@gmail.com>
 <6178131635190015@myt6-af0b0b987ed8.qloud-c.yandex.net>
 <87d9c47b-1797-3f9a-9707-48d2b398dba3@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87d9c47b-1797-3f9a-9707-48d2b398dba3@gmail.com>
X-ClientProxiedBy: MW2PR2101CA0035.namprd21.prod.outlook.com
 (2603:10b6:302:1::48) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:a892) by MW2PR2101CA0035.namprd21.prod.outlook.com (2603:10b6:302:1::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.2 via Frontend Transport; Mon, 25 Oct 2021 21:55:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6b30a3d-aae3-4715-706b-08d9980220ec
X-MS-TrafficTypeDiagnostic: SA1PR15MB4569:
X-Microsoft-Antispam-PRVS: <SA1PR15MB45692F6C45326995B1D1DFCFD5839@SA1PR15MB4569.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gtanT/cEFTE/UcN7BQ0WrRFeAZeYdZ3yHnBHqPoRYMzW8JRNA01qwZbN+BHn0atYY154IEU2p9At5YYqk4j5+Sk61GKnZ/bMdqA9h6POP9kh0ZiYoDGo9hU/Zb7LU3lBoZZEqqv25BZB1H8wSTHBlRX8SXTZkHRiSZIOnvi09uePK4gGyBPuLsoPBfe31kawPJMC2LDXA+6v6X6eTH/P34BaBN4HfxPIs/quhy8XDoQvDpAEL8fY7PDmdAeY5A0n4Bx5D7TFqCmzphpCmFb0efap+OXGE8byjcABnSEoLVXX9ewFPB/M0h5vtYKR6TAUmsf1iJuWqSkrBh7a0DOr9sOvkeFSR/SgRVezF2uI/BnTwDcXQsZWrtAHyGVNyF9dMvnCOByCuZzKtzRmfNLJYX5r3vuZT9t9MOy5Z7amY0Jt+D0mMTqOtpLCapvNymPP4h4NsF8VA55bt0elodC6fkFMOgY5hJ2iD2VQpu+JFcgVxgqgrSICKLj4DIZ35OLuMGYqqzsILPmIkofi4zyCqHnuoc+ijXMQ39IOd0xM+lZsJO48u9ZJ/SN2pt/7Wr3pNoZBrs+YQnk3y5TQvX7QmYfosS1A2RufhFpHi4VJDFvqxGJfwknO6C/FBP5WlzsSXp/0xL0rCd2h4e7yIAmcEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(86362001)(66476007)(66946007)(9686003)(7696005)(4326008)(83380400001)(1076003)(508600001)(8676002)(8936002)(52116002)(55016002)(5660300002)(6506007)(186003)(53546011)(6666004)(54906003)(2906002)(38100700002)(110136005)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uvDPKMsjq0rBjshpCf5H6QdcT2GGDrk3KRjXKQBsr2alimqHgr1+ubex50ks?=
 =?us-ascii?Q?5OntjaqTH74pqpjX5v/Y1+gj7z7M04cBUWfSw60UxqTBHyZzFjrPmRsm/VL+?=
 =?us-ascii?Q?nGZME47WTIuhktsTqOvmcEtwFsFikaU1ZZ4Kup/m3xNYbR6cxiGcZATgX3kD?=
 =?us-ascii?Q?ec3x0nIE6Mpud+M6plSM/Db7ix3sFqw9rLlC+lcHvZarB7aU5kfElysvwqAH?=
 =?us-ascii?Q?yTJu8pQtAy4d2coWAg/32Jxj2+oShtqKD3WynK4N8WbIkcQt8YIx8S7tS3/G?=
 =?us-ascii?Q?yuVsnSQtPvV1+12UffsQ5H/cE4RFR5n5sdEvYIC4tA3w3Mp3hKKtwmYyScPB?=
 =?us-ascii?Q?bZAfnjG8unfpOtXmlbA7vB+GtetG08F/ZEo86VcP8EDm8X6rkHupIWQtvOmr?=
 =?us-ascii?Q?+hLfCK98oUcOnpX/575Hi7pGztwDGVb/ri6rd6PVXZ6cZUPJPbea2YccrJ/G?=
 =?us-ascii?Q?FIllkCjS2u8H4J2UlQglrIwA94bxhs9LWFTdEdg1ymxpEFhVUGqoSU/6kQWB?=
 =?us-ascii?Q?rF8ZZIQTRGG7W6sqmnlGIQPks+uEEbSwlAlpazZFKoLPzs+NypDBrzsfzPMr?=
 =?us-ascii?Q?LAWNdMvZ5+anAysIH3Qy1qDjil6yK5CPPNRYALypeglB+gA+2crTYCxMzz33?=
 =?us-ascii?Q?zhZNuHdB97/+ECzwto+AbM50B3q96IFE5rhmytdH989IxVu1WiigNAjkcTRf?=
 =?us-ascii?Q?qW+DJ+iceZxRxLLFVOlO8xSxWZQQWbebna/LPTGuXLwlBJY0af3+OQP/OnFN?=
 =?us-ascii?Q?ZkL1zr3ZK15gtDKTdNxJlzLAmWTTHzFlbm/IKGt5SvhnhVOsag86GqbgGQCn?=
 =?us-ascii?Q?s9LPjtjehKpVtshjKiEVue8/E36J2VhV40pRFzbgXLQEwdMePsdCwVMWi1lW?=
 =?us-ascii?Q?zvNgmzVKNI99dp9vnze8g3AOEimHGxO66sWlRHPzBcjBjM2kawI8n8KXf4v4?=
 =?us-ascii?Q?jmZ06Hd2XG2ZPCtS4kxf8YBJuTTN4u220E7kHEbeM47HRS78z6IniRv/5IUi?=
 =?us-ascii?Q?uGoytXCriBcS/Ew0axCPiphZSvqPXdaz6U2P7O+alpf3+s25dUWbVNlQmpF3?=
 =?us-ascii?Q?9rb3jTXrm9f2uCris8RhlVrTFcf4yLZ8wDXfhJv2cYTvdEq1kR8NnXdUhCUE?=
 =?us-ascii?Q?ZTO+cwqTXbbixPTP6rATZIwwpUv7znRd0WW6zY36nhaPNV6R/YX2ccDVuu2w?=
 =?us-ascii?Q?Ok+IyFgW60z1m/jz34XTqU8FceA3OtHrOwpK790Y/gnqIuc92qASB8haw3il?=
 =?us-ascii?Q?l8SaGIplytYeF8+jfptCwPGU9Ll1ddddNC1hbPe7dhAFzMSC1Ns04a3uUCQG?=
 =?us-ascii?Q?m2jpT74OBh79WL3DHdgiLVLk8UTg1Vuef84wf4AbgdVohRkok6h6+uF8dwLP?=
 =?us-ascii?Q?n/TG6NtQDQvKEOgpXPw6QHmh4axanqGK2T21y4Vallp0SpCVxVEzbt6PA23G?=
 =?us-ascii?Q?ZDJ+i3q2aRz46ihezXkD0kzGcdaUc903bV8w/2c60NO564btbAMnTafEHZWt?=
 =?us-ascii?Q?x+uuFuf710mlV4pQEB1RWCdKr5ygYAWKIoOatvDUJ5WIAVP9jd9U8I1sluIp?=
 =?us-ascii?Q?LHNYjbMo0BF1nkNaQi3cg79LPo0490wSIcigWf30?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6b30a3d-aae3-4715-706b-08d9980220ec
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 21:55:16.2614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kHH4AXWHEiW6syeaJV8PmW9mrwTvirlZ4iL4nYBxsUvcUHrZCHcg9LIldRcC/8hQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4569
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: nw5A1tG0bxZMkTX25rq-YJhV7WqX_Z8Z
X-Proofpoint-ORIG-GUID: nw5A1tG0bxZMkTX25rq-YJhV7WqX_Z8Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_07,2021-10-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1011 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110250124
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 01:48:12PM -0700, Eric Dumazet wrote:
> 
> 
> On 10/25/21 12:26 PM, Alexander Azimov wrote:
> > Hi Eric,
> >  
> > Can you please clarify why do you think that SYN RTO should be accessible through BPF and SYN ACK RTO should be bound to TCP_TIMEOUT_INIT constant?

> > I can't see the reason for such asymmetry, please advise.
In tcp_conn_request(),  tcp_timeout_init() is used, so the very
first SYN-ACK RTO should work?

iiuc, this patch's changes in reqsk_timer_handler() only affects the
later RTOs (e.g. 2nd RTOs).  For this particular
function (reqsk_timer_handler()), it looks like an overlook
in the original bpf's tcp_timeout_init() implementation.

> > I also wonder what kind of existing BPF programs can suffer from these changes. Please give us your insights.
> > 
> > ps: this is a copy of the original message, hope this one will come in a plain text
> > 
> 
> When commit 8550f328f45db6d37981eb2041bc465810245c03
> ("bpf: Support for per connection SYN/SYN-ACK RTOs")
> was added, tcp_timeout_init() (and potential eBPF prog)
> would be called from tcp_conn_request() and tcp_connect_init()
> 
> So some users are now using this eBPF program, expecting
> it to have an effect only from these call sites.
> 
> If you are adding more call sites, suddenly the behavior
> of TCP stack for these users will change. You have to
> document if bad things could happen for them, like unexpected
> max acceptable delays for connection establishment being severely reduced.
> 
> In any case, I would prefer adding a new @timeout field
> in struct request_sock to carry the base timeout
> instead of calling a BPF program all the times,
> otherwise we could have weird behavior (eg PAWS checks)
> if the return from eBPF program is variable for one 5-tuple.
Seems like a good idea.  This field can be set to
the timeout-value returned by the bpf prog.
